begin;

alter table public.profiles
  add column if not exists email text;

update public.profiles p
set email = lower(u.email)
from auth.users u
where u.id = p.id
  and u.email is not null
  and p.email is distinct from lower(u.email);

create unique index if not exists profiles_email_unique_idx
  on public.profiles (lower(email))
  where email is not null;

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
    status
  )
  values (
    new.id,
    lower(new.email),
    coalesce(new.raw_user_meta_data ->> 'first_name', ''),
    coalesce(new.raw_user_meta_data ->> 'last_name', ''),
    case
      when new.email_confirmed_at is null then 'pending'::public.account_status
      else 'active'::public.account_status
    end
  )
  on conflict (id) do update
  set email = excluded.email;

  insert into public.user_roles (user_id, role, source)
  values (new.id, 'alumno'::public.app_role, 'registration')
  on conflict (user_id, role) do nothing;

  return new;
end;
$$;

create or replace function app_private.sync_profile_email()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.profiles
  set email = lower(new.email)
  where id = new.id;
  return new;
end;
$$;

drop trigger if exists auth_users_sync_profile_email on auth.users;
create trigger auth_users_sync_profile_email
after update of email on auth.users
for each row execute function app_private.sync_profile_email();

revoke all on function app_private.sync_profile_email()
  from public, anon, authenticated;

drop policy if exists profiles_update_admin on public.profiles;
create policy profiles_update_admin
on public.profiles for update
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

revoke update (status) on public.profiles from authenticated;

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
  if not (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  )) then
    raise exception 'Administrator access required';
  end if;

  update public.profiles
  set status = p_status
  where id = p_profile_id;
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

create table if not exists public.lesson_audio_segments (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  position smallint not null,
  title text not null,
  narration_text text not null default '',
  audio_storage_path text,
  audio_external_url text,
  duration_seconds integer not null default 120,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (lesson_id, position),
  constraint lesson_audio_segments_position check (position between 1 and 5),
  constraint lesson_audio_segments_title_length check (
    char_length(title) between 1 and 240
  ),
  constraint lesson_audio_segments_duration check (
    duration_seconds between 1 and 1800
  ),
  constraint lesson_audio_segments_single_source check (
    not (
      audio_storage_path is not null
      and audio_external_url is not null
    )
  ),
  constraint lesson_audio_segments_publishable check (
    not published
    or audio_storage_path is not null
    or audio_external_url is not null
  )
);

create index if not exists lesson_audio_segments_lesson_idx
  on public.lesson_audio_segments (lesson_id, position);

create table if not exists public.lesson_segment_slides (
  id uuid primary key default gen_random_uuid(),
  segment_id uuid not null
    references public.lesson_audio_segments(id) on delete cascade,
  position smallint not null,
  title text not null,
  body text not null default '',
  image_storage_path text,
  image_external_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (segment_id, position),
  constraint lesson_segment_slides_position check (position between 1 and 50),
  constraint lesson_segment_slides_title_length check (
    char_length(title) between 1 and 240
  ),
  constraint lesson_segment_slides_single_source check (
    not (
      image_storage_path is not null
      and image_external_url is not null
    )
  )
);

create index if not exists lesson_segment_slides_segment_idx
  on public.lesson_segment_slides (segment_id, position);

create table if not exists public.lesson_audio_progress (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null
    references public.enrollments(id) on delete cascade,
  segment_id uuid not null
    references public.lesson_audio_segments(id) on delete cascade,
  max_position_seconds integer not null default 0,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (enrollment_id, segment_id),
  constraint lesson_audio_progress_position check (
    max_position_seconds >= 0
  )
);

create index if not exists lesson_audio_progress_enrollment_idx
  on public.lesson_audio_progress (enrollment_id, completed_at, segment_id);

drop trigger if exists lesson_audio_segments_set_updated_at
  on public.lesson_audio_segments;
create trigger lesson_audio_segments_set_updated_at
before update on public.lesson_audio_segments
for each row execute function app_private.set_updated_at();

drop trigger if exists lesson_segment_slides_set_updated_at
  on public.lesson_segment_slides;
create trigger lesson_segment_slides_set_updated_at
before update on public.lesson_segment_slides
for each row execute function app_private.set_updated_at();

drop trigger if exists lesson_audio_progress_set_updated_at
  on public.lesson_audio_progress;
create trigger lesson_audio_progress_set_updated_at
before update on public.lesson_audio_progress
for each row execute function app_private.set_updated_at();

alter table public.lesson_audio_segments enable row level security;
alter table public.lesson_segment_slides enable row level security;
alter table public.lesson_audio_progress enable row level security;

drop policy if exists lesson_audio_segments_visible
  on public.lesson_audio_segments;
create policy lesson_audio_segments_visible
on public.lesson_audio_segments for select
to authenticated
using (
  (
    published
    and exists (
      select 1
      from public.lessons l
      join public.course_modules m on m.id = l.module_id
      where l.id = lesson_id
        and (select app_private.current_user_is_enrolled(m.course_version_id))
    )
  )
  or (select app_private.current_user_has_role(
    array[
      'tutor',
      'administrador',
      'superadministrador'
    ]::public.app_role[]
  ))
);

drop policy if exists lesson_audio_segments_admin_manage
  on public.lesson_audio_segments;
create policy lesson_audio_segments_admin_manage
on public.lesson_audio_segments for all
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists lesson_segment_slides_visible
  on public.lesson_segment_slides;
create policy lesson_segment_slides_visible
on public.lesson_segment_slides for select
to authenticated
using (
  exists (
    select 1
    from public.lesson_audio_segments s
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    where s.id = segment_id
      and (
        (
          s.published
          and (select app_private.current_user_is_enrolled(
            m.course_version_id
          ))
        )
        or (select app_private.current_user_has_role(
          array[
            'tutor',
            'administrador',
            'superadministrador'
          ]::public.app_role[]
        ))
      )
  )
);

drop policy if exists lesson_segment_slides_admin_manage
  on public.lesson_segment_slides;
create policy lesson_segment_slides_admin_manage
on public.lesson_segment_slides for all
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists lesson_audio_progress_visible
  on public.lesson_audio_progress;
create policy lesson_audio_progress_visible
on public.lesson_audio_progress for select
to authenticated
using (
  exists (
    select 1
    from public.enrollments e
    where e.id = enrollment_id
      and e.user_id = (select auth.uid())
  )
  or (select app_private.current_user_has_role(
    array[
      'tutor',
      'administrador',
      'superadministrador'
    ]::public.app_role[]
  ))
);

revoke all on public.lesson_audio_segments,
  public.lesson_segment_slides,
  public.lesson_audio_progress
from anon, authenticated;

grant select, insert, update, delete
  on public.lesson_audio_segments, public.lesson_segment_slides
  to authenticated;
grant select on public.lesson_audio_progress to authenticated;

create or replace function public.record_audio_segment_progress(
  p_enrollment_id uuid,
  p_segment_id uuid,
  p_position_seconds integer,
  p_completed boolean default false
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  v_lesson_id uuid;
  v_course_version_id uuid;
  v_segment_position smallint;
  v_duration_seconds integer;
  v_old_max integer := 0;
  v_new_max integer := 0;
  v_updated_at timestamptz := now();
  v_completed_at timestamptz;
  v_allowed_max integer;
  v_lesson_complete boolean := false;
  v_has_quiz boolean := false;
  v_completed_lessons integer := 0;
  v_total_lessons integer := 0;
  v_next_lesson_id uuid;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  if p_position_seconds < 0 then
    raise exception 'Invalid audio position';
  end if;

  select
    s.lesson_id,
    m.course_version_id,
    s.position,
    s.duration_seconds
  into
    v_lesson_id,
    v_course_version_id,
    v_segment_position,
    v_duration_seconds
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
    and lp.status <> 'locked';

  if not found then
    raise exception 'Audio segment is not available';
  end if;

  if exists (
    select 1
    from public.lesson_audio_segments previous_segment
    where previous_segment.lesson_id = v_lesson_id
      and previous_segment.published = true
      and previous_segment.position < v_segment_position
      and not exists (
        select 1
        from public.lesson_audio_progress previous_progress
        where previous_progress.enrollment_id = p_enrollment_id
          and previous_progress.segment_id = previous_segment.id
          and previous_progress.completed_at is not null
      )
  ) then
    raise exception 'Previous audio segments must be completed first';
  end if;

  insert into public.lesson_audio_progress (
    enrollment_id,
    segment_id,
    max_position_seconds
  )
  values (
    p_enrollment_id,
    p_segment_id,
    least(p_position_seconds, 5)
  )
  on conflict (enrollment_id, segment_id) do nothing;

  select
    max_position_seconds,
    updated_at,
    completed_at
  into
    v_old_max,
    v_updated_at,
    v_completed_at
  from public.lesson_audio_progress
  where enrollment_id = p_enrollment_id
    and segment_id = p_segment_id
  for update;

  if v_completed_at is not null then
    return jsonb_build_object(
      'maxPositionSeconds', v_old_max,
      'completed', true
    );
  end if;

  v_allowed_max := v_old_max + least(
    floor(extract(epoch from (now() - v_updated_at)))::integer + 2,
    20
  );

  if p_position_seconds > v_allowed_max then
    raise exception 'Forward seeking is not allowed';
  end if;

  v_new_max := least(
    v_duration_seconds,
    greatest(v_old_max, p_position_seconds)
  );

  if p_completed
    and v_new_max >= greatest(v_duration_seconds - 2, 0) then
    v_completed_at := now();
  end if;

  update public.lesson_audio_progress
  set
    max_position_seconds = v_new_max,
    completed_at = v_completed_at
  where enrollment_id = p_enrollment_id
    and segment_id = p_segment_id;

  update public.lesson_progress
  set
    status = case
      when status = 'available' then 'in_progress'::public.lesson_progress_status
      else status
    end,
    first_started_at = coalesce(first_started_at, now()),
    last_activity_at = now()
  where enrollment_id = p_enrollment_id
    and lesson_id = v_lesson_id;

  select not exists (
    select 1
    from public.lesson_audio_segments required_segment
    where required_segment.lesson_id = v_lesson_id
      and required_segment.published = true
      and not exists (
        select 1
        from public.lesson_audio_progress completed_progress
        where completed_progress.enrollment_id = p_enrollment_id
          and completed_progress.segment_id = required_segment.id
          and completed_progress.completed_at is not null
      )
  )
  and exists (
    select 1
    from public.lesson_audio_segments published_segment
    where published_segment.lesson_id = v_lesson_id
      and published_segment.published = true
  )
  into v_lesson_complete;

  if v_lesson_complete then
    select exists (
      select 1
      from public.quizzes q
      where q.lesson_id = v_lesson_id
        and q.active = true
    )
    into v_has_quiz;

    if v_has_quiz then
      update public.lesson_progress
      set
        status = 'in_progress',
        last_activity_at = now()
      where enrollment_id = p_enrollment_id
        and lesson_id = v_lesson_id;
    else
      update public.lesson_progress
      set
        status = 'completed',
        completed_at = coalesce(completed_at, now()),
        last_activity_at = now()
      where enrollment_id = p_enrollment_id
        and lesson_id = v_lesson_id;

      select next_lesson.id
      into v_next_lesson_id
      from public.lessons current_lesson
      join public.course_modules current_module
        on current_module.id = current_lesson.module_id
      join public.course_modules next_module
        on next_module.course_version_id = current_module.course_version_id
      join public.lessons next_lesson
        on next_lesson.module_id = next_module.id
      where current_lesson.id = v_lesson_id
        and next_lesson.active = true
        and (
          next_module.position,
          next_lesson.position
        ) > (
          current_module.position,
          current_lesson.position
        )
      order by next_module.position, next_lesson.position
      limit 1;

      if v_next_lesson_id is not null then
        update public.lesson_progress
        set status = 'available'
        where enrollment_id = p_enrollment_id
          and lesson_id = v_next_lesson_id
          and status = 'locked';
      end if;
    end if;
  end if;

  select
    count(*) filter (where lp.status = 'completed'),
    count(*)
  into v_completed_lessons, v_total_lessons
  from public.lesson_progress lp
  where lp.enrollment_id = p_enrollment_id;

  update public.enrollments
  set
    progress_percent = case
      when v_total_lessons = 0 then 0
      else round(
        (v_completed_lessons::numeric / v_total_lessons::numeric) * 100,
        2
      )
    end,
    status = case
      when status = 'not_started' then 'in_progress'::public.enrollment_status
      else status
    end,
    started_at = coalesce(started_at, now())
  where id = p_enrollment_id;

  return jsonb_build_object(
    'maxPositionSeconds', v_new_max,
    'completed', v_completed_at is not null,
    'lessonAudioCompleted', v_lesson_complete
  );
end;
$$;

revoke all on function public.record_audio_segment_progress(
  uuid,
  uuid,
  integer,
  boolean
) from public, anon;
grant execute on function public.record_audio_segment_progress(
  uuid,
  uuid,
  integer,
  boolean
) to authenticated;

create or replace function app_private.sync_practice_validation()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.result = 'passed'::public.practice_result then
    update public.enrollments
    set status = 'practice_completed'::public.enrollment_status
    where id = new.enrollment_id;
  elsif new.result = 'failed'::public.practice_result then
    update public.enrollments
    set status = 'practice_pending'::public.enrollment_status
    where id = new.enrollment_id
      and status <> 'completed'::public.enrollment_status;
  end if;

  return new;
end;
$$;

drop trigger if exists practice_attendance_sync_enrollment
  on public.practice_attendance;
create trigger practice_attendance_sync_enrollment
after insert or update of result on public.practice_attendance
for each row execute function app_private.sync_practice_validation();

revoke all on function app_private.sync_practice_validation()
  from public, anon, authenticated;

commit;
