-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 19/20 a partir de sus fuentes.

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
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 1, 'El EPI se utiliza cuando el riesgo residual lo requiere y nunca sustituye medidas colectivas. Debe seleccionarse según exposición, tarea, duración y condiciones reales. La empresa debe justificar su necesidad y formar en uso correcto.', array['El EPI se utiliza cuando el riesgo residual lo requiere y nunca sustituye medidas colectivas.', 'Debe seleccionarse según exposición, tarea, duración y condiciones reales.', 'La empresa debe justificar su necesidad y formar en uso correcto.', 'Aplicación práctica: Distingue entre situación normal controlada y tarea excepcional que requiere respirador.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 61–62', 'El EPI se utiliza cuando el riesgo residual lo requiere y nunca sustituye medidas colectivas. Debe seleccionarse según exposición, tarea, duración y condiciones reales. La empresa debe justificar su necesidad y formar en uso correcto. Aplicación práctica: Distingue entre situación normal controlada y tarea excepcional que requiere respirador.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'El EPI se utiliza cuando el riesgo residual lo requiere y nunca sustituye medidas colectivas. Debe seleccionarse según exposición, tarea, duración y condiciones reales. La empresa debe justificar su necesidad y formar en uso correcto. Aplicación en explotación: Distingue entre situación normal controlada y tarea excepcional que requiere respirador. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 2, 'Mascarilla, filtro o equipo asistido se eligen según concentración y tiempo de uso. No todos los equipos protegen igual ni sirven para cualquier nivel de exposición. La comodidad y adaptación al trabajador influyen en el uso real.', array['Mascarilla, filtro o equipo asistido se eligen según concentración y tiempo de uso.', 'No todos los equipos protegen igual ni sirven para cualquier nivel de exposición.', 'La comodidad y adaptación al trabajador influyen en el uso real.', 'Aplicación práctica: Selecciona protección para limpieza puntual frente a trabajo prolongado en zona con SCR.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 63–64', 'Mascarilla, filtro o equipo asistido se eligen según concentración y tiempo de uso. No todos los equipos protegen igual ni sirven para cualquier nivel de exposición. La comodidad y adaptación al trabajador influyen en el uso real. Aplicación práctica: Selecciona protección para limpieza puntual frente a trabajo prolongado en zona con SCR.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Mascarilla, filtro o equipo asistido se eligen según concentración y tiempo de uso. No todos los equipos protegen igual ni sirven para cualquier nivel de exposición. La comodidad y adaptación al trabajador influyen en el uso real. Aplicación en explotación: Selecciona protección para limpieza puntual frente a trabajo prolongado en zona con SCR. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 3, 'Un equipo filtrante solo protege si sella correctamente en la cara. Barba, patillas, suciedad o talla incorrecta rompen la estanqueidad. La formación práctica debe incluir control de ajuste y ensayos cuando proceda.', array['Un equipo filtrante solo protege si sella correctamente en la cara.', 'Barba, patillas, suciedad o talla incorrecta rompen la estanqueidad.', 'La formación práctica debe incluir control de ajuste y ensayos cuando proceda.', 'Aplicación práctica: Demuestra una comprobación de ajuste antes de entrar en zona contaminada.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 65–66', 'Un equipo filtrante solo protege si sella correctamente en la cara. Barba, patillas, suciedad o talla incorrecta rompen la estanqueidad. La formación práctica debe incluir control de ajuste y ensayos cuando proceda. Aplicación práctica: Demuestra una comprobación de ajuste antes de entrar en zona contaminada.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Un equipo filtrante solo protege si sella correctamente en la cara. Barba, patillas, suciedad o talla incorrecta rompen la estanqueidad. La formación práctica debe incluir control de ajuste y ensayos cuando proceda. Aplicación en explotación: Demuestra una comprobación de ajuste antes de entrar en zona contaminada. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 4, 'El equipo se coloca antes de entrar y se retira después de salir de la zona contaminada. Debe limpiarse, revisarse y almacenarse protegido. Filtros y componentes se sustituyen según instrucciones y condiciones de uso.', array['El equipo se coloca antes de entrar y se retira después de salir de la zona contaminada.', 'Debe limpiarse, revisarse y almacenarse protegido.', 'Filtros y componentes se sustituyen según instrucciones y condiciones de uso.', 'Aplicación práctica: Describe una secuencia segura de colocación, retirada y almacenaje.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 67–68', 'El equipo se coloca antes de entrar y se retira después de salir de la zona contaminada. Debe limpiarse, revisarse y almacenarse protegido. Filtros y componentes se sustituyen según instrucciones y condiciones de uso. Aplicación práctica: Describe una secuencia segura de colocación, retirada y almacenaje.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'El equipo se coloca antes de entrar y se retira después de salir de la zona contaminada. Debe limpiarse, revisarse y almacenarse protegido. Filtros y componentes se sustituyen según instrucciones y condiciones de uso. Aplicación en explotación: Describe una secuencia segura de colocación, retirada y almacenaje. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 5, 'En zonas con riesgo no se debe comer, beber ni fumar. Hay que lavarse antes de pausas y al terminar la jornada. Debe evitarse trasladar polvo a comedor, vehículos, viviendas o zonas limpias.', array['En zonas con riesgo no se debe comer, beber ni fumar.', 'Hay que lavarse antes de pausas y al terminar la jornada.', 'Debe evitarse trasladar polvo a comedor, vehículos, viviendas o zonas limpias.', 'Aplicación práctica: Separa zona sucia y zona limpia en el recorrido diario del trabajador.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 69–70', 'En zonas con riesgo no se debe comer, beber ni fumar. Hay que lavarse antes de pausas y al terminar la jornada. Debe evitarse trasladar polvo a comedor, vehículos, viviendas o zonas limpias. Aplicación práctica: Separa zona sucia y zona limpia en el recorrido diario del trabajador.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'En zonas con riesgo no se debe comer, beber ni fumar. Hay que lavarse antes de pausas y al terminar la jornada. Debe evitarse trasladar polvo a comedor, vehículos, viviendas o zonas limpias. Aplicación en explotación: Separa zona sucia y zona limpia en el recorrido diario del trabajador. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 6, 'La ropa contaminada no debe llevarse a casa. Debe guardarse separada de la ropa de calle y manipularse sin liberar polvo. La empresa organiza limpieza o descontaminación cuando procede.', array['La ropa contaminada no debe llevarse a casa.', 'Debe guardarse separada de la ropa de calle y manipularse sin liberar polvo.', 'La empresa organiza limpieza o descontaminación cuando procede.', 'Aplicación práctica: Define el circuito de vestuario, retirada, almacenamiento y lavado de ropa contaminada.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 71–72', 'La ropa contaminada no debe llevarse a casa. Debe guardarse separada de la ropa de calle y manipularse sin liberar polvo. La empresa organiza limpieza o descontaminación cuando procede. Aplicación práctica: Define el circuito de vestuario, retirada, almacenamiento y lavado de ropa contaminada.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La ropa contaminada no debe llevarse a casa. Debe guardarse separada de la ropa de calle y manipularse sin liberar polvo. La empresa organiza limpieza o descontaminación cuando procede. Aplicación en explotación: Define el circuito de vestuario, retirada, almacenamiento y lavado de ropa contaminada. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 7, 'La vigilancia debe ser adecuada, específica y realizada por personal sanitario competente. Periodicidad y contenido se fijan según riesgo y protocolos, no solo por porcentaje de sílice. La información sanitaria es confidencial, pero sus conclusiones preventivas deben integrarse.', array['La vigilancia debe ser adecuada, específica y realizada por personal sanitario competente.', 'Periodicidad y contenido se fijan según riesgo y protocolos, no solo por porcentaje de sílice.', 'La información sanitaria es confidencial, pero sus conclusiones preventivas deben integrarse.', 'Aplicación práctica: Relaciona vigilancia sanitaria con revisión de condiciones de trabajo.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 73–74', 'La vigilancia debe ser adecuada, específica y realizada por personal sanitario competente. Periodicidad y contenido se fijan según riesgo y protocolos, no solo por porcentaje de sílice. La información sanitaria es confidencial, pero sus conclusiones preventivas deben integrarse. Aplicación práctica: Relaciona vigilancia sanitaria con revisión de condiciones de trabajo.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'La vigilancia debe ser adecuada, específica y realizada por personal sanitario competente. Periodicidad y contenido se fijan según riesgo y protocolos, no solo por porcentaje de sílice. La información sanitaria es confidencial, pero sus conclusiones preventivas deben integrarse. Aplicación en explotación: Relaciona vigilancia sanitaria con revisión de condiciones de trabajo. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 8, 'El reconocimiento no sustituye el control de exposición. Los síntomas requieren valoración temprana y pueden motivar revisión preventiva. Debe evitarse ocultar información o normalizar molestias respiratorias.', array['El reconocimiento no sustituye el control de exposición.', 'Los síntomas requieren valoración temprana y pueden motivar revisión preventiva.', 'Debe evitarse ocultar información o normalizar molestias respiratorias.', 'Aplicación práctica: Explica cuándo comunicar un síntoma y a quién acudir.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 75–76', 'El reconocimiento no sustituye el control de exposición. Los síntomas requieren valoración temprana y pueden motivar revisión preventiva. Debe evitarse ocultar información o normalizar molestias respiratorias. Aplicación práctica: Explica cuándo comunicar un síntoma y a quién acudir.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'El reconocimiento no sustituye el control de exposición. Los síntomas requieren valoración temprana y pueden motivar revisión preventiva. Debe evitarse ocultar información o normalizar molestias respiratorias. Aplicación en explotación: Explica cuándo comunicar un síntoma y a quién acudir. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 9, 'Fallo de riego, aspiración, filtros, cabina o EPI debe comunicarse de inmediato. Avisar sin abandonar la exposición puede resultar insuficiente. La protección individual no sustituye el restablecimiento de medidas colectivas.', array['Fallo de riego, aspiración, filtros, cabina o EPI debe comunicarse de inmediato.', 'Avisar sin abandonar la exposición puede resultar insuficiente.', 'La protección individual no sustituye el restablecimiento de medidas colectivas.', 'Aplicación práctica: Decide cuándo parar, comunicar y pedir apoyo especializado.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 77–78', 'Fallo de riego, aspiración, filtros, cabina o EPI debe comunicarse de inmediato. Avisar sin abandonar la exposición puede resultar insuficiente. La protección individual no sustituye el restablecimiento de medidas colectivas. Aplicación práctica: Decide cuándo parar, comunicar y pedir apoyo especializado.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Fallo de riego, aspiración, filtros, cabina o EPI debe comunicarse de inmediato. Avisar sin abandonar la exposición puede resultar insuficiente. La protección individual no sustituye el restablecimiento de medidas colectivas. Aplicación en explotación: Decide cuándo parar, comunicar y pedir apoyo especializado. Evidencia: demostración de EPI, higiene y ajuste'),
  ('prevencion-polvo-silice-cristalina-respirable', 20, 4, 10, 'Tos persistente o dificultad respiratoria se comunican al servicio sanitario. Los síntomas no miden exposición, pero pueden indicar una deficiencia colectiva. Debe revisarse medición, controles y personas potencialmente afectadas.', array['Tos persistente o dificultad respiratoria se comunican al servicio sanitario.', 'Los síntomas no miden exposición, pero pueden indicar una deficiencia colectiva.', 'Debe revisarse medición, controles y personas potencialmente afectadas.', 'Aplicación práctica: Define una respuesta que proteja al trabajador y al resto de la plantilla.']::text[], 'observar, medir, documentar y corregir antes de normalizar la exposición.', 'Presentación oficial Inmíner · Curso 6', 'Diapositivas 79–80', 'Tos persistente o dificultad respiratoria se comunican al servicio sanitario. Los síntomas no miden exposición, pero pueden indicar una deficiencia colectiva. Debe revisarse medición, controles y personas potencialmente afectadas. Aplicación práctica: Define una respuesta que proteja al trabajador y al resto de la plantilla.', 'El EPI protege solo cuando está bien seleccionado, ajustado y mantenido. Punto de control: observar, medir, documentar y corregir antes de normalizar la exposición.', 'Tos persistente o dificultad respiratoria se comunican al servicio sanitario. Los síntomas no miden exposición, pero pueden indicar una deficiencia colectiva. Debe revisarse medición, controles y personas potencialmente afectadas. Aplicación en explotación: Define una respuesta que proteja al trabajador y al resto de la plantilla. Evidencia: demostración de EPI, higiene y ajuste');

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
