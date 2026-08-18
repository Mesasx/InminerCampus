-- El bloque 1 recibio explicaciones detalladas y diapositivas propias solo en
-- la version de 20 horas (20260813123633). Esta migracion traslada ese mismo
-- contenido (ficha detallada y diapositiva 1) a la version de reciclaje de 5
-- horas, sin tocar sus audios propios ni la diapositiva 2 (exclusiva del
-- itinerario de 20 horas).

begin;

create temporary table _block_one_source on commit drop as
select
  source_segment.position as part_position,
  note.summary,
  note.key_points,
  note.stop_criterion,
  note.source_label as note_source_label,
  note.source_pages,
  slide.title as slide_title,
  slide.body as slide_body,
  slide.source_label as slide_source_label
from public.courses course
join public.course_versions source_version
  on source_version.course_id = course.id
 and source_version.duration_hours = 20
 and source_version.status = 'published'
join public.course_modules source_module
  on source_module.course_version_id = source_version.id
 and source_module.position = 1
join public.lessons source_lesson
  on source_lesson.module_id = source_module.id
 and source_lesson.position = 1
join public.lesson_audio_segments source_segment
  on source_segment.lesson_id = source_lesson.id
 and source_segment.published = true
join public.lesson_segment_notes note
  on note.segment_id = source_segment.id
join public.lesson_segment_slides slide
  on slide.segment_id = source_segment.id
 and slide.position = 1
where course.slug = 'operador-maquinaria-arranque-carga-viales';

do $$
begin
  if (select count(*) from _block_one_source) <> 10 then
    raise exception 'Se esperaban las 10 fichas detalladas del bloque 1 de 20 horas';
  end if;
end;
$$;

create temporary table _block_one_target on commit drop as
select
  target_segment.id as segment_id,
  source.summary,
  source.key_points,
  source.stop_criterion,
  source.note_source_label,
  source.source_pages,
  source.slide_title,
  source.slide_body,
  source.slide_source_label
from public.courses course
join public.course_versions target_version
  on target_version.course_id = course.id
 and target_version.duration_hours = 5
 and target_version.status = 'published'
join public.course_modules target_module
  on target_module.course_version_id = target_version.id
 and target_module.position = 1
join public.lessons target_lesson
  on target_lesson.module_id = target_module.id
 and target_lesson.position = 1
join public.lesson_audio_segments target_segment
  on target_segment.lesson_id = target_lesson.id
 and target_segment.published = true
join _block_one_source source
  on source.part_position = target_segment.position
where course.slug = 'operador-maquinaria-arranque-carga-viales';

do $$
begin
  if (select count(*) from _block_one_target) <> 10 then
    raise exception 'Se esperaban las 10 partes del bloque 1 de 5 horas';
  end if;
end;
$$;

create temporary table _block_one_audio_snapshot on commit drop as
select segment.id, segment.audio_storage_path, segment.audio_external_url
from public.lesson_audio_segments segment
join _block_one_target target on target.segment_id = segment.id;

update public.lesson_segment_notes note
set
  summary = target.summary,
  key_points = target.key_points,
  stop_criterion = target.stop_criterion,
  source_label = target.note_source_label,
  source_pages = target.source_pages,
  approved = true,
  updated_at = now()
from _block_one_target target
where note.segment_id = target.segment_id;

update public.lesson_segment_slides slide
set
  title = target.slide_title,
  body = target.slide_body,
  source_label = target.slide_source_label,
  updated_at = now()
from _block_one_target target
where slide.segment_id = target.segment_id
  and slide.position = 1;

do $$
declare
  detailed_notes integer;
  detailed_slides integer;
  changed_audio_count integer;
begin
  select count(*)
  into detailed_notes
  from _block_one_target target
  join public.lesson_segment_notes note on note.segment_id = target.segment_id
  where note.summary = target.summary
    and note.approved = true;

  select count(*)
  into detailed_slides
  from _block_one_target target
  join public.lesson_segment_slides slide
    on slide.segment_id = target.segment_id and slide.position = 1
  where slide.title = target.slide_title
    and slide.body = target.slide_body;

  select count(*)
  into changed_audio_count
  from _block_one_audio_snapshot snapshot
  join public.lesson_audio_segments segment on segment.id = snapshot.id
  where segment.audio_storage_path is distinct from snapshot.audio_storage_path
     or segment.audio_external_url is distinct from snapshot.audio_external_url;

  if detailed_notes <> 10 or detailed_slides <> 10 or changed_audio_count <> 0 then
    raise exception
      'Bloque 1 de 5 horas incompleto: % fichas, % diapositivas, % audios modificados',
      detailed_notes, detailed_slides, changed_audio_count;
  end if;
end;
$$;

commit;
