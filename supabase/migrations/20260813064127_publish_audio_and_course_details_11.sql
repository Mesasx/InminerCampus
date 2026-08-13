-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 11/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 1, 'El operador se responsabiliza del transporte interno seguro del material entre la zona de carga, las pistas, la descarga y los puntos de control. Su trabajo debe combinar productividad, regularidad del ciclo y cumplimiento riguroso de las normas preventivas.', array['El operador se responsabiliza del transporte interno seguro del material entre la zona de carga, las pistas, la descarga y los puntos de control.', 'Su trabajo debe combinar productividad, regularidad del ciclo y cumplimiento riguroso de las normas preventivas.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 1–2', 'El operador se responsabiliza del transporte interno seguro del material entre la zona de carga, las pistas, la descarga y los puntos de control. Su trabajo debe combinar productividad, regularidad del ciclo y cumplimiento riguroso de las normas preventivas. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El operador se responsabiliza del transporte interno seguro del material entre la zona de carga, las pistas, la descarga y los puntos de control. Su trabajo debe combinar productividad, regularidad del ciclo y cumplimiento riguroso de las normas preventivas. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 2, 'El ciclo operativo se compone de aproximación, posicionamiento en carga, transporte por vial, descarga y retorno. Conocer bien cada fase ayuda a evitar maniobras innecesarias, tiempos muertos y situaciones inseguras.', array['El ciclo operativo se compone de aproximación, posicionamiento en carga, transporte por vial, descarga y retorno.', 'Conocer bien cada fase ayuda a evitar maniobras innecesarias, tiempos muertos y situaciones inseguras.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 3–4', 'El ciclo operativo se compone de aproximación, posicionamiento en carga, transporte por vial, descarga y retorno. Conocer bien cada fase ayuda a evitar maniobras innecesarias, tiempos muertos y situaciones inseguras. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El ciclo operativo se compone de aproximación, posicionamiento en carga, transporte por vial, descarga y retorno. Conocer bien cada fase ayuda a evitar maniobras innecesarias, tiempos muertos y situaciones inseguras. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 3, 'En la explotación pueden emplearse dúmperes rígidos, articulados, camiones de carretera adaptados u otros vehículos auxiliares. Cada uno presenta capacidades, radios de giro, estabilidad y limitaciones de uso diferentes.', array['En la explotación pueden emplearse dúmperes rígidos, articulados, camiones de carretera adaptados u otros vehículos auxiliares.', 'Cada uno presenta capacidades, radios de giro, estabilidad y limitaciones de uso diferentes.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 5–6', 'En la explotación pueden emplearse dúmperes rígidos, articulados, camiones de carretera adaptados u otros vehículos auxiliares. Cada uno presenta capacidades, radios de giro, estabilidad y limitaciones de uso diferentes. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'En la explotación pueden emplearse dúmperes rígidos, articulados, camiones de carretera adaptados u otros vehículos auxiliares. Cada uno presenta capacidades, radios de giro, estabilidad y limitaciones de uso diferentes. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 4, 'El operador debe identificar cabina, chasis, caja, sistema de elevación, frenos, dirección, neumáticos y elementos de acceso. Comprender la función de estos conjuntos facilita la inspección diaria y el uso correcto del vehículo.', array['El operador debe identificar cabina, chasis, caja, sistema de elevación, frenos, dirección, neumáticos y elementos de acceso.', 'Comprender la función de estos conjuntos facilita la inspección diaria y el uso correcto del vehículo.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 7–8', 'El operador debe identificar cabina, chasis, caja, sistema de elevación, frenos, dirección, neumáticos y elementos de acceso. Comprender la función de estos conjuntos facilita la inspección diaria y el uso correcto del vehículo. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El operador debe identificar cabina, chasis, caja, sistema de elevación, frenos, dirección, neumáticos y elementos de acceso. Comprender la función de estos conjuntos facilita la inspección diaria y el uso correcto del vehículo. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 5, 'Frente, plataforma de carga, pistas, cruces, báscula, tolvas, vertederos y acopios son áreas con riesgos específicos. El conductor debe saber qué normas y velocidades se aplican en cada una de ellas.', array['Frente, plataforma de carga, pistas, cruces, báscula, tolvas, vertederos y acopios son áreas con riesgos específicos.', 'El conductor debe saber qué normas y velocidades se aplican en cada una de ellas.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 9–10', 'Frente, plataforma de carga, pistas, cruces, báscula, tolvas, vertederos y acopios son áreas con riesgos específicos. El conductor debe saber qué normas y velocidades se aplican en cada una de ellas. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Frente, plataforma de carga, pistas, cruces, báscula, tolvas, vertederos y acopios son áreas con riesgos específicos. El conductor debe saber qué normas y velocidades se aplican en cada una de ellas. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 6, 'La coordinación entre el equipo de carga y el camión condiciona la seguridad y el rendimiento del ciclo. Las posiciones de espera, aproximación y carga deben estar definidas para evitar golpes o interferencias.', array['La coordinación entre el equipo de carga y el camión condiciona la seguridad y el rendimiento del ciclo.', 'Las posiciones de espera, aproximación y carga deben estar definidas para evitar golpes o interferencias.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 11–12', 'La coordinación entre el equipo de carga y el camión condiciona la seguridad y el rendimiento del ciclo. Las posiciones de espera, aproximación y carga deben estar definidas para evitar golpes o interferencias. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La coordinación entre el equipo de carga y el camión condiciona la seguridad y el rendimiento del ciclo. Las posiciones de espera, aproximación y carga deben estar definidas para evitar golpes o interferencias. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 7, 'El estado del firme, la pendiente, la humedad y la visibilidad modifican el comportamiento del vehículo en circulación o descarga. Una cantera segura exige adaptar la conducción a las condiciones reales del terreno.', array['El estado del firme, la pendiente, la humedad y la visibilidad modifican el comportamiento del vehículo en circulación o descarga.', 'Una cantera segura exige adaptar la conducción a las condiciones reales del terreno.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 13–14', 'El estado del firme, la pendiente, la humedad y la visibilidad modifican el comportamiento del vehículo en circulación o descarga. Una cantera segura exige adaptar la conducción a las condiciones reales del terreno. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El estado del firme, la pendiente, la humedad y la visibilidad modifican el comportamiento del vehículo en circulación o descarga. Una cantera segura exige adaptar la conducción a las condiciones reales del terreno. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 8, 'La circulación debe regirse por prioridades, sentidos de marcha, señales fijas y procedimientos de radio o aviso establecidos. La falta de comunicación multiplica el riesgo de colisión y de maniobra errónea.', array['La circulación debe regirse por prioridades, sentidos de marcha, señales fijas y procedimientos de radio o aviso establecidos.', 'La falta de comunicación multiplica el riesgo de colisión y de maniobra errónea.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 15–16', 'La circulación debe regirse por prioridades, sentidos de marcha, señales fijas y procedimientos de radio o aviso establecidos. La falta de comunicación multiplica el riesgo de colisión y de maniobra errónea. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La circulación debe regirse por prioridades, sentidos de marcha, señales fijas y procedimientos de radio o aviso establecidos. La falta de comunicación multiplica el riesgo de colisión y de maniobra errónea. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 9, 'Antes de comenzar conviene conocer recorrido, destino del material, condiciones especiales del día y puntos de atención. Una buena planificación reduce improvisaciones y ayuda a mantener un ciclo seguro y estable.', array['Antes de comenzar conviene conocer recorrido, destino del material, condiciones especiales del día y puntos de atención.', 'Una buena planificación reduce improvisaciones y ayuda a mantener un ciclo seguro y estable.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 17–18', 'Antes de comenzar conviene conocer recorrido, destino del material, condiciones especiales del día y puntos de atención. Una buena planificación reduce improvisaciones y ayuda a mantener un ciclo seguro y estable. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Antes de comenzar conviene conocer recorrido, destino del material, condiciones especiales del día y puntos de atención. Una buena planificación reduce improvisaciones y ayuda a mantener un ciclo seguro y estable. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 1, 10, 'La seguridad depende también de la actitud del operador durante toda la jornada. Respetar procedimientos, comunicar incidencias y detenerse ante una condición no segura es parte esencial del oficio.', array['La seguridad depende también de la actitud del operador durante toda la jornada.', 'Respetar procedimientos, comunicar incidencias y detenerse ante una condición no segura es parte esencial del oficio.', 'Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 19–20', 'La seguridad depende también de la actitud del operador durante toda la jornada. Respetar procedimientos, comunicar incidencias y detenerse ante una condición no segura es parte esencial del oficio. Aplicación práctica: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación.', 'La seguridad del transporte comienza entendiendo el ciclo completo y cada zona de la explotación. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La seguridad depende también de la actitud del operador durante toda la jornada. Respetar procedimientos, comunicar incidencias y detenerse ante una condición no segura es parte esencial del oficio. Aplicación en explotación: Relaciona el recorrido real del material con los equipos de carga, los viales y los puntos de descarga de tu explotación. Evidencia: identificación del circuito y zonas de trabajo');

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
