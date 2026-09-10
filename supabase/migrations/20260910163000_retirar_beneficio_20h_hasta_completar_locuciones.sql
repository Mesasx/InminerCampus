-- Retira de la venta la formación inicial de 20 h de «Operadores en
-- establecimientos de beneficio» hasta que el estudio entregue las locuciones
-- que faltan.
--
-- El curso tiene 16 de sus 50 unidades con audio: el bloque 1 completo y seis
-- unidades del bloque 2. Los bloques 3, 4 y 5 siguen activos y sin ninguna
-- unidad publicada, de modo que un alumno que termina el bloque 2 desbloquea un
-- bloque vacío y no puede avanzar: `record_audio_segment_progress` sólo da una
-- lección por completada si tiene al menos una unidad publicada, así que la
-- matrícula nunca llega a `completed` ni genera certificado.
--
-- Se despublica únicamente esa versión. El reciclaje de 5 h está completo y
-- sigue a la venta, y el curso (`courses.status`) permanece publicado. Es
-- reversible: cuando lleguen las 34 pistas basta con volver a poner
-- `status = 'published'` tras cargarlas.
--
-- No se toca ninguna matrícula. Las tres existentes son accesos
-- administrativos, y `enrollments` no depende del estado de la versión, así que
-- el equipo interno conserva la vista previa del contenido cargado.
begin;

update public.course_versions cv
set status = 'draft',
    updated_at = now()
from public.courses c
where c.id = cv.course_id
  and c.slug = 'operadores-establecimientos-beneficio'
  and cv.duration_hours = 20
  and cv.status = 'published'
  -- Guarda de seguridad: sólo se retira mientras el contenido esté incompleto.
  and (
    select count(*)
    from public.course_modules cm
    join public.lessons l on l.module_id = cm.id
    join public.lesson_audio_segments s on s.lesson_id = l.id
    where cm.course_version_id = cv.id
      and s.published
  ) < 50;

commit;
