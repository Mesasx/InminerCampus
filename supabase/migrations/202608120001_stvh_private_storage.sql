-- Privatiza las diapositivas y los materiales descargables de «Formación
-- STVH»: dejan de servirse como ficheros públicos bajo /course-slides/stvh
-- y /course-materials/stvh y pasan a vivir en el bucket privado
-- `course-materials`, bajo la carpeta `<course_version_id>/...`.
--
-- Esa carpeta ya está cubierta por la política genérica
-- `course_materials_enrolled_read` (202607290008, redefinida en
-- 20260810123511) para cualquier `<uuid>/...`: exige matrícula en esa
-- versión de curso o rol tutor/administrador/superadministrador. No hace
-- falta ninguna política nueva.
--
-- IMPORTANTE — orden de despliegue para no dejar sin imagen a alumnos ya
-- matriculados: primero sube los ficheros al bucket con
-- `scripts/upload-stvh-private-assets.mjs` (deja intactos los públicos
-- mientras tanto) y solo entonces aplica esta migración. Aplicarla antes de
-- subir los ficheros rompe las diapositivas y los PDF hasta que termine la
-- subida.
--
-- Requiere 202608110002 ya aplicada. Es idempotente: una segunda ejecución
-- no encuentra filas con el external_url antiguo y no hace nada.

begin;

do $$
declare
  v_version_id uuid;
  v_slides_updated integer;
  v_resources_updated integer;
begin
  select cv.id into v_version_id
  from public.course_versions cv
  join public.courses c on c.id = cv.course_id
  where c.slug = 'formacion-stvh'
    and cv.version_number = 1;

  if v_version_id is null then
    raise exception
      'No se encontró la versión publicada de Formación STVH (courses.slug = formacion-stvh). Aplica primero 202608110002.';
  end if;

  update public.lesson_segment_slides s
  set
    image_storage_path = v_version_id::text || '/slides/'
      || regexp_replace(s.image_external_url, '^/course-slides/stvh/', ''),
    image_external_url = null
  from public.lesson_audio_segments seg
  join public.lessons l on l.id = seg.lesson_id
  join public.course_modules m on m.id = l.module_id
  where s.segment_id = seg.id
    and m.course_version_id = v_version_id
    and s.image_external_url like '/course-slides/stvh/%';
  get diagnostics v_slides_updated = row_count;

  update public.lesson_resources r
  set
    storage_path = v_version_id::text || '/materials/'
      || regexp_replace(r.external_url, '^/course-materials/stvh/', ''),
    external_url = null
  from public.lessons l
  join public.course_modules m on m.id = l.module_id
  where r.lesson_id = l.id
    and m.course_version_id = v_version_id
    and r.external_url like '/course-materials/stvh/%';
  get diagnostics v_resources_updated = row_count;

  raise notice 'Formación STVH: % diapositivas y % materiales repuntados al bucket privado (versión %).',
    v_slides_updated, v_resources_updated, v_version_id;
end $$;

commit;
