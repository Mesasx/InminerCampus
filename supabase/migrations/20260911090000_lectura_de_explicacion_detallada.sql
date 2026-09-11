-- Registro de la lectura de la explicación detallada.
--
-- Hasta ahora una unidad se daba por recorrida cuando terminaba su locución.
-- A partir de esta actualización el alumno debe además haber recorrido la
-- explicación detallada hasta el final para poder pasar a la diapositiva
-- siguiente.
--
-- El avance se guarda donde ya vive el resto del progreso de la unidad, en
-- `lesson_audio_progress`, con una columna nueva y opcional. No se crea ninguna
-- tabla paralela, no se borra nada y no se toca la lógica de finalización de
-- lección ni de certificación: `record_audio_segment_progress` sigue siendo
-- quien completa la lección y desbloquea la siguiente, exactamente igual que
-- antes.
--
-- Compatibilidad con quien ya ha avanzado: toda unidad que hoy esté escuchada
-- se marca también como leída. Nadie ve retroceder su progreso ni tiene que
-- repetir una diapositiva que ya había completado.
begin;

alter table public.lesson_audio_progress
  add column if not exists explanation_read_at timestamptz;

comment on column public.lesson_audio_progress.explanation_read_at is
  'Momento en que el alumno recorrió la explicación detallada de la unidad hasta el final. Nulo mientras no la haya recorrido.';

-- Continuidad para las matrículas en curso: lo ya escuchado cuenta como leído.
update public.lesson_audio_progress
set explanation_read_at = completed_at
where completed_at is not null
  and explanation_read_at is null;

-- `updated_at` de esta tabla no es una marca de auditoría cualquiera: es la
-- referencia temporal con la que `record_audio_segment_progress` decide cuánto
-- audio ha podido avanzar desde el último parte y rechaza los adelantos. Si la
-- marca de lectura la refrescara, la ventana permitida se encogería y una
-- reproducción legítima podría rechazarse como adelanto.
--
-- Por eso el disparador deja de refrescarla en un único caso: cuando lo único
-- que cambia es la marca de lectura. Cualquier otra escritura —incluida la del
-- progreso de audio que no llega a avanzar la posición— se comporta
-- exactamente igual que antes.
drop trigger if exists lesson_audio_progress_set_updated_at
  on public.lesson_audio_progress;

create trigger lesson_audio_progress_set_updated_at
  before update on public.lesson_audio_progress
  for each row
  when (
    old.explanation_read_at is not distinct from new.explanation_read_at
    or old.max_position_seconds is distinct from new.max_position_seconds
    or old.completed_at is distinct from new.completed_at
  )
  execute function app_private.set_updated_at();

create or replace function public.record_explanation_read(
  p_enrollment_id uuid,
  p_segment_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path to ''
as $function$
declare
  current_user_id uuid := auth.uid();
  v_read_at timestamptz;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  -- Mismas comprobaciones de acceso que el progreso de audio: la unidad debe
  -- estar publicada, pertenecer a una matrícula viva del propio usuario y
  -- corresponder a una lección que no esté bloqueada.
  if not exists (
    select 1
    from public.lesson_audio_segments s
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    join public.enrollments e
      on e.course_version_id = m.course_version_id
    join public.lesson_progress lp
      on lp.enrollment_id = e.id
     and lp.lesson_id = l.id
    where s.id = p_segment_id
      and s.published = true
      and e.id = p_enrollment_id
      and e.user_id = current_user_id
      and e.status not in ('failed', 'expired')
      and lp.status <> 'locked'
  ) then
    raise exception 'Audio segment is not available';
  end if;

  insert into public.lesson_audio_progress (
    enrollment_id,
    segment_id,
    max_position_seconds,
    explanation_read_at
  )
  values (p_enrollment_id, p_segment_id, 0, now())
  on conflict (enrollment_id, segment_id) do update
    -- Se conserva la primera lectura: volver a recorrer la explicación no
    -- reescribe la fecha original.
    set explanation_read_at = coalesce(
      lesson_audio_progress.explanation_read_at,
      excluded.explanation_read_at
    )
  returning explanation_read_at into v_read_at;

  return jsonb_build_object('explanationReadAt', v_read_at);
end;
$function$;

revoke all on function public.record_explanation_read(uuid, uuid) from public;
grant execute on function public.record_explanation_read(uuid, uuid)
  to authenticated;

commit;
