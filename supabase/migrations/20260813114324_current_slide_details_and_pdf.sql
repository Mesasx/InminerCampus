-- La ficha visible depende de la diapositiva activa y se referencia contra
-- los materiales oficiales de "Cursos Pedro" en Google Drive.

create temporary table _arranque_parts_source (
  block_position integer not null,
  part_position integer not null,
  manual_pages text not null,
  primary key (block_position, part_position)
) on commit drop;

insert into _arranque_parts_source (block_position, part_position, manual_pages)
values
  (1, 1, 'prólogo y pp. 5–6'),
  (1, 2, 'pp. 7–15'),
  (1, 3, 'pp. 7–15'),
  (1, 4, 'pp. 19–24'),
  (1, 5, 'pp. 25–30 y 211–237'),
  (1, 6, 'presentación del curso, bloque 1'),
  (1, 7, 'pp. 139–238'),
  (1, 8, 'pp. 16–30'),
  (1, 9, 'pp. 306–347'),
  (1, 10, 'pp. 7–30 y 65–108'),
  (2, 1, 'pp. 126–130'),
  (2, 2, 'pp. 33–43'),
  (2, 3, 'pp. 33–43'),
  (2, 4, 'pp. 33–43, 199–206 y 232–237'),
  (2, 5, 'pp. 33–43 y 191–238'),
  (2, 6, 'pp. 44–45 y 207–210'),
  (2, 7, 'pp. 65–72 y 260–275'),
  (2, 8, 'pp. 46–52 y 109–120'),
  (2, 9, 'pp. 60–64'),
  (2, 10, 'pp. 53–59'),
  (3, 1, 'pp. 65–72'),
  (3, 2, 'pp. 245–253 y 277–295'),
  (3, 3, 'pp. 73–86'),
  (3, 4, 'pp. 73–97'),
  (3, 5, 'presentación del curso, bloque 3'),
  (3, 6, 'pp. 277–295 y 324–328'),
  (3, 7, 'pp. 278–295'),
  (3, 8, 'pp. 87–97'),
  (3, 9, 'pp. 98–100'),
  (3, 10, 'pp. 101–108'),
  (4, 1, 'pp. 141–157'),
  (4, 2, 'pp. 158–190'),
  (4, 3, 'pp. 191–196 y 221–228'),
  (4, 4, 'pp. 197–238'),
  (4, 5, 'pp. 199–206 y 232–237'),
  (4, 6, 'pp. 183–190 y 249–250'),
  (4, 7, 'pp. 250–252'),
  (4, 8, 'pp. 242–247'),
  (4, 9, 'pp. 260–275'),
  (4, 10, 'pp. 121–125, 253–254 y 334–341'),
  (5, 1, 'pp. 278–283'),
  (5, 2, 'pp. 284–295'),
  (5, 3, 'pp. 309–317'),
  (5, 4, 'pp. 318–322'),
  (5, 5, 'pp. 323–328'),
  (5, 6, 'pp. 329–330'),
  (5, 7, 'pp. 296–302'),
  (5, 8, 'pp. 131–134'),
  (5, 9, 'pp. 135–136'),
  (5, 10, 'pp. 331–347');

create temporary table _arranque_segments on commit drop as
select
  cv.id as course_version_id,
  cv.duration_hours,
  cm.position as block_position,
  s.position as part_position,
  s.id as segment_id,
  source.manual_pages
from public.courses c
join public.course_versions cv on cv.course_id = c.id
join public.course_modules cm on cm.course_version_id = cv.id
join public.lessons l on l.module_id = cm.id
join public.lesson_audio_segments s
  on s.lesson_id = l.id
  and s.published = true
  and coalesce(s.audio_storage_path, s.audio_external_url) is not null
join _arranque_parts_source source
  on source.block_position = cm.position
  and source.part_position = s.position
where c.slug = 'operador-maquinaria-arranque-carga-viales'
  and cv.duration_hours in (5, 20)
  and cv.status = 'published';

do $$
begin
  if (select count(*) from _arranque_segments) <> 100 then
    raise exception 'Se esperaban 100 partes publicadas de arranque y se encontraron %',
      (select count(*) from _arranque_segments);
  end if;
end;
$$;

update public.lesson_segment_slides slide
set
  source_label = 'Cursos Pedro (Google Drive) · Manual oficial ET 2001-1-08 · Presentación actual de 50 diapositivas',
  updated_at = now()
from _arranque_segments target
where slide.segment_id = target.segment_id;

update public.lesson_segment_notes note
set
  summary = slide.body,
  source_label = 'Cursos Pedro (Google Drive) · Manual oficial del operador · ITC 02.1.02 · ET 2001-1-08',
  source_pages = target.manual_pages,
  approved = true,
  updated_at = now()
from _arranque_segments target
join lateral (
  select current_slide.body
  from public.lesson_segment_slides current_slide
  where current_slide.segment_id = target.segment_id
  order by current_slide.position
  limit 1
) slide on true
where note.segment_id = target.segment_id;

-- El PDF descargable es una exportación del PowerPoint actual que generó
-- las 50 diapositivas, no el manual ni una versión anterior del curso.
update public.lesson_resources resource
set
  kind = 'presentation'::public.resource_kind,
  title = 'Diapositivas actuales del curso · 50 páginas',
  storage_path = null,
  external_url = '/course-materials/arranque-20h/formacion-inicial-arranque-20h-actual.pdf',
  mime_type = 'application/pdf',
  size_bytes = 7538898,
  downloadable = true,
  updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where resource.lesson_id = lesson.id
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours in (5, 20)
  and version.status = 'published'
  and resource.mime_type = 'application/pdf';

do $$
declare
  detailed_slides integer;
  sourced_notes integer;
  current_pdf_resources integer;
begin
  select count(*)
  into detailed_slides
  from _arranque_segments target
  join public.lesson_segment_slides slide on slide.segment_id = target.segment_id
  where btrim(slide.body) <> ''
    and slide.source_label like 'Cursos Pedro (Google Drive)%';

  select count(*)
  into sourced_notes
  from _arranque_segments target
  join public.lesson_segment_notes note on note.segment_id = target.segment_id
  where note.approved = true
    and btrim(note.summary) <> ''
    and note.source_label like 'Cursos Pedro (Google Drive)%';

  select count(*)
  into current_pdf_resources
  from public.lesson_resources resource
  join public.lessons lesson on lesson.id = resource.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours in (5, 20)
    and version.status = 'published'
    and resource.external_url = '/course-materials/arranque-20h/formacion-inicial-arranque-20h-actual.pdf'
    and resource.downloadable = true;

  if detailed_slides <> 100 or sourced_notes <> 100
     or current_pdf_resources <> 11 then
    raise exception 'Validación fallida: % diapositivas, % fichas, % recursos PDF',
      detailed_slides, sourced_notes, current_pdf_resources;
  end if;
end;
$$;
