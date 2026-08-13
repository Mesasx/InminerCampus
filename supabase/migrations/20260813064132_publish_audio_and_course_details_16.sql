-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 16/20 a partir de sus fuentes.

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
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 1, 'Materia sólida particulada dispersa en el aire por procesos mecánicos o corrientes de aire. En minería puede aparecer en extracción, carga, transporte, trituración, limpieza y mantenimiento. No basta con “ver” polvo: hay que identificar material, proceso y fracción capaz de llegar al trabajador.', array['Materia sólida particulada dispersa en el aire por procesos mecánicos o corrientes de aire.', 'En minería puede aparecer en extracción, carga, transporte, trituración, limpieza y mantenimiento.', 'No basta con “ver” polvo: hay que identificar material, proceso y fracción capaz de llegar al trabajador.', 'Aplicación práctica: Ubica en el plano del centro qué tareas generan polvo y qué personas pueden recibir exposición directa o indirecta.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 1–2', 'Materia sólida particulada dispersa en el aire por procesos mecánicos o corrientes de aire. En minería puede aparecer en extracción, carga, transporte, trituración, limpieza y mantenimiento. No basta con “ver” polvo: hay que identificar material, proceso y fracción capaz de llegar al trabajador. Aplicación práctica: Ubica en el plano del centro qué tareas generan polvo y qué personas pueden recibir exposición directa o indirecta.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Materia sólida particulada dispersa en el aire por procesos mecánicos o corrientes de aire. En minería puede aparecer en extracción, carga, transporte, trituración, limpieza y mantenimiento. No basta con “ver” polvo: hay que identificar material, proceso y fracción capaz de llegar al trabajador. Aplicación en explotación: Ubica en el plano del centro qué tareas generan polvo y qué personas pueden recibir exposición directa o indirecta. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 2, 'La sílice cristalina es dióxido de silicio cristalizado, normalmente cuarzo o cristobalita. El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas. El porcentaje de sílice ayuda a caracterizar el peligro, pero la exposición real depende de proceso, humedad, ventilación y tiempo.', array['La sílice cristalina es dióxido de silicio cristalizado, normalmente cuarzo o cristobalita.', 'El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas.', 'El porcentaje de sílice ayuda a caracterizar el peligro, pero la exposición real depende de proceso, humedad, ventilación y tiempo.', 'Aplicación práctica: Relaciona litologías, áridos o rocas del centro con tareas capaces de liberar SCR.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 3–4', 'La sílice cristalina es dióxido de silicio cristalizado, normalmente cuarzo o cristobalita. El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas. El porcentaje de sílice ayuda a caracterizar el peligro, pero la exposición real depende de proceso, humedad, ventilación y tiempo. Aplicación práctica: Relaciona litologías, áridos o rocas del centro con tareas capaces de liberar SCR.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La sílice cristalina es dióxido de silicio cristalizado, normalmente cuarzo o cristobalita. El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas. El porcentaje de sílice ayuda a caracterizar el peligro, pero la exposición real depende de proceso, humedad, ventilación y tiempo. Aplicación en explotación: Relaciona litologías, áridos o rocas del centro con tareas capaces de liberar SCR. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 3, 'Debe existir un material con sílice y una tarea capaz de liberar partículas respirables. La evaluación incluye focos cercanos aunque el puesto no genere directamente el polvo. Mecánicos, laboratorio u oficina pueden exponerse si acceden a producción.', array['Debe existir un material con sílice y una tarea capaz de liberar partículas respirables.', 'La evaluación incluye focos cercanos aunque el puesto no genere directamente el polvo.', 'Mecánicos, laboratorio u oficina pueden exponerse si acceden a producción.', 'Aplicación práctica: Identifica puestos no operativos que entran de forma puntual en zonas con polvo.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 5–6', 'Debe existir un material con sílice y una tarea capaz de liberar partículas respirables. La evaluación incluye focos cercanos aunque el puesto no genere directamente el polvo. Mecánicos, laboratorio u oficina pueden exponerse si acceden a producción. Aplicación práctica: Identifica puestos no operativos que entran de forma puntual en zonas con polvo.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Debe existir un material con sílice y una tarea capaz de liberar partículas respirables. La evaluación incluye focos cercanos aunque el puesto no genere directamente el polvo. Mecánicos, laboratorio u oficina pueden exponerse si acceden a producción. Aplicación en explotación: Identifica puestos no operativos que entran de forma puntual en zonas con polvo. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 4, 'Extracción, perforación, trituración, molienda, tamizado, carga y transporte son focos habituales. Limpiezas, paradas, averías, apertura de equipos o vaciado de filtros pueden generar picos intensos. Las tareas breves no deben desaparecer de la evaluación por ser poco frecuentes.', array['Extracción, perforación, trituración, molienda, tamizado, carga y transporte son focos habituales.', 'Limpiezas, paradas, averías, apertura de equipos o vaciado de filtros pueden generar picos intensos.', 'Las tareas breves no deben desaparecer de la evaluación por ser poco frecuentes.', 'Aplicación práctica: Recorre el proceso completo desde el frente hasta el producto final y marca focos ordinarios y no rutinarios.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 7–8', 'Extracción, perforación, trituración, molienda, tamizado, carga y transporte son focos habituales. Limpiezas, paradas, averías, apertura de equipos o vaciado de filtros pueden generar picos intensos. Las tareas breves no deben desaparecer de la evaluación por ser poco frecuentes. Aplicación práctica: Recorre el proceso completo desde el frente hasta el producto final y marca focos ordinarios y no rutinarios.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Extracción, perforación, trituración, molienda, tamizado, carga y transporte son focos habituales. Limpiezas, paradas, averías, apertura de equipos o vaciado de filtros pueden generar picos intensos. Las tareas breves no deben desaparecer de la evaluación por ser poco frecuentes. Aplicación en explotación: Recorre el proceso completo desde el frente hasta el producto final y marca focos ordinarios y no rutinarios. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 5, 'La fracción inhalable entra por nariz y boca; la torácica supera la laringe. La fracción respirable alcanza zonas profundas del pulmón y es clave para SCR. Dos nubes aparentemente iguales pueden tener efectos diferentes según tamaño de partícula.', array['La fracción inhalable entra por nariz y boca; la torácica supera la laringe.', 'La fracción respirable alcanza zonas profundas del pulmón y es clave para SCR.', 'Dos nubes aparentemente iguales pueden tener efectos diferentes según tamaño de partícula.', 'Aplicación práctica: Diferencia exposición visible de exposición respirable y justifica por qué se necesita medición.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 9–10', 'La fracción inhalable entra por nariz y boca; la torácica supera la laringe. La fracción respirable alcanza zonas profundas del pulmón y es clave para SCR. Dos nubes aparentemente iguales pueden tener efectos diferentes según tamaño de partícula. Aplicación práctica: Diferencia exposición visible de exposición respirable y justifica por qué se necesita medición.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La fracción inhalable entra por nariz y boca; la torácica supera la laringe. La fracción respirable alcanza zonas profundas del pulmón y es clave para SCR. Dos nubes aparentemente iguales pueden tener efectos diferentes según tamaño de partícula. Aplicación en explotación: Diferencia exposición visible de exposición respirable y justifica por qué se necesita medición. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 6, 'Las partículas finas permanecen suspendidas más tiempo y se desplazan con el aire. Una nube no visible no garantiza ambiente seguro. La decisión preventiva debe apoyarse en mediciones representativas y conocimiento del proceso.', array['Las partículas finas permanecen suspendidas más tiempo y se desplazan con el aire.', 'Una nube no visible no garantiza ambiente seguro.', 'La decisión preventiva debe apoyarse en mediciones representativas y conocimiento del proceso.', 'Aplicación práctica: Explica por qué una zona aparentemente limpia puede requerir control si hay fuente respirable cercana.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 11–12', 'Las partículas finas permanecen suspendidas más tiempo y se desplazan con el aire. Una nube no visible no garantiza ambiente seguro. La decisión preventiva debe apoyarse en mediciones representativas y conocimiento del proceso. Aplicación práctica: Explica por qué una zona aparentemente limpia puede requerir control si hay fuente respirable cercana.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Las partículas finas permanecen suspendidas más tiempo y se desplazan con el aire. Una nube no visible no garantiza ambiente seguro. La decisión preventiva debe apoyarse en mediciones representativas y conocimiento del proceso. Aplicación en explotación: Explica por qué una zona aparentemente limpia puede requerir control si hay fuente respirable cercana. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 7, 'El polvo puede provocar irritación, molestias respiratorias y estornudos. La SCR puede causar silicosis, pérdida de función pulmonar, tuberculosis, enfermedad renal y cáncer de pulmón. El riesgo depende de concentración, tiempo y picos de exposición.', array['El polvo puede provocar irritación, molestias respiratorias y estornudos.', 'La SCR puede causar silicosis, pérdida de función pulmonar, tuberculosis, enfermedad renal y cáncer de pulmón.', 'El riesgo depende de concentración, tiempo y picos de exposición.', 'Aplicación práctica: Relaciona síntomas, vigilancia sanitaria y revisión de medidas sin esperar a que exista daño irreversible.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 13–14', 'El polvo puede provocar irritación, molestias respiratorias y estornudos. La SCR puede causar silicosis, pérdida de función pulmonar, tuberculosis, enfermedad renal y cáncer de pulmón. El riesgo depende de concentración, tiempo y picos de exposición. Aplicación práctica: Relaciona síntomas, vigilancia sanitaria y revisión de medidas sin esperar a que exista daño irreversible.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'El polvo puede provocar irritación, molestias respiratorias y estornudos. La SCR puede causar silicosis, pérdida de función pulmonar, tuberculosis, enfermedad renal y cáncer de pulmón. El riesgo depende de concentración, tiempo y picos de exposición. Aplicación en explotación: Relaciona síntomas, vigilancia sanitaria y revisión de medidas sin esperar a que exista daño irreversible. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 8, 'Enfermedad pulmonar grave e irreversible causada por inhalación de SCR. Puede progresar incluso después de cesar la exposición. La prevención primaria es más eficaz que cualquier actuación posterior.', array['Enfermedad pulmonar grave e irreversible causada por inhalación de SCR.', 'Puede progresar incluso después de cesar la exposición.', 'La prevención primaria es más eficaz que cualquier actuación posterior.', 'Aplicación práctica: Explica por qué la formación debe centrarse en control antes del daño y no solo en reconocimiento médico.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 15–16', 'Enfermedad pulmonar grave e irreversible causada por inhalación de SCR. Puede progresar incluso después de cesar la exposición. La prevención primaria es más eficaz que cualquier actuación posterior. Aplicación práctica: Explica por qué la formación debe centrarse en control antes del daño y no solo en reconocimiento médico.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Enfermedad pulmonar grave e irreversible causada por inhalación de SCR. Puede progresar incluso después de cesar la exposición. La prevención primaria es más eficaz que cualquier actuación posterior. Aplicación en explotación: Explica por qué la formación debe centrarse en control antes del daño y no solo en reconocimiento médico. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 9, 'Puede presentarse de forma crónica, acelerada o aguda según intensidad y duración. Exposiciones altas acortan mucho los plazos de aparición. Averías de aspiración, limpiezas incorrectas o tareas excepcionales requieren control inmediato.', array['Puede presentarse de forma crónica, acelerada o aguda según intensidad y duración.', 'Exposiciones altas acortan mucho los plazos de aparición.', 'Averías de aspiración, limpiezas incorrectas o tareas excepcionales requieren control inmediato.', 'Aplicación práctica: Identifica situaciones de pico que no pueden normalizarse en el trabajo diario.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 17–18', 'Puede presentarse de forma crónica, acelerada o aguda según intensidad y duración. Exposiciones altas acortan mucho los plazos de aparición. Averías de aspiración, limpiezas incorrectas o tareas excepcionales requieren control inmediato. Aplicación práctica: Identifica situaciones de pico que no pueden normalizarse en el trabajo diario.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Puede presentarse de forma crónica, acelerada o aguda según intensidad y duración. Exposiciones altas acortan mucho los plazos de aparición. Averías de aspiración, limpiezas incorrectas o tareas excepcionales requieren control inmediato. Aplicación en explotación: Identifica situaciones de pico que no pueden normalizarse en el trabajo diario. Evidencia: mapa de focos y rutas de exposición'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 1, 10, 'Influyen naturaleza de la roca, humedad, maquinaria, pistas, viento, climatología y aplicación de agua. Una pista seca con tráfico y viento emite mucho más que una pista húmeda y estabilizada. El análisis se actualiza si cambian estación, producción, maquinaria o método.', array['Influyen naturaleza de la roca, humedad, maquinaria, pistas, viento, climatología y aplicación de agua.', 'Una pista seca con tráfico y viento emite mucho más que una pista húmeda y estabilizada.', 'El análisis se actualiza si cambian estación, producción, maquinaria o método.', 'Aplicación práctica: Revisa qué medidas de invierno pueden resultar insuficientes en periodo seco y ventoso.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 19–20', 'Influyen naturaleza de la roca, humedad, maquinaria, pistas, viento, climatología y aplicación de agua. Una pista seca con tráfico y viento emite mucho más que una pista húmeda y estabilizada. El análisis se actualiza si cambian estación, producción, maquinaria o método. Aplicación práctica: Revisa qué medidas de invierno pueden resultar insuficientes en periodo seco y ventoso.', 'La exposición empieza en el foco, pero puede alcanzar puestos directos e indirectos. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Influyen naturaleza de la roca, humedad, maquinaria, pistas, viento, climatología y aplicación de agua. Una pista seca con tráfico y viento emite mucho más que una pista húmeda y estabilizada. El análisis se actualiza si cambian estación, producción, maquinaria o método. Aplicación en explotación: Revisa qué medidas de invierno pueden resultar insuficientes en periodo seco y ventoso. Evidencia: mapa de focos y rutas de exposición');

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
