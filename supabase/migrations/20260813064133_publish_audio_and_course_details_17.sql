-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 17/20 a partir de sus fuentes.

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
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 1, 'La referencia minera específica es la Orden TED/723/2021 que aprueba la ITC 02.0.02. También aplican RD 665/1997 sobre agentes cancerígenos y RD 374/2001 sobre agentes químicos. El DSS debe integrar normativa específica y obligaciones generales de prevención.', array['La referencia minera específica es la Orden TED/723/2021 que aprueba la ITC 02.0.02.', 'También aplican RD 665/1997 sobre agentes cancerígenos y RD 374/2001 sobre agentes químicos.', 'El DSS debe integrar normativa específica y obligaciones generales de prevención.', 'Aplicación práctica: Comprueba que la evaluación y el DSS no mantienen referencias derogadas ni criterios antiguos.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 21–22', 'La referencia minera específica es la Orden TED/723/2021 que aprueba la ITC 02.0.02. También aplican RD 665/1997 sobre agentes cancerígenos y RD 374/2001 sobre agentes químicos. El DSS debe integrar normativa específica y obligaciones generales de prevención. Aplicación práctica: Comprueba que la evaluación y el DSS no mantienen referencias derogadas ni criterios antiguos.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La referencia minera específica es la Orden TED/723/2021 que aprueba la ITC 02.0.02. También aplican RD 665/1997 sobre agentes cancerígenos y RD 374/2001 sobre agentes químicos. El DSS debe integrar normativa específica y obligaciones generales de prevención. Aplicación en explotación: Comprueba que la evaluación y el DSS no mantienen referencias derogadas ni criterios antiguos. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 2, 'Los trabajos con exposición a polvo respirable de sílice cristalina se consideran procedimientos cancerígenos. La exposición debe evitarse o reducirse al nivel más bajo técnicamente posible. No basta con estar por debajo de un número: hay que justificar sustitución, captación, higiene, información y vigilancia.', array['Los trabajos con exposición a polvo respirable de sílice cristalina se consideran procedimientos cancerígenos.', 'La exposición debe evitarse o reducirse al nivel más bajo técnicamente posible.', 'No basta con estar por debajo de un número: hay que justificar sustitución, captación, higiene, información y vigilancia.', 'Aplicación práctica: Justifica qué medidas colectivas se han valorado antes de recurrir a EPI.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 23–24', 'Los trabajos con exposición a polvo respirable de sílice cristalina se consideran procedimientos cancerígenos. La exposición debe evitarse o reducirse al nivel más bajo técnicamente posible. No basta con estar por debajo de un número: hay que justificar sustitución, captación, higiene, información y vigilancia. Aplicación práctica: Justifica qué medidas colectivas se han valorado antes de recurrir a EPI.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Los trabajos con exposición a polvo respirable de sílice cristalina se consideran procedimientos cancerígenos. La exposición debe evitarse o reducirse al nivel más bajo técnicamente posible. No basta con estar por debajo de un número: hay que justificar sustitución, captación, higiene, información y vigilancia. Aplicación en explotación: Justifica qué medidas colectivas se han valorado antes de recurrir a EPI. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 3, 'Deben cumplirse simultáneamente 3 mg/m³ para polvo respirable total y 0,05 mg/m³ para SCR. Ambos límites son VLA-ED referidos a jornada estándar de ocho horas. Un resultado bajo de polvo total no garantiza conformidad si la proporción de SCR es alta.', array['Deben cumplirse simultáneamente 3 mg/m³ para polvo respirable total y 0,05 mg/m³ para SCR.', 'Ambos límites son VLA-ED referidos a jornada estándar de ocho horas.', 'Un resultado bajo de polvo total no garantiza conformidad si la proporción de SCR es alta.', 'Aplicación práctica: Interpreta resultados separando polvo respirable y sílice cristalina respirable.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 25–26', 'Deben cumplirse simultáneamente 3 mg/m³ para polvo respirable total y 0,05 mg/m³ para SCR. Ambos límites son VLA-ED referidos a jornada estándar de ocho horas. Un resultado bajo de polvo total no garantiza conformidad si la proporción de SCR es alta. Aplicación práctica: Interpreta resultados separando polvo respirable y sílice cristalina respirable.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Deben cumplirse simultáneamente 3 mg/m³ para polvo respirable total y 0,05 mg/m³ para SCR. Ambos límites son VLA-ED referidos a jornada estándar de ocho horas. Un resultado bajo de polvo total no garantiza conformidad si la proporción de SCR es alta. Aplicación en explotación: Interpreta resultados separando polvo respirable y sílice cristalina respirable. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 4, 'Cumplir el valor límite no permite abandonar el control preventivo. Al ser agente cancerígeno, se debe reducir la exposición todo lo técnicamente posible. Trabajar cerca del límite deja poco margen ante viento, fallos de riego o aumento de producción.', array['Cumplir el valor límite no permite abandonar el control preventivo.', 'Al ser agente cancerígeno, se debe reducir la exposición todo lo técnicamente posible.', 'Trabajar cerca del límite deja poco margen ante viento, fallos de riego o aumento de producción.', 'Aplicación práctica: Propón una mejora incluso cuando la medición no supera el límite.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 27–28', 'Cumplir el valor límite no permite abandonar el control preventivo. Al ser agente cancerígeno, se debe reducir la exposición todo lo técnicamente posible. Trabajar cerca del límite deja poco margen ante viento, fallos de riego o aumento de producción. Aplicación práctica: Propón una mejora incluso cuando la medición no supera el límite.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Cumplir el valor límite no permite abandonar el control preventivo. Al ser agente cancerígeno, se debe reducir la exposición todo lo técnicamente posible. Trabajar cerca del límite deja poco margen ante viento, fallos de riego o aumento de producción. Aplicación en explotación: Propón una mejora incluso cuando la medición no supera el límite. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 5, 'La evaluación debe identificar puestos, tareas, materiales, focos, duración e intensidad de exposición. Incluye operaciones ordinarias, mantenimiento, limpieza, acceso puntual y trabajos subcontratados. La exposición indirecta también forma parte del análisis preventivo.', array['La evaluación debe identificar puestos, tareas, materiales, focos, duración e intensidad de exposición.', 'Incluye operaciones ordinarias, mantenimiento, limpieza, acceso puntual y trabajos subcontratados.', 'La exposición indirecta también forma parte del análisis preventivo.', 'Aplicación práctica: Elabora una matriz tarea-puesto-foco-personas expuestas.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 29–30', 'La evaluación debe identificar puestos, tareas, materiales, focos, duración e intensidad de exposición. Incluye operaciones ordinarias, mantenimiento, limpieza, acceso puntual y trabajos subcontratados. La exposición indirecta también forma parte del análisis preventivo. Aplicación práctica: Elabora una matriz tarea-puesto-foco-personas expuestas.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La evaluación debe identificar puestos, tareas, materiales, focos, duración e intensidad de exposición. Incluye operaciones ordinarias, mantenimiento, limpieza, acceso puntual y trabajos subcontratados. La exposición indirecta también forma parte del análisis preventivo. Aplicación en explotación: Elabora una matriz tarea-puesto-foco-personas expuestas. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 6, 'El muestreo debe representar la jornada, las condiciones reales y los trabajos significativos. La muestra personal refleja la exposición en la zona de respiración del trabajador. La estrategia debe explicar duración, caudal, equipo, puesto, tareas y condiciones.', array['El muestreo debe representar la jornada, las condiciones reales y los trabajos significativos.', 'La muestra personal refleja la exposición en la zona de respiración del trabajador.', 'La estrategia debe explicar duración, caudal, equipo, puesto, tareas y condiciones.', 'Aplicación práctica: Detecta si una campaña de medición es representativa o si deja fuera una tarea crítica.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 31–32', 'El muestreo debe representar la jornada, las condiciones reales y los trabajos significativos. La muestra personal refleja la exposición en la zona de respiración del trabajador. La estrategia debe explicar duración, caudal, equipo, puesto, tareas y condiciones. Aplicación práctica: Detecta si una campaña de medición es representativa o si deja fuera una tarea crítica.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'El muestreo debe representar la jornada, las condiciones reales y los trabajos significativos. La muestra personal refleja la exposición en la zona de respiración del trabajador. La estrategia debe explicar duración, caudal, equipo, puesto, tareas y condiciones. Aplicación en explotación: Detecta si una campaña de medición es representativa o si deja fuera una tarea crítica. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 7, 'La toma de muestras debe realizarla personal competente con equipos adecuados. Los resultados dependen de calibración, caudal, volumen, filtro, análisis y trazabilidad. Una medición sin contexto operativo pierde utilidad preventiva.', array['La toma de muestras debe realizarla personal competente con equipos adecuados.', 'Los resultados dependen de calibración, caudal, volumen, filtro, análisis y trazabilidad.', 'Una medición sin contexto operativo pierde utilidad preventiva.', 'Aplicación práctica: Revisa qué datos mínimos debe contener la ficha de muestreo.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 33–34', 'La toma de muestras debe realizarla personal competente con equipos adecuados. Los resultados dependen de calibración, caudal, volumen, filtro, análisis y trazabilidad. Una medición sin contexto operativo pierde utilidad preventiva. Aplicación práctica: Revisa qué datos mínimos debe contener la ficha de muestreo.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La toma de muestras debe realizarla personal competente con equipos adecuados. Los resultados dependen de calibración, caudal, volumen, filtro, análisis y trazabilidad. Una medición sin contexto operativo pierde utilidad preventiva. Aplicación en explotación: Revisa qué datos mínimos debe contener la ficha de muestreo. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 8, 'La ITC exige mediciones periódicas al menos una vez cada cuatrimestre del año natural. Repetir siempre en el momento más favorable reduce la utilidad preventiva. La periodicidad puede ampliarse si cambian condiciones o aparecen incidencias.', array['La ITC exige mediciones periódicas al menos una vez cada cuatrimestre del año natural.', 'Repetir siempre en el momento más favorable reduce la utilidad preventiva.', 'La periodicidad puede ampliarse si cambian condiciones o aparecen incidencias.', 'Aplicación práctica: Planifica campañas que cubran variaciones de producción, clima y turnos.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 35–36', 'La ITC exige mediciones periódicas al menos una vez cada cuatrimestre del año natural. Repetir siempre en el momento más favorable reduce la utilidad preventiva. La periodicidad puede ampliarse si cambian condiciones o aparecen incidencias. Aplicación práctica: Planifica campañas que cubran variaciones de producción, clima y turnos.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La ITC exige mediciones periódicas al menos una vez cada cuatrimestre del año natural. Repetir siempre en el momento más favorable reduce la utilidad preventiva. La periodicidad puede ampliarse si cambian condiciones o aparecen incidencias. Aplicación en explotación: Planifica campañas que cubran variaciones de producción, clima y turnos. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 9, 'Se revisa ante cambios, daños a la salud o medidas insuficientes. En minería debe revisarse en todo caso cada tres años. Nueva trituradora, cambio de material o resultados crecientes exigen actuar antes.', array['Se revisa ante cambios, daños a la salud o medidas insuficientes.', 'En minería debe revisarse en todo caso cada tres años.', 'Nueva trituradora, cambio de material o resultados crecientes exigen actuar antes.', 'Aplicación práctica: Decide cuándo una modificación del proceso obliga a revisar la evaluación.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 37–38', 'Se revisa ante cambios, daños a la salud o medidas insuficientes. En minería debe revisarse en todo caso cada tres años. Nueva trituradora, cambio de material o resultados crecientes exigen actuar antes. Aplicación práctica: Decide cuándo una modificación del proceso obliga a revisar la evaluación.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Se revisa ante cambios, daños a la salud o medidas insuficientes. En minería debe revisarse en todo caso cada tres años. Nueva trituradora, cambio de material o resultados crecientes exigen actuar antes. Aplicación en explotación: Decide cuándo una modificación del proceso obliga a revisar la evaluación. Evidencia: caso con medición, VLA-ED y decisión preventiva'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 2, 10, 'Cada trabajador debe conocer riesgos, resultados que le afecten y medidas implantadas. Los valores se registran en fichas individualizadas y se incorporan al expediente médico. La comunicación debe ser comprensible, trazable y relacionada con el puesto.', array['Cada trabajador debe conocer riesgos, resultados que le afecten y medidas implantadas.', 'Los valores se registran en fichas individualizadas y se incorporan al expediente médico.', 'La comunicación debe ser comprensible, trazable y relacionada con el puesto.', 'Aplicación práctica: Transforma un resultado numérico en una explicación útil para el trabajador.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 39–40', 'Cada trabajador debe conocer riesgos, resultados que le afecten y medidas implantadas. Los valores se registran en fichas individualizadas y se incorporan al expediente médico. La comunicación debe ser comprensible, trazable y relacionada con el puesto. Aplicación práctica: Transforma un resultado numérico en una explicación útil para el trabajador.', 'El dato solo es útil si representa el puesto, la tarea y la jornada real. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Cada trabajador debe conocer riesgos, resultados que le afecten y medidas implantadas. Los valores se registran en fichas individualizadas y se incorporan al expediente médico. La comunicación debe ser comprensible, trazable y relacionada con el puesto. Aplicación en explotación: Transforma un resultado numérico en una explicación útil para el trabajador. Evidencia: caso con medición, VLA-ED y decisión preventiva');

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
