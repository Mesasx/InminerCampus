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
  where slug = 'operadores-establecimientos-beneficio';

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
      'operadores-establecimientos-beneficio',
      'Operadores en establecimientos de beneficio',
      'Formación preventiva para operadores de plantas e instalaciones de beneficio.',
      'Itinerario preventivo para los puestos del Grupo 5.4, conforme a la ET 2004-1-10 y la ITC 02.1.02.',
      'Establecimientos de beneficio',
      'draft',
      'purchase',
      false
    )
    returning id into v_course_id;
  end if;

  create temporary table tmp_establecimientos_units (
    block_position integer,
    unit_position integer,
    title text,
    primary key (block_position, unit_position)
  ) on commit drop;

  insert into tmp_establecimientos_units values
    (1,1,'Qué es un Establecimiento de Beneficio'),
    (1,2,'Puestos del Grupo 5.4 y Alcance de la ET 2004-1-10'),
    (1,3,'Flujo General del Proceso Mineral'),
    (1,4,'Recepción, Tolvas y Alimentación de Material'),
    (1,5,'Trituración y Clasificación'),
    (1,6,'Molienda'),
    (1,7,'Estrío y Selección de Materiales'),
    (1,8,'Separación y Concentración'),
    (1,9,'Hornos y Mezclas'),
    (1,10,'Plantas de Construcción, Roca Ornamental, Laboratorio y Mantenimiento'),
    (2,1,'Revisión del Lugar de Trabajo Antes de Comenzar'),
    (2,2,'Revisión de Equipos, Máquinas, Accesorios e Instrumental'),
    (2,3,'Operaciones Básicas de Mantenimiento'),
    (2,4,'Acceso al Puesto y a Puntos de Mantenimiento'),
    (2,5,'Comprobación de Instalaciones Eléctricas, Hidráulicas y Neumáticas'),
    (2,6,'Preparación, Puesta en Marcha y Alimentación'),
    (2,7,'Funcionamiento y Supervisión'),
    (2,8,'Descarga, Finalización y Parada de Equipos'),
    (2,9,'Atascos, Averías y Resolución de Problemas'),
    (2,10,'Primeros Auxilios, Emergencia y Procedimientos de Trabajo Seguro'),
    (3,1,'Conocimiento Técnico de Equipos, Accesorios e Instalaciones'),
    (3,2,'Trituradoras, Cribas y Molinos: Protecciones Críticas'),
    (3,3,'Cintas, Alimentadores, Tolvas y Transferencias'),
    (3,4,'Bombas, Tuberías, Tanques y Equipos de Separación'),
    (3,5,'Hornos y Equipos Térmicos'),
    (3,6,'Plantas de Materiales para la Construcción'),
    (3,7,'Plantas de Roca Ornamental'),
    (3,8,'Equipos e Instrumental de Laboratorio'),
    (3,9,'Mantenimiento Mecánico, Eléctrico, Hidráulico y Neumático'),
    (3,10,'Sistemas de Seguridad, Limitaciones y Riesgos Residuales'),
    (4,1,'Manómetros, Termómetros e Indicadores de Nivel'),
    (4,2,'Paneles de Alarmas Acústicas y Luminosas'),
    (4,3,'Control del Lugar de Trabajo según Procedimientos Internos'),
    (4,4,'Polvo, Ruido, Vibraciones y Condiciones Ambientales'),
    (4,5,'Orden, Limpieza y Condiciones de Paso'),
    (4,6,'Trabajos Simultáneos e Interferencias'),
    (4,7,'Procedimientos Seguros de Comunicación'),
    (4,8,'Trabajos en Proximidad de Maquinaria u Otro Personal'),
    (4,9,'Reparaciones, Revisiones y Mantenimiento con Producción'),
    (4,10,'Coordinación con Contratistas y Subcontratas'),
    (5,1,'Marco Normativo Aplicable'),
    (5,2,'Derechos y Obligaciones Preventivas'),
    (5,3,'Duración de 20 Horas y Presencialidad'),
    (5,4,'Equipo Formador y Adaptación Técnica'),
    (5,5,'Evaluación, Acreditación, Cartilla y Registro'),
    (5,6,'Reciclaje cada Cuatro Años: Puestos Afectados'),
    (5,7,'Reciclaje cada Dos Años: Puestos Afectados'),
    (5,8,'Trabajadores con Varios Puestos y Personal Subcontratado'),
    (5,9,'Caso Integrado: Intervención Segura ante un Atasco en Planta'),
    (5,10,'Cierre: Comportamiento Preventivo en Establecimientos de Beneficio');

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
        renewal_interval_months
      ) values (
        v_course_id,
        case when v_duration = 5 then 1 else 2 end,
        v_duration,
        'in_person',
        '["Reconocer los riesgos de los procesos y equipos", "Aplicar consignación, control y coordinación preventiva"]'::jsonb,
        '["Operadores incluidos en el Grupo 5.4 y personal de apoyo expuesto"]'::jsonb,
        '["Formación adaptada al puesto, la planta y los procedimientos del centro"]'::jsonb,
        'Cinco bloques y 50 unidades conforme al manual maestro de Inmíner Campus.',
        case when v_duration = 20 then 'Formación inicial de 20 horas' else 'Reciclaje mínimo de 5 horas' end,
        'ITC 02.1.02 · ET 2004-1-10',
        true,
        'draft',
        null
      ) returning id into v_version_id;
    end if;

    for v_block in 1..5
    loop
      v_block_title := case v_block
        when 1 then 'Procesos, puestos y riesgos en establecimientos de beneficio'
        when 2 then 'Técnicas preventivas y operaciones seguras'
        when 3 then 'Equipos, accesorios e instalaciones'
        when 4 then 'Control, vigilancia e interferencias en el lugar de trabajo'
        else 'Normativa, formación, reciclaje y aplicación práctica'
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
          v_module_id, 1, v_block_title,
          'Diez unidades del bloque ' || v_block::text || '.',
          'mixed', case when v_duration = 20 then 240 else 60 end,
          true, true, 'audio'
        ) returning id into v_lesson_id;
      end if;

      for v_unit in
        select * from tmp_establecimientos_units
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
          'Capítulo ' || v_unit.block_position::text || '.' || v_unit.unit_position::text,
          v_unit.title,
          '',
          case when v_duration = 20 then 55 else 15 end,
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
