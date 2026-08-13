-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 13/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 1, 'La aproximación a pala o excavadora debe hacerse a baja velocidad, por la trayectoria prevista y con total atención a las indicaciones del cargador. Adelantarse o invadir la zona activa crea un riesgo grave de impacto.', array['La aproximación a pala o excavadora debe hacerse a baja velocidad, por la trayectoria prevista y con total atención a las indicaciones del cargador.', 'Adelantarse o invadir la zona activa crea un riesgo grave de impacto.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 41–42', 'La aproximación a pala o excavadora debe hacerse a baja velocidad, por la trayectoria prevista y con total atención a las indicaciones del cargador. Adelantarse o invadir la zona activa crea un riesgo grave de impacto. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La aproximación a pala o excavadora debe hacerse a baja velocidad, por la trayectoria prevista y con total atención a las indicaciones del cargador. Adelantarse o invadir la zona activa crea un riesgo grave de impacto. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 2, 'El camión debe colocarse en el punto de carga definido, sobre terreno competente y orientado para una salida segura. Una mala colocación dificulta el trabajo del cargador y aumenta el peligro de golpear la caja o la cabina.', array['El camión debe colocarse en el punto de carga definido, sobre terreno competente y orientado para una salida segura.', 'Una mala colocación dificulta el trabajo del cargador y aumenta el peligro de golpear la caja o la cabina.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 43–44', 'El camión debe colocarse en el punto de carga definido, sobre terreno competente y orientado para una salida segura. Una mala colocación dificulta el trabajo del cargador y aumenta el peligro de golpear la caja o la cabina. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El camión debe colocarse en el punto de carga definido, sobre terreno competente y orientado para una salida segura. Una mala colocación dificulta el trabajo del cargador y aumenta el peligro de golpear la caja o la cabina. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 3, 'La carga debe repartirse con homogeneidad dentro de la caja para no comprometer la estabilidad ni castigar el bastidor. La sobrecarga incrementa el desgaste y el riesgo en frenadas, curvas y pendientes.', array['La carga debe repartirse con homogeneidad dentro de la caja para no comprometer la estabilidad ni castigar el bastidor.', 'La sobrecarga incrementa el desgaste y el riesgo en frenadas, curvas y pendientes.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 45–46', 'La carga debe repartirse con homogeneidad dentro de la caja para no comprometer la estabilidad ni castigar el bastidor. La sobrecarga incrementa el desgaste y el riesgo en frenadas, curvas y pendientes. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La carga debe repartirse con homogeneidad dentro de la caja para no comprometer la estabilidad ni castigar el bastidor. La sobrecarga incrementa el desgaste y el riesgo en frenadas, curvas y pendientes. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 4, 'Los viales deben recorrerse dentro de los límites de velocidad, con control continuo del firme y de la distancia de seguridad. Conducir con anticipación es imprescindible en equipos de gran masa y largo tiempo de respuesta.', array['Los viales deben recorrerse dentro de los límites de velocidad, con control continuo del firme y de la distancia de seguridad.', 'Conducir con anticipación es imprescindible en equipos de gran masa y largo tiempo de respuesta.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 47–48', 'Los viales deben recorrerse dentro de los límites de velocidad, con control continuo del firme y de la distancia de seguridad. Conducir con anticipación es imprescindible en equipos de gran masa y largo tiempo de respuesta. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Los viales deben recorrerse dentro de los límites de velocidad, con control continuo del firme y de la distancia de seguridad. Conducir con anticipación es imprescindible en equipos de gran masa y largo tiempo de respuesta. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 5, 'La velocidad debe adaptarse a carga, pendiente, visibilidad y estado del vial en cada momento. Mantener distancia de seguridad permite reaccionar ante frenadas, baches o presencia repentina de otros equipos.', array['La velocidad debe adaptarse a carga, pendiente, visibilidad y estado del vial en cada momento.', 'Mantener distancia de seguridad permite reaccionar ante frenadas, baches o presencia repentina de otros equipos.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 49–50', 'La velocidad debe adaptarse a carga, pendiente, visibilidad y estado del vial en cada momento. Mantener distancia de seguridad permite reaccionar ante frenadas, baches o presencia repentina de otros equipos. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'La velocidad debe adaptarse a carga, pendiente, visibilidad y estado del vial en cada momento. Mantener distancia de seguridad permite reaccionar ante frenadas, baches o presencia repentina de otros equipos. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 6, 'En curvas y rasantes la visibilidad disminuye y el riesgo de inestabilidad aumenta si se entra con exceso de velocidad. Las pendientes deben afrontarse con la marcha y la técnica adecuadas al manual del equipo.', array['En curvas y rasantes la visibilidad disminuye y el riesgo de inestabilidad aumenta si se entra con exceso de velocidad.', 'Las pendientes deben afrontarse con la marcha y la técnica adecuadas al manual del equipo.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 51–52', 'En curvas y rasantes la visibilidad disminuye y el riesgo de inestabilidad aumenta si se entra con exceso de velocidad. Las pendientes deben afrontarse con la marcha y la técnica adecuadas al manual del equipo. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'En curvas y rasantes la visibilidad disminuye y el riesgo de inestabilidad aumenta si se entra con exceso de velocidad. Las pendientes deben afrontarse con la marcha y la técnica adecuadas al manual del equipo. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 7, 'El polvo en suspensión dificulta la percepción de distancias y puede ocultar vehículos o peatones. El riego de viales reduce la exposición, pero exige adaptar también la conducción a un firme que puede cambiar de adherencia.', array['El polvo en suspensión dificulta la percepción de distancias y puede ocultar vehículos o peatones.', 'El riego de viales reduce la exposición, pero exige adaptar también la conducción a un firme que puede cambiar de adherencia.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 53–54', 'El polvo en suspensión dificulta la percepción de distancias y puede ocultar vehículos o peatones. El riego de viales reduce la exposición, pero exige adaptar también la conducción a un firme que puede cambiar de adherencia. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'El polvo en suspensión dificulta la percepción de distancias y puede ocultar vehículos o peatones. El riego de viales reduce la exposición, pero exige adaptar también la conducción a un firme que puede cambiar de adherencia. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 8, 'Las maniobras hacia atrás se reducirán al mínimo y siempre se ejecutarán con máxima precaución. Si la visibilidad no es suficiente, se recurrirá a ayudas externas conforme a las normas internas de la cantera.', array['Las maniobras hacia atrás se reducirán al mínimo y siempre se ejecutarán con máxima precaución.', 'Si la visibilidad no es suficiente, se recurrirá a ayudas externas conforme a las normas internas de la cantera.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 55–56', 'Las maniobras hacia atrás se reducirán al mínimo y siempre se ejecutarán con máxima precaución. Si la visibilidad no es suficiente, se recurrirá a ayudas externas conforme a las normas internas de la cantera. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Las maniobras hacia atrás se reducirán al mínimo y siempre se ejecutarán con máxima precaución. Si la visibilidad no es suficiente, se recurrirá a ayudas externas conforme a las normas internas de la cantera. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 9, 'En los puntos de pesaje o control el conductor debe seguir la señalización, detenerse correctamente y respetar el orden de paso. El control de peso forma parte tanto de la operación segura como de la trazabilidad del material.', array['En los puntos de pesaje o control el conductor debe seguir la señalización, detenerse correctamente y respetar el orden de paso.', 'El control de peso forma parte tanto de la operación segura como de la trazabilidad del material.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 57–58', 'En los puntos de pesaje o control el conductor debe seguir la señalización, detenerse correctamente y respetar el orden de paso. El control de peso forma parte tanto de la operación segura como de la trazabilidad del material. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'En los puntos de pesaje o control el conductor debe seguir la señalización, detenerse correctamente y respetar el orden de paso. El control de peso forma parte tanto de la operación segura como de la trazabilidad del material. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero'),
  ('operador-maquinaria-transporte-camion-volquete', 20, 3, 10, 'Una conducción suave, sin aceleraciones ni frenazos innecesarios, reduce consumo, desgaste y fatiga del vehículo. La conducción eficiente también disminuye el riesgo de pérdida de control y mejora la regularidad del ciclo.', array['Una conducción suave, sin aceleraciones ni frenazos innecesarios, reduce consumo, desgaste y fatiga del vehículo.', 'La conducción eficiente también disminuye el riesgo de pérdida de control y mejora la regularidad del ciclo.', 'Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.']::text[], 'observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5', 'Diapositivas 59–60', 'Una conducción suave, sin aceleraciones ni frenazos innecesarios, reduce consumo, desgaste y fatiga del vehículo. La conducción eficiente también disminuye el riesgo de pérdida de control y mejora la regularidad del ciclo. Aplicación práctica: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra.', 'Carga, vial y conducción deben mantenerse siempre bajo control, incluso en condiciones cambiantes. Punto de control: observar el entorno, comunicar incidencias y no normalizar maniobras inseguras.', 'Una conducción suave, sin aceleraciones ni frenazos innecesarios, reduce consumo, desgaste y fatiga del vehículo. La conducción eficiente también disminuye el riesgo de pérdida de control y mejora la regularidad del ciclo. Aplicación en explotación: Comprueba en pista velocidad, visibilidad, carga y prioridad de paso antes de cada desplazamiento o maniobra. Evidencia: control de circulación, carga y vial minero');

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
