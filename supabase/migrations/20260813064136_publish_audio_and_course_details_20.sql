-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 20/20 a partir de sus fuentes.

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
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 1, 'La documentación se integra en el Documento sobre Seguridad y Salud. Debe incluir evaluación, criterios de muestreo, resultados y medidas de prevención y protección. Debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida.', array['La documentación se integra en el Documento sobre Seguridad y Salud.', 'Debe incluir evaluación, criterios de muestreo, resultados y medidas de prevención y protección.', 'Debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida.', 'Aplicación práctica: Revisa si el expediente permite identificar medida, responsable y plazo de seguimiento.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 81–82', 'La documentación se integra en el Documento sobre Seguridad y Salud. Debe incluir evaluación, criterios de muestreo, resultados y medidas de prevención y protección. Debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida. Aplicación práctica: Revisa si el expediente permite identificar medida, responsable y plazo de seguimiento.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La documentación se integra en el Documento sobre Seguridad y Salud. Debe incluir evaluación, criterios de muestreo, resultados y medidas de prevención y protección. Debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida. Aplicación en explotación: Revisa si el expediente permite identificar medida, responsable y plazo de seguimiento. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 2, 'Registran puesto, jornada, equipo, condiciones de trabajo y resultados de polvo y SCR. Deben relacionar resultado y condiciones: duración, caudal, volumen, material, controles y anomalías. Sin contexto, dos concentraciones numéricas pueden interpretarse mal.', array['Registran puesto, jornada, equipo, condiciones de trabajo y resultados de polvo y SCR.', 'Deben relacionar resultado y condiciones: duración, caudal, volumen, material, controles y anomalías.', 'Sin contexto, dos concentraciones numéricas pueden interpretarse mal.', 'Aplicación práctica: Completa una ficha trazable para una campaña de muestreo.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 83–84', 'Registran puesto, jornada, equipo, condiciones de trabajo y resultados de polvo y SCR. Deben relacionar resultado y condiciones: duración, caudal, volumen, material, controles y anomalías. Sin contexto, dos concentraciones numéricas pueden interpretarse mal. Aplicación práctica: Completa una ficha trazable para una campaña de muestreo.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Registran puesto, jornada, equipo, condiciones de trabajo y resultados de polvo y SCR. Deben relacionar resultado y condiciones: duración, caudal, volumen, material, controles y anomalías. Sin contexto, dos concentraciones numéricas pueden interpretarse mal. Aplicación en explotación: Completa una ficha trazable para una campaña de muestreo. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 3, 'Las fichas estadísticas se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre. También se presentan anualmente a la Autoridad Minera con modificaciones del DSS. La remisión no sustituye el análisis interno ni la acción preventiva.', array['Las fichas estadísticas se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre.', 'También se presentan anualmente a la Autoridad Minera con modificaciones del DSS.', 'La remisión no sustituye el análisis interno ni la acción preventiva.', 'Aplicación práctica: Decide qué hacer internamente cuando un resultado aumenta aunque todavía no supere el VLA.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 85–86', 'Las fichas estadísticas se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre. También se presentan anualmente a la Autoridad Minera con modificaciones del DSS. La remisión no sustituye el análisis interno ni la acción preventiva. Aplicación práctica: Decide qué hacer internamente cuando un resultado aumenta aunque todavía no supere el VLA.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Las fichas estadísticas se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre. También se presentan anualmente a la Autoridad Minera con modificaciones del DSS. La remisión no sustituye el análisis interno ni la acción preventiva. Aplicación en explotación: Decide qué hacer internamente cuando un resultado aumenta aunque todavía no supere el VLA. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 4, 'Cada desviación debe traducirse en medida concreta, responsable y plazo. La acción correctora se verifica para confirmar que reduce la exposición. Cerrar un hallazgo sin comprobar eficacia deja el riesgo activo.', array['Cada desviación debe traducirse en medida concreta, responsable y plazo.', 'La acción correctora se verifica para confirmar que reduce la exposición.', 'Cerrar un hallazgo sin comprobar eficacia deja el riesgo activo.', 'Aplicación práctica: Redacta una acción correctora para una captación con fuga y define evidencia de cierre.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 87–88', 'Cada desviación debe traducirse en medida concreta, responsable y plazo. La acción correctora se verifica para confirmar que reduce la exposición. Cerrar un hallazgo sin comprobar eficacia deja el riesgo activo. Aplicación práctica: Redacta una acción correctora para una captación con fuga y define evidencia de cierre.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Cada desviación debe traducirse en medida concreta, responsable y plazo. La acción correctora se verifica para confirmar que reduce la exposición. Cerrar un hallazgo sin comprobar eficacia deja el riesgo activo. Aplicación en explotación: Redacta una acción correctora para una captación con fuga y define evidencia de cierre. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 5, 'Debe conocer riesgos, resultados, medidas, procedimientos y limitaciones del EPI. La información debe ser comprensible y vinculada al puesto. No basta con entregar un documento si el trabajador no puede aplicarlo.', array['Debe conocer riesgos, resultados, medidas, procedimientos y limitaciones del EPI.', 'La información debe ser comprensible y vinculada al puesto.', 'No basta con entregar un documento si el trabajador no puede aplicarlo.', 'Aplicación práctica: Convierte una instrucción técnica en una pauta clara antes de entrar en producción.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 89–90', 'Debe conocer riesgos, resultados, medidas, procedimientos y limitaciones del EPI. La información debe ser comprensible y vinculada al puesto. No basta con entregar un documento si el trabajador no puede aplicarlo. Aplicación práctica: Convierte una instrucción técnica en una pauta clara antes de entrar en producción.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Debe conocer riesgos, resultados, medidas, procedimientos y limitaciones del EPI. La información debe ser comprensible y vinculada al puesto. No basta con entregar un documento si el trabajador no puede aplicarlo. Aplicación en explotación: Convierte una instrucción técnica en una pauta clara antes de entrar en producción. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 6, 'La formación debe ser suficiente, adecuada y específica del puesto. Debe incluir comprensión del riesgo, aplicación de medidas y uso correcto de protección respiratoria. La reproducción del audio no acredita por sí sola competencia.', array['La formación debe ser suficiente, adecuada y específica del puesto.', 'Debe incluir comprensión del riesgo, aplicación de medidas y uso correcto de protección respiratoria.', 'La reproducción del audio no acredita por sí sola competencia.', 'Aplicación práctica: Define una evidencia práctica que demuestre competencia real.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 91–92', 'La formación debe ser suficiente, adecuada y específica del puesto. Debe incluir comprensión del riesgo, aplicación de medidas y uso correcto de protección respiratoria. La reproducción del audio no acredita por sí sola competencia. Aplicación práctica: Define una evidencia práctica que demuestre competencia real.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La formación debe ser suficiente, adecuada y específica del puesto. Debe incluir comprensión del riesgo, aplicación de medidas y uso correcto de protección respiratoria. La reproducción del audio no acredita por sí sola competencia. Aplicación en explotación: Define una evidencia práctica que demuestre competencia real. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 7, 'La formación frente a polvo y sílice se repite como mínimo una vez al año. Debe actualizarse ante cambios de funciones, puesto, lugar, tecnología, equipos o conocimientos. La modalidad de 20 horas no elimina el refuerzo anual mínimo.', array['La formación frente a polvo y sílice se repite como mínimo una vez al año.', 'Debe actualizarse ante cambios de funciones, puesto, lugar, tecnología, equipos o conocimientos.', 'La modalidad de 20 horas no elimina el refuerzo anual mínimo.', 'Aplicación práctica: Planifica actualización anual y actualización extraordinaria por cambio de proceso.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 93–94', 'La formación frente a polvo y sílice se repite como mínimo una vez al año. Debe actualizarse ante cambios de funciones, puesto, lugar, tecnología, equipos o conocimientos. La modalidad de 20 horas no elimina el refuerzo anual mínimo. Aplicación práctica: Planifica actualización anual y actualización extraordinaria por cambio de proceso.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La formación frente a polvo y sílice se repite como mínimo una vez al año. Debe actualizarse ante cambios de funciones, puesto, lugar, tecnología, equipos o conocimientos. La modalidad de 20 horas no elimina el refuerzo anual mínimo. Aplicación en explotación: Planifica actualización anual y actualización extraordinaria por cambio de proceso. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 8, 'Trabajadores y representantes deben recibir información y participar conforme a la normativa. Su experiencia ayuda a detectar focos y fallos reales no visibles en una visita puntual. La participación mejora la calidad de la evaluación y la eficacia de las medidas.', array['Trabajadores y representantes deben recibir información y participar conforme a la normativa.', 'Su experiencia ayuda a detectar focos y fallos reales no visibles en una visita puntual.', 'La participación mejora la calidad de la evaluación y la eficacia de las medidas.', 'Aplicación práctica: Integra observaciones de operadores en la revisión de focos de polvo.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 95–96', 'Trabajadores y representantes deben recibir información y participar conforme a la normativa. Su experiencia ayuda a detectar focos y fallos reales no visibles en una visita puntual. La participación mejora la calidad de la evaluación y la eficacia de las medidas. Aplicación práctica: Integra observaciones de operadores en la revisión de focos de polvo.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Trabajadores y representantes deben recibir información y participar conforme a la normativa. Su experiencia ayuda a detectar focos y fallos reales no visibles en una visita puntual. La participación mejora la calidad de la evaluación y la eficacia de las medidas. Aplicación en explotación: Integra observaciones de operadores en la revisión de focos de polvo. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 9, 'Antes de trabajar se verifican riego, aspiración, ventilación y cabina. También se revisa protección respiratoria, zonas restringidas y comunicaciones. Cualquier anomalía se comunica antes de exponerse.', array['Antes de trabajar se verifican riego, aspiración, ventilación y cabina.', 'También se revisa protección respiratoria, zonas restringidas y comunicaciones.', 'Cualquier anomalía se comunica antes de exponerse.', 'Aplicación práctica: Crea un check previo de 60 segundos para el inicio de turno.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 97–98', 'Antes de trabajar se verifican riego, aspiración, ventilación y cabina. También se revisa protección respiratoria, zonas restringidas y comunicaciones. Cualquier anomalía se comunica antes de exponerse. Aplicación práctica: Crea un check previo de 60 segundos para el inicio de turno.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Antes de trabajar se verifican riego, aspiración, ventilación y cabina. También se revisa protección respiratoria, zonas restringidas y comunicaciones. Cualquier anomalía se comunica antes de exponerse. Aplicación en explotación: Crea un check previo de 60 segundos para el inicio de turno. Evidencia: ficha trazable de acción correctora y seguimiento'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 5, 10, 'La silicosis es prevenible si se controla el polvo desde el origen. Las medidas colectivas deben mantenerse y cada persona debe aplicar procedimientos. Trabajar sin nube visible no garantiza seguridad: medición, evaluación y disciplina acompañan cada tarea.', array['La silicosis es prevenible si se controla el polvo desde el origen.', 'Las medidas colectivas deben mantenerse y cada persona debe aplicar procedimientos.', 'Trabajar sin nube visible no garantiza seguridad: medición, evaluación y disciplina acompañan cada tarea.', 'Aplicación práctica: Resume qué hará el trabajador mañana para reducir exposición propia y de compañeros.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 99–100', 'La silicosis es prevenible si se controla el polvo desde el origen. Las medidas colectivas deben mantenerse y cada persona debe aplicar procedimientos. Trabajar sin nube visible no garantiza seguridad: medición, evaluación y disciplina acompañan cada tarea. Aplicación práctica: Resume qué hará el trabajador mañana para reducir exposición propia y de compañeros.', 'Sin trazabilidad no hay mejora: cada resultado debe conducir a una decisión. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La silicosis es prevenible si se controla el polvo desde el origen. Las medidas colectivas deben mantenerse y cada persona debe aplicar procedimientos. Trabajar sin nube visible no garantiza seguridad: medición, evaluación y disciplina acompañan cada tarea. Aplicación en explotación: Resume qué hará el trabajador mañana para reducir exposición propia y de compañeros. Evidencia: ficha trazable de acción correctora y seguimiento');

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
