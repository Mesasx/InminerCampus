-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 10/20 a partir de sus fuentes.

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
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 1, 'El casco, el calzado de seguridad, la protección ocular, auditiva y la ropa de alta visibilidad forman parte del trabajo habitual. Los EPI deben utilizarse de acuerdo con la tarea y mantenerse en condiciones adecuadas.', array['El casco, el calzado de seguridad, la protección ocular, auditiva y la ropa de alta visibilidad forman parte del trabajo habitual.', 'Los EPI deben utilizarse de acuerdo con la tarea y mantenerse en condiciones adecuadas.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 81–82', 'El casco, el calzado de seguridad, la protección ocular, auditiva y la ropa de alta visibilidad forman parte del trabajo habitual. Los EPI deben utilizarse de acuerdo con la tarea y mantenerse en condiciones adecuadas. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El casco, el calzado de seguridad, la protección ocular, auditiva y la ropa de alta visibilidad forman parte del trabajo habitual. Los EPI deben utilizarse de acuerdo con la tarea y mantenerse en condiciones adecuadas. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 2, 'La explotación cuenta con disposiciones internas de seguridad, normas de circulación y procedimientos específicos que deben conocerse y aplicarse. Trabajar al margen de estos documentos genera descontrol y aumenta la exposición al riesgo.', array['La explotación cuenta con disposiciones internas de seguridad, normas de circulación y procedimientos específicos que deben conocerse y aplicarse.', 'Trabajar al margen de estos documentos genera descontrol y aumenta la exposición al riesgo.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 83–84', 'La explotación cuenta con disposiciones internas de seguridad, normas de circulación y procedimientos específicos que deben conocerse y aplicarse. Trabajar al margen de estos documentos genera descontrol y aumenta la exposición al riesgo. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La explotación cuenta con disposiciones internas de seguridad, normas de circulación y procedimientos específicos que deben conocerse y aplicarse. Trabajar al margen de estos documentos genera descontrol y aumenta la exposición al riesgo. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 3, 'La operación debe minimizar la emisión de polvo, el deterioro del terreno y la dispersión de materiales fuera de las zonas previstas. El riego, la limpieza y el buen estado de los viales son medidas básicas de control ambiental.', array['La operación debe minimizar la emisión de polvo, el deterioro del terreno y la dispersión de materiales fuera de las zonas previstas.', 'El riego, la limpieza y el buen estado de los viales son medidas básicas de control ambiental.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 85–86', 'La operación debe minimizar la emisión de polvo, el deterioro del terreno y la dispersión de materiales fuera de las zonas previstas. El riego, la limpieza y el buen estado de los viales son medidas básicas de control ambiental. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La operación debe minimizar la emisión de polvo, el deterioro del terreno y la dispersión de materiales fuera de las zonas previstas. El riego, la limpieza y el buen estado de los viales son medidas básicas de control ambiental. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 4, 'Los aceites usados, filtros, trapos y otros residuos deben recogerse y gestionarse en los puntos establecidos por la explotación. Los derrames deben contenerse de inmediato para evitar contaminación y resbalones.', array['Los aceites usados, filtros, trapos y otros residuos deben recogerse y gestionarse en los puntos establecidos por la explotación.', 'Los derrames deben contenerse de inmediato para evitar contaminación y resbalones.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 87–88', 'Los aceites usados, filtros, trapos y otros residuos deben recogerse y gestionarse en los puntos establecidos por la explotación. Los derrames deben contenerse de inmediato para evitar contaminación y resbalones. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Los aceites usados, filtros, trapos y otros residuos deben recogerse y gestionarse en los puntos establecidos por la explotación. Los derrames deben contenerse de inmediato para evitar contaminación y resbalones. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 5, 'El repostaje debe realizarse en las zonas autorizadas, con el motor parado y evitando cualquier foco de ignición próximo. También deben extremarse las precauciones durante engrase, limpieza o cambios de herramienta.', array['El repostaje debe realizarse en las zonas autorizadas, con el motor parado y evitando cualquier foco de ignición próximo.', 'También deben extremarse las precauciones durante engrase, limpieza o cambios de herramienta.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 89–90', 'El repostaje debe realizarse en las zonas autorizadas, con el motor parado y evitando cualquier foco de ignición próximo. También deben extremarse las precauciones durante engrase, limpieza o cambios de herramienta. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El repostaje debe realizarse en las zonas autorizadas, con el motor parado y evitando cualquier foco de ignición próximo. También deben extremarse las precauciones durante engrase, limpieza o cambios de herramienta. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 6, 'Las reuniones o breafings de seguridad alinean criterios de trabajo y permiten recordar riesgos concretos del día. La coordinación es especialmente importante cuando intervienen varias contratas o equipos simultáneamente.', array['Las reuniones o breafings de seguridad alinean criterios de trabajo y permiten recordar riesgos concretos del día.', 'La coordinación es especialmente importante cuando intervienen varias contratas o equipos simultáneamente.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 91–92', 'Las reuniones o breafings de seguridad alinean criterios de trabajo y permiten recordar riesgos concretos del día. La coordinación es especialmente importante cuando intervienen varias contratas o equipos simultáneamente. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Las reuniones o breafings de seguridad alinean criterios de trabajo y permiten recordar riesgos concretos del día. La coordinación es especialmente importante cuando intervienen varias contratas o equipos simultáneamente. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 7, 'Ante un accidente se aplicará la conducta PAS: proteger la zona, avisar a los responsables y socorrer sin agravar la situación. La rapidez debe ir siempre acompañada de orden y control.', array['Ante un accidente se aplicará la conducta PAS: proteger la zona, avisar a los responsables y socorrer sin agravar la situación.', 'La rapidez debe ir siempre acompañada de orden y control.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 93–94', 'Ante un accidente se aplicará la conducta PAS: proteger la zona, avisar a los responsables y socorrer sin agravar la situación. La rapidez debe ir siempre acompañada de orden y control. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Ante un accidente se aplicará la conducta PAS: proteger la zona, avisar a los responsables y socorrer sin agravar la situación. La rapidez debe ir siempre acompañada de orden y control. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 8, 'El operador debe conocer dónde se ubican los extintores y cómo actuar en un conato de incendio de su equipo. Si la situación no es controlable de forma inmediata, la prioridad será alejarse y avisar.', array['El operador debe conocer dónde se ubican los extintores y cómo actuar en un conato de incendio de su equipo.', 'Si la situación no es controlable de forma inmediata, la prioridad será alejarse y avisar.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 95–96', 'El operador debe conocer dónde se ubican los extintores y cómo actuar en un conato de incendio de su equipo. Si la situación no es controlable de forma inmediata, la prioridad será alejarse y avisar. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El operador debe conocer dónde se ubican los extintores y cómo actuar en un conato de incendio de su equipo. Si la situación no es controlable de forma inmediata, la prioridad será alejarse y avisar. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 9, 'Toda cantera debe disponer de canales de comunicación, vías de evacuación y puntos de reunión claramente definidos. El operador debe saber cómo y a quién avisar en caso de incidencia grave.', array['Toda cantera debe disponer de canales de comunicación, vías de evacuación y puntos de reunión claramente definidos.', 'El operador debe saber cómo y a quién avisar en caso de incidencia grave.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 97–98', 'Toda cantera debe disponer de canales de comunicación, vías de evacuación y puntos de reunión claramente definidos. El operador debe saber cómo y a quién avisar en caso de incidencia grave. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Toda cantera debe disponer de canales de comunicación, vías de evacuación y puntos de reunión claramente definidos. El operador debe saber cómo y a quién avisar en caso de incidencia grave. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia'),
  ('operador-maquinaria-arranque-carga-viales', 20, 5, 10, 'La seguridad no depende solo de la máquina, sino también de la actitud con la que se trabaja cada día. Detener una maniobra insegura, comunicar una anomalía y respetar la norma son rasgos de un buen profesional.', array['La seguridad no depende solo de la máquina, sino también de la actitud con la que se trabaja cada día.', 'Detener una maniobra insegura, comunicar una anomalía y respetar la norma son rasgos de un buen profesional.', 'Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 99–100', 'La seguridad no depende solo de la máquina, sino también de la actitud con la que se trabaja cada día. Detener una maniobra insegura, comunicar una anomalía y respetar la norma son rasgos de un buen profesional. Aplicación práctica: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente.', 'Normativa, medio ambiente y respuesta ante emergencias forman parte del trabajo diario. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La seguridad no depende solo de la máquina, sino también de la actitud con la que se trabaja cada día. Detener una maniobra insegura, comunicar una anomalía y respetar la norma son rasgos de un buen profesional. Aplicación en explotación: Confirma el uso de EPI, el cumplimiento de normas internas y la forma de actuar ante una emergencia o accidente. Evidencia: cumplimiento de normativa, EPI y emergencia');

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
