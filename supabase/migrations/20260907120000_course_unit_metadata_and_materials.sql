begin;

-- Stable, human-readable identity for each of the ten units contained by a
-- block lesson. Existing courses keep their current progress and quiz links.
alter table public.lesson_audio_segments
  add column if not exists lesson_code text,
  add column if not exists manual_chapter text;

alter table public.lesson_audio_segments
  drop constraint if exists lesson_audio_segments_lesson_code_format;
alter table public.lesson_audio_segments
  add constraint lesson_audio_segments_lesson_code_format
  check (
    lesson_code is null
    or lesson_code ~ '^[1-9][0-9]*\.(?:[1-9]|10)$'
  );

create unique index if not exists lesson_audio_segments_lesson_code_idx
  on public.lesson_audio_segments (lesson_id, lesson_code)
  where lesson_code is not null;

comment on column public.lesson_audio_segments.lesson_code is
  'Stable unit code within its block container, for example 2.7.';
comment on column public.lesson_audio_segments.manual_chapter is
  'Chapter label in the authoritative course manual.';

-- Detailed chapters from master manuals regularly exceed the original
-- editorial limit of 4,000 characters.
alter table public.lesson_segment_notes
  drop constraint if exists lesson_segment_notes_summary_length;
alter table public.lesson_segment_notes
  add constraint lesson_segment_notes_summary_length
  check (char_length(summary) between 10 and 20000);

create table if not exists public.course_materials (
  id uuid primary key default gen_random_uuid(),
  course_version_id uuid not null
    references public.course_versions(id) on delete cascade,
  kind text not null,
  title text not null,
  description text not null default '',
  storage_path text,
  external_url text,
  mime_type text,
  size_bytes bigint,
  downloadable boolean not null default true,
  position integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint course_materials_kind check (
    kind in ('manual', 'presentation', 'spreadsheet', 'document', 'other')
  ),
  constraint course_materials_title_length check (
    char_length(title) between 1 and 240
  ),
  constraint course_materials_source_required check (
    (storage_path is not null) <> (external_url is not null)
  ),
  constraint course_materials_size_nonnegative check (
    size_bytes is null or size_bytes >= 0
  ),
  constraint course_materials_position_positive check (position > 0)
);

create index if not exists course_materials_version_idx
  on public.course_materials (course_version_id, position);

drop trigger if exists course_materials_set_updated_at
  on public.course_materials;
create trigger course_materials_set_updated_at
before update on public.course_materials
for each row execute function app_private.set_updated_at();

alter table public.course_materials enable row level security;

drop policy if exists course_materials_enrolled_or_staff
  on public.course_materials;
create policy course_materials_enrolled_or_staff
on public.course_materials for select
to authenticated
using (
  (select app_private.current_user_is_enrolled(course_version_id))
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists course_materials_admin_manage
  on public.course_materials;
create policy course_materials_admin_manage
on public.course_materials for all
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

revoke all on public.course_materials from anon, authenticated;
grant select, insert, update, delete on public.course_materials to authenticated;

commit;
