-- Reutiliza en el curso de arranque de 5 h las 50 diapositivas oficiales
-- publicadas para el curso de 20 h, manteniendo intactos sus 50 audios.

begin;

create temporary table course_one_audio_snapshot on commit drop as
select
  segment.id,
  segment.audio_storage_path,
  segment.audio_external_url,
  segment.duration_seconds
from public.lesson_audio_segments segment
join public.lessons lesson on lesson.id = segment.lesson_id
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 5
  and version.status = 'published'
  and module.position between 1 and 5
  and segment.position between 1 and 10
  and segment.published;

do $$
declare
  snapshot_count integer;
  stored_slide_count integer;
begin
  select count(*) into snapshot_count from course_one_audio_snapshot;

  select count(*) into stored_slide_count
  from storage.objects object
  join public.course_versions version
    on object.name like version.id::text
      || '/slides/course-1-arranque-5h-course4-v3/%'
  join public.courses course on course.id = version.course_id
  where object.bucket_id = 'course-materials'
    and course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 5
    and version.status = 'published';

  if snapshot_count <> 50 or stored_slide_count <> 50 then
    raise exception
      'Curso 1 no preparado: % audios propios y % diapositivas copiadas.',
      snapshot_count, stored_slide_count;
  end if;
end $$;

delete from public.lesson_segment_slides slide
using public.lesson_audio_segments segment,
      public.lessons lesson,
      public.course_modules module,
      public.course_versions version,
      public.courses course
where slide.segment_id = segment.id
  and segment.lesson_id = lesson.id
  and lesson.module_id = module.id
  and module.course_version_id = version.id
  and version.course_id = course.id
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 5
  and version.status = 'published'
  and module.position between 1 and 5
  and segment.position between 1 and 10;

insert into public.lesson_segment_slides (
  segment_id,
  position,
  title,
  body,
  image_storage_path,
  image_external_url,
  source_label,
  source_page,
  alt_text
)
select
  target_segment.id,
  1,
  source_slide.title,
  source_slide.body,
  target_version.id::text
    || '/slides/course-1-arranque-5h-course4-v3/block-'
    || target_module.position::text
    || '/audio-' || target_module.position::text
    || '-' || lpad(target_segment.position::text, 2, '0')
    || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Operador de maquinaria de arranque, carga y viales',
  (((target_module.position - 1) * 10) + target_segment.position)::text,
  source_slide.alt_text
from public.courses target_course
join public.course_versions target_version
  on target_version.course_id = target_course.id
 and target_version.duration_hours = 5
 and target_version.status = 'published'
join public.course_modules target_module
  on target_module.course_version_id = target_version.id
 and target_module.position between 1 and 5
join public.lessons target_lesson
  on target_lesson.module_id = target_module.id
 and target_lesson.position = 1
join public.lesson_audio_segments target_segment
  on target_segment.lesson_id = target_lesson.id
 and target_segment.position between 1 and 10
 and target_segment.published
join public.course_versions source_version
  on source_version.course_id = target_course.id
 and source_version.duration_hours = 20
 and source_version.status = 'published'
join public.course_modules source_module
  on source_module.course_version_id = source_version.id
 and source_module.position = target_module.position
join public.lessons source_lesson
  on source_lesson.module_id = source_module.id
 and source_lesson.position = 1
join public.lesson_audio_segments source_segment
  on source_segment.lesson_id = source_lesson.id
 and source_segment.position = target_segment.position
 and source_segment.published
join public.lesson_segment_slides source_slide
  on source_slide.segment_id = source_segment.id
 and source_slide.position = 1
 and source_slide.image_storage_path like source_version.id::text
   || '/slides/course-4-20260813-v3/%'
where target_course.slug = 'operador-maquinaria-arranque-carga-viales';

do $$
declare
  associated_slide_count integer;
  changed_audio_count integer;
begin
  select count(*) into associated_slide_count
  from public.lesson_segment_slides slide
  join public.lesson_audio_segments segment on segment.id = slide.segment_id
  join public.lessons lesson on lesson.id = segment.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 5
    and version.status = 'published'
    and slide.image_storage_path like version.id::text
      || '/slides/course-1-arranque-5h-course4-v3/%';

  select count(*) into changed_audio_count
  from course_one_audio_snapshot snapshot
  join public.lesson_audio_segments segment on segment.id = snapshot.id
  where segment.audio_storage_path is distinct from snapshot.audio_storage_path
     or segment.audio_external_url is distinct from snapshot.audio_external_url
     or segment.duration_seconds is distinct from snapshot.duration_seconds;

  if associated_slide_count <> 50 or changed_audio_count <> 0 then
    raise exception
      'Curso 1 incompleto: % diapositivas nuevas y % audios modificados.',
      associated_slide_count, changed_audio_count;
  end if;
end $$;

commit;
