-- Bloques formativos publicados: transcripción, contenido específico y evaluación por bloque.
-- Fuentes contrastadas en "Cursos Pedro" (Google Drive):
--   * Arranque, carga y viales: ITC 02.1.02 · ET 2001-1-08.
--   * Transporte, camión y volquete: ITC 02.1.02 · ET 2000-1-08.
--   * Polvo y sílice: ITC 02.0.02 · Orden TED/723/2021.

create temporary table _target_versions on commit drop as
select
  cv.id as course_version_id,
  c.slug,
  c.title as course_title,
  cv.duration_hours
from public.course_versions cv
join public.courses c on c.id = cv.course_id
where cv.status = 'published'
  and (
    (c.slug = 'operador-maquinaria-arranque-carga-viales'
      and cv.duration_hours in (5, 20))
    or
    (c.slug = 'operador-maquinaria-transporte-camion-volquete'
      and cv.duration_hours in (5, 20))
    or
    (c.slug = 'prevencion-polvo-silice-cristalina-respirable'
      and cv.duration_hours = 5)
  );

do $$
begin
  if (select count(*) from _target_versions) <> 5 then
    raise exception 'Expected five published course versions, found %',
      (select count(*) from _target_versions);
  end if;
end;
$$;

create temporary table _target_lessons on commit drop as
select
  tv.course_version_id,
  tv.slug,
  tv.course_title,
  tv.duration_hours,
  cm.position as block_position,
  l.id as lesson_id,
  l.title as lesson_title
from _target_versions tv
join public.course_modules cm
  on cm.course_version_id = tv.course_version_id
join public.lessons l
  on l.module_id = cm.id
  and l.active = true
where (
  select count(*)
  from public.lesson_audio_segments s
  where s.lesson_id = l.id
    and s.published = true
    and coalesce(s.audio_storage_path, s.audio_external_url) is not null
) = 10;

do $$
begin
  if (select count(*) from _target_lessons) <> 25 then
    raise exception 'Expected 25 playable blocks, found %',
      (select count(*) from _target_lessons);
  end if;
end;
$$;

-- Transcripciones verificadas contra los 25 audios que carecían de guion.
create temporary table _silica_transcripts (
  block_position integer not null,
  part_position integer not null,
  transcript text not null,
  primary key (block_position, part_position)
) on commit drop;

insert into _silica_transcripts (block_position, part_position, transcript)
values
  (1, 6, 'Las partículas gruesas tienden a sedimentar antes, mientras que las finas permanecen más tiempo suspendidas y pueden desplazarse con el aire. Que una nube no sea visible no significa que el ambiente esté libre de partículas respirables.'),
  (1, 7, 'La exposición al polvo puede causar irritación, estornudos o molestias respiratorias. La exposición prolongada a sílice cristalina respirable puede provocar silicosis, pérdida de función pulmonar y aumentar el riesgo de tuberculosis, enfermedad renal y cáncer de pulmón.'),
  (1, 8, 'La silicosis es una enfermedad pulmonar grave e irreversible causada por la inhalación de sílice cristalina respirable. Puede evolucionar incluso después de cesar la exposición. La prevención debe actuar antes de que aparezcan síntomas o alteraciones radiológicas.'),
  (1, 9, 'Según la intensidad y duración de la exposición, la silicosis puede presentarse de forma crónica, acelerada o aguda. Las exposiciones más intensas pueden acortar mucho el tiempo de aparición, por lo que ninguna sobreexposición debe considerarse aceptable.'),
  (1, 10, 'Influyen la naturaleza y humedad de la roca, el proceso productivo, la maquinaria, el estado de las pistas, la climatología, el viento y la posibilidad de aplicar agua. Estos factores deben valorarse para elegir medidas preventivas eficaces.'),
  (2, 6, 'La exposición se mide con equipos personales portados por el trabajador. El muestreador se coloca en su zona de respiración y la estrategia debe ser representativa de la actividad real. La toma la realiza personal competente y no el propio trabajador.'),
  (2, 7, 'La toma de muestras debe extenderse a toda la jornada de trabajo. Solo puede reducirse excepcionalmente por exigencias analíticas, dejando constancia de la incidencia y garantizando que la muestra siga siendo suficiente y representativa de la exposición diaria.'),
  (2, 8, 'En los puestos con riesgo de exposición a polvo se tomarán muestras, como mínimo, una vez cada cuatrimestre del año natural. Los análisis los realiza el Instituto Nacional de Silicosis o un laboratorio reconocido por la autoridad minera.'),
  (2, 9, 'La evaluación se revisa cuando cambian las condiciones, aparecen daños para la salud o las medidas resultan insuficientes. En minería, la ITC exige además revisarla en todo caso cada tres años, sin esperar a que ocurra un incidente.'),
  (2, 10, 'Cada trabajador debe conocer los riesgos de su puesto, los resultados que le afecten y las medidas implantadas. Los valores de exposición se registran periódicamente en fichas individualizadas para conocer el riesgo acumulado y se incorporan al expediente médico.'),
  (3, 6, 'La aspiración localizada captura el polvo cerca del punto de generación antes de que alcance la zona de respiración. Campanas, conductos, filtros y separadores deben dimensionarse, revisarse y mantenerse para conservar el caudal y la eficacia previstos.'),
  (3, 7, 'El riego o estabilización de pistas, la limitación de velocidad, la limpieza de ruedas y el cubrimiento de cargas reducen las emisiones del transporte. Los acopios pueden protegerse del viento y gestionarse para evitar caídas y manipulaciones innecesarias.'),
  (3, 8, 'La limpieza debe realizarse por aspiración industrial o por vía húmeda. Barrer en seco o utilizar aire comprimido vuelve a poner el polvo en suspensión y aumenta la exposición, por lo que estas prácticas deben evitarse salvo procedimiento específicamente controlado.'),
  (3, 9, 'Una medida preventiva solo protege si funciona. Deben revisarse boquillas, captaciones, filtros, cerramientos, cabinas y sistemas de riego. Cualquier fallo se comunica y corrige antes de continuar si compromete el control de la exposición.'),
  (3, 10, 'En averías, reparaciones, inspecciones y limpiezas extraordinarias puede aumentar la exposición. Se limitará el acceso a personal autorizado, se reducirá el tiempo imprescindible y se usarán medidas técnicas y protección respiratoria adecuadas al riesgo.'),
  (4, 6, 'La empresa debe proporcionar ropa de protección cuando proceda y organizar su limpieza o descontaminación. La ropa contaminada no debe llevarse a casa, se guardará separada de la ropa de calle y se manipulará evitando liberar polvo.'),
  (4, 7, 'La empresa garantizará una vigilancia adecuada y específica realizada por personal sanitario competente. Su contenido y periodicidad se fijan conforme a los protocolos sanitarios y al riesgo, no mediante una regla única basada solo en el porcentaje de sílice de la roca.'),
  (4, 8, 'Los resultados de exposición de cada trabajador se registran para conocer el riesgo acumulado y se incorporan a su expediente médico. Esta trazabilidad permite relacionar los puestos, tareas, tiempos y mediciones con la vigilancia de la salud.'),
  (4, 9, 'El trabajador debe avisar si una perforadora emite polvo, falla una boquilla, una cabina no presuriza, la ventilación se detiene o se limpia en seco. Comunicarlo pronto permite corregir la causa antes de que afecte a más personas.'),
  (4, 10, 'La aparición de tos persistente, dificultad respiratoria u otros síntomas debe comunicarse al servicio sanitario, sin esperar al reconocimiento programado. Los síntomas no sirven para medir la exposición, pero requieren valoración y pueden motivar la revisión de las medidas preventivas.'),
  (5, 6, 'Cada trabajador debe recibir formación suficiente y adecuada para su puesto, tanto teórica como práctica. No basta con entregar documentación: hay que comprender los riesgos, aplicar las medidas de control y demostrar el uso correcto de la protección respiratoria.'),
  (5, 7, 'La formación frente al polvo y la sílice debe repetirse como mínimo una vez al año. También se actualizará cuando cambien las funciones, el puesto, el lugar de trabajo, la tecnología, los equipos o los conocimientos sobre el riesgo.'),
  (5, 8, 'Los trabajadores y sus representantes deben recibir información y participar conforme a la normativa preventiva. Su experiencia ayuda a detectar focos, fallos de mantenimiento y situaciones reales que pueden no aparecer durante una visita puntual.'),
  (5, 9, 'Antes de trabajar, comprueba que funcionan el riego, la aspiración, la ventilación o la presurización de la cabina. Verifica el estado del equipo respiratorio, conoce las zonas restringidas y comunica cualquier anomalía antes de exponerte.'),
  (5, 10, 'La silicosis es prevenible si se controla el polvo desde el origen, se mantienen las medidas colectivas y cada persona aplica los procedimientos. Trabajar sin nube visible no garantiza seguridad: la evaluación, la medición y la disciplina preventiva deben acompañar cada tarea.');

update public.lesson_audio_segments s
set
  narration_text = st.transcript,
  updated_at = now()
from _silica_transcripts st
join _target_lessons tl
  on tl.slug = 'prevencion-polvo-silice-cristalina-respirable'
  and tl.duration_hours = 5
  and tl.block_position = st.block_position
where s.lesson_id = tl.lesson_id
  and s.position = st.part_position
  and s.published = true;

do $$
begin
  if exists (
    select 1
    from _target_lessons tl
    join public.lesson_audio_segments s on s.lesson_id = tl.lesson_id
    where s.published = true
      and coalesce(s.audio_storage_path, s.audio_external_url) is not null
      and btrim(s.narration_text) = ''
  ) then
    raise exception 'Every playable segment must have an audio transcript';
  end if;
end;
$$;

-- Información específica, única y vinculada a cada audio/diapositiva de sílice.
insert into public.lesson_segment_notes (
  segment_id,
  summary,
  key_points,
  stop_criterion,
  source_label,
  source_pages,
  approved
)
select
  s.id,
  s.narration_text || E'\n\nAplicación al puesto: ' || case tl.block_position
    when 1 then 'identifica el polvo respirable como un riesgo aunque la nube no sea visible y evita valorar la seguridad solo a simple vista.'
    when 2 then 'relaciona cada resultado de medición con la tarea, la jornada real y las condiciones en las que se obtuvo.'
    when 3 then 'prioriza las medidas técnicas y colectivas sobre el uso aislado de protección individual.'
    when 4 then 'registra la exposición y comunica sin demora cualquier fallo de control o indicio que requiera vigilancia sanitaria.'
    else 'comprueba los controles antes de comenzar y aplica la formación preventiva en cada tarea.'
  end,
  array_remove(array[
    split_part(s.narration_text, '. ', 1) || '.',
    nullif(split_part(s.narration_text, '. ', 2), '')
  ], null),
  case tl.block_position
    when 1 then 'Detén la tarea y comunica la incidencia si se genera polvo sin medidas eficaces, aunque la nube no sea visible.'
    when 2 then 'No des por válida una medición que no represente la jornada o las condiciones reales del puesto.'
    when 3 then 'Interrumpe el trabajo si falla una medida colectiva y la exposición no queda controlada.'
    when 4 then 'Comunica de inmediato cualquier fallo preventivo o síntoma y sigue la indicación del servicio competente.'
    else 'No inicies la tarea si el control colectivo o el equipo respiratorio requerido no funcionan correctamente.'
  end,
  'ITC 02.0.02 · Orden TED/723/2021 · Cursos Pedro',
  coalesce(
    (
      select string_agg(
        distinct coalesce(nullif(ss.source_page, ''), 'diapositiva ' || ss.position),
        ', '
      )
      from public.lesson_segment_slides ss
      where ss.segment_id = s.id
    ),
    'Parte ' || tl.block_position || '.' || s.position
  ),
  true
from _target_lessons tl
join public.lesson_audio_segments s on s.lesson_id = tl.lesson_id
where tl.slug = 'prevencion-polvo-silice-cristalina-respirable'
  and tl.duration_hours = 5
  and s.published = true
  and coalesce(s.audio_storage_path, s.audio_external_url) is not null
on conflict (segment_id) do update
set
  summary = excluded.summary,
  key_points = excluded.key_points,
  stop_criterion = excluded.stop_criterion,
  source_label = excluded.source_label,
  source_pages = excluded.source_pages,
  approved = true,
  updated_at = now();

do $$
begin
  if exists (
    select 1
    from _target_lessons tl
    join public.lesson_audio_segments s on s.lesson_id = tl.lesson_id
    left join public.lesson_segment_notes n
      on n.segment_id = s.id and n.approved = true
    where s.published = true
      and coalesce(s.audio_storage_path, s.audio_external_url) is not null
      and n.id is null
  ) then
    raise exception 'Every playable segment must have approved specific information';
  end if;
end;
$$;

-- Un banco independiente por bloque evita mezclar preguntas de otros bloques.
insert into public.question_banks (course_version_id, title)
select
  tl.course_version_id,
  'Evaluación por bloque · ' || tl.slug || ' · '
    || tl.duration_hours || ' h · Bloque ' || tl.block_position
    || ' · 2026-08'
from _target_lessons tl
where not exists (
  select 1
  from public.question_banks qb
  where qb.course_version_id = tl.course_version_id
    and qb.title = 'Evaluación por bloque · ' || tl.slug || ' · '
      || tl.duration_hours || ' h · Bloque ' || tl.block_position
      || ' · 2026-08'
);

create temporary table _block_banks on commit drop as
select
  tl.*,
  qb.id as bank_id
from _target_lessons tl
join public.question_banks qb
  on qb.course_version_id = tl.course_version_id
  and qb.title = 'Evaluación por bloque · ' || tl.slug || ' · '
    || tl.duration_hours || ' h · Bloque ' || tl.block_position
    || ' · 2026-08';

do $$
begin
  if (select count(*) from _block_banks) <> 25 then
    raise exception 'Expected 25 block question banks, found %',
      (select count(*) from _block_banks);
  end if;
end;
$$;

create temporary table _assessment_segments on commit drop as
select
  bb.bank_id,
  bb.lesson_id,
  bb.block_position,
  s.id as segment_id,
  s.position as part_position,
  s.title,
  case
    when strpos(s.narration_text, '. ') > 0
      then split_part(s.narration_text, '. ', 1) || '.'
    else s.narration_text
  end as fact
from _block_banks bb
join public.lesson_audio_segments s on s.lesson_id = bb.lesson_id
where s.published = true
  and coalesce(s.audio_storage_path, s.audio_external_url) is not null
  and btrim(s.narration_text) <> '';

create temporary table _question_specs (
  question_id uuid not null default gen_random_uuid(),
  bank_id uuid not null,
  segment_id uuid,
  prompt text not null,
  explanation text not null,
  correct_option text not null,
  distractor_1 text not null,
  distractor_2 text not null,
  distractor_3 text not null
) on commit drop;

-- Diez preguntas factuales: una por cada explicación del bloque.
insert into _question_specs (
  bank_id, segment_id, prompt, explanation,
  correct_option, distractor_1, distractor_2, distractor_3
)
select
  current.bank_id,
  current.segment_id,
  '¿Cuál es la afirmación correcta sobre «' || current.title
    || '» según la explicación '
    || current.block_position || '.' || current.part_position || '?',
  'La respuesta aparece en la explicación '
    || current.block_position || '.' || current.part_position
    || ': ' || current.fact,
  current.fact,
  next_1.fact,
  next_2.fact,
  next_3.fact
from _assessment_segments current
join _assessment_segments next_1
  on next_1.bank_id = current.bank_id
  and next_1.part_position = (current.part_position % 10) + 1
join _assessment_segments next_2
  on next_2.bank_id = current.bank_id
  and next_2.part_position = ((current.part_position + 1) % 10) + 1
join _assessment_segments next_3
  on next_3.bank_id = current.bank_id
  and next_3.part_position = ((current.part_position + 2) % 10) + 1;

-- Cinco preguntas de identificación: refuerzan la relación idea/explicación.
insert into _question_specs (
  bank_id, segment_id, prompt, explanation,
  correct_option, distractor_1, distractor_2, distractor_3
)
select
  current.bank_id,
  null,
  '¿Qué explicación del bloque desarrolla esta idea: «'
    || current.fact || '»?',
  'La idea se desarrolla en la explicación '
    || current.block_position || '.' || current.part_position
    || ', titulada «' || current.title || '».',
  current.title,
  next_1.title,
  next_2.title,
  next_3.title
from _assessment_segments current
join _assessment_segments next_1
  on next_1.bank_id = current.bank_id
  and next_1.part_position = (current.part_position % 10) + 1
join _assessment_segments next_2
  on next_2.bank_id = current.bank_id
  and next_2.part_position = ((current.part_position + 1) % 10) + 1
join _assessment_segments next_3
  on next_3.bank_id = current.bank_id
  and next_3.part_position = ((current.part_position + 2) % 10) + 1
where current.part_position <= 5;

do $$
begin
  if exists (
    select 1
    from _block_banks bb
    left join _question_specs qs on qs.bank_id = bb.bank_id
    group by bb.bank_id
    having count(qs.question_id) <> 15
  ) then
    raise exception 'Every block bank must define exactly 15 questions';
  end if;
end;
$$;

insert into public.questions (
  id,
  question_bank_id,
  lesson_audio_segment_id,
  prompt,
  type,
  explanation,
  points,
  active
)
select
  qs.question_id,
  qs.bank_id,
  qs.segment_id,
  qs.prompt,
  'single_choice',
  qs.explanation,
  1,
  true
from _question_specs qs;

insert into public.question_options (
  question_id,
  position,
  option_text,
  is_correct
)
select
  qs.question_id,
  option.ordinality::integer,
  option.option_text,
  option.ordinality = 1
from _question_specs qs
cross join lateral unnest(array[
  qs.correct_option,
  qs.distractor_1,
  qs.distractor_2,
  qs.distractor_3
]) with ordinality as option(option_text, ordinality);

insert into public.quizzes (
  lesson_id,
  question_bank_id,
  title,
  question_count,
  passing_percent,
  required_perfect_streak,
  randomize_questions,
  randomize_options,
  minimum_retry_seconds,
  active,
  completion_mode
)
select
  bb.lesson_id,
  bb.bank_id,
  'Test del bloque ' || bb.block_position || ' · 15 preguntas',
  15,
  100,
  3,
  true,
  true,
  0,
  true,
  'cumulative_perfect'
from _block_banks bb
on conflict (lesson_id) do update
set
  question_bank_id = excluded.question_bank_id,
  title = excluded.title,
  question_count = 15,
  passing_percent = 100,
  required_perfect_streak = 3,
  randomize_questions = true,
  randomize_options = true,
  minimum_retry_seconds = 0,
  active = true,
  completion_mode = 'cumulative_perfect',
  updated_at = now();

update public.course_versions cv
set required_perfect_streak = 3, updated_at = now()
from _target_versions tv
where cv.id = tv.course_version_id;

do $$
begin
  if exists (
    select 1
    from _block_banks bb
    join public.quizzes q on q.lesson_id = bb.lesson_id
    left join public.questions question
      on question.question_bank_id = q.question_bank_id
      and question.active = true
    left join public.question_options option
      on option.question_id = question.id
    group by bb.lesson_id, q.id, q.question_count,
      q.required_perfect_streak, q.completion_mode
    having q.question_count <> 15
      or q.required_perfect_streak <> 3
      or q.completion_mode <> 'cumulative_perfect'
      or count(distinct question.id) <> 15
      or count(option.id) <> 60
      or count(option.id) filter (where option.is_correct) <> 15
  ) then
    raise exception 'Block assessment validation failed';
  end if;
end;
$$;
