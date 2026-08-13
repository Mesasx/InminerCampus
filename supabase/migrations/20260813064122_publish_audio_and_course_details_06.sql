-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 6/20 a partir de sus fuentes.

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
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 1, 'El operador participa en el ciclo productivo desde el arranque del material hasta su transporte interno y la conservación de los viales. Su trabajo debe combinar rendimiento, coordinación con otros equipos y cumplimiento estricto de las normas de seguridad.', array['El operador participa en el ciclo productivo desde el arranque del material hasta su transporte interno y la conservación de los viales.', 'Su trabajo debe combinar rendimiento, coordinación con otros equipos y cumplimiento estricto de las normas de seguridad.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 1–2', 'El operador participa en el ciclo productivo desde el arranque del material hasta su transporte interno y la conservación de los viales. Su trabajo debe combinar rendimiento, coordinación con otros equipos y cumplimiento estricto de las normas de seguridad. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El operador participa en el ciclo productivo desde el arranque del material hasta su transporte interno y la conservación de los viales. Su trabajo debe combinar rendimiento, coordinación con otros equipos y cumplimiento estricto de las normas de seguridad. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 2, 'Una cantera a cielo abierto se organiza en bancos, frentes, bermas, pistas y zonas de descarga o acopio claramente diferenciadas. Conocer cada zona ayuda a circular con seguridad y a evitar maniobras improvisadas.', array['Una cantera a cielo abierto se organiza en bancos, frentes, bermas, pistas y zonas de descarga o acopio claramente diferenciadas.', 'Conocer cada zona ayuda a circular con seguridad y a evitar maniobras improvisadas.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 3–4', 'Una cantera a cielo abierto se organiza en bancos, frentes, bermas, pistas y zonas de descarga o acopio claramente diferenciadas. Conocer cada zona ayuda a circular con seguridad y a evitar maniobras improvisadas. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Una cantera a cielo abierto se organiza en bancos, frentes, bermas, pistas y zonas de descarga o acopio claramente diferenciadas. Conocer cada zona ayuda a circular con seguridad y a evitar maniobras improvisadas. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 3, 'En este grupo se incluyen excavadoras hidráulicas, palas cargadoras y otros equipos que arrancan o cargan el material. Cada máquina tiene capacidades, radios de trabajo y limitaciones que el operador debe respetar.', array['En este grupo se incluyen excavadoras hidráulicas, palas cargadoras y otros equipos que arrancan o cargan el material.', 'Cada máquina tiene capacidades, radios de trabajo y limitaciones que el operador debe respetar.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 5–6', 'En este grupo se incluyen excavadoras hidráulicas, palas cargadoras y otros equipos que arrancan o cargan el material. Cada máquina tiene capacidades, radios de trabajo y limitaciones que el operador debe respetar. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'En este grupo se incluyen excavadoras hidráulicas, palas cargadoras y otros equipos que arrancan o cargan el material. Cada máquina tiene capacidades, radios de trabajo y limitaciones que el operador debe respetar. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 4, 'Las motoniveladoras, rodillos, cisternas y equipos auxiliares mantienen las pistas en buen estado y mejoran la seguridad del tránsito. Su intervención es clave para controlar el polvo, la rodadura y la estabilidad del firme.', array['Las motoniveladoras, rodillos, cisternas y equipos auxiliares mantienen las pistas en buen estado y mejoran la seguridad del tránsito.', 'Su intervención es clave para controlar el polvo, la rodadura y la estabilidad del firme.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 7–8', 'Las motoniveladoras, rodillos, cisternas y equipos auxiliares mantienen las pistas en buen estado y mejoran la seguridad del tránsito. Su intervención es clave para controlar el polvo, la rodadura y la estabilidad del firme. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Las motoniveladoras, rodillos, cisternas y equipos auxiliares mantienen las pistas en buen estado y mejoran la seguridad del tránsito. Su intervención es clave para controlar el polvo, la rodadura y la estabilidad del firme. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 5, 'El ciclo típico comprende arranque, carga, transporte interior, descarga y acondicionamiento de la zona de circulación. El operador debe entender el conjunto para detectar cuellos de botella y prevenir interferencias.', array['El ciclo típico comprende arranque, carga, transporte interior, descarga y acondicionamiento de la zona de circulación.', 'El operador debe entender el conjunto para detectar cuellos de botella y prevenir interferencias.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 9–10', 'El ciclo típico comprende arranque, carga, transporte interior, descarga y acondicionamiento de la zona de circulación. El operador debe entender el conjunto para detectar cuellos de botella y prevenir interferencias. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El ciclo típico comprende arranque, carga, transporte interior, descarga y acondicionamiento de la zona de circulación. El operador debe entender el conjunto para detectar cuellos de botella y prevenir interferencias. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 6, 'Los frentes de trabajo deben presentar condiciones de estabilidad, orden y visibilidad compatibles con la operación segura. Las bermas y distancias de resguardo no son opcionales y deben mantenerse durante toda la jornada.', array['Los frentes de trabajo deben presentar condiciones de estabilidad, orden y visibilidad compatibles con la operación segura.', 'Las bermas y distancias de resguardo no son opcionales y deben mantenerse durante toda la jornada.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 11–12', 'Los frentes de trabajo deben presentar condiciones de estabilidad, orden y visibilidad compatibles con la operación segura. Las bermas y distancias de resguardo no son opcionales y deben mantenerse durante toda la jornada. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Los frentes de trabajo deben presentar condiciones de estabilidad, orden y visibilidad compatibles con la operación segura. Las bermas y distancias de resguardo no son opcionales y deben mantenerse durante toda la jornada. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 7, 'La zona de carga exige una organización clara entre excavadora, pala y vehículos receptores para evitar colisiones o tiempos muertos. Toda maniobra debe realizarse con posiciones predefinidas y comunicación efectiva.', array['La zona de carga exige una organización clara entre excavadora, pala y vehículos receptores para evitar colisiones o tiempos muertos.', 'Toda maniobra debe realizarse con posiciones predefinidas y comunicación efectiva.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 13–14', 'La zona de carga exige una organización clara entre excavadora, pala y vehículos receptores para evitar colisiones o tiempos muertos. Toda maniobra debe realizarse con posiciones predefinidas y comunicación efectiva. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La zona de carga exige una organización clara entre excavadora, pala y vehículos receptores para evitar colisiones o tiempos muertos. Toda maniobra debe realizarse con posiciones predefinidas y comunicación efectiva. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 8, 'El firme, la pendiente, la presencia de material suelto y la meteorología condicionan directamente la maniobrabilidad de la maquinaria. Trabajar sin valorar estas condiciones incrementa el riesgo de derrape, vuelco o choque.', array['El firme, la pendiente, la presencia de material suelto y la meteorología condicionan directamente la maniobrabilidad de la maquinaria.', 'Trabajar sin valorar estas condiciones incrementa el riesgo de derrape, vuelco o choque.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 15–16', 'El firme, la pendiente, la presencia de material suelto y la meteorología condicionan directamente la maniobrabilidad de la maquinaria. Trabajar sin valorar estas condiciones incrementa el riesgo de derrape, vuelco o choque. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El firme, la pendiente, la presencia de material suelto y la meteorología condicionan directamente la maniobrabilidad de la maquinaria. Trabajar sin valorar estas condiciones incrementa el riesgo de derrape, vuelco o choque. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 9, 'Las órdenes deben ser claras, comprendidas y confirmadas antes de iniciar maniobras relevantes o simultáneas. La comunicación deficiente es una causa habitual de errores de coordinación y situaciones peligrosas.', array['Las órdenes deben ser claras, comprendidas y confirmadas antes de iniciar maniobras relevantes o simultáneas.', 'La comunicación deficiente es una causa habitual de errores de coordinación y situaciones peligrosas.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 17–18', 'Las órdenes deben ser claras, comprendidas y confirmadas antes de iniciar maniobras relevantes o simultáneas. La comunicación deficiente es una causa habitual de errores de coordinación y situaciones peligrosas. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Las órdenes deben ser claras, comprendidas y confirmadas antes de iniciar maniobras relevantes o simultáneas. La comunicación deficiente es una causa habitual de errores de coordinación y situaciones peligrosas. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 1, 10, 'Antes de iniciar el turno conviene identificar la tarea, el itinerario, las condiciones del entorno y los riesgos previsibles. Una buena planificación reduce improvisaciones y mejora tanto la seguridad como la productividad.', array['Antes de iniciar el turno conviene identificar la tarea, el itinerario, las condiciones del entorno y los riesgos previsibles.', 'Una buena planificación reduce improvisaciones y mejora tanto la seguridad como la productividad.', 'Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 19–20', 'Antes de iniciar el turno conviene identificar la tarea, el itinerario, las condiciones del entorno y los riesgos previsibles. Una buena planificación reduce improvisaciones y mejora tanto la seguridad como la productividad. Aplicación práctica: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea.', 'Entender la explotación y el papel de cada equipo es la base de una operación segura. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Antes de iniciar el turno conviene identificar la tarea, el itinerario, las condiciones del entorno y los riesgos previsibles. Una buena planificación reduce improvisaciones y mejora tanto la seguridad como la productividad. Aplicación en explotación: Identifica en tu explotación real los frentes, bancos, equipos y zonas de trabajo antes de iniciar cualquier tarea. Evidencia: reconocimiento del frente y de los equipos de trabajo');

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
