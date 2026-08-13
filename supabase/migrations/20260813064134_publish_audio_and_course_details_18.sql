-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 18/20 a partir de sus fuentes.

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
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 1, 'Primero se evita o reduce la generación en el foco; después se actúa sobre el medio. La protección respiratoria es complemento, no sustituto de medidas técnicas y organizativas. La jerarquía evita convertir la mascarilla en solución automática.', array['Primero se evita o reduce la generación en el foco; después se actúa sobre el medio.', 'La protección respiratoria es complemento, no sustituto de medidas técnicas y organizativas.', 'La jerarquía evita convertir la mascarilla en solución automática.', 'Aplicación práctica: Ordena medidas: eliminar/reducir, cerrar/captar, organizar y complementar con EPI.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 41–42', 'Primero se evita o reduce la generación en el foco; después se actúa sobre el medio. La protección respiratoria es complemento, no sustituto de medidas técnicas y organizativas. La jerarquía evita convertir la mascarilla en solución automática. Aplicación práctica: Ordena medidas: eliminar/reducir, cerrar/captar, organizar y complementar con EPI.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Primero se evita o reduce la generación en el foco; después se actúa sobre el medio. La protección respiratoria es complemento, no sustituto de medidas técnicas y organizativas. La jerarquía evita convertir la mascarilla en solución automática. Aplicación en explotación: Ordena medidas: eliminar/reducir, cerrar/captar, organizar y complementar con EPI. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 2, 'Si es técnicamente posible, se sustituyen materiales o procedimientos por otros menos peligrosos. En minería quizá no se sustituya la roca, pero sí métodos, velocidades, caída, apertura o trabajo húmedo. Cada cambio debe evaluarse globalmente para no crear nuevos riesgos.', array['Si es técnicamente posible, se sustituyen materiales o procedimientos por otros menos peligrosos.', 'En minería quizá no se sustituya la roca, pero sí métodos, velocidades, caída, apertura o trabajo húmedo.', 'Cada cambio debe evaluarse globalmente para no crear nuevos riesgos.', 'Aplicación práctica: Compara dos métodos de trabajo y selecciona el que genera menos polvo sin aumentar otros peligros.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 43–44', 'Si es técnicamente posible, se sustituyen materiales o procedimientos por otros menos peligrosos. En minería quizá no se sustituya la roca, pero sí métodos, velocidades, caída, apertura o trabajo húmedo. Cada cambio debe evaluarse globalmente para no crear nuevos riesgos. Aplicación práctica: Compara dos métodos de trabajo y selecciona el que genera menos polvo sin aumentar otros peligros.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Si es técnicamente posible, se sustituyen materiales o procedimientos por otros menos peligrosos. En minería quizá no se sustituya la roca, pero sí métodos, velocidades, caída, apertura o trabajo húmedo. Cada cambio debe evaluarse globalmente para no crear nuevos riesgos. Aplicación en explotación: Compara dos métodos de trabajo y selecciona el que genera menos polvo sin aumentar otros peligros. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 3, 'Carenados, capotajes y cerramientos limitan la dispersión en trituradoras, cintas y transferencias. Deben mantenerse íntegros, con juntas y tapas en buen estado. Abrir cerramientos sin procedimiento puede liberar polvo acumulado.', array['Carenados, capotajes y cerramientos limitan la dispersión en trituradoras, cintas y transferencias.', 'Deben mantenerse íntegros, con juntas y tapas en buen estado.', 'Abrir cerramientos sin procedimiento puede liberar polvo acumulado.', 'Aplicación práctica: Inspecciona un cerramiento: integridad, accesos, depresión y limpieza segura.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 45–46', 'Carenados, capotajes y cerramientos limitan la dispersión en trituradoras, cintas y transferencias. Deben mantenerse íntegros, con juntas y tapas en buen estado. Abrir cerramientos sin procedimiento puede liberar polvo acumulado. Aplicación práctica: Inspecciona un cerramiento: integridad, accesos, depresión y limpieza segura.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Carenados, capotajes y cerramientos limitan la dispersión en trituradoras, cintas y transferencias. Deben mantenerse íntegros, con juntas y tapas en buen estado. Abrir cerramientos sin procedimiento puede liberar polvo acumulado. Aplicación en explotación: Inspecciona un cerramiento: integridad, accesos, depresión y limpieza segura. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 4, 'La ventilación debe dirigir el contaminante lejos de la zona de respiración. Mover aire sin captación puede desplazar el problema a otro puesto. La ventilación se diseña junto a captación, cerramientos y organización del trabajo.', array['La ventilación debe dirigir el contaminante lejos de la zona de respiración.', 'Mover aire sin captación puede desplazar el problema a otro puesto.', 'La ventilación se diseña junto a captación, cerramientos y organización del trabajo.', 'Aplicación práctica: Analiza si un ventilador reduce exposición o solo dispersa polvo hacia otros trabajadores.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 47–48', 'La ventilación debe dirigir el contaminante lejos de la zona de respiración. Mover aire sin captación puede desplazar el problema a otro puesto. La ventilación se diseña junto a captación, cerramientos y organización del trabajo. Aplicación práctica: Analiza si un ventilador reduce exposición o solo dispersa polvo hacia otros trabajadores.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La ventilación debe dirigir el contaminante lejos de la zona de respiración. Mover aire sin captación puede desplazar el problema a otro puesto. La ventilación se diseña junto a captación, cerramientos y organización del trabajo. Aplicación en explotación: Analiza si un ventilador reduce exposición o solo dispersa polvo hacia otros trabajadores. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 5, 'Humectación, pulverización y corte húmedo reducen la puesta en suspensión. El agua debe aplicarse en el punto correcto y con caudal suficiente. La medida exige mantenimiento de boquillas, presión, aporte y drenajes.', array['Humectación, pulverización y corte húmedo reducen la puesta en suspensión.', 'El agua debe aplicarse en el punto correcto y con caudal suficiente.', 'La medida exige mantenimiento de boquillas, presión, aporte y drenajes.', 'Aplicación práctica: Verifica boquillas y puntos de aplicación antes de iniciar producción.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 49–50', 'Humectación, pulverización y corte húmedo reducen la puesta en suspensión. El agua debe aplicarse en el punto correcto y con caudal suficiente. La medida exige mantenimiento de boquillas, presión, aporte y drenajes. Aplicación práctica: Verifica boquillas y puntos de aplicación antes de iniciar producción.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Humectación, pulverización y corte húmedo reducen la puesta en suspensión. El agua debe aplicarse en el punto correcto y con caudal suficiente. La medida exige mantenimiento de boquillas, presión, aporte y drenajes. Aplicación en explotación: Verifica boquillas y puntos de aplicación antes de iniciar producción. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 6, 'Captura el polvo cerca del punto de generación antes de llegar al trabajador. Campanas, conductos, filtros y separadores requieren dimensionamiento y mantenimiento. Pérdida de caudal o filtros saturados reducen la eficacia real.', array['Captura el polvo cerca del punto de generación antes de llegar al trabajador.', 'Campanas, conductos, filtros y separadores requieren dimensionamiento y mantenimiento.', 'Pérdida de caudal o filtros saturados reducen la eficacia real.', 'Aplicación práctica: Comprueba caudal, filtros, conductos y señales de fuga en una instalación de captación.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 51–52', 'Captura el polvo cerca del punto de generación antes de llegar al trabajador. Campanas, conductos, filtros y separadores requieren dimensionamiento y mantenimiento. Pérdida de caudal o filtros saturados reducen la eficacia real. Aplicación práctica: Comprueba caudal, filtros, conductos y señales de fuga en una instalación de captación.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Captura el polvo cerca del punto de generación antes de llegar al trabajador. Campanas, conductos, filtros y separadores requieren dimensionamiento y mantenimiento. Pérdida de caudal o filtros saturados reducen la eficacia real. Aplicación en explotación: Comprueba caudal, filtros, conductos y señales de fuga en una instalación de captación. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 7, 'Riego, estabilización de pistas y limitación de velocidad reducen emisiones del transporte. Limpieza de ruedas y cubrimiento de cargas evitan dispersión. Acopios pueden protegerse del viento y gestionarse para minimizar manipulación.', array['Riego, estabilización de pistas y limitación de velocidad reducen emisiones del transporte.', 'Limpieza de ruedas y cubrimiento de cargas evitan dispersión.', 'Acopios pueden protegerse del viento y gestionarse para minimizar manipulación.', 'Aplicación práctica: Define medidas para una pista seca con tráfico pesado y viento lateral.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 53–54', 'Riego, estabilización de pistas y limitación de velocidad reducen emisiones del transporte. Limpieza de ruedas y cubrimiento de cargas evitan dispersión. Acopios pueden protegerse del viento y gestionarse para minimizar manipulación. Aplicación práctica: Define medidas para una pista seca con tráfico pesado y viento lateral.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Riego, estabilización de pistas y limitación de velocidad reducen emisiones del transporte. Limpieza de ruedas y cubrimiento de cargas evitan dispersión. Acopios pueden protegerse del viento y gestionarse para minimizar manipulación. Aplicación en explotación: Define medidas para una pista seca con tráfico pesado y viento lateral. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 8, 'Debe realizarse por aspiración industrial o vía húmeda. Barrer en seco o usar aire comprimido pone el polvo en suspensión. El procedimiento debe evitar reexposición durante mantenimiento y retirada de residuos.', array['Debe realizarse por aspiración industrial o vía húmeda.', 'Barrer en seco o usar aire comprimido pone el polvo en suspensión.', 'El procedimiento debe evitar reexposición durante mantenimiento y retirada de residuos.', 'Aplicación práctica: Sustituye una limpieza en seco por un método controlado con aspiración o agua.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 55–56', 'Debe realizarse por aspiración industrial o vía húmeda. Barrer en seco o usar aire comprimido pone el polvo en suspensión. El procedimiento debe evitar reexposición durante mantenimiento y retirada de residuos. Aplicación práctica: Sustituye una limpieza en seco por un método controlado con aspiración o agua.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Debe realizarse por aspiración industrial o vía húmeda. Barrer en seco o usar aire comprimido pone el polvo en suspensión. El procedimiento debe evitar reexposición durante mantenimiento y retirada de residuos. Aplicación en explotación: Sustituye una limpieza en seco por un método controlado con aspiración o agua. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 9, 'Boquillas, captaciones, filtros, cerramientos, cabinas y riego solo protegen si funcionan. Cualquier fallo debe comunicarse y corregirse antes de continuar si compromete la exposición. El mantenimiento preventivo evita que el control se degrade sin ser visible.', array['Boquillas, captaciones, filtros, cerramientos, cabinas y riego solo protegen si funcionan.', 'Cualquier fallo debe comunicarse y corregirse antes de continuar si compromete la exposición.', 'El mantenimiento preventivo evita que el control se degrade sin ser visible.', 'Aplicación práctica: Crea una lista de comprobación para medidas colectivas críticas.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 57–58', 'Boquillas, captaciones, filtros, cerramientos, cabinas y riego solo protegen si funcionan. Cualquier fallo debe comunicarse y corregirse antes de continuar si compromete la exposición. El mantenimiento preventivo evita que el control se degrade sin ser visible. Aplicación práctica: Crea una lista de comprobación para medidas colectivas críticas.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Boquillas, captaciones, filtros, cerramientos, cabinas y riego solo protegen si funcionan. Cualquier fallo debe comunicarse y corregirse antes de continuar si compromete la exposición. El mantenimiento preventivo evita que el control se degrade sin ser visible. Aplicación en explotación: Crea una lista de comprobación para medidas colectivas críticas. Evidencia: lista de comprobación de medidas colectivas'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 3, 10, 'La cabina protege si permanece cerrada, presurizada y con filtración mantenida. Ventanas abiertas, filtros anulados o juntas deterioradas anulan la protección. El operador debe revisar indicadores y comunicar fallos de climatización o presión.', array['La cabina protege si permanece cerrada, presurizada y con filtración mantenida.', 'Ventanas abiertas, filtros anulados o juntas deterioradas anulan la protección.', 'El operador debe revisar indicadores y comunicar fallos de climatización o presión.', 'Aplicación práctica: Comprueba si una cabina opera como barrera real o solo como refugio aparente.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 59–60', 'La cabina protege si permanece cerrada, presurizada y con filtración mantenida. Ventanas abiertas, filtros anulados o juntas deterioradas anulan la protección. El operador debe revisar indicadores y comunicar fallos de climatización o presión. Aplicación práctica: Comprueba si una cabina opera como barrera real o solo como refugio aparente.', 'La prioridad preventiva está en el control colectivo y en origen. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La cabina protege si permanece cerrada, presurizada y con filtración mantenida. Ventanas abiertas, filtros anulados o juntas deterioradas anulan la protección. El operador debe revisar indicadores y comunicar fallos de climatización o presión. Aplicación en explotación: Comprueba si una cabina opera como barrera real o solo como refugio aparente. Evidencia: lista de comprobación de medidas colectivas');

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
