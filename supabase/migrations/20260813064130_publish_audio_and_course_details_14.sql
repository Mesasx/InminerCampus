-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 14/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 1, 'La aproximación al punto de descarga debe hacerse despacio, con buena alineación y verificando el estado del terreno. Antes de elevar la caja hay que asegurarse de que la zona es estable y está libre de personas.', array['La aproximación al punto de descarga debe hacerse despacio, con buena alineación y verificando el estado del terreno.', 'Antes de elevar la caja hay que asegurarse de que la zona es estable y está libre de personas.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 61–62', 'La aproximación al punto de descarga debe hacerse despacio, con buena alineación y verificando el estado del terreno. Antes de elevar la caja hay que asegurarse de que la zona es estable y está libre de personas. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La aproximación al punto de descarga debe hacerse despacio, con buena alineación y verificando el estado del terreno. Antes de elevar la caja hay que asegurarse de que la zona es estable y está libre de personas. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 2, 'Elevar la caja en terreno inclinado, blando o irregular puede provocar pérdida de estabilidad o vuelco. La descarga solo debe realizarse en zonas autorizadas, preparadas y con las protecciones previstas.', array['Elevar la caja en terreno inclinado, blando o irregular puede provocar pérdida de estabilidad o vuelco.', 'La descarga solo debe realizarse en zonas autorizadas, preparadas y con las protecciones previstas.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 63–64', 'Elevar la caja en terreno inclinado, blando o irregular puede provocar pérdida de estabilidad o vuelco. La descarga solo debe realizarse en zonas autorizadas, preparadas y con las protecciones previstas. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Elevar la caja en terreno inclinado, blando o irregular puede provocar pérdida de estabilidad o vuelco. La descarga solo debe realizarse en zonas autorizadas, preparadas y con las protecciones previstas. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 3, 'Cuando el material se vierte sobre tolvas, parrillas o instalaciones, el operador debe respetar topes, referencias y distancias de seguridad. La aproximación final requiere precisión y total atención al punto de descarga.', array['Cuando el material se vierte sobre tolvas, parrillas o instalaciones, el operador debe respetar topes, referencias y distancias de seguridad.', 'La aproximación final requiere precisión y total atención al punto de descarga.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 65–66', 'Cuando el material se vierte sobre tolvas, parrillas o instalaciones, el operador debe respetar topes, referencias y distancias de seguridad. La aproximación final requiere precisión y total atención al punto de descarga. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Cuando el material se vierte sobre tolvas, parrillas o instalaciones, el operador debe respetar topes, referencias y distancias de seguridad. La aproximación final requiere precisión y total atención al punto de descarga. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 4, 'Si parte de la carga queda adherida o se produce un atasco, nunca debe improvisarse una intervención peligrosa bajo la caja o junto a elementos inestables. Cualquier actuación se hará con procedimiento autorizado y el vehículo asegurado.', array['Si parte de la carga queda adherida o se produce un atasco, nunca debe improvisarse una intervención peligrosa bajo la caja o junto a elementos inestables.', 'Cualquier actuación se hará con procedimiento autorizado y el vehículo asegurado.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 67–68', 'Si parte de la carga queda adherida o se produce un atasco, nunca debe improvisarse una intervención peligrosa bajo la caja o junto a elementos inestables. Cualquier actuación se hará con procedimiento autorizado y el vehículo asegurado. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Si parte de la carga queda adherida o se produce un atasco, nunca debe improvisarse una intervención peligrosa bajo la caja o junto a elementos inestables. Cualquier actuación se hará con procedimiento autorizado y el vehículo asegurado. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 5, 'Al terminar el trabajo, el camión debe quedar inmovilizado, con la caja bajada, freno aplicado y sistemas neutralizados. Un estacionamiento deficiente puede originar desplazamientos no deseados o arranques inseguros.', array['Al terminar el trabajo, el camión debe quedar inmovilizado, con la caja bajada, freno aplicado y sistemas neutralizados.', 'Un estacionamiento deficiente puede originar desplazamientos no deseados o arranques inseguros.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 69–70', 'Al terminar el trabajo, el camión debe quedar inmovilizado, con la caja bajada, freno aplicado y sistemas neutralizados. Un estacionamiento deficiente puede originar desplazamientos no deseados o arranques inseguros. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Al terminar el trabajo, el camión debe quedar inmovilizado, con la caja bajada, freno aplicado y sistemas neutralizados. Un estacionamiento deficiente puede originar desplazamientos no deseados o arranques inseguros. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 6, 'La conservación del camión depende de una combinación de inspección diaria, revisiones programadas y uso correcto en operación. Detectar síntomas tempranos evita averías graves y prolonga la vida útil del equipo.', array['La conservación del camión depende de una combinación de inspección diaria, revisiones programadas y uso correcto en operación.', 'Detectar síntomas tempranos evita averías graves y prolonga la vida útil del equipo.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 71–72', 'La conservación del camión depende de una combinación de inspección diaria, revisiones programadas y uso correcto en operación. Detectar síntomas tempranos evita averías graves y prolonga la vida útil del equipo. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La conservación del camión depende de una combinación de inspección diaria, revisiones programadas y uso correcto en operación. Detectar síntomas tempranos evita averías graves y prolonga la vida útil del equipo. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 7, 'Toda intervención de mantenimiento debe realizarse con bloqueo y consignación de energías, evitando puestas en marcha imprevistas. El taller debe trabajar con el vehículo asegurado y apoyado según el procedimiento establecido.', array['Toda intervención de mantenimiento debe realizarse con bloqueo y consignación de energías, evitando puestas en marcha imprevistas.', 'El taller debe trabajar con el vehículo asegurado y apoyado según el procedimiento establecido.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 73–74', 'Toda intervención de mantenimiento debe realizarse con bloqueo y consignación de energías, evitando puestas en marcha imprevistas. El taller debe trabajar con el vehículo asegurado y apoyado según el procedimiento establecido. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Toda intervención de mantenimiento debe realizarse con bloqueo y consignación de energías, evitando puestas en marcha imprevistas. El taller debe trabajar con el vehículo asegurado y apoyado según el procedimiento establecido. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 8, 'El combustible, las fugas y los elementos a alta temperatura pueden originar incendios en el vehículo o en su entorno. El orden, la limpieza y la detección precoz de anomalías son medidas preventivas esenciales.', array['El combustible, las fugas y los elementos a alta temperatura pueden originar incendios en el vehículo o en su entorno.', 'El orden, la limpieza y la detección precoz de anomalías son medidas preventivas esenciales.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 75–76', 'El combustible, las fugas y los elementos a alta temperatura pueden originar incendios en el vehículo o en su entorno. El orden, la limpieza y la detección precoz de anomalías son medidas preventivas esenciales. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El combustible, las fugas y los elementos a alta temperatura pueden originar incendios en el vehículo o en su entorno. El orden, la limpieza y la detección precoz de anomalías son medidas preventivas esenciales. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 9, 'La exposición prolongada a vibraciones, ruido o jornadas monótonas reduce la capacidad de atención del operador. Reconocer signos de fatiga y aplicar pausas o medidas correctoras ayuda a prevenir errores críticos.', array['La exposición prolongada a vibraciones, ruido o jornadas monótonas reduce la capacidad de atención del operador.', 'Reconocer signos de fatiga y aplicar pausas o medidas correctoras ayuda a prevenir errores críticos.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 77–78', 'La exposición prolongada a vibraciones, ruido o jornadas monótonas reduce la capacidad de atención del operador. Reconocer signos de fatiga y aplicar pausas o medidas correctoras ayuda a prevenir errores críticos. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La exposición prolongada a vibraciones, ruido o jornadas monótonas reduce la capacidad de atención del operador. Reconocer signos de fatiga y aplicar pausas o medidas correctoras ayuda a prevenir errores críticos. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 4, 10, 'Los principales accidentes con camiones de cantera se relacionan con velocidad inadecuada, terreno deficiente, interferencias o maniobras erróneas. La prevención exige conducción defensiva, control del entorno y respeto estricto del procedimiento.', array['Los principales accidentes con camiones de cantera se relacionan con velocidad inadecuada, terreno deficiente, interferencias o maniobras erróneas.', 'La prevención exige conducción defensiva, control del entorno y respeto estricto del procedimiento.', 'Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 79–80', 'Los principales accidentes con camiones de cantera se relacionan con velocidad inadecuada, terreno deficiente, interferencias o maniobras erróneas. La prevención exige conducción defensiva, control del entorno y respeto estricto del procedimiento. Aplicación práctica: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo.', 'La descarga y el mantenimiento concentran riesgos críticos que exigen método y estabilidad. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Los principales accidentes con camiones de cantera se relacionan con velocidad inadecuada, terreno deficiente, interferencias o maniobras erróneas. La prevención exige conducción defensiva, control del entorno y respeto estricto del procedimiento. Aplicación en explotación: Verifica la estabilidad del punto de descarga y aplica bloqueo o inmovilización antes de cualquier intervención sobre el vehículo. Evidencia: verificación de descarga y mantenimiento seguro');

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
