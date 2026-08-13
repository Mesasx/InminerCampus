-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 15/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 1, 'Casco, calzado de seguridad, ropa de alta visibilidad y otros EPI definidos por la explotación son de uso obligatorio. Deben mantenerse en buen estado y utilizarse de acuerdo con la tarea y la zona de trabajo.', array['Casco, calzado de seguridad, ropa de alta visibilidad y otros EPI definidos por la explotación son de uso obligatorio.', 'Deben mantenerse en buen estado y utilizarse de acuerdo con la tarea y la zona de trabajo.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 81–82', 'Casco, calzado de seguridad, ropa de alta visibilidad y otros EPI definidos por la explotación son de uso obligatorio. Deben mantenerse en buen estado y utilizarse de acuerdo con la tarea y la zona de trabajo. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Casco, calzado de seguridad, ropa de alta visibilidad y otros EPI definidos por la explotación son de uso obligatorio. Deben mantenerse en buen estado y utilizarse de acuerdo con la tarea y la zona de trabajo. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 2, 'La explotación establece disposiciones internas de seguridad, normas de circulación y procedimientos de trabajo que deben conocerse y cumplirse. Estas reglas son la referencia diaria para una operación disciplinada y segura.', array['La explotación establece disposiciones internas de seguridad, normas de circulación y procedimientos de trabajo que deben conocerse y cumplirse.', 'Estas reglas son la referencia diaria para una operación disciplinada y segura.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 83–84', 'La explotación establece disposiciones internas de seguridad, normas de circulación y procedimientos de trabajo que deben conocerse y cumplirse. Estas reglas son la referencia diaria para una operación disciplinada y segura. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La explotación establece disposiciones internas de seguridad, normas de circulación y procedimientos de trabajo que deben conocerse y cumplirse. Estas reglas son la referencia diaria para una operación disciplinada y segura. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 3, 'La circulación debe realizarse minimizando el deterioro del firme, el polvo y la dispersión de material fuera de las zonas previstas. El buen estado de los viales también es una medida esencial de seguridad.', array['La circulación debe realizarse minimizando el deterioro del firme, el polvo y la dispersión de material fuera de las zonas previstas.', 'El buen estado de los viales también es una medida esencial de seguridad.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 85–86', 'La circulación debe realizarse minimizando el deterioro del firme, el polvo y la dispersión de material fuera de las zonas previstas. El buen estado de los viales también es una medida esencial de seguridad. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La circulación debe realizarse minimizando el deterioro del firme, el polvo y la dispersión de material fuera de las zonas previstas. El buen estado de los viales también es una medida esencial de seguridad. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 4, 'Aceites, filtros y otros residuos del mantenimiento deben gestionarse en los puntos habilitados y nunca en la pista o el frente. Ante un derrame, la prioridad es contenerlo, señalizarlo y comunicarlo de inmediato.', array['Aceites, filtros y otros residuos del mantenimiento deben gestionarse en los puntos habilitados y nunca en la pista o el frente.', 'Ante un derrame, la prioridad es contenerlo, señalizarlo y comunicarlo de inmediato.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 87–88', 'Aceites, filtros y otros residuos del mantenimiento deben gestionarse en los puntos habilitados y nunca en la pista o el frente. Ante un derrame, la prioridad es contenerlo, señalizarlo y comunicarlo de inmediato. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Aceites, filtros y otros residuos del mantenimiento deben gestionarse en los puntos habilitados y nunca en la pista o el frente. Ante un derrame, la prioridad es contenerlo, señalizarlo y comunicarlo de inmediato. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 5, 'Cuando intervienen varias empresas o personal ajeno a la explotación, la coordinación de actividades es imprescindible. Todo conductor debe conocer qué restricciones, rutas o comunicaciones especiales aplican en esos casos.', array['Cuando intervienen varias empresas o personal ajeno a la explotación, la coordinación de actividades es imprescindible.', 'Todo conductor debe conocer qué restricciones, rutas o comunicaciones especiales aplican en esos casos.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 89–90', 'Cuando intervienen varias empresas o personal ajeno a la explotación, la coordinación de actividades es imprescindible. Todo conductor debe conocer qué restricciones, rutas o comunicaciones especiales aplican en esos casos. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Cuando intervienen varias empresas o personal ajeno a la explotación, la coordinación de actividades es imprescindible. Todo conductor debe conocer qué restricciones, rutas o comunicaciones especiales aplican en esos casos. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 6, 'Las reuniones breves al inicio de la jornada permiten recordar riesgos, trabajos especiales y cambios en el circuito operativo. Compartir información antes de salir a pista evita errores de coordinación durante el turno.', array['Las reuniones breves al inicio de la jornada permiten recordar riesgos, trabajos especiales y cambios en el circuito operativo.', 'Compartir información antes de salir a pista evita errores de coordinación durante el turno.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 91–92', 'Las reuniones breves al inicio de la jornada permiten recordar riesgos, trabajos especiales y cambios en el circuito operativo. Compartir información antes de salir a pista evita errores de coordinación durante el turno. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Las reuniones breves al inicio de la jornada permiten recordar riesgos, trabajos especiales y cambios en el circuito operativo. Compartir información antes de salir a pista evita errores de coordinación durante el turno. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 7, 'Ante un accidente debe aplicarse la conducta PAS: proteger, avisar y socorrer sin agravar la situación. Conservar la calma y seguir el protocolo facilita una respuesta rápida y ordenada.', array['Ante un accidente debe aplicarse la conducta PAS: proteger, avisar y socorrer sin agravar la situación.', 'Conservar la calma y seguir el protocolo facilita una respuesta rápida y ordenada.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 93–94', 'Ante un accidente debe aplicarse la conducta PAS: proteger, avisar y socorrer sin agravar la situación. Conservar la calma y seguir el protocolo facilita una respuesta rápida y ordenada. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Ante un accidente debe aplicarse la conducta PAS: proteger, avisar y socorrer sin agravar la situación. Conservar la calma y seguir el protocolo facilita una respuesta rápida y ordenada. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 8, 'El conductor debe conocer la ubicación de extintores, el procedimiento de parada y los límites de actuación ante un conato. Si el incendio no se controla de inmediato, la prioridad será alejarse y avisar.', array['El conductor debe conocer la ubicación de extintores, el procedimiento de parada y los límites de actuación ante un conato.', 'Si el incendio no se controla de inmediato, la prioridad será alejarse y avisar.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 95–96', 'El conductor debe conocer la ubicación de extintores, el procedimiento de parada y los límites de actuación ante un conato. Si el incendio no se controla de inmediato, la prioridad será alejarse y avisar. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El conductor debe conocer la ubicación de extintores, el procedimiento de parada y los límites de actuación ante un conato. Si el incendio no se controla de inmediato, la prioridad será alejarse y avisar. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 9, 'Toda explotación debe disponer de canales de aviso, vías de evacuación y puntos de reunión claros para emergencias. El operador debe saber cómo comunicar una incidencia y dónde dirigirse si se activa una evacuación.', array['Toda explotación debe disponer de canales de aviso, vías de evacuación y puntos de reunión claros para emergencias.', 'El operador debe saber cómo comunicar una incidencia y dónde dirigirse si se activa una evacuación.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 97–98', 'Toda explotación debe disponer de canales de aviso, vías de evacuación y puntos de reunión claros para emergencias. El operador debe saber cómo comunicar una incidencia y dónde dirigirse si se activa una evacuación. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Toda explotación debe disponer de canales de aviso, vías de evacuación y puntos de reunión claros para emergencias. El operador debe saber cómo comunicar una incidencia y dónde dirigirse si se activa una evacuación. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 5, 10, 'Los últimos movimientos del turno deben dejar vehículo, documentación y circuito en condiciones seguras para la siguiente operación. Cerrar bien la jornada forma parte de la trazabilidad y de la cultura preventiva del centro.', array['Los últimos movimientos del turno deben dejar vehículo, documentación y circuito en condiciones seguras para la siguiente operación.', 'Cerrar bien la jornada forma parte de la trazabilidad y de la cultura preventiva del centro.', 'Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 99–100', 'Los últimos movimientos del turno deben dejar vehículo, documentación y circuito en condiciones seguras para la siguiente operación. Cerrar bien la jornada forma parte de la trazabilidad y de la cultura preventiva del centro. Aplicación práctica: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno.', 'Normativa, medio ambiente y emergencia forman parte inseparable del trabajo del operador. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Los últimos movimientos del turno deben dejar vehículo, documentación y circuito en condiciones seguras para la siguiente operación. Cerrar bien la jornada forma parte de la trazabilidad y de la cultura preventiva del centro. Aplicación en explotación: Confirma el cumplimiento de EPI, normas internas y protocolos de emergencia antes, durante y al final del turno. Evidencia: cumplimiento de normativa, ambiente y emergencia');

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
