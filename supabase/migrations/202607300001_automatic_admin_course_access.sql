begin;

create or replace function app_private.grant_published_courses_to_admin()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.role not in (
    'administrador'::public.app_role,
    'superadministrador'::public.app_role
  ) then
    return new;
  end if;

  insert into public.enrollments (
    user_id,
    course_version_id,
    source_type,
    source_reference,
    status,
    created_by
  )
  select
    new.user_id,
    cv.id,
    'administrative_access',
    'automatic_admin_access',
    'not_started'::public.enrollment_status,
    new.user_id
  from public.course_versions cv
  join public.courses c on c.id = cv.course_id
  where c.status = 'published'
    and cv.status = 'published'
  on conflict (user_id, course_version_id) do nothing;

  return new;
end;
$$;

create or replace function app_private.grant_published_version_to_admins()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status <> 'published'::public.course_version_status then
    return new;
  end if;

  if tg_op = 'UPDATE'
    and old.status = 'published'::public.course_version_status then
    return new;
  end if;

  insert into public.enrollments (
    user_id,
    course_version_id,
    source_type,
    source_reference,
    status,
    created_by
  )
  select
    ur.user_id,
    new.id,
    'administrative_access',
    'automatic_admin_access',
    'not_started'::public.enrollment_status,
    ur.user_id
  from public.user_roles ur
  where ur.role in (
    'administrador'::public.app_role,
    'superadministrador'::public.app_role
  )
  on conflict (user_id, course_version_id) do nothing;

  return new;
end;
$$;

revoke all on function app_private.grant_published_courses_to_admin()
  from public, anon, authenticated;
revoke all on function app_private.grant_published_version_to_admins()
  from public, anon, authenticated;

drop trigger if exists user_roles_grant_admin_course_access
  on public.user_roles;
create trigger user_roles_grant_admin_course_access
after insert or update of role on public.user_roles
for each row execute function app_private.grant_published_courses_to_admin();

drop trigger if exists course_versions_grant_admin_access
  on public.course_versions;
create trigger course_versions_grant_admin_access
after insert or update of status on public.course_versions
for each row execute function app_private.grant_published_version_to_admins();

insert into public.enrollments (
  user_id,
  course_version_id,
  source_type,
  source_reference,
  status,
  created_by
)
select
  ur.user_id,
  cv.id,
  'administrative_access',
  'automatic_admin_access',
  'not_started'::public.enrollment_status,
  ur.user_id
from public.user_roles ur
cross join public.course_versions cv
join public.courses c on c.id = cv.course_id
where ur.role in (
    'administrador'::public.app_role,
    'superadministrador'::public.app_role
  )
  and c.status = 'published'
  and cv.status = 'published'
on conflict (user_id, course_version_id) do nothing;

commit;
