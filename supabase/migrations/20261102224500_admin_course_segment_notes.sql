begin;

-- PostgREST puede omitir una relación anidada cuando la tabla hija tiene una
-- política de lectura dependiente de varias relaciones. El panel interno usa
-- esta función acotada a una versión para recuperar las explicaciones sin
-- ampliar su visibilidad a alumnos no matriculados.
create or replace function public.admin_course_segment_notes(
  p_course_version_id uuid
)
returns table (
  segment_id uuid,
  summary text,
  key_points text[],
  stop_criterion text,
  source_label text,
  source_pages text,
  approved boolean
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not (select app_private.current_user_has_role(
    array[
      'tutor',
      'administrador',
      'superadministrador'
    ]::public.app_role[]
  )) then
    raise exception 'Acceso administrativo requerido'
      using errcode = '42501';
  end if;

  return query
  select
    n.segment_id,
    n.summary,
    n.key_points,
    n.stop_criterion,
    n.source_label,
    n.source_pages,
    n.approved
  from public.lesson_segment_notes n
  join public.lesson_audio_segments s on s.id = n.segment_id
  join public.lessons l on l.id = s.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = p_course_version_id
  order by m.position, l.position, s.position;
end;
$$;

revoke all on function public.admin_course_segment_notes(uuid)
  from public, anon;
grant execute on function public.admin_course_segment_notes(uuid)
  to authenticated;

commit;
