begin;

alter table public.course_versions
  add column if not exists stripe_price_id text;

create unique index if not exists course_versions_stripe_price_unique_idx
  on public.course_versions (stripe_price_id)
  where stripe_price_id is not null;

insert into public.courses (
  slug, title, short_description, description, specialty, status
) values
(
  'operador-maquinaria-arranque-carga-viales',
  'Operador de maquinaria de arranque, carga y viales',
  'Formación Preventiva Oficial para operadores en actividades extractivas de exterior.',
  'Itinerario preventivo para pala cargadora, excavadora hidráulica de cadenas y tractor de cadenas, adaptado al puesto y al centro de trabajo. No es un carné genérico de maquinaria.',
  'ITC 02.1.02 · ET 2001-1-08',
  'published'
),
(
  'operador-maquinaria-transporte-camion-volquete',
  'Operador de maquinaria de transporte: camión y volquete',
  'Formación Preventiva Oficial para transporte en actividades extractivas de exterior.',
  'Itinerario preventivo para operadores de volquete y conductores de camión en explotaciones mineras de exterior, adaptado al puesto y al centro de trabajo.',
  'ITC 02.1.02 · ET 2000-1-08',
  'published'
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  'Prevención frente al polvo y la sílice cristalina respirable',
  'Formación preventiva específica sobre exposición a polvo y SCR en actividades mineras.',
  'Programa específico de información, prevención y protección frente al polvo respirable y la sílice cristalina respirable. Se encuadra en la ITC 02.0.02 y no en la ITC 02.1.02.',
  'ITC 02.0.02 · Orden TED/723/2021',
  'published'
)
on conflict (slug) do update set
  title = excluded.title,
  short_description = excluded.short_description,
  description = excluded.description,
  specialty = excluded.specialty,
  status = excluded.status,
  updated_at = now();

insert into public.course_versions (
  course_id, version_number, duration_hours, modality, objectives,
  target_audience, requirements, syllabus_summary, accreditation_label,
  accreditation_reference, practice_required, price_net, tax_rate, currency,
  stripe_price_id, status, published_at
)
select c.id, v.version_number, v.duration_hours, 'hybrid'::public.course_modality,
  v.objectives::jsonb, v.target_audience::jsonb, v.requirements::jsonb,
  v.syllabus_summary, v.accreditation_label, v.accreditation_reference,
  v.practice_required, v.price_net, 21, 'EUR', v.stripe_price_id,
  'published'::public.course_version_status, now()
from (
  values
  (
    'operador-maquinaria-arranque-carga-viales', 1, 5, 149.00,
    'price_1TyTpxFK9VAoIFUTFk2o1XS2', true,
    'Formación Preventiva Oficial de actualización y reciclaje',
    'ITC 02.1.02 · ET 2001-1-08',
    '["Actualizar técnicas preventivas específicas del puesto","Reconocer riesgos antes, durante y después del trabajo","Aplicar controles sobre máquina, entorno e interferencias"]',
    '["Operadores con formación inicial previa","Empresas y contratas de actividades extractivas de exterior"]',
    '["Acreditar formación inicial o situación formativa previa","Completar teoría, evaluación y práctica/validación aplicable"]',
    E'1. Definición de los trabajos\n2. Técnicas preventivas y de protección específicas\n3. Equipos, máquinas y medios auxiliares\n4. Control y vigilancia del lugar de trabajo\n5. Interferencias con otras actividades\n6. Normativa y legislación'
  ),
  (
    'operador-maquinaria-arranque-carga-viales', 2, 20, 349.00,
    'price_1TyTqNFK9VAoIFUTlGBgxMih', true,
    'Formación Preventiva Oficial inicial',
    'ITC 02.1.02 · ET 2001-1-08',
    '["Adquirir la formación preventiva mínima del puesto","Manejar con seguridad pala cargadora, excavadora y equipos asociados","Integrar la evaluación de riesgos y las instrucciones del centro"]',
    '["Personal de nueva incorporación","Operadores que deban completar el itinerario inicial"]',
    '["Completar las 20 horas mínimas","Superar evaluación teórica y validación práctica","Aportar los datos necesarios para el registro formativo"]',
    E'1. Definición de los trabajos (1 h)\n2. Técnicas preventivas y de protección específicas (11 h)\n3. Equipos, máquinas y medios auxiliares (3 h)\n4. Control y vigilancia del lugar y entorno (2 h)\n5. Interferencias con otras actividades (2 h)\n6. Normativa y legislación (1 h)'
  ),
  (
    'operador-maquinaria-transporte-camion-volquete', 1, 5, 149.00,
    'price_1TyTqCFK9VAoIFUT2UrdzGDd', true,
    'Formación Preventiva Oficial de actualización y reciclaje',
    'ITC 02.1.02 · ET 2000-1-08',
    '["Actualizar técnicas preventivas de transporte minero","Revisar riesgos de circulación, carga, descarga y mantenimiento","Aplicar procedimientos de coordinación e interferencias"]',
    '["Operadores de volquete y conductores de camión con formación previa","Empresas y contratas mineras"]',
    '["Acreditar formación inicial o situación formativa previa","Completar teoría, evaluación y práctica/validación aplicable"]',
    E'1. Definición de los trabajos\n2. Técnicas preventivas y de protección específicas\n3. Equipos, máquinas y medios auxiliares\n4. Control y vigilancia del lugar de trabajo\n5. Interferencias con otras actividades\n6. Normativa y legislación'
  ),
  (
    'operador-maquinaria-transporte-camion-volquete', 2, 20, 349.00,
    'price_1TyTqPFK9VAoIFUTpdJu3KO1', true,
    'Formación Preventiva Oficial inicial',
    'ITC 02.1.02 · ET 2000-1-08',
    '["Adquirir la formación preventiva mínima del puesto","Operar camiones y volquetes con criterios de seguridad minera","Integrar procedimientos del centro, señalización y coordinación"]',
    '["Personal de nueva incorporación","Operadores que deban completar el itinerario inicial"]',
    '["Completar las 20 horas mínimas","Superar evaluación teórica y validación práctica","Aportar los datos necesarios para el registro formativo"]',
    E'1. Definición de los trabajos (1 h)\n2. Técnicas preventivas y de protección específicas (11 h)\n3. Equipos, máquinas y medios auxiliares (3 h)\n4. Control y vigilancia del lugar y entorno (2 h)\n5. Interferencias con otras actividades (2 h)\n6. Normativa y legislación (1 h)'
  ),
  (
    'prevencion-polvo-silice-cristalina-respirable', 1, 5, 189.00,
    'price_1TyTqDFK9VAoIFUT2kb7kEQ3', true,
    'Formación preventiva específica',
    'ITC 02.0.02 · Orden TED/723/2021',
    '["Comprender el riesgo por polvo respirable y SCR","Identificar fuentes y evaluar medidas de control","Usar correctamente protección respiratoria y medidas higiénicas"]',
    '["Trabajadores expuestos a polvo inorgánico en actividades mineras","Mandos, técnicos y responsables preventivos"]',
    '["Completar la formación y evaluación","Realizar las prácticas o ensayos de ajuste que sean aplicables al puesto"]',
    E'1. Polvo y sílice cristalina respirable\n2. Polvo en la industria extractiva\n3. Marco normativo\n4. Identificación y evaluación de la exposición\n5. Prevención y reducción de la exposición\n6. Vigilancia de la salud\n7. Documentación e información\n8. Formación, consulta y protección respiratoria'
  )
) as v(
  slug, version_number, duration_hours, price_net, stripe_price_id,
  practice_required, accreditation_label, accreditation_reference,
  objectives, target_audience, requirements, syllabus_summary
)
join public.courses c on c.slug = v.slug
on conflict (course_id, version_number) do update set
  duration_hours = excluded.duration_hours,
  modality = excluded.modality,
  objectives = excluded.objectives,
  target_audience = excluded.target_audience,
  requirements = excluded.requirements,
  syllabus_summary = excluded.syllabus_summary,
  accreditation_label = excluded.accreditation_label,
  accreditation_reference = excluded.accreditation_reference,
  practice_required = excluded.practice_required,
  price_net = excluded.price_net,
  tax_rate = excluded.tax_rate,
  currency = excluded.currency,
  stripe_price_id = excluded.stripe_price_id,
  status = excluded.status,
  published_at = coalesce(public.course_versions.published_at, excluded.published_at),
  updated_at = now();

insert into public.course_modules (course_version_id, position, title, description)
select cv.id, m.position, m.title, m.description
from public.course_versions cv
join public.courses c on c.id = cv.course_id
cross join (
  values
    (1, 'Definición de los trabajos', 'Tareas, ciclos y operaciones del puesto.'),
    (2, 'Técnicas preventivas y de protección', 'Riesgos y medidas antes, durante y después del trabajo.'),
    (3, 'Equipos y medios auxiliares', 'Conocimiento, sistemas de seguridad y mantenimiento.'),
    (4, 'Control del lugar de trabajo', 'Entorno, señalización, estabilidad y vigilancia.'),
    (5, 'Interferencias y coordinación', 'Trabajos simultáneos y procedimientos internos.'),
    (6, 'Normativa y evaluación final', 'Marco aplicable y comprobación de conocimientos.')
) as m(position, title, description)
where c.slug in (
  'operador-maquinaria-arranque-carga-viales',
  'operador-maquinaria-transporte-camion-volquete'
)
on conflict (course_version_id, position) do update set
  title = excluded.title,
  description = excluded.description,
  updated_at = now();

insert into public.course_modules (course_version_id, position, title, description)
select cv.id, m.position, m.title, m.description
from public.course_versions cv
join public.courses c on c.id = cv.course_id
cross join (
  values
    (1, 'El polvo y la sílice cristalina', 'Conceptos, fracciones y efectos sobre la salud.'),
    (2, 'Exposición en la industria extractiva', 'Procesos, fuentes y situaciones de riesgo.'),
    (3, 'Marco normativo', 'ITC 02.0.02 y normativa preventiva relacionada.'),
    (4, 'Identificación y evaluación', 'Mediciones, valores y documentación.'),
    (5, 'Prevención y reducción', 'Medidas técnicas, organizativas, higiénicas y EPR.'),
    (6, 'Vigilancia, información y evaluación', 'Salud, consulta, práctica y comprobación final.')
) as m(position, title, description)
where c.slug = 'prevencion-polvo-silice-cristalina-respirable'
on conflict (course_version_id, position) do update set
  title = excluded.title,
  description = excluded.description,
  updated_at = now();

insert into public.lessons (
  module_id, position, title, summary, kind, duration_minutes,
  sequential_required, active
)
select cm.id, 1, cm.title,
  case
    when cm.position = 6 then
      'Incluye la evaluación final. El banco de preguntas aportado queda pendiente de validación docente de respuestas correctas antes de su activación.'
    else
      'Lección estructurada a partir de los manuales y presentaciones aportados por Inmíner. El vídeo se añadirá antes de abrir la matrícula.'
  end,
  case when cm.position = 6 then 'mixed'::public.lesson_kind else 'document'::public.lesson_kind end,
  case
    when cv.duration_hours = 20 and cm.position = 2 then 660
    when cv.duration_hours = 20 and cm.position = 3 then 180
    when cv.duration_hours = 20 and cm.position in (4, 5) then 120
    when cv.duration_hours = 20 then 60
    else 50
  end,
  true, true
from public.course_modules cm
join public.course_versions cv on cv.id = cm.course_version_id
join public.courses c on c.id = cv.course_id
where c.slug in (
  'operador-maquinaria-arranque-carga-viales',
  'operador-maquinaria-transporte-camion-volquete',
  'prevencion-polvo-silice-cristalina-respirable'
)
on conflict (module_id, position) do update set
  title = excluded.title,
  summary = excluded.summary,
  kind = excluded.kind,
  duration_minutes = excluded.duration_minutes,
  active = excluded.active,
  updated_at = now();

commit;
