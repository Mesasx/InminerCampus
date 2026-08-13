-- Explicaciones detalladas aportadas para las partes 1.1 a 1.10 del Curso 4.

create temporary table _course4_block1_details (
  part_position integer primary key,
  title text not null,
  body text not null,
  pdf_page integer not null,
  manual_pages text not null
) on commit drop;

insert into _course4_block1_details (
  part_position, title, body, pdf_page, manual_pages
)
values
  (1, 'Objeto de la formación y ámbito de aplicación', $detail$
Objetivo
Comprender que la formación preventiva no se limita al manejo de los mandos: prepara al operador para reconocer peligros, interpretar el entorno y aplicar las reglas de la explotación.

Explicación detallada
La formación del operador de maquinaria de arranque, carga y viales responde a un puesto con capacidad para generar consecuencias graves: vuelcos, atropellos, atrapamientos, caída de materiales, colisiones y exposición a energías hidráulicas o mecánicas. La experiencia práctica ayuda, pero no sustituye el conocimiento preventivo específico. Dos máquinas parecidas pueden presentar mandos, alarmas, capacidades, radios de giro y procedimientos de emergencia diferentes.
El ámbito comprende, de manera particular, a operadores de pala cargadora, excavadora hidráulica de cadenas y tractor de cadenas que trabajan en actividades extractivas de exterior. También alcanza a trabajadores de empresas contratistas y subcontratistas. La pertenencia a una empresa externa no reduce las obligaciones: exige coordinación, autorización y conocimiento de las condiciones particulares del centro minero.
El operador debe integrar cuatro fuentes de instrucciones: la formación recibida, el manual del fabricante, las disposiciones internas de seguridad de la explotación y la orden o procedimiento concreto de trabajo. Si existen contradicciones o el escenario real no coincide con el previsto, no se debe improvisar. La maniobra se detiene, la máquina se deja en condición segura y la desviación se comunica.

Aplicación práctica
Un operador con años de experiencia llega a una explotación nueva. Antes de trabajar debe conocer la circulación interna, prioridades, límites de velocidad, señales, zonas restringidas, sistema de comunicaciones, procedimiento de repostaje, actuación ante averías y plan de emergencia. La familiaridad con la máquina no equivale a conocer el centro.

Riesgos y errores que deben evitarse
- Confundir habilidad operativa con competencia preventiva.
- Empezar sin autorización o sin conocer las DIS.
- Aplicar hábitos adquiridos en otra explotación con condiciones diferentes.

Idea clave
La autorización para operar exige formación específica, conocimiento del equipo concreto y adaptación a la organización real de la explotación.
$detail$, 3, 'prólogo y pp. 5–6'),
  (2, 'Fases del movimiento de tierras', $detail$
Objetivo
Reconocer el movimiento de tierras como un sistema compuesto por fases interdependientes y no como una suma de maniobras aisladas.

Explicación detallada
El ciclo básico está formado por arranque, carga, transporte y descarga. Según el objetivo del trabajo, puede completarse con extendido, nivelación, compactación y refino. El arranque transforma el material natural en material susceptible de manipulación; la carga lo transfiere al equipo de transporte; el transporte lo desplaza y la descarga lo deposita en tolva, acopio, escombrera u otra zona definida.
Cada fase condiciona las siguientes. Un material mal fragmentado dificulta la carga y puede producir impactos, derrames o bloques sobredimensionados. Una carga descentrada modifica la estabilidad del vehículo. Una pista con baches, roderas o pendiente transversal aumenta las oscilaciones y el riesgo de pérdida de control. Una descarga sobre suelo inestable puede provocar el hundimiento del terreno o el vuelco.
La planificación debe considerar material, equipos, capacidad de producción, recorrido, cruces, pendientes, visibilidad, punto de descarga, condiciones meteorológicas e interferencias. El objetivo preventivo es que el ciclo mantenga continuidad sin obligar a los operadores a corregir de forma apresurada errores generados en fases anteriores.

Aplicación práctica
Antes de comenzar, el operador recorre mentalmente el ciclo: dónde atacará el material, cómo saldrá cargado, qué vehículos pueden cruzarse, dónde debe reducir velocidad, quién controla la descarga y qué hará si encuentra la zona ocupada o el terreno cambia.

Riesgos y errores que deben evitarse
- Analizar únicamente la maniobra propia.
- No comunicar defectos de pistas o puntos de descarga.
- Intentar compensar un ciclo mal diseñado aumentando la velocidad.

Idea clave
La seguridad de una fase depende de cómo se ejecutaron las anteriores y de cómo queda preparado el trabajo para la siguiente máquina.
$detail$, 4, 'pp. 7–15'),
  (3, 'Arranque del material y elección del método', $detail$
Objetivo
Seleccionar el método de arranque a partir de las propiedades del material, las capacidades del equipo y las condiciones del frente.

Explicación detallada
Arrancar es separar el material de su estado natural para dejarlo en condiciones de carga y transporte. La elección técnica depende de la dureza, fracturación, abrasividad, humedad, cohesión, pendiente, geometría del frente y volumen previsto. No existe un método universal: forzar una máquina fuera de su campo de aplicación reduce el rendimiento y aumenta las solicitaciones estructurales y los riesgos.
La roca competente puede requerir perforación y voladura diseñadas y ejecutadas por personal autorizado. En materiales ripables puede emplearse un tractor de cadenas con escarificador. Una excavadora puede realizar arranque mecánico con cuchara, diente ripper o martillo hidráulico, siempre que el equipo esté previsto por el fabricante y las condiciones del terreno permitan trabajar con estabilidad.
El operador observa continuamente la respuesta del material y de la máquina. Vibraciones anormales, ruidos, movimientos inesperados, pérdida de apoyo, grietas, bloques sueltos o desprendimientos son señales para detener el ciclo. El operador no modifica unilateralmente el método, la presión de trabajo o el accesorio con el fin de mantener la producción.

Aplicación práctica
Si un frente que parecía ripable presenta una capa competente y la máquina comienza a rebotar, no se aumenta la agresividad ni se ataca desde una posición inestable. Se retira el equipo a una zona segura, se señaliza si procede y se solicita una reevaluación.

Riesgos y errores que deben evitarse
- Superar las capacidades o limitaciones del fabricante.
- Trabajar bajo bloques o taludes inestables.
- Cambiar el método o accesorio sin autorización y comprobaciones.

Idea clave
El método correcto es el que permite arrancar el material sin sobrepasar la capacidad del equipo ni comprometer la estabilidad del frente o de la máquina.
$detail$, 5, 'pp. 7–15'),
  (4, 'Pala cargadora: definición y funciones', $detail$
Objetivo
Entender la configuración de la pala cargadora, su ciclo de trabajo y los riesgos derivados de la articulación, la carga elevada y la visibilidad.

Explicación detallada
La pala cargadora es una máquina autopropulsada, normalmente sobre ruedas, cuyo equipo frontal se llena mediante el avance de la propia máquina. Su ciclo habitual incluye aproximación, penetración en el material, llenado, retroceso, traslado corto y descarga. Puede cargar volquetes, alimentar tolvas, formar acopios, limpiar superficies o manipular cargas con accesorios expresamente autorizados.
Al penetrar en el acopio deben mantenerse los bastidores alineados para aprovechar la tracción y reducir esfuerzos laterales. El cucharón debe llenarse de forma uniforme, evitando sobrecargas y derrames. Durante el desplazamiento se mantiene lo más bajo posible, porque elevarlo desplaza el centro de gravedad hacia arriba y hacia delante, reduce la estabilidad y empeora la visibilidad inmediata.
La articulación central proporciona maniobrabilidad, pero forma una zona de atrapamiento que puede cerrarse al girar la dirección. Nadie debe permanecer en ella sin inmovilización y bloqueo conforme al procedimiento. Los neumáticos son especialmente vulnerables a cortes provocados por piedras derramadas, por lo que el estado y la limpieza de la zona de carga influyen directamente en la seguridad.

Aplicación práctica
Para cargar un volquete, el operador entra recto al acopio, obtiene un llenado controlado, retrocede observando el entorno, transporta con el cucharón bajo y se aproxima al vehículo sin elevarlo antes de lo necesario.

Riesgos y errores que deben evitarse
- Circular o girar con el cucharón elevado.
- Permanecer en la articulación sin bloqueo.
- Sobrecargar y dejar caer piedras en la zona de circulación.

Idea clave
La estabilidad de la pala depende de mantener la carga baja, adaptar la velocidad y controlar la articulación y el estado del terreno.
$detail$, 6, 'pp. 19–24'),
  (5, 'Excavadora hidráulica de cadenas: definición y funciones', $detail$
Objetivo
Comprender la forma de trabajo de la excavadora y las condiciones necesarias para mantener la estabilidad y controlar el radio de giro.

Explicación detallada
La excavadora hidráulica de cadenas dispone de una superestructura que normalmente puede girar 360 grados sobre un tren de rodaje. Realiza el ciclo de excavación y carga sin desplazar su base en cada maniobra. La pluma, el balancín, la cuchara y otros equipos admitidos se accionan mediante energía hidráulica, capaz de generar fuerzas elevadas incluso con movimientos aparentemente lentos.
La estabilidad depende de la capacidad portante y nivelación de la plataforma, de la posición del tren de rodaje, del alcance, del peso del accesorio y de la carga manipulada. La proximidad a zanjas, bordes, rellenos recientes o terrenos saturados reduce el margen de seguridad. Aumentar el alcance o girar con una carga pesada puede modificar considerablemente la respuesta del equipo.
El radio de giro debe permanecer segregado. El contrapeso puede alcanzar a personas o vehículos que el operador no ve. El contacto visual no constituye por sí solo una protección suficiente: el acceso requiere detener los movimientos, dejar el equipo en condición segura y establecer comunicación o autorización conforme al procedimiento.

Aplicación práctica
Antes de cargar volquetes, se comprueba la plataforma y se organiza su posición para evitar que entren en la zona del contrapeso. Si el operador pierde de vista a una persona que estaba cerca, detiene inmediatamente la maniobra.

Riesgos y errores que deben evitarse
- Trabajar junto a bordes sin valorar la capacidad portante.
- Permitir personas o vehículos dentro del radio de giro.
- Confiar en el sistema hidráulico para sostener el equipo durante una intervención.

Idea clave
Una excavadora estable necesita una base resistente, un radio de giro controlado y una organización que elimine la presencia de terceros en la zona peligrosa.
$detail$, 7, 'pp. 25–30 y 211–237');

insert into _course4_block1_details (
  part_position, title, body, pdf_page, manual_pages
)
values
  (6, 'Tractor de cadenas: definición y aplicaciones', $detail$
Objetivo
Identificar las aplicaciones del tractor de cadenas y evitar que su elevada capacidad de tracción genere una falsa sensación de seguridad.

Explicación detallada
El tractor de cadenas utiliza una hoja para cortar, empujar, extender o nivelar materiales y puede incorporar escarificador para ripar terrenos compactos o roca blanda. Se utiliza también en el acondicionamiento de pistas, conformación de escombreras y apoyo a determinadas operaciones auxiliares definidas por la explotación.
Las cadenas mejoran la tracción y reparten la carga sobre el terreno, pero no impiden el deslizamiento, el hundimiento o el vuelco. En laderas deben respetarse la pendiente máxima y la orientación de trabajo indicadas por el fabricante y el procedimiento. Los giros bruscos, la proximidad a coronaciones y el empuje hacia bordes reducen el margen de estabilidad.
El remolcado o recuperación de otras máquinas no se decide únicamente comparando pesos o potencia. Requiere puntos de anclaje previstos, elementos de tiro adecuados, análisis de trayectoria, exclusión de personas y un procedimiento autorizado. El tractor tampoco debe utilizarse como aparato de elevación si no está diseñado y autorizado para ello.

Aplicación práctica
Tras lluvias intensas, la zona próxima a un borde puede haber perdido capacidad portante. Aunque el tractor tenga tracción, el operador no realiza una pasada de prueba cerca del límite: comunica el cambio y espera una nueva evaluación.

Riesgos y errores que deben evitarse
- Confundir tracción con estabilidad.
- Girar bruscamente o trabajar demasiado cerca de bordes.
- Realizar remolcados improvisados con cadenas o puntos no diseñados.

Idea clave
La fuerza del tractor no compensa un terreno inestable ni autoriza operaciones de remolcado o elevación no previstas.
$detail$, 8, 'pp. 7–15 y 65–108'),
  (7, 'Máquina base, equipos y accesorios', $detail$
Objetivo
Distinguir máquina base, equipo y accesorio, y comprender cómo un cambio de implemento modifica las condiciones de utilización.

Explicación detallada
La máquina base es el conjunto autopropulsado sin los implementos que determinan la tarea. Los equipos son componentes montados para cumplir la función primaria de la máquina. Los accesorios son herramientas desmontables, instaladas directamente o mediante acoplamiento rápido, que permiten realizar la función principal u otra aplicación específica.
Que un accesorio encaje físicamente no significa que sea compatible. Deben verificarse autorización o evaluación técnica, peso, capacidad, presión y caudal hidráulicos, geometría, sistema de retención y límites de la máquina. Un accesorio más pesado o largo modifica el centro de gravedad, la capacidad efectiva, el alcance, la visibilidad y las solicitaciones estructurales.
Después del montaje se comprueba visual y funcionalmente el bloqueo, se conectan correctamente los circuitos y se realiza una prueba controlada a baja altura y en zona despejada. El operador confirma que las limitaciones y tablas aplicables siguen siendo válidas. Nunca se trabaja confiando solo en una señal acústica, un indicador o en que el enganche parece cerrado.

Aplicación práctica
Tras instalar una pinza, el operador verifica pasadores y bloqueo, realiza una prueba de retención con el accesorio cerca del suelo y comprueba que no existen fugas ni movimientos anormales antes de entrar en producción.

Riesgos y errores que deben evitarse
- Montar un accesorio físicamente acoplable pero no autorizado.
- No verificar el bloqueo del acoplamiento rápido.
- Aplicar capacidades calculadas para otro implemento.

Idea clave
Cada accesorio cambia la máquina desde el punto de vista funcional y preventivo; por ello exige compatibilidad, comprobación y límites específicos.
$detail$, 9, 'pp. 139–238'),
  (8, 'Tareas comunes del operador', $detail$
Objetivo
Delimitar las obligaciones preventivas del operador y diferenciarlas de las reparaciones propias del personal de mantenimiento.

Explicación detallada
El operador es la primera barrera de detección. Antes y durante el turno inspecciona el equipo, comprueba niveles y elementos visibles, mantiene limpios cristales y espejos, interpreta alarmas y observa cambios de comportamiento. También respeta rutas y señalización, comunica defectos y estaciona la máquina de forma que no genere riesgos para otros usuarios.
El mantenimiento básico autorizado puede incluir determinadas comprobaciones, limpieza, engrase o reposición según el manual y las instrucciones de la empresa. Estas tareas deben realizarse con la máquina en condición segura y empleando los medios previstos. No convierten al operador en mecánico ni lo autorizan a desmontar protecciones, intervenir en circuitos presurizados o realizar reglajes complejos.
Ante un defecto que pueda afectar a frenos, dirección, estabilidad, retención de accesorios, neumáticos, sistemas hidráulicos, alarmas o visibilidad, la prioridad no es completar el ciclo. La máquina se inmoviliza, se identifica la incidencia y se comunica. Las intervenciones con energías peligrosas requieren personal competente, parada, aislamiento, bloqueo y comprobación de ausencia de energía residual.

Aplicación práctica
Una fuga cerca de un latiguillo no se busca con la mano ni se aprieta con el motor en marcha. El operador baja el equipo, estaciona, desconecta según procedimiento, impide el uso y avisa al responsable.

Riesgos y errores que deben evitarse
- Continuar porque el defecto parece pequeño.
- Manipular sistemas hidráulicos o mecánicos sin competencia.
- Anular alarmas o protecciones para mantener la producción.

Idea clave
La responsabilidad del operador es detectar, comunicar y no utilizar un equipo inseguro; reparar corresponde a personal competente y autorizado.
$detail$, 10, 'pp. 16–30'),
  (9, 'Planificación, autorización y DIS', $detail$
Objetivo
Aplicar las disposiciones internas de seguridad y reaccionar correctamente cuando el trabajo real se desvía de lo planificado.

Explicación detallada
Las DIS concretan las reglas necesarias para las condiciones particulares del centro minero: organización, circulación, prioridades, límites de velocidad, señales, vertido, mantenimiento, uso de equipos, trabajos excepcionales y actuación ante emergencias. Una vez aprobadas y aplicables, son de obligado cumplimiento para el personal afectado, incluido el de empresas contratistas.
La planificación debe definir responsable, máquina, operador autorizado, tarea, zona, secuencia, comunicaciones, interferencias y medidas preventivas. Cuando varias empresas o equipos actúan en el mismo lugar, se coordinan trayectorias, prioridades, señales y zonas de exclusión. Una instrucción genérica no sustituye la evaluación del escenario real.
El entorno puede cambiar por lluvia, tránsito, voladuras, movimientos de acopios, averías o retirada de protecciones. Si el procedimiento real deja de coincidir con la orden, el operador no compensa la diferencia con experiencia o maniobras de prueba. Se retira o detiene en lugar seguro, comunica la desviación y obtiene una nueva instrucción o autorización.

Aplicación práctica
Se ordena acondicionar una pista, pero la lluvia ha reblandecido el borde y falta la berma prevista. El operador no prueba si el terreno aguanta: suspende la maniobra y solicita que se restablezcan las condiciones o se defina otro procedimiento.

Riesgos y errores que deben evitarse
- Desconocer las DIS por pertenecer a una contrata.
- Mantener una orden cuando las condiciones han cambiado.
- Trabajar sin coordinación con peatones, volquetes u otros equipos.

Idea clave
La planificación es válida mientras coincida con la realidad; cualquier desviación relevante exige parar, comunicar y volver a autorizar.
$detail$, 11, 'pp. 306–347'),
  (10, 'El ciclo de trabajo como sistema preventivo', $detail$
Objetivo
Integrar seguridad y productividad mediante observación, control y anticipación en todas las etapas del ciclo.

Explicación detallada
Un ciclo seguro integra persona, máquina, material y entorno. Antes de la maniobra se observa y se decide; durante ella se controlan trayectoria, estabilidad, visibilidad y respuesta del equipo; al terminar se deja el área preparada para la siguiente fase. Esta secuencia se repite incluso en trabajos rutinarios, porque el terreno, el material y las interferencias pueden variar de un ciclo al siguiente.
La productividad no consiste en llevar cada movimiento al límite de velocidad. Un flujo uniforme reduce golpes, derrames, esperas, maniobras de corrección, desgaste y consumo. Acelerar una fase puede bloquear la siguiente, generar acopios desordenados o forzar cruces y aproximaciones. La seguridad bien integrada favorece la continuidad y reduce paradas no planificadas.
El operador desarrolla pensamiento anticipatorio: qué ocurrirá si entra un vehículo, falla una alarma, cede el terreno, cambia la pendiente, pierde la carga o desaparece una persona de su campo visual. Reconocer indicios tempranos permite detener el ciclo antes de que la condición insegura evolucione hacia un accidente.

Aplicación práctica
En una secuencia repetitiva de carga, el operador no da por supuesto que el área permanece libre. Verifica cada aproximación, mantiene contacto con el sistema de coordinación y detiene el movimiento si pierde la referencia del volquete o aparece un tercero.

Riesgos y errores que deben evitarse
- Reducir tiempos eliminando observaciones previas.
- Normalizar pequeños derrames, golpes o alarmas.
- Confundir velocidad instantánea con rendimiento global.

Idea clave
La operación más productiva es la que mantiene un ciclo estable, previsible y sin necesidad de correcciones peligrosas.
$detail$, 12, 'pp. 7–30 y 65–108');

create temporary table _course4_block1_segments on commit drop as
select
  segment.id as segment_id,
  segment.position as part_position,
  detail.title,
  detail.body,
  detail.pdf_page,
  detail.manual_pages
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module
  on module.course_version_id = version.id and module.position = 1
join public.lessons lesson on lesson.module_id = module.id
join public.lesson_audio_segments segment
  on segment.lesson_id = lesson.id
  and segment.published = true
  and coalesce(segment.audio_storage_path, segment.audio_external_url) is not null
join _course4_block1_details detail on detail.part_position = segment.position
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
  and version.status = 'published';

do $$
begin
  if (select count(*) from _course4_block1_segments) <> 10 then
    raise exception 'Se esperaban las 10 partes del Curso 4, Bloque 1';
  end if;
end;
$$;

update public.lesson_segment_slides slide
set
  title = target.title,
  body = target.body,
  source_label = 'Curso 4 · Bloque 1 · Explicaciones detalladas INMÍNER',
  updated_at = now()
from _course4_block1_segments target
where slide.segment_id = target.segment_id
  and slide.position = 1;

update public.lesson_segment_notes note
set
  summary = target.body,
  key_points = array[]::text[],
  stop_criterion = '',
  source_label = 'Curso_4_Bloque_1_Explicaciones_Detalladas_INMINER.pdf',
  source_pages = 'PDF de explicaciones, página ' || target.pdf_page
    || ' de 14 · Manual ET 2001-1-08, ' || target.manual_pages,
  approved = true,
  updated_at = now()
from _course4_block1_segments target
where note.segment_id = target.segment_id;

do $$
declare
  detailed_slides integer;
  detailed_notes integer;
begin
  select count(*)
  into detailed_slides
  from _course4_block1_segments target
  join public.lesson_segment_slides slide
    on slide.segment_id = target.segment_id and slide.position = 1
  where slide.body = target.body
    and slide.source_label = 'Curso 4 · Bloque 1 · Explicaciones detalladas INMÍNER';

  select count(*)
  into detailed_notes
  from _course4_block1_segments target
  join public.lesson_segment_notes note on note.segment_id = target.segment_id
  where note.summary = target.body
    and note.approved = true
    and cardinality(note.key_points) = 0;

  if detailed_slides <> 10 or detailed_notes <> 10 then
    raise exception 'Validación fallida: % diapositivas y % fichas detalladas',
      detailed_slides, detailed_notes;
  end if;
end;
$$;
