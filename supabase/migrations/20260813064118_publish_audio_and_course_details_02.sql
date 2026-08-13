-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 2/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 1, 'El ciclo de trabajo comprende la carga del material, el transporte por las pistas, la descarga en tolva o escombrera, el retorno en vacío y las maniobras necesarias para volver a posicionar la unidad. Cada fase debe ejecutarse siguiendo el procedimiento establecido. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El ciclo de trabajo comprende la carga del material, el transporte por las pistas, la descarga en tolva o escombrera', 'Cada fase debe ejecutarse siguiendo el procedimiento establecido', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '22–26', 'El ciclo de trabajo comprende la carga del material, el transporte por las pistas, la descarga en tolva o escombrera, el retorno en vacío y las maniobras necesarias para volver a posicionar la unidad. Cada fase debe ejecutarse siguiendo el procedimiento establecido. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El ciclo de trabajo comprende la carga del material, el transporte por las pistas, la descarga en tolva o escombrera, el retorno en vacío y las maniobras necesarias para volver a posicionar la unidad. Cada fase debe ejecutarse siguiendo el procedimiento establecido. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 2, 'Al comenzar el turno, el conductor debe utilizar la indumentaria y los equipos de protección exigidos, realizar la revisión previa, comprobar que el entorno está despejado y acceder a la cabina con tres puntos de apoyo. Después trasladará la unidad siguiendo las normas internas. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Al comenzar el turno, el conductor debe utilizar la indumentaria y los equipos de protección exigidos, realizar la revisión previa', 'Después trasladará la unidad siguiendo las normas internas', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '17–22 y 28–38', 'Al comenzar el turno, el conductor debe utilizar la indumentaria y los equipos de protección exigidos, realizar la revisión previa, comprobar que el entorno está despejado y acceder a la cabina con tres puntos de apoyo. Después trasladará la unidad siguiendo las normas internas. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Al comenzar el turno, el conductor debe utilizar la indumentaria y los equipos de protección exigidos, realizar la revisión previa, comprobar que el entorno está despejado y acceder a la cabina con tres puntos de apoyo. Después trasladará la unidad siguiendo las normas internas. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 3, 'La aproximación al frente se hará despacio y con buena visibilidad. Deben comprobarse la estabilidad y limpieza del terreno, la presencia de rocas sueltas y el espacio de maniobra. El posicionamiento se coordinará con el operador del equipo de carga. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['La aproximación al frente se hará despacio y con buena visibilidad', 'Deben comprobarse la estabilidad y limpieza del terreno, la presencia de rocas sueltas y el espacio de maniobra', 'El posicionamiento se coordinará con el operador del equipo de carga']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '58–70', 'La aproximación al frente se hará despacio y con buena visibilidad. Deben comprobarse la estabilidad y limpieza del terreno, la presencia de rocas sueltas y el espacio de maniobra. El posicionamiento se coordinará con el operador del equipo de carga. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'La aproximación al frente se hará despacio y con buena visibilidad. Deben comprobarse la estabilidad y limpieza del terreno, la presencia de rocas sueltas y el espacio de maniobra. El posicionamiento se coordinará con el operador del equipo de carga. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 4, 'Con pala cargadora, el eje longitudinal del volquete se sitúa normalmente sesgado entre treinta y cinco y cuarenta y cinco grados respecto al frente, con la cabina alejada del punto de carga. Las maniobras y señales deben ajustarse al procedimiento interno de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Con pala cargadora, el eje longitudinal del volquete se sitúa normalmente sesgado entre treinta y cinco y cuarenta y cinco grados respecto al frente', 'Las maniobras y señales deben ajustarse al procedimiento interno de la explotación', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '58–70', 'Con pala cargadora, el eje longitudinal del volquete se sitúa normalmente sesgado entre treinta y cinco y cuarenta y cinco grados respecto al frente, con la cabina alejada del punto de carga. Las maniobras y señales deben ajustarse al procedimiento interno de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Con pala cargadora, el eje longitudinal del volquete se sitúa normalmente sesgado entre treinta y cinco y cuarenta y cinco grados respecto al frente, con la cabina alejada del punto de carga. Las maniobras y señales deben ajustarse al procedimiento interno de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 5, 'Durante la carga, la unidad se considera estacionada: transmisión en punto muerto, freno de estacionamiento conectado y motor al ralentí, salvo indicación del fabricante. La permanencia del conductor se regirá por la DIS y nunca se pasará la carga sobre la cabina. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Durante la carga, la unidad se considera estacionada: transmisión en punto muerto, freno de estacionamiento conectado y motor al ralentí', 'La permanencia del conductor se regirá por la DIS y nunca se pasará la carga sobre la cabina', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'La permanencia del conductor se regirá por la DIS y nunca se pasará la carga sobre la cabina.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '58–70', 'Durante la carga, la unidad se considera estacionada: transmisión en punto muerto, freno de estacionamiento conectado y motor al ralentí, salvo indicación del fabricante. La permanencia del conductor se regirá por la DIS y nunca se pasará la carga sobre la cabina. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Durante la carga, la unidad se considera estacionada: transmisión en punto muerto, freno de estacionamiento conectado y motor al ralentí, salvo indicación del fabricante. La permanencia del conductor se regirá por la DIS y nunca se pasará la carga sobre la cabina. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 6, 'Circule a la velocidad autorizada, mantenga la distancia de seguridad y respete la señalización y las prioridades fijadas en la DIS. Cuando conviven camiones de carretera y volquetes, el camión facilitará el adelantamiento del volquete solo si está permitido y puede hacerse con seguridad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Circule a la velocidad autorizada, mantenga la distancia de seguridad y respete la señalización y las prioridades fijadas en la DIS', 'Cuando conviven camiones de carretera y volquetes, el camión facilitará el adelantamiento del volquete solo si está permitido y puede hacerse con seguridad', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '71–79', 'Circule a la velocidad autorizada, mantenga la distancia de seguridad y respete la señalización y las prioridades fijadas en la DIS. Cuando conviven camiones de carretera y volquetes, el camión facilitará el adelantamiento del volquete solo si está permitido y puede hacerse con seguridad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Circule a la velocidad autorizada, mantenga la distancia de seguridad y respete la señalización y las prioridades fijadas en la DIS. Cuando conviven camiones de carretera y volquetes, el camión facilitará el adelantamiento del volquete solo si está permitido y puede hacerse con seguridad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 7, 'Nunca descienda una pendiente en punto muerto ni neutralice la transmisión. Controle la velocidad desde el inicio y utilice la relación de transmisión y el sistema de frenado o retardador que indique el fabricante, evitando sobrecalentar los frenos de servicio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Nunca descienda una pendiente en punto muerto ni neutralice la transmisión', 'Controle la velocidad desde el inicio y utilice la relación de transmisión y el sistema de frenado o retardador que indique el fabricante', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Nunca descienda una pendiente en punto muerto ni neutralice la transmisión.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '71–79', 'Nunca descienda una pendiente en punto muerto ni neutralice la transmisión. Controle la velocidad desde el inicio y utilice la relación de transmisión y el sistema de frenado o retardador que indique el fabricante, evitando sobrecalentar los frenos de servicio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Nunca descienda una pendiente en punto muerto ni neutralice la transmisión. Controle la velocidad desde el inicio y utilice la relación de transmisión y el sistema de frenado o retardador que indique el fabricante, evitando sobrecalentar los frenos de servicio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 8, 'Al subir rampas importantes, el material puede derramarse por la parte posterior de la caja. Las piedras caídas crean obstáculos y pueden dañar los neumáticos de los vehículos que circulan detrás. La carga debe distribuirse correctamente y la pista mantenerse limpia. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Al subir rampas importantes, el material puede derramarse por la parte posterior de la caja', 'Las piedras caídas crean obstáculos y pueden dañar los neumáticos de los vehículos que circulan detrás', 'La carga debe distribuirse correctamente y la pista mantenerse limpia']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '71–79', 'Al subir rampas importantes, el material puede derramarse por la parte posterior de la caja. Las piedras caídas crean obstáculos y pueden dañar los neumáticos de los vehículos que circulan detrás. La carga debe distribuirse correctamente y la pista mantenerse limpia. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Al subir rampas importantes, el material puede derramarse por la parte posterior de la caja. Las piedras caídas crean obstáculos y pueden dañar los neumáticos de los vehículos que circulan detrás. La carga debe distribuirse correctamente y la pista mantenerse limpia. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 9, 'Algunos volquetes incorporan suplementos o compuertas traseras para limitar la pérdida de material en las rampas. Estos dispositivos se abren al elevar la caja y se cierran al bajarla. Su utilización y mantenimiento deben seguir siempre las instrucciones del fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Algunos volquetes incorporan suplementos o compuertas traseras para limitar la pérdida de material en las rampas', 'Estos dispositivos se abren al elevar la caja y se cierran al bajarla', 'Su utilización y mantenimiento deben seguir siempre las instrucciones del fabricante']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '71–85', 'Algunos volquetes incorporan suplementos o compuertas traseras para limitar la pérdida de material en las rampas. Estos dispositivos se abren al elevar la caja y se cierran al bajarla. Su utilización y mantenimiento deben seguir siempre las instrucciones del fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Algunos volquetes incorporan suplementos o compuertas traseras para limitar la pérdida de material en las rampas. Estos dispositivos se abren al elevar la caja y se cierran al bajarla. Su utilización y mantenimiento deben seguir siempre las instrucciones del fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 2, 10, 'Existen modelos con una placa o frente eyector que desplaza el material hacia la parte posterior. Este sistema permite descargar sin elevar la caja y, en determinados equipos, sin detener completamente el volquete, siempre que el fabricante y el procedimiento de trabajo lo permitan. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Existen modelos con una placa o frente eyector que desplaza el material hacia la parte posterior', 'Este sistema permite descargar sin elevar la caja y, en determinados equipos, sin detener completamente el volquete', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '80–85', 'Existen modelos con una placa o frente eyector que desplaza el material hacia la parte posterior. Este sistema permite descargar sin elevar la caja y, en determinados equipos, sin detener completamente el volquete, siempre que el fabricante y el procedimiento de trabajo lo permitan. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'Cada maniobra del ciclo debe ser visible, comunicada y controlada. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Existen modelos con una placa o frente eyector que desplaza el material hacia la parte posterior. Este sistema permite descargar sin elevar la caja y, en determinados equipos, sin detener completamente el volquete, siempre que el fabricante y el procedimiento de trabajo lo permitan. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Verifica la maniobra real en el ciclo de trabajo y compárala con la DIS del centro. Evidencia: procedimiento de carga, acarreo y descarga');

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
