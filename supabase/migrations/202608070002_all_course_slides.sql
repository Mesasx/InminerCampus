begin;

create temporary table course_slide_decks (
  course_slug text not null,
  module_position smallint not null,
  source_key text not null,
  source_slides smallint[] not null,
  primary key (course_slug, module_position),
  constraint course_slide_decks_ten_sources check (
    array_length(source_slides, 1) = 10
  )
) on commit drop;

insert into course_slide_decks values
('operador-maquinaria-arranque-carga-viales', 1, 'arranque',
  array[4, 5, 6, 7, 8, 9, 10, 11, 12, 10]::smallint[]),
('operador-maquinaria-arranque-carga-viales', 2, 'arranque',
  array[13, 20, 27, 34, 41, 48, 55, 62, 69, 76]::smallint[]),
('operador-maquinaria-arranque-carga-viales', 3, 'arranque',
  array[77, 78, 79, 80, 81, 82, 83, 84, 83, 84]::smallint[]),
('operador-maquinaria-arranque-carga-viales', 4, 'arranque',
  array[85, 86, 87, 88, 89, 85, 86, 87, 88, 89]::smallint[]),
('operador-maquinaria-arranque-carga-viales', 5, 'arranque',
  array[90, 91, 92, 93, 94, 90, 91, 92, 93, 94]::smallint[]),
('operador-maquinaria-transporte-camion-volquete', 1, 'transporte',
  array[4, 5, 6, 7, 8, 9, 10, 12, 13, 16]::smallint[]),
('operador-maquinaria-transporte-camion-volquete', 2, 'transporte',
  array[18, 24, 30, 36, 42, 48, 54, 60, 66, 73]::smallint[]),
('operador-maquinaria-transporte-camion-volquete', 3, 'transporte',
  array[74, 75, 76, 77, 78, 79, 80, 81, 80, 81]::smallint[]),
('operador-maquinaria-transporte-camion-volquete', 4, 'transporte',
  array[82, 83, 84, 85, 86, 87, 82, 83, 84, 85]::smallint[]),
('operador-maquinaria-transporte-camion-volquete', 5, 'transporte',
  array[88, 89, 90, 91, 92, 93, 94, 95, 88, 89]::smallint[]),
('prevencion-polvo-silice-cristalina-respirable', 1, 'silice',
  array[4, 5, 6, 8, 14, 14, 15, 15, 15, 21]::smallint[]),
('prevencion-polvo-silice-cristalina-respirable', 2, 'silice',
  array[23, 24, 25, 26, 27, 28, 24, 25, 26, 27]::smallint[]),
('prevencion-polvo-silice-cristalina-respirable', 3, 'silice',
  array[29, 30, 31, 32, 33, 34, 35, 36, 34, 35]::smallint[]),
('prevencion-polvo-silice-cristalina-respirable', 4, 'silice',
  array[37, 40, 41, 43, 46, 50, 54, 57, 60, 63]::smallint[]),
('prevencion-polvo-silice-cristalina-respirable', 5, 'silice',
  array[64, 65, 66, 67, 68, 69, 70, 71, 74, 76]::smallint[]);

with mapped_segments as (
  select
    s.id as segment_id,
    s.title,
    s.narration_text,
    c.slug as course_slug,
    cv.duration_hours,
    cm.position as module_position,
    s.position as audio_position,
    d.source_key,
    case
      when c.slug = 'operador-maquinaria-arranque-carga-viales'
        and cv.duration_hours = 5
        and cm.position = 2
      then (array[7, 7]::smallint[])[s.position]
      else d.source_slides[s.position]
    end as source_slide
  from public.lesson_audio_segments s
  join public.lessons l on l.id = s.lesson_id
  join public.course_modules cm on cm.id = l.module_id
  join public.course_versions cv on cv.id = cm.course_version_id
  join public.courses c on c.id = cv.course_id
  join course_slide_decks d
    on d.course_slug = c.slug
   and d.module_position = cm.position
  where s.published
    and s.position between 1 and 10
    and not (
      c.slug = 'operador-maquinaria-arranque-carga-viales'
      and cv.duration_hours = 5
      and cm.position = 1
    )
),
visual_slides as (
  select
    segment_id,
    1::smallint as position,
    title,
    coalesce(
      nullif(trim(narration_text), ''),
      'Apoyo visual para la parte ' || module_position::text || '.'
        || audio_position::text || ': ' || title || '.'
    ) as body,
    '/course-slides/sources/' || source_key || '/source-slide-'
      || lpad(source_slide::text, 3, '0') || '.jpg' as image_external_url,
    source_slide
  from mapped_segments
  where source_slide is not null
)
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
  segment_id,
  position,
  title,
  body,
  null,
  image_external_url,
  U&'Presentaci\00F3n original de Cursos Pedro',
  'Diapositiva ' || source_slide::text,
  'Diapositiva original de apoyo para ' || lower(title)
from visual_slides
on conflict (segment_id, position) do update set
  image_storage_path = null,
  image_external_url = excluded.image_external_url,
  source_label = excluded.source_label,
  source_page = excluded.source_page,
  alt_text = excluded.alt_text,
  updated_at = now();

with drilling_segments as (
  select
    s.id as segment_id,
    s.position as audio_position,
    s.title,
    s.narration_text,
    cm.position as module_position,
    cm.title as module_title
  from public.lesson_audio_segments s
  join public.lessons l on l.id = s.lesson_id
  join public.course_modules cm on cm.id = l.module_id
  join public.course_versions cv on cv.id = cm.course_version_id
  join public.courses c on c.id = cv.course_id
  where c.slug = 'operadores-perforacion-corte-exterior'
    and s.published
    and s.position between 1 and 10
)
insert into public.lesson_segment_slides (
  segment_id,
  position,
  title,
  body,
  source_label,
  alt_text
)
select
  segment_id,
  1,
  title,
  coalesce(
    nullif(trim(narration_text), ''),
    'Parte ' || module_position::text || '.' || audio_position::text
      || ' del bloque "' || module_title || '". '
      || 'Escucha el audio completo y aplica las indicaciones preventivas '
      || 'del procedimiento de trabajo de la explotacion.'
  ),
  'Contenido de audio aportado por Inminer',
  'Diapositiva didactica para ' || lower(title)
from drilling_segments
on conflict (segment_id, position) do nothing;

commit;
