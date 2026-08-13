-- Actualiza el bloque 1 del curso 4 con la presentación oficial de 50 diapositivas.

begin;

create temporary table course_four_slide_updates (
  part_position integer primary key,
  source_page integer not null,
  title text not null,
  summary text not null,
  key_points text[] not null
) on commit drop;

insert into course_four_slide_updates values
  (1, 1, 'Objeto de la formación y ámbito de aplicación', 'Este curso proporciona la formación preventiva inicial para operadores de maquinaria de arranque, carga y viales en actividades extractivas de exterior. Se aplica especialmente a quienes manejan palas cargadoras, excavadoras hidráulicas de cadenas y tractores de cadenas, tanto si pertenecen a la empresa explotadora como a una contrata. La formación tiene una duración reglamentaria de veinte horas y debe relacionarse siempre con el equipo concreto, el terreno y la organización real de la explotación.', array['Este curso proporciona la formación preventiva inicial para operadores de maquinaria de arranque, carga y viales en actividades extractivas de exterior.', 'Se aplica especialmente a quienes manejan palas cargadoras, excavadoras hidráulicas de cadenas y tractores de cadenas, tanto si pertenecen a la empresa explotadora como a una contrata.', 'La formación tiene una duración reglamentaria de veinte horas y debe relacionarse siempre con el equipo concreto, el terreno y la organización real de la explotación.']::text[]),
  (2, 2, 'Fases del movimiento de tierras', 'El movimiento de tierras comprende una secuencia de operaciones relacionadas: arranque, carga, transporte y descarga. Cada fase modifica las condiciones del terreno y genera riesgos propios, pero ninguna debe analizarse de forma aislada. Por eso, antes de iniciar el ciclo, el operador debe conocer el material, el recorrido, las zonas de cruce, el punto de descarga y la presencia de personas o equipos que puedan interferir.', array['El movimiento de tierras comprende una secuencia de operaciones relacionadas: arranque, carga, transporte y descarga.', 'Cada fase modifica las condiciones del terreno y genera riesgos propios, pero ninguna debe analizarse de forma aislada.', 'Por eso, antes de iniciar el ciclo, el operador debe conocer el material, el recorrido, las zonas de cruce, el punto de descarga y la presencia de personas o equipos que puedan interferir.']::text[]),
  (3, 3, 'Arranque del material y elección del método', 'Arrancar un material significa separarlo de su estado natural para que pueda cargarse y transportarse. En roca competente puede ser necesaria una voladura previamente diseñada y ejecutada por personal autorizado. Si aparecen bloques inestables, vibraciones anormales o un frente con riesgo de desprendimiento, se detiene la operación y se comunica la incidencia.', array['Arrancar un material significa separarlo de su estado natural para que pueda cargarse y transportarse.', 'En roca competente puede ser necesaria una voladura previamente diseñada y ejecutada por personal autorizado.', 'Si aparecen bloques inestables, vibraciones anormales o un frente con riesgo de desprendimiento, se detiene la operación y se comunica la incidencia.']::text[]),
  (4, 4, 'Pala cargadora: definición y funciones', 'La pala cargadora es una máquina autopropulsada, normalmente sobre ruedas, con un equipo frontal destinado principalmente a cargar mediante el avance de la propia máquina. También puede limpiar pistas, alimentar instalaciones o manipular materiales con accesorios autorizados. La conducción debe hacerse con el equipo bajo, velocidad adaptada y bastidores alineados al penetrar en el acopio.', array['La pala cargadora es una máquina autopropulsada, normalmente sobre ruedas, con un equipo frontal destinado principalmente a cargar mediante el avance de la propia máquina.', 'También puede limpiar pistas, alimentar instalaciones o manipular materiales con accesorios autorizados.', 'La conducción debe hacerse con el equipo bajo, velocidad adaptada y bastidores alineados al penetrar en el acopio.']::text[]),
  (5, 5, 'Excavadora hidráulica de cadenas: definición y funciones', 'La excavadora hidráulica de cadenas dispone de una superestructura que normalmente gira trescientos sesenta grados sobre un tren de rodaje. Es adecuada para trabajar desde una plataforma estable, formar frentes, abrir zanjas y cargar vehículos situados dentro de su alcance. Antes de comenzar, el operador debe comprobar la capacidad portante del terreno, mantener el tren de rodaje bien apoyado y delimitar el radio de giro para impedir el acceso de personas.', array['La excavadora hidráulica de cadenas dispone de una superestructura que normalmente gira trescientos sesenta grados sobre un tren de rodaje.', 'Es adecuada para trabajar desde una plataforma estable, formar frentes, abrir zanjas y cargar vehículos situados dentro de su alcance.', 'Antes de comenzar, el operador debe comprobar la capacidad portante del terreno, mantener el tren de rodaje bien apoyado y delimitar el radio de giro para impedir el acceso de personas.']::text[]),
  (6, 6, 'Tractor de cadenas: definición y aplicaciones', 'El tractor de cadenas es una máquina autopropulsada equipada con una hoja para cortar, empujar y nivelar materiales, o con equipos que ejercen fuerza de empuje o tracción. Puede incorporar escarificador para ripar terrenos compactos o roca blanda, acondicionar pistas, conformar escombreras y apoyar la recuperación de otras máquinas cuando existe un procedimiento autorizado. El operador debe conocer la pendiente máxima permitida, evitar giros bruscos en laderas, mantener distancia a coronaciones y no utilizar el tractor como equipo de remolque o elevación fuera de las condiciones definidas por el fabricante y la explotación.', array['El tractor de cadenas es una máquina autopropulsada equipada con una hoja para cortar, empujar y nivelar materiales, o con equipos que ejercen fuerza de empuje o tracción.', 'Puede incorporar escarificador para ripar terrenos compactos o roca blanda, acondicionar pistas, conformar escombreras y apoyar la recuperación de otras máquinas cuando existe un procedimiento autorizado.', 'El operador debe conocer la pendiente máxima permitida, evitar giros bruscos en laderas, mantener distancia a coronaciones y no utilizar el tractor como equipo de remolque o elevación fuera de las condiciones definidas por el fabricante y la explotación.']::text[]),
  (7, 7, 'Máquina base, equipos y accesorios', 'La máquina base es el conjunto autopropulsado sin los implementos que determinan la tarea. Un accesorio compatible físicamente no es necesariamente seguro: debe estar autorizado por el fabricante o evaluado técnicamente, tener capacidad adecuada y utilizar el sistema de acoplamiento previsto. Nunca se trabaja confiando solo en que el enganche parece cerrado.', array['La máquina base es el conjunto autopropulsado sin los implementos que determinan la tarea.', 'Un accesorio compatible físicamente no es necesariamente seguro: debe estar autorizado por el fabricante o evaluado técnicamente, tener capacidad adecuada y utilizar el sistema de acoplamiento previsto.', 'Nunca se trabaja confiando solo en que el enganche parece cerrado.']::text[]),
  (8, 8, 'Tareas comunes del operador', 'Además de manejar la máquina, el operador realiza tareas preventivas esenciales: inspección diaria, comprobación de niveles, limpieza de elementos de visibilidad, comunicación de defectos y mantenimiento básico autorizado. Estas obligaciones no convierten al operador en mecánico. La responsabilidad del operador consiste en detectar, informar y no utilizar una máquina cuando un defecto pueda comprometer la seguridad propia o la de terceros.', array['Además de manejar la máquina, el operador realiza tareas preventivas esenciales: inspección diaria, comprobación de niveles, limpieza de elementos de visibilidad, comunicación de defectos y mantenimiento básico autorizado.', 'Estas obligaciones no convierten al operador en mecánico.', 'La responsabilidad del operador consiste en detectar, informar y no utilizar una máquina cuando un defecto pueda comprometer la seguridad propia o la de terceros.']::text[]),
  (9, 9, 'Planificación, autorización y DIS', 'El trabajo comienza antes de subir a la cabina. Estas reglas concretan la circulación, prioridades, velocidades, comunicaciones, mantenimiento, vertido, trabajos cerca de líneas eléctricas y actuación ante emergencias. La acción correcta es detenerse en una zona segura, comunicar la desviación y obtener instrucciones antes de continuar.', array['El trabajo comienza antes de subir a la cabina.', 'Estas reglas concretan la circulación, prioridades, velocidades, comunicaciones, mantenimiento, vertido, trabajos cerca de líneas eléctricas y actuación ante emergencias.', 'La acción correcta es detenerse en una zona segura, comunicar la desviación y obtener instrucciones antes de continuar.']::text[]),
  (10, 10, 'El ciclo de trabajo como sistema preventivo', 'Un ciclo seguro integra persona, máquina, material y entorno. La productividad no consiste en acelerar cada movimiento, sino en mantener un flujo uniforme sin golpes, derrames, esperas ni correcciones peligrosas. La seguridad forma parte de la operación, no es una comprobación separada.', array['Un ciclo seguro integra persona, máquina, material y entorno.', 'La productividad no consiste en acelerar cada movimiento, sino en mantener un flujo uniforme sin golpes, derrames, esperas ni correcciones peligrosas.', 'La seguridad forma parte de la operación, no es una comprobación separada.']::text[]);

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
      || '/slides/course-4-20260813-v3/block-1/%';

  if object_count <> 10 then
    raise exception 'Curso 4, bloque 1: se esperaban 10 imágenes y existen %.', object_count;
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
  and module.position = 1
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
  and module.position = 1
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
  and module.position = 1
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
  version.id::text || '/slides/course-4-20260813-v3/block-1/audio-1-'
    || lpad(detail.part_position::text, 2, '0') || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
  detail.source_page::text,
  'Curso 4, bloque 1, parte 1.' || detail.part_position::text
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module on module.course_version_id = version.id and module.position = 1
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
  join public.course_modules module on module.course_version_id = version.id and module.position = 1
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
    raise exception 'Curso 4, bloque 1 incompleto: % partes, % diapositivas, % fichas.',
      updated_segments, updated_slides, updated_notes;
  end if;
end $$;

commit;
