begin;

create temporary table course_four_slide_content (
  module_position smallint not null,
  segment_position smallint not null,
  source_part text not null,
  title text not null,
  summary text not null,
  first_page smallint not null,
  second_page smallint not null,
  primary key (module_position, segment_position)
) on commit drop;

insert into course_four_slide_content (
  module_position, segment_position, source_part, title, summary,
  first_page, second_page
) values
  (1, 1, '1.1', '1.1 · Objeto de la formación y ámbito de aplicación', 'Formación preventiva inicial para operadores de pala cargadora, excavadora hidráulica de cadenas y tractor de cadenas en actividades extractivas de exterior.', 1, 2),
  (1, 2, '1.2', '1.2 · Fases del movimiento de tierras', 'El ciclo integra arranque, carga, transporte y descarga; en trabajos especiales también extendido, nivelación, compactación y refino.', 3, 4),
  (1, 3, '1.3', '1.3 · Arranque del material y elección del método', 'El método depende de dureza, fracturación, humedad, pendiente y volumen: voladura, ripado, excavación mecánica o accesorios autorizados.', 5, 6),
  (1, 4, '1.4', '1.4 · Pala cargadora: definición y funciones', 'Máquina autopropulsada con equipo frontal para cargar, alimentar instalaciones, limpiar pistas o manipular materiales con accesorios autorizados.', 7, 8),
  (1, 5, '1.5', '1.5 · Excavadora hidráulica de cadenas', 'Excava y carga desde una plataforma estable con superestructura giratoria, pluma, balancín y cuchara u otros accesorios autorizados.', 9, 10),
  (1, 6, '1.6', '1.6 · Tractor de cadenas: definición y aplicaciones', 'Equipo con hoja o escarificador para cortar, empujar, ripar, nivelar, conformar escombreras y apoyar recuperaciones según procedimiento.', 11, 12),
  (1, 7, '1.7', '1.7 · Órdenes de trabajo, coordinación y DIS', 'La tarea debe estar definida: frente, equipo, trayectoria, punto de descarga, interferencias, límites de circulación y comunicación.', 13, 14),
  (1, 8, '1.8', '1.8 · Límites de uso, accesorios y fabricante', 'Cada accesorio modifica peso, centro de gravedad, alcance, presión hidráulica y capacidad. La compatibilidad física no basta.', 15, 16),
  (1, 9, '1.9', '1.9 · Mantenimiento y competencia del operador', 'El operador realiza comprobaciones y mantenimiento rutinario asignado; las reparaciones complejas corresponden a personal competente.', 17, 18),
  (1, 10, '1.10', '1.10 · Documentación, trazabilidad y práctica', 'La formación inicial de 20 horas debe apoyarse en diapositivas, manual, actividades, prácticas, evaluación y evidencias del centro real.', 19, 20),
  (2, 1, '2.1', '2.1 · Preparación personal y equipos de protección', 'Antes de acceder a la máquina se confirma aptitud física y mental, ropa ajustada y EPI adecuados al riesgo del puesto.', 21, 22),
  (2, 2, '2.2', '2.2 · Inspección perimetral de la máquina', 'La revisión diaria comienza desde el suelo, con máquina inmovilizada y equipo apoyado, buscando personas, obstáculos, daños, fugas y signos de incendio.', 23, 24),
  (2, 3, '2.3', '2.3 · Niveles, fugas y circuitos calientes', 'Los niveles se comprueban según manual. No se abre un circuito caliente ni se busca una fuga hidráulica con la mano.', 25, 26),
  (2, 4, '2.4', '2.4 · Neumáticos y tren de rodaje', 'En palas se revisan neumáticos, llantas y fijaciones; en cadenas, tensión, rodillos, zapatas y acumulación de material.', 27, 28),
  (2, 5, '2.5', '2.5 · Equipo de trabajo y sistema hidráulico', 'Se inspeccionan cucharón, hoja, pluma, pasadores, dientes, cilindros y latiguillos antes de presurizar o mover el equipo.', 29, 30),
  (2, 6, '2.6', '2.6 · Acceso seguro y acondicionamiento de cabina', 'Subir y bajar mirando a la máquina con tres puntos de apoyo; ajustar asiento, espejos, cinturón y retirar objetos sueltos.', 31, 32),
  (2, 7, '2.7', '2.7 · Comprobaciones funcionales', 'Tras el arranque se observan paneles y se prueban frenos, dirección, bocina, alarma de retroceso, luces y mandos a baja velocidad.', 33, 34),
  (2, 8, '2.8', '2.8 · Embarque y transporte sobre góndola', 'El embarque requiere rampas adecuadas, máquina alineada, señalista visible, puntos de amarre autorizados y equipo de trabajo apoyado.', 35, 36),
  (2, 9, '2.9', '2.9 · Remolcado y recuperación', 'El remolcado depende de frenos, dirección, peso, terreno y puntos de enganche. Se aplica el procedimiento del fabricante y de la explotación.', 37, 38),
  (2, 10, '2.10', '2.10 · Cambio de accesorios y entorno preparado', 'El cambio de accesorio se realiza en zona nivelada, con energía controlada, útil compatible y comprobación funcional posterior.', 39, 40),
  (3, 1, '3.1', '3.1 · Arranque, calentamiento y preparación', 'El motor se arranca desde cabina, con mandos neutralizados y zona despejada, vigilando presión de aceite, temperatura, carga eléctrica y alarmas.', 41, 42),
  (3, 2, '3.2', '3.2 · Visibilidad, zonas ciegas y control del área', 'Las máquinas grandes pueden ocultar personas o vehículos ligeros. Cámaras y espejos ayudan, pero no sustituyen observación, señalista y segregación.', 43, 44),
  (3, 3, '3.3', '3.3 · Carga segura con pala cargadora', 'La pala se aproxima con cucharón bajo y bastidores alineados, ataca el acopio sin embestir y transporta la carga baja y estable.', 45, 46),
  (3, 4, '3.4', '3.4 · Excavación y carga con excavadora hidráulica', 'La excavadora trabaja sobre plataforma resistente, con radio de giro despejado y vehículo de transporte fuera de zonas peligrosas.', 47, 48),
  (3, 5, '3.5', '3.5 · Trabajo con tractor de cadenas', 'El tractor corta, empuja, ripia y nivela dentro de límites de pendiente, adherencia y capacidad, manteniendo hoja o ripper bajo control.', 49, 50),
  (3, 6, '3.6', '3.6 · Circulación con maquinaria de arranque y carga', 'La circulación se realiza por rutas autorizadas, con equipo bajo, velocidad adaptada, distancia de seguridad y cinturón colocado.', 51, 52),
  (3, 7, '3.7', '3.7 · Bordes, taludes y acopios', 'La estabilidad cambia por lluvia, voladura, vibración, agua o material recién movido. Se vigilan grietas, bloques y deformaciones.', 53, 54),
  (3, 8, '3.8', '3.8 · Elevación de cargas y usos especiales', 'Elevar cargas con excavadora o pala solo es admisible si está previsto, configurado y evaluado, con peso conocido y útiles adecuados.', 55, 56),
  (3, 9, '3.9', '3.9 · Estacionamiento y parada segura', 'Al finalizar o detenerse, estacionar en lugar seguro, equipo apoyado, mandos neutralizados, freno conectado y máquina asegurada.', 57, 58),
  (3, 10, '3.10', '3.10 · Avería durante la operación', 'Ante avería se busca una posición segura, se señaliza, se comunica y se impide que terceros entren en zonas peligrosas.', 59, 60),
  (4, 1, '4.1', '4.1 · Motor, refrigeración y lubricación', 'El operador vigila presión de aceite, temperatura, combustible, filtros y admisión de aire para evitar roturas, incendios o pérdida de control.', 61, 62),
  (4, 2, '4.2', '4.2 · Transmisión, articulación y tracción', 'La transmisión entrega potencia; en palas articuladas la zona central es un punto de aplastamiento que debe bloquearse para mantenimiento.', 63, 64),
  (4, 3, '4.3', '4.3 · Sistema hidráulico y energía acumulada', 'El circuito hidráulico puede conservar presión con motor parado; acumuladores, cilindros e implementos elevados requieren descarga y bloqueo.', 65, 66),
  (4, 4, '4.4', '4.4 · Accesorios y capacidades', 'Cucharones, horquillas, martillos o rippers cambian peso, alcance, centro de gravedad y esfuerzos sobre la máquina.', 67, 68),
  (4, 5, '4.5', '4.5 · Neumáticos, cadenas y terreno', 'Neumáticos y cadenas condicionan dirección, frenado, estabilidad y capacidad de trabajar sobre rellenos, plataformas o bordes.', 69, 70),
  (4, 6, '4.6', '4.6 · Frenos, dirección y control del movimiento', 'Frenos de servicio, estacionamiento y emergencia deben probarse según manual. La dirección de emergencia no permite continuar produciendo.', 71, 72),
  (4, 7, '4.7', '4.7 · ROPS, FOPS y cinturón', 'ROPS protege frente a vuelco y FOPS frente a caída de objetos dentro de condiciones de diseño; el cinturón mantiene al operador en la zona protegida.', 73, 74),
  (4, 8, '4.8', '4.8 · Espejos, cámaras, alarmas y mandos', 'Los sistemas de ayuda reducen el riesgo, pero no sustituyen observación directa, segregación ni comunicación con señalista.', 75, 76),
  (4, 9, '4.9', '4.9 · Resguardos y acceso a mantenimiento', 'Resguardos de correas, ventiladores y partes móviles deben reinstalarse tras mantenimiento; las zonas de acceso deben ser antideslizantes y seguras.', 77, 78),
  (4, 10, '4.10', '4.10 · Manual, señalización y límites documentados', 'El manual y la señalización de la máquina indican uso previsto, riesgos residuales, límites, mantenimiento y respuesta ante alarmas.', 79, 80),
  (5, 1, '5.1', '5.1 · Vigilancia de frentes, plataformas y taludes', 'El operador observa frente, coronación, pie de talud y plataforma antes y durante el trabajo, especialmente tras lluvia, heladas o voladuras.', 81, 82),
  (5, 2, '5.2', '5.2 · Pistas, bermas, drenaje y polvo', 'Las pistas requieren anchura, pendiente, firme, visibilidad y drenaje compatibles con los equipos; las bermas no son freno garantizado.', 83, 84),
  (5, 3, '5.3', '5.3 · Interferencia entre pala cargadora y camión', 'La carga combina dos equipos con zonas ciegas. Punto de espera, autorización, señales y trayectoria deben estar definidos.', 85, 86),
  (5, 4, '5.4', '5.4 · Interferencia entre excavadora y transporte', 'La excavadora requiere radio de giro despejado y camión posicionado en punto estable, fuera de la zona de golpeo o caída.', 87, 88),
  (5, 5, '5.5', '5.5 · Personal de tierra, señalistas y comunicaciones', 'Rutas peatonales y zonas de exclusión deben estar definidas. Para acercarse a una máquina se establece contacto y se espera confirmación.', 89, 90),
  (5, 6, '5.6', '5.6 · Trabajos próximos a líneas eléctricas', 'Las líneas aéreas pueden producir arco sin contacto. Se identifican tensión, altura, recorrido y distancias del procedimiento.', 91, 92),
  (5, 7, '5.7', '5.7 · Mantenimiento, reparación e interferencias', 'Operador y mantenimiento acuerdan quién controla la máquina, qué energías se aíslan y cuándo se retiran bloqueos.', 93, 94),
  (6, 1, '5.8', '5.8 · Incendio, primeros auxilios y conducta PAS', 'La conducta básica es proteger, alertar y socorrer dentro de la formación recibida, evitando nuevas víctimas y comunicando información precisa.', 95, 96),
  (6, 2, '5.9', '5.9 · Plan de emergencia y evacuación', 'El plan define alarmas, responsables, vías, puntos de reunión y comunicaciones. El operador debe saber dejar la máquina sin bloquear una pista.', 97, 98),
  (6, 3, '5.10', '5.10 · Marco normativo, derechos y obligaciones', 'La formación se encuadra en la ITC 02.1.02 y ET 2001-1-08, con relación a Ley 31/1995, RD 1215/1997, RD 1389/1997 y coordinación empresarial.', 99, 100);

-- Publish the initial 20-hour offer without changing the 5-hour refresher version.
update public.courses
set status = 'published', updated_at = now()
where slug = 'operador-maquinaria-arranque-carga-viales';

update public.course_versions cv
set status = 'published',
    published_at = coalesce(cv.published_at, now()),
    updated_at = now()
from public.courses c
where c.id = cv.course_id
  and c.slug = 'operador-maquinaria-arranque-carga-viales'
  and cv.duration_hours = 20;

-- Split the complete presentation across the six official lessons. PDF block 5
-- is divided between interferences (5.1-5.7) and regulations/assessment
-- (5.8-5.10).
update public.lessons l
set content_mode = 'slides',
    kind = case
      when cm.position = 6 then 'mixed'::public.lesson_kind
      else 'document'::public.lesson_kind
    end,
    active = true,
    updated_at = now()
from public.course_modules cm
join public.course_versions cv on cv.id = cm.course_version_id
join public.courses c on c.id = cv.course_id
where l.module_id = cm.id
  and l.position = 1
  and c.slug = 'operador-maquinaria-arranque-carga-viales'
  and cv.duration_hours = 20;

-- Disable previous editorial chapters and publish only the 50 chapters from
-- the definitive PDF.
update public.lesson_audio_segments segment
set published = false,
    updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where segment.lesson_id = lesson.id
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

insert into public.lesson_audio_segments (
  lesson_id, position, title, narration_text, audio_storage_path,
  audio_external_url, duration_seconds, published
)
select
  lesson.id, content.segment_position, content.title, content.summary,
  null, null, 120, true
from course_four_slide_content content
join public.course_modules module on module.position = content.module_position
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join public.lessons lesson on lesson.module_id = module.id and lesson.position = 1
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
on conflict (lesson_id, position) do update set
  title = excluded.title,
  narration_text = excluded.narration_text,
  audio_storage_path = null,
  audio_external_url = null,
  duration_seconds = excluded.duration_seconds,
  published = true,
  updated_at = now();

-- Replace prior visual aids for this offer with the 100 definitive slides.
delete from public.lesson_segment_slides slide
using public.lesson_audio_segments segment,
      public.lessons lesson,
      public.course_modules module,
      public.course_versions version,
      public.courses course
where slide.segment_id = segment.id
  and segment.lesson_id = lesson.id
  and lesson.module_id = module.id
  and module.course_version_id = version.id
  and version.course_id = course.id
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

insert into public.lesson_segment_slides (
  segment_id, position, title, body, image_external_url,
  source_label, source_page, alt_text
)
select
  segment.id,
  page.slide_position,
  case when page.slide_position = 1 then content.title
       else content.title || ' · Aplicación visual en obra' end,
  content.summary,
  format('/course-slides/arranque-20h/slide-%s.jpg', lpad(page.page_number::text, 3, '0')),
  'Curso 4 · Formación inicial 20 h',
  format('Diapositiva %s de 100', page.page_number),
  case when page.slide_position = 1 then content.title
       else content.title || ' · Aplicación visual en obra' end
from course_four_slide_content content
join public.course_modules module on module.position = content.module_position
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join public.lessons lesson on lesson.module_id = module.id and lesson.position = 1
join public.lesson_audio_segments segment
  on segment.lesson_id = lesson.id and segment.position = content.segment_position
cross join lateral (
  values (1::smallint, content.first_page), (2::smallint, content.second_page)
) as page(slide_position, page_number)
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
on conflict (segment_id, position) do update set
  title = excluded.title,
  body = excluded.body,
  image_storage_path = null,
  image_external_url = excluded.image_external_url,
  source_label = excluded.source_label,
  source_page = excluded.source_page,
  alt_text = excluded.alt_text,
  updated_at = now();

-- Make the complete PDF downloadable from all six course blocks.
delete from public.lesson_resources resource
using public.lessons lesson,
      public.course_modules module,
      public.course_versions version,
      public.courses course
where resource.lesson_id = lesson.id
  and lesson.module_id = module.id
  and module.course_version_id = version.id
  and version.course_id = course.id
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
  and resource.external_url = '/course-materials/arranque-20h/formacion-inicial-arranque-20h.pdf';

insert into public.lesson_resources (
  lesson_id, kind, title, external_url, mime_type, size_bytes,
  downloadable, required, position
)
select
  lesson.id,
  'presentation'::public.resource_kind,
  'Presentación completa · Formación inicial de 20 horas',
  '/course-materials/arranque-20h/formacion-inicial-arranque-20h.pdf',
  'application/pdf', 16342681, true, false, 100
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where lesson.position = 1
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

-- Keep the existing assessment for this version unchanged.
do $$
declare
  target_version_count integer;
  published_segment_count integer;
  slide_count integer;
begin
  select count(*) into target_version_count
  from public.course_versions version
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20;

  select count(*) into published_segment_count
  from public.lesson_audio_segments segment
  join public.lessons lesson on lesson.id = segment.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20 and segment.published;

  select count(*) into slide_count
  from public.lesson_segment_slides slide
  join public.lesson_audio_segments segment on segment.id = slide.segment_id
  join public.lessons lesson on lesson.id = segment.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20;

  if target_version_count <> 1 then
    raise exception 'Expected one 20-hour arranque version; found: %', target_version_count;
  end if;
  if published_segment_count <> 50 then
    raise exception 'Expected 50 published chapters; found: %', published_segment_count;
  end if;
  if slide_count <> 100 then
    raise exception 'Expected 100 slides; found: %', slide_count;
  end if;
end $$;

commit;
