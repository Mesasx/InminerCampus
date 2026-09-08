begin;

alter table public.course_materials
  add column if not exists file_name text,
  add column if not exists page_count integer,
  add column if not exists is_published boolean not null default false;

alter table public.course_materials
  drop constraint if exists course_materials_file_name_length;
alter table public.course_materials
  add constraint course_materials_file_name_length
  check (file_name is null or char_length(file_name) between 1 and 260);

alter table public.course_materials
  drop constraint if exists course_materials_page_count_positive;
alter table public.course_materials
  add constraint course_materials_page_count_positive
  check (page_count is null or page_count > 0);

update public.course_materials
set file_name = regexp_replace(storage_path, '^.*/', '')
where file_name is null and storage_path is not null;

create index if not exists course_materials_published_version_idx
  on public.course_materials (course_version_id, position)
  where is_published;

drop policy if exists course_materials_enrolled_or_staff
  on public.course_materials;
create policy course_materials_enrolled_or_staff
on public.course_materials for select
to authenticated
using (
  (
    is_published
    and (select app_private.current_user_is_enrolled(course_version_id))
  )
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

comment on column public.course_materials.is_published is
  'Only published materials are shown to enrolled learners.';
comment on column public.course_materials.file_name is
  'Original downloadable filename displayed to learners and administrators.';
comment on column public.course_materials.page_count is
  'Optional page or slide count supplied by the administrator.';

commit;
