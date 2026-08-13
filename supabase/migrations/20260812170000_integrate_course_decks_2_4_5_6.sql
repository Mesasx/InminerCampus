-- Integra las presentaciones oficiales de los cursos 2, 4, 5 y 6.
-- Cada uno de los 50 audios principales recibe sus dos diapositivas en el
-- bucket privado `course-materials`, bajo una ruta versionada e inmutable.

begin;

create temporary table target_course_decks (
  course_number integer not null,
  slug text not null,
  duration_hours integer not null,
  image_extension text not null,
  version_id uuid not null
) on commit drop;

insert into target_course_decks (
  course_number,
  slug,
  duration_hours,
  image_extension,
  version_id
)
select
  requested.course_number,
  requested.slug,
  requested.duration_hours,
  requested.image_extension,
  version.id
from (
  values
    (2, 'operador-maquinaria-transporte-camion-volquete', 5, 'png'),
    (4, 'operador-maquinaria-arranque-carga-viales', 20, 'jpg'),
    (5, 'operador-maquinaria-transporte-camion-volquete', 20, 'jpg'),
    (6, 'prevencion-polvo-silice-cristalina-respirable', 20, 'jpg')
) as requested(course_number, slug, duration_hours, image_extension)
join public.courses course on course.slug = requested.slug
join public.course_versions version
  on version.course_id = course.id
 and version.duration_hours = requested.duration_hours;

do $$
declare
  deck record;
  target_count integer;
  segment_count integer;
  object_count integer;
begin
  select count(*) into target_count from target_course_decks;
  if target_count <> 4 then
    raise exception 'Se esperaban 4 versiones de curso y se encontraron %.', target_count;
  end if;

  for deck in select * from target_course_decks order by course_number loop
    select count(*) into segment_count
    from public.course_modules module
    join public.lessons lesson on lesson.module_id = module.id
    join public.lesson_audio_segments segment on segment.lesson_id = lesson.id
    where module.course_version_id = deck.version_id
      and module.position between 1 and 5
      and segment.position between 1 and 10;

    if segment_count <> 50 then
      raise exception 'Curso %: se esperaban 50 audios y se encontraron %.',
        deck.course_number, segment_count;
    end if;

    select count(*) into object_count
    from storage.objects object
    where object.bucket_id = 'course-materials'
      and object.name like deck.version_id::text
        || '/slides/course-deck-20260812/%';

    if object_count <> 100 then
      raise exception 'Curso %: se esperaban 100 imágenes privadas y se encontraron %.',
        deck.course_number, object_count;
    end if;
  end loop;
end $$;

-- La versión de 20 h de arranque ya tenía los 50 MP3 en Storage, pero una
-- migración anterior dejó 47 segmentos sin apuntar a ellos.
update public.lesson_audio_segments segment
set
  audio_storage_path = deck.version_id::text
    || '/block-' || module.position::text
    || '/audio/part-' || module.position::text
    || '-' || lpad(segment.position::text, 2, '0') || '.mp3',
  audio_external_url = null,
  updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join target_course_decks deck
  on deck.version_id = module.course_version_id
 and deck.course_number = 4
where segment.lesson_id = lesson.id
  and module.position between 1 and 5
  and segment.position between 1 and 10;

delete from public.lesson_segment_slides slide
using public.lesson_audio_segments segment,
      public.lessons lesson,
      public.course_modules module,
      target_course_decks deck
where slide.segment_id = segment.id
  and segment.lesson_id = lesson.id
  and lesson.module_id = module.id
  and module.course_version_id = deck.version_id
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
  segment.id,
  slide_position::smallint,
  left(segment.title || ' · diapositiva ' || slide_position::text, 240),
  '',
  deck.version_id::text
    || '/slides/course-deck-20260812/block-' || module.position::text
    || '/audio-' || module.position::text
    || '-' || lpad(segment.position::text, 2, '0')
    || '/slide-' || lpad(slide_position::text, 2, '0')
    || '.' || deck.image_extension,
  null,
  'Presentación oficial Inmíner · Curso ' || deck.course_number::text,
  (((module.position - 1) * 10 + (segment.position - 1)) * 2 + slide_position)::text,
  'Curso ' || deck.course_number::text
    || ', bloque ' || module.position::text
    || ', audio ' || module.position::text || '.' || segment.position::text
    || ', diapositiva ' || slide_position::text
from target_course_decks deck
join public.course_modules module on module.course_version_id = deck.version_id
join public.lessons lesson on lesson.module_id = module.id
join public.lesson_audio_segments segment on segment.lesson_id = lesson.id
cross join generate_series(1, 2) as slide_position
where module.position between 1 and 5
  and segment.position between 1 and 10;

do $$
declare
  deck record;
  slide_count integer;
  audio_count integer;
begin
  for deck in select * from target_course_decks order by course_number loop
    select count(*) into slide_count
    from public.lesson_segment_slides slide
    join public.lesson_audio_segments segment on segment.id = slide.segment_id
    join public.lessons lesson on lesson.id = segment.lesson_id
    join public.course_modules module on module.id = lesson.module_id
    where module.course_version_id = deck.version_id
      and module.position between 1 and 5
      and slide.image_storage_path like deck.version_id::text
        || '/slides/course-deck-20260812/%';

    if slide_count <> 100 then
      raise exception 'Curso %: la integración produjo % diapositivas; se esperaban 100.',
        deck.course_number, slide_count;
    end if;
  end loop;

  select count(*) into audio_count
  from public.lesson_audio_segments segment
  join public.lessons lesson on lesson.id = segment.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join target_course_decks target
    on target.version_id = module.course_version_id
   and target.course_number = 4
  where module.position between 1 and 5
    and segment.audio_storage_path is not null;

  if audio_count <> 50 then
    raise exception 'Curso 4: solo % de 50 audios quedaron conectados.', audio_count;
  end if;
end $$;

commit;
