-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote 7/20 a partir de sus fuentes.

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
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 1, 'La inspección previa permite comprobar niveles, neumáticos o cadenas, elementos de acceso, protecciones y posibles fugas. Ninguna máquina debe ponerse en marcha si presenta una anomalía que comprometa la seguridad.', array['La inspección previa permite comprobar niveles, neumáticos o cadenas, elementos de acceso, protecciones y posibles fugas.', 'Ninguna máquina debe ponerse en marcha si presenta una anomalía que comprometa la seguridad.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 21–22', 'La inspección previa permite comprobar niveles, neumáticos o cadenas, elementos de acceso, protecciones y posibles fugas. Ninguna máquina debe ponerse en marcha si presenta una anomalía que comprometa la seguridad. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La inspección previa permite comprobar niveles, neumáticos o cadenas, elementos de acceso, protecciones y posibles fugas. Ninguna máquina debe ponerse en marcha si presenta una anomalía que comprometa la seguridad. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 2, 'El acceso a cabina debe hacerse manteniendo tres puntos de apoyo y sin saltar desde escalones o plataformas. Las superficies sucias, embarradas o aceitosas aumentan notablemente el riesgo de caída.', array['El acceso a cabina debe hacerse manteniendo tres puntos de apoyo y sin saltar desde escalones o plataformas.', 'Las superficies sucias, embarradas o aceitosas aumentan notablemente el riesgo de caída.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 23–24', 'El acceso a cabina debe hacerse manteniendo tres puntos de apoyo y sin saltar desde escalones o plataformas. Las superficies sucias, embarradas o aceitosas aumentan notablemente el riesgo de caída. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El acceso a cabina debe hacerse manteniendo tres puntos de apoyo y sin saltar desde escalones o plataformas. Las superficies sucias, embarradas o aceitosas aumentan notablemente el riesgo de caída. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 3, 'La posición del asiento, los retrovisores, las cámaras y los mandos influyen en el control seguro del equipo durante todo el turno. Una ergonomía incorrecta genera fatiga, errores y pérdida de visibilidad operativa.', array['La posición del asiento, los retrovisores, las cámaras y los mandos influyen en el control seguro del equipo durante todo el turno.', 'Una ergonomía incorrecta genera fatiga, errores y pérdida de visibilidad operativa.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 25–26', 'La posición del asiento, los retrovisores, las cámaras y los mandos influyen en el control seguro del equipo durante todo el turno. Una ergonomía incorrecta genera fatiga, errores y pérdida de visibilidad operativa. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La posición del asiento, los retrovisores, las cámaras y los mandos influyen en el control seguro del equipo durante todo el turno. Una ergonomía incorrecta genera fatiga, errores y pérdida de visibilidad operativa. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 4, 'Antes de iniciar el trabajo se debe verificar el funcionamiento de dirección, frenos, claxon, iluminación y alarmas de marcha atrás. Estos sistemas son básicos para maniobrar con seguridad dentro de la explotación.', array['Antes de iniciar el trabajo se debe verificar el funcionamiento de dirección, frenos, claxon, iluminación y alarmas de marcha atrás.', 'Estos sistemas son básicos para maniobrar con seguridad dentro de la explotación.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 27–28', 'Antes de iniciar el trabajo se debe verificar el funcionamiento de dirección, frenos, claxon, iluminación y alarmas de marcha atrás. Estos sistemas son básicos para maniobrar con seguridad dentro de la explotación. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Antes de iniciar el trabajo se debe verificar el funcionamiento de dirección, frenos, claxon, iluminación y alarmas de marcha atrás. Estos sistemas son básicos para maniobrar con seguridad dentro de la explotación. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 5, 'La excavadora debe colocarse sobre terreno competente, estable y con un radio de giro libre de interferencias. Una posición deficiente reduce el control del cazo y puede provocar inestabilidad o golpes a terceros.', array['La excavadora debe colocarse sobre terreno competente, estable y con un radio de giro libre de interferencias.', 'Una posición deficiente reduce el control del cazo y puede provocar inestabilidad o golpes a terceros.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 29–30', 'La excavadora debe colocarse sobre terreno competente, estable y con un radio de giro libre de interferencias. Una posición deficiente reduce el control del cazo y puede provocar inestabilidad o golpes a terceros. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La excavadora debe colocarse sobre terreno competente, estable y con un radio de giro libre de interferencias. Una posición deficiente reduce el control del cazo y puede provocar inestabilidad o golpes a terceros. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 6, 'El arranque del material debe hacerse con trayectorias suaves, evitando golpes secos y solicitaciones innecesarias del equipo. Un buen llenado del cazo mejora el rendimiento y disminuye el desgaste de la máquina.', array['El arranque del material debe hacerse con trayectorias suaves, evitando golpes secos y solicitaciones innecesarias del equipo.', 'Un buen llenado del cazo mejora el rendimiento y disminuye el desgaste de la máquina.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 31–32', 'El arranque del material debe hacerse con trayectorias suaves, evitando golpes secos y solicitaciones innecesarias del equipo. Un buen llenado del cazo mejora el rendimiento y disminuye el desgaste de la máquina. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'El arranque del material debe hacerse con trayectorias suaves, evitando golpes secos y solicitaciones innecesarias del equipo. Un buen llenado del cazo mejora el rendimiento y disminuye el desgaste de la máquina. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 7, 'La carga debe repartirse de forma homogénea para no comprometer la estabilidad ni castigar de forma desigual la caja o la suspensión. El vehículo receptor se situará siempre en la posición fijada por el procedimiento de trabajo.', array['La carga debe repartirse de forma homogénea para no comprometer la estabilidad ni castigar de forma desigual la caja o la suspensión.', 'El vehículo receptor se situará siempre en la posición fijada por el procedimiento de trabajo.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 33–34', 'La carga debe repartirse de forma homogénea para no comprometer la estabilidad ni castigar de forma desigual la caja o la suspensión. El vehículo receptor se situará siempre en la posición fijada por el procedimiento de trabajo. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La carga debe repartirse de forma homogénea para no comprometer la estabilidad ni castigar de forma desigual la caja o la suspensión. El vehículo receptor se situará siempre en la posición fijada por el procedimiento de trabajo. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 8, 'La pala requiere controlar el ángulo de ataque, la tracción y la elevación de la cuchara sin perder estabilidad. Circular con la carga demasiado alta reduce visibilidad y aumenta el riesgo de vuelco.', array['La pala requiere controlar el ángulo de ataque, la tracción y la elevación de la cuchara sin perder estabilidad.', 'Circular con la carga demasiado alta reduce visibilidad y aumenta el riesgo de vuelco.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 35–36', 'La pala requiere controlar el ángulo de ataque, la tracción y la elevación de la cuchara sin perder estabilidad. Circular con la carga demasiado alta reduce visibilidad y aumenta el riesgo de vuelco. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'La pala requiere controlar el ángulo de ataque, la tracción y la elevación de la cuchara sin perder estabilidad. Circular con la carga demasiado alta reduce visibilidad y aumenta el riesgo de vuelco. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 9, 'En acopios o tolvas se debe respetar la distancia al borde, la capacidad del punto de descarga y la estabilidad del material. La aproximación final debe hacerse despacio y con atención total al entorno inmediato.', array['En acopios o tolvas se debe respetar la distancia al borde, la capacidad del punto de descarga y la estabilidad del material.', 'La aproximación final debe hacerse despacio y con atención total al entorno inmediato.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 37–38', 'En acopios o tolvas se debe respetar la distancia al borde, la capacidad del punto de descarga y la estabilidad del material. La aproximación final debe hacerse despacio y con atención total al entorno inmediato. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'En acopios o tolvas se debe respetar la distancia al borde, la capacidad del punto de descarga y la estabilidad del material. La aproximación final debe hacerse despacio y con atención total al entorno inmediato. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga'),
  ('operador-maquinaria-arranque-carga-viales', 20, 2, 10, 'Al finalizar la maniobra o el turno, la máquina debe quedar inmovilizada, con implementos apoyados y sistemas neutralizados. Un estacionamiento incorrecto puede generar desplazamientos no deseados y arranques inseguros.', array['Al finalizar la maniobra o el turno, la máquina debe quedar inmovilizada, con implementos apoyados y sistemas neutralizados.', 'Un estacionamiento incorrecto puede generar desplazamientos no deseados y arranques inseguros.', 'Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.']::text[], 'observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4', 'Diapositivas 39–40', 'Al finalizar la maniobra o el turno, la máquina debe quedar inmovilizada, con implementos apoyados y sistemas neutralizados. Un estacionamiento incorrecto puede generar desplazamientos no deseados y arranques inseguros. Aplicación práctica: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra.', 'La buena técnica de arranque y carga combina precisión, visibilidad y control de la máquina. Punto de control: observar el entorno, respetar el procedimiento y detenerse ante una condición no segura.', 'Al finalizar la maniobra o el turno, la máquina debe quedar inmovilizada, con implementos apoyados y sistemas neutralizados. Un estacionamiento incorrecto puede generar desplazamientos no deseados y arranques inseguros. Aplicación en explotación: Aplica la técnica correcta de revisión, conducción y carga para trabajar con seguridad y rendimiento en cada maniobra. Evidencia: verificación de técnica operativa en arranque y carga');

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
