-- Actualiza el bloque 3 del curso 4 con la presentación oficial de 50 diapositivas.

begin;

create temporary table course_four_slide_updates (
  part_position integer primary key,
  source_page integer not null,
  title text not null,
  summary text not null,
  key_points text[] not null
) on commit drop;

insert into course_four_slide_updates values
  (1, 21, 'Arranque, calentamiento y preparación operativa', 'El motor se arranca desde el puesto del operador, con los mandos neutralizados y después de confirmar que no hay nadie alrededor. Durante el calentamiento se vigilan presión de aceite, temperatura, carga eléctrica y mensajes del panel. Si la máquina produce humo anormal, golpeteos o una alarma persistente, se detiene y se informa antes de iniciar el trabajo.', array['El motor se arranca desde el puesto del operador, con los mandos neutralizados y después de confirmar que no hay nadie alrededor.', 'Durante el calentamiento se vigilan presión de aceite, temperatura, carga eléctrica y mensajes del panel.', 'Si la máquina produce humo anormal, golpeteos o una alarma persistente, se detiene y se informa antes de iniciar el trabajo.']::text[]),
  (2, 22, 'Visibilidad, zonas ciegas y control del área', 'Las máquinas grandes tienen zonas ciegas que pueden ocultar por completo a una persona o a un vehículo ligero. Cuando la maniobra no puede controlarse desde la cabina, interviene un señalista identificado, situado en un lugar visible y utilizando señales acordadas. El radio de giro y la zona bajo el equipo de trabajo se mantienen libres.', array['Las máquinas grandes tienen zonas ciegas que pueden ocultar por completo a una persona o a un vehículo ligero.', 'Cuando la maniobra no puede controlarse desde la cabina, interviene un señalista identificado, situado en un lugar visible y utilizando señales acordadas.', 'El radio de giro y la zona bajo el equipo de trabajo se mantienen libres.']::text[]),
  (3, 23, 'Carga segura con pala cargadora', 'Para cargar con pala, se aproxima el cucharón bajo y con los bastidores alineados. Tras el llenado se inclina el cucharón para retener el material y se retrocede mirando la trayectoria. El operador distribuye la carga de forma uniforme siguiendo la comunicación establecida con el conductor.', array['Para cargar con pala, se aproxima el cucharón bajo y con los bastidores alineados.', 'Tras el llenado se inclina el cucharón para retener el material y se retrocede mirando la trayectoria.', 'El operador distribuye la carga de forma uniforme siguiendo la comunicación establecida con el conductor.']::text[]),
  (4, 24, 'Excavación y carga con excavadora hidráulica', 'La excavadora trabaja sobre una plataforma resistente, nivelada y con espacio para el giro. El vehículo de transporte se coloca fuera de la zona de caída de material y, cuando sea posible, de forma que la cuchara no pase sobre la cabina. Si el operador pierde visibilidad del camión o de la persona que dirige la maniobra, detiene el ciclo hasta recuperar una comunicación segura.', array['La excavadora trabaja sobre una plataforma resistente, nivelada y con espacio para el giro.', 'El vehículo de transporte se coloca fuera de la zona de caída de material y, cuando sea posible, de forma que la cuchara no pase sobre la cabina.', 'Si el operador pierde visibilidad del camión o de la persona que dirige la maniobra, detiene el ciclo hasta recuperar una comunicación segura.']::text[]),
  (5, 25, 'Operación segura con tractor de cadenas', 'Con el tractor se empuja o ripa manteniendo una trayectoria que preserve la estabilidad. La hoja se lleva baja durante los desplazamientos y nunca se utiliza como freno improvisado salvo en una emergencia contemplada. Al ripar se evita enganchar obstáculos desconocidos y se detiene la operación si aparecen vibraciones, pérdida de control o una resistencia superior a la prevista.', array['Con el tractor se empuja o ripa manteniendo una trayectoria que preserve la estabilidad.', 'La hoja se lleva baja durante los desplazamientos y nunca se utiliza como freno improvisado salvo en una emergencia contemplada.', 'Al ripar se evita enganchar obstáculos desconocidos y se detiene la operación si aparecen vibraciones, pérdida de control o una resistencia superior a la prevista.']::text[]),
  (6, 26, 'Circulación por pistas, rampas y cruces', 'La velocidad se adapta a la carga, visibilidad, anchura, pendiente, firme y tráfico; el límite indicado es un máximo, no una velocidad obligatoria. En rampas se utiliza la marcha y el sistema de retención recomendados, sin circular en punto muerto. Polvo, lluvia, barro o baches obligan a reducir la velocidad o detener la circulación.', array['La velocidad se adapta a la carga, visibilidad, anchura, pendiente, firme y tráfico; el límite indicado es un máximo, no una velocidad obligatoria.', 'En rampas se utiliza la marcha y el sistema de retención recomendados, sin circular en punto muerto.', 'Polvo, lluvia, barro o baches obligan a reducir la velocidad o detener la circulación.']::text[]),
  (7, 27, 'Taludes, frentes, zanjas y bordes', 'El terreno próximo a un talud o una zanja puede fallar sin que el borde aparente se mueva. En zanjas se identifican servicios, se controla la estabilidad y se aplican entibación, taludes o accesos seguros cuando correspondan. Si aparecen grietas, caída de pequeños fragmentos o deformaciones, se retira el equipo a una zona segura y se informa; continuar para terminar una pasada puede agravar el fallo.', array['El terreno próximo a un talud o una zanja puede fallar sin que el borde aparente se mueva.', 'En zanjas se identifican servicios, se controla la estabilidad y se aplican entibación, taludes o accesos seguros cuando correspondan.', 'Si aparecen grietas, caída de pequeños fragmentos o deformaciones, se retira el equipo a una zona segura y se informa; continuar para terminar una pasada puede agravar el fallo.']::text[]),
  (8, 28, 'Descarga en camiones, tolvas y acopios', 'La descarga exige coordinación y control de la trayectoria del material. No se empuja material mientras haya personas en el punto de vertido. La limpieza o desatasco se efectúa con el equipo parado, aislado y conforme al procedimiento específico de la instalación.', array['La descarga exige coordinación y control de la trayectoria del material.', 'No se empuja material mientras haya personas en el punto de vertido.', 'La limpieza o desatasco se efectúa con el equipo parado, aislado y conforme al procedimiento específico de la instalación.']::text[]),
  (9, 29, 'Elevación de cargas con maquinaria', 'Una pala o excavadora solo puede elevar cargas cuando el fabricante lo permite, el equipo está configurado para esa función y la explotación dispone del procedimiento correspondiente. La carga se engancha en puntos previstos con accesorios de elevación certificados; nunca en dientes, cucharas o elementos no diseñados. Las cargas se desplazan bajas, lentamente y sin tirones, considerando pendiente, viento y estabilidad del terreno.', array['Una pala o excavadora solo puede elevar cargas cuando el fabricante lo permite, el equipo está configurado para esa función y la explotación dispone del procedimiento correspondiente.', 'La carga se engancha en puntos previstos con accesorios de elevación certificados; nunca en dientes, cucharas o elementos no diseñados.', 'Las cargas se desplazan bajas, lentamente y sin tirones, considerando pendiente, viento y estabilidad del terreno.']::text[]),
  (10, 30, 'Estacionamiento, parada y comunicación de incidencias', 'Al terminar, la máquina se estaciona en la zona designada, sobre terreno firme y preferentemente horizontal. Se retira la llave, se cierra la cabina y se colocan calzos cuando el procedimiento lo exija. Si afecta a la seguridad, la máquina permanece señalizada y fuera de servicio.', array['Al terminar, la máquina se estaciona en la zona designada, sobre terreno firme y preferentemente horizontal.', 'Se retira la llave, se cierra la cabina y se colocan calzos cuando el procedimiento lo exija.', 'Si afecta a la seguridad, la máquina permanece señalizada y fuera de servicio.']::text[]);

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
      || '/slides/course-4-20260813-v3/block-3/%';

  if object_count <> 10 then
    raise exception 'Curso 4, bloque 3: se esperaban 10 imágenes y existen %.', object_count;
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
  and module.position = 3
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
  and module.position = 3
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
  and module.position = 3
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
  version.id::text || '/slides/course-4-20260813-v3/block-3/audio-3-'
    || lpad(detail.part_position::text, 2, '0') || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
  detail.source_page::text,
  'Curso 4, bloque 3, parte 3.' || detail.part_position::text
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module on module.course_version_id = version.id and module.position = 3
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
  join public.course_modules module on module.course_version_id = version.id and module.position = 3
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
    raise exception 'Curso 4, bloque 3 incompleto: % partes, % diapositivas, % fichas.',
      updated_segments, updated_slides, updated_notes;
  end if;
end $$;

commit;
