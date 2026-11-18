-- Corrige el curso de interior: ET 2002-1-08, grupos 5.3.c y 5.3.d.
-- Conserva el temario, las 80 diapositivas y 75 locuciones; sustituye solo 1, 2, 6, 9 y 79.
begin;

update public.courses set
  slug = 'operadores-interior-arranque-carga-perforacion-voladura',
  title = 'Operadores de arranque/carga y perforación/voladura en interior',
  short_description = 'Formación preventiva para operadores de arranque/carga y perforación/voladura; picador, barrenista y ayudante minero.',
  description = 'Curso presencial de 20 horas conforme a la ET 2002-1-08, grupos 5.3.c y 5.3.d de la ITC 02.1.02, con apoyo digital, explicaciones y evaluación por bloques.',
  specialty = 'ITC 02.1.02 · ET 2002-1-08 · Grupos 5.3.c y 5.3.d',
  cover_storage_path = '/images/curso-operadores-interior-portada.png',
  updated_at = now()
where id = 'b6586fbf-c8eb-515a-b82c-2c54cd9f4a5b'::uuid;

update public.course_versions set
  modality = 'in_person',
  objectives = '["Aplicar los controles preventivos de las operaciones de arranque, carga, perforación y voladura en interior", "Reconocer peligros del terreno, la atmósfera, la ventilación, los equipos, el transporte y las energías", "Aplicar criterios de parada, aislamiento, evacuación y reapertura", "Coordinar interferencias y conservar evidencias trazables"]'::jsonb,
  target_audience = '["Operadores de arranque/carga y operadores de perforación/voladura en actividades extractivas de interior", "Picadores, barrenistas y ayudantes mineros"]'::jsonb,
  requirements = '["Vinculación al puesto", "Asistencia a la impartición presencial", "Cumplimiento de las autorizaciones específicas que correspondan a cada función"]'::jsonb,
  accreditation_label = 'Formación preventiva presencial de 20 horas · ET 2002-1-08',
  accreditation_reference = 'ITC 02.1.02 · ET 2002-1-08 · Grupos 5.3.c y 5.3.d',
  updated_at = now()
where id = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'::uuid;

update public.course_materials set
  title = 'Manual del curso de operadores de interior',
  description = 'Manual completo de 39 páginas conforme a la ET 2002-1-08 para los grupos 5.3.c y 5.3.d.',
  storage_path = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11/materials/manual-operadores-interior-20h-et-2002-1-08-v1.1.pdf',
  file_name = 'manual-operadores-interior-20h-et-2002-1-08-v1.1.pdf',
  size_bytes = 932011,
  page_count = 39,
  is_published = true,
  updated_at = now()
where id = '9a9528a2-261f-5a13-b640-5a74c179cb54'::uuid;

update public.course_materials set
  title = 'Presentación del curso de operadores de interior',
  description = 'Presentación completa de 80 diapositivas. Pendiente de sustituir por la exportación corregida de Gamma.',
  is_published = false,
  updated_at = now()
where id = 'fa73e06b-97c3-5ef9-8e7b-2d5beb5113b4'::uuid;

update public.lesson_segment_slides s set
  source_label = 'Presentación InmínerCampus · Operadores de interior',
  updated_at = now()
where s.segment_id in (
  select a.id
  from public.lesson_audio_segments a
  join public.lessons l on l.id = a.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'::uuid
);

update public.lesson_segment_notes n set
  source_label = 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
  updated_at = now()
where n.segment_id in (
  select a.id
  from public.lesson_audio_segments a
  join public.lessons l on l.id = a.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'::uuid
);

update public.lesson_audio_segments set
  title = $t1$Identificación, destinatarios y alcance del curso$t1$,
  narration_text = $n1$En una explotación de interior, la prevención empieza por identificar con precisión quién realiza el trabajo y qué tareas desempeña realmente. Este curso está dirigido a operadores de arranque y carga, operadores de perforación y voladura, picadores, barrenistas y ayudantes mineros. Son los puestos incluidos en los grupos 5.3.c y 5.3.d de la ITC 02.1.02 y desarrollados por la Especificación Técnica 2002-1-08.

El programa tiene una duración mínima de veinte horas y debe llevarse siempre al terreno. No basta con conocer una regla de memoria. Cada contenido tiene que relacionarse con la labor concreta, el método de explotación, los equipos empleados, la ventilación, el sostenimiento, el transporte, las comunicaciones y las disposiciones internas de seguridad. También se aplica a trabajadores de empresas contratistas cuando desempeñan estos puestos en una explotación de interior.

Conviene dejar claro el alcance. Esta formación preventiva acredita los conocimientos exigidos para el puesto, pero no convierte al alumno en técnico titulado ni concede por sí sola autorizaciones distintas. Por ejemplo, no sustituye la autorización para actuar como artillero, el nombramiento de otras figuras de la organización minera ni la formación específica de un equipo determinado.

Pensemos en una entrada de turno. El operador recibe la indicación de comenzar el trabajo, pero observa que la ventilación secundaria está en una posición diferente y que hay agua acumulada junto al acceso. La respuesta correcta no es continuar porque la tarea sea habitual. Debe comparar la situación con las condiciones autorizadas, detener el inicio si falta una barrera y comunicar el cambio.

La idea principal es sencilla: identificar bien el puesto permite aplicar el itinerario correcto y evita asumir competencias que no corresponden.$n1$,
  duration_seconds = 112,
  audio_storage_path = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11/audio-et-2002-1-08/slide-001.mp3',
  updated_at = now()
where id = 'd03c6921-2fac-58c6-999f-2799e0c092a4'::uuid;

update public.lesson_segment_slides set
  title = $st1$Identificación, destinatarios y alcance del curso$st1$,
  body = $sb1$Objetivo: Formación preventiva para operadores de arranque y carga, operadores de perforación y voladura, picadores, barrenistas y ayudantes mineros en actividades extractivas de interior.

Idea clave: Puesto correcto, formación correcta$sb1$,
  source_label = 'Presentación InmínerCampus · Operadores de interior',
  alt_text = $sa1$Diapositiva 1: Identificación, destinatarios y alcance del curso$sa1$,
  image_storage_path = null,
  image_external_url = null,
  updated_at = now()
where id = 'fc99f059-d612-5ec7-be9a-f46e2f1dcb03'::uuid;

update public.lesson_segment_notes set
  summary = $e1$Objetivo

Formación preventiva para operadores de arranque y carga, operadores de perforación y voladura, picadores, barrenistas y ayudantes mineros en actividades extractivas de interior.

Explicación detallada

La ET 2002-1-08 desarrolla el itinerario preventivo de los grupos 5.3.c y 5.3.d de la ITC 02.1.02. El curso inicial tiene una duración mínima de 20 horas y debe adaptarse al puesto, a los equipos, al Documento sobre Seguridad y Salud, a las disposiciones internas de seguridad y a las condiciones reales de cada explotación. Incluye también al personal de empresas contratistas que desempeñe estos puestos. Esta formación acredita la formación preventiva del puesto, pero no sustituye autorizaciones específicas para funciones como artillero, ni el adiestramiento de cada equipo o procedimiento.

Aplicación práctica

Antes de entrar en una labor, el operador comprueba qué tarea va a realizar, qué equipo utilizará, qué riesgos pueden cambiar durante el turno y qué instrucciones gobiernan la operación. Si la realidad no coincide con lo previsto, no improvisa: mantiene el estado seguro y comunica la desviación.

Comprobación antes de continuar

Identifica la tarea, la zona, las condiciones de partida, la señal de pérdida de control y la persona responsable. Si falta un dato crítico, conserva el estado seguro, detén la tarea cuando corresponda y comunica la desviación.

Idea clave

Puesto correcto, formación correcta$e1$,
  key_points = array[$ko1$Formación preventiva para operadores de arranque y carga, operadores de perforación y voladura, picadores, barrenistas y ayudantes mineros en actividades extractivas de interior.$ko1$, $kk1$Puesto correcto, formación correcta$kk1$],
  stop_criterion = $sk1$Puesto correcto, formación correcta$sk1$,
  source_label = 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
  approved = true,
  updated_at = now()
where id = '225efe0a-a6dc-51d1-8c86-8164b0e6525d'::uuid;

update public.questions set
  prompt = $qp1$Respecto a «Identificación, destinatarios y alcance del curso», ¿qué criterio es correcto?$qp1$,
  explanation = $qe1$La ET 2002-1-08 se dirige a los grupos 5.3.c y 5.3.d —operadores de arranque/carga y perforación/voladura; picador, barrenista y ayudante minero— y no concede por sí sola autorizaciones distintas.$qe1$,
  updated_at = now()
where id = 'c4a4668d-cf48-5dab-95ae-e36ed63d1bc1'::uuid;

update public.question_options set
  option_text = $qo1$Puesto correcto, formación correcta: La ET 2002-1-08 se dirige a los grupos 5.3.c y 5.3.d —operadores de arranque/carga y perforación/voladura; picador, barrenista y ayudante minero— y no concede por sí sola autorizaciones distintas.$qo1$,
  updated_at = now()
where id = '286ffa47-a738-557a-a69d-37765b913be3'::uuid;

update public.lesson_audio_segments set
  title = $t2$ET 2002-1-08, duración y límites de la formación$t2$,
  narration_text = $n2$La referencia normativa de este curso es la Especificación Técnica 2002-1-08. Esta norma desarrolla la formación preventiva para los grupos 5.3.c y 5.3.d: operadores de arranque y carga y operadores de perforación y voladura en interior, incluyendo los puestos de picador, barrenista y ayudante minero.

La formación inicial tiene una duración mínima de veinte horas. La norma distribuye ese tiempo entre la definición de los trabajos, las técnicas preventivas específicas, los equipos y medios auxiliares, el control del lugar de trabajo, las interferencias y la normativa. No es una duración comercial elegida por la plataforma, sino el mínimo establecido para este itinerario.

La impartición reglamentaria es presencial. El campus puede servir como apoyo para estudiar, repasar, evaluar y conservar evidencias, pero no debe presentarse como sustituto de la impartición presencial ni de la práctica adaptada al centro de trabajo.

También hay que distinguir formación inicial y reciclaje. La ITC establece que la actualización o el reciclaje tendrá un mínimo de cinco horas. Para los puestos de esta especificación, la frecuencia máxima obligatoria es de dos años. Si cambian el puesto, el equipo, el procedimiento o los riesgos, la empresa no debe esperar automáticamente a que termine ese plazo: debe asegurar una formación suficiente y adecuada antes de exponer al trabajador a la nueva situación.

Un ejemplo sencillo: llega un certificado que identifica un grupo diferente o una especificación técnica ajena a estos puestos. Aunque parte del contenido pueda parecerse, no acredita este itinerario. La ficha correcta debe mencionar la ET 2002-1-08 y los grupos 5.3.c y 5.3.d.

La clave es comprobar siempre cuatro datos: puesto, referencia normativa, duración y fecha de renovación.$n2$,
  duration_seconds = 117,
  audio_storage_path = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11/audio-et-2002-1-08/slide-002.mp3',
  updated_at = now()
where id = 'd86aa9b6-a44f-5a01-9a0b-b0b6f4bd9a0b'::uuid;

update public.lesson_segment_slides set
  title = $st2$ET 2002-1-08, duración y límites de la formación$st2$,
  body = $sb2$Objetivo: Itinerario de los grupos 5.3.c y 5.3.d: formación inicial mínima de 20 horas, presencial, con reciclaje o actualización de al menos 5 horas y una frecuencia máxima obligatoria de 2 años.

Idea clave: 20 horas iniciales; reciclaje de 5 horas; máximo 2 años$sb2$,
  source_label = 'Presentación InmínerCampus · Operadores de interior',
  alt_text = $sa2$Diapositiva 2: ET 2002-1-08, duración y límites de la formación$sa2$,
  image_storage_path = null,
  image_external_url = null,
  updated_at = now()
where id = '5747dfaa-4de7-5326-9d18-a670d556a7c4'::uuid;

update public.lesson_segment_notes set
  summary = $e2$Objetivo

Itinerario de los grupos 5.3.c y 5.3.d: formación inicial mínima de 20 horas, presencial, con reciclaje o actualización de al menos 5 horas y una frecuencia máxima obligatoria de 2 años.

Explicación detallada

La Resolución de 7 de octubre de 2008 aprueba la ET 2002-1-08 y fija 20 horas para el curso inicial. La Orden ITC/1316/2008, modificada en 2011, establece que los cursos de reciclaje o actualización tendrán un mínimo de 5 horas. Para este itinerario concreto, la ET 2002-1-08 fija una frecuencia máxima obligatoria de 2 años. La formación reglamentaria es presencial y debe completarse con la información, instrucciones y adiestramiento propios de la empresa y del equipo utilizado.

Aplicación práctica

Antes de admitir una acreditación, se comprueban el puesto, la referencia ET 2002-1-08, la duración, la fecha, la entidad o empresa formadora y la adaptación al centro. Una ficha que identifique otro grupo u otra especificación técnica corresponde a un itinerario distinto y debe corregirse.

Comprobación antes de continuar

Identifica la tarea, la zona, las condiciones de partida, la señal de pérdida de control y la persona responsable. Si falta un dato crítico, conserva el estado seguro, detén la tarea cuando corresponda y comunica la desviación.

Idea clave

20 horas iniciales; reciclaje de 5 horas; máximo 2 años$e2$,
  key_points = array[$ko2$Itinerario de los grupos 5.3.c y 5.3.d: formación inicial mínima de 20 horas, presencial, con reciclaje o actualización de al menos 5 horas y una frecuencia máxima obligatoria de 2 años.$ko2$, $kk2$20 horas iniciales; reciclaje de 5 horas; máximo 2 años$kk2$],
  stop_criterion = $sk2$20 horas iniciales; reciclaje de 5 horas; máximo 2 años$sk2$,
  source_label = 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
  approved = true,
  updated_at = now()
where id = 'da707c66-4458-504b-9992-3072c4210e16'::uuid;

update public.questions set
  prompt = $qp2$Respecto a «ET 2002-1-08, duración y límites de la formación», ¿qué combinación es correcta?$qp2$,
  explanation = $qe2$Los grupos 5.3.c y 5.3.d tienen 20 horas de formación inicial presencial, reciclaje o actualización de al menos 5 horas y una frecuencia máxima obligatoria de 2 años.$qe2$,
  updated_at = now()
where id = '55a808e2-42aa-53ab-9929-fddfd8cf5a4c'::uuid;

update public.question_options set
  option_text = $qo2$20 horas iniciales; reciclaje de 5 horas; máximo 2 años: Los grupos 5.3.c y 5.3.d tienen 20 horas de formación inicial presencial, reciclaje o actualización de al menos 5 horas y una frecuencia máxima obligatoria de 2 años.$qo2$,
  updated_at = now()
where id = '58b18993-e2b6-5507-825b-468160d68fe8'::uuid;

update public.lesson_audio_segments set
  title = $t6$Estados no productivos que también generan riesgo$t6$,
  narration_text = $n6$Muchas incidencias ocurren cuando la producción está parada y alguien interpreta que el riesgo también se ha detenido. Sin embargo, una espera, una limpieza, un desatasco, una inspección, una prueba o una operación de mantenimiento tienen peligros propios.

Un equipo inmóvil puede conservar presión hidráulica o neumática, energía eléctrica, inercia, una carga suspendida o material capaz de desplazarse. En una labor de interior también pueden cambiar la ventilación, la atmósfera, el estado del terreno, el agua o las rutas de circulación mientras el trabajo está detenido. Por eso, parar la máquina no equivale a dejarla en condición segura.

Antes de intervenir, el operador debe identificar todas las fuentes de energía, aplicar el procedimiento de aislamiento y consignación, comprobar la ausencia de movimiento y delimitar la zona. Si intervienen varias personas, cada una debe saber quién controla el aislamiento y qué condiciones deben cumplirse antes de retirar un bloqueo.

Imaginemos una cinta detenida por un atasco. Una persona se acerca para retirar material mientras otra intenta una prueba desde un puesto distinto. Aunque ambas crean estar resolviendo el problema, la falta de coordinación puede provocar un arranque inesperado. La medida correcta es mantener una única entrega de la instalación, controlar todas las energías y comunicar de forma clara cuándo puede hacerse la prueba.

Lo mismo ocurre después de una parada de ventilación, una voladura, una avería o una incidencia. Antes de recuperar la actividad hay que volver a medir, inspeccionar y verificar las barreras necesarias. No se reabre porque haya pasado tiempo, sino porque existe evidencia de que la condición vuelve a ser segura.

La regla práctica es esta: una pausa cambia el estado del sistema y obliga a comprobarlo de nuevo.$n6$,
  duration_seconds = 107,
  audio_storage_path = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11/audio-et-2002-1-08/slide-006.mp3',
  updated_at = now()
where id = '548a36a8-d8e0-5a49-8269-e5d36fe17738'::uuid;

update public.lesson_segment_slides set
  title = $st6$Estados no productivos que también generan riesgo$st6$,
  body = $sb6$Objetivo: Espera, limpieza, desatasco, inspección, prueba y mantenimiento tienen peligros propios. Una parada de ventilación, un cambio de turno o la recuperación tras una incidencia obligan a volver a verificar las condiciones.

Idea clave: Parar la producción no elimina el peligro$sb6$,
  source_label = 'Presentación InmínerCampus · Operadores de interior',
  alt_text = $sa6$Diapositiva 6: Estados no productivos que también generan riesgo$sa6$,
  image_storage_path = null,
  image_external_url = null,
  updated_at = now()
where id = 'e4ecec27-2ca5-52ac-bc54-1db1735fbe5f'::uuid;

update public.lesson_segment_notes set
  summary = $e6$Objetivo

Espera, limpieza, desatasco, inspección, prueba y mantenimiento tienen peligros propios. Una parada de ventilación, un cambio de turno o la recuperación tras una incidencia obligan a volver a verificar las condiciones.

Explicación detallada

La ET 2002-1-08 exige formar sobre las tareas reales y sus medidas preventivas. El peligro no desaparece cuando se detiene la producción: pueden permanecer presiones hidráulicas, energía eléctrica, material suspendido, equipos con posibilidad de movimiento, atmósferas deficientes o terreno sin sanear. Antes de intervenir se aplica el procedimiento previsto, se aíslan las energías, se delimita la zona y se comprueba que la condición segura es efectiva. La reanudación exige una verificación nueva, no una simple orden verbal.

Aplicación práctica

Durante una espera, una máquina queda detenida con presión acumulada y material atrapado. Retirar el atasco sin consignar convierte una pausa productiva en una intervención peligrosa. La tarea solo continúa cuando las energías están controladas y la zona se entrega de forma inequívoca.

Comprobación antes de continuar

Identifica la tarea, la zona, las condiciones de partida, la señal de pérdida de control y la persona responsable. Si falta un dato crítico, conserva el estado seguro, detén la tarea cuando corresponda y comunica la desviación.

Idea clave

Parar la producción no elimina el peligro$e6$,
  key_points = array[$ko6$Espera, limpieza, desatasco, inspección, prueba y mantenimiento tienen peligros propios. Una parada de ventilación, un cambio de turno o la recuperación tras una incidencia obligan a volver a verificar las condiciones.$ko6$, $kk6$Parar la producción no elimina el peligro$kk6$],
  stop_criterion = $sk6$Parar la producción no elimina el peligro$sk6$,
  source_label = 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
  approved = true,
  updated_at = now()
where id = '1dd50283-4f06-5b00-bb3f-ca4be06f8eb3'::uuid;

update public.questions set
  prompt = $qp6$Respecto a «Estados no productivos que también generan riesgo», ¿qué criterio es correcto?$qp6$,
  explanation = $qe6$Antes de limpiar, desatascar, inspeccionar, probar o mantener se controlan las energías y, antes de reanudar, se verifican de nuevo las condiciones.$qe6$,
  updated_at = now()
where id = '41642c33-67e7-5c1d-a89c-21e409de129f'::uuid;

update public.question_options set
  option_text = $qo6$Parar la producción no elimina el peligro: Antes de limpiar, desatascar, inspeccionar, probar o mantener se controlan las energías y, antes de reanudar, se verifican de nuevo las condiciones.$qo6$,
  updated_at = now()
where id = 'c5f49b26-6260-5b83-b251-312b59704115'::uuid;

update public.lesson_audio_segments set
  title = $t9$Funciones del puesto, responsabilidades y límites de actuación$t9$,
  narration_text = $n9$Trabajar con seguridad exige saber qué corresponde hacer, qué debe comunicarse y qué decisiones requieren una autorización diferente. En una explotación de interior intervienen la dirección facultativa, los vigilantes, los operadores, el personal de mantenimiento, los artilleros y otras figuras. Sus responsabilidades están relacionadas, pero no son intercambiables.

El operador debe ejecutar las tareas para las que ha recibido formación y autorización, inspeccionar su zona y su equipo antes de comenzar, respetar las disposiciones internas de seguridad y aplicar los criterios de parada. Si detecta una desviación, su responsabilidad no es buscar una solución improvisada para mantener la producción. Debe conservar el estado seguro, avisar por el canal previsto y aportar información concreta: lugar, hora, condición observada, personas afectadas y medida adoptada.

Esta formación no convierte al alumno en técnico titulado ni concede automáticamente funciones de vigilante, artillero, rescatista o responsable de mantenimiento. Tampoco autoriza a modificar por cuenta propia una secuencia de voladura, un sostenimiento, un sistema de ventilación o un aislamiento. Cuando la decisión supera su competencia, se eleva a la persona que tenga la autoridad y el conocimiento necesarios.

Pensemos en un relevo. El turno saliente sabe que un frente tiene una limitación temporal, pero la transmite solo de palabra. El entrante podría interpretar que la zona está disponible. La actuación correcta es dejar la condición identificada, mantener la restricción, comprobar que la información ha sido comprendida y definir quién puede autorizar la reapertura.

La capacidad de parar ante una condición insegura forma parte del trabajo responsable. Parar no significa asumir una función ajena; significa evitar que una desviación se convierta en accidente y facilitar que la decisión llegue a quien corresponda.$n9$,
  duration_seconds = 111,
  audio_storage_path = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11/audio-et-2002-1-08/slide-009.mp3',
  updated_at = now()
where id = '785abfe5-ce90-53a3-8564-5ed8eb9da223'::uuid;

update public.lesson_segment_slides set
  title = $st9$Funciones del puesto, responsabilidades y límites de actuación$st9$,
  body = $sb9$Objetivo: El operador ejecuta las tareas para las que está formado y autorizado, inspecciona su zona y su equipo, aplica los criterios de parada y comunica desviaciones. No asume funciones o autorizaciones diferentes por haber realizado este curso.

Idea clave: Actuar dentro de la formación y autorización recibidas$sb9$,
  source_label = 'Presentación InmínerCampus · Operadores de interior',
  alt_text = $sa9$Diapositiva 9: Funciones del puesto, responsabilidades y límites de actuación$sa9$,
  image_storage_path = null,
  image_external_url = null,
  updated_at = now()
where id = 'c0de7882-b212-5ecb-85a7-0edc7d7ce34e'::uuid;

update public.lesson_segment_notes set
  summary = $e9$Objetivo

El operador ejecuta las tareas para las que está formado y autorizado, inspecciona su zona y su equipo, aplica los criterios de parada y comunica desviaciones. No asume funciones o autorizaciones diferentes por haber realizado este curso.

Explicación detallada

En la explotación participan el empresario, la dirección facultativa, vigilantes, operadores, personal de mantenimiento, artilleros y otras figuras con funciones distintas. El trabajador debe conocer la cadena de mando y los límites de su autorización. Puede y debe detener o no iniciar una tarea cuando falte una condición crítica, pero no modifica por su cuenta un procedimiento, un sostenimiento, una ventilación, una secuencia de voladura o un aislamiento. La formación de la ET 2002-1-08 no sustituye la autorización específica que exijan determinadas funciones.

Aplicación práctica

El turno saliente comunica una limitación temporal en un frente. El operador entrante la confirma, la mantiene señalizada y no reabre hasta que la persona competente verifique la condición y quede registrada la entrega.

Comprobación antes de continuar

Identifica la tarea, la zona, las condiciones de partida, la señal de pérdida de control y la persona responsable. Si falta un dato crítico, conserva el estado seguro, detén la tarea cuando corresponda y comunica la desviación.

Idea clave

Actuar dentro de la formación y autorización recibidas$e9$,
  key_points = array[$ko9$El operador ejecuta las tareas para las que está formado y autorizado, inspecciona su zona y su equipo, aplica los criterios de parada y comunica desviaciones. No asume funciones o autorizaciones diferentes por haber realizado este curso.$ko9$, $kk9$Actuar dentro de la formación y autorización recibidas$kk9$],
  stop_criterion = $sk9$Actuar dentro de la formación y autorización recibidas$sk9$,
  source_label = 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
  approved = true,
  updated_at = now()
where id = '58995a3e-61ab-5ca5-a5ea-2a522c95c301'::uuid;

update public.questions set
  prompt = $qp9$Respecto a «Funciones del puesto, responsabilidades y límites de actuación», ¿qué criterio es correcto?$qp9$,
  explanation = $qe9$El operador inspecciona, aplica criterios de parada y comunica desviaciones, pero el curso no le concede automáticamente funciones o autorizaciones diferentes.$qe9$,
  updated_at = now()
where id = '38651d3c-ce41-59e3-aea9-85994248cc6e'::uuid;

update public.question_options set
  option_text = $qo9$Actuar dentro de la formación y autorización recibidas: El operador inspecciona, aplica criterios de parada y comunica desviaciones, pero el curso no le concede automáticamente funciones o autorizaciones diferentes.$qo9$,
  updated_at = now()
where id = 'f5d07f92-e1ac-5126-9f4d-821ec56dc44a'::uuid;

update public.lesson_audio_segments set
  title = $t79$Alcance de la ET 2002-1-08 y evidencias documentales$t79$,
  narration_text = $n79$Una formación solo puede verificarse si la evidencia documental identifica con claridad qué se ha impartido, a quién, para qué puesto y en qué fecha. En este curso, la referencia correcta es la ET 2002-1-08 y los grupos 5.3.c y 5.3.d. El certificado debe relacionarse con los puestos de operador de arranque y carga, operador de perforación y voladura, picador, barrenista o ayudante minero, según corresponda.

La acreditación debe incluir, como mínimo, los datos de la persona trabajadora, la duración, las fechas, la empresa o entidad que imparte o certifica y la identificación suficiente del equipo formador. También debe quedar constancia del resultado de la evaluación y de la adaptación del contenido al puesto y al centro de trabajo.

La ITC exige que la formación se anote y certifique en la cartilla profesional del trabajador. Además, la empresa debe mantener al día el libro de registro de los cursos y conservar la información relevante dentro de la documentación preventiva, incluido el capítulo correspondiente del Documento sobre Seguridad y Salud.

Hay dos plazos que no deben confundirse. El curso inicial tiene una duración mínima de veinte horas. Los cursos de actualización o reciclaje tienen una duración mínima de cinco horas. Para este itinerario, la frecuencia máxima obligatoria es de dos años, sin perjuicio de formar antes cuando cambien el puesto, el procedimiento, el equipo o los riesgos.

Imagine un certificado que solo dice formación minera de interior y no indica la ET, el grupo ni el puesto. Ese documento no permite comprobar por sí solo que la persona haya realizado el itinerario correcto. Antes de asignar la tarea, la empresa debe aclarar la equivalencia o completar la formación que falte.

La idea final es simple: el contenido debe ser correcto, y la evidencia debe permitir demostrarlo sin ambigüedades.$n79$,
  duration_seconds = 114,
  audio_storage_path = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11/audio-et-2002-1-08/slide-079.mp3',
  updated_at = now()
where id = '6a8ae087-a744-5845-8eaa-72161e335e94'::uuid;

update public.lesson_segment_slides set
  title = $st79$Alcance de la ET 2002-1-08 y evidencias documentales$st79$,
  body = $sb79$Objetivo: La acreditación debe identificar la ET 2002-1-08, los grupos 5.3.c y 5.3.d, el puesto, la duración, las fechas, la persona trabajadora, el equipo formador y la empresa o entidad que certifica la formación.

Idea clave: Formación correcta y evidencia trazable$sb79$,
  source_label = 'Presentación InmínerCampus · Operadores de interior',
  alt_text = $sa79$Diapositiva 79: Alcance de la ET 2002-1-08 y evidencias documentales$sa79$,
  image_storage_path = null,
  image_external_url = null,
  updated_at = now()
where id = 'a0eec77c-e60f-5b80-b44b-55bef4e5c8c6'::uuid;

update public.lesson_segment_notes set
  summary = $e79$Objetivo

La acreditación debe identificar la ET 2002-1-08, los grupos 5.3.c y 5.3.d, el puesto, la duración, las fechas, la persona trabajadora, el equipo formador y la empresa o entidad que certifica la formación.

Explicación detallada

La formación superada se acredita documentalmente y se anota en la cartilla de formación profesional del trabajador. La empresa mantiene actualizado el libro de registro de cursos y conserva en el Documento sobre Seguridad y Salud la información relevante: asistentes, puestos, materiales, docentes, fechas y resultados. El curso inicial es de 20 horas; la actualización o reciclaje es de al menos 5 horas y, para este itinerario, la frecuencia máxima obligatoria es de 2 años. La evidencia debe ser trazable y corresponder al puesto real.

Aplicación práctica

Antes de asignar el puesto se revisa que el certificado no se limite a una denominación genérica. Si faltan la ET, el grupo, el puesto o la fecha, la empresa completa la comprobación antes de considerar acreditado el itinerario.

Comprobación antes de continuar

Identifica la tarea, la zona, las condiciones de partida, la señal de pérdida de control y la persona responsable. Si falta un dato crítico, conserva el estado seguro, detén la tarea cuando corresponda y comunica la desviación.

Idea clave

Formación correcta y evidencia trazable$e79$,
  key_points = array[$ko79$La acreditación debe identificar la ET 2002-1-08, los grupos 5.3.c y 5.3.d, el puesto, la duración, las fechas, la persona trabajadora, el equipo formador y la empresa o entidad que certifica la formación.$ko79$, $kk79$Formación correcta y evidencia trazable$kk79$],
  stop_criterion = $sk79$Formación correcta y evidencia trazable$sk79$,
  source_label = 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
  approved = true,
  updated_at = now()
where id = '9463d6d1-300a-591d-9f4b-a9fb00be0d03'::uuid;

update public.questions set
  prompt = $qp79$Respecto a «Alcance de la ET 2002-1-08 y evidencias documentales», ¿qué criterio es correcto?$qp79$,
  explanation = $qe79$La evidencia debe identificar la ET 2002-1-08, los grupos 5.3.c y 5.3.d, las 20 horas iniciales, el reciclaje mínimo de 5 horas, la frecuencia máxima de 2 años y el registro completo del curso.$qe79$,
  updated_at = now()
where id = '90a08272-14f3-57bb-bce8-98f8525889e1'::uuid;

update public.question_options set
  option_text = $qo79$Formación correcta y evidencia trazable: La evidencia debe identificar la ET 2002-1-08, los grupos 5.3.c y 5.3.d, las 20 horas iniciales, el reciclaje mínimo de 5 horas, la frecuencia máxima de 2 años y el registro completo del curso.$qo79$,
  updated_at = now()
where id = '7bb0962e-6ff6-5a68-b50d-a8260725d2c0'::uuid;

commit;
