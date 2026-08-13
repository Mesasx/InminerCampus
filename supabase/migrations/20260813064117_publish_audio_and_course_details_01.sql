-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 1/20 a partir de sus fuentes.

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
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 1, 'En muchas explotaciones, el transporte es la fase de mayor coste por tonelada movida, incluso por encima del arranque. Por eso, ajustar las distancias, los tiempos de ciclo y el número de unidades resulta esencial para trabajar con seguridad y eficiencia. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['En muchas explotaciones, el transporte es la fase de mayor coste por tonelada movida, incluso por encima del arranque', 'Por eso, ajustar las distancias, los tiempos de ciclo y el número de unidades resulta esencial para trabajar con seguridad y eficiencia', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '7–16', 'En muchas explotaciones, el transporte es la fase de mayor coste por tonelada movida, incluso por encima del arranque. Por eso, ajustar las distancias, los tiempos de ciclo y el número de unidades resulta esencial para trabajar con seguridad y eficiencia. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'En muchas explotaciones, el transporte es la fase de mayor coste por tonelada movida, incluso por encima del arranque. Por eso, ajustar las distancias, los tiempos de ciclo y el número de unidades resulta esencial para trabajar con seguridad y eficiencia. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 2, 'La productividad depende de la coordinación entre las unidades de transporte y los equipos de carga, como palas y excavadoras. La capacidad del volquete, el tamaño del cucharón y el ritmo de ambos equipos deben ser compatibles para evitar esperas y maniobras innecesarias. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['La productividad depende de la coordinación entre las unidades de transporte y los equipos de carga, como palas y excavadoras', 'La capacidad del volquete, el tamaño del cucharón y el ritmo de ambos equipos deben ser compatibles para evitar esperas y maniobras innecesarias', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '7–24', 'La productividad depende de la coordinación entre las unidades de transporte y los equipos de carga, como palas y excavadoras. La capacidad del volquete, el tamaño del cucharón y el ritmo de ambos equipos deben ser compatibles para evitar esperas y maniobras innecesarias. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'La productividad depende de la coordinación entre las unidades de transporte y los equipos de carga, como palas y excavadoras. La capacidad del volquete, el tamaño del cucharón y el ritmo de ambos equipos deben ser compatibles para evitar esperas y maniobras innecesarias. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 3, 'La distancia de transporte, las pendientes y las diferencias de cota condicionan el tiempo de ciclo, el consumo y el rendimiento del equipo. El trazado y el estado de las pistas influyen directamente en la seguridad, el desgaste y el coste de la operación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['La distancia de transporte, las pendientes y las diferencias de cota condicionan el tiempo de ciclo, el consumo y el rendimiento del equipo', 'El trazado y el estado de las pistas influyen directamente en la seguridad, el desgaste y el coste de la operación', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '7–16', 'La distancia de transporte, las pendientes y las diferencias de cota condicionan el tiempo de ciclo, el consumo y el rendimiento del equipo. El trazado y el estado de las pistas influyen directamente en la seguridad, el desgaste y el coste de la operación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'La distancia de transporte, las pendientes y las diferencias de cota condicionan el tiempo de ciclo, el consumo y el rendimiento del equipo. El trazado y el estado de las pistas influyen directamente en la seguridad, el desgaste y el coste de la operación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 4, 'En plantas de áridos también se emplean camiones convencionales y conjuntos tipo bañera, formados por una cabeza tractora y un semirremolque basculante. Pueden trabajar dentro de la explotación y, cuando están autorizados y acondicionados, realizar transporte exterior por carretera. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['En plantas de áridos también se emplean camiones convencionales y conjuntos tipo bañera, formados por una cabeza tractora y un semirremolque basculante', 'Pueden trabajar dentro de la explotación y, cuando están autorizados y acondicionados, realizar transporte exterior por carretera', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '7–16', 'En plantas de áridos también se emplean camiones convencionales y conjuntos tipo bañera, formados por una cabeza tractora y un semirremolque basculante. Pueden trabajar dentro de la explotación y, cuando están autorizados y acondicionados, realizar transporte exterior por carretera. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'En plantas de áridos también se emplean camiones convencionales y conjuntos tipo bañera, formados por una cabeza tractora y un semirremolque basculante. Pueden trabajar dentro de la explotación y, cuando están autorizados y acondicionados, realizar transporte exterior por carretera. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 5, 'El volquete rígido está diseñado para transportar cargas pesadas en explotaciones mineras. La tracción actúa normalmente sobre el eje posterior, mientras el delantero es direccional. Según el modelo y las condiciones de uso, puede alcanzar velocidades próximas a setenta kilómetros por hora. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El volquete rígido está diseñado para transportar cargas pesadas en explotaciones mineras', 'La tracción actúa normalmente sobre el eje posterior, mientras el delantero es direccional', 'Según el modelo y las condiciones de uso, puede alcanzar velocidades próximas a setenta kilómetros por hora']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '9–23', 'El volquete rígido está diseñado para transportar cargas pesadas en explotaciones mineras. La tracción actúa normalmente sobre el eje posterior, mientras el delantero es direccional. Según el modelo y las condiciones de uso, puede alcanzar velocidades próximas a setenta kilómetros por hora. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El volquete rígido está diseñado para transportar cargas pesadas en explotaciones mineras. La tracción actúa normalmente sobre el eje posterior, mientras el delantero es direccional. Según el modelo y las condiciones de uso, puede alcanzar velocidades próximas a setenta kilómetros por hora. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 6, 'Los volquetes rígidos destacan por la robustez de sus componentes. El bastidor y la caja están construidos para soportar cargas elevadas y los impactos producidos durante la carga de rocas de tamaño considerable, siempre dentro de los límites indicados por el fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Los volquetes rígidos destacan por la robustez de sus componentes', 'El bastidor y la caja están construidos para soportar cargas elevadas y los impactos producidos durante la carga de rocas de tamaño considerable', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '9–23', 'Los volquetes rígidos destacan por la robustez de sus componentes. El bastidor y la caja están construidos para soportar cargas elevadas y los impactos producidos durante la carga de rocas de tamaño considerable, siempre dentro de los límites indicados por el fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Los volquetes rígidos destacan por la robustez de sus componentes. El bastidor y la caja están construidos para soportar cargas elevadas y los impactos producidos durante la carga de rocas de tamaño considerable, siempre dentro de los límites indicados por el fabricante. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 7, 'El volquete articulado cambia de dirección mediante la unión de sus dos bastidores, lo que reduce el radio de giro. Su caja es menos robusta que la de un rígido y, si transporta roca, esta debe estar bien volada y no superar aproximadamente cuarenta o cincuenta centímetros. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['El volquete articulado cambia de dirección mediante la unión de sus dos bastidores, lo que reduce el radio de giro', 'Su caja es menos robusta que la de un rígido y, si transporta roca, esta debe estar bien volada y no superar aproximadamente cuarenta o cincuenta.', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '9–16', 'El volquete articulado cambia de dirección mediante la unión de sus dos bastidores, lo que reduce el radio de giro. Su caja es menos robusta que la de un rígido y, si transporta roca, esta debe estar bien volada y no superar aproximadamente cuarenta o cincuenta centímetros. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'El volquete articulado cambia de dirección mediante la unión de sus dos bastidores, lo que reduce el radio de giro. Su caja es menos robusta que la de un rígido y, si transporta roca, esta debe estar bien volada y no superar aproximadamente cuarenta o cincuenta centímetros. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 8, 'Los volquetes articulados están pensados para pistas mal conservadas, superficies irregulares y terrenos embarrados con baja adherencia. La tracción en todos sus ejes mejora su capacidad de avance y su adaptación al terreno, pero no elimina los riesgos de deslizamiento o vuelco. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Los volquetes articulados están pensados para pistas mal conservadas, superficies irregulares y terrenos embarrados con baja adherencia', 'La tracción en todos sus ejes mejora su capacidad de avance y su adaptación al terreno, pero no elimina los riesgos de deslizamiento o vuelco', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '9–16', 'Los volquetes articulados están pensados para pistas mal conservadas, superficies irregulares y terrenos embarrados con baja adherencia. La tracción en todos sus ejes mejora su capacidad de avance y su adaptación al terreno, pero no elimina los riesgos de deslizamiento o vuelco. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Los volquetes articulados están pensados para pistas mal conservadas, superficies irregulares y terrenos embarrados con baja adherencia. La tracción en todos sus ejes mejora su capacidad de avance y su adaptación al terreno, pero no elimina los riesgos de deslizamiento o vuelco. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 9, 'Al disponer de todos los ejes motrices, el volquete articulado reparte la tracción entre sus ruedas. La oscilación permite el movimiento relativo de los bastidores: uno puede inclinarse o llegar a volcar mientras el otro permanece horizontal, por lo que debe vigilarse siempre la estabilidad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Al disponer de todos los ejes motrices, el volquete articulado reparte la tracción entre sus ruedas', 'La oscilación permite el movimiento relativo de los bastidores: uno puede inclinarse o llegar a volcar mientras el otro permanece horizontal', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '9–16', 'Al disponer de todos los ejes motrices, el volquete articulado reparte la tracción entre sus ruedas. La oscilación permite el movimiento relativo de los bastidores: uno puede inclinarse o llegar a volcar mientras el otro permanece horizontal, por lo que debe vigilarse siempre la estabilidad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Al disponer de todos los ejes motrices, el volquete articulado reparte la tracción entre sus ruedas. La oscilación permite el movimiento relativo de los bastidores: uno puede inclinarse o llegar a volcar mientras el otro permanece horizontal, por lo que debe vigilarse siempre la estabilidad. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte'),
  ('operador-maquinaria-transporte-camion-volquete', 5, 1, 10, 'Algunos modelos articulados de menos de veinticinco toneladas tienen menos de trece toneladas por eje y una anchura inferior a dos metros y medio. En principio pueden circular por carretera, aunque deben comprobarse su clasificación, autorización y condiciones concretas de circulación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', array['Algunos modelos articulados de menos de veinticinco toneladas tienen menos de trece toneladas por eje y una anchura inferior a dos metros y medio', 'En principio pueden circular por carretera, aunque deben comprobarse su clasificación, autorización y condiciones concretas de circulación', 'Aplicar el manual del fabricante y las disposiciones internas']::text[], 'Detenga la operación y comunique cualquier condición que impida trabajar con seguridad.', 'ET 2000-1-08 · Presentación Cursos Pedro · Manual oficial del operador de maquinaria de transporte', '9–26', 'Algunos modelos articulados de menos de veinticinco toneladas tienen menos de trece toneladas por eje y una anchura inferior a dos metros y medio. En principio pueden circular por carretera, aunque deben comprobarse su clasificación, autorización y condiciones concretas de circulación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado.', 'La eficiencia del transporte depende de coordinar vehículo, pista y carga. Punto de control: observar, comprobar, comunicar y detenerse ante condiciones no seguras.', 'Algunos modelos articulados de menos de veinticinco toneladas tienen menos de trece toneladas por eje y una anchura inferior a dos metros y medio. En principio pueden circular por carretera, aunque deben comprobarse su clasificación, autorización y condiciones concretas de circulación. En la aplicación práctica deben respetarse el manual del fabricante, las disposiciones internas de seguridad y el criterio de parada indicado. Aplicación en explotación: Relaciona el tipo de vehículo, la distancia y la pista con el rendimiento seguro del ciclo. Evidencia: mapa de ciclos, equipos y rutas de transporte');

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
