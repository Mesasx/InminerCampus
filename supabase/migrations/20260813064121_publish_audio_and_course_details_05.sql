-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 5/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 1, 'Algunos paneles clasifican las alarmas en tres niveles. El primero informa de avisos básicos; el segundo exige corregir la forma de trabajo o revisar la anomalía; y el tercero incorpora una alarma sonora y requiere detener la máquina de inmediato. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Algunos paneles clasifican las alarmas en tres niveles', 'El primero informa de avisos básicos; el segundo exige corregir la forma de trabajo o revisar la anomalía', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '222–235', 'Algunos paneles clasifican las alarmas en tres niveles. El primero informa de avisos básicos; el segundo exige corregir la forma de trabajo o revisar la anomalía; y el tercero incorpora una alarma sonora y requiere detener la máquina de inmediato. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Algunos paneles clasifican las alarmas en tres niveles. El primero informa de avisos básicos; el segundo exige corregir la forma de trabajo o revisar la anomalía; y el tercero incorpora una alarma sonora y requiere detener la máquina de inmediato. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 2, 'Los volquetes modernos pueden incorporar sistemas de pesaje e indicadores de carga. Respete siempre la carga nominal y las advertencias del fabricante: una sobrecarga afecta al comportamiento de la unidad y aumenta las exigencias sobre neumáticos, dirección y frenos. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Los volquetes modernos pueden incorporar sistemas de pesaje e indicadores de carga', 'Respete siempre la carga nominal y las advertencias del fabricante: una sobrecarga afecta al comportamiento de la unidad y aumenta las exigencias sobre.', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '236–238', 'Los volquetes modernos pueden incorporar sistemas de pesaje e indicadores de carga. Respete siempre la carga nominal y las advertencias del fabricante: una sobrecarga afecta al comportamiento de la unidad y aumenta las exigencias sobre neumáticos, dirección y frenos. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Los volquetes modernos pueden incorporar sistemas de pesaje e indicadores de carga. Respete siempre la carga nominal y las advertencias del fabricante: una sobrecarga afecta al comportamiento de la unidad y aumenta las exigencias sobre neumáticos, dirección y frenos. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 3, 'Vigile continuamente la superficie de rodadura e informe de baches, roderas, blandones, piedras u otros obstáculos. El mal estado de la pista reduce la estabilidad, daña los neumáticos y obliga a adaptar la velocidad y la conducción. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Vigile continuamente la superficie de rodadura e informe de baches, roderas, blandones, piedras u otros obstáculos', 'El mal estado de la pista reduce la estabilidad, daña los neumáticos y obliga a adaptar la velocidad y la conducción', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '246–252', 'Vigile continuamente la superficie de rodadura e informe de baches, roderas, blandones, piedras u otros obstáculos. El mal estado de la pista reduce la estabilidad, daña los neumáticos y obliga a adaptar la velocidad y la conducción. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Vigile continuamente la superficie de rodadura e informe de baches, roderas, blandones, piedras u otros obstáculos. El mal estado de la pista reduce la estabilidad, daña los neumáticos y obliga a adaptar la velocidad y la conducción. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 4, 'Respete el sentido de circulación y las prioridades establecidas en la DIS. Un adelantamiento solo se hará si está permitido, existe espacio y visibilidad suficientes, puede completarse con rapidez y el conductor del vehículo adelantado confirma la maniobra por radio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Respete el sentido de circulación y las prioridades establecidas en la DIS', 'Un adelantamiento solo se hará si está permitido, existe espacio y visibilidad suficientes', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '246–252 y 281–283', 'Respete el sentido de circulación y las prioridades establecidas en la DIS. Un adelantamiento solo se hará si está permitido, existe espacio y visibilidad suficientes, puede completarse con rapidez y el conductor del vehículo adelantado confirma la maniobra por radio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Respete el sentido de circulación y las prioridades establecidas en la DIS. Un adelantamiento solo se hará si está permitido, existe espacio y visibilidad suficientes, puede completarse con rapidez y el conductor del vehículo adelantado confirma la maniobra por radio. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 5, 'Los peatones deben seguir el itinerario definido por la explotación. En pistas de doble sentido caminarán por el lado izquierdo y, cuando sea posible, harán lo mismo en las de sentido único, utilizando casco y ropa de alta visibilidad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Los peatones deben seguir el itinerario definido por la explotación', 'En pistas de doble sentido caminarán por el lado izquierdo y, cuando sea posible, harán lo mismo en las de sentido único', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '279–284', 'Los peatones deben seguir el itinerario definido por la explotación. En pistas de doble sentido caminarán por el lado izquierdo y, cuando sea posible, harán lo mismo en las de sentido único, utilizando casco y ropa de alta visibilidad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Los peatones deben seguir el itinerario definido por la explotación. En pistas de doble sentido caminarán por el lado izquierdo y, cuando sea posible, harán lo mismo en las de sentido único, utilizando casco y ropa de alta visibilidad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 6, 'Según el manual del curso, las líneas de alta tensión deben señalizarse veinticinco metros antes. Circule con la caja bajada y respete la DIS: al cruzarlas debe conservarse la distancia vertical establecida, nunca inferior a cuatro metros y aumentada según la tensión de la línea. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Según el manual del curso, las líneas de alta tensión deben señalizarse veinticinco metros antes', 'Circule con la caja bajada y respete la DIS: al cruzarlas debe conservarse la distancia vertical establecida', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Circule con la caja bajada y respete la DIS: al cruzarlas debe conservarse la distancia vertical establecida, nunca inferior a cuatro metros y…', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '285–286', 'Según el manual del curso, las líneas de alta tensión deben señalizarse veinticinco metros antes. Circule con la caja bajada y respete la DIS: al cruzarlas debe conservarse la distancia vertical establecida, nunca inferior a cuatro metros y aumentada según la tensión de la línea. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Según el manual del curso, las líneas de alta tensión deben señalizarse veinticinco metros antes. Circule con la caja bajada y respete la DIS: al cruzarlas debe conservarse la distancia vertical establecida, nunca inferior a cuatro metros y aumentada según la tensión de la línea. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 7, 'El cinturón debe utilizarse siempre que la unidad disponga de estructura ROPS. Ambos sistemas trabajan conjuntamente: la cabina conserva un espacio de protección y el cinturón mantiene al operador sujeto dentro de él durante un vuelco. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El cinturón debe utilizarse siempre que la unidad disponga de estructura ROPS', 'Ambos sistemas trabajan conjuntamente: la cabina conserva un espacio de protección y el cinturón mantiene al operador sujeto dentro de él durante un vuelco', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '212–214', 'El cinturón debe utilizarse siempre que la unidad disponga de estructura ROPS. Ambos sistemas trabajan conjuntamente: la cabina conserva un espacio de protección y el cinturón mantiene al operador sujeto dentro de él durante un vuelco. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El cinturón debe utilizarse siempre que la unidad disponga de estructura ROPS. Ambos sistemas trabajan conjuntamente: la cabina conserva un espacio de protección y el cinturón mantiene al operador sujeto dentro de él durante un vuelco. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 8, 'Utilice los equipos exigidos para cada tarea: casco al abandonar la cabina, calzado de seguridad antideslizante, ropa de alta visibilidad, guantes adecuados y protección auditiva o visual cuando corresponda. Los EPI deben estar homologados y en buen estado. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Utilice los equipos exigidos para cada tarea: casco al abandonar la cabina, calzado de seguridad antideslizante, ropa de alta visibilidad', 'Los EPI deben estar homologados y en buen estado', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '108–110', 'Utilice los equipos exigidos para cada tarea: casco al abandonar la cabina, calzado de seguridad antideslizante, ropa de alta visibilidad, guantes adecuados y protección auditiva o visual cuando corresponda. Los EPI deben estar homologados y en buen estado. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Utilice los equipos exigidos para cada tarea: casco al abandonar la cabina, calzado de seguridad antideslizante, ropa de alta visibilidad, guantes adecuados y protección auditiva o visual cuando corresponda. Los EPI deben estar homologados y en buen estado. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 9, 'Ante un accidente, aplique la conducta PAS: proteger la zona para evitar nuevos riesgos, avisar a los servicios de emergencia y socorrer sin agravar las lesiones. Conozca las vías de evacuación, los responsables y el punto de encuentro de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Ante un accidente, aplique la conducta PAS: proteger la zona para evitar nuevos riesgos', 'Conozca las vías de evacuación, los responsables y el punto de encuentro de la explotación', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '111–116', 'Ante un accidente, aplique la conducta PAS: proteger la zona para evitar nuevos riesgos, avisar a los servicios de emergencia y socorrer sin agravar las lesiones. Conozca las vías de evacuación, los responsables y el punto de encuentro de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Ante un accidente, aplique la conducta PAS: proteger la zona para evitar nuevos riesgos, avisar a los servicios de emergencia y socorrer sin agravar las lesiones. Conozca las vías de evacuación, los responsables y el punto de encuentro de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 5, 10, 'El trabajo se encuadra en la Ley de Prevención de Riesgos Laborales, los reales decretos 1215/1997 y 1389/1997, la ITC 02.1.02 y la Especificación Técnica 2000-1-08. Además, deben cumplirse el manual del fabricante y las Disposiciones Internas de Seguridad de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El trabajo se encuadra en la Ley de Prevención de Riesgos Laborales, los reales decretos 1215/1997 y 1389/1997', 'Además, deben cumplirse el manual del fabricante y las Disposiciones Internas de Seguridad de la explotación', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '289–302', 'El trabajo se encuadra en la Ley de Prevención de Riesgos Laborales, los reales decretos 1215/1997 y 1389/1997, la ITC 02.1.02 y la Especificación Técnica 2000-1-08. Además, deben cumplirse el manual del fabricante y las Disposiciones Internas de Seguridad de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'El entorno de trabajo exige anticipación, comunicación y cumplimiento de la DIS. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El trabajo se encuadra en la Ley de Prevención de Riesgos Laborales, los reales decretos 1215/1997 y 1389/1997, la ITC 02.1.02 y la Especificación Técnica 2000-1-08. Además, deben cumplirse el manual del fabricante y las Disposiciones Internas de Seguridad de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Confirma que el entorno, las interferencias y la normativa interna se cumplen antes de operar. Evidencia: registro de entorno, interferencias y DIS');

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
