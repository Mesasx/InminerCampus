-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 3/20 a partir de sus fuentes.

begin;

create temporary table course_part_details (
  slug text not null,
  duration_hours integer not null,
  block_position integer not null,
  part_position integer not null,
  summary text not null,
  key_points text[] not null,
  stop_criterion text not null,
  source_label text not null,
  source_pages text not null,
  narration_text text not null,
  overview_body text not null,
  detail_body text not null,
  primary key (slug, duration_hours, block_position, part_position)
) on commit drop;

insert into course_part_details values
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 1, 'Antes de arrancar debe realizarse la inspección previa y cumplimentarse el parte o lista de control establecido por la empresa. La revisión permite detectar fugas, daños y fallos en los sistemas mecánicos y de seguridad antes de poner la unidad en servicio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Antes de arrancar debe realizarse la inspección previa y cumplimentarse el parte o lista de control establecido por la empresa', 'La revisión permite detectar fugas, daños y fallos en los sistemas mecánicos y de seguridad antes de poner la unidad en servicio', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '28–38', 'Antes de arrancar debe realizarse la inspección previa y cumplimentarse el parte o lista de control establecido por la empresa. La revisión permite detectar fugas, daños y fallos en los sistemas mecánicos y de seguridad antes de poner la unidad en servicio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Antes de arrancar debe realizarse la inspección previa y cumplimentarse el parte o lista de control establecido por la empresa. La revisión permite detectar fugas, daños y fallos en los sistemas mecánicos y de seguridad antes de poner la unidad en servicio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 2, 'Observe el suelo y la parte inferior de la unidad para detectar pérdidas de agua, aceite, combustible u otros fluidos. Manténgase fuera de zonas de atrapamiento, utilice el casco y comunique cualquier fuga antes de iniciar el trabajo. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Observe el suelo y la parte inferior de la unidad para detectar pérdidas de agua, aceite, combustible u otros fluidos', 'Manténgase fuera de zonas de atrapamiento, utilice el casco y comunique cualquier fuga antes de iniciar el trabajo', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Manténgase fuera de zonas de atrapamiento, utilice el casco y comunique cualquier fuga antes de iniciar el trabajo.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '28–37', 'Observe el suelo y la parte inferior de la unidad para detectar pérdidas de agua, aceite, combustible u otros fluidos. Manténgase fuera de zonas de atrapamiento, utilice el casco y comunique cualquier fuga antes de iniciar el trabajo. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Observe el suelo y la parte inferior de la unidad para detectar pérdidas de agua, aceite, combustible u otros fluidos. Manténgase fuera de zonas de atrapamiento, utilice el casco y comunique cualquier fuga antes de iniciar el trabajo. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 3, 'Revise en frío la banda de rodadura, los flancos, los cortes y los tornillos de las ruedas. Use guantes y no se coloque frente al neumático al comprobar la presión: la posición segura es paralela y por su parte posterior. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Revise en frío la banda de rodadura, los flancos, los cortes y los tornillos de las ruedas', 'Use guantes y no se coloque frente al neumático al comprobar la presión: la posición segura es paralela y por su parte posterior', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '31–37 y 190–197', 'Revise en frío la banda de rodadura, los flancos, los cortes y los tornillos de las ruedas. Use guantes y no se coloque frente al neumático al comprobar la presión: la posición segura es paralela y por su parte posterior. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Revise en frío la banda de rodadura, los flancos, los cortes y los tornillos de las ruedas. Use guantes y no se coloque frente al neumático al comprobar la presión: la posición segura es paralela y por su parte posterior. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 4, 'El calor excesivo, una presión incorrecta o un uso inadecuado de los frenos pueden provocar una explosión del neumático. El inflado debe realizarse en frío, desde una posición protegida y según el fabricante; el manual contempla el nitrógeno como opción preventiva frente a la combustión interna. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El calor excesivo, una presión incorrecta o un uso inadecuado de los frenos pueden provocar una explosión del neumático', 'El inflado debe realizarse en frío, desde una posición protegida y según el fabricante', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '31–37 y 190–197', 'El calor excesivo, una presión incorrecta o un uso inadecuado de los frenos pueden provocar una explosión del neumático. El inflado debe realizarse en frío, desde una posición protegida y según el fabricante; el manual contempla el nitrógeno como opción preventiva frente a la combustión interna. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El calor excesivo, una presión incorrecta o un uso inadecuado de los frenos pueden provocar una explosión del neumático. El inflado debe realizarse en frío, desde una posición protegida y según el fabricante; el manual contempla el nitrógeno como opción preventiva frente a la combustión interna. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 5, 'Compruebe el freno de servicio, el de estacionamiento y el sistema de emergencia conforme al manual. En los volquetes, el freno de emergencia debe poder actuar, manual o automáticamente, si falla el freno de servicio o existe riesgo inminente. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Compruebe el freno de servicio, el de estacionamiento y el sistema de emergencia conforme al manual', 'En los volquetes, el freno de emergencia debe poder actuar, manual o automáticamente, si falla el freno de servicio o existe riesgo inminente', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '28–37 y 160–171', 'Compruebe el freno de servicio, el de estacionamiento y el sistema de emergencia conforme al manual. En los volquetes, el freno de emergencia debe poder actuar, manual o automáticamente, si falla el freno de servicio o existe riesgo inminente. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Compruebe el freno de servicio, el de estacionamiento y el sistema de emergencia conforme al manual. En los volquetes, el freno de emergencia debe poder actuar, manual o automáticamente, si falla el freno de servicio o existe riesgo inminente. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 6, 'Mantenga limpios los cristales, las luces y los espejos retrovisores, y compruebe su estado y regulación. Una visibilidad deficiente aumenta el riesgo en los ángulos muertos, especialmente durante las maniobras y la marcha atrás. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Mantenga limpios los cristales, las luces y los espejos retrovisores, y compruebe su estado y regulación', 'Una visibilidad deficiente aumenta el riesgo en los ángulos muertos, especialmente durante las maniobras y la marcha atrás', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '28–37 y 210', 'Mantenga limpios los cristales, las luces y los espejos retrovisores, y compruebe su estado y regulación. Una visibilidad deficiente aumenta el riesgo en los ángulos muertos, especialmente durante las maniobras y la marcha atrás. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Mantenga limpios los cristales, las luces y los espejos retrovisores, y compruebe su estado y regulación. Una visibilidad deficiente aumenta el riesgo en los ángulos muertos, especialmente durante las maniobras y la marcha atrás. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 7, 'Suba y baje de cara a la máquina, utilizando todos los peldaños y asideros y manteniendo tres puntos de apoyo. Lleve las manos libres y evite anillos, colgantes o prendas sueltas que puedan engancharse. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Suba y baje de cara a la máquina, utilizando todos los peldaños y asideros y manteniendo tres puntos de apoyo', 'Lleve las manos libres y evite anillos, colgantes o prendas sueltas que puedan engancharse', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '49–50', 'Suba y baje de cara a la máquina, utilizando todos los peldaños y asideros y manteniendo tres puntos de apoyo. Lleve las manos libres y evite anillos, colgantes o prendas sueltas que puedan engancharse. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Suba y baje de cara a la máquina, utilizando todos los peldaños y asideros y manteniendo tres puntos de apoyo. Lleve las manos libres y evite anillos, colgantes o prendas sueltas que puedan engancharse. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 8, 'El operador realiza las comprobaciones y las tareas rutinarias que le asigne el fabricante y la empresa, como vigilar niveles, engrase o filtros. Cualquier intervención debe respetar el manual de mantenimiento, los bloqueos y los límites de competencia del trabajador. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El operador realiza las comprobaciones y las tareas rutinarias que le asigne el fabricante y la empresa, como vigilar niveles, engrase o filtros', 'Cualquier intervención debe respetar el manual de mantenimiento, los bloqueos y los límites de competencia del trabajador', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '38–44', 'El operador realiza las comprobaciones y las tareas rutinarias que le asigne el fabricante y la empresa, como vigilar niveles, engrase o filtros. Cualquier intervención debe respetar el manual de mantenimiento, los bloqueos y los límites de competencia del trabajador. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El operador realiza las comprobaciones y las tareas rutinarias que le asigne el fabricante y la empresa, como vigilar niveles, engrase o filtros. Cualquier intervención debe respetar el manual de mantenimiento, los bloqueos y los límites de competencia del trabajador. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 9, 'El repostado se realizará en las zonas habilitadas y conforme al procedimiento de la explotación. Apague el motor cuando así se establezca, conecte el freno de estacionamiento y evite fumar, usar el teléfono o generar llamas y chispas cerca del combustible. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El repostado se realizará en las zonas habilitadas y conforme al procedimiento de la explotación', 'Apague el motor cuando así se establezca, conecte el freno de estacionamiento y evite fumar', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '38–44', 'El repostado se realizará en las zonas habilitadas y conforme al procedimiento de la explotación. Apague el motor cuando así se establezca, conecte el freno de estacionamiento y evite fumar, usar el teléfono o generar llamas y chispas cerca del combustible. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El repostado se realizará en las zonas habilitadas y conforme al procedimiento de la explotación. Apague el motor cuando así se establezca, conecte el freno de estacionamiento y evite fumar, usar el teléfono o generar llamas y chispas cerca del combustible. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 3, 10, 'El remolcado cambia según funcionen el motor, la dirección y los frenos. No improvise: aplique el procedimiento específico del fabricante, utilice los puntos de enganche previstos y realice cualquier desbloqueo de frenos únicamente por personal competente y con la unidad asegurada. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El remolcado cambia según funcionen el motor, la dirección y los frenos', 'No improvise: aplique el procedimiento específico del fabricante, utilice los puntos de enganche previstos y realice cualquier desbloqueo de frenos.', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'No improvise: aplique el procedimiento específico del fabricante, utilice los puntos de enganche previstos y realice cualquier desbloqueo de frenos…', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '45–48', 'El remolcado cambia según funcionen el motor, la dirección y los frenos. No improvise: aplique el procedimiento específico del fabricante, utilice los puntos de enganche previstos y realice cualquier desbloqueo de frenos únicamente por personal competente y con la unidad asegurada. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La revisión previa evita averías, accidentes y paradas no planificadas. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El remolcado cambia según funcionen el motor, la dirección y los frenos. No improvise: aplique el procedimiento específico del fabricante, utilice los puntos de enganche previstos y realice cualquier desbloqueo de frenos únicamente por personal competente y con la unidad asegurada. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Aplica la lista de revisión diaria antes de autorizar el arranque o continuar el turno. Evidencia: lista diaria de comprobación del vehículo');

do $$
begin
  if (select count(*) from course_part_details) <> 10 then
    raise exception 'Se esperaban 10 fichas didácticas.';
  end if;
end $$;

update public.lesson_audio_segments segment
set narration_text = detail.narration_text,
    published = true,
    updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_part_details detail
  on detail.slug = course.slug
 and detail.duration_hours = version.duration_hours
 and detail.block_position = module.position
where segment.lesson_id = lesson.id
  and segment.position = detail.part_position;

update public.lesson_segment_slides slide
set body = case slide.position
      when 1 then detail.overview_body
      else detail.detail_body
    end,
    updated_at = now()
from public.lesson_audio_segments segment
join public.lessons lesson on lesson.id = segment.lesson_id
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_part_details detail
  on detail.slug = course.slug
 and detail.duration_hours = version.duration_hours
 and detail.block_position = module.position
 and detail.part_position = segment.position
where slide.segment_id = segment.id
  and slide.position between 1 and 2;

insert into public.lesson_segment_notes (
  segment_id, summary, key_points, stop_criterion, source_label, source_pages, approved
)
select segment.id, detail.summary, detail.key_points, detail.stop_criterion,
       detail.source_label, detail.source_pages, true
from course_part_details detail
join public.courses course on course.slug = detail.slug
join public.course_versions version
  on version.course_id = course.id
 and version.duration_hours = detail.duration_hours
join public.course_modules module
  on module.course_version_id = version.id
 and module.position = detail.block_position
join public.lessons lesson on lesson.module_id = module.id
join public.lesson_audio_segments segment
  on segment.lesson_id = lesson.id
 and segment.position = detail.part_position
on conflict (segment_id) do update set
  summary = excluded.summary,
  key_points = excluded.key_points,
  stop_criterion = excluded.stop_criterion,
  source_label = excluded.source_label,
  source_pages = excluded.source_pages,
  approved = true,
  updated_at = now();

do $$
declare
  detailed_segments integer;
  detailed_slides integer;
  detailed_notes integer;
begin
  select count(*) into detailed_segments
  from course_part_details detail
  join public.courses course on course.slug = detail.slug
  join public.course_versions version on version.course_id = course.id and version.duration_hours = detail.duration_hours
  join public.course_modules module on module.course_version_id = version.id and module.position = detail.block_position
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id and segment.position = detail.part_position
  where segment.published and length(trim(segment.narration_text)) >= 10;

  select count(*) into detailed_slides
  from course_part_details detail
  join public.courses course on course.slug = detail.slug
  join public.course_versions version on version.course_id = course.id and version.duration_hours = detail.duration_hours
  join public.course_modules module on module.course_version_id = version.id and module.position = detail.block_position
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id and segment.position = detail.part_position
  join public.lesson_segment_slides slide on slide.segment_id = segment.id
  where slide.position between 1 and 2 and length(trim(slide.body)) >= 10;

  select count(*) into detailed_notes
  from course_part_details detail
  join public.courses course on course.slug = detail.slug
  join public.course_versions version on version.course_id = course.id and version.duration_hours = detail.duration_hours
  join public.course_modules module on module.course_version_id = version.id and module.position = detail.block_position
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id and segment.position = detail.part_position
  join public.lesson_segment_notes note on note.segment_id = segment.id
  where note.approved;

  if detailed_segments <> 10 or detailed_slides <> 20 or detailed_notes <> 10 then
    raise exception 'Detalle incompleto: % segmentos, % diapositivas y % fichas.',
      detailed_segments, detailed_slides, detailed_notes;
  end if;
end $$;

commit;
