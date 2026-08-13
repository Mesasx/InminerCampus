-- Sustituye las diapositivas provisionales del curso 2 por la presentación
-- oficial ubicada en `Diapositivas cursos`. Los objetos se publican en una
-- ruta nueva para que los móviles no reutilicen imágenes antiguas de la CDN.

begin;

do $$
declare
  target_version_id uuid;
  object_count integer;
  updated_count integer;
begin
  select version.id
    into target_version_id
  from public.courses course
  join public.course_versions version on version.course_id = course.id
  where course.slug = 'operador-maquinaria-transporte-camion-volquete'
    and version.duration_hours = 5;

  if target_version_id is null then
    raise exception 'No se encontró la versión de 5 horas del curso 2.';
  end if;

  select count(*)
    into object_count
  from storage.objects object
  where object.bucket_id = 'course-materials'
    and object.name like target_version_id::text
      || '/slides/course-deck-20260813-v2/%';

  if object_count <> 100 then
    raise exception 'Curso 2: se esperaban 100 imágenes oficiales y se encontraron %.',
      object_count;
  end if;

  update public.lesson_segment_slides slide
  set
    image_storage_path = target_version_id::text
      || '/slides/course-deck-20260813-v2/block-' || module.position::text
      || '/audio-' || module.position::text
      || '-' || lpad(segment.position::text, 2, '0')
      || '/slide-' || lpad(slide.position::text, 2, '0') || '.jpg',
    image_external_url = null,
    source_label = 'Presentación oficial Inmíner · Curso 2',
    updated_at = now()
  from public.lesson_audio_segments segment,
       public.lessons lesson,
       public.course_modules module
  where slide.segment_id = segment.id
    and segment.lesson_id = lesson.id
    and lesson.module_id = module.id
    and module.course_version_id = target_version_id
    and module.position between 1 and 5
    and segment.position between 1 and 10
    and slide.position between 1 and 2;

  get diagnostics updated_count = row_count;
  if updated_count <> 100 then
    raise exception 'Curso 2: se actualizaron % diapositivas; se esperaban 100.',
      updated_count;
  end if;
end $$;

commit;
