begin;

-- Block 1 has ten sequential parts rather than the five-part editorial default.
alter table public.lesson_audio_segments
  drop constraint if exists lesson_audio_segments_position;
alter table public.lesson_audio_segments
  add constraint lesson_audio_segments_position
  check (position between 1 and 10);

alter table public.lesson_segment_slides
  add column if not exists source_label text,
  add column if not exists source_page text,
  add column if not exists alt_text text;

create table if not exists public.lesson_segment_notes (
  id uuid primary key default gen_random_uuid(),
  segment_id uuid not null unique
    references public.lesson_audio_segments(id) on delete cascade,
  summary text not null,
  key_points text[] not null default '{}'::text[],
  source_label text not null,
  source_pages text not null,
  approved boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_segment_notes_summary_length check (
    char_length(summary) between 10 and 4000
  )
);

drop trigger if exists lesson_segment_notes_set_updated_at
  on public.lesson_segment_notes;
create trigger lesson_segment_notes_set_updated_at
before update on public.lesson_segment_notes
for each row execute function app_private.set_updated_at();

alter table public.lesson_segment_notes enable row level security;

drop policy if exists lesson_segment_notes_visible
  on public.lesson_segment_notes;
create policy lesson_segment_notes_visible
on public.lesson_segment_notes for select
to authenticated
using (
  exists (
    select 1
    from public.lesson_audio_segments s
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    where s.id = segment_id
      and (
        (
          s.published
          and approved
          and (select app_private.current_user_is_enrolled(m.course_version_id))
        )
        or (select app_private.current_user_has_role(
          array[
            'tutor',
            'administrador',
            'superadministrador'
          ]::public.app_role[]
        ))
      )
  )
);

drop policy if exists lesson_segment_notes_admin_manage
  on public.lesson_segment_notes;
create policy lesson_segment_notes_admin_manage
on public.lesson_segment_notes for all
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

revoke all on public.lesson_segment_notes from anon, authenticated;
grant select, insert, update, delete on public.lesson_segment_notes
  to authenticated;

alter table public.questions
  add column if not exists lesson_audio_segment_id uuid
  references public.lesson_audio_segments(id) on delete set null;

create index if not exists questions_audio_segment_idx
  on public.questions (lesson_audio_segment_id)
  where lesson_audio_segment_id is not null;

create unique index if not exists questions_bank_audio_segment_unique_idx
  on public.questions (question_bank_id, lesson_audio_segment_id)
  where lesson_audio_segment_id is not null;

alter table public.quizzes
  add column if not exists completion_mode text
  not null default 'consecutive_perfect';

alter table public.quizzes
  drop constraint if exists quizzes_completion_mode;
alter table public.quizzes
  add constraint quizzes_completion_mode check (
    completion_mode in ('consecutive_perfect', 'cumulative_perfect')
  );

create temporary table block_one_parts (
  position smallint primary key,
  title text not null,
  narration text not null,
  duration_seconds integer not null,
  audio_filename text not null,
  slide_number text not null,
  slide_body text not null,
  manual_pages text not null,
  note_summary text not null,
  key_points text[] not null
) on commit drop;

insert into block_one_parts values
(1,
  'Introducción al movimiento de tierras en explotaciones',
  'El movimiento de tierras reúne las operaciones necesarias para modificar el terreno en una explotación. El ciclo principal comprende el arranque, la carga, el transporte y la descarga, y puede completarse con extendido, nivelación, compactación y refino.',
  26,
  'part-1-01.mp4',
  '4',
  'El movimiento de tierras transforma el terreno mediante un ciclo coordinado: arranque, carga, transporte y descarga. Según el trabajo, se añaden operaciones de acabado.',
  '13 (página impresa 7)',
  'El movimiento de tierras es un proceso encadenado. La elección de equipos y la coordinación entre fases condicionan producción, coste y seguridad.',
  array['Arranque', 'Carga', 'Transporte', 'Descarga', 'Operaciones complementarias']),
(2,
  'La fase de arranque: concepto y objetivos principales',
  'El arranque es la primera fase del ciclo. Su objetivo es separar el material del macizo o del terreno natural y dejarlo en condiciones adecuadas para su carga. El método depende de la naturaleza, dureza y estado del material.',
  18,
  'part-1-02.mp4',
  '5',
  'Arrancar consiste en separar y disgregar el material natural hasta obtener un material suelto que pueda cargarse y transportarse.',
  '13',
  'El resultado buscado no es solo extraer: el material debe quedar con una fragmentación y disposición compatibles con el equipo de carga.',
  array['Separar el material', 'Disgregar el macizo', 'Preparar para la carga']),
(3,
  'Métodos de arranque: uso de voladuras y perforación',
  'Cuando la roca sana presenta elevada dureza, el arranque suele requerir perforación y voladura. La operación debe planificarse para obtener la fragmentación necesaria, limitar proyecciones y vibraciones y facilitar las fases posteriores.',
  17,
  'part-1-03.mp4',
  '5',
  'La perforación crea los barrenos y la voladura fragmenta la roca. Su diseño debe responder al tipo de roca, a la geometría del frente y a la granulometría requerida.',
  '14',
  'Perforación y voladura forman un sistema: una fragmentación deficiente perjudica la carga, el transporte y la trituración.',
  array['Perforación de barrenos', 'Voladura planificada', 'Fragmentación controlada']),
(4,
  'El arranque mecánico mediante tractor de cadenas y ripper',
  'Los materiales ripables pueden arrancarse mecánicamente con un tractor de cadenas provisto de escarificador o ripper. La penetración de los dientes y el empuje del tractor rompen y aflojan el terreno sin recurrir a explosivos.',
  17,
  'part-1-04.mp4',
  '5',
  'El ripper concentra el esfuerzo en uno o varios dientes. La capacidad de ripado depende de la resistencia, fracturación y estratificación del terreno.',
  '14',
  'El tractor de cadenas aporta tracción; el escarificador transmite el esfuerzo al material. Antes de elegirlo debe comprobarse la ripabilidad.',
  array['Tractor de cadenas', 'Escarificador o ripper', 'Material ripable']),
(5,
  'La fase de carga: introducción y equipos habituales',
  'La carga recoge el material arrancado y lo deposita en el equipo de transporte o en la instalación receptora. Entre los equipos habituales se encuentran la pala cargadora y la excavadora, seleccionadas según frente, producción y compatibilidad con el transporte.',
  16,
  'part-1-05.mp3',
  '6',
  'La carga enlaza el arranque con el transporte. El tamaño de la cuchara, la altura de descarga y el ciclo de trabajo deben ser compatibles con el vehículo receptor.',
  '13–14',
  'Una buena combinación entre equipo de carga y transporte reduce esperas, derrames y maniobras innecesarias.',
  array['Pala cargadora', 'Excavadora', 'Compatibilidad con transporte']),
(6,
  'Características operativas de la pala cargadora sobre ruedas',
  'La pala cargadora sobre ruedas destaca por su movilidad, rapidez de desplazamiento y versatilidad en firmes adecuados. Su rendimiento exige controlar el estado del terreno, la estabilidad, los neumáticos y la posición segura del cucharón durante la circulación.',
  15,
  'part-1-06.mp3',
  '6',
  'La pala sobre ruedas combina carga y desplazamiento corto. La movilidad es una ventaja cuando el firme ofrece capacidad portante y se mantienen rutas seguras.',
  '14–15',
  'No debe confundirse movilidad con aptitud universal: barro profundo, roca cortante o firmes deficientes pueden perjudicar tracción, estabilidad y neumáticos.',
  array['Movilidad', 'Versatilidad', 'Control del firme', 'Vigilancia de neumáticos']),
(7,
  'Análisis de costes y distancias en la fase de transporte',
  'El transporte suele tener un peso decisivo en el coste del movimiento de tierras. La distancia, las diferencias de cota, el estado y pendiente de las pistas, la capacidad del equipo y los tiempos de espera determinan el rendimiento del ciclo.',
  15,
  'part-1-07.mp3',
  '7',
  'El coste de transporte crece con el tiempo de ciclo. No depende solo de los kilómetros: pendientes, firme, tráfico y coordinación de carga y descarga cambian la productividad.',
  '13',
  'El análisis debe considerar el ciclo completo, incluidos retorno vacío, esperas y maniobras.',
  array['Distancia', 'Diferencia de cotas', 'Estado de pistas', 'Tiempo de ciclo']),
(8,
  'Tipos de transporte y la fase de descarga en tolva o escombrera',
  'El material puede transportarse con volquetes, dúmperes, camiones bañera u otros sistemas continuos. La descarga puede realizarse en tolvas, acopios o escombreras y requiere una zona estable, señalizada y compatible con el equipo.',
  15,
  'part-1-08.mp3',
  '7–8',
  'El sistema de transporte se elige por distancia, producción, material y condiciones de la ruta. En descarga deben controlarse bordes, estabilidad del firme y presencia de personas o equipos.',
  '14–17',
  'La descarga forma parte del ciclo productivo y debe diseñarse con el mismo rigor que la carga y el transporte.',
  array['Volquete', 'Dúmper', 'Camión bañera', 'Tolva', 'Escombrera']),
(9,
  'Fases complementarias: extendido, nivelación, compactación y refino',
  'Después de la descarga pueden ser necesarias operaciones de extendido, nivelación, compactación y refino. Estas fases colocan el material con la geometría, espesor, densidad y acabado previstos en el proyecto.',
  16,
  'part-1-09.mp3',
  '4 y 9',
  'El extendido reparte el material; la nivelación define cotas y pendientes; la compactación alcanza la densidad prevista; el refino completa el acabado.',
  '13 y 18–20',
  'Las fases complementarias no son intercambiables. Cada una controla una propiedad distinta del resultado final.',
  array['Extendido', 'Nivelación', 'Compactación', 'Refino']),
(10,
  'Clasificación de los sistemas mixtos: excavadora, pala y mototraílla',
  'Los sistemas mixtos combinan varias funciones en una misma máquina. La excavadora puede arrancar y cargar, la pala puede cargar y realizar transporte corto y la mototraílla puede arrancar, cargar, transportar, descargar y extender en condiciones adecuadas.',
  21,
  'part-1-10.mp3',
  '10',
  'La clasificación funcional ayuda a diseñar el ciclo: equipos de una sola fase y equipos capaces de asumir dos o más operaciones.',
  '18–19',
  'Una máquina multifunción puede simplificar el ciclo, pero su idoneidad sigue dependiendo del terreno, la distancia y la producción requerida.',
  array['Excavadora: arranque y carga', 'Pala: carga y transporte corto', 'Mototraílla: ciclo combinado']);

update public.course_modules cm
set
  title = 'Definición de los trabajos y fases del movimiento de tierras',
  description = 'Arranque, carga, transporte, descarga y operaciones complementarias.',
  updated_at = now()
from public.course_versions cv
join public.courses c on c.id = cv.course_id
where cm.course_version_id = cv.id
  and cm.position = 1
  and cv.duration_hours = 5
  and c.slug = 'operador-maquinaria-arranque-carga-viales';

update public.lessons l
set
  title = 'Bloque 1 · Definición de los trabajos',
  summary = 'Diez partes secuenciales sobre las fases y equipos del movimiento de tierras.',
  duration_minutes = 60,
  kind = 'mixed'::public.lesson_kind,
  updated_at = now()
from public.course_modules cm
join public.course_versions cv on cv.id = cm.course_version_id
join public.courses c on c.id = cv.course_id
where l.module_id = cm.id
  and l.position = 1
  and cm.position = 1
  and cv.duration_hours = 5
  and c.slug = 'operador-maquinaria-arranque-carga-viales';

insert into public.lesson_audio_segments (
  lesson_id,
  position,
  title,
  narration_text,
  audio_storage_path,
  duration_seconds,
  published
)
select
  l.id,
  p.position,
  p.title,
  p.narration,
  cv.id::text || '/block-1/audio/' || p.audio_filename,
  p.duration_seconds,
  false
from block_one_parts p
join public.courses c
  on c.slug = 'operador-maquinaria-arranque-carga-viales'
join public.course_versions cv
  on cv.course_id = c.id and cv.duration_hours = 5
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
on conflict (lesson_id, position) do update set
  title = excluded.title,
  narration_text = excluded.narration_text,
  audio_storage_path = excluded.audio_storage_path,
  audio_external_url = null,
  duration_seconds = excluded.duration_seconds,
  published = false,
  updated_at = now();

insert into public.lesson_segment_slides (
  segment_id,
  position,
  title,
  body,
  source_label,
  source_page,
  alt_text
)
select
  s.id,
  1,
  'Parte 1.' || p.position::text || ' · ' || p.title,
  p.slide_body,
  'Presentación oficial del curso',
  'Diapositiva ' || p.slide_number,
  'Resumen visual de la parte 1.' || p.position::text || ': ' || p.title
from block_one_parts p
join public.courses c
  on c.slug = 'operador-maquinaria-arranque-carga-viales'
join public.course_versions cv
  on cv.course_id = c.id and cv.duration_hours = 5
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
join public.lesson_audio_segments s
  on s.lesson_id = l.id and s.position = p.position
on conflict (segment_id, position) do update set
  title = excluded.title,
  body = excluded.body,
  source_label = excluded.source_label,
  source_page = excluded.source_page,
  alt_text = excluded.alt_text,
  updated_at = now();

insert into public.lesson_segment_notes (
  segment_id,
  summary,
  key_points,
  source_label,
  source_pages,
  approved
)
select
  s.id,
  p.note_summary,
  p.key_points,
  'Manual de formación preventiva para el desempeño del puesto de operador de maquinaria de arranque/carga/viales',
  p.manual_pages,
  true
from block_one_parts p
join public.courses c
  on c.slug = 'operador-maquinaria-arranque-carga-viales'
join public.course_versions cv
  on cv.course_id = c.id and cv.duration_hours = 5
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
join public.lesson_audio_segments s
  on s.lesson_id = l.id and s.position = p.position
on conflict (segment_id) do update set
  summary = excluded.summary,
  key_points = excluded.key_points,
  source_label = excluded.source_label,
  source_pages = excluded.source_pages,
  approved = excluded.approved,
  updated_at = now();

insert into public.lesson_resources (
  lesson_id,
  kind,
  title,
  external_url,
  downloadable
)
select
  l.id,
  'pdf'::public.resource_kind,
  'Manual oficial del operador de maquinaria de arranque, carga y viales',
  'https://www.miteco.gob.es/content/dam/miteco/es/energia/files-1/mineria/Seguridad_Minera/Formacion/Material_Didactico/Operador_maquinaria_arranque_carga_viales.pdf',
  true
from public.courses c
join public.course_versions cv
  on cv.course_id = c.id and cv.duration_hours = 5
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
where c.slug = 'operador-maquinaria-arranque-carga-viales'
  and not exists (
    select 1
    from public.lesson_resources existing
    where existing.lesson_id = l.id
      and existing.external_url = 'https://www.miteco.gob.es/content/dam/miteco/es/energia/files-1/mineria/Seguridad_Minera/Formacion/Material_Didactico/Operador_maquinaria_arranque_carga_viales.pdf'
  );

create temporary table block_one_questions (
  segment_position smallint primary key,
  prompt text not null,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_position integer not null,
  explanation text not null
) on commit drop;

insert into block_one_questions values
(1, '¿Qué operaciones forman el ciclo principal del movimiento de tierras?',
  'Arranque, carga, transporte y descarga',
  'Solo perforación y voladura',
  'Únicamente extendido y compactación',
  'Carga, riego y mantenimiento',
  1, 'Parte 1.1. El ciclo principal enlaza arranque, carga, transporte y descarga.'),
(2, '¿Cuál es el objetivo principal de la fase de arranque?',
  'Compactar el material hasta su densidad final',
  'Separar y disgregar el material para que pueda cargarse',
  'Transportar el material hasta la escombrera',
  'Nivelar la pista de circulación',
  2, 'Parte 1.2. El arranque deja el material suelto y preparado para la carga.'),
(3, '¿Qué método se requiere normalmente para arrancar roca sana de elevada dureza?',
  'Riego y compactación',
  'Nivelación con motoniveladora',
  'Perforación y voladura planificada',
  'Transporte con camión bañera',
  3, 'Parte 1.3. La roca dura suele fragmentarse mediante barrenos y voladura.'),
(4, '¿Con qué elemento trabaja un tractor de cadenas para desgarrar material ripable?',
  'Con un escarificador o ripper',
  'Con una tolva fija',
  'Con una caja basculante',
  'Con un rodillo vibrante',
  1, 'Parte 1.4. Los dientes del ripper penetran y aflojan el terreno.'),
(5, '¿Qué equipo se utiliza habitualmente en la fase de carga?',
  'Un rodillo compactador',
  'Una perforadora exclusivamente',
  'Una pala cargadora',
  'Una motoniveladora exclusivamente',
  3, 'Parte 1.5. La pala cargadora es uno de los equipos habituales de carga.'),
(6, '¿Qué característica operativa destaca en una pala cargadora sobre ruedas?',
  'Su movilidad y rapidez de desplazamiento en firmes adecuados',
  'Que no necesita controlar el estado de los neumáticos',
  'Que trabaja mejor en cualquier barro profundo',
  'Que solo puede permanecer inmóvil',
  1, 'Parte 1.6. La movilidad es una ventaja, condicionada por el firme y los neumáticos.'),
(7, '¿Qué factores influyen de forma directa en el coste del transporte?',
  'Solo el color del vehículo',
  'La distancia, las cotas, las pistas y el tiempo de ciclo',
  'Únicamente el tamaño del cucharón',
  'Solo la marca del equipo',
  2, 'Parte 1.7. El coste se analiza sobre el ciclo completo y sus condiciones reales.'),
(8, '¿Qué equipos se emplean habitualmente para transportar material?',
  'Volquetes, dúmperes y camiones bañera',
  'Solo rodillos y compactadores',
  'Únicamente perforadoras',
  'Solo tractores con ripper',
  1, 'Parte 1.8. El sistema se elige según material, distancia, producción y ruta.'),
(9, '¿Qué conjunto corresponde a fases complementarias del movimiento de tierras?',
  'Perforación, voladura y carga',
  'Repostaje, lavado y estacionamiento',
  'Extendido, nivelación, compactación y refino',
  'Arranque, transporte y retorno vacío',
  3, 'Parte 1.9. Estas operaciones dan geometría, densidad y acabado al material.'),
(10, '¿Qué afirmación describe correctamente un sistema mixto?',
  'La excavadora solo transporta a larga distancia',
  'La pala no puede realizar desplazamientos cortos',
  'La mototraílla puede combinar arranque, carga, transporte, descarga y extendido',
  'Todos los equipos realizan siempre una única fase',
  3, 'Parte 1.10. Los sistemas mixtos reúnen dos o más funciones en una máquina.');

insert into public.question_banks (course_version_id, title)
select
  cv.id,
  'Bloque 1 · Definición de los trabajos'
from public.courses c
join public.course_versions cv
  on cv.course_id = c.id and cv.duration_hours = 5
where c.slug = 'operador-maquinaria-arranque-carga-viales'
on conflict (course_version_id, title) do nothing;

update public.questions q
set active = false, updated_at = now()
from public.question_banks qb
join public.course_versions cv on cv.id = qb.course_version_id
join public.courses c on c.id = cv.course_id
where q.question_bank_id = qb.id
  and qb.title = 'Bloque 1 · Definición de los trabajos'
  and cv.duration_hours = 5
  and c.slug = 'operador-maquinaria-arranque-carga-viales';

update public.questions q
set
  prompt = bq.prompt,
  explanation = bq.explanation,
  lesson_audio_segment_id = s.id,
  type = 'single_choice'::public.question_type,
  points = 1,
  active = true,
  updated_at = now()
from block_one_questions bq
join public.question_banks qb
  on qb.title = 'Bloque 1 · Definición de los trabajos'
join public.course_versions cv
  on cv.id = qb.course_version_id and cv.duration_hours = 5
join public.courses c
  on c.id = cv.course_id
 and c.slug = 'operador-maquinaria-arranque-carga-viales'
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
join public.lesson_audio_segments s
  on s.lesson_id = l.id and s.position = bq.segment_position
where q.question_bank_id = qb.id
  and q.lesson_audio_segment_id = s.id;

insert into public.questions (
  question_bank_id,
  lesson_audio_segment_id,
  prompt,
  type,
  explanation,
  points,
  active
)
select
  qb.id,
  s.id,
  bq.prompt,
  'single_choice'::public.question_type,
  bq.explanation,
  1,
  true
from block_one_questions bq
join public.question_banks qb
  on qb.title = 'Bloque 1 · Definición de los trabajos'
join public.course_versions cv
  on cv.id = qb.course_version_id and cv.duration_hours = 5
join public.courses c
  on c.id = cv.course_id
 and c.slug = 'operador-maquinaria-arranque-carga-viales'
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
join public.lesson_audio_segments s
  on s.lesson_id = l.id and s.position = bq.segment_position
where not exists (
  select 1
  from public.questions existing
  where existing.question_bank_id = qb.id
    and existing.lesson_audio_segment_id = s.id
);

insert into public.question_options (
  question_id,
  position,
  option_text,
  is_correct
)
select
  q.id,
  option_row.position,
  option_row.option_text,
  option_row.position = bq.correct_position
from block_one_questions bq
join public.question_banks qb
  on qb.title = 'Bloque 1 · Definición de los trabajos'
join public.course_versions cv
  on cv.id = qb.course_version_id and cv.duration_hours = 5
join public.courses c
  on c.id = cv.course_id
 and c.slug = 'operador-maquinaria-arranque-carga-viales'
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
join public.lesson_audio_segments s
  on s.lesson_id = l.id and s.position = bq.segment_position
join public.questions q
  on q.question_bank_id = qb.id and q.lesson_audio_segment_id = s.id
cross join lateral (
  values
    (1, bq.option_a),
    (2, bq.option_b),
    (3, bq.option_c),
    (4, bq.option_d)
) as option_row(position, option_text)
on conflict (question_id, position) do update set
  option_text = excluded.option_text,
  is_correct = excluded.is_correct,
  updated_at = now();

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
  l.id,
  qb.id,
  'Evaluación del Bloque 1',
  10,
  100,
  3,
  true,
  true,
  0,
  true,
  'cumulative_perfect'
from public.courses c
join public.course_versions cv
  on cv.course_id = c.id and cv.duration_hours = 5
join public.course_modules cm
  on cm.course_version_id = cv.id and cm.position = 1
join public.lessons l
  on l.module_id = cm.id and l.position = 1
join public.question_banks qb
  on qb.course_version_id = cv.id
 and qb.title = 'Bloque 1 · Definición de los trabajos'
where c.slug = 'operador-maquinaria-arranque-carga-viales'
on conflict (lesson_id) do update set
  question_bank_id = excluded.question_bank_id,
  title = excluded.title,
  question_count = excluded.question_count,
  passing_percent = excluded.passing_percent,
  required_perfect_streak = excluded.required_perfect_streak,
  randomize_questions = excluded.randomize_questions,
  randomize_options = excluded.randomize_options,
  minimum_retry_seconds = excluded.minimum_retry_seconds,
  active = excluded.active,
  completion_mode = excluded.completion_mode,
  updated_at = now();

create or replace function public.start_quiz_attempt(
  p_quiz_id uuid,
  p_enrollment_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  quiz_record public.quizzes%rowtype;
  attempt_id uuid;
  next_attempt_number integer;
  prior_streak integer := 0;
  perfect_rounds integer := 0;
  last_submitted_at timestamptz;
  question_total integer;
  result jsonb;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  perform pg_advisory_xact_lock(
    hashtextextended(p_quiz_id::text || ':' || p_enrollment_id::text, 0)
  );

  select q.*
  into quiz_record
  from public.quizzes q
  join public.lessons l on l.id = q.lesson_id
  join public.course_modules m on m.id = l.module_id
  join public.enrollments e on e.course_version_id = m.course_version_id
  join public.lesson_progress lp
    on lp.enrollment_id = e.id and lp.lesson_id = l.id
  where q.id = p_quiz_id
    and q.active = true
    and e.id = p_enrollment_id
    and e.user_id = current_user_id
    and e.status not in ('failed', 'expired')
    and lp.status <> 'locked';

  if not found then
    raise exception 'Quiz is not available';
  end if;

  select qa.id, qa.attempt_number
  into attempt_id, next_attempt_number
  from public.quiz_attempts qa
  where qa.quiz_id = p_quiz_id
    and qa.enrollment_id = p_enrollment_id
    and qa.user_id = current_user_id
    and qa.status = 'in_progress'
  order by qa.attempt_number desc
  limit 1;

  select
    coalesce(
      (array_agg(perfect_streak_after order by attempt_number desc)
        filter (where status = 'graded'))[1],
      0
    ),
    count(*) filter (where status = 'graded' and is_perfect = true),
    max(submitted_at)
  into prior_streak, perfect_rounds, last_submitted_at
  from public.quiz_attempts
  where quiz_id = p_quiz_id
    and enrollment_id = p_enrollment_id;

  if attempt_id is null then
    select coalesce(max(attempt_number), 0) + 1
    into next_attempt_number
    from public.quiz_attempts
    where quiz_id = p_quiz_id
      and enrollment_id = p_enrollment_id;

    if last_submitted_at is not null
       and last_submitted_at
         + make_interval(secs => quiz_record.minimum_retry_seconds) > now()
    then
      raise exception 'Retry interval has not elapsed';
    end if;

    select count(*)
    into question_total
    from public.questions
    where question_bank_id = quiz_record.question_bank_id
      and active = true;

    if question_total < quiz_record.question_count then
      raise exception 'Question bank does not contain enough active questions';
    end if;

    insert into public.quiz_attempts (
      quiz_id, enrollment_id, user_id, attempt_number, status
    )
    values (
      p_quiz_id, p_enrollment_id, current_user_id,
      next_attempt_number, 'in_progress'
    )
    returning id into attempt_id;

    insert into public.quiz_attempt_questions (
      quiz_attempt_id, question_id, position, option_order
    )
    select
      attempt_id,
      chosen.id,
      row_number() over (),
      case
        when quiz_record.randomize_options then (
          select array_agg(o.id order by random())
          from public.question_options o
          where o.question_id = chosen.id
        )
        else (
          select array_agg(o.id order by o.position)
          from public.question_options o
          where o.question_id = chosen.id
        )
      end
    from (
      select q.id
      from public.questions q
      where q.question_bank_id = quiz_record.question_bank_id
        and q.active = true
      order by
        case when quiz_record.randomize_questions then random() else 0 end,
        q.created_at,
        q.id
      limit quiz_record.question_count
    ) chosen;
  end if;

  select jsonb_build_object(
    'attemptId', attempt_id,
    'attemptNumber', next_attempt_number,
    'title', quiz_record.title,
    'currentStreak', prior_streak,
    'requiredStreak', quiz_record.required_perfect_streak,
    'currentPerfectRounds', perfect_rounds,
    'requiredPerfectRounds', quiz_record.required_perfect_streak,
    'completionMode', quiz_record.completion_mode,
    'questions', coalesce(
      jsonb_agg(
        jsonb_build_object(
          'id', q.id,
          'prompt', q.prompt,
          'type', q.type,
          'options', (
            select jsonb_agg(
              jsonb_build_object(
                'id', ordered_option.option_id,
                'text', qo.option_text
              )
              order by ordered_option.ordinality
            )
            from unnest(aq.option_order) with ordinality
              as ordered_option(option_id, ordinality)
            join public.question_options qo
              on qo.id = ordered_option.option_id
          )
        )
        order by aq.position
      ),
      '[]'::jsonb
    )
  )
  into result
  from public.quiz_attempt_questions aq
  join public.questions q on q.id = aq.question_id
  where aq.quiz_attempt_id = attempt_id;

  return result;
end;
$$;

create or replace function public.submit_quiz_attempt(
  p_attempt_id uuid,
  p_answers jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  attempt_record public.quiz_attempts%rowtype;
  quiz_record public.quizzes%rowtype;
  total_questions integer;
  correct_questions integer;
  score numeric(5,2);
  perfect boolean;
  prior_streak integer := 0;
  resulting_streak integer;
  prior_perfect_rounds integer := 0;
  resulting_perfect_rounds integer;
  completion_achieved boolean;
  review_parts jsonb := '[]'::jsonb;
  v_course_version_id uuid;
  v_lesson_id uuid;
  completed_lessons integer;
  total_lessons integer;
  progress numeric(5,2);
  practice_is_required boolean;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  if jsonb_typeof(p_answers) <> 'array' then
    raise exception 'Answers must be a JSON array';
  end if;

  select *
  into attempt_record
  from public.quiz_attempts
  where id = p_attempt_id
    and user_id = current_user_id
  for update;

  if not found or attempt_record.status <> 'in_progress' then
    raise exception 'Attempt is not available for submission';
  end if;

  select *
  into quiz_record
  from public.quizzes
  where id = attempt_record.quiz_id;

  with submitted as (
    select
      answer.question_id,
      coalesce(
        array(
          select value::uuid
          from jsonb_array_elements_text(answer.selected_option_ids) value
          order by value::uuid
        ),
        '{}'::uuid[]
      ) as selected_ids
    from jsonb_to_recordset(p_answers) as answer(
      question_id uuid,
      selected_option_ids jsonb
    )
  ),
  graded as (
    select
      aq.question_id,
      coalesce(s.selected_ids, '{}'::uuid[]) as selected_ids,
      coalesce(s.selected_ids, '{}'::uuid[]) = array(
        select qo.id
        from public.question_options qo
        where qo.question_id = aq.question_id
          and qo.is_correct = true
        order by qo.id
      ) as is_correct
    from public.quiz_attempt_questions aq
    left join submitted s on s.question_id = aq.question_id
    where aq.quiz_attempt_id = p_attempt_id
  )
  insert into public.quiz_attempt_answers (
    quiz_attempt_id, question_id, selected_option_ids, is_correct
  )
  select p_attempt_id, question_id, selected_ids, is_correct
  from graded;

  select
    count(*),
    count(*) filter (where is_correct)
  into total_questions, correct_questions
  from public.quiz_attempt_answers
  where quiz_attempt_id = p_attempt_id;

  if total_questions = 0 then
    raise exception 'Attempt has no questions';
  end if;

  score := round(
    (correct_questions::numeric / total_questions::numeric) * 100,
    2
  );
  perfect := correct_questions = total_questions;

  select
    coalesce(
      (array_agg(perfect_streak_after order by attempt_number desc))[1],
      0
    ),
    count(*) filter (where is_perfect = true)
  into prior_streak, prior_perfect_rounds
  from public.quiz_attempts
  where quiz_id = attempt_record.quiz_id
    and enrollment_id = attempt_record.enrollment_id
    and status = 'graded'
    and attempt_number < attempt_record.attempt_number;

  resulting_streak := case when perfect then prior_streak + 1 else 0 end;
  resulting_perfect_rounds := prior_perfect_rounds
    + case when perfect then 1 else 0 end;
  completion_achieved := case
    when quiz_record.completion_mode = 'cumulative_perfect'
      then resulting_perfect_rounds >= quiz_record.required_perfect_streak
    else resulting_streak >= quiz_record.required_perfect_streak
  end;

  update public.quiz_attempts
  set
    status = 'graded',
    score_percent = score,
    is_perfect = perfect,
    perfect_streak_after = resulting_streak,
    submitted_at = now(),
    graded_at = now()
  where id = p_attempt_id;

  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'position', missed.position,
        'title', missed.title
      )
      order by missed.position
    ),
    '[]'::jsonb
  )
  into review_parts
  from (
    select distinct s.position, s.title
    from public.quiz_attempt_answers qaa
    join public.questions q on q.id = qaa.question_id
    join public.lesson_audio_segments s
      on s.id = q.lesson_audio_segment_id
    where qaa.quiz_attempt_id = p_attempt_id
      and qaa.is_correct = false
  ) missed;

  select q.lesson_id, m.course_version_id
  into v_lesson_id, v_course_version_id
  from public.quizzes q
  join public.lessons l on l.id = q.lesson_id
  join public.course_modules m on m.id = l.module_id
  where q.id = attempt_record.quiz_id;

  if completion_achieved then
    update public.lesson_progress
    set
      status = 'completed',
      completed_at = coalesce(completed_at, now())
    where enrollment_id = attempt_record.enrollment_id
      and public.lesson_progress.lesson_id = v_lesson_id;

    update public.lesson_progress target_progress
    set status = 'available'
    where target_progress.enrollment_id = attempt_record.enrollment_id
      and target_progress.status = 'locked'
      and target_progress.lesson_id = (
        select ordered.id
        from (
          select
            l.id,
            row_number() over (order by m.position, l.position) as sequence_number
          from public.course_modules m
          join public.lessons l on l.module_id = m.id
          where m.course_version_id = v_course_version_id
            and l.active = true
        ) ordered
        where ordered.sequence_number = (
          select current_lesson.sequence_number + 1
          from (
            select
              l.id,
              row_number() over (order by m.position, l.position) as sequence_number
            from public.course_modules m
            join public.lessons l on l.module_id = m.id
            where m.course_version_id = v_course_version_id
              and l.active = true
          ) current_lesson
          where current_lesson.id = v_lesson_id
        )
      );
  end if;

  select
    count(*) filter (where lp.status = 'completed'),
    count(*)
  into completed_lessons, total_lessons
  from public.lesson_progress lp
  where lp.enrollment_id = attempt_record.enrollment_id;

  progress := case
    when total_lessons = 0 then 0
    else round(
      (completed_lessons::numeric / total_lessons::numeric) * 100,
      2
    )
  end;

  select practice_required
  into practice_is_required
  from public.course_versions
  where id = v_course_version_id;

  update public.enrollments
  set
    progress_percent = progress,
    status = case
      when completed_lessons = total_lessons and practice_is_required
        then 'practice_pending'::public.enrollment_status
      when completed_lessons = total_lessons
        then 'completed'::public.enrollment_status
      else 'in_progress'::public.enrollment_status
    end,
    started_at = coalesce(started_at, now()),
    theory_completed_at = case
      when completed_lessons = total_lessons
        then coalesce(theory_completed_at, now())
      else theory_completed_at
    end,
    completed_at = case
      when completed_lessons = total_lessons and not practice_is_required
        then coalesce(completed_at, now())
      else completed_at
    end
  where id = attempt_record.enrollment_id;

  return jsonb_build_object(
    'scorePercent', score,
    'isPerfect', perfect,
    'perfectStreak', resulting_streak,
    'requiredStreak', quiz_record.required_perfect_streak,
    'perfectRounds', resulting_perfect_rounds,
    'requiredPerfectRounds', quiz_record.required_perfect_streak,
    'completionMode', quiz_record.completion_mode,
    'reviewParts', review_parts,
    'evaluationCompleted', completion_achieved
  );
end;
$$;

revoke all on function public.start_quiz_attempt(uuid, uuid)
  from public, anon;
revoke all on function public.submit_quiz_attempt(uuid, jsonb)
  from public, anon;
grant execute on function public.start_quiz_attempt(uuid, uuid)
  to authenticated;
grant execute on function public.submit_quiz_attempt(uuid, jsonb)
  to authenticated;

commit;
