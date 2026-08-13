-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 9/20 a partir de sus fuentes.

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
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 1, 'La revisión diaria debe incluir estructura, implementos, ruedas o cadenas, sistemas hidráulicos y dispositivos de seguridad. Toda incidencia detectada debe anotarse y comunicarse antes de continuar el trabajo.', array['La revisión diaria debe incluir estructura, implementos, ruedas o cadenas, sistemas hidráulicos y dispositivos de seguridad.', 'Toda incidencia detectada debe anotarse y comunicarse antes de continuar el trabajo.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 61–62', 'La revisión diaria debe incluir estructura, implementos, ruedas o cadenas, sistemas hidráulicos y dispositivos de seguridad. Toda incidencia detectada debe anotarse y comunicarse antes de continuar el trabajo. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La revisión diaria debe incluir estructura, implementos, ruedas o cadenas, sistemas hidráulicos y dispositivos de seguridad. Toda incidencia detectada debe anotarse y comunicarse antes de continuar el trabajo. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 2, 'El estado de la rodadura condiciona la tracción, la frenada y la estabilidad general del equipo. Trabajar con desgaste, cortes o tensiones incorrectas incrementa el riesgo de avería y pérdida de control.', array['El estado de la rodadura condiciona la tracción, la frenada y la estabilidad general del equipo.', 'Trabajar con desgaste, cortes o tensiones incorrectas incrementa el riesgo de avería y pérdida de control.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 63–64', 'El estado de la rodadura condiciona la tracción, la frenada y la estabilidad general del equipo. Trabajar con desgaste, cortes o tensiones incorrectas incrementa el riesgo de avería y pérdida de control. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El estado de la rodadura condiciona la tracción, la frenada y la estabilidad general del equipo. Trabajar con desgaste, cortes o tensiones incorrectas incrementa el riesgo de avería y pérdida de control. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 3, 'Las fugas hidráulicas afectan al rendimiento del equipo y pueden originar incendios o fallos súbitos de maniobra. Además, el aceite sobre superficies de acceso aumenta el riesgo de resbalón.', array['Las fugas hidráulicas afectan al rendimiento del equipo y pueden originar incendios o fallos súbitos de maniobra.', 'Además, el aceite sobre superficies de acceso aumenta el riesgo de resbalón.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 65–66', 'Las fugas hidráulicas afectan al rendimiento del equipo y pueden originar incendios o fallos súbitos de maniobra. Además, el aceite sobre superficies de acceso aumenta el riesgo de resbalón. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Las fugas hidráulicas afectan al rendimiento del equipo y pueden originar incendios o fallos súbitos de maniobra. Además, el aceite sobre superficies de acceso aumenta el riesgo de resbalón. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 4, 'La eficacia de frenos y dirección debe mantenerse dentro de los parámetros fijados por el fabricante y el plan interno. Cualquier anomalía en estos sistemas exige inmovilizar la máquina hasta su corrección.', array['La eficacia de frenos y dirección debe mantenerse dentro de los parámetros fijados por el fabricante y el plan interno.', 'Cualquier anomalía en estos sistemas exige inmovilizar la máquina hasta su corrección.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 67–68', 'La eficacia de frenos y dirección debe mantenerse dentro de los parámetros fijados por el fabricante y el plan interno. Cualquier anomalía en estos sistemas exige inmovilizar la máquina hasta su corrección. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La eficacia de frenos y dirección debe mantenerse dentro de los parámetros fijados por el fabricante y el plan interno. Cualquier anomalía en estos sistemas exige inmovilizar la máquina hasta su corrección. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 5, 'No se debe intervenir jamás bajo una cuchara, caja o implemento elevado sin sujeción mecánica adecuada. La simple presión hidráulica no constituye una garantía suficiente para trabajar debajo.', array['No se debe intervenir jamás bajo una cuchara, caja o implemento elevado sin sujeción mecánica adecuada.', 'La simple presión hidráulica no constituye una garantía suficiente para trabajar debajo.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 69–70', 'No se debe intervenir jamás bajo una cuchara, caja o implemento elevado sin sujeción mecánica adecuada. La simple presión hidráulica no constituye una garantía suficiente para trabajar debajo. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'No se debe intervenir jamás bajo una cuchara, caja o implemento elevado sin sujeción mecánica adecuada. La simple presión hidráulica no constituye una garantía suficiente para trabajar debajo. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 6, 'Toda intervención de mantenimiento debe ir precedida por la consignación de la máquina y la verificación de energía cero. El bloqueo evita puestas en marcha inesperadas durante la reparación o la limpieza.', array['Toda intervención de mantenimiento debe ir precedida por la consignación de la máquina y la verificación de energía cero.', 'El bloqueo evita puestas en marcha inesperadas durante la reparación o la limpieza.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 71–72', 'Toda intervención de mantenimiento debe ir precedida por la consignación de la máquina y la verificación de energía cero. El bloqueo evita puestas en marcha inesperadas durante la reparación o la limpieza. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Toda intervención de mantenimiento debe ir precedida por la consignación de la máquina y la verificación de energía cero. El bloqueo evita puestas en marcha inesperadas durante la reparación o la limpieza. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 7, 'El vuelco puede desencadenarse por exceso de velocidad, sobrecarga, firme deficiente o maniobras inadecuadas en pendiente. Las estructuras ROPS y el uso del cinturón son fundamentales para la supervivencia del operador.', array['El vuelco puede desencadenarse por exceso de velocidad, sobrecarga, firme deficiente o maniobras inadecuadas en pendiente.', 'Las estructuras ROPS y el uso del cinturón son fundamentales para la supervivencia del operador.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 73–74', 'El vuelco puede desencadenarse por exceso de velocidad, sobrecarga, firme deficiente o maniobras inadecuadas en pendiente. Las estructuras ROPS y el uso del cinturón son fundamentales para la supervivencia del operador. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El vuelco puede desencadenarse por exceso de velocidad, sobrecarga, firme deficiente o maniobras inadecuadas en pendiente. Las estructuras ROPS y el uso del cinturón son fundamentales para la supervivencia del operador. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 8, 'La proximidad al frente exige valorar siempre la estabilidad del terreno y la presencia de bloques sueltos o voladizos. Trabajar ignorando estos indicios puede derivar en desprendimientos graves.', array['La proximidad al frente exige valorar siempre la estabilidad del terreno y la presencia de bloques sueltos o voladizos.', 'Trabajar ignorando estos indicios puede derivar en desprendimientos graves.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 75–76', 'La proximidad al frente exige valorar siempre la estabilidad del terreno y la presencia de bloques sueltos o voladizos. Trabajar ignorando estos indicios puede derivar en desprendimientos graves. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La proximidad al frente exige valorar siempre la estabilidad del terreno y la presencia de bloques sueltos o voladizos. Trabajar ignorando estos indicios puede derivar en desprendimientos graves. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 9, 'La exposición prolongada a ruido, vibraciones o polvo afecta a la salud y reduce la capacidad de atención del operador. La fatiga también incrementa la probabilidad de cometer errores en tareas repetitivas.', array['La exposición prolongada a ruido, vibraciones o polvo afecta a la salud y reduce la capacidad de atención del operador.', 'La fatiga también incrementa la probabilidad de cometer errores en tareas repetitivas.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 77–78', 'La exposición prolongada a ruido, vibraciones o polvo afecta a la salud y reduce la capacidad de atención del operador. La fatiga también incrementa la probabilidad de cometer errores en tareas repetitivas. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La exposición prolongada a ruido, vibraciones o polvo afecta a la salud y reduce la capacidad de atención del operador. La fatiga también incrementa la probabilidad de cometer errores en tareas repetitivas. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo'),
  ('operador-maquinaria-arranque-carga-viales', 20, 4, 10, 'La presencia de combustible, lubricantes y elementos calientes obliga a extremar el orden y la limpieza de la máquina. Un derrame no controlado o una fuga cerca del motor puede iniciar un incendio con rapidez.', array['La presencia de combustible, lubricantes y elementos calientes obliga a extremar el orden y la limpieza de la máquina.', 'Un derrame no controlado o una fuga cerca del motor puede iniciar un incendio con rapidez.', 'Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 79–80', 'La presencia de combustible, lubricantes y elementos calientes obliga a extremar el orden y la limpieza de la máquina. Un derrame no controlado o una fuga cerca del motor puede iniciar un incendio con rapidez. Aplicación práctica: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento.', 'Inspección, mantenimiento y consignación previenen averías y accidentes graves. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La presencia de combustible, lubricantes y elementos calientes obliga a extremar el orden y la limpieza de la máquina. Un derrame no controlado o una fuga cerca del motor puede iniciar un incendio con rapidez. Aplicación en explotación: Registra incidencias, inmoviliza el equipo si es necesario y aplica consignación antes de intervenir en mantenimiento. Evidencia: lista de inspección y mantenimiento preventivo');

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
