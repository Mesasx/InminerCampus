begin;

-- Every new account now enters a human-review queue. Email confirmation proves
-- control of an inbox; it must never activate access to training content.
alter table public.profiles
  add column if not exists company_name text,
  add column if not exists job_title text,
  add column if not exists relationship_type text,
  add column if not exists access_reason text,
  add column if not exists reviewed_at timestamptz,
  add column if not exists reviewed_by uuid references auth.users(id) on delete set null;

alter table public.profiles
  drop constraint if exists profiles_company_name_length,
  add constraint profiles_company_name_length
    check (company_name is null or char_length(company_name) <= 200),
  drop constraint if exists profiles_job_title_length,
  add constraint profiles_job_title_length
    check (job_title is null or char_length(job_title) <= 160),
  drop constraint if exists profiles_relationship_type_value,
  add constraint profiles_relationship_type_value check (
    relationship_type is null
    or relationship_type in (
      'inminer_team',
      'client_company',
      'collaborator',
      'invited_person',
      'other'
    )
  ),
  drop constraint if exists profiles_access_reason_length,
  add constraint profiles_access_reason_length
    check (access_reason is null or char_length(access_reason) <= 1200);

create or replace function app_private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (
    id,
    email,
    first_name,
    last_name,
    phone,
    dni,
    company_name,
    job_title,
    relationship_type,
    access_reason,
    status
  )
  values (
    new.id,
    lower(new.email),
    coalesce(new.raw_user_meta_data ->> 'first_name', ''),
    coalesce(new.raw_user_meta_data ->> 'last_name', ''),
    nullif(btrim(coalesce(new.raw_user_meta_data ->> 'phone', '')), ''),
    nullif(upper(btrim(coalesce(new.raw_user_meta_data ->> 'dni', ''))), ''),
    nullif(btrim(coalesce(new.raw_user_meta_data ->> 'company_name', '')), ''),
    nullif(btrim(coalesce(new.raw_user_meta_data ->> 'job_title', '')), ''),
    nullif(btrim(coalesce(new.raw_user_meta_data ->> 'relationship_type', '')), ''),
    nullif(btrim(coalesce(new.raw_user_meta_data ->> 'access_reason', '')), ''),
    'pending'::public.account_status
  )
  on conflict (id) do update
  set email = excluded.email;

  insert into public.user_roles (user_id, role, source)
  values (new.id, 'alumno'::public.app_role, 'registration')
  on conflict (user_id, role) do nothing;

  return new;
end;
$$;

create or replace function app_private.current_user_is_approved()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select auth.uid()) is not null
    and exists (
      select 1
      from public.profiles p
      where p.id = (select auth.uid())
        and p.status = 'active'::public.account_status
    );
$$;

revoke all on function app_private.current_user_is_approved()
  from public, anon;
grant execute on function app_private.current_user_is_approved()
  to authenticated;

-- Centralise the approval requirement in the helpers already used by content,
-- progress and private Storage policies.
create or replace function app_private.current_user_is_enrolled(
  target_course_version_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select app_private.current_user_is_approved())
    and exists (
      select 1
      from public.enrollments e
      where e.user_id = (select auth.uid())
        and e.course_version_id = target_course_version_id
        and e.status not in (
          'failed'::public.enrollment_status,
          'expired'::public.enrollment_status
        )
    );
$$;

create or replace function app_private.current_user_owns_enrollment(
  target_enrollment_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select app_private.current_user_is_approved())
    and exists (
      select 1
      from public.enrollments e
      where e.id = target_enrollment_id
        and e.user_id = (select auth.uid())
    );
$$;

-- Keep the existing RPC contract used by the admin panel, but make every
-- decision traceable to the administrator and timestamp that reviewed it.
create or replace function public.admin_update_profile_status(
  p_profile_id uuid,
  p_status public.account_status
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not (select app_private.current_user_is_approved())
     or not (select app_private.current_user_has_role(
       array['administrador', 'superadministrador']::public.app_role[]
     )) then
    raise exception 'Administrator access required';
  end if;

  update public.profiles
  set
    status = p_status,
    reviewed_at = now(),
    reviewed_by = (select auth.uid())
  where id = p_profile_id;

  if not found then
    raise exception 'Profile not found';
  end if;

  insert into public.audit_logs (
    actor_user_id,
    action,
    entity_type,
    entity_id,
    payload
  )
  values (
    (select auth.uid()),
    'profile_status_reviewed',
    'profile',
    p_profile_id::text,
    jsonb_build_object('status', p_status::text)
  );
end;
$$;

revoke all on function public.admin_update_profile_status(
  uuid,
  public.account_status
) from public, anon;
grant execute on function public.admin_update_profile_status(
  uuid,
  public.account_status
) to authenticated;

-- Public visitors may see only the course introduction. Internal structure,
-- lesson titles and learning resources require both approval and an enrolment.
drop policy if exists course_versions_visible on public.course_versions;
drop policy if exists course_versions_public_published on public.course_versions;
create policy course_versions_public_published
on public.course_versions for select
to anon
using (
  status = 'published'
  and exists (
    select 1
    from public.courses c
    where c.id = course_id
      and c.status = 'published'
      and c.listed
  )
);

drop policy if exists course_modules_visible on public.course_modules;
drop policy if exists lessons_visible on public.lessons;

drop policy if exists lessons_enrolled_or_staff on public.lessons;
create policy lessons_enrolled_or_staff
on public.lessons for select
to authenticated
using (
  exists (
    select 1
    from public.course_modules cm
    where cm.id = module_id
      and (
        (select app_private.current_user_is_enrolled(cm.course_version_id))
        or (select app_private.current_user_has_role(
          array['tutor', 'administrador', 'superadministrador']::public.app_role[]
        ))
      )
  )
);

revoke select on public.course_modules, public.lessons from anon;

-- Pricing and delivery-mode fields are retained only for trusted historical
-- administration. They are no longer readable with the public API key.
revoke select on public.course_versions from anon;
grant select (
  id,
  course_id,
  version_number,
  duration_hours,
  status,
  objectives,
  target_audience,
  requirements,
  syllabus_summary,
  practice_required,
  accreditation_reference,
  renewal_interval_months,
  published_at,
  created_at,
  updated_at
) on public.course_versions to anon;

-- Restrictive policies are combined with the existing ownership/enrolment
-- policies. A valid session is therefore insufficient while the profile is
-- pending, suspended or archived.
do $policies$
declare
  table_name text;
begin
  foreach table_name in array array[
    'course_versions',
    'course_modules',
    'lessons',
    'lesson_resources',
    'enrollments',
    'lesson_progress',
    'video_events',
    'quizzes',
    'quiz_attempts',
    'quiz_attempt_answers',
    'lesson_audio_segments',
    'lesson_segment_slides',
    'lesson_audio_progress'
  ]
  loop
    if to_regclass('public.' || table_name) is not null then
      execute format(
        'drop policy if exists approved_account_gate on public.%I',
        table_name
      );
      execute format(
        'create policy approved_account_gate on public.%I as restrictive for all to authenticated using ((select app_private.current_user_is_approved())) with check ((select app_private.current_user_is_approved()))',
        table_name
      );
    end if;
  end loop;
end;
$policies$;

-- SECURITY DEFINER learning RPCs bypass RLS. This trigger provides the same
-- account-state check for their writes, while keeping service-role operations
-- (whose auth.uid() is null) available to trusted back-office jobs.
create or replace function app_private.require_approved_learning_write()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is not null
     and not (select app_private.current_user_is_approved()) then
    raise exception using
      errcode = '42501',
      message = 'La cuenta necesita aprobación administrativa.';
  end if;
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

revoke all on function app_private.require_approved_learning_write()
  from public, anon, authenticated;

do $triggers$
declare
  table_name text;
begin
  foreach table_name in array array[
    'enrollments',
    'lesson_progress',
    'video_events',
    'quiz_attempts',
    'quiz_attempt_answers',
    'quiz_attempt_questions',
    'lesson_audio_progress',
    'learning_activity_events'
  ]
  loop
    if to_regclass('public.' || table_name) is not null then
      execute format(
        'drop trigger if exists require_approved_learning_write on public.%I',
        table_name
      );
      execute format(
        'create trigger require_approved_learning_write before insert or update or delete on public.%I for each row execute function app_private.require_approved_learning_write()',
        table_name
      );
    end if;
  end loop;
end;
$triggers$;

commit;
