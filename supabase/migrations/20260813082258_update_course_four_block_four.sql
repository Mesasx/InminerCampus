-- Actualiza el bloque 4 del curso 4 con la presentación oficial de 50 diapositivas.

begin;

create temporary table course_four_slide_updates (
  part_position integer primary key,
  source_page integer not null,
  title text not null,
  summary text not null,
  key_points text[] not null
) on commit drop;

insert into course_four_slide_updates values
  (1, 31, 'Motor, refrigeración y lubricación', 'El motor transforma la energía del combustible en movimiento y calor. Una temperatura alta puede deberse a radiadores obstruidos, nivel insuficiente o avería del ventilador; continuar trabajando puede causar incendio o rotura grave. Nunca se elimina una alarma sin haber identificado y corregido su causa.', array['El motor transforma la energía del combustible en movimiento y calor.', 'Una temperatura alta puede deberse a radiadores obstruidos, nivel insuficiente o avería del ventilador; continuar trabajando puede causar incendio o rotura grave.', 'Nunca se elimina una alarma sin haber identificado y corregido su causa.']::text[]),
  (2, 32, 'Transmisión, articulación y tracción', 'La transmisión entrega la potencia a ruedas o cadenas y permite adaptar velocidad y esfuerzo. Diferenciales y sistemas de tracción mejoran la movilidad, pero no compensan un firme sin capacidad ni una pendiente excesiva. Cualquier tirón, ruido o pérdida de tracción anormal se comunica antes de que evolucione a una avería peligrosa.', array['La transmisión entrega la potencia a ruedas o cadenas y permite adaptar velocidad y esfuerzo.', 'Diferenciales y sistemas de tracción mejoran la movilidad, pero no compensan un firme sin capacidad ni una pendiente excesiva.', 'Cualquier tirón, ruido o pérdida de tracción anormal se comunica antes de que evolucione a una avería peligrosa.']::text[]),
  (3, 33, 'Sistema hidráulico y energía acumulada', 'El sistema hidráulico transmite grandes fuerzas mediante fluido a presión. Por eso, antes de intervenir se apoya el equipo, se descarga la presión según el procedimiento y se bloquean los movimientos posibles. Si un mando responde con retraso, aparecen movimientos espontáneos o baja el equipo sin orden, la máquina se retira de servicio hasta que personal competente revise el circuito.', array['El sistema hidráulico transmite grandes fuerzas mediante fluido a presión.', 'Por eso, antes de intervenir se apoya el equipo, se descarga la presión según el procedimiento y se bloquean los movimientos posibles.', 'Si un mando responde con retraso, aparecen movimientos espontáneos o baja el equipo sin orden, la máquina se retira de servicio hasta que personal competente revise el circuito.']::text[]),
  (4, 34, 'Equipos de trabajo, accesorios y capacidades', 'Cada accesorio cambia la geometría y las prestaciones de la máquina. Antes de utilizarlo se comprueban compatibilidad, peso, presión y caudal requeridos, dispositivos de retención y limitaciones del manual. Si cambia el material o el alcance, se vuelve a evaluar la capacidad y estabilidad.', array['Cada accesorio cambia la geometría y las prestaciones de la máquina.', 'Antes de utilizarlo se comprueban compatibilidad, peso, presión y caudal requeridos, dispositivos de retención y limitaciones del manual.', 'Si cambia el material o el alcance, se vuelve a evaluar la capacidad y estabilidad.']::text[]),
  (5, 35, 'Neumáticos, cadenas y contacto con el terreno', 'Los neumáticos y el tren de rodaje son el único contacto de la máquina con el terreno. En palas, una presión incorrecta o un corte puede provocar pérdida de control y calentamiento. Antes de trabajar sobre rellenos, bordes o plataformas recientes se confirma su capacidad portante y se evita concentrar cargas cerca de zonas debilitadas.', array['Los neumáticos y el tren de rodaje son el único contacto de la máquina con el terreno.', 'En palas, una presión incorrecta o un corte puede provocar pérdida de control y calentamiento.', 'Antes de trabajar sobre rellenos, bordes o plataformas recientes se confirma su capacidad portante y se evita concentrar cargas cerca de zonas debilitadas.']::text[]),
  (6, 36, 'Frenos, dirección y control de movimiento', 'La pala dispone de freno de servicio, estacionamiento y, según su diseño, sistema de emergencia. En la excavadora, el control de giro y los bloqueos hidráulicos evitan movimientos no deseados. Si la respuesta cambia, aumenta el recorrido del pedal o aparece una alarma, se estaciona en un lugar seguro y se solicita revisión.', array['La pala dispone de freno de servicio, estacionamiento y, según su diseño, sistema de emergencia.', 'En la excavadora, el control de giro y los bloqueos hidráulicos evitan movimientos no deseados.', 'Si la respuesta cambia, aumenta el recorrido del pedal o aparece una alarma, se estaciona en un lugar seguro y se solicita revisión.']::text[]),
  (7, 37, 'ROPS, FOPS y cinturón de seguridad', 'Las estructuras ROPS protegen el espacio del operador en caso de vuelco y las FOPS frente a caída de objetos, dentro de las condiciones para las que fueron diseñadas. Puertas, cristales y anclajes forman parte del conjunto de protección. Después de un vuelco, impacto importante o daño visible, la estructura requiere evaluación; no basta con enderezar una parte deformada y volver al servicio.', array['Las estructuras ROPS protegen el espacio del operador en caso de vuelco y las FOPS frente a caída de objetos, dentro de las condiciones para las que fueron diseñadas.', 'Puertas, cristales y anclajes forman parte del conjunto de protección.', 'Después de un vuelco, impacto importante o daño visible, la estructura requiere evaluación; no basta con enderezar una parte deformada y volver al servicio.']::text[]),
  (8, 38, 'Bloqueos, resguardos y prevención del movimiento', 'Los bloqueos mecánicos del equipo, bastidor articulado o superestructura evitan movimientos causados por pérdida de presión, accionamiento involuntario o gravedad. Los resguardos separan a las personas de correas, ventiladores y elementos giratorios. Al finalizar, se comprueba que herramientas, soportes y personas estén fuera antes de retirar bloqueos y devolver la máquina a servicio.', array['Los bloqueos mecánicos del equipo, bastidor articulado o superestructura evitan movimientos causados por pérdida de presión, accionamiento involuntario o gravedad.', 'Los resguardos separan a las personas de correas, ventiladores y elementos giratorios.', 'Al finalizar, se comprueba que herramientas, soportes y personas estén fuera antes de retirar bloqueos y devolver la máquina a servicio.']::text[]),
  (9, 39, 'Instrumentos, alarmas y dispositivos de aviso', 'Manómetros, termómetros, indicadores de nivel y paneles de alarma informan del estado de los sistemas principales. Bocina, alarma de retroceso, luces, rotativos, cámaras y espejos ayudan a comunicar el movimiento y ampliar la visión. Tapar una luz o desconectar una alarma elimina información esencial y puede ocultar un fallo progresivo.', array['Manómetros, termómetros, indicadores de nivel y paneles de alarma informan del estado de los sistemas principales.', 'Bocina, alarma de retroceso, luces, rotativos, cámaras y espejos ayudan a comunicar el movimiento y ampliar la visión.', 'Tapar una luz o desconectar una alarma elimina información esencial y puede ocultar un fallo progresivo.']::text[]),
  (10, 40, 'Manual del fabricante y adecuación al Real Decreto 1215/1997', 'El manual de instrucciones define el uso previsto, capacidades, mantenimiento, advertencias y procedimientos de emergencia de cada modelo. Las máquinas puestas a disposición de los trabajadores deben cumplir las disposiciones aplicables del Real Decreto 1215/1997, incluyendo mandos seguros, protección frente a vuelco o caída de objetos, frenado, visibilidad y prevención del acceso a partes peligrosas. Ante una contradicción, prevalecen las limitaciones más seguras y se consulta al responsable técnico.', array['El manual de instrucciones define el uso previsto, capacidades, mantenimiento, advertencias y procedimientos de emergencia de cada modelo.', 'Las máquinas puestas a disposición de los trabajadores deben cumplir las disposiciones aplicables del Real Decreto 1215/1997, incluyendo mandos seguros, protección frente a vuelco o caída de objetos, frenado, visibilidad y prevención del acceso a partes peligrosas.', 'Ante una contradicción, prevalecen las limitaciones más seguras y se consulta al responsable técnico.']::text[]);

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
      || '/slides/course-4-20260813-v3/block-4/%';

  if object_count <> 10 then
    raise exception 'Curso 4, bloque 4: se esperaban 10 imágenes y existen %.', object_count;
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
  and module.position = 4
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
  and module.position = 4
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
  and module.position = 4
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
  version.id::text || '/slides/course-4-20260813-v3/block-4/audio-4-'
    || lpad(detail.part_position::text, 2, '0') || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
  detail.source_page::text,
  'Curso 4, bloque 4, parte 4.' || detail.part_position::text
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module on module.course_version_id = version.id and module.position = 4
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
  join public.course_modules module on module.course_version_id = version.id and module.position = 4
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
    raise exception 'Curso 4, bloque 4 incompleto: % partes, % diapositivas, % fichas.',
      updated_segments, updated_slides, updated_notes;
  end if;
end $$;

commit;
