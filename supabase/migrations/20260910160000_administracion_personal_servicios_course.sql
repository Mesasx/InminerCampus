-- Alta del curso «Administración y personal de servicios distintos a los de
-- mantenimiento» (ITC 02.1.02 · ET 2004-1-10 · Grupo 5.5.d) con sus dos
-- modalidades: reciclaje de 5 h y formación inicial de 20 h.
--
-- La estructura reproduce la de los cursos ya publicados: una versión por
-- modalidad, un módulo por bloque de la ET, una lección por módulo y una unidad
-- de audio por diapositiva. Las cincuenta unidades son las mismas en las dos
-- modalidades; lo que cambia es la locución, la transcripción y el reparto
-- horario. El contenido (audios, diapositivas, transcripciones y explicaciones
-- del manual) lo cargan después
-- `scripts/extract-administracion-master-manual.py` e
-- `scripts/import-administracion-master-content.mjs`.
--
-- Los precios son los que ya aplica el catálogo a cada duración: 149 € netos
-- para las formaciones de 5 h y 259 € netos para las de 20 h, con el 21 % de
-- IVA. No intervienen identificadores de precio de Stripe: `api/checkout`
-- construye la línea de pedido a partir de `price_net` y `tax_rate`, así que
-- `course_versions` es la única fuente de verdad del importe.
begin;

do $$
declare
  v_course_id uuid;
  v_version_id uuid;
  v_module_id uuid;
  v_lesson_id uuid;
  v_duration integer;
  v_block integer;
  v_block_title text;
  v_unit record;
begin
  select id into v_course_id
  from public.courses
  where slug = 'administracion-personal-servicios-no-mantenimiento';

  if v_course_id is null then
    insert into public.courses (
      slug,
      title,
      short_description,
      description,
      specialty,
      status,
      access_mode,
      listed
    ) values (
      'administracion-personal-servicios-no-mantenimiento',
      'Administración y personal de servicios distintos a los de mantenimiento',
      'Formación Preventiva Oficial para el personal de administración y de servicios de centros mineros.',
      'Itinerario preventivo del Grupo 5.5.d: el centro minero como entorno de trabajo, técnicas preventivas y de protección, equipos de trabajo y EPI, control y vigilancia del lugar de trabajo, interferencias con otras actividades y normativa aplicable. Los contenidos deben adaptarse a las tareas, equipos y condiciones reales del puesto y del centro.',
      'ITC 02.1.02 · ET 2004-1-10',
      'published',
      'purchase',
      true
    )
    returning id into v_course_id;
  end if;

  create temporary table tmp_administracion_units (
    block_position integer,
    unit_position integer,
    title text,
    primary key (block_position, unit_position)
  ) on commit drop;

  insert into tmp_administracion_units values
    (1,1,'Introducción a la formación preventiva minera'),
    (1,2,'El Grupo 5.5.d y sus límites'),
    (1,3,'El centro minero como entorno de trabajo'),
    (1,4,'Organización preventiva y personas responsables'),
    (1,5,'Funciones administrativas y sus riesgos'),
    (1,6,'Servicios distintos del mantenimiento'),
    (1,7,'Zonas de trabajo y desplazamientos internos'),
    (1,8,'Cambio entre zona administrativa y operativa'),
    (1,9,'Responsabilidades preventivas básicas'),
    (2,1,'Peligro, riesgo, daño y prevención'),
    (2,2,'Inspección previa del entorno'),
    (2,3,'Control del acceso'),
    (2,4,'Peatones, vehículos y maquinaria móvil'),
    (2,5,'Caídas, golpes y caída de objetos'),
    (2,6,'Energías e instalaciones: reconocer sin intervenir'),
    (2,7,'Ruido y condiciones físicas del entorno'),
    (2,8,'Polvo y agentes químicos'),
    (2,9,'Emergencia, incendio y evacuación'),
    (2,10,'Primeros auxilios y conducta PAS'),
    (3,1,'Qué es un equipo de trabajo'),
    (3,2,'Competencia y autorización para utilizar equipos'),
    (3,3,'Comprobación previa de equipos'),
    (3,4,'Manuales e instrucciones del fabricante'),
    (3,5,'Resguardos y dispositivos de seguridad'),
    (3,6,'Indicadores, manómetros y paneles'),
    (3,7,'Protección colectiva y EPI'),
    (3,8,'EPI habituales y selección por riesgo'),
    (3,9,'Revisión, cuidado y retirada de EPI'),
    (4,1,'Vigilancia continua del entorno'),
    (4,2,'Alarmas'),
    (4,3,'Cambios de condiciones'),
    (4,4,'Qué es una anomalía'),
    (4,5,'Comunicación eficaz de incidencias'),
    (4,6,'Detenerse ante una condición insegura'),
    (5,1,'Concepto de interferencia'),
    (5,2,'Concurrencia de empresas'),
    (5,3,'Información antes de comenzar'),
    (5,4,'Comunicación segura'),
    (5,5,'Proximidad a maquinaria'),
    (5,6,'Interacción peatón-vehículo'),
    (5,7,'Zonas en reparación o mantenimiento'),
    (5,8,'Zonas temporalmente restringidas'),
    (5,9,'Trabajos no previstos y cambios de alcance'),
    (6,1,'Derechos y obligaciones preventivas'),
    (6,2,'Arquitectura normativa básica'),
    (6,3,'Ley 31/1995 de Prevención de Riesgos Laborales'),
    (6,4,'Derechos de los trabajadores'),
    (6,5,'Obligaciones de los trabajadores'),
    (6,6,'Reglamento General de Normas Básicas de Seguridad Minera'),
    (6,7,'Las 10 conductas preventivas esenciales');

  foreach v_duration in array array[5, 20]
  loop
    select id into v_version_id
    from public.course_versions
    where course_id = v_course_id and duration_hours = v_duration;

    if v_version_id is null then
      insert into public.course_versions (
        course_id,
        version_number,
        duration_hours,
        modality,
        objectives,
        target_audience,
        requirements,
        syllabus_summary,
        accreditation_label,
        accreditation_reference,
        practice_required,
        status,
        published_at,
        renewal_interval_months,
        price_net,
        tax_rate,
        currency
      ) values (
        v_course_id,
        case when v_duration = 5 then 1 else 2 end,
        v_duration,
        'hybrid',
        case when v_duration = 20 then
          '["Situar el puesto administrativo o de servicios dentro del centro minero", "Reconocer los riesgos del entorno y los límites de actuación del Grupo 5.5.d", "Aplicar las reglas de acceso, comunicación y emergencia del centro"]'::jsonb
        else
          '["Actualizar el criterio preventivo del puesto", "Repasar los riesgos del entorno minero y los límites de actuación", "Revisar la comunicación de anomalías, las interferencias y las emergencias"]'::jsonb
        end,
        case when v_duration = 20 then
          '["Personal de administración y de servicios distintos a los de mantenimiento", "Personal de nueva incorporación en centros adscritos a actividades mineras"]'::jsonb
        else
          '["Personal del Grupo 5.5.d con formación inicial previa", "Empresas y contratas con personal administrativo o de servicios en centro minero"]'::jsonb
        end,
        case when v_duration = 20 then
          '["Completar las 20 horas mínimas de la ET 2004-1-10", "Superar la evaluación de conocimientos", "Aportar los datos necesarios para el registro formativo"]'::jsonb
        else
          '["Acreditar formación inicial o situación formativa previa", "Completar las 5 horas mínimas de reciclaje o actualización"]'::jsonb
        end,
        '1. Definición de los trabajos (' || case when v_duration = 20 then '1 h' else '15 min' end || ')
2. Técnicas preventivas y de protección (' || case when v_duration = 20 then '7 h' else '1 h 45 min' end || ')
3. Equipos de trabajo, EPI y medios auxiliares (' || case when v_duration = 20 then '7 h' else '1 h 45 min' end || ')
4. Control y vigilancia sobre el lugar de trabajo y su entorno (' || case when v_duration = 20 then '2 h' else '30 min' end || ')
5. Interferencias con otras actividades (' || case when v_duration = 20 then '2 h' else '30 min' end || ')
6. Normativa y legislación (' || case when v_duration = 20 then '1 h' else '15 min' end || ')',
        case when v_duration = 20 then 'Formación Preventiva Oficial inicial' else 'Formación Preventiva Oficial de actualización y reciclaje' end,
        'ITC 02.1.02 · ET 2004-1-10',
        false,
        'published',
        now(),
        48,
        case when v_duration = 20 then 259.00 else 149.00 end,
        21,
        'EUR'
      ) returning id into v_version_id;
    end if;

    for v_block in 1..6
    loop
      v_block_title := case v_block
        when 1 then 'Definición de los trabajos'
        when 2 then 'Técnicas preventivas y de protección'
        when 3 then 'Equipos de trabajo, EPI y medios auxiliares'
        when 4 then 'Control y vigilancia sobre el lugar de trabajo y su entorno'
        when 5 then 'Interferencias con otras actividades'
        when 6 then 'Normativa y legislación'
      end;

      select id into v_module_id
      from public.course_modules
      where course_version_id = v_version_id and position = v_block;

      if v_module_id is null then
        insert into public.course_modules (course_version_id, position, title)
        values (v_version_id, v_block, v_block_title)
        returning id into v_module_id;
      end if;

      select id into v_lesson_id
      from public.lessons
      where module_id = v_module_id and position = 1;

      if v_lesson_id is null then
        insert into public.lessons (
          module_id, position, title, summary, kind, duration_minutes,
          sequential_required, active, content_mode
        ) values (
          v_module_id,
          1,
          'Bloque ' || v_block::text || ' · ' || v_block_title,
          (
            select 'Unidades ' || min(unit_position)::text || ' a '
              || max(unit_position)::text || ' del bloque ' || v_block::text || '.'
            from tmp_administracion_units where block_position = v_block
          ),
          'mixed',
          case v_block
            when 1 then case when v_duration = 20 then 60 else 15 end
            when 2 then case when v_duration = 20 then 420 else 105 end
            when 3 then case when v_duration = 20 then 420 else 105 end
            when 4 then case when v_duration = 20 then 120 else 30 end
            when 5 then case when v_duration = 20 then 120 else 30 end
            when 6 then case when v_duration = 20 then 60 else 15 end
          end,
          true, true, 'audio'
        ) returning id into v_lesson_id;
      end if;

      for v_unit in
        select * from tmp_administracion_units
        where block_position = v_block
        order by unit_position
      loop
        insert into public.lesson_audio_segments (
          lesson_id, position, lesson_code, manual_chapter, title,
          narration_text, duration_seconds, published
        )
        select
          v_lesson_id,
          v_unit.unit_position,
          v_unit.block_position::text || '.' || v_unit.unit_position::text,
          'Unidad ' || v_unit.block_position::text || '.' || v_unit.unit_position::text,
          v_unit.title,
          '',
          case when v_duration = 20 then 45 else 17 end,
          false
        where not exists (
          select 1 from public.lesson_audio_segments existing
          where existing.lesson_id = v_lesson_id
            and existing.lesson_code = v_unit.block_position::text || '.' || v_unit.unit_position::text
        );
      end loop;
    end loop;
  end loop;
end
$$;

commit;
