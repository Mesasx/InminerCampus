begin;

do $$
begin
  create type public.course_status as enum ('draft', 'published', 'archived');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.course_version_status as enum ('draft', 'published', 'retired');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.course_modality as enum ('online', 'hybrid', 'in_person');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.lesson_kind as enum ('video', 'document', 'quiz', 'practice', 'mixed');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.resource_kind as enum ('pdf', 'presentation', 'file', 'external_link');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.enrollment_status as enum (
    'not_started',
    'in_progress',
    'theory_passed',
    'practice_pending',
    'practice_completed',
    'validation_pending',
    'completed',
    'failed',
    'expired'
  );
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.lesson_progress_status as enum ('locked', 'available', 'in_progress', 'completed');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.question_type as enum ('single_choice', 'multiple_choice');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.quiz_attempt_status as enum ('in_progress', 'submitted', 'graded', 'invalidated');
exception
  when duplicate_object then null;
end $$;

create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  slug text not null,
  title text not null,
  short_description text not null default '',
  description text not null default '',
  specialty text not null,
  status public.course_status not null default 'draft',
  cover_storage_path text,
  created_by uuid references auth.users(id) on delete set null,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint courses_slug_format check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  constraint courses_title_length check (char_length(title) between 3 and 240),
  constraint courses_specialty_length check (char_length(specialty) between 2 and 100)
);

create unique index if not exists courses_slug_unique_idx on public.courses (slug);
create index if not exists courses_status_specialty_idx on public.courses (status, specialty);

create table if not exists public.course_versions (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  version_number integer not null,
  duration_hours integer not null,
  modality public.course_modality not null default 'hybrid',
  objectives jsonb not null default '[]'::jsonb,
  target_audience jsonb not null default '[]'::jsonb,
  requirements jsonb not null default '[]'::jsonb,
  syllabus_summary text not null default '',
  accreditation_label text,
  accreditation_reference text,
  practice_required boolean not null default false,
  required_perfect_streak smallint not null default 3,
  video_completion_percent numeric(5,2) not null default 95,
  price_net numeric(12,2),
  tax_rate numeric(5,2) not null default 21,
  currency text not null default 'EUR',
  status public.course_version_status not null default 'draft',
  published_at timestamptz,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_id, version_number),
  constraint course_versions_duration check (duration_hours in (5, 20)),
  constraint course_versions_required_streak check (required_perfect_streak between 1 and 10),
  constraint course_versions_completion_percent check (video_completion_percent between 50 and 100),
  constraint course_versions_price check (price_net is null or price_net >= 0),
  constraint course_versions_tax check (tax_rate between 0 and 100),
  constraint course_versions_currency check (currency ~ '^[A-Z]{3}$'),
  constraint course_versions_objectives_array check (jsonb_typeof(objectives) = 'array'),
  constraint course_versions_audience_array check (jsonb_typeof(target_audience) = 'array'),
  constraint course_versions_requirements_array check (jsonb_typeof(requirements) = 'array'),
  constraint course_versions_publication_consistency check (
    (status <> 'published') or published_at is not null
  )
);

create index if not exists course_versions_course_status_idx
  on public.course_versions (course_id, status, version_number desc);

create table if not exists public.course_modules (
  id uuid primary key default gen_random_uuid(),
  course_version_id uuid not null references public.course_versions(id) on delete cascade,
  position integer not null,
  title text not null,
  description text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_version_id, position),
  constraint course_modules_position_positive check (position > 0),
  constraint course_modules_title_length check (char_length(title) between 1 and 240)
);

create index if not exists course_modules_version_idx
  on public.course_modules (course_version_id, position);

create table if not exists public.lessons (
  id uuid primary key default gen_random_uuid(),
  module_id uuid not null references public.course_modules(id) on delete cascade,
  position integer not null,
  title text not null,
  summary text not null default '',
  kind public.lesson_kind not null,
  duration_minutes integer not null default 0,
  sequential_required boolean not null default true,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (module_id, position),
  constraint lessons_position_positive check (position > 0),
  constraint lessons_duration_nonnegative check (duration_minutes >= 0),
  constraint lessons_title_length check (char_length(title) between 1 and 240)
);

create index if not exists lessons_module_idx on public.lessons (module_id, position);

create table if not exists public.lesson_resources (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  kind public.resource_kind not null,
  title text not null,
  storage_path text,
  external_url text,
  mime_type text,
  size_bytes bigint,
  downloadable boolean not null default false,
  required boolean not null default false,
  position integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_resources_source_required check (
    (storage_path is not null) <> (external_url is not null)
  ),
  constraint lesson_resources_size_nonnegative check (size_bytes is null or size_bytes >= 0),
  constraint lesson_resources_position_positive check (position > 0)
);

create index if not exists lesson_resources_lesson_idx
  on public.lesson_resources (lesson_id, position);

create table if not exists public.enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  course_version_id uuid not null references public.course_versions(id) on delete restrict,
  organization_id uuid references public.organizations(id) on delete set null,
  source_type text not null default 'manual',
  source_reference text,
  status public.enrollment_status not null default 'not_started',
  progress_percent numeric(5,2) not null default 0,
  registered_seconds bigint not null default 0,
  enrolled_at timestamptz not null default now(),
  started_at timestamptz,
  theory_completed_at timestamptz,
  completed_at timestamptz,
  expires_at timestamptz,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, course_version_id),
  constraint enrollments_progress_percent check (progress_percent between 0 and 100),
  constraint enrollments_registered_seconds check (registered_seconds >= 0),
  constraint enrollments_expiration_order check (expires_at is null or expires_at > enrolled_at)
);

create index if not exists enrollments_user_status_idx
  on public.enrollments (user_id, status, enrolled_at desc);
create index if not exists enrollments_version_status_idx
  on public.enrollments (course_version_id, status);
create index if not exists enrollments_org_status_idx
  on public.enrollments (organization_id, status)
  where organization_id is not null;

create table if not exists public.lesson_progress (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null references public.enrollments(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  status public.lesson_progress_status not null default 'locked',
  max_video_position_seconds integer not null default 0,
  active_watch_seconds integer not null default 0,
  video_completed_at timestamptz,
  material_opened_at timestamptz,
  first_started_at timestamptz,
  last_activity_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (enrollment_id, lesson_id),
  constraint lesson_progress_max_position check (max_video_position_seconds >= 0),
  constraint lesson_progress_active_watch check (active_watch_seconds >= 0)
);

create index if not exists lesson_progress_enrollment_status_idx
  on public.lesson_progress (enrollment_id, status);
create index if not exists lesson_progress_lesson_idx on public.lesson_progress (lesson_id);

create table if not exists public.video_events (
  id bigint generated always as identity primary key,
  enrollment_id uuid not null references public.enrollments(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  session_id uuid not null,
  event_type text not null,
  position_seconds integer not null default 0,
  active_seconds_delta integer not null default 0,
  metadata jsonb not null default '{}'::jsonb,
  occurred_at timestamptz not null default now(),
  constraint video_events_type check (
    event_type in ('start', 'play', 'pause', 'heartbeat', 'seek_blocked', 'complete', 'inactive', 'ended')
  ),
  constraint video_events_position_nonnegative check (position_seconds >= 0),
  constraint video_events_delta_range check (active_seconds_delta between 0 and 120),
  constraint video_events_metadata_object check (jsonb_typeof(metadata) = 'object')
);

create index if not exists video_events_enrollment_lesson_time_idx
  on public.video_events (enrollment_id, lesson_id, occurred_at desc);
create index if not exists video_events_session_idx
  on public.video_events (session_id, occurred_at);

create table if not exists public.question_banks (
  id uuid primary key default gen_random_uuid(),
  course_version_id uuid not null references public.course_versions(id) on delete cascade,
  title text not null,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists question_banks_version_idx
  on public.question_banks (course_version_id);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  question_bank_id uuid not null references public.question_banks(id) on delete cascade,
  prompt text not null,
  type public.question_type not null default 'single_choice',
  explanation text,
  points numeric(8,2) not null default 1,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint questions_prompt_length check (char_length(prompt) between 3 and 4000),
  constraint questions_points_positive check (points > 0)
);

create index if not exists questions_bank_active_idx
  on public.questions (question_bank_id, active);

create table if not exists public.question_options (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.questions(id) on delete cascade,
  position integer not null,
  option_text text not null,
  is_correct boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (question_id, position),
  constraint question_options_position_positive check (position > 0),
  constraint question_options_text_length check (char_length(option_text) between 1 and 2000)
);

create index if not exists question_options_question_idx
  on public.question_options (question_id, position);

create table if not exists public.quizzes (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null unique references public.lessons(id) on delete cascade,
  question_bank_id uuid not null references public.question_banks(id) on delete restrict,
  title text not null,
  question_count smallint not null,
  passing_percent numeric(5,2) not null default 100,
  required_perfect_streak smallint not null default 3,
  randomize_questions boolean not null default true,
  randomize_options boolean not null default true,
  minimum_retry_seconds integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint quizzes_question_count_positive check (question_count > 0),
  constraint quizzes_passing_percent check (passing_percent between 0 and 100),
  constraint quizzes_streak_range check (required_perfect_streak between 1 and 10),
  constraint quizzes_retry_nonnegative check (minimum_retry_seconds >= 0)
);

create index if not exists quizzes_bank_idx on public.quizzes (question_bank_id);

create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  quiz_id uuid not null references public.quizzes(id) on delete restrict,
  enrollment_id uuid not null references public.enrollments(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  attempt_number integer not null,
  status public.quiz_attempt_status not null default 'in_progress',
  score_percent numeric(5,2),
  is_perfect boolean,
  perfect_streak_after smallint not null default 0,
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  graded_at timestamptz,
  invalidated_at timestamptz,
  invalidation_reason text,
  created_at timestamptz not null default now(),
  unique (quiz_id, enrollment_id, attempt_number),
  constraint quiz_attempts_attempt_positive check (attempt_number > 0),
  constraint quiz_attempts_score check (score_percent is null or score_percent between 0 and 100),
  constraint quiz_attempts_streak_nonnegative check (perfect_streak_after >= 0)
);

create index if not exists quiz_attempts_enrollment_quiz_idx
  on public.quiz_attempts (enrollment_id, quiz_id, attempt_number desc);
create index if not exists quiz_attempts_user_started_idx
  on public.quiz_attempts (user_id, started_at desc);

create table if not exists public.quiz_attempt_answers (
  id uuid primary key default gen_random_uuid(),
  quiz_attempt_id uuid not null references public.quiz_attempts(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete restrict,
  selected_option_ids uuid[] not null default '{}'::uuid[],
  is_correct boolean,
  answered_at timestamptz not null default now(),
  unique (quiz_attempt_id, question_id)
);

create index if not exists quiz_attempt_answers_question_idx
  on public.quiz_attempt_answers (question_id);

create or replace function app_private.current_user_is_enrolled(target_course_version_id uuid)
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
      from public.enrollments e
      where e.course_version_id = target_course_version_id
        and e.user_id = (select auth.uid())
        and e.status not in ('failed', 'expired')
    );
$$;

create or replace function app_private.current_user_owns_enrollment(target_enrollment_id uuid)
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
      from public.enrollments e
      where e.id = target_enrollment_id
        and e.user_id = (select auth.uid())
    );
$$;

revoke execute on function app_private.current_user_is_enrolled(uuid) from public, anon;
revoke execute on function app_private.current_user_owns_enrollment(uuid) from public, anon;
grant execute on function app_private.current_user_is_enrolled(uuid) to authenticated;
grant execute on function app_private.current_user_owns_enrollment(uuid) to authenticated;

do $$
declare
  target_table regclass;
begin
  foreach target_table in array array[
    'public.courses'::regclass,
    'public.course_versions'::regclass,
    'public.course_modules'::regclass,
    'public.lessons'::regclass,
    'public.lesson_resources'::regclass,
    'public.enrollments'::regclass,
    'public.lesson_progress'::regclass,
    'public.question_banks'::regclass,
    'public.questions'::regclass,
    'public.question_options'::regclass,
    'public.quizzes'::regclass
  ]
  loop
    execute format(
      'drop trigger if exists %I on %s',
      replace(target_table::text, 'public.', '') || '_set_updated_at',
      target_table
    );
    execute format(
      'create trigger %I before update on %s for each row execute function app_private.set_updated_at()',
      replace(target_table::text, 'public.', '') || '_set_updated_at',
      target_table
    );
  end loop;
end $$;

alter table public.courses enable row level security;
alter table public.course_versions enable row level security;
alter table public.course_modules enable row level security;
alter table public.lessons enable row level security;
alter table public.lesson_resources enable row level security;
alter table public.enrollments enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.video_events enable row level security;
alter table public.question_banks enable row level security;
alter table public.questions enable row level security;
alter table public.question_options enable row level security;
alter table public.quizzes enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.quiz_attempt_answers enable row level security;

drop policy if exists courses_public_published on public.courses;
create policy courses_public_published
on public.courses for select
to anon, authenticated
using (
  status = 'published'
);

drop policy if exists courses_staff_select on public.courses;
create policy courses_staff_select
on public.courses for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists courses_admin_manage on public.courses;
create policy courses_admin_manage
on public.courses for all
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

drop policy if exists course_versions_visible on public.course_versions;
create policy course_versions_visible
on public.course_versions for select
to anon, authenticated
using (
  status = 'published'
);

drop policy if exists course_versions_enrolled_or_staff on public.course_versions;
create policy course_versions_enrolled_or_staff
on public.course_versions for select
to authenticated
using (
  (select app_private.current_user_is_enrolled(id))
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists course_versions_admin_manage on public.course_versions;
create policy course_versions_admin_manage
on public.course_versions for all
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

drop policy if exists course_modules_visible on public.course_modules;
create policy course_modules_visible
on public.course_modules for select
to anon, authenticated
using (
  exists (
    select 1 from public.course_versions cv
    where cv.id = course_version_id and cv.status = 'published'
  )
);

drop policy if exists course_modules_enrolled_or_staff on public.course_modules;
create policy course_modules_enrolled_or_staff
on public.course_modules for select
to authenticated
using (
  (select app_private.current_user_is_enrolled(course_version_id))
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists course_modules_admin_manage on public.course_modules;
create policy course_modules_admin_manage
on public.course_modules for all
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

drop policy if exists lessons_visible on public.lessons;
create policy lessons_visible
on public.lessons for select
to anon, authenticated
using (
  exists (
    select 1
    from public.course_modules cm
    join public.course_versions cv on cv.id = cm.course_version_id
    where cm.id = module_id and cv.status = 'published'
  )
);

drop policy if exists lessons_staff_select on public.lessons;
create policy lessons_staff_select
on public.lessons for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists lessons_admin_manage on public.lessons;
create policy lessons_admin_manage
on public.lessons for all
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

drop policy if exists lesson_resources_enrolled_or_staff on public.lesson_resources;
create policy lesson_resources_enrolled_or_staff
on public.lesson_resources for select
to authenticated
using (
  exists (
    select 1
    from public.lessons l
    join public.course_modules cm on cm.id = l.module_id
    where l.id = lesson_id
      and (
        (select app_private.current_user_is_enrolled(cm.course_version_id))
        or (select app_private.current_user_has_role(
          array['tutor', 'administrador', 'superadministrador']::public.app_role[]
        ))
      )
  )
);

drop policy if exists lesson_resources_admin_manage on public.lesson_resources;
create policy lesson_resources_admin_manage
on public.lesson_resources for all
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

drop policy if exists enrollments_visible on public.enrollments;
create policy enrollments_visible
on public.enrollments for select
to authenticated
using (
  user_id = (select auth.uid())
  or (
    organization_id is not null
    and (select app_private.current_user_manages_org(organization_id))
  )
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists enrollments_admin_manage on public.enrollments;
create policy enrollments_admin_manage
on public.enrollments for all
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

drop policy if exists lesson_progress_visible on public.lesson_progress;
create policy lesson_progress_visible
on public.lesson_progress for select
to authenticated
using (
  (select app_private.current_user_owns_enrollment(enrollment_id))
  or exists (
    select 1 from public.enrollments e
    where e.id = enrollment_id
      and e.organization_id is not null
      and (select app_private.current_user_manages_org(e.organization_id))
  )
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists video_events_insert_own on public.video_events;
create policy video_events_insert_own
on public.video_events for insert
to authenticated
with check (
  (select app_private.current_user_owns_enrollment(enrollment_id))
  and exists (
    select 1
    from public.enrollments e
    join public.course_modules cm on cm.course_version_id = e.course_version_id
    join public.lessons l on l.module_id = cm.id
    where e.id = enrollment_id
      and l.id = lesson_id
  )
);

drop policy if exists video_events_select_own_or_staff on public.video_events;
create policy video_events_select_own_or_staff
on public.video_events for select
to authenticated
using (
  (select app_private.current_user_owns_enrollment(enrollment_id))
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists question_banks_staff on public.question_banks;
create policy question_banks_staff
on public.question_banks for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists question_banks_admin_manage on public.question_banks;
create policy question_banks_admin_manage
on public.question_banks for all
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

drop policy if exists questions_staff on public.questions;
create policy questions_staff
on public.questions for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists questions_admin_manage on public.questions;
create policy questions_admin_manage
on public.questions for all
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

drop policy if exists question_options_staff on public.question_options;
create policy question_options_staff
on public.question_options for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists question_options_admin_manage on public.question_options;
create policy question_options_admin_manage
on public.question_options for all
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

drop policy if exists quizzes_enrolled_or_staff on public.quizzes;
create policy quizzes_enrolled_or_staff
on public.quizzes for select
to authenticated
using (
  exists (
    select 1
    from public.lessons l
    join public.course_modules cm on cm.id = l.module_id
    where l.id = lesson_id
      and (
        (select app_private.current_user_is_enrolled(cm.course_version_id))
        or (select app_private.current_user_has_role(
          array['tutor', 'administrador', 'superadministrador']::public.app_role[]
        ))
      )
  )
);

drop policy if exists quizzes_admin_manage on public.quizzes;
create policy quizzes_admin_manage
on public.quizzes for all
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

drop policy if exists quiz_attempts_visible on public.quiz_attempts;
create policy quiz_attempts_visible
on public.quiz_attempts for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists quiz_attempt_answers_visible on public.quiz_attempt_answers;
create policy quiz_attempt_answers_visible
on public.quiz_attempt_answers for select
to authenticated
using (
  exists (
    select 1 from public.quiz_attempts qa
    where qa.id = quiz_attempt_id
      and (
        qa.user_id = (select auth.uid())
        or (select app_private.current_user_has_role(
          array['tutor', 'administrador', 'superadministrador']::public.app_role[]
        ))
      )
  )
);

revoke all on public.courses, public.course_versions, public.course_modules,
  public.lessons, public.lesson_resources, public.enrollments,
  public.lesson_progress, public.video_events, public.question_banks,
  public.questions, public.question_options, public.quizzes,
  public.quiz_attempts, public.quiz_attempt_answers
from anon, authenticated;

grant select on public.courses, public.course_versions, public.course_modules,
  public.lessons to anon, authenticated;

grant insert, update, delete on public.courses, public.course_versions,
  public.course_modules, public.lessons, public.lesson_resources,
  public.enrollments, public.question_banks, public.questions,
  public.question_options, public.quizzes
to authenticated;

grant select on public.lesson_resources, public.enrollments,
  public.lesson_progress, public.video_events, public.question_banks,
  public.questions, public.question_options, public.quizzes,
  public.quiz_attempts, public.quiz_attempt_answers
to authenticated;

grant insert on public.video_events to authenticated;

commit;
