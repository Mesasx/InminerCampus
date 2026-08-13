-- Actualiza el bloque 5 del curso 4 con la presentación oficial de 50 diapositivas.

begin;

create temporary table course_four_slide_updates (
  part_position integer primary key,
  source_page integer not null,
  title text not null,
  summary text not null,
  key_points text[] not null
) on commit drop;

insert into course_four_slide_updates values
  (1, 41, 'Vigilancia de frentes, plataformas y taludes', 'El lugar de trabajo cambia durante la jornada. La inspección debe repetirse después de lluvia intensa, heladas, voladuras o trabajos que alteren el terreno. La continuidad de la producción no debe anteponerse a una señal de inestabilidad.', array['El lugar de trabajo cambia durante la jornada.', 'La inspección debe repetirse después de lluvia intensa, heladas, voladuras o trabajos que alteren el terreno.', 'La continuidad de la producción no debe anteponerse a una señal de inestabilidad.']::text[]),
  (2, 42, 'Pistas, bermas, drenaje y control del polvo', 'Las pistas deben mantener anchura, pendiente, firme, visibilidad y drenaje compatibles con los equipos que circulan. Las bermas ayudan a delimitar y contener, pero no son un sistema de frenado ni garantizan que el borde soporte una máquina. Si una pista no permite circular con seguridad, se detiene su uso hasta corregirla, en lugar de confiar en la experiencia individual para superar una condición deficiente.', array['Las pistas deben mantener anchura, pendiente, firme, visibilidad y drenaje compatibles con los equipos que circulan.', 'Las bermas ayudan a delimitar y contener, pero no son un sistema de frenado ni garantizan que el borde soporte una máquina.', 'Si una pista no permite circular con seguridad, se detiene su uso hasta corregirla, en lugar de confiar en la experiencia individual para superar una condición deficiente.']::text[]),
  (3, 43, 'Interferencia entre pala cargadora y camión', 'La carga de un camión combina dos equipos con zonas ciegas y trayectorias distintas. Se evita pasar el cucharón sobre la cabina y se distribuye el material sin golpes. Si aparece una persona, se pierde contacto visual o un vehículo cambia de posición sin aviso, la operación se detiene y se restablece la coordinación.', array['La carga de un camión combina dos equipos con zonas ciegas y trayectorias distintas.', 'Se evita pasar el cucharón sobre la cabina y se distribuye el material sin golpes.', 'Si aparece una persona, se pierde contacto visual o un vehículo cambia de posición sin aviso, la operación se detiene y se restablece la coordinación.']::text[]),
  (4, 44, 'Interferencia entre excavadora y vehículo de transporte', 'La excavadora necesita un radio de giro despejado y un punto estable para el camión. El conductor permanece donde establezca el procedimiento y no mueve el camión hasta recibir la señal. Una única persona dirige la maniobra y cualquier pérdida de comunicación implica parada inmediata.', array['La excavadora necesita un radio de giro despejado y un punto estable para el camión.', 'El conductor permanece donde establezca el procedimiento y no mueve el camión hasta recibir la señal.', 'Una única persona dirige la maniobra y cualquier pérdida de comunicación implica parada inmediata.']::text[]),
  (5, 45, 'Personal de tierra, señalistas y comunicaciones', 'Las personas a pie son especialmente vulnerables frente a maquinaria móvil. El señalista utiliza señales acordadas, se mantiene visible y nunca se coloca entre la máquina y un obstáculo. Si varias personas dan instrucciones, se detiene el trabajo hasta designar un único interlocutor.', array['Las personas a pie son especialmente vulnerables frente a maquinaria móvil.', 'El señalista utiliza señales acordadas, se mantiene visible y nunca se coloca entre la máquina y un obstáculo.', 'Si varias personas dan instrucciones, se detiene el trabajo hasta designar un único interlocutor.']::text[]),
  (6, 46, 'Trabajos próximos a líneas eléctricas', 'Una línea aérea puede producir arco eléctrico sin contacto directo. La explotación debe señalizar la aproximación -el material del curso utiliza aviso previo de veinticinco metros- y puede requerir pórticos, limitadores, vigilancia o desenergización. Si una máquina entra en contacto, el operador permanece en la cabina salvo incendio u otro peligro inmediato y se sigue el plan de emergencia para evitar tensiones de paso.', array['Una línea aérea puede producir arco eléctrico sin contacto directo.', 'La explotación debe señalizar la aproximación -el material del curso utiliza aviso previo de veinticinco metros- y puede requerir pórticos, limitadores, vigilancia o desenergización.', 'Si una máquina entra en contacto, el operador permanece en la cabina salvo incendio u otro peligro inmediato y se sigue el plan de emergencia para evitar tensiones de paso.']::text[]),
  (7, 47, 'Interferencias durante mantenimiento y reparación', 'Las reparaciones generan riesgos diferentes a la producción: equipos elevados, pruebas con motor en marcha, presencia de técnicos y energías liberadas. La llave y los dispositivos de consignación no se entregan ni se eliminan sin autorización. Tras la reparación se realiza una entrega formal e inspección funcional antes de volver a producir.', array['Las reparaciones generan riesgos diferentes a la producción: equipos elevados, pruebas con motor en marcha, presencia de técnicos y energías liberadas.', 'La llave y los dispositivos de consignación no se entregan ni se eliminan sin autorización.', 'Tras la reparación se realiza una entrega formal e inspección funcional antes de volver a producir.']::text[]),
  (8, 48, 'Incendio, primeros auxilios y conducta PAS', 'Ante un accidente se aplica la conducta PAS: proteger, avisar y socorrer. En un incendio incipiente puede utilizarse el extintor si existe vía de escape y no se asume un riesgo adicional. Toda máquina debe permitir localizar con rapidez extintor, botiquín, salida alternativa y medios de comunicación.', array['Ante un accidente se aplica la conducta PAS: proteger, avisar y socorrer.', 'En un incendio incipiente puede utilizarse el extintor si existe vía de escape y no se asume un riesgo adicional.', 'Toda máquina debe permitir localizar con rapidez extintor, botiquín, salida alternativa y medios de comunicación.']::text[]),
  (9, 49, 'Plan de emergencia y evacuación', 'El plan de emergencia define alarmas, responsables, comunicaciones, vías de evacuación y puntos de reunión. En una evacuación no se improvisan rutas a través de frentes, taludes o zonas de tráfico. El objetivo no es buscar culpables, sino identificar fallos técnicos u organizativos y evitar que la situación se repita.', array['El plan de emergencia define alarmas, responsables, comunicaciones, vías de evacuación y puntos de reunión.', 'En una evacuación no se improvisan rutas a través de frentes, taludes o zonas de tráfico.', 'El objetivo no es buscar culpables, sino identificar fallos técnicos u organizativos y evitar que la situación se repita.']::text[]),
  (10, 50, 'Marco normativo, derechos y obligaciones', 'Esta formación se encuadra en la ITC 02.1.02 y en la Especificación Técnica 2001-1-08 para operadores de maquinaria de arranque, carga y viales. La formación inicial tiene veinte horas y la frecuencia máxima obligatoria indicada por la especificación es de dos años. El trabajador debe utilizar correctamente la máquina, los dispositivos y los EPI, respetar las DIS y comunicar de inmediato cualquier situación que pueda suponer un riesgo grave.', array['Esta formación se encuadra en la ITC 02.1.02 y en la Especificación Técnica 2001-1-08 para operadores de maquinaria de arranque, carga y viales.', 'La formación inicial tiene veinte horas y la frecuencia máxima obligatoria indicada por la especificación es de dos años.', 'El trabajador debe utilizar correctamente la máquina, los dispositivos y los EPI, respetar las DIS y comunicar de inmediato cualquier situación que pueda suponer un riesgo grave.']::text[]);

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
      || '/slides/course-4-20260813-v3/block-5/%';

  if object_count <> 10 then
    raise exception 'Curso 4, bloque 5: se esperaban 10 imágenes y existen %.', object_count;
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
  and module.position = 5
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
  and module.position = 5
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
  and module.position = 5
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
  version.id::text || '/slides/course-4-20260813-v3/block-5/audio-5-'
    || lpad(detail.part_position::text, 2, '0') || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
  detail.source_page::text,
  'Curso 4, bloque 5, parte 5.' || detail.part_position::text
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module on module.course_version_id = version.id and module.position = 5
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
  join public.course_modules module on module.course_version_id = version.id and module.position = 5
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
    raise exception 'Curso 4, bloque 5 incompleto: % partes, % diapositivas, % fichas.',
      updated_segments, updated_slides, updated_notes;
  end if;
end $$;

commit;
