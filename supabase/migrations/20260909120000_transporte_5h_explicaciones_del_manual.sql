-- InmínerCampus
-- Reescribe las explicaciones de las 50 diapositivas del curso de transporte de
-- 5 horas a partir del manual «El transporte en el movimiento de tierras y los
-- tipos de vehículos», la presentación de 55 páginas aportada el 8 de septiembre
-- de 2026.
--
-- Qué estaba mal. Los cuerpos anteriores eran una plantilla: cambiaba el título
-- y una frase, pero los apartados de aplicación, errores y comprobaciones eran
-- idénticos en las 50 diapositivas («Convertir una tarea repetida en
-- automática», «Condición de la unidad verificada»…). El manual, en cambio,
-- trae por diapositiva su propia idea clave, su error frecuente y su criterio de
-- parada, y nada de eso llegaba al alumno.
--
-- Además los encabezados iban en mayúsculas («EXPLICACIÓN DETALLADA»), y
-- `detailedInformationHeadings`, en AudioLessonPlayer.tsx, sólo reconoce la
-- forma con inicial mayúscula. El resultado era que el texto se pintaba como
-- párrafos sueltos, sin títulos, sin listas y sin el recuadro de idea clave. Se
-- pasan a la forma que el componente reconoce, así que el contenido gana además
-- el formato que siempre debió tener.
--
-- No se toca `narration_text`: es la transcripción literal de pistas de audio ya
-- grabadas, y reescribirla dejaría voz y texto diciendo cosas distintas.
--
-- El bloque 6 queda fuera: es la evaluación final y sus diapositivas no salen de
-- este manual, no tienen `source_page`.

begin;

-- Bloque 1 · El transporte en el movimiento de tierras y los tipos de vehículos

update public.lesson_segment_slides set body = $b$Objetivo

Situar el transporte dentro de los costes de la explotación y reconocer que el rendimiento se juega en el ciclo completo, no en la velocidad de cada viaje.

Explicación detallada

En muchas explotaciones el transporte concentra una parte muy importante del coste por tonelada movida. Lo que determina el rendimiento son las distancias, los tiempos de ciclo y el número de unidades en servicio, no lo rápido que vaya cada camión. Acelerar viajes de forma aislada no mejora el sistema y sí empeora la seguridad.

Aplicación práctica

Antes de empezar, el operador entiende qué lugar ocupa su unidad en el ciclo: de dónde carga, por dónde circula, dónde descarga y con qué equipos se cruza. Si el equipo, las Disposiciones Internas de Seguridad o el procedimiento han cambiado, se revisa antes de continuar con la operación habitual.

Errores críticos que deben evitarse

• Convertir la tarea repetida en automática y dejar de comprobar el entorno, porque la rutina genera complacencia.
• Interpretar la eficiencia como velocidad individual y no como optimización del ciclo.

Comprobación antes de continuar

• Ciclo y ruta previstos conocidos
• Cambios en equipo, DIS o procedimiento revisados

Idea clave

El transporte concentra una parte muy importante del coste por tonelada movida. Rendimiento no es velocidad individual, sino optimización del ciclo completo.$b$ where id = '40aae3fd-4b13-45ad-bd26-3d0060d70231';

update public.lesson_segment_slides set body = $b$Objetivo

Coordinar la unidad de transporte con el equipo de carga, de modo que la cadena funcione sin esperas ni maniobras improvisadas.

Explicación detallada

La productividad depende de la coordinación entre la unidad de transporte y las palas y excavadoras. La cadena sólo funciona si todos sus eslabones están sincronizados. La capacidad de la caja, el tamaño del cucharón y el ritmo de ambos equipos deben ser compatibles para reducir esperas y aprovechar el rendimiento de los dos.

Aplicación práctica

El operador espera en el punto definido y no entra al frente hasta recibir una señal clara y confirmada del equipo de carga. La señal la da el equipo de carga: no es una interpretación del conductor.

Errores críticos que deben evitarse

• Mover la unidad sin señal o sin autorización inequívoca del equipo de carga.
• Forzar el ritmo cuando la capacidad de caja y el cucharón no son compatibles.

Comprobación antes de continuar

• Punto de espera definido
• Señal de entrada confirmada
• Área libre de personas

Idea clave

La productividad depende de coordinar la unidad de transporte con palas y excavadoras. La cadena sólo funciona si todos sus eslabones están sincronizados.$b$ where id = '1cbd0403-6146-4766-acd9-1adc568fbb6f';

update public.lesson_segment_slides set body = $b$Objetivo

Reconocer cómo la distancia, la pendiente, la cota y el trazado de las pistas condicionan el ciclo, el consumo y la seguridad.

Explicación detallada

La distancia determina directamente el tiempo de ciclo y el número de unidades necesarias. La pendiente afecta al consumo, al desgaste de frenos y a la seguridad en descenso. Las diferencias de cota condicionan la potencia requerida y el rendimiento. El estado y el diseño de las pistas influyen de forma directa en la seguridad, el desgaste de neumáticos y el coste operativo.

Aplicación práctica

La conducción se adapta a la condición real del trazado en cada vuelta, no al tiempo que se tardó en la anterior. Un deterioro de la pista cambia el criterio aunque la ruta sea la de siempre.

Errores críticos que deben evitarse

• Continuar por presión de producción cuando la condición real de la pista o la pendiente no coincide con el procedimiento establecido.
• Mantener el tiempo de ciclo como objetivo cuando el trazado ha empeorado.

Comprobación antes de continuar

• Estado real de la pista valorado
• Pendientes y cotas del recorrido conocidas

Idea clave

El trazado y el estado de las pistas influyen directamente en la seguridad, el desgaste y el coste de la operación.$b$ where id = '5696d5e1-09e7-4657-96a6-22b1076cca91';

update public.lesson_segment_slides set body = $b$Objetivo

Distinguir el camión convencional de la configuración tipo bañera y saber de qué depende que puedan circular fuera de la explotación.

Explicación detallada

El camión convencional es un vehículo de carretera adaptado para uso en explotación cuando está autorizado y acondicionado conforme a las condiciones de las Disposiciones Internas de Seguridad. La configuración bañera es una cabeza tractora con semirremolque basculante, y puede realizar transporte exterior si cumple las condiciones de autorización aplicables.

Aplicación práctica

Antes de asumir que una unidad puede salir a vía pública, se confirma su situación concreta. Las características del tipo no dicen nada sobre la autorización de la unidad que se conduce hoy.

Errores críticos que deben evitarse

• Deducir la autorización de circulación exterior del aspecto o del tipo de vehículo.
• Utilizar en explotación un camión de carretera sin el acondicionamiento que exige la DIS.

Comprobación antes de continuar

• Autorización aplicable verificada
• Acondicionamiento conforme a la DIS

Idea clave

Las características concretas se confirman en el manual del fabricante y en la autorización aplicable, no por comparación entre vehículos.$b$ where id = 'e7699d16-84a5-4218-b1e8-382ce4910c2e';

update public.lesson_segment_slides set body = $b$Objetivo

Conocer el diseño del volquete de bastidor rígido y separar las características generales del tipo de los límites de la unidad concreta.

Explicación detallada

El volquete rígido está concebido para cargas pesadas. Lleva dirección en el eje delantero, tracción principal en el eje posterior y caja basculante hidráulica. Sus prestaciones dependen del modelo y de las condiciones de uso, de modo que las cifras que aparecen en el material formativo no son una autorización para circular a esa velocidad ni para cargar hasta ese valor.

Aplicación práctica

El operador toma como referencia vinculante la placa de la máquina, el manual del modelo y las Disposiciones Internas de Seguridad, no el ejemplo del curso.

Errores críticos que deben evitarse

• Asumir que las características generales del tipo equivalen a los límites de la unidad concreta asignada.
• Tomar una cifra de velocidad del material formativo como permiso para circular a ella.

Comprobación antes de continuar

• Límites de la unidad concreta consultados
• Manual del modelo y DIS disponibles

Idea clave

El volquete rígido está concebido para cargas pesadas, con dirección en el eje delantero y tracción principal posterior.$b$ where id = 'ad34ccd4-1cef-432c-afe7-d46af7dcc477';

update public.lesson_segment_slides set body = $b$Objetivo

Entender hasta dónde llega la robustez del bastidor y de la caja, y qué se inspecciona antes de cada turno.

Explicación detallada

El bastidor y la caja están construidos para soportar cargas e impactos dentro de los límites del fabricante, pero no son indestructibles. La sobrecarga, el material inadecuado o los impactos concentrados pueden superar la capacidad de diseño prevista, y el daño no siempre se manifiesta de inmediato.

Aplicación práctica

En cada revisión previa se inspeccionan visualmente bastidor y caja buscando grietas, deformaciones o daños visibles. Cualquier anomalía se comunica antes de circular.

Errores críticos que deben evitarse

• Confundir robustez con invulnerabilidad y aceptar sobrecargas o impactos concentrados.
• Circular con una deformación o grieta detectada sin haberla comunicado.

Comprobación antes de continuar

• Bastidor inspeccionado visualmente
• Caja sin grietas ni deformaciones
• Anomalías comunicadas antes de circular

Idea clave

Bastidor y caja soportan cargas e impactos dentro de los límites del fabricante. No son indestructibles.$b$ where id = '837f648d-ade6-467e-a328-3bae805f3c30';

update public.lesson_segment_slides set body = $b$Objetivo

Conocer el volquete de bastidor articulado y de qué depende su límite de carga y de tamaño de roca.

Explicación detallada

En el volquete articulado la dirección se produce mediante la unión articulada de dos bastidores, lo que reduce el radio de giro y mejora la adaptación al terreno irregular. Su ventaja principal es la maniobrabilidad en espacios reducidos y en los terrenos irregulares propios de explotaciones mineras activas.

Aplicación práctica

Los límites de tamaño de roca y las condiciones de uso se toman siempre del fabricante y del procedimiento de la explotación. No se deducen comparando con otros modelos que trabajen en el mismo frente.

Errores críticos que deben evitarse

• Deducir el límite de carga o de tamaño de roca por comparación con otro modelo.
• Aprovechar el menor radio de giro para maniobrar en espacios que el procedimiento no contempla.

Comprobación antes de continuar

• Límites del modelo consultados en el manual
• Procedimiento de la explotación aplicable conocido

Idea clave

La dirección se produce mediante la unión articulada de dos bastidores, lo que reduce el radio de giro y mejora la adaptación al terreno.$b$ where id = '3ad918d6-f9fb-4628-8af2-3dd173cbded4';

update public.lesson_segment_slides set body = $b$Objetivo

Aplicar el criterio correcto en pistas mal conservadas, barro y baja adherencia, sin confiar la seguridad a la tracción.

Explicación detallada

Los volquetes articulados están pensados para superficies irregulares, barro y baja adherencia, pero esto no elimina el riesgo. La tracción en todos los ejes mejora la movilidad y no suprime el deslizamiento, la pérdida de control ni el riesgo de vuelco en terrenos extremos.

Aplicación práctica

La decisión no es si la máquina puede avanzar, sino si el terreno ofrece garantías para la operación prevista. Cuando no las ofrece, se detiene y se comunica.

Errores críticos que deben evitarse

• Confiar en la tracción total para circular en condiciones que superan los límites del equipo, porque tracción total no es seguridad ilimitada.
• Tomar el hecho de que la máquina avance como prueba de que el terreno es seguro.

Comprobación antes de continuar

• Adherencia real del terreno valorada
• Estabilidad suficiente para la operación prevista

Idea clave

Los articulados están pensados para superficies irregulares, barro y baja adherencia, pero esto no elimina el riesgo.$b$ where id = 'c584f6a5-ddc4-4698-a123-170fb98ddcd7';

update public.lesson_segment_slides set body = $b$Objetivo

Comprender qué aportan la tracción distribuida y la oscilación de los bastidores, y qué siguen sin garantizar.

Explicación detallada

La tracción se reparte entre los ejes para mejorar la adherencia en terrenos difíciles, y el sistema adapta el par a cada eje según la condición. La oscilación permite el movimiento relativo entre los dos bastidores: mejora la adaptación al terreno irregular, pero no garantiza estabilidad absoluta en todas las condiciones. Un bastidor puede inclinarse mientras el otro permanece horizontal.

Aplicación práctica

Durante la circulación se vigila de forma continua la geometría del terreno y la posición de cada bastidor, no sólo la del que se ve desde la cabina.

Errores críticos que deben evitarse

• Interpretar la oscilación como una garantía de estabilidad en cualquier terreno.
• Perder de vista la posición del bastidor trasero durante la maniobra.

Comprobación antes de continuar

• Geometría del terreno valorada
• Posición de ambos bastidores bajo control

Idea clave

La oscilación mejora la adaptación al terreno irregular, pero no garantiza estabilidad absoluta en todas las condiciones.$b$ where id = 'b6101790-5a3d-428f-a624-2cc2a5f00b5e';

update public.lesson_segment_slides set body = $b$Objetivo

Saber qué condiciona que un articulado ligero pueda circular por vía pública y por qué no basta con su tamaño.

Explicación detallada

Algunos modelos articulados de menor masa y anchura pueden cumplir condiciones para circular por vías públicas o mixtas. Ahora bien, la posibilidad real debe comprobarse por clasificación, autorización y condiciones concretas: no se deduce del tamaño de la unidad ni de que otro modelo parecido lo haga.

Aplicación práctica

Antes de circular fuera de la explotación se verifica siempre la autorización aplicable. La clasificación del vehículo es lo determinante.

Errores críticos que deben evitarse

• Deducir la aptitud para vía pública sólo del tamaño o la masa de la unidad.
• Salir de la explotación sin verificar la autorización aplicable a esa unidad.

Comprobación antes de continuar

• Clasificación del vehículo conocida
• Autorización aplicable verificada
• Condiciones concretas de circulación confirmadas

Idea clave

Algunos modelos articulados de menor masa y anchura pueden cumplir condiciones para circular por vías públicas o mixtas, pero eso se comprueba, no se supone.$b$ where id = 'b086ffab-15a7-4fac-a2e3-259184d5b91f';

-- Bloque 2 · Ciclo de trabajo y operativa de carga y transporte

update public.lesson_segment_slides set body = $b$Objetivo

Reconocer las cinco fases del ciclo de transporte y que cada una tiene riesgos propios que no se mezclan entre sí.

Explicación detallada

El ciclo encadena carga en el frente de trabajo, transporte por las vías establecidas, descarga en la zona de volcado, retorno en vacío al área de carga y posicionamiento frente al cargador. Cada fase tiene riesgos propios y debe seguir el procedimiento establecido en las Disposiciones Internas de Seguridad. No se aplican criterios de una fase a otra.

Aplicación práctica

El operador identifica en qué fase está y qué exige esa fase concreta. El tráfico, el firme, el material o la visibilidad pueden cambiar el nivel de riesgo en cualquier ciclo, aunque el recorrido sea el mismo de siempre.

Errores críticos que deben evitarse

• Convertir una fase rutinaria en automática y dejar de leer las condiciones de ese ciclo.
• Trasladar a una fase el criterio que corresponde a otra distinta.

Comprobación antes de continuar

• Fase del ciclo identificada
• Procedimiento de esa fase presente
• Condiciones del ciclo actual valoradas

Idea clave

La repetición nunca convierte una maniobra en automática. Cada ciclo requiere atención activa.$b$ where id = 'baf04912-c0c1-4557-a08f-8126e55c40a0';

update public.lesson_segment_slides set body = $b$Objetivo

Ordenar las tareas que abren el turno, desde el equipo de protección hasta la incorporación al ciclo productivo.

Explicación detallada

El equipo de protección individual y la indumentaria deben ser correctos antes de acceder al área de trabajo, sin excepciones. La revisión previa se completa y se registra según la lista de control de la explotación. El acceso a la cabina se hace con tres puntos de apoyo, de cara a la máquina y con las manos libres en todo momento. El traslado aplica las normas internas y la planificación de ruta antes de incorporarse al ciclo productivo.

Aplicación práctica

Ninguna de estas tareas se sustituye por la experiencia acumulada. La revisión previa se registra aunque la unidad sea la misma de ayer y la haya conducido el mismo operador.

Errores críticos que deben evitarse

• Omitir la revisión previa por presión de producción o por hábito, porque la revisión no es opcional.
• Acceder a la cabina con objetos en las manos o de espaldas a la máquina.

Comprobación antes de continuar

• EPI e indumentaria correctos
• Revisión previa completada y registrada
• Ruta planificada según normas internas

Idea clave

La revisión previa no es opcional: se completa y se registra según la lista de control de la explotación.$b$ where id = '935b2c2a-e7f8-47f2-b800-ebb33f703f13';

update public.lesson_segment_slides set body = $b$Objetivo

Aproximarse al frente de carga de forma lenta, visible y coordinada, leyendo un entorno que cambia en cada ciclo.

Explicación detallada

La aproximación al frente debe ser lenta, visible y coordinada con el equipo de carga presente. Antes de colocarse se revisan el suelo, las rocas sueltas y el espacio de maniobra disponible, porque el entorno del frente cambia en cada ciclo aunque el punto sea el mismo.

Aplicación práctica

La posición se elige de modo que ni la cabina ni los neumáticos queden expuestos a la trayectoria de material o de maquinaria. Si esa posición no es posible, se comunica antes de entrar.

Errores críticos que deben evitarse

• Aceptar una posición que expone la cabina o los neumáticos a la trayectoria de material o de maquinaria.
• Entrar al frente sin haber revisado suelo, rocas sueltas y espacio de maniobra.

Comprobación antes de continuar

• Señal de entrada confirmada
• Área libre de personas
• Suelo con resistencia suficiente

Idea clave

La aproximación al frente debe ser lenta, visible y coordinada con el equipo de carga presente.$b$ where id = '7e06daef-743a-4aa7-8fe8-08bc7761c93c';

update public.lesson_segment_slides set body = $b$Objetivo

Situar la unidad respecto a la pala cargadora manteniendo la cabina fuera del punto de carga.

Explicación detallada

Como referencia de posicionamiento, el material formativo propone una posición sesgada aproximada de 35 a 45 grados respecto a la pala cargadora, con la cabina alejada del punto de carga. Es una referencia: las maniobras y las señales reales se ajustan al procedimiento interno y al equipo concreto con el que se trabaja.

Aplicación práctica

Cuando cambia el equipo de carga, el frente o el procedimiento, la posición se replantea. La que servía con otra pala no vale por costumbre.

Errores críticos que deben evitarse

• Mantener una posición por hábito aunque el equipo de carga o el procedimiento hayan cambiado.
• Tomar los 35 a 45 grados como una regla fija por encima del procedimiento interno.

Comprobación antes de continuar

• Cabina alejada del punto de carga
• Posición acordada con el equipo de carga
• Procedimiento interno aplicable revisado

Idea clave

La referencia de posicionamiento es orientativa. Las maniobras y señales reales las fijan el procedimiento interno y el equipo concreto.$b$ where id = '6e186e38-a0fd-40cf-8813-86152b3b1130';

update public.lesson_segment_slides set body = $b$Objetivo

Mantener la unidad y al conductor en la condición prevista mientras el equipo de carga trabaja sobre la caja.

Explicación detallada

Durante la carga la unidad permanece estacionada en la condición indicada por el fabricante y por las Disposiciones Internas de Seguridad. Nada de esto se improvisa. La permanencia del conductor en la cabina se rige por el procedimiento de la explotación, no por la costumbre del frente ni por la decisión del momento.

Aplicación práctica

Está prohibido pasar material sobre la cabina, moverse sin señal inequívoca del equipo de carga y abandonar el puesto sin procedimiento.

Errores críticos que deben evitarse

• Moverse sin señal inequívoca del equipo de carga.
• Abandonar el puesto de conducción sin que el procedimiento lo contemple.
• Aceptar que el material pase por encima de la cabina.

Comprobación antes de continuar

• Freno aplicado
• Posición estable
• Señal de inicio de carga recibida

Idea clave

Durante la carga la unidad permanece estacionada en la condición indicada por el fabricante y la DIS. No se improvisa.$b$ where id = 'cf20c854-a104-49f3-8b2a-2025bb5a4b7c';

update public.lesson_segment_slides set body = $b$Objetivo

Circular por las pistas respetando los límites de la explotación y adaptando la velocidad a la condición real.

Explicación detallada

Se respetan la velocidad autorizada, la distancia de seguridad, la señalización y las prioridades fijadas por las Disposiciones Internas de Seguridad, sin excepciones por producción. Los adelantamientos sólo proceden cuando están permitidos y existen visibilidad, espacio y coordinación suficientes con el resto de la circulación.

Aplicación práctica

La velocidad máxima no es un objetivo que haya que alcanzar: es un límite que no se rebasa. En una pista deteriorada, la velocidad segura está por debajo de la autorizada.

Errores críticos que deben evitarse

• Circular a velocidad inadecuada por presión de producción o por costumbre.
• Adelantar sin visibilidad, espacio o coordinación suficientes.

Comprobación antes de continuar

• Velocidad adaptada a la condición real de la pista
• Distancia de seguridad mantenida
• Señalización y prioridades de la DIS respetadas

Idea clave

La velocidad máxima no es un objetivo, es un límite.$b$ where id = 'b40dd75d-08eb-4d59-9afe-fc3a069d51ba';

update public.lesson_segment_slides set body = $b$Objetivo

Decidir cómo se va a controlar la velocidad antes de entrar en un descenso, no durante.

Explicación detallada

Nunca se desciende en punto muerto ni se neutraliza la transmisión en ningún tramo de pendiente. Se utilizan la relación de transmisión, el frenado motor o el retardador que indica el fabricante para cada condición de pendiente y carga. La capacidad de detenerse se protege antes de necesitarla: velocidad y sistema de retención se deciden con margen, antes de iniciar el descenso.

Aplicación práctica

Al llegar al inicio de la rampa, el operador ya sabe con qué marcha y con qué sistema de retención va a bajar. Si no lo sabe, no inicia el descenso.

Errores críticos que deben evitarse

• Entrar en un descenso sin haber decidido previamente cómo controlar la velocidad en ese tramo concreto.
• Descender en punto muerto o neutralizar la transmisión en pendiente.

Comprobación antes de continuar

• Marcha y sistema de retención decididos antes de la rampa
• Indicaciones del fabricante para esa pendiente y carga aplicadas

Idea clave

La capacidad de detenerse se protege antes de necesitarla.$b$ where id = 'e4b261b4-e0a4-41a0-8cdc-f36f62673bd8';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar el derrame de material desde la caja como un riesgo acumulativo para toda la flota, no como una molestia.

Explicación detallada

En rampas, el material puede derramarse desde la caja y convertirse en obstáculo o dañar los neumáticos de los vehículos que circulan detrás. La prevención pasa por una distribución correcta de la carga, por mantener las pistas limpias de material suelto y por comunicar los derrames que se produzcan.

Aplicación práctica

El derrame se comunica siempre, aunque el vehículo que lo provocó siga su ruta sin incidencias. Una piedra en la pista puede causar un accidente grave a la unidad siguiente.

Errores críticos que deben evitarse

• Ignorar el derrame por considerarlo un problema menor, cuando el derrame continuo deteriora la pista y acumula riesgos.
• Cargar sin cuidar la distribución en la caja antes de afrontar una rampa.

Comprobación antes de continuar

• Carga correctamente distribuida en la caja
• Derrames observados comunicados

Idea clave

Una piedra en la pista puede causar un accidente grave. Reportar siempre cualquier derrame.$b$ where id = 'cf3e5e2f-cc92-4085-a138-2ce5682aee4d';

update public.lesson_segment_slides set body = $b$Objetivo

Conocer para qué sirven las compuertas y los suplementos de caja y qué se comprueba en cada ciclo.

Explicación detallada

Algunos equipos incorporan compuertas o suplementos para limitar las pérdidas de material durante el transporte en rampas y pistas. Su apertura, cierre, mantenimiento y compatibilidad con la carga se rigen por las instrucciones del fabricante y por el procedimiento de la explotación.

Aplicación práctica

El estado y el cierre correcto de las compuertas se comprueban antes de iniciar el transporte en cada ciclo, no una vez al día.

Errores críticos que deben evitarse

• Asumir que el cierre es correcto por defecto sin comprobarlo en el ciclo.
• Operar compuertas o suplementos al margen de las instrucciones del fabricante.

Comprobación antes de continuar

• Estado de las compuertas revisado
• Cierre correcto confirmado en este ciclo
• Compatibilidad con la carga verificada

Idea clave

Las compuertas limitan las pérdidas de material, pero su cierre se comprueba en cada ciclo. No se asume correcto por defecto.$b$ where id = '3b6b8676-c516-4cca-9dbd-b674a958fbe5';

update public.lesson_segment_slides set body = $b$Objetivo

Entender la descarga por empuje horizontal y qué condiciones deben permanecer controladas mientras dura.

Explicación detallada

Algunos modelos desplazan el material sin elevar la caja, mediante un frente eyector que empuja la carga horizontalmente. La descarga sólo continúa mientras el terreno, la alineación, la inmovilización y la estabilidad permanecen controlados en todo momento.

Aplicación práctica

La descarga en movimiento sólo se realiza cuando el fabricante y el procedimiento lo permiten expresamente. No se infiere de que el sistema sea eyector.

Errores críticos que deben evitarse

• Deducir del sistema eyector que se puede descargar en movimiento.
• Continuar la descarga cuando el terreno, la alineación o la estabilidad han dejado de estar controlados.

Comprobación antes de continuar

• Terreno y zona autorizados
• Unidad alineada e inmovilizada
• Área despejada de personas

Idea clave

La descarga sólo continúa mientras terreno, alineación, inmovilización y estabilidad permanecen controlados en todo momento.$b$ where id = 'a909a92d-2959-4ba3-ad2c-41e41d311296';

-- Bloque 3 · Técnicas preventivas y revisión de seguridad de la unidad

update public.lesson_segment_slides set body = $b$Objetivo

Entender para qué sirve realmente el control diario y cuándo obliga a dejar la unidad fuera de servicio.

Explicación detallada

La revisión previa no busca demostrar que la máquina funciona. Busca descubrir por qué no debería entrar en servicio. El proceso consiste en completar la inspección previa y cumplimentar el parte o lista de control que define la explotación, con el objetivo de detectar fugas, daños y fallos de seguridad antes de poner la unidad en producción.

Aplicación práctica

El resultado de la revisión se registra siempre, tanto si aparecen anomalías como si no. El registro es lo que permite seguir la evolución de un defecto entre turnos.

Errores críticos que deben evitarse

• Enfocar la revisión como un trámite para confirmar que la máquina arranca.
• Poner la unidad en producción con una anomalía pendiente de valorar.

Comprobación antes de continuar

• Inspección previa completa
• Parte o lista de control cumplimentado
• Anomalías en sistemas críticos inmovilizadas hasta valoración competente

Idea clave

La revisión previa no busca demostrar que la máquina funciona. Busca descubrir por qué no debería entrar en servicio.$b$ where id = '6a2a5fe1-150e-4fb9-aae0-d86d69b53393';

update public.lesson_segment_slides set body = $b$Objetivo

Detectar fugas bajo la máquina sin exponerse a atrapamiento y saber cuáles obligan a inmovilizar.

Explicación detallada

Se buscan pérdidas de agua, aceite, combustible u otros fluidos en el suelo y en la parte inferior de la máquina. La inspección se hace manteniéndose fuera de las zonas de atrapamiento, y nunca bajo un equipo sin asegurar.

Aplicación práctica

Cualquier fuga se comunica antes de trabajar. No se normaliza ni se pospone la comunicación al final del turno, porque una mancha pequeña puede ser el primer síntoma de un fallo en un sistema crítico.

Errores críticos que deben evitarse

• Situarse bajo un equipo sin asegurar para localizar el origen de la fuga.
• Normalizar una fuga conocida y aplazar su comunicación.

Comprobación antes de continuar

• Suelo y bajos inspeccionados desde posición segura
• Fugas detectadas comunicadas antes de trabajar
• Fuga en frenos, dirección o hidráulico: inmovilizar y comunicar

Idea clave

Cualquier fuga debe comunicarse antes de trabajar. No se normaliza ni se pospone la comunicación.$b$ where id = 'dfca659e-03fa-454a-aa53-0d93f43cffb0';

update public.lesson_segment_slides set body = $b$Objetivo

Inspeccionar los neumáticos desde posición protegida y reconocer el límite de lo que puede hacer el operador.

Explicación detallada

La inspección visual cubre banda de rodadura, flancos, cortes y fijaciones, en frío y antes de circular, desde una posición lateral protegida. El control de presión se hace también desde posición protegida según procedimiento, nunca frente a la trayectoria de proyección en caso de explosión.

Aplicación práctica

La intervención sobre neumáticos está reservada a personal competente con medios adecuados. El operador detecta y comunica, pero no improvisa reparaciones ni ajustes.

Errores críticos que deben evitarse

• Normalizar cortes, calentamientos o fijaciones dudosas porque la unidad todavía puede circular, cuando eso no es criterio de seguridad.
• Situarse frente a la trayectoria de proyección durante el control de presión.

Comprobación antes de continuar

• Banda, flancos, cortes y fijaciones revisados en frío
• Control de presión hecho desde posición protegida
• Anomalías derivadas a personal competente

Idea clave

Que la unidad todavía pueda circular no es criterio de seguridad para un neumático dudoso.$b$ where id = '40ac880f-63d4-4b85-89b7-1e8246906338';

update public.lesson_segment_slides set body = $b$Objetivo

Dimensionar el riesgo de explosión de un neumático de volquete y actuar en consecuencia.

Explicación detallada

Las causas principales son el calor excesivo, la presión incorrecta y el frenado intenso continuado, que generan un riesgo grave en los neumáticos de gran tamaño de los volquetes. El inflado y el mantenimiento se hacen en frío, desde posición protegida y conforme a las especificaciones del fabricante para el modelo concreto.

Aplicación práctica

El operador detecta síntomas, mantiene la distancia mínima de seguridad y avisa. Quien interviene es el especialista.

Errores críticos que deben evitarse

• Aproximarse a un neumático sobrecalentado sin respetar la distancia mínima de seguridad.
• Inflar en caliente o al margen de las especificaciones del fabricante para ese modelo.

Comprobación antes de continuar

• Temperatura y presión dentro de lo previsto
• Distancia mínima de seguridad respetada
• Síntomas comunicados al especialista

Idea clave

Una explosión de neumático de volquete minero puede ser mortal. La energía liberada es enorme y la distancia mínima de seguridad es esencial.$b$ where id = '73dac394-a00b-4f4b-b554-4488675538f8';

update public.lesson_segment_slides set body = $b$Objetivo

Distinguir los tres sistemas de frenado y el papel que corresponde a cada uno.

Explicación detallada

El freno de servicio es el de la frenada en marcha normal, y se comprueba en zona habilitada antes de entrar en producción. El de estacionamiento inmoviliza la unidad parada y es imprescindible en pendiente y al finalizar la jornada. El de emergencia queda reservado para fallos y no sustituye al de servicio en operación normal.

Aplicación práctica

La comprobación del freno de servicio se hace en la zona habilitada, no probándolo por primera vez en una rampa cargada.

Errores críticos que deben evitarse

• Confiar en el freno de emergencia para compensar un sistema sobrecalentado o una marcha inadecuada en pendiente.
• Entrar en producción sin haber comprobado el freno de servicio.

Comprobación antes de continuar

• Freno de servicio comprobado en zona habilitada
• Freno de estacionamiento operativo
• Freno de emergencia reservado a fallos

Idea clave

La capacidad de detenerse se protege antes de necesitarla.$b$ where id = 'fe124e43-0875-4884-9fef-a14fe7e519e1';

update public.lesson_segment_slides set body = $b$Objetivo

Mantener la visibilidad operativa durante toda la jornada y reconocer cuándo obliga a parar.

Explicación detallada

Cristales, luces y espejos se mantienen limpios, regulados y operativos en todo momento: no se comprueban sólo al inicio del turno. La falta de visibilidad incrementa el riesgo en ángulos muertos, especialmente en marcha atrás y en maniobras en la zona de descarga. Las cámaras de visión trasera y los sistemas de ayuda a la maniobra, cuando están instalados, son un complemento y no un sustituto.

Aplicación práctica

Si el polvo, el barro o la lluvia degradan la visibilidad a lo largo del turno, se corrige en ese momento, no al final de la jornada.

Errores críticos que deben evitarse

• Tratar la cámara trasera como sustituto de la visión directa y de los espejos.
• Operar con un elemento de visibilidad dañado o inoperativo.

Comprobación antes de continuar

• Cristales, luces y espejos limpios y regulados
• Sistemas de ayuda operativos si están instalados
• Ningún elemento de visibilidad dañado

Idea clave

Cristales, luces y espejos se mantienen limpios, regulados y operativos en todo momento, no sólo al inicio del turno.$b$ where id = '8d822b2e-3359-40a5-a988-f2ea3a1cc27e';

update public.lesson_segment_slides set body = $b$Objetivo

Acceder y abandonar la cabina con la técnica que evita la caída a distinto nivel.

Explicación detallada

Lo correcto es subir y bajar de cara a la máquina, utilizando peldaños y asideros, con tres puntos de apoyo y las manos libres en todo momento. Es incorrecto bajar de espaldas, saltar desde la cabina, llevar objetos en las manos y usar prendas que puedan engancharse en peldaños o asideros.

Aplicación práctica

Los peldaños y asideros se inspeccionan durante la revisión previa, porque el material acumulado, el barro o un daño pueden comprometer el acceso seguro.

Errores críticos que deben evitarse

• Saltar desde la cabina o bajar de espaldas a la máquina.
• Subir o bajar con objetos en las manos, perdiendo los tres puntos de apoyo.

Comprobación antes de continuar

• Peldaños y asideros inspeccionados y limpios
• Manos libres antes de iniciar el ascenso o descenso
• Indumentaria sin elementos que puedan engancharse

Idea clave

Subir y bajar de cara a la máquina, con tres puntos de apoyo y manos libres en todo momento.$b$ where id = '6ca0dcf5-e4d8-42fc-b618-161fc185d70e';

update public.lesson_segment_slides set body = $b$Objetivo

Delimitar qué mantenimiento corresponde al operador y dónde empieza el terreno del especialista.

Explicación detallada

El alcance del operador se limita a las tareas rutinarias asignadas por el fabricante y por la empresa: niveles de fluidos, engrase y filtros. Nada más. Toda intervención respeta los bloqueos y los límites establecidos, y no se improvisa ninguna reparación ni ajuste que no esté asignado.

Aplicación práctica

El operador no decide el alcance de la intervención. Cuando la tarea excede lo asignado, se comunica y se espera a personal competente.

Errores críticos que deben evitarse

• Intervenir con energía almacenada o sin impedir movimientos inesperados de la máquina, con riesgo de atrapamiento grave.
• Ampliar por iniciativa propia el alcance de una tarea rutinaria.

Comprobación antes de continuar

• Tarea dentro de lo asignado por fabricante y empresa
• Bloqueos aplicados y energía residual controlada
• Movimientos inesperados impedidos

Idea clave

El operador no decide el alcance de la intervención: lo fijan el manual del fabricante y el procedimiento de la explotación.$b$ where id = '37c2d159-06c9-4a39-8d3b-9b3327cf387f';

update public.lesson_segment_slides set body = $b$Objetivo

Repostar en zona habilitada controlando las fuentes de ignición y la posibilidad de derrame.

Explicación detallada

El repostaje se realiza en zona habilitada y conforme al procedimiento, controlando el freno, el motor, las fuentes de ignición y los posibles derrames. Durante todo el proceso están prohibidos fumar, las llamas, las chispas y cualquier conducta incompatible con el combustible.

Aplicación práctica

El plan de emergencia de la explotación incluye la respuesta ante derrames. El operador debe conocerla antes de repostar, no consultarla cuando el derrame ya se ha producido.

Errores críticos que deben evitarse

• Repostar fuera de la zona habilitada o con el motor en marcha, situaciones prohibidas en cualquier procedimiento.
• Mantener fuentes de ignición activas en el entorno del repostaje.

Comprobación antes de continuar

• Zona habilitada de repostaje
• Motor parado y freno aplicado
• Fuentes de ignición controladas
• Respuesta ante derrames conocida

Idea clave

El repostaje se realiza en zona habilitada y conforme al procedimiento, controlando freno, motor, fuentes de ignición y posibles derrames.$b$ where id = 'dcff3463-9c70-48ec-9f1d-d0b6499d71e1';

update public.lesson_segment_slides set body = $b$Objetivo

Reconocer que el remolcado es una operación autorizada y planificada, nunca una improvisación.

Explicación detallada

El remolcado depende del estado del motor, la dirección y los frenos, y cada modelo tiene requisitos distintos. El proceso correcto pasa por seguir el manual, usar los puntos de enganche previstos y dejar el desbloqueo de frenos en manos de personal competente, con la unidad asegurada.

Aplicación práctica

El remolcado requiere autorización previa de un responsable. Sin ella no se inicia, por muy despejada que parezca la situación.

Errores críticos que deben evitarse

• Improvisar puntos de tiro o de bloqueo sin autorización ni procedimiento, con riesgo de accidente grave para el equipo de recuperación.
• Desbloquear frenos sin personal competente y sin la unidad asegurada.

Comprobación antes de continuar

• Autorización previa del responsable
• Puntos de enganche previstos por el fabricante
• Unidad asegurada antes de cualquier desbloqueo

Idea clave

El remolcado depende del estado de motor, dirección y frenos. No se improvisa: cada modelo tiene requisitos distintos.$b$ where id = '2ef94966-6890-4a5b-952d-d404a278f4eb';

-- Bloque 4 · Técnicas preventivas durante la descarga y el estacionamiento

update public.lesson_segment_slides set body = $b$Objetivo

Aproximarse a la zona de descarga con la trayectoria controlada y una señal que no admita dudas.

Explicación detallada

La aproximación es suave y se ajusta a la señalización, avisando antes de retroceder cuando el procedimiento lo exige, con el señalista visible en todo momento. La trayectoria se controla mediante visión directa y con las ayudas disponibles, cámara trasera, espejo y señalista, todas de forma complementaria. La descarga sólo continúa mientras terreno, alineación, inmovilización y estabilidad permanecen controlados.

Aplicación práctica

Si el señalista deja de ser visible o la señal se vuelve ambigua, la maniobra se detiene hasta recuperar una autorización inequívoca.

Errores críticos que deben evitarse

• Mover la unidad sin señal o sin autorización inequívoca, porque la ambigüedad en la señal equivale a ausencia de señal.
• Sustituir la visión directa por una sola ayuda a la maniobra.

Comprobación antes de continuar

• Señalista visible y señal inequívoca
• Ayudas a la maniobra operativas
• Terreno, alineación e inmovilización controlados

Idea clave

La ambigüedad en la señal equivale a ausencia de señal.$b$ where id = 'c387cee9-e634-4ed9-9a41-41ab20451566';

update public.lesson_segment_slides set body = $b$Objetivo

Verificar la estabilidad antes de elevar la caja y reconocer las señales que obligan a bajarla.

Explicación detallada

Al elevar la caja aumenta la altura del centro de gravedad y con ella el riesgo de vuelco lateral, especialmente si hay pendiente transversal. La condición obligatoria es terreno firme y sin inclinación transversal peligrosa antes de iniciar el basculamiento. Esa condición no se asume: se verifica.

Aplicación práctica

Durante la descarga se vigila la aparición de grietas, material retenido, inclinación o protección insuficiente. Ante cualquiera de ellas, se baja la caja y se reposiciona.

Errores críticos que deben evitarse

• Bascular con la unidad desnivelada o sobre terreno cuya resistencia no está confirmada, porque el vuelco puede ocurrir sin previo aviso.
• Continuar el basculamiento con material retenido en la caja.

Comprobación antes de continuar

• Terreno firme confirmado
• Sin inclinación transversal peligrosa
• Unidad nivelada antes de elevar la caja

Idea clave

Al elevar la caja aumenta la altura del centro de gravedad y el riesgo de vuelco lateral, sobre todo con pendiente transversal.$b$ where id = '50d7562e-27b1-4b9a-a562-e207b77e4d61';

update public.lesson_segment_slides set body = $b$Objetivo

Descargar en bordes de talud y escombrera sólo en zonas autorizadas y con la berma a la vista.

Explicación detallada

El borde puede ceder bajo la carga del eje trasero, con riesgo de vuelco y caída del equipo. El borde que estaba firme ayer puede no serlo hoy. Se utilizan zonas de vertido autorizadas, respetando la señalización, las bermas y las indicaciones del responsable de la zona.

Aplicación práctica

El aspecto visual no es garantía de resistencia. Un borde de escombrera puede parecer sólido y ceder sin aviso, así que la referencia es la autorización de la zona, no la impresión del operador.

Errores críticos que deben evitarse

• Tomar el aspecto sólido del borde como prueba de que resiste.
• Descargar fuera de las zonas de vertido autorizadas.

Comprobación antes de continuar

• Zona de vertido autorizada
• Berma visible y respetada
• Indicaciones del responsable de zona recibidas

Idea clave

El borde de una escombrera puede parecer sólido y ceder sin aviso. El aspecto visual no es garantía de resistencia.$b$ where id = '4252b0dd-9a8c-4bd7-b2ee-251b7fdd8c93';

update public.lesson_segment_slides set body = $b$Objetivo

Usar los topes como lo que son, una referencia de aviso, y no como un sistema de retención.

Explicación detallada

Los topes son referencias de aviso para no seguir retrocediendo. No son un freno ni una garantía de contención del vehículo. El uso correcto consiste en detener la unidad antes de alcanzar el tope: éste indica el límite máximo permitido, no sustituye al sistema de frenada.

Aplicación práctica

Antes de iniciar la maniobra de descarga se comprueba que el tope está visible y en posición correcta. Un tope desplazado es una señal de alerta sobre lo que ha ocurrido en ese punto.

Errores críticos que deben evitarse

• Tratar el tope como barrera de seguridad y apoyarse en él para detener la marcha, cuando puede ceder ante la carga.
• Iniciar la maniobra con el tope desplazado o no visible.

Comprobación antes de continuar

• Tope visible desde la posición de maniobra
• Tope en posición correcta
• Parada prevista antes de alcanzarlo

Idea clave

Los topes son referencias de aviso para no seguir retrocediendo. No son freno ni garantía de contención.$b$ where id = 'cd897614-446b-4058-8ff3-512b59522358';

update public.lesson_segment_slides set body = $b$Objetivo

Descargar sobre tolva de machaqueo con autorización, zona despejada y vertido gradual.

Explicación detallada

Antes de descargar se espera la autorización y se comprueba que la zona está despejada de personas. La tolva debe estar operativa y en condición de recibir carga. La técnica de vertido es gradual, para reducir el riesgo de atascos, especialmente con material de gran tamaño o irregular.

Aplicación práctica

Que la tolva esté libre a la vista no significa que esté operativa. La confirmación es explícita antes de iniciar el vertido.

Errores críticos que deben evitarse

• Iniciar la descarga sin autorización o sin confirmar que la tolva está operativa y puede recibir el material.
• Verter de golpe material de gran tamaño o irregular.

Comprobación antes de continuar

• Alineación correcta
• Unidad inmovilizada
• Zona despejada de personas
• Autorización confirmada

Idea clave

La tolva debe estar operativa y en condición de recibir carga, y eso se confirma antes de descargar.$b$ where id = 'b66cf3af-45d5-40b7-b4c9-8c2c98758b78';

update public.lesson_segment_slides set body = $b$Objetivo

Asumir que los riesgos residuales y las zonas ciegas son propios de cada unidad y hay que conocerlos.

Explicación detallada

Cada modelo mantiene riesgos residuales por diseño, antigüedad o equipamiento, y no son idénticos entre modelos. Las zonas ciegas, en particular, son propias de cada máquina y varían según el equipo, la carga y las condiciones del entorno.

Aplicación práctica

El operador conoce el manual y las limitaciones específicas de su unidad concreta, y mantiene a las personas fuera del área de trabajo. Conocer el propio equipo es responsabilidad suya.

Errores críticos que deben evitarse

• Trasladar a una unidad el mapa de zonas ciegas de otra que se conducía antes.
• Operar sin conocer las limitaciones específicas del modelo asignado.

Comprobación antes de continuar

• Manual y limitaciones de la unidad concreta conocidos
• Zonas ciegas del modelo identificadas
• Personas fuera del área de trabajo

Idea clave

Cada modelo mantiene riesgos residuales por diseño, antigüedad o equipamiento. No son idénticos entre modelos.$b$ where id = 'f3d788e1-5490-4d30-9ef9-f0c7efcfbe1a';

update public.lesson_segment_slides set body = $b$Objetivo

Cerrar la jornada dejando la unidad estacionada y asegurada en la condición prevista.

Explicación detallada

Se estaciona en el terreno lo más llano posible, con la transmisión y el freno en la condición prevista por el fabricante, y se asegura la unidad. El proceso correcto incluye respetar el tiempo de estabilización que indica el fabricante, dejar la caja completamente bajada, apagar el motor correctamente y activar el freno de estacionamiento.

Aplicación práctica

La zona de estacionamiento la designa la explotación. No se elige por proximidad ni por costumbre al terminar el turno.

Errores críticos que deben evitarse

• Estacionar en pendiente sin calzos o sin aplicar todos los sistemas de inmovilización disponibles en la unidad.
• Apagar el motor sin respetar el tiempo de estabilización previsto.

Comprobación antes de continuar

• Terreno lo más llano posible
• Caja completamente bajada
• Motor apagado correctamente
• Freno de estacionamiento activado

Idea clave

Estacionar en terreno lo más llano posible, con transmisión y freno en la condición prevista por el fabricante, y asegurar la unidad.$b$ where id = '070b3bd5-a334-450d-9a48-e901c6814fab';

update public.lesson_segment_slides set body = $b$Objetivo

Estacionar en pendiente sólo cuando puede garantizarse la inmovilización completa.

Explicación detallada

Cuando la pendiente no puede evitarse, se orienta la unidad según el procedimiento, se aplican todos los sistemas de inmovilización y se usan calzos cuando sean necesarios o estén exigidos. El objetivo es impedir cualquier movimiento no intencionado de la unidad durante el tiempo que permanezca estacionada.

Aplicación práctica

Si no puede garantizarse la inmovilización completa en ese punto, no se estaciona allí: se busca otra ubicación.

Errores críticos que deben evitarse

• Confiar únicamente en el freno de estacionamiento sin calzos en pendiente pronunciada.
• Estacionar en un punto donde la inmovilización completa no está garantizada.

Comprobación antes de continuar

• Unidad orientada según procedimiento
• Todos los sistemas de inmovilización aplicados
• Calzos colocados cuando son necesarios o exigidos

Idea clave

Si no puede garantizarse la inmovilización completa, no se estaciona en ese punto.$b$ where id = 'a62ed663-e294-4fcc-8282-b151deb65c83';

update public.lesson_segment_slides set body = $b$Objetivo

Aplicar la regla del bloqueo mecánico siempre que haya que trabajar bajo la caja elevada.

Explicación detallada

Si una intervención exige la caja elevada, se instala el bloqueo mecánico previsto antes de trabajar bajo ella, sin excepción posible. Nunca se confía únicamente en el circuito hidráulico para impedir una bajada imprevista, porque los sistemas hidráulicos pueden fallar.

Aplicación práctica

Sin bloqueo mecánico disponible y verificado, no se trabaja bajo la caja. No se improvisan sustitutos con lo que haya a mano.

Errores críticos que deben evitarse

• Trabajar bajo la caja elevada sin bloqueo mecánico instalado, con riesgo de aplastamiento mortal.
• Sustituir el bloqueo previsto por un apoyo improvisado.

Comprobación antes de continuar

• Bloqueo mecánico previsto disponible
• Bloqueo instalado y verificado
• Ningún sustituto improvisado en uso

Idea clave

Si una intervención exige caja elevada, se instala el bloqueo mecánico previsto antes de trabajar bajo ella. Sin excepción posible.$b$ where id = 'b388248d-028b-48ba-9128-8ba5a807567b';

update public.lesson_segment_slides set body = $b$Objetivo

Entender qué protege cada estructura y por qué una modificación anula esa protección.

Explicación detallada

La estructura ROPS protege al operador frente a vuelco creando un volumen de supervivencia en la cabina durante el accidente. La FOPS protege frente a la caída de objetos desde altura cuando está instalada, y es obligatoria en zonas con riesgo de proyección. El mantenimiento pasa por una revisión visual en cada inspección.

Aplicación práctica

No se modifican mediante soldaduras ni taladros sin autorización expresa del fabricante, por pequeña que parezca la intervención.

Errores críticos que deben evitarse

• Modificar o dañar la estructura ROPS o FOPS, porque invalida su protección y una estructura modificada no garantiza el volumen de supervivencia.
• Operar en zona con riesgo de proyección sin la FOPS instalada.

Comprobación antes de continuar

• Estructuras revisadas visualmente
• Sin soldaduras ni taladros no autorizados
• FOPS instalada donde hay riesgo de proyección

Idea clave

Modificar o dañar la estructura ROPS o FOPS invalida su protección.$b$ where id = 'cb74cc36-a9b4-4077-b022-6647aa821631';

-- Bloque 5 · Control del entorno, interferencias y normativa

update public.lesson_segment_slides set body = $b$Objetivo

Interpretar los tres niveles de aviso del panel y responder a cada uno con la acción que le corresponde.

Explicación detallada

Un aviso informativo señala una situación a supervisar, sin acción inmediata requerida. Un aviso operativo exige corregir la operación y adaptar la conducción sin demora. Un aviso crítico exige detenerse, inmovilizar en lugar seguro y comunicar inmediatamente.

Aplicación práctica

Los pilotos y códigos no son universales. Un mismo símbolo puede significar cosas distintas en máquinas de distinto fabricante o modelo, así que la referencia es el manual de la unidad.

Errores críticos que deben evitarse

• Reiniciar o silenciar el aviso sin identificar la causa.
• Interpretar alarmas por analogía con otra máquina de diferente fabricante o modelo.

Comprobación antes de continuar

• Nivel del aviso identificado
• Causa localizada antes de silenciar
• Alarma crítica: inmovilizar en lugar seguro y comunicar

Idea clave

Ante una alarma de nivel crítico se inmoviliza en lugar seguro y se comunica. No se continúa el ciclo.$b$ where id = '9f017a25-1195-4c2a-ae15-2c138cfcb713';

update public.lesson_segment_slides set body = $b$Objetivo

Usar los sistemas de pesaje como ayuda y mantener la capacidad nominal de la unidad como límite real.

Explicación detallada

Los sistemas de pesaje ayudan a controlar la carga, pero no sustituyen el respeto a la capacidad nominal ni la distribución adecuada en la caja. La sobrecarga modifica el comportamiento dinámico de la unidad y aumenta las exigencias sobre neumáticos, dirección y frenos.

Aplicación práctica

La referencia vinculante es la placa de la máquina, junto con el manual del fabricante y las Disposiciones Internas de Seguridad. La placa manda sobre cualquier cifra recordada del curso.

Errores críticos que deben evitarse

• Convertir una cifra del material formativo en una regla universal para todos los equipos, cuando cada modelo tiene su capacidad nominal.
• Compensar una mala distribución en la caja confiando en el indicador de pesaje.

Comprobación antes de continuar

• Capacidad nominal de la unidad consultada en la placa
• Carga distribuida adecuadamente en la caja

Idea clave

Los sistemas de pesaje ayudan a controlar la carga, pero no sustituyen el respeto a la capacidad nominal ni la distribución adecuada.$b$ where id = '2c98da42-321d-4f36-b211-6b5f88f351af';

update public.lesson_segment_slides set body = $b$Objetivo

Vigilar el estado de la pista de forma continua y comunicar los deterioros que se detecten.

Explicación detallada

Baches, roderas, blandones, piedras y obstáculos afectan a la estabilidad y a los neumáticos, y el estado de la pista varía en cada turno. La obligación del operador es vigilar la pista de forma continua, adaptar la conducción a la condición real y comunicar los deterioros para su corrección inmediata.

Aplicación práctica

La comunicación no es un trámite: es lo que permite corregir el deterioro antes de que afecte al resto de la flota.

Errores críticos que deben evitarse

• Normalizar el mal estado de la pista y no comunicarlo, porque el silencio perpetúa el riesgo para todos los operadores.
• Mantener la conducción habitual sobre una pista que ha empeorado.

Comprobación antes de continuar

• Estado real de la pista valorado en este turno
• Conducción adaptada a esa condición
• Deterioros comunicados para su corrección

Idea clave

Normalizar el mal estado de la pista y no comunicarlo perpetúa el riesgo para todos los operadores.$b$ where id = 'eed1f66d-c46b-48e7-9fc9-8c2c214df1fb';

update public.lesson_segment_slides set body = $b$Objetivo

Aplicar las prioridades de circulación de la explotación y confirmar de forma explícita cada adelantamiento.

Explicación detallada

El sentido de circulación y las prioridades se rigen por las Disposiciones Internas de Seguridad de la explotación, y no se adaptan por analogía con las carreteras convencionales. El adelantamiento sólo procede si está permitido, existen visibilidad y espacio suficientes y la maniobra está coordinada con el otro equipo.

Aplicación práctica

La confirmación entre equipos debe ser explícita. Un gesto interpretado no es una confirmación.

Errores críticos que deben evitarse

• Dar por supuesto que la otra máquina o persona ha visto o entendido la maniobra.
• Aplicar las reglas de una carretera convencional dentro de la explotación.

Comprobación antes de continuar

• Prioridades de la DIS conocidas para ese punto
• Confirmación explícita del otro equipo
• Contacto visual, radio o señal definida mantenido

Idea clave

Dar por supuesto que la otra máquina ha visto la maniobra es un error crítico. La confirmación debe ser explícita.$b$ where id = '7c28ad97-bdae-4bf5-8de1-8b97ae5971f4';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar cualquier duda sobre la posición de una persona como una condición de parada.

Explicación detallada

La incertidumbre sobre una persona o sobre una maniobra equivale a una condición de parada: la duda no se resuelve avanzando. El operador no debe asumir que una persona le ha visto, y aplica de forma activa la separación de rutas, la comunicación y el control de zonas ciegas. Los peatones, por su parte, deben usar itinerarios definidos y elementos de alta visibilidad. Ambas partes son responsables de la separación.

Aplicación práctica

Si hay una persona en el área de trabajo sin confirmación de contacto visual o radio, se detiene y se confirma antes de mover la unidad.

Errores críticos que deben evitarse

• Asumir que una persona ha visto la máquina porque está mirando en su dirección.
• Resolver la duda sobre la posición de alguien continuando la maniobra.

Comprobación antes de continuar

• Contacto visual o por radio confirmado
• Separación de rutas aplicada
• Zonas ciegas controladas de forma activa

Idea clave

La incertidumbre sobre una persona o una maniobra equivale a una condición de parada. La duda no se resuelve avanzando.$b$ where id = '829751ba-6ebe-4901-82d1-c2a72dd09301';

update public.lesson_segment_slides set body = $b$Objetivo

Circular bajo líneas eléctricas aéreas con la caja bajada y el gálibo verificado para esa instalación.

Explicación detallada

En presencia de líneas y estructuras, la caja se mantiene bajada, y el gálibo y las distancias se verifican para la instalación real: no se estiman. El principio seguro combina caja bajada, ruta autorizada, señalización respetada y distancias establecidas según la evaluación, la normativa y las Disposiciones Internas de Seguridad.

Aplicación práctica

Las distancias dependen de la tensión, la geometría y la evaluación de cada instalación eléctrica. No se aplican cifras genéricas recordadas de otra explotación.

Errores críticos que deben evitarse

• Entrar bajo una línea con la caja elevada o sin confirmar el gálibo autorizado para esa instalación concreta.
• Generalizar una distancia de seguridad de una instalación a otra.

Comprobación antes de continuar

• Caja completamente bajada
• Ruta autorizada y señalización respetada
• Gálibo verificado para la instalación real

Idea clave

Con líneas y estructuras, la caja se mantiene bajada y el gálibo se verifica para la instalación real, no se estima.$b$ where id = 'fad244cc-a9b1-4e86-832b-71d4467d931d';

update public.lesson_segment_slides set body = $b$Objetivo

Entender que ROPS y cinturón forman un único sistema y que uno sin el otro no protege.

Explicación detallada

La estructura ROPS crea el volumen de supervivencia y el cinturón mantiene al operador dentro de ese volumen durante un vuelco. Ambos son imprescindibles: sin cinturón, la ROPS no puede proteger al operador en caso de vuelco. Son un sistema integrado, no dos opciones alternativas.

Aplicación práctica

El cinturón va abrochado desde el primer momento, sin excepciones de ningún tipo en ningún ciclo.

Errores críticos que deben evitarse

• No abrocharse el cinturón por comodidad o por tratarse de un trayecto corto, cuando el vuelco no avisa ni respeta la distancia del viaje.
• Considerar que la cabina protege por sí sola sin cinturón abrochado.

Comprobación antes de continuar

• Cinturón abrochado desde el primer momento
• Estructura ROPS sin daños ni modificaciones

Idea clave

Sin cinturón, la ROPS no puede proteger al operador en caso de vuelco. Son un sistema integrado, no opciones alternativas.$b$ where id = '7bcea277-6a63-4209-b6c9-1af02590a14f';

update public.lesson_segment_slides set body = $b$Objetivo

Usar el equipo de protección individual que corresponde a cada situación, dentro y fuera de la cabina.

Explicación detallada

El casco se lleva siempre al abandonar la cabina, sin excepción por lo breve que sea el tiempo fuera. El calzado de seguridad se usa durante toda la jornada en el área de trabajo. La alta visibilidad es imprescindible en cualquier zona compartida con maquinaria. Los guantes y la protección auditiva o visual se determinan según la tarea y la evaluación de riesgos de la explotación.

Aplicación práctica

Los equipos deben estar en buen estado. Un equipo deteriorado no cumple su función aunque se lleve puesto.

Errores críticos que deben evitarse

• Salir de la cabina sin casco por tratarse de una parada breve.
• Tratar el equipo de protección individual como sustituto de los controles técnicos.

Comprobación antes de continuar

• Casco disponible antes de abandonar la cabina
• Calzado de seguridad y alta visibilidad en uso
• Equipos en buen estado

Idea clave

Los EPI deben estar en buen estado. No sustituyen los controles técnicos: son la última barrera.$b$ where id = '7daa26fb-8643-4381-a622-aee1731cfee8';

update public.lesson_segment_slides set body = $b$Objetivo

Conocer el protocolo de emergencia de la explotación antes de necesitarlo y respetar el orden de actuación.

Explicación detallada

El operador debe conocer las vías de evacuación, los responsables de emergencia y el punto de encuentro de la explotación, y debe conocerlos antes de necesitarlos. El protocolo PAS, proteger, avisar y socorrer, se aplica en cualquier emergencia, y el orden es crítico: primero proteger, nunca socorrer sin haber asegurado antes el área.

Aplicación práctica

Cada centro tiene su protocolo específico, recogido en el plan de emergencia y en las Disposiciones Internas de Seguridad.

Errores críticos que deben evitarse

• Mover a un accidentado sin valorar el riesgo de agravar las lesiones, porque el movimiento precipitado puede ser peor que la espera.
• Socorrer antes de haber asegurado el área.

Comprobación antes de continuar

• Vías de evacuación conocidas
• Responsables de emergencia identificados
• Punto de encuentro localizado

Idea clave

El orden del protocolo PAS es crítico: primero proteger, nunca socorrer sin haber asegurado el área.$b$ where id = 'b0d0d726-823e-4d5d-a5ab-b27d3ab9aa7a';

update public.lesson_segment_slides set body = $b$Objetivo

Situar la formación dentro del marco normativo y fijar el criterio que prevalece sobre cualquier presión.

Explicación detallada

El marco aplicable lo componen la Ley 31/1995 de prevención de riesgos laborales, el Real Decreto 1215/1997 sobre equipos de trabajo, el Real Decreto 1389/1997 para la minería a cielo abierto, la ITC 02.1.02, la especificación técnica ET 2000-1-08, el manual del fabricante y las Disposiciones Internas de Seguridad de la explotación. La formación aporta criterio, pero el equipo real y las DIS determinan cómo se ejecuta cada tarea concreta.

Aplicación práctica

La formación de reciclaje actualiza conocimientos. La operación diaria sigue dependiendo de las reglas concretas del centro y de la unidad asignada.

Errores críticos que deben evitarse

• Aplicar el criterio general del curso por encima de la DIS del centro o del manual de la unidad.
• Continuar una operación insegura por presión de producción, plazo o instrucción verbal.

Comprobación antes de continuar

• Marco normativo aplicable conocido
• DIS del centro y manual de la unidad disponibles
• Criterio de parada asumido

Idea clave

Si no se puede realizar la operación de forma segura, la operación se detiene. Este criterio prevalece sobre cualquier presión de producción, plazo o instrucción verbal.$b$ where id = '8d1c3a17-df38-42d2-aeda-ef8b555e1b2c';

do $val$
declare
  plantilla integer;
  sin_idea integer;
  mayusculas integer;
begin
  -- Ningún cuerpo debe conservar el texto de relleno que se repetía en las 50
  -- diapositivas.
  select count(*) into plantilla
  from public.lesson_segment_slides s
  join public.lesson_audio_segments a on a.id = s.segment_id
  join public.lessons l on l.id = a.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'fec849ae-60f8-4f8a-9075-c8927ccaade3'
    and m.position <= 5
    and s.body like '%Esta parte funciona como recordatorio de una competencia ya adquirida%';

  if plantilla > 0 then
    raise exception 'Quedan % diapositivas de transporte 5h con el texto de plantilla', plantilla;
  end if;

  -- Los encabezados deben ir en la forma que reconoce el reproductor.
  select count(*) into mayusculas
  from public.lesson_segment_slides s
  join public.lesson_audio_segments a on a.id = s.segment_id
  join public.lessons l on l.id = a.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'fec849ae-60f8-4f8a-9075-c8927ccaade3'
    and m.position <= 5
    and s.body like '%EXPLICACIÓN DETALLADA%';

  if mayusculas > 0 then
    raise exception 'Quedan % diapositivas de transporte 5h con encabezados en mayúsculas', mayusculas;
  end if;

  select count(*) into sin_idea
  from public.lesson_segment_slides s
  join public.lesson_audio_segments a on a.id = s.segment_id
  join public.lessons l on l.id = a.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'fec849ae-60f8-4f8a-9075-c8927ccaade3'
    and m.position <= 5
    and s.body not like '%Idea clave%';

  if sin_idea > 0 then
    raise exception 'Quedan % diapositivas de transporte 5h sin idea clave', sin_idea;
  end if;
end;
$val$;

commit;
