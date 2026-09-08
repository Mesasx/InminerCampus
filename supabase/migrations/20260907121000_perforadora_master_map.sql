begin;

update public.courses
set title = 'Operador de perforadora / perforista',
    short_description = 'Formación preventiva para operadores de perforadora en actividades extractivas de exterior.',
    description = 'Curso estructurado en 5 bloques y 50 unidades conforme a la ITC 02.1.02 y la ET 2003-1-10. El manual maestro desarrolla el oficio, la preparación, la operación segura, los riesgos y la cultura preventiva.'
where slug = 'operadores-perforacion-corte-exterior';

with block_map(block_position, title) as (
  values
    (1, 'El oficio de perforista y los fundamentos de la perforación'),
    (2, 'Preparación del trabajo, inspección y acondicionamiento'),
    (3, 'Operación segura y control del proceso de perforación'),
    (4, 'Riesgos higiénicos, mecánicos e interferencias críticas'),
    (5, 'Sistemas de seguridad, mantenimiento y cultura preventiva')
)
update public.course_modules module
set title = block_map.title,
    description = block_map.title
from block_map
join public.course_versions version on true
join public.courses course on course.id = version.course_id
where module.course_version_id = version.id
  and course.slug = 'operadores-perforacion-corte-exterior'
  and module.position = block_map.block_position;

with block_map(block_position, title) as (
  values
    (1, 'El oficio de perforista y los fundamentos de la perforación'),
    (2, 'Preparación del trabajo, inspección y acondicionamiento'),
    (3, 'Operación segura y control del proceso de perforación'),
    (4, 'Riesgos higiénicos, mecánicos e interferencias críticas'),
    (5, 'Sistemas de seguridad, mantenimiento y cultura preventiva')
)
update public.lessons lesson
set title = block_map.title,
    summary = 'Diez unidades secuenciales del bloque ' || block_map.block_position || '.'
from public.course_modules module
join block_map on block_map.block_position = module.position
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where lesson.module_id = module.id
  and course.slug = 'operadores-perforacion-corte-exterior';

with unit_map(block_position, unit_position, lesson_code, title, source_pages) as (
  values
    (1,1,'1.1','Función del perforista en una explotación minera','5–6'),
    (1,2,'1.2','La perforación dentro del ciclo de arranque','7'),
    (1,3,'1.3','Tipos de maquinaria de perforación','8–9'),
    (1,4,'1.4','Sistemas de perforación: martillo en cabeza y martillo en fondo','9–10'),
    (1,5,'1.5','Sarta de perforación: varillaje, manguitos y broca','11'),
    (1,6,'1.6','Geometría del barreno: diámetro, profundidad e inclinación','12–13'),
    (1,7,'1.7','Perforación desde la plataforma superior del banco','13–14'),
    (1,8,'1.8','Perforación en la base del banco','15'),
    (1,9,'1.9','Taqueo y fragmentación secundaria','16–17'),
    (1,10,'1.10','Detritus y estériles generados durante la perforación','17–18'),
    (2,1,'2.1','Reconocimiento del terreno antes de perforar','19–20'),
    (2,2,'2.2','Emplazamiento y nivelación de la perforadora','21'),
    (2,3,'2.3','Revisión perimetral y checklist previo','22–23'),
    (2,4,'2.4','Acceso seguro al puesto de mando','23–24'),
    (2,5,'2.5','Comprobación de sistemas eléctricos, hidráulicos y neumáticos','25'),
    (2,6,'2.6','Control de fluidos, mangueras y fugas','26–27'),
    (2,7,'2.7','Estado y cambio de herramientas de perforación','27–28'),
    (2,8,'2.8','Sistemas de control del polvo en perforación','29'),
    (2,9,'2.9','Equipos de protección individual del perforista','30–31'),
    (2,10,'2.10','Balizamiento y zona de exclusión alrededor de la máquina','31–32'),
    (3,1,'3.1','Preparación y posicionamiento sobre el punto de perforación','33–34'),
    (3,2,'3.2','Puesta en marcha de los equipos de perforación','35'),
    (3,3,'3.3','Rotación, percusión, empuje y barrido','36–37'),
    (3,4,'3.4','Alineación, orientación y control de desviaciones','37–38'),
    (3,5,'3.5','Manejo y cambio seguro del varillaje','39'),
    (3,6,'3.6','Avance y limpieza continua del barreno','40'),
    (3,7,'3.7','Manipulación segura de circuitos a presión','41–42'),
    (3,8,'3.8','Atranques y resolución segura de problemas','42–43'),
    (3,9,'3.9','Finalización del barreno y retirada de la sarta','43–44'),
    (3,10,'3.10','Parada, limpieza y estacionamiento al final del turno','45'),
    (4,1,'4.1','Riesgo de polvo y sílice cristalina respirable','47'),
    (4,2,'4.2','Exposición al ruido durante la perforación','48'),
    (4,3,'4.3','Vibraciones transmitidas al operador y al equipo','49–50'),
    (4,4,'4.4','Proyecciones y contacto con partes móviles','50–51'),
    (4,5,'4.5','Caídas y vuelco cerca de bordes de banco','52'),
    (4,6,'4.6','Interferencias con líneas eléctricas aéreas','53–54'),
    (4,7,'4.7','Interferencias con maquinaria móvil','54–55'),
    (4,8,'4.8','Coordinación con trabajos de voladura y artilleros','56'),
    (4,9,'4.9','Barrenos fallidos y zonas con posible explosivo','57–58'),
    (4,10,'4.10','Primeros auxilios, emergencia y evacuación','58–59'),
    (5,1,'5.1','Bloqueos y dispositivos de seguridad de la perforadora','60–61'),
    (5,2,'5.2','Control de presión y temperatura','62'),
    (5,3,'5.3','Alarmas, avisos e indicadores del equipo','63–64'),
    (5,4,'5.4','Iluminación, señalización y visibilidad','64–65'),
    (5,5,'5.5','Manual del fabricante y límites de uso','65–66'),
    (5,6,'5.6','Mantenimiento de primer nivel y aislamiento de energías','67'),
    (5,7,'5.7','Peligros residuales descritos por el fabricante','68–69'),
    (5,8,'5.8','Comunicación segura y trabajos simultáneos','69–70'),
    (5,9,'5.9','Derechos, obligaciones e instrucciones internas de seguridad','71'),
    (5,10,'5.10','Reciclaje, actualización y cultura preventiva','72–73')
)
update public.lesson_audio_segments segment
set lesson_code = unit_map.lesson_code,
    manual_chapter = 'Capítulo ' || unit_map.lesson_code,
    title = unit_map.title
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join unit_map on unit_map.block_position = module.position
where segment.lesson_id = lesson.id
  and course.slug = 'operadores-perforacion-corte-exterior'
  and unit_map.unit_position = segment.position;

with unit_map(block_position, unit_position, lesson_code, title, source_pages) as (
  values
    (1,1,'1.1','Función del perforista en una explotación minera','5–6'),(1,2,'1.2','La perforación dentro del ciclo de arranque','7'),(1,3,'1.3','Tipos de maquinaria de perforación','8–9'),(1,4,'1.4','Sistemas de perforación: martillo en cabeza y martillo en fondo','9–10'),(1,5,'1.5','Sarta de perforación: varillaje, manguitos y broca','11'),(1,6,'1.6','Geometría del barreno: diámetro, profundidad e inclinación','12–13'),(1,7,'1.7','Perforación desde la plataforma superior del banco','13–14'),(1,8,'1.8','Perforación en la base del banco','15'),(1,9,'1.9','Taqueo y fragmentación secundaria','16–17'),(1,10,'1.10','Detritus y estériles generados durante la perforación','17–18'),
    (2,1,'2.1','Reconocimiento del terreno antes de perforar','19–20'),(2,2,'2.2','Emplazamiento y nivelación de la perforadora','21'),(2,3,'2.3','Revisión perimetral y checklist previo','22–23'),(2,4,'2.4','Acceso seguro al puesto de mando','23–24'),(2,5,'2.5','Comprobación de sistemas eléctricos, hidráulicos y neumáticos','25'),(2,6,'2.6','Control de fluidos, mangueras y fugas','26–27'),(2,7,'2.7','Estado y cambio de herramientas de perforación','27–28'),(2,8,'2.8','Sistemas de control del polvo en perforación','29'),(2,9,'2.9','Equipos de protección individual del perforista','30–31'),(2,10,'2.10','Balizamiento y zona de exclusión alrededor de la máquina','31–32'),
    (3,1,'3.1','Preparación y posicionamiento sobre el punto de perforación','33–34'),(3,2,'3.2','Puesta en marcha de los equipos de perforación','35'),(3,3,'3.3','Rotación, percusión, empuje y barrido','36–37'),(3,4,'3.4','Alineación, orientación y control de desviaciones','37–38'),(3,5,'3.5','Manejo y cambio seguro del varillaje','39'),(3,6,'3.6','Avance y limpieza continua del barreno','40'),(3,7,'3.7','Manipulación segura de circuitos a presión','41–42'),(3,8,'3.8','Atranques y resolución segura de problemas','42–43'),(3,9,'3.9','Finalización del barreno y retirada de la sarta','43–44'),(3,10,'3.10','Parada, limpieza y estacionamiento al final del turno','45'),
    (4,1,'4.1','Riesgo de polvo y sílice cristalina respirable','47'),(4,2,'4.2','Exposición al ruido durante la perforación','48'),(4,3,'4.3','Vibraciones transmitidas al operador y al equipo','49–50'),(4,4,'4.4','Proyecciones y contacto con partes móviles','50–51'),(4,5,'4.5','Caídas y vuelco cerca de bordes de banco','52'),(4,6,'4.6','Interferencias con líneas eléctricas aéreas','53–54'),(4,7,'4.7','Interferencias con maquinaria móvil','54–55'),(4,8,'4.8','Coordinación con trabajos de voladura y artilleros','56'),(4,9,'4.9','Barrenos fallidos y zonas con posible explosivo','57–58'),(4,10,'4.10','Primeros auxilios, emergencia y evacuación','58–59'),
    (5,1,'5.1','Bloqueos y dispositivos de seguridad de la perforadora','60–61'),(5,2,'5.2','Control de presión y temperatura','62'),(5,3,'5.3','Alarmas, avisos e indicadores del equipo','63–64'),(5,4,'5.4','Iluminación, señalización y visibilidad','64–65'),(5,5,'5.5','Manual del fabricante y límites de uso','65–66'),(5,6,'5.6','Mantenimiento de primer nivel y aislamiento de energías','67'),(5,7,'5.7','Peligros residuales descritos por el fabricante','68–69'),(5,8,'5.8','Comunicación segura y trabajos simultáneos','69–70'),(5,9,'5.9','Derechos, obligaciones e instrucciones internas de seguridad','71'),(5,10,'5.10','Reciclaje, actualización y cultura preventiva','72–73')
)
update public.lesson_segment_slides slide
set title = unit_map.title,
    source_label = 'Manual_Operador_Perforadora_Inminer_Campus.pdf',
    source_page = unit_map.source_pages,
    alt_text = 'Diapositiva de la unidad ' || unit_map.lesson_code || ': ' || unit_map.title
from public.lesson_audio_segments segment
join public.lessons lesson on lesson.id = segment.lesson_id
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join unit_map on unit_map.block_position = module.position
  and unit_map.unit_position = segment.position
where slide.segment_id = segment.id
  and course.slug = 'operadores-perforacion-corte-exterior';

commit;
