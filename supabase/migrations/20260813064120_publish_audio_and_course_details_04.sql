-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 4/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 1, 'Aproxímese a la tolva o escombrera con suavidad y siguiendo la señalización. Tras una parada prolongada, avise con la bocina antes de retroceder, avance lentamente y controle la trayectoria por los espejos y los sistemas de ayuda disponibles. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Aproxímese a la tolva o escombrera con suavidad y siguiendo la señalización', 'Tras una parada prolongada, avise con la bocina antes de retroceder, avance lentamente y controle la trayectoria por los espejos y los sistemas de ayuda.', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '80–85 y 253–254', 'Aproxímese a la tolva o escombrera con suavidad y siguiendo la señalización. Tras una parada prolongada, avise con la bocina antes de retroceder, avance lentamente y controle la trayectoria por los espejos y los sistemas de ayuda disponibles. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Aproxímese a la tolva o escombrera con suavidad y siguiendo la señalización. Tras una parada prolongada, avise con la bocina antes de retroceder, avance lentamente y controle la trayectoria por los espejos y los sistemas de ayuda disponibles. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 2, 'Al elevar la caja aumenta la altura del centro de gravedad y, con ella, el riesgo de vuelco lateral. Sitúe la parte posterior del volquete en terreno firme y horizontal, sin inclinación transversal, y respete las condiciones indicadas por el fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Al elevar la caja aumenta la altura del centro de gravedad y, con ella, el riesgo de vuelco lateral', 'Sitúe la parte posterior del volquete en terreno firme y horizontal, sin inclinación transversal, y respete las condiciones indicadas por el fabricante', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '80–85', 'Al elevar la caja aumenta la altura del centro de gravedad y, con ella, el riesgo de vuelco lateral. Sitúe la parte posterior del volquete en terreno firme y horizontal, sin inclinación transversal, y respete las condiciones indicadas por el fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Al elevar la caja aumenta la altura del centro de gravedad y, con ella, el riesgo de vuelco lateral. Sitúe la parte posterior del volquete en terreno firme y horizontal, sin inclinación transversal, y respete las condiciones indicadas por el fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 3, 'El borde de una escombrera puede ceder bajo el peso del eje trasero. Mantenga una distancia segura, utilice únicamente las zonas de vertido autorizadas y respete la señalización, las bermas y las indicaciones del responsable de la descarga. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El borde de una escombrera puede ceder bajo el peso del eje trasero', 'Mantenga una distancia segura, utilice únicamente las zonas de vertido autorizadas y respete la señalización', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '80–85 y 253–254', 'El borde de una escombrera puede ceder bajo el peso del eje trasero. Mantenga una distancia segura, utilice únicamente las zonas de vertido autorizadas y respete la señalización, las bermas y las indicaciones del responsable de la descarga. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El borde de una escombrera puede ceder bajo el peso del eje trasero. Mantenga una distancia segura, utilice únicamente las zonas de vertido autorizadas y respete la señalización, las bermas y las indicaciones del responsable de la descarga. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 4, 'Detenga el volquete antes de alcanzar el borde o la tolva. Los topes metálicos, de madera u hormigón son referencias de aviso para no seguir retrocediendo; no deben utilizarse como freno ni como garantía de contención, salvo que estén diseñados expresamente para ello. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Detenga el volquete antes de alcanzar el borde o la tolva', 'Los topes metálicos, de madera u hormigón son referencias de aviso para no seguir retrocediendo', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Los topes metálicos, de madera u hormigón son referencias de aviso para no seguir retrocediendo; no deben utilizarse como freno ni como garantía de…', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '80–85 y 253–254', 'Detenga el volquete antes de alcanzar el borde o la tolva. Los topes metálicos, de madera u hormigón son referencias de aviso para no seguir retrocediendo; no deben utilizarse como freno ni como garantía de contención, salvo que estén diseñados expresamente para ello. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Detenga el volquete antes de alcanzar el borde o la tolva. Los topes metálicos, de madera u hormigón son referencias de aviso para no seguir retrocediendo; no deben utilizarse como freno ni como garantía de contención, salvo que estén diseñados expresamente para ello. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 5, 'Antes de descargar en la tolva, espere la señal de autorización y compruebe que la zona está despejada. Realice el vertido de forma gradual para reducir el riesgo de atascos en la machacadora, especialmente cuando el material contiene bloques grandes. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Antes de descargar en la tolva, espere la señal de autorización y compruebe que la zona está despejada', 'Realice el vertido de forma gradual para reducir el riesgo de atascos en la machacadora, especialmente cuando el material contiene bloques grandes', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '80–85 y 253–254', 'Antes de descargar en la tolva, espere la señal de autorización y compruebe que la zona está despejada. Realice el vertido de forma gradual para reducir el riesgo de atascos en la machacadora, especialmente cuando el material contiene bloques grandes. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Antes de descargar en la tolva, espere la señal de autorización y compruebe que la zona está despejada. Realice el vertido de forma gradual para reducir el riesgo de atascos en la machacadora, especialmente cuando el material contiene bloques grandes. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 6, 'Cada modelo puede presentar riesgos residuales propios por su diseño, antigüedad o equipamiento. El operador debe recibir formación específica, conocer el manual, mantener a las personas fuera de la zona de trabajo y extremar la atención en los ángulos muertos. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Cada modelo puede presentar riesgos residuales propios por su diseño, antigüedad o equipamiento', 'El operador debe recibir formación específica, conocer el manual, mantener a las personas fuera de la zona de trabajo y extremar la atención en los.', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '88–105', 'Cada modelo puede presentar riesgos residuales propios por su diseño, antigüedad o equipamiento. El operador debe recibir formación específica, conocer el manual, mantener a las personas fuera de la zona de trabajo y extremar la atención en los ángulos muertos. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Cada modelo puede presentar riesgos residuales propios por su diseño, antigüedad o equipamiento. El operador debe recibir formación específica, conocer el manual, mantener a las personas fuera de la zona de trabajo y extremar la atención en los ángulos muertos. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 7, 'Estacione en un terreno lo más llano posible, sitúe la transmisión en punto muerto y bloquéela, y conecte el freno de estacionamiento. En una parada prolongada, deje el motor a bajo régimen durante treinta a cuarenta y cinco segundos antes de pararlo sin acelerar. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Estacione en un terreno lo más llano posible, sitúe la transmisión en punto muerto y bloquéela, y conecte el freno de estacionamiento', 'En una parada prolongada, deje el motor a bajo régimen durante treinta a cuarenta y cinco segundos antes de pararlo sin acelerar', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '86–87', 'Estacione en un terreno lo más llano posible, sitúe la transmisión en punto muerto y bloquéela, y conecte el freno de estacionamiento. En una parada prolongada, deje el motor a bajo régimen durante treinta a cuarenta y cinco segundos antes de pararlo sin acelerar. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Estacione en un terreno lo más llano posible, sitúe la transmisión en punto muerto y bloquéela, y conecte el freno de estacionamiento. En una parada prolongada, deje el motor a bajo régimen durante treinta a cuarenta y cinco segundos antes de pararlo sin acelerar. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 8, 'Si no puede evitar estacionar en pendiente, coloque la unidad paralela a la línea de máxima pendiente. Accione el bloqueo de la transmisión y el freno de estacionamiento, y utilice calzos cuando sea necesario o lo exija el procedimiento de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Si no puede evitar estacionar en pendiente, coloque la unidad paralela a la línea de máxima pendiente', 'Accione el bloqueo de la transmisión y el freno de estacionamiento, y utilice calzos cuando sea necesario o lo exija el procedimiento de la explotación', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Si no puede evitar estacionar en pendiente, coloque la unidad paralela a la línea de máxima pendiente.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '86–87', 'Si no puede evitar estacionar en pendiente, coloque la unidad paralela a la línea de máxima pendiente. Accione el bloqueo de la transmisión y el freno de estacionamiento, y utilice calzos cuando sea necesario o lo exija el procedimiento de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Si no puede evitar estacionar en pendiente, coloque la unidad paralela a la línea de máxima pendiente. Accione el bloqueo de la transmisión y el freno de estacionamiento, y utilice calzos cuando sea necesario o lo exija el procedimiento de la explotación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 9, 'Si una intervención exige mantener la caja elevada, instale siempre el bloqueo mecánico previsto, como bulones, cables o perfiles de retención. Nunca confíe únicamente en el circuito hidráulico para impedir una bajada imprevista. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Si una intervención exige mantener la caja elevada, instale siempre el bloqueo mecánico previsto, como bulones, cables o perfiles de retención', 'Nunca confíe únicamente en el circuito hidráulico para impedir una bajada imprevista', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Nunca confíe únicamente en el circuito hidráulico para impedir una bajada imprevista.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '204–206', 'Si una intervención exige mantener la caja elevada, instale siempre el bloqueo mecánico previsto, como bulones, cables o perfiles de retención. Nunca confíe únicamente en el circuito hidráulico para impedir una bajada imprevista. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Si una intervención exige mantener la caja elevada, instale siempre el bloqueo mecánico previsto, como bulones, cables o perfiles de retención. Nunca confíe únicamente en el circuito hidráulico para impedir una bajada imprevista. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 4, 10, 'Las estructuras ROPS protegen en caso de vuelco y las FOPS frente a la caída de objetos. Compruebe visualmente su estado y no realice soldaduras, taladros ni modificaciones sin la autorización expresa del fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Las estructuras ROPS protegen en caso de vuelco y las FOPS frente a la caída de objetos', 'Compruebe visualmente su estado y no realice soldaduras, taladros ni modificaciones sin la autorización expresa del fabricante', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '212–214', 'Las estructuras ROPS protegen en caso de vuelco y las FOPS frente a la caída de objetos. Compruebe visualmente su estado y no realice soldaduras, taladros ni modificaciones sin la autorización expresa del fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La descarga y el estacionamiento concentran riesgos de vuelco y atrapamiento. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Las estructuras ROPS protegen en caso de vuelco y las FOPS frente a la caída de objetos. Compruebe visualmente su estado y no realice soldaduras, taladros ni modificaciones sin la autorización expresa del fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Comprueba que la descarga y el estacionamiento se hacen en zona autorizada y estable. Evidencia: verificación de descarga y estacionamiento seguro');

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
