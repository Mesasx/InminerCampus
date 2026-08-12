-- Emite de forma automática el certificado nominal de Formación STVH al
-- completar la matrícula. El registro es el documento verificable; el PDF se
-- genera bajo demanda desde el campus con estos datos inmutables.

begin;

create or replace function app_private.issue_stvh_certificate()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_course_title text;
  v_duration_hours integer;
  v_modality public.course_modality;
  v_holder_name text;
  v_certificate_code text;
begin
  if new.status <> 'completed'::public.enrollment_status
    or new.completed_at is null
  then
    return new;
  end if;

  select
    c.title,
    cv.duration_hours,
    cv.modality,
    coalesce(
      nullif(btrim(concat_ws(' ', p.first_name, p.last_name)), ''),
      'Alumno/a'
    )
  into
    v_course_title,
    v_duration_hours,
    v_modality,
    v_holder_name
  from public.course_versions cv
  join public.courses c on c.id = cv.course_id
  left join public.profiles p on p.id = new.user_id
  where cv.id = new.course_version_id
    and c.slug = 'formacion-stvh';

  if not found then
    return new;
  end if;

  v_certificate_code :=
    'INM-STVH-'
    || upper(substr(replace(new.id::text, '-', ''), 1, 8))
    || '-'
    || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));

  insert into public.certificates (
    enrollment_id,
    user_id,
    course_version_id,
    certificate_code,
    holder_name,
    course_title,
    duration_hours,
    modality,
    completion_date
  )
  values (
    new.id,
    new.user_id,
    new.course_version_id,
    v_certificate_code,
    v_holder_name,
    v_course_title,
    v_duration_hours,
    v_modality,
    new.completed_at::date
  )
  on conflict (enrollment_id) do nothing;

  return new;
end;
$$;

revoke all on function app_private.issue_stvh_certificate()
  from public, anon, authenticated;

drop trigger if exists enrollments_issue_stvh_certificate
  on public.enrollments;
create trigger enrollments_issue_stvh_certificate
after insert or update of status, completed_at on public.enrollments
for each row execute function app_private.issue_stvh_certificate();

-- Recupera certificados de alumnos que ya habían terminado el curso antes de
-- instalar este automatismo.
insert into public.certificates (
  enrollment_id,
  user_id,
  course_version_id,
  certificate_code,
  holder_name,
  course_title,
  duration_hours,
  modality,
  completion_date
)
select
  e.id,
  e.user_id,
  e.course_version_id,
  'INM-STVH-'
    || upper(substr(replace(e.id::text, '-', ''), 1, 8))
    || '-'
    || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8)),
  coalesce(
    nullif(btrim(concat_ws(' ', p.first_name, p.last_name)), ''),
    'Alumno/a'
  ),
  c.title,
  cv.duration_hours,
  cv.modality,
  e.completed_at::date
from public.enrollments e
join public.course_versions cv on cv.id = e.course_version_id
join public.courses c on c.id = cv.course_id
left join public.profiles p on p.id = e.user_id
where c.slug = 'formacion-stvh'
  and e.status = 'completed'::public.enrollment_status
  and e.completed_at is not null
on conflict (enrollment_id) do nothing;

commit;
