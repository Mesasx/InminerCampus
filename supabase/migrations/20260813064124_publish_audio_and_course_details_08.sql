-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 8/20 a partir de sus fuentes.

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
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 1, 'Los viales deben permitir una circulación continua, previsible y segura de todos los equipos de la explotación. Su diseño y conservación influyen directamente en el riesgo de colisión, derrape y vuelco.', array['Los viales deben permitir una circulación continua, previsible y segura de todos los equipos de la explotación.', 'Su diseño y conservación influyen directamente en el riesgo de colisión, derrape y vuelco.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 41–42', 'Los viales deben permitir una circulación continua, previsible y segura de todos los equipos de la explotación. Su diseño y conservación influyen directamente en el riesgo de colisión, derrape y vuelco. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Los viales deben permitir una circulación continua, previsible y segura de todos los equipos de la explotación. Su diseño y conservación influyen directamente en el riesgo de colisión, derrape y vuelco. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 2, 'La anchura del vial y el estado del firme deben ser compatibles con el tamaño y la carga de la maquinaria que circula por él. Las pendientes excesivas y los blandones exigen medidas correctoras inmediatas.', array['La anchura del vial y el estado del firme deben ser compatibles con el tamaño y la carga de la maquinaria que circula por él.', 'Las pendientes excesivas y los blandones exigen medidas correctoras inmediatas.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 43–44', 'La anchura del vial y el estado del firme deben ser compatibles con el tamaño y la carga de la maquinaria que circula por él. Las pendientes excesivas y los blandones exigen medidas correctoras inmediatas. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La anchura del vial y el estado del firme deben ser compatibles con el tamaño y la carga de la maquinaria que circula por él. Las pendientes excesivas y los blandones exigen medidas correctoras inmediatas. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 3, 'La señalización fija prioridades, sentidos de circulación, zonas de precaución y límites de velocidad dentro de la cantera. El cumplimiento de estas indicaciones evita maniobras dudosas y mejora la convivencia entre equipos.', array['La señalización fija prioridades, sentidos de circulación, zonas de precaución y límites de velocidad dentro de la cantera.', 'El cumplimiento de estas indicaciones evita maniobras dudosas y mejora la convivencia entre equipos.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 45–46', 'La señalización fija prioridades, sentidos de circulación, zonas de precaución y límites de velocidad dentro de la cantera. El cumplimiento de estas indicaciones evita maniobras dudosas y mejora la convivencia entre equipos. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La señalización fija prioridades, sentidos de circulación, zonas de precaución y límites de velocidad dentro de la cantera. El cumplimiento de estas indicaciones evita maniobras dudosas y mejora la convivencia entre equipos. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 4, 'Las curvas cerradas y los cambios de rasante reducen la visibilidad y obligan a extremar la anticipación. En cruces o incorporaciones debe comprobarse siempre que la trayectoria está libre.', array['Las curvas cerradas y los cambios de rasante reducen la visibilidad y obligan a extremar la anticipación.', 'En cruces o incorporaciones debe comprobarse siempre que la trayectoria está libre.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 47–48', 'Las curvas cerradas y los cambios de rasante reducen la visibilidad y obligan a extremar la anticipación. En cruces o incorporaciones debe comprobarse siempre que la trayectoria está libre. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Las curvas cerradas y los cambios de rasante reducen la visibilidad y obligan a extremar la anticipación. En cruces o incorporaciones debe comprobarse siempre que la trayectoria está libre. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 5, 'Mantener una distancia adecuada permite reaccionar ante frenadas, baches o pérdidas de material en la calzada. Seguir demasiado cerca a otro equipo anula el margen de maniobra disponible.', array['Mantener una distancia adecuada permite reaccionar ante frenadas, baches o pérdidas de material en la calzada.', 'Seguir demasiado cerca a otro equipo anula el margen de maniobra disponible.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 49–50', 'Mantener una distancia adecuada permite reaccionar ante frenadas, baches o pérdidas de material en la calzada. Seguir demasiado cerca a otro equipo anula el margen de maniobra disponible. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Mantener una distancia adecuada permite reaccionar ante frenadas, baches o pérdidas de material en la calzada. Seguir demasiado cerca a otro equipo anula el margen de maniobra disponible. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 6, 'En pistas mineras el cruce entre equipos pesados debe producirse solo en zonas adecuadas y con visibilidad suficiente. Los adelantamientos solo se admitirán cuando la norma interna y el entorno lo permitan con claridad.', array['En pistas mineras el cruce entre equipos pesados debe producirse solo en zonas adecuadas y con visibilidad suficiente.', 'Los adelantamientos solo se admitirán cuando la norma interna y el entorno lo permitan con claridad.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 51–52', 'En pistas mineras el cruce entre equipos pesados debe producirse solo en zonas adecuadas y con visibilidad suficiente. Los adelantamientos solo se admitirán cuando la norma interna y el entorno lo permitan con claridad. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'En pistas mineras el cruce entre equipos pesados debe producirse solo en zonas adecuadas y con visibilidad suficiente. Los adelantamientos solo se admitirán cuando la norma interna y el entorno lo permitan con claridad. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 7, 'Los equipos de conservación de viales actúan frecuentemente con circulación alrededor y precisan una protección especial del área de trabajo. El resto de operadores debe adaptar velocidad y trayectoria a su presencia.', array['Los equipos de conservación de viales actúan frecuentemente con circulación alrededor y precisan una protección especial del área de trabajo.', 'El resto de operadores debe adaptar velocidad y trayectoria a su presencia.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 53–54', 'Los equipos de conservación de viales actúan frecuentemente con circulación alrededor y precisan una protección especial del área de trabajo. El resto de operadores debe adaptar velocidad y trayectoria a su presencia. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Los equipos de conservación de viales actúan frecuentemente con circulación alrededor y precisan una protección especial del área de trabajo. El resto de operadores debe adaptar velocidad y trayectoria a su presencia. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 8, 'El riego reduce el polvo en suspensión, pero también puede modificar la adherencia del firme si se aplica en exceso. El operador debe adaptar la conducción cuando la visibilidad esté comprometida por polvo o barro.', array['El riego reduce el polvo en suspensión, pero también puede modificar la adherencia del firme si se aplica en exceso.', 'El operador debe adaptar la conducción cuando la visibilidad esté comprometida por polvo o barro.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 55–56', 'El riego reduce el polvo en suspensión, pero también puede modificar la adherencia del firme si se aplica en exceso. El operador debe adaptar la conducción cuando la visibilidad esté comprometida por polvo o barro. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El riego reduce el polvo en suspensión, pero también puede modificar la adherencia del firme si se aplica en exceso. El operador debe adaptar la conducción cuando la visibilidad esté comprometida por polvo o barro. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 9, 'Las maniobras hacia atrás se realizarán solo cuando sean necesarias y utilizando cámaras, espejos o ayuda externa si procede. Las zonas ciegas de la maquinaria pesada obligan a una vigilancia reforzada.', array['Las maniobras hacia atrás se realizarán solo cuando sean necesarias y utilizando cámaras, espejos o ayuda externa si procede.', 'Las zonas ciegas de la maquinaria pesada obligan a una vigilancia reforzada.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 57–58', 'Las maniobras hacia atrás se realizarán solo cuando sean necesarias y utilizando cámaras, espejos o ayuda externa si procede. Las zonas ciegas de la maquinaria pesada obligan a una vigilancia reforzada. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Las maniobras hacia atrás se realizarán solo cuando sean necesarias y utilizando cámaras, espejos o ayuda externa si procede. Las zonas ciegas de la maquinaria pesada obligan a una vigilancia reforzada. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero'),
  ('operador-maquinaria-arranque-carga-viales', 20, 3, 10, 'La descarga junto a un borde exige comprobar el estado del terreno, la existencia de topes y la correcta alineación del vehículo. Nunca debe confiarse la seguridad a un punto de apoyo dudoso o deteriorado.', array['La descarga junto a un borde exige comprobar el estado del terreno, la existencia de topes y la correcta alineación del vehículo.', 'Nunca debe confiarse la seguridad a un punto de apoyo dudoso o deteriorado.', 'Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 59–60', 'La descarga junto a un borde exige comprobar el estado del terreno, la existencia de topes y la correcta alineación del vehículo. Nunca debe confiarse la seguridad a un punto de apoyo dudoso o deteriorado. Aplicación práctica: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar.', 'Los viales seguros reducen tiempos muertos y evitan colisiones, derrapes y vuelcos. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La descarga junto a un borde exige comprobar el estado del terreno, la existencia de topes y la correcta alineación del vehículo. Nunca debe confiarse la seguridad a un punto de apoyo dudoso o deteriorado. Aplicación en explotación: Comprueba sobre el terreno el estado del vial, la señalización y las distancias de seguridad antes de circular o descargar. Evidencia: control de circulación y maniobras en vial minero');

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
