-- InmínerCampus
-- 1. "Operador de maquinaria de transporte: camión y volquete" es 100% online.
--    Como el resto del catálogo, heredó modality='hybrid' del valor por defecto
--    de course_versions y con él practice_required=true, así que las matrículas
--    se quedaban en 'practice_pending' al acabar la teoría.
-- 2. El DNI pasa a recogerse en el alta. Sin él, el aviso interno de
--    finalización a administración no se puede emitir (el servicio lo exige y
--    reintenta en bucle), y el certificado tampoco puede identificar al alumno.

update public.course_versions
set
  modality = 'online'::public.course_modality,
  practice_required = false
where course_id = '362231f3-3900-4b23-a59c-4afc0830134d';

-- Desatasca solo a quien ya tiene DNI: completar una matrícula encola el aviso
-- interno, y ese aviso falla de forma reintentable si falta el DNI del alumno.
-- Los que no lo tengan se completarán solos en cuanto lo rellenen.
update public.enrollments e
set
  status = 'completed'::public.enrollment_status,
  completed_at = coalesce(e.completed_at, e.theory_completed_at, now())
from public.course_versions cv, public.profiles p
where cv.id = e.course_version_id
  and p.id = e.user_id
  and cv.course_id = '362231f3-3900-4b23-a59c-4afc0830134d'
  and e.status in (
    'practice_pending'::public.enrollment_status,
    'practice_completed'::public.enrollment_status,
    'validation_pending'::public.enrollment_status
  )
  and e.theory_completed_at is not null
  and btrim(coalesce(p.dni, '')) <> '';

-- El alta guardaba nombre y apellidos pero descartaba el DNI, así que ningún
-- alumno registrado desde la web llegaba a tenerlo.
create or replace function app_private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, first_name, last_name, dni, status)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'first_name', ''),
    coalesce(new.raw_user_meta_data ->> 'last_name', ''),
    nullif(upper(btrim(coalesce(new.raw_user_meta_data ->> 'dni', ''))), ''),
    case when new.email_confirmed_at is null then 'pending' else 'active' end
  )
  on conflict (id) do nothing;

  insert into public.user_roles (user_id, role, source)
  values (new.id, 'alumno', 'registration')
  on conflict (user_id, role) do nothing;

  return new;
end;
$$;

do $val$
declare
  hibridas integer;
begin
  select count(*) into hibridas
  from public.course_versions
  where course_id = '362231f3-3900-4b23-a59c-4afc0830134d'
    and (modality <> 'online'::public.course_modality or practice_required);

  if hibridas > 0 then
    raise exception 'Quedan % versiones de camión y volquete sin pasar a online', hibridas;
  end if;
end;
$val$;
