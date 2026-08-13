-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 12/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 1, 'La revisión previa permite detectar daños, obstáculos, pérdidas de material y anomalías visibles en el vehículo. Ningún camión debe ponerse en servicio sin haber comprobado su estado general y su entorno inmediato.', array['La revisión previa permite detectar daños, obstáculos, pérdidas de material y anomalías visibles en el vehículo.', 'Ningún camión debe ponerse en servicio sin haber comprobado su estado general y su entorno inmediato.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 21–22', 'La revisión previa permite detectar daños, obstáculos, pérdidas de material y anomalías visibles en el vehículo. Ningún camión debe ponerse en servicio sin haber comprobado su estado general y su entorno inmediato. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La revisión previa permite detectar daños, obstáculos, pérdidas de material y anomalías visibles en el vehículo. Ningún camión debe ponerse en servicio sin haber comprobado su estado general y su entorno inmediato. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 2, 'El estado de neumáticos, presión, cortes, desgaste y fijación de llantas influye directamente en la estabilidad y la seguridad. Cualquier defecto en la rodadura debe comunicarse e inmovilizarse si compromete la operación.', array['El estado de neumáticos, presión, cortes, desgaste y fijación de llantas influye directamente en la estabilidad y la seguridad.', 'Cualquier defecto en la rodadura debe comunicarse e inmovilizarse si compromete la operación.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 23–24', 'El estado de neumáticos, presión, cortes, desgaste y fijación de llantas influye directamente en la estabilidad y la seguridad. Cualquier defecto en la rodadura debe comunicarse e inmovilizarse si compromete la operación. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El estado de neumáticos, presión, cortes, desgaste y fijación de llantas influye directamente en la estabilidad y la seguridad. Cualquier defecto en la rodadura debe comunicarse e inmovilizarse si compromete la operación. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 3, 'Combustible, aceite, refrigerante y sistema hidráulico deben revisarse conforme al plan del equipo. Las fugas pueden provocar averías, incendios, pérdida de control o suelos resbaladizos en la zona de trabajo.', array['Combustible, aceite, refrigerante y sistema hidráulico deben revisarse conforme al plan del equipo.', 'Las fugas pueden provocar averías, incendios, pérdida de control o suelos resbaladizos en la zona de trabajo.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 25–26', 'Combustible, aceite, refrigerante y sistema hidráulico deben revisarse conforme al plan del equipo. Las fugas pueden provocar averías, incendios, pérdida de control o suelos resbaladizos en la zona de trabajo. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Combustible, aceite, refrigerante y sistema hidráulico deben revisarse conforme al plan del equipo. Las fugas pueden provocar averías, incendios, pérdida de control o suelos resbaladizos en la zona de trabajo. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 4, 'La subida y bajada se harán manteniendo tres puntos de apoyo y utilizando los peldaños y barandillas previstos. Saltar desde la máquina o acceder con barro en el calzado aumenta claramente el riesgo de caída.', array['La subida y bajada se harán manteniendo tres puntos de apoyo y utilizando los peldaños y barandillas previstos.', 'Saltar desde la máquina o acceder con barro en el calzado aumenta claramente el riesgo de caída.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 27–28', 'La subida y bajada se harán manteniendo tres puntos de apoyo y utilizando los peldaños y barandillas previstos. Saltar desde la máquina o acceder con barro en el calzado aumenta claramente el riesgo de caída. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La subida y bajada se harán manteniendo tres puntos de apoyo y utilizando los peldaños y barandillas previstos. Saltar desde la máquina o acceder con barro en el calzado aumenta claramente el riesgo de caída. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 5, 'Asiento, volante, espejos, cámaras y cinturón deben ajustarse antes de iniciar la marcha. Una postura correcta mejora el control del vehículo, reduce la fatiga y favorece la visibilidad del entorno.', array['Asiento, volante, espejos, cámaras y cinturón deben ajustarse antes de iniciar la marcha.', 'Una postura correcta mejora el control del vehículo, reduce la fatiga y favorece la visibilidad del entorno.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 29–30', 'Asiento, volante, espejos, cámaras y cinturón deben ajustarse antes de iniciar la marcha. Una postura correcta mejora el control del vehículo, reduce la fatiga y favorece la visibilidad del entorno. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Asiento, volante, espejos, cámaras y cinturón deben ajustarse antes de iniciar la marcha. Una postura correcta mejora el control del vehículo, reduce la fatiga y favorece la visibilidad del entorno. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 6, 'Antes de circular es necesario verificar dirección, frenos, claxon, luces, avisador de marcha atrás e instrumentos de control. Estos sistemas son la base para una conducción segura dentro de la explotación.', array['Antes de circular es necesario verificar dirección, frenos, claxon, luces, avisador de marcha atrás e instrumentos de control.', 'Estos sistemas son la base para una conducción segura dentro de la explotación.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 31–32', 'Antes de circular es necesario verificar dirección, frenos, claxon, luces, avisador de marcha atrás e instrumentos de control. Estos sistemas son la base para una conducción segura dentro de la explotación. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Antes de circular es necesario verificar dirección, frenos, claxon, luces, avisador de marcha atrás e instrumentos de control. Estos sistemas son la base para una conducción segura dentro de la explotación. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 7, 'El arranque debe realizarse con el entorno despejado, freno aplicado y sin personal en las proximidades. Los primeros metros de circulación permiten confirmar que el vehículo responde con normalidad.', array['El arranque debe realizarse con el entorno despejado, freno aplicado y sin personal en las proximidades.', 'Los primeros metros de circulación permiten confirmar que el vehículo responde con normalidad.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 33–34', 'El arranque debe realizarse con el entorno despejado, freno aplicado y sin personal en las proximidades. Los primeros metros de circulación permiten confirmar que el vehículo responde con normalidad. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El arranque debe realizarse con el entorno despejado, freno aplicado y sin personal en las proximidades. Los primeros metros de circulación permiten confirmar que el vehículo responde con normalidad. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 8, 'El camión presenta amplias zonas ciegas alrededor de la cabina y de la caja. El operador debe conocerlas y apoyarse en retrovisores, cámaras y una vigilancia reforzada antes de cualquier maniobra.', array['El camión presenta amplias zonas ciegas alrededor de la cabina y de la caja.', 'El operador debe conocerlas y apoyarse en retrovisores, cámaras y una vigilancia reforzada antes de cualquier maniobra.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 35–36', 'El camión presenta amplias zonas ciegas alrededor de la cabina y de la caja. El operador debe conocerlas y apoyarse en retrovisores, cámaras y una vigilancia reforzada antes de cualquier maniobra. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El camión presenta amplias zonas ciegas alrededor de la cabina y de la caja. El operador debe conocerlas y apoyarse en retrovisores, cámaras y una vigilancia reforzada antes de cualquier maniobra. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 9, 'Cuando el vehículo se detiene, debe quedar correctamente inmovilizado y en una posición que no cree interferencias ni riesgo de movimiento. La caja se mantendrá bajada salvo operación específica de descarga.', array['Cuando el vehículo se detiene, debe quedar correctamente inmovilizado y en una posición que no cree interferencias ni riesgo de movimiento.', 'La caja se mantendrá bajada salvo operación específica de descarga.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 37–38', 'Cuando el vehículo se detiene, debe quedar correctamente inmovilizado y en una posición que no cree interferencias ni riesgo de movimiento. La caja se mantendrá bajada salvo operación específica de descarga. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Cuando el vehículo se detiene, debe quedar correctamente inmovilizado y en una posición que no cree interferencias ni riesgo de movimiento. La caja se mantendrá bajada salvo operación específica de descarga. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 2, 10, 'Toda incidencia detectada debe registrarse y comunicarse al responsable designado sin improvisar soluciones no autorizadas. La trazabilidad de averías ayuda a prevenir fallos repetitivos y actuaciones inseguras.', array['Toda incidencia detectada debe registrarse y comunicarse al responsable designado sin improvisar soluciones no autorizadas.', 'La trazabilidad de averías ayuda a prevenir fallos repetitivos y actuaciones inseguras.', 'Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 39–40', 'Toda incidencia detectada debe registrarse y comunicarse al responsable designado sin improvisar soluciones no autorizadas. La trazabilidad de averías ayuda a prevenir fallos repetitivos y actuaciones inseguras. Aplicación práctica: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad.', 'Una buena revisión previa y una cabina bien ajustada evitan fallos desde el primer metro. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Toda incidencia detectada debe registrarse y comunicarse al responsable designado sin improvisar soluciones no autorizadas. La trazabilidad de averías ayuda a prevenir fallos repetitivos y actuaciones inseguras. Aplicación en explotación: Aplica una inspección preoperacional completa y no inicies la marcha si detectas una anomalía que comprometa la seguridad. Evidencia: lista de inspección y prearranque del camión');

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
