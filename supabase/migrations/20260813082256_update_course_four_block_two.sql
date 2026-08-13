-- Actualiza el bloque 2 del curso 4 con la presentación oficial de 50 diapositivas.

begin;

create temporary table course_four_slide_updates (
  part_position integer primary key,
  source_page integer not null,
  title text not null,
  summary text not null,
  key_points text[] not null
) on commit drop;

insert into course_four_slide_updates values
  (1, 11, 'Preparación personal y equipos de protección', 'Antes de acceder a la máquina, el operador debe encontrarse en condiciones físicas y mentales adecuadas, sin fatiga incapacitante ni efectos de alcohol, drogas o medicamentos que reduzcan la atención. El casco, el calzado de seguridad, el chaleco de alta visibilidad, los guantes y las protecciones auditiva, ocular o respiratoria se seleccionan según la evaluación de riesgos. También debe conocerse dónde guardarlos para evitar contaminación y cómo comprobar su estado antes de usarlos.', array['Antes de acceder a la máquina, el operador debe encontrarse en condiciones físicas y mentales adecuadas, sin fatiga incapacitante ni efectos de alcohol, drogas o medicamentos que reduzcan la atención.', 'El casco, el calzado de seguridad, el chaleco de alta visibilidad, los guantes y las protecciones auditiva, ocular o respiratoria se seleccionan según la evaluación de riesgos.', 'También debe conocerse dónde guardarlos para evitar contaminación y cómo comprobar su estado antes de usarlos.']::text[]),
  (2, 12, 'Inspección perimetral de la máquina', 'La revisión diaria empieza desde el suelo y con la máquina inmovilizada. Bajo la máquina se observa si existen manchas recientes de combustible, aceite, refrigerante o fluido hidráulico. Cualquier anomalía se registra y se valora antes del arranque.', array['La revisión diaria empieza desde el suelo y con la máquina inmovilizada.', 'Bajo la máquina se observa si existen manchas recientes de combustible, aceite, refrigerante o fluido hidráulico.', 'Cualquier anomalía se registra y se valora antes del arranque.']::text[]),
  (3, 13, 'Niveles, fugas y circuitos calientes', 'Los niveles se comprueban siguiendo el manual y con la máquina en la posición indicada, porque una lectura incorrecta puede provocar sobrellenado o falta de lubricación. Para localizar pérdidas se emplean medios adecuados y personal competente. Si aparece olor a combustible, una manguera dañada o pérdida importante, la máquina queda fuera de servicio hasta que se elimine la causa, no solo hasta limpiar la mancha.', array['Los niveles se comprueban siguiendo el manual y con la máquina en la posición indicada, porque una lectura incorrecta puede provocar sobrellenado o falta de lubricación.', 'Para localizar pérdidas se emplean medios adecuados y personal competente.', 'Si aparece olor a combustible, una manguera dañada o pérdida importante, la máquina queda fuera de servicio hasta que se elimine la causa, no solo hasta limpiar la mancha.']::text[]),
  (4, 14, 'Neumáticos y tren de rodaje', 'En una pala se revisan presión, cortes, abultamientos, desgaste, llantas y fijaciones. En máquinas de cadenas se inspeccionan tejas, bulones, rodillos, rueda guía, rueda motriz y tensión aparente. El operador comunica daños o desgaste anormal y no intenta intervenir si la tarea excede el mantenimiento autorizado.', array['En una pala se revisan presión, cortes, abultamientos, desgaste, llantas y fijaciones.', 'En máquinas de cadenas se inspeccionan tejas, bulones, rodillos, rueda guía, rueda motriz y tensión aparente.', 'El operador comunica daños o desgaste anormal y no intenta intervenir si la tarea excede el mantenimiento autorizado.']::text[]),
  (5, 15, 'Equipo de trabajo y sistema hidráulico', 'El cucharón, la hoja, la pluma, el balancín y los accesorios soportan esfuerzos elevados. Una fisura, un pasador desplazado o una fuga puede terminar en caída del accesorio o pérdida de control. Si se necesita limpiar o revisar una articulación, se apoya el equipo, se descarga la presión residual, se detiene el motor y se aplica el procedimiento de aislamiento previsto.', array['El cucharón, la hoja, la pluma, el balancín y los accesorios soportan esfuerzos elevados.', 'Una fisura, un pasador desplazado o una fuga puede terminar en caída del accesorio o pérdida de control.', 'Si se necesita limpiar o revisar una articulación, se apoya el equipo, se descarga la presión residual, se detiene el motor y se aplica el procedimiento de aislamiento previsto.']::text[]),
  (6, 16, 'Acceso seguro y acondicionamiento de la cabina', 'Se sube y baja mirando hacia la máquina y manteniendo tres puntos de apoyo. No se utiliza el volante, una palanca ni una manguera como agarradero, y nunca se salta desde la cabina. El cinturón se abrocha antes de mover la máquina; la estructura ROPS protege de forma eficaz cuando el operador permanece dentro del espacio protegido.', array['Se sube y baja mirando hacia la máquina y manteniendo tres puntos de apoyo.', 'No se utiliza el volante, una palanca ni una manguera como agarradero, y nunca se salta desde la cabina.', 'El cinturón se abrocha antes de mover la máquina; la estructura ROPS protege de forma eficaz cuando el operador permanece dentro del espacio protegido.']::text[]),
  (7, 17, 'Comprobaciones funcionales antes de desplazarse', 'Tras arrancar, se observan el panel y las alarmas mientras el motor alcanza las condiciones indicadas por el fabricante. En excavadoras se comprueba el bloqueo hidráulico y el freno o control de giro; en palas, la dirección de emergencia cuando proceda. Una alarma no se anula para continuar trabajando: se identifica su causa y se aplica el procedimiento correspondiente.', array['Tras arrancar, se observan el panel y las alarmas mientras el motor alcanza las condiciones indicadas por el fabricante.', 'En excavadoras se comprueba el bloqueo hidráulico y el freno o control de giro; en palas, la dirección de emergencia cuando proceda.', 'Una alarma no se anula para continuar trabajando: se identifica su causa y se aplica el procedimiento correspondiente.']::text[]),
  (8, 18, 'Mantenimiento básico, bloqueo y consignación', 'El operador puede realizar las operaciones básicas asignadas por el fabricante y la empresa, como limpieza, engrase o comprobaciones sencillas. Cuando exista riesgo por energía eléctrica, hidráulica, neumática, mecánica o térmica, se bloquea, se consigna y se verifica la ausencia de energía. Si el trabajo requiere elevar la máquina o el implemento, se utilizan soportes diseñados para ello; nunca se confía únicamente en los cilindros hidráulicos.', array['El operador puede realizar las operaciones básicas asignadas por el fabricante y la empresa, como limpieza, engrase o comprobaciones sencillas.', 'Cuando exista riesgo por energía eléctrica, hidráulica, neumática, mecánica o térmica, se bloquea, se consigna y se verifica la ausencia de energía.', 'Si el trabajo requiere elevar la máquina o el implemento, se utilizan soportes diseñados para ello; nunca se confía únicamente en los cilindros hidráulicos.']::text[]),
  (9, 19, 'Cambio seguro de accesorios', 'El cambio de cucharas, martillos, horquillas u otros accesorios se realiza en una superficie estable, dentro de una zona sin personas y siguiendo la secuencia del fabricante. Los acoplamientos se mantienen limpios para evitar fallos y contaminación del sistema. Un accesorio mal enganchado puede desprenderse sin previo aviso.', array['El cambio de cucharas, martillos, horquillas u otros accesorios se realiza en una superficie estable, dentro de una zona sin personas y siguiendo la secuencia del fabricante.', 'Los acoplamientos se mantienen limpios para evitar fallos y contaminación del sistema.', 'Un accesorio mal enganchado puede desprenderse sin previo aviso.']::text[]),
  (10, 20, 'Embarque, transporte, remolcado y recuperación', 'Subir una máquina a una góndola requiere un plan: capacidad del vehículo, rampas adecuadas, terreno nivelado, alineación, ausencia de personas y guía de un señalista cuando la visibilidad sea limitada. El remolcado o recuperación solo se realiza con procedimiento autorizado, elementos certificados y puntos de anclaje previstos por el fabricante. Si la máquina está en pendiente, hundida o cerca de un borde, primero se estabiliza la situación y se designa una única persona para dirigir la maniobra.', array['Subir una máquina a una góndola requiere un plan: capacidad del vehículo, rampas adecuadas, terreno nivelado, alineación, ausencia de personas y guía de un señalista cuando la visibilidad sea limitada.', 'El remolcado o recuperación solo se realiza con procedimiento autorizado, elementos certificados y puntos de anclaje previstos por el fabricante.', 'Si la máquina está en pendiente, hundida o cerca de un borde, primero se estabiliza la situación y se designa una única persona para dirigir la maniobra.']::text[]);

do $$
declare
  target_version_id uuid;
  object_count integer;
begin
  select version.id into strict target_version_id
  from public.course_versions version
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20;

  select count(*) into object_count
  from storage.objects object
  where object.bucket_id = 'course-materials'
    and object.name like target_version_id::text
      || '/slides/course-4-20260813-v3/block-2/%';

  if object_count <> 10 then
    raise exception 'Curso 4, bloque 2: se esperaban 10 imágenes y existen %.', object_count;
  end if;
end $$;

update public.lesson_audio_segments segment
set title = detail.title,
    narration_text = detail.summary,
    published = true,
    updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_four_slide_updates detail on true
where segment.lesson_id = lesson.id
  and segment.position = detail.part_position
  and module.position = 2
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

update public.lesson_segment_notes note
set summary = detail.summary,
    key_points = detail.key_points,
    source_label = 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
    source_pages = 'Diapositiva ' || detail.source_page::text || '/50',
    approved = true,
    updated_at = now()
from public.lesson_audio_segments segment
join public.lessons lesson on lesson.id = segment.lesson_id
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_four_slide_updates detail on detail.part_position = segment.position
where note.segment_id = segment.id
  and module.position = 2
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

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
  and module.position = 2
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

insert into public.lesson_segment_slides (
  segment_id, position, title, body, image_storage_path, image_external_url,
  source_label, source_page, alt_text
)
select
  segment.id,
  1,
  detail.title,
  detail.summary,
  version.id::text || '/slides/course-4-20260813-v3/block-2/audio-2-'
    || lpad(detail.part_position::text, 2, '0') || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
  detail.source_page::text,
  'Curso 4, bloque 2, parte 2.' || detail.part_position::text
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module on module.course_version_id = version.id and module.position = 2
join public.lessons lesson on lesson.module_id = module.id
join public.lesson_audio_segments segment on segment.lesson_id = lesson.id
join course_four_slide_updates detail on detail.part_position = segment.position
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

do $$
declare
  updated_segments integer;
  updated_slides integer;
  updated_notes integer;
begin
  select count(distinct segment.id), count(distinct slide.id), count(distinct note.segment_id)
  into updated_segments, updated_slides, updated_notes
  from public.courses course
  join public.course_versions version on version.course_id = course.id
  join public.course_modules module on module.course_version_id = version.id and module.position = 2
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id
  join public.lesson_segment_slides slide on slide.segment_id = segment.id
    and slide.image_storage_path like version.id::text || '/slides/course-4-20260813-v3/%'
  join public.lesson_segment_notes note on note.segment_id = segment.id and note.approved
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20
    and segment.published
    and length(trim(segment.narration_text)) >= 10;

  if updated_segments <> 10 or updated_slides <> 10 or updated_notes <> 10 then
    raise exception 'Curso 4, bloque 2 incompleto: % partes, % diapositivas, % fichas.',
      updated_segments, updated_slides, updated_notes;
  end if;
end $$;

commit;
