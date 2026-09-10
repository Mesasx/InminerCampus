-- Deja el reciclaje de 5 h de «Operador de maquinaria de arranque, carga y
-- viales» alineado con su juego definitivo de locuciones y con el manual
-- maestro del que salen esas locuciones.
--
-- Qué estaba desalineado:
--
--   1. El bloque 1 seguía un temario anterior. Sus diez unidades hablaban de
--      fases del transporte, costes y descarga en tolva, mientras que la
--      presentación, el manual y los audios nuevos desarrollan objeto de la
--      formación, tipos de máquina, accesorios, tareas del operador y ciclo de
--      trabajo. Los bloques 2 a 5 ya coincidían.
--   2. Las cincuenta transcripciones procedían de ese mismo temario anterior y
--      no correspondían al guion registrado de cada locución.
--   3. Los cuerpos de diapositiva eran un párrafo suelto de unas cuarenta
--      palabras, sin las secciones que `AudioLessonPlayer` sabe representar.
--
-- Fuente: «Manual maestro · Operador de maquinaria de arranque, carga y viales»
-- (edición técnica 1.0, 2 de septiembre de 2026). Su campo «síntesis de la
-- locución» reproduce el guion registrado en la hoja de producción de cada uno
-- de los cincuenta audios; el propio manual advierte de que la comprobación
-- acústica palabra por palabra exigiría los MP3 originales. En la unidad 4.10 se
-- adopta el título largo del manual, «Manual del fabricante y adecuación al Real
-- Decreto 1215/1997», porque el nombre del fichero de audio lo abrevia.
--
-- Los encabezados se escriben en el formato que reconoce el reproductor:
-- Objetivo, Explicación detallada, Aplicación práctica, Errores críticos que
-- deben evitarse, Comprobación antes de continuar e Idea clave.
--
-- Las diapositivas ya apuntaban a las páginas 2 a 51 de la presentación de
-- arranque, que lleva estos mismos títulos, así que no se tocan sus imágenes.
-- Los ficheros de audio los sube `scripts/sync-arranque-5h-final-audio.mjs`. No
-- se tocan matrículas, progreso ni la modalidad de 20 h.

begin;

-- Bloque 1 · Definición de los trabajos y organización de la maquinaria

update public.lesson_segment_slides set body = $b$Objetivo

Situar la formación inicial dentro del sistema preventivo de la explotación y no como un permiso genérico de manejo.

Explicación detallada

La ITC 02.1.02 regula la formación preventiva mínima de quienes trabajan en centros mineros y señala expresamente al operador de maquinaria de arranque, carga y viales. La ET 2001-1-08 desarrolla ese itinerario para pala cargadora, excavadora hidráulica de cadenas y, desde la modificación de 2014, tractor de cadenas. Alcanza también al personal de contratas y subcontratas, porque la obligación depende de la tarea y de la exposición al riesgo, no de la empresa que figure en la nómina. La finalidad no es enseñar a mover los mandos: es reconocer los peligros de cada operación, aplicar las medidas preventivas y trabajar conforme al manual de la máquina y a las disposiciones internas de seguridad.

Aplicación práctica

Antes de trabajar, el operador identifica mandos, indicadores, capacidades, limitaciones de pendiente, puntos de izado y amarre, sistema de acoplamiento, advertencias y procedimientos de emergencia del modelo asignado. La experiencia con un equipo parecido ayuda, pero no sustituye esa familiarización.

Errores críticos que deben evitarse

• Tratar la acreditación del curso como autorización para manejar cualquier máquina o accesorio.
• Improvisar cuando dos instrucciones parecen incompatibles, en lugar de dejar el equipo en condición segura y pedir aclaración.

Comprobación antes de continuar

• Manual del equipo, evaluación de riesgos y DIS conocidos
• Autorización vigente para la máquina y los accesorios asignados
• Criterio de parada segura identificado

Idea clave

La formación habilitante se refiere al puesto y debe adaptarse siempre a la máquina, al centro y a la tarea real; no es un permiso genérico para operar cualquier equipo.$b$ where id = 'ed0449de-2629-4025-b4f0-c8d159c19f20';

update public.lesson_segment_slides set body = $b$Objetivo

Leer el movimiento de tierras como un proceso encadenado en el que cada fase condiciona la siguiente.

Explicación detallada

El arranque separa el material del macizo o del terreno natural; la carga lo transfiere a un medio de transporte; el transporte lo desplaza por pistas y accesos; y la descarga lo deposita en una tolva, acopio, escombrera o zona de relleno. Según el objetivo pueden añadirse extendido, nivelación, compactación, perfilado y refino. No todas las máquinas intervienen igual: la excavadora puede arrancar y cargar desde una posición fija, la pala combina penetración, llenado y desplazamiento, y el tractor de cadenas empuja, ripa, extiende o conforma. Un bloque de tamaño excesivo impide el llenado estable de la cuchara o daña la caja del vehículo, y una carga descentrada altera el comportamiento del transporte.

Aplicación práctica

El operador observa durante el turno cómo cambia la zona: crecimiento del acopio, roderas, derrames, agua, tránsito de terceros o variaciones del frente. Esos cambios se comunican aunque la máquina propia todavía pueda continuar, porque afectan a quien interviene después.

Errores críticos que deben evitarse

• Analizar solo la maniobra visible, sin ver que muchas causas de vuelco o derrame se originan en la fase anterior.
• Acortar ciclos elevando velocidades, girando con el implemento alto o reduciendo distancias de separación.

Comprobación antes de continuar

• Material, recorrido y punto de descarga conocidos
• Zonas de cruce y presencia de personas o equipos identificadas
• Estado de la plataforma y de la pista valorado en este ciclo

Idea clave

La seguridad del movimiento de tierras depende de la continuidad entre fases: cada operador entrega a la siguiente máquina un material, una ruta y un entorno previsibles.$b$ where id = 'e6f67aa3-84e1-48b8-901d-81c9e4abada7';

update public.lesson_segment_slides set body = $b$Objetivo

Elegir el método de arranque según el material y las capacidades reales del equipo, nunca por costumbre.

Explicación detallada

La roca competente, el terreno ripable y los materiales sueltos no responden del mismo modo. La dureza informa sobre la resistencia a la penetración, la fracturación indica la posibilidad de separar bloques, la humedad modifica cohesión y apoyo, y la abrasividad condiciona el desgaste de dientes, cuchillas y orugas. La voladura corresponde a roca que necesita fragmentación con explosivos y debe ser diseñada y ejecutada por personal autorizado; tras ella no se entra automáticamente, sino que se respeta el procedimiento de comprobación, se controla la existencia de barrenos fallidos y se inspecciona el frente. El ripado usa el escarificador del tractor con pasadas y profundidad compatibles con la potencia y la adherencia.

Aplicación práctica

El arranque mecánico con cuchara, ripper o martillo solo es admisible si la máquina y el accesorio están previstos para ello, comprobando masa, presión, caudal, acoplamiento y limitaciones de alcance. Ante vibraciones anormales, golpes metálicos, hundimiento de apoyos o fisuras nuevas se retira el implemento de forma controlada y se comunica.

Errores críticos que deben evitarse

• Usar la cuchara como martillo o forzar lateralmente el balancín, con daño estructural y pérdida de control.
• Probar la estabilidad golpeando repetidamente un frente incierto desde una posición expuesta.

Comprobación antes de continuar

• Método aprobado por la dirección facultativa para ese material
• Frente inspeccionado, sin voladizos ni material colgado
• Vía de retirada y zona de exclusión conservadas

Idea clave

El método de arranque se aprueba antes de operar; la máquina no debe emplearse para compensar una caracterización deficiente del terreno ni para superar sus límites de diseño.$b$ where id = '17fbd61c-106a-4e75-b912-4f7afaee5017';

update public.lesson_segment_slides set body = $b$Objetivo

Operar la pala sabiendo que su maniobrabilidad y su articulación son también su fuente de riesgo.

Explicación detallada

La pala cargadora es una máquina autopropulsada, normalmente sobre ruedas, con equipo frontal que carga mediante el avance de la propia máquina. El centro de gravedad se desplaza hacia delante y hacia arriba al elevar el cucharón, y con la máquina articulada el polígono de apoyo cambia, de modo que un giro brusco, una pendiente transversal o un bache reducen el margen de estabilidad. La articulación crea una zona de aplastamiento entre semibastidores a la que nadie debe acceder mientras exista posibilidad de movimiento. La capacidad nominal del cucharón no equivale siempre a una carga segura, porque el peso varía con la densidad del material.

Aplicación práctica

La penetración se hace con los bastidores razonablemente alineados y el cucharón en posición adecuada, sin atacar el acopio en giro, porque forzar una esquina genera cargas laterales, deslizamiento y desgaste. En la descarga sobre camión se adopta una posición conocida por ambos operadores y la cuchara no se desplaza innecesariamente sobre la cabina.

Errores críticos que deben evitarse

• Circular con el cucharón elevado o girar sin haber reducido antes la velocidad.
• Socavar un frente que pueda caer sobre la cabina al recoger material.

Comprobación antes de continuar

• Equipo bajo y en la posición indicada por el fabricante para desplazarse
• Bastidores alineados antes de penetrar en el acopio
• Entorno comprobado y aviso emitido antes de retroceder

Idea clave

La pala es más estable cuando circula con el equipo bajo, gira a velocidad reducida y trabaja con los bastidores alineados en la penetración.$b$ where id = '51ac4415-1f64-4554-b958-a54ed209c8b8';

update public.lesson_segment_slides set body = $b$Objetivo

Controlar apoyo, orientación y radio de giro antes de excavar con la base inmóvil.

Explicación detallada

La excavadora hidráulica de cadenas trabaja normalmente con la base inmóvil mientras la superestructura gira trescientos sesenta grados, y el contrapeso describe una trayectoria que puede quedar fuera del campo visual del operador. El tren de cadenas distribuye el peso sobre el terreno, lo que mejora el apoyo frente a superficies puntuales, pero no convierte en seguro un relleno débil, una zanja oculta o un borde erosionado. La orientación del tren respecto a la carga influye en el margen de estabilidad, y extender al máximo la pluma para ganar unos centímetros reduce capacidad y control. Las tablas del fabricante deben interpretarse para la posición real, el radio y la altura de trabajo.

Aplicación práctica

El radio de giro es una zona de exclusión continua que incluye contrapeso, pluma, balancín, herramienta y posibles oscilaciones de la carga. Para cargar un vehículo se fija una posición que minimice el giro y mantenga la cabina fuera de la trayectoria.

Errores críticos que deben evitarse

• Trabajar con parte del tren suspendido o sobre un borde no consolidado.
• Improvisar una elevación de cargas con dientes o conexiones no diseñadas para izar.

Comprobación antes de continuar

• Capacidad portante y nivelación de la plataforma examinadas
• Cadenas apoyadas por completo y orientación conforme al manual
• Radio de giro delimitado e impedido el acceso de personas

Idea clave

La estabilidad de la excavadora depende del apoyo, la orientación, el radio y la carga; la segregación debe abarcar también el contrapeso y toda la trayectoria del implemento.$b$ where id = 'cca95302-9afc-4642-8392-90b0827f18f0';

update public.lesson_segment_slides set body = $b$Objetivo

Aprovechar la tracción del tractor sin confundirla con inmunidad frente al vuelco o al hundimiento.

Explicación detallada

El tractor de cadenas transmite una elevada fuerza de empuje y tracción a través de su tren de rodaje, y puede equiparse con hojas de distintas geometrías y, en la parte trasera, con escarificador o cabestrante cuando esté previsto. Las cadenas aumentan la superficie de contacto, pero la adherencia depende del material, la humedad, la pendiente y el estado de tejas y garras: el deslizamiento lateral puede iniciarse de forma progresiva y acelerarse cuando el terreno se rompe. La hoja no es una protección frente a caídas de bloques ni un punto universal de apoyo. En ripado, una púa enganchada puede producir un cambio brusco de dirección o una elevación parcial del tren.

Aplicación práctica

El empuje se efectúa con una cantidad de material que permita mantener dirección y tracción, porque una carga excesiva aumenta el patinamiento y puede hacer que el tractor pivote hacia el lado de menor resistencia. En conformación de bancos o escombreras, el borde puede estar construido con material reciente y no consolidado.

Errores críticos que deben evitarse

• Girar en cerrado mientras el útil está sometido a gran esfuerzo, o desplazarse transversalmente por una pendiente sin necesidad.
• Acercarse al borde basándose solo en la apariencia superficial, o usar la berma como freno.

Comprobación antes de continuar

• Pendiente máxima permitida por el fabricante conocida
• Ausencia de personas delante y en los laterales de la trayectoria
• Distancia a la coronación fijada por la evaluación y las DIS

Idea clave

La capacidad de tracción del tractor no elimina los límites del terreno: pendiente, borde, adherencia y esfuerzos del implemento deben evaluarse antes de cada pasada.$b$ where id = '49d9a7d6-7285-4caf-9b9b-bda5e39ef188';

update public.lesson_segment_slides set body = $b$Objetivo

Entender que la máquina segura es la combinación autorizada de base y accesorio, no cada pieza por separado.

Explicación detallada

La ET distingue la máquina base, entendida sin los equipos que cumplen la función prevista, del conjunto montado para ejecutar esa función y de los accesorios desmontables. Esa clasificación evita un error habitual: suponer que todo lo que puede fijarse mecánicamente es automáticamente válido. Una cuchara de mayor volumen puede superar la masa admisible con material denso; un martillo necesita caudal, presión y línea de retorno adecuados; unas horquillas cambian el modo de calcular la capacidad. El peso y la distancia del accesorio desplazan el centro de gravedad, la longitud adicional aumenta el radio de giro y crea nuevas zonas ciegas, y las conexiones hidráulicas incorporan energía acumulada y riesgo de proyección.

Aplicación práctica

El operador reconoce la configuración activa antes de arrancar, porque la pantalla o el sistema de control puede requerir seleccionar el accesorio para ajustar presión y respuesta. Tras el montaje se comprueba el indicador de bloqueo y se prueba cerca del suelo, en zona despejada y sin nadie en la trayectoria.

Errores críticos que deben evitarse

• Trabajar confiando en que el enganche parece cerrado, sin la comprobación visual y funcional prevista.
• Continuar con un pasador parcialmente introducido, una manguera torsionada o una placa ilegible.

Comprobación antes de continuar

• Accesorio autorizado por el fabricante o evaluado técnicamente
• Bloqueo verificado y prueba a baja altura realizada
• Tablas de carga y limitaciones vigentes para esa configuración

Idea clave

La configuración segura es la combinación autorizada de máquina y accesorio; la compatibilidad física por sí sola no acredita capacidad ni seguridad.$b$ where id = 'f62d93ae-fae1-4027-a995-d146f96a7164';

update public.lesson_segment_slides set body = $b$Objetivo

Delimitar lo que corresponde al operador durante el turno y dónde empieza el personal competente.

Explicación detallada

Al iniciar el turno el operador recibe la orden de trabajo, revisa incidencias previas y comprueba la máquina y su entorno; durante la operación vigila indicadores, comportamiento, terreno y presencia de terceros; al terminar estaciona, apoya el equipo, neutraliza mandos, aplica freno y asegura conforme al manual. Las tareas básicas autorizadas suelen incluir limpieza, engrase o comprobaciones definidas por el fabricante y la empresa, y no incluyen desmontar componentes presurizados, puentear sensores, ajustar sistemas de seguridad ni trabajar bajo un equipo elevado sin soporte mecánico. La observación debe ser activa: cambios de ruido, vibración, temperatura, deriva o esfuerzo de dirección pueden preceder a un fallo.

Aplicación práctica

Cuando el operador describe con precisión cuándo aparece el síntoma y bajo qué carga, facilita un diagnóstico correcto. La decisión de reparar o autorizar un uso limitado corresponde a personal competente y queda documentada con medidas concretas.

Errores críticos que deben evitarse

• Normalizar una fuga pequeña, una alarma ocasional o un freno con más recorrido porque la máquina sigue funcionando.
• Ocultar una incidencia por presión productiva en lugar de registrarla y comunicarla.

Comprobación antes de continuar

• Incidencias del turno anterior revisadas
• Defectos detectados registrados con su condición de aparición
• Tarea dentro del alcance autorizado al operador

Idea clave

Operar es observar, decidir y comunicar durante todo el turno; el manejo de mandos es solo una parte de la función preventiva.$b$ where id = '60e4e60b-a4ad-4bce-afb9-a78e298110c3';

update public.lesson_segment_slides set body = $b$Objetivo

Integrar orden de trabajo, DIS, evaluación de riesgos y manual antes de poner la máquina en movimiento.

Explicación detallada

Una orden eficaz identifica tarea, ubicación, material, máquina y accesorio, resultado esperado, secuencia, rutas, punto de carga o descarga, interferencias, comunicaciones y responsables, e incluye las condiciones que obligan a detener o a pedir nueva autorización. Instrucciones genéricas como «limpiar el frente» son insuficientes cuando hay bordes, líneas eléctricas, tráfico o terreno alterado. El Reglamento General permite que la dirección facultativa establezca Disposiciones Internas de Seguridad; una vez aprobadas son de obligado cumplimiento y regulan circulación, velocidades, prioridades, señalización, comunicaciones, trabajo en frentes, vertido, mantenimiento, recuperación y respuesta ante emergencias. No sustituyen al manual ni amplían las capacidades técnicas del equipo.

Aplicación práctica

El operador contrasta la orden con el escenario visible: accesos, señalización, pendientes, estado del terreno, iluminación, meteorología, personas y equipos. Si el equipo asignado, el accesorio o las condiciones no coinciden, lo comunica antes de comenzar.

Errores críticos que deben evitarse

• Resolver con una maniobra improvisada una desviación entre la orden y la realidad del terreno.
• Apoyarse en una costumbre informal cuando contradice una instrucción escrita vigente.

Comprobación antes de continuar

• Orden clara y autorización para el equipo concreto
• DIS aplicables al puesto conocidas y vigentes
• Coordinación con contratas y actividades simultáneas resuelta

Idea clave

La orden de trabajo y las DIS convierten la prevención general en reglas concretas; si la realidad se aparta de ellas, se detiene y se replantea.$b$ where id = 'e2bc0d31-3455-453d-af31-ca6dbe6fcf51';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar el ciclo como el sistema preventivo en sí, y no como una tarea con una comprobación añadida.

Explicación detallada

Un ciclo seguro coordina persona, máquina, material y entorno antes, durante y después de cada maniobra. Antes se define el objetivo, se reconoce la zona, se ajustan asiento y espejos, se abrocha el cinturón y se anticipa la trayectoria del implemento y del contrapeso, el espacio de frenado y la vía de escape. Durante se conservan velocidad, carga, alcance y trayectoria dentro de márgenes que permitan corregir sin brusquedad, y la atención alterna entre implemento, ruta, personas, receptor de la carga y panel. Los márgenes también son espaciales: zona de exclusión, distancia a bordes y separación entre equipos deben absorber errores previsibles y movimientos inesperados.

Aplicación práctica

Al finalizar, el operador deposita la carga, apoya el equipo, se retira de zonas inestables y estaciona según el procedimiento, dejando plataforma, acceso o acopio compatibles con la siguiente operación. Tiempos de espera, maniobras cruzadas, frenadas frecuentes o avisos constantes señalan una organización que conviene ajustar.

Errores críticos que deben evitarse

• Trabajar al límite geométrico o de capacidad, cuando una maniobra que solo es segura con precisión absoluta no está controlada.
• Medir la productividad por la velocidad de cada movimiento en lugar de por la uniformidad del flujo.

Comprobación antes de continuar

• Escenario del ciclo conocido y máquina adecuada a la tarea
• Personas fuera del entorno y vía de escape disponible
• Zona entregada en condiciones para el siguiente equipo

Idea clave

Cada ciclo debe comenzar con un escenario conocido, mantenerse dentro de márgenes y terminar dejando condiciones seguras para la siguiente operación.$b$ where id = 'b452849f-c694-40b3-ad0e-5f3d8c699357';

-- Bloque 2 · Técnicas preventivas antes de comenzar el trabajo

update public.lesson_segment_slides set body = $b$Objetivo

Confirmar que la persona está apta, informada y equipada antes de acceder a la máquina.

Explicación detallada

La actividad exige atención sostenida, coordinación y decisiones rápidas. La falta de sueño, el estrés intenso, una enfermedad aguda o los efectos de alcohol, drogas y determinados medicamentos reducen la percepción, el tiempo de reacción y el juicio. La fatiga también aparece durante el turno por calor, vibración, monotonía o jornada prolongada, y se manifiesta en pérdida de concentración, correcciones tardías, irritabilidad y olvidos. El Real Decreto 773/1997 establece que el equipo de protección individual se emplea frente a los riesgos que no han podido evitarse o limitarse por protección colectiva u organización: una mascarilla no reemplaza el control del polvo ni un chaleco permite mezclar peatones y maquinaria sin segregación.

Aplicación práctica

Los EPI deben ser adecuados al riesgo, compatibles entre sí y ajustados al usuario. Un protector auditivo que impide oír señales críticas obliga a revisar el sistema de comunicación, y los guantes que protegen en una inspección pueden ser peligrosos cerca de partes giratorias.

Errores críticos que deben evitarse

• Sustituir el descanso por ventilación o música cuando la atención ya no puede mantenerse.
• Subir con herramientas u objetos sueltos que puedan caer, bloquear un pedal o convertirse en proyectiles.

Comprobación antes de continuar

• Aptitud física y mental compatible con el turno
• EPI seleccionados según evaluación, en buen estado y bien guardados
• Ropa ajustada, sin colgantes, y calzado limpio de barro o grasa

Idea clave

El EPI es la última barrera; la primera condición de seguridad es que la persona esté apta, informada y equipada para el riesgo real.$b$ where id = 'cd183281-4620-469f-97b2-cef2a2f968b5';

update public.lesson_segment_slides set body = $b$Objetivo

Descubrir desde el suelo los defectos que no se ven desde la cabina, antes de presurizar nada.

Explicación detallada

La revisión comienza a distancia, observando inclinación anormal, manchas en el suelo, piezas caídas, daños recientes y presencia de personas, y después recorre la máquina en el mismo sentido cada día para reducir olvidos. Se comprueban accesos, pasamanos, cristales, espejos, luces, cámaras, extintor, señalización, resguardos, pasadores, mangueras, cilindros y neumáticos o tren de cadenas. El método se adapta al equipo: en una pala se atiende a articulación, neumáticos, cucharón y bloqueo; en la excavadora, a tren de rodaje, rodillos, orugas, giro, pluma y acoplamiento; en el tractor, a tejas, rodillos, hoja, escarificador y posibles cables. Una máquina sin defectos puede seguir siendo insegura si está estacionada sobre un terreno que ha cedido.

Aplicación práctica

Bajo la máquina se observan manchas recientes de combustible, aceite, refrigerante o fluido hidráulico, siempre con medios adecuados y nunca con la mano, porque una fuga a presión puede penetrar la piel. El parte registra fecha, máquina, horas, defecto, localización, condición de aparición y acción adoptada.

Errores críticos que deben evitarse

• Pasar bajo un implemento suspendido durante la vuelta de inspección.
• Decidir por apariencia que una fisura es superficial en lugar de etiquetar y pedir inspección competente.

Comprobación antes de continuar

• Perímetro recorrido completo con la máquina inmovilizada
• Herramienta o accesorio apoyado y sin deformaciones evidentes
• Cada punto de la lista resuelto como apto, a vigilar o fuera de servicio

Idea clave

La inspección perimetral es una decisión de puesta en servicio: cualquier defecto de seguridad debe quedar comunicado y resuelto antes de operar.$b$ where id = 'ecf80587-c1a7-41aa-9aca-06542af842be';

update public.lesson_segment_slides set body = $b$Objetivo

Comprobar niveles y circuitos sabiendo que el motor parado no significa energía eliminada.

Explicación detallada

Cada nivel se verifica en la condición que indica el fabricante: terreno nivelado, motor frío o a determinada temperatura, implemento apoyado y tiempo de espera tras la parada. Medir en otra condición produce lecturas falsas y llenados excesivos. El sistema hidráulico puede conservar presión en acumuladores, cilindros y tramos bloqueados aun con el motor detenido, y el implemento puede descender por gravedad o por pérdida interna. Aflojar un racor para comprobar si queda presión es una práctica peligrosa: la fuga fina puede ser casi invisible y causar una lesión grave por inyección. Abrir un tapón presurizado en caliente puede producir ebullición súbita y proyección.

Aplicación práctica

Una bajada repetida de nivel no se resuelve añadiendo fluido: puede indicar fuga externa, consumo interno o comunicación entre circuitos, y debe registrarse la tendencia y pedir diagnóstico. Al repostar se detiene el motor, se evita cualquier fuente de ignición y se controla el derrame.

Errores críticos que deben evitarse

• Buscar una fuga hidráulica con la mano o abrir en caliente un tapón de refrigerante.
• Dar la máquina por segura tras limpiar la mancha sin eliminar la causa.

Comprobación antes de continuar

• Máquina en la posición que indica el manual para medir
• Mangueras sin abrasión, abultamiento, torsión ni envejecimiento
• Origen de cualquier pérdida localizado y comunicado

Idea clave

Motor parado no significa energía eliminada: presión, temperatura y gravedad deben controlarse antes de abrir, limpiar o intervenir.$b$ where id = 'eee53940-8c63-4267-847a-61ad03c29ed6';

update public.lesson_segment_slides set body = $b$Objetivo

Leer el sistema de rodaje y el terreno como un único contacto dinámico.

Explicación detallada

En la pala se comprueban presión según procedimiento, cortes, grietas, desprendimientos, objetos incrustados, desgaste, válvulas, llantas y fijaciones; la presión incorrecta modifica huella, calentamiento y capacidad. Los neumáticos de gran tamaño almacenan mucha energía, de modo que inflado, desmontaje y reparación corresponden a personal y equipos especializados. En máquinas de cadenas se revisan tejas, pernos, eslabones, rodillos, ruedas guía, rueda motriz, protectores y tensión conforme al fabricante: demasiado tensa aumenta desgaste y esfuerzos, demasiado floja puede salirse. El desgaste desigual puede revelar desalineación, trabajo frecuente en una dirección o terreno abrasivo.

Aplicación práctica

La presión media sobre el suelo no describe por sí sola la estabilidad: un relleno puede tener costra resistente sobre material saturado y una cuneta cubierta puede colapsar bajo una rueda. El recorrido previo identifica blandones, socavaciones y bordes; si hay duda se solicita evaluación o acondicionamiento.

Errores críticos que deben evitarse

• Situarse frente a la trayectoria probable de proyección de la llanta o del neumático.
• Retirar piedras atrapadas o limpiar el tren de rodaje sin la máquina parada y asegurada.

Comprobación antes de continuar

• Presión, cortes, llantas y fijaciones revisados en la pala
• Tejas, rodillos, ruedas y tensión conforme al fabricante en cadenas
• Terreno del recorrido reconocido antes de aproximar la máquina

Idea clave

El sistema de rodaje es parte de la seguridad de la máquina; sus defectos y el terreno deben evaluarse como un único contacto dinámico.$b$ where id = '98e7b040-528b-4dc4-8c63-c212a7d8acf4';

update public.lesson_segment_slides set body = $b$Objetivo

Inspeccionar el implemento y su circuito asumiendo que todo lo elevado puede descender.

Explicación detallada

El equipo de trabajo transforma la energía hidráulica en movimiento y fuerza, y sus cargas son elevadas. Se observan dientes, cuchillas, esquinas, soldaduras, placas de desgaste, orejetas, bulones, pasadores y seguros, porque una pieza suelta puede proyectarse o caer sobre el vehículo receptor. En pluma, balancín, hoja y brazos se buscan deformaciones, rozaduras y holguras; los cilindros se revisan por fugas y vástagos dañados; las mangueras no deben estar pellizcadas, torcidas ni expuestas al roce. Los acumuladores mantienen presión para funciones específicas y requieren descarga controlada, y las válvulas de retención, limitadores y bloqueos no se puentean.

Aplicación práctica

Tras la inspección los movimientos se prueban con carga mínima, cerca del suelo y a temperatura de servicio, observando respuesta, retención de posición, alarmas y estabilidad. Si un movimiento es errático, lento o deriva, se detiene y se diagnostica.

Errores críticos que deben evitarse

• Situarse bajo un equipo elevado sin bloqueo mecánico certificado, o sustituirlo por tacos improvisados.
• Aumentar la presión para levantar una carga que la máquina no controla.

Comprobación antes de continuar

• Soldaduras, pasadores, bulones, dientes y retenedores sin fisuras ni desplazamientos
• Latiguillos sin rozaduras, ampollas ni alambres expuestos
• Presión residual descargada antes de cualquier intervención

Idea clave

Todo implemento elevado debe considerarse capaz de descender; el apoyo, el bloqueo y la descarga de energía preceden a cualquier intervención.$b$ where id = '91230ea1-2cc2-40f1-bdd8-cd4fe917f5fe';

update public.lesson_segment_slides set body = $b$Objetivo

Evitar la caída al subir y bajar, y dejar el puesto ajustado para controlar la máquina todo el turno.

Explicación detallada

Muchas lesiones ocurren al subir o bajar, no durante la operación principal. Se asciende de frente a la máquina manteniendo tres puntos de apoyo, con dos manos y un pie o dos pies y una mano en contacto, usando solo peldaños, plataformas y pasamanos diseñados. No se utiliza el volante, una palanca, la oruga, el neumático o una manguera como apoyo. El asiento se regula en distancia, altura, peso o suspensión para alcanzar pedales y mandos sin estirar el cuerpo, porque una postura forzada aumenta la fatiga y reduce la precisión. El cinturón se relaciona directamente con la ROPS: mantiene al operador dentro del volumen protegido.

Aplicación práctica

Los espejos se ajustan desde la posición real de conducción, ya que hacerlo desde otra postura deja zonas sin cubrir. La preparación de cabina termina con una prueba de claxon y avisos, porque una señal descubierta como inoperativa al iniciar la maniobra ya ha reducido el margen preventivo.

Errores críticos que deben evitarse

• Saltar desde la cabina, aunque la altura parezca pequeña.
• Improvisar con cajones o escalas sueltas cuando el acceso de la máquina está dañado.

Comprobación antes de continuar

• Peldaños y asideros íntegros y limpios de barro, grasa o hielo
• Asiento, reposabrazos, espejos y mandos ajustados y objetos sueltos retirados
• Cinturón abrochado y salida de emergencia localizada y libre

Idea clave

El acceso seguro evita caídas y el ajuste de cabina permite usar cinturón, mandos y visión sin fatiga ni posturas que retrasen la respuesta.$b$ where id = 'fc1acb6d-ec08-48c2-88c1-8cdc65f7bf3b';

update public.lesson_segment_slides set body = $b$Objetivo

Probar las funciones críticas en zona despejada antes de entrar en producción.

Explicación detallada

El motor se arranca únicamente desde el puesto del operador, con cinturón colocado, mandos neutralizados y freno aplicado, observando el autodiagnóstico y comprobando que los testigos se encienden y apagan según el manual. La prueba de freno de servicio, de estacionamiento y, cuando proceda, de emergencia se hace en una zona con superficie y espacio suficientes, a velocidad reducida y sin personas, verificando capacidad de detener y mantener la máquina, recorrido del mando y ausencia de desviaciones. La dirección se prueba en ambos sentidos observando holgura, esfuerzo y respuesta, y en palas articuladas sin que nadie esté en la articulación.

Aplicación práctica

En excavadoras se comprueban el bloqueo hidráulico y el freno o control de giro; en palas, la dirección de emergencia cuando proceda, porque su disponibilidad puede depender de presión o energía auxiliar. Los mandos del implemento se prueban lentamente, confirmando que el sentido y la respuesta corresponden a la configuración seleccionada.

Errores críticos que deben evitarse

• Anular o silenciar una alarma para seguir trabajando en lugar de identificar su causa.
• Probar los frenos por primera vez al aproximarse a una pendiente, una tolva o un vehículo.

Comprobación antes de continuar

• Panel y alarmas observados mientras el motor alcanza condiciones
• Frenos, dirección y mandos del equipo probados a baja velocidad
• Bocina, avisador de retroceso, luces y limpiaparabrisas operativos

Idea clave

Frenos y dirección se comprueban antes de necesitarlos: la primera prueba nunca debe producirse frente a una pendiente, un borde o un obstáculo.$b$ where id = '75876829-4441-455b-b122-c1d9e37fb7bf';

update public.lesson_segment_slides set body = $b$Objetivo

Separar, bloquear, disipar y verificar toda energía antes de acceder a una zona peligrosa.

Explicación detallada

El operador realiza solo las tareas previstas para su puesto: comprobaciones, limpieza, engrase o reposiciones autorizadas. Parar el motor y retirar la llave puede no eliminar la gravedad, la presión hidráulica, los acumuladores, la tensión eléctrica, la temperatura ni la posibilidad de movimiento por pendiente. La consignación comprende separar la máquina de las fuentes, bloquear los dispositivos de separación, disipar o contener la energía acumulada y verificar que no queda energía peligrosa. La verificación es indispensable: se comprueba la presión y se confirma que el equipo no puede moverse. Las piezas sostenidas solo por presión hidráulica no se consideran aseguradas.

Aplicación práctica

Si existe riesgo de movimiento se colocan calzos, bloqueo de articulación, soporte del equipo o bloqueo de giro según el modelo. Al terminar se retiran herramientas, se montan los resguardos, se comprueba que todas las personas están fuera y cada responsable retira su bloqueo conforme a la secuencia.

Errores críticos que deben evitarse

• Confiar en un cartel sin aislamiento físico, o retirar el medio de bloqueo de otra persona sin procedimiento.
• Elevar la máquina o el implemento apoyándose únicamente en los cilindros hidráulicos.

Comprobación antes de continuar

• Terreno firme, equipo apoyado, freno aplicado y llave retirada o controlada
• Energías separadas, bloqueadas, disipadas y verificadas
• Protecciones repuestas antes del arranque

Idea clave

La consignación no termina al apagar: hay que separar, bloquear, disipar y verificar todas las energías antes de acceder a una zona peligrosa.$b$ where id = 'e6f01f65-97ef-4946-baab-0efa85b16441';

update public.lesson_segment_slides set body = $b$Objetivo

Cambiar el accesorio con secuencia, zona despejada y una verificación que no dependa de la apariencia.

Explicación detallada

El cambio de accesorios concentra riesgos de caída, atrapamiento, liberación hidráulica y montaje incompleto. Se confirma que el accesorio está autorizado para el modelo y la configuración, que su masa y capacidades son conocidas y que no presenta daños; la zona de cambio se nivela, se delimita y se libera de personas, y el accesorio se apoya en posición estable para que no vuelque al desacoplarse. La presión hidráulica se libera antes de manipular conexiones, se evita contaminar conectores y se colocan tapones. Un conector que no coincide no se adapta con piezas improvisadas ni se fuerza con golpes.

Aplicación práctica

El operador conoce cómo cambia la máquina tras el montaje: capacidad, centro de gravedad, caudal, presión, modo de control, visibilidad y radio. La primera operación productiva se realiza con carga conservadora para observar la respuesta.

Errores críticos que deben evitarse

• Dar por bueno el enganche porque el accesorio parece sostenerse, sin la inspección directa.
• Introducir las manos entre componentes que puedan moverse durante el posicionamiento.

Comprobación antes de continuar

• Superficie estable, zona delimitada y sin personas
• Pasadores o indicadores de bloqueo en la posición correcta
• Prueba funcional próxima al suelo, con nadie en la trayectoria

Idea clave

Después de acoplar, se verifica visualmente y se prueba cerca del suelo; la apariencia de sujeción no demuestra que el bloqueo esté completo.$b$ where id = '6b0a3901-d016-4d80-a230-dab52a5f153b';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar embarque, remolcado y recuperación como maniobras específicas y planificadas.

Explicación detallada

Antes de embarcar se verifica capacidad del transporte, estado y pendiente de rampas, anchura, resistencia del terreno, gálibo y ausencia de obstáculos; la góndola se inmoviliza y apoya según su diseño, y las rampas se limpian y alinean. El ascenso se hace a velocidad mínima, sin cambios bruscos, y una vez situado el equipo se apoya, se neutraliza, se frena y se detiene, fijando los amarres en los puntos definidos por el fabricante. El remolcado solo se realiza si el manual lo permite y con el método indicado, conociendo masa, estado de frenos y dirección, pendiente, distancia y capacidad del vehículo tractor. Una máquina averiada puede no conservar dirección ni frenado.

Aplicación práctica

Una máquina hundida, volcada o atrapada introduce terreno inestable y cargas difíciles de estimar: primero se estabiliza, se determina la dirección probable y se decide si hace falta una empresa especializada. Tras recuperarla no vuelve directamente a servicio, sino que se inspeccionan estructura, fluidos, frenos, dirección y sistemas de seguridad.

Errores críticos que deben evitarse

• Usar puntos de izado, dientes o componentes del implemento como anclajes de tiro sin autorización expresa.
• Permanecer entre equipos, sobre el cable o dentro de la trayectoria de latigazo.

Comprobación antes de continuar

• Plan de maniobra con una única persona dirigiendo
• Elementos certificados y puntos de amarre previstos por el fabricante
• Zona de latigazo despejada y tensión aplicada de forma progresiva

Idea clave

Las operaciones de transporte y recuperación se diseñan como maniobras específicas; los puntos de anclaje y la zona de latigazo nunca se improvisan.$b$ where id = '7fab83a8-2b71-4992-b632-8e641f25e7dd';

-- Bloque 3 · Técnicas preventivas durante la operación

update public.lesson_segment_slides set body = $b$Objetivo

Poner la máquina en servicio de forma gradual y comprobar que responde antes de aplicar carga.

Explicación detallada

El motor se arranca desde el puesto del operador, sentado, con cinturón, freno aplicado y mandos en neutro, tras confirmar que no hay etiquetas de consignación ni personas trabajando en la máquina. Arrancar desde el suelo o puentear bornes elimina interbloqueos y expone a un movimiento inesperado. En recintos con ventilación insuficiente los gases de escape pueden alcanzar concentraciones peligrosas. El calentamiento no consiste en dejar el motor a ralentí sin vigilancia: es permitir que alcance condiciones mientras se mueven las funciones suavemente. En hidráulica fría la respuesta puede ser lenta y la presión elevada, así que se realizan ciclos moderados en zona despejada.

Aplicación práctica

Con los sistemas disponibles se selecciona el modo de trabajo, el accesorio y los ajustes autorizados, y se comprueba que la pantalla reconoce la configuración. La primera pasada se hace de forma conservadora para contrastar terreno y máquina; si la respuesta no coincide con lo esperado, se corrige antes de aumentar el ritmo.

Errores críticos que deben evitarse

• Normalizar una alarma persistente diciendo que la máquina siempre lo hace, o tapar el indicador.
• Acelerar el motor en frío para acortar el tiempo de calentamiento.

Comprobación antes de continuar

• Entorno confirmado sin personas y advertencia emitida
• Presión de aceite, temperatura, carga eléctrica y panel dentro de rango
• Implemento probado cerca del suelo y frenos y dirección a baja velocidad

Idea clave

La máquina se arranca desde el puesto y se lleva gradualmente a servicio; ninguna alarma persistente se normaliza ni se anula.$b$ where id = 'bb49b22b-f61b-4f15-a939-655967431829';

update public.lesson_segment_slides set body = $b$Objetivo

Conocer el mapa real de zonas ciegas y usar las ayudas de visión sin sustituir la segregación.

Explicación detallada

Las dimensiones de la maquinaria generan zonas que el operador no puede ver directamente, y cambian con el implemento bajo, alto o cargado, durante el giro y en marcha atrás. En la pala, el cucharón y la parte posterior ocultan áreas; en la excavadora, el contrapeso y los laterales; en el tractor, la hoja, el capó y el equipo trasero. Las cámaras pueden perder imagen por suciedad, condensación, contraste o avería; los sensores detectan solo dentro de determinados rangos y materiales, y una alarma frecuente genera habituación; los espejos deforman la distancia. La señal acústica advierte pero no concede prioridad absoluta.

Aplicación práctica

Cuando la maniobra no puede controlarse desde la cabina interviene un señalista formado, identificado, con alta visibilidad y situado donde vea la zona sin quedar en la trayectoria. Una sola persona dirige, y si se pierde el contacto o la orden es ambigua, la máquina se detiene.

Errores críticos que deben evitarse

• Presuponer que todos oyeron el motor tras una parada, sin repetir la comprobación del entorno.
• Llevar pasajeros sin un asiento homologado para ello.

Comprobación antes de continuar

• Entorno revisado, aviso emitido y tiempo dado para que todos reaccionen
• Espejos ajustados y cámaras limpias desde la posición real de conducción
• Radio de giro y zona bajo el equipo de trabajo libres

Idea clave

Una ayuda de visión no sustituye la segregación; si se pierde el control visual o la señal del guía, la máquina se detiene.$b$ where id = '04beb5b2-3666-4c8a-b3ed-d4d529f022ed';

update public.lesson_segment_slides set body = $b$Objetivo

Llenar y descargar con la pala manteniendo estabilidad, trayectoria y coordinación con el receptor.

Explicación detallada

El llenado eficaz se consigue con aproximación alineada y penetración controlada, no con velocidad elevada ni giros dentro del material. Se selecciona una cara estable del acopio, sin voladizos ni bloques con caída probable, se penetra progresivamente manteniendo tracción y evitando patinamiento prolongado, y se completa el llenado con los movimientos previstos por el fabricante. Una carga irregular o demasiado densa puede superar la masa admisible aunque el volumen aparente sea normal. Girar la articulación con el cucharón enterrado aumenta esfuerzos y reduce estabilidad. Durante el desplazamiento el cucharón va bajo y recogido.

Aplicación práctica

Pala y camión acuerdan lugar, sentido de entrada y señal de inmovilización, y el vehículo no cambia de posición hasta recibir autorización. El material se vierte de forma progresiva, distribuido según la capacidad del vehículo y sin dejar grandes bloques en posición peligrosa.

Errores críticos que deben evitarse

• Elevar el cucharón al máximo para ver por debajo, o circular con él alto.
• Pasar la carga sobre la cabina del camión, o golpear la caja para desprender material adherido.

Comprobación antes de continuar

• Superficie de ataque firme y lo más horizontal posible
• Bastidores alineados y cucharón inclinado para retener el material
• Zona comprobada y aviso emitido antes de retroceder

Idea clave

La carga segura con pala combina bastidores alineados, cucharón bajo en desplazamiento y descarga coordinada sin invadir la cabina del transporte.$b$ where id = 'd26126e1-59f5-4597-816e-e3163aa05c2b';

update public.lesson_segment_slides set body = $b$Objetivo

Excavar y cargar desde una base estable, con el radio segregado y una trayectoria que evite la cabina.

Explicación detallada

El terreno debe soportar la máquina y las cargas dinámicas, así que se revisan bordes, zanjas ocultas, rellenos, agua y desniveles; las cadenas apoyan plenamente y la plataforma incluye espacio para el contrapeso y la trayectoria de la pluma. No se corrige un apoyo deficiente acumulando material sin compactación comprobada, y la posición debe permitir excavar sin socavar la propia base. Trabajar al alcance máximo reduce margen y aumenta la sensibilidad a cualquier cambio. Antes de excavar se identifica la presencia de servicios enterrados y se evalúa el frente o la zanja.

Aplicación práctica

Se establece una zona de espera fuera del radio de giro; el vehículo entra tras señal, se coloca donde el operador pueda verlo y ambos confirman inmovilización. El contrapeso puede barrer un área opuesta a la carga y debe permanecer libre.

Errores críticos que deben evitarse

• Dejar caer un bloque desde altura dentro del camión para romperlo, en lugar de usar el método autorizado.
• Compensar una inclinación de la máquina extendiendo otro elemento de forma improvisada.

Comprobación antes de continuar

• Plataforma resistente, nivelada y con espacio para el giro
• Vehículo fuera de la zona de caída de material y con la cabina fuera de la trayectoria
• Comunicación con el camión o el señalista establecida

Idea clave

La excavadora carga con base estable, radio segregado y trayectoria que evita la cabina; cualquier cambio del apoyo obliga a replantear.$b$ where id = '121875a7-f5b4-4513-9cc0-49b778442617';

update public.lesson_segment_slides set body = $b$Objetivo

Empujar y ripar conservando adherencia, alineación y distancia a todo borde reciente.

Explicación detallada

La cantidad de material frente a la hoja se adapta a potencia, pendiente y adherencia, porque una carga excesiva provoca patinamiento, pérdida de dirección y empuje lateral. Se avanza con trayectoria planificada, evitando giros cerrados bajo carga, y la hoja se mantiene a una altura que controle el cordón sin ocultar el terreno: sus extremos quedan fuera de la visión directa y exigen margen respecto a personas y obstáculos. El escarificador se introduce de forma gradual con el tractor alineado, y girar con la púa sometida a gran esfuerzo puede dañar el equipo o desplazar la máquina. El material ripado crea bloques y huecos que cambian el apoyo.

Aplicación práctica

En pendientes se trabaja en la dirección definida por el fabricante y por el procedimiento, evitando maniobras transversales innecesarias y reduciendo la velocidad antes de girar. Si el escarificador se engancha, se detiene, se descarga la tensión y se replantea.

Errores críticos que deben evitarse

• Usar la hoja como freno improvisado, o la berma como tope de contención.
• Acelerar o levantar bruscamente el útil enganchado, con riesgo de movimiento inesperado.

Comprobación antes de continuar

• Carga de la hoja compatible con la potencia y la adherencia disponibles
• Implementos bajos durante los desplazamientos
• Distancia al borde valorada por grietas, material suelto y posible rotura del terreno

Idea clave

Empujar y ripar de forma segura exige mantener el tractor alineado, limitar la carga y tratar todo borde reciente como terreno potencialmente inestable.$b$ where id = '2bc1a971-f6fb-490e-91bf-582623799af0';

update public.lesson_segment_slides set body = $b$Objetivo

Adaptar la velocidad a la condición real de la pista y no al límite señalizado.

Explicación detallada

Pendiente, anchura, firme, drenaje, polvo, prioridades y tráfico cambian la capacidad de detener y de evitar colisiones, así que la velocidad autorizada es un máximo condicionado. Antes de circular se conocen sentido, prioridades, límites, puntos de cruce y restricciones, y se observan baches, roderas, material suelto, barro, hielo, agua, estrechamientos y bermas. En palas se circula con la cuchara baja, tanto cargada como vacía, y en excavadoras y tractores se adopta la posición de transporte del fabricante. En rampas se selecciona la marcha y el sistema de retención recomendados antes de descender, sin circular en punto muerto.

Aplicación práctica

En una intersección se reduce la velocidad, se establece contacto y se respeta la prioridad de las DIS: el tamaño de la máquina no concede prioridad. En tráfico bidireccional la anchura útil considera implementos y posibles derrames, no solo la calzada aparente.

Errores críticos que deben evitarse

• Adelantar fuera de las zonas permitidas o sin visibilidad suficiente.
• Acelerar cuando la máquina pierde tracción, aumentando el deslizamiento.

Comprobación antes de continuar

• Sentidos, prioridades y distancias de seguridad de las DIS conocidos
• Marcha y sistema de retención elegidos antes de la rampa
• Reducción o parada decidida ante polvo, lluvia, barro o baches

Idea clave

La velocidad se adapta a visibilidad, firme, pendiente, carga y tráfico; el límite señalizado nunca sustituye el juicio preventivo.$b$ where id = '8eaade53-b2de-4761-bb1a-512dbc66214a';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar la distancia al borde como una decisión técnica, no como una cifra aprendida.

Explicación detallada

El terreno próximo a un talud o una zanja puede fallar sin que el borde aparente se mueva, y la maquinaria añade peso, vibración y cambios de geometría. Se observan grietas paralelas al borde, abombamientos, caída de fragmentos, material húmedo, erosión, filtraciones y postes inclinados, y se compara con inspecciones previas; la ausencia de signos no garantiza estabilidad. Las zanjas pueden tener servicios, rellenos y paredes susceptibles de desprendimiento, por lo que el peso de la máquina se mantiene fuera de la zona definida y los acopios no se depositan donde añadan sobrecarga. La distancia la establece una persona competente y se recoge en la instrucción.

Aplicación práctica

Después de lluvia intensa, deshielo, voladura, excavación o parada prolongada se repite la inspección. Si aparece una grieta o una caída, se retira la máquina en dirección segura, se delimita y se comunica.

Errores críticos que deben evitarse

• Trabajar bajo bloques o viseras sin sanear, o socavar la propia plataforma.
• Intentar rellenar una grieta pasando sobre ella, o continuar para terminar la pasada.

Comprobación antes de continuar

• Distancia definida tras evaluar altura, material, fracturas, humedad y sobrecargas
• Servicios enterrados identificados en zanjas y entibación o taludes aplicados
• Vía de retirada y zona de exclusión conservadas

Idea clave

La distancia al borde se determina técnicamente y se revisa cuando cambian agua, geometría o cargas; una cifra fija no sirve para todos los terrenos.$b$ where id = '23ff4912-49c4-4125-b367-37db45c564f8';

update public.lesson_segment_slides set body = $b$Objetivo

Transferir el material a un receptor inmovilizado y capaz, con la altura y el impacto mínimos.

Explicación detallada

Al cargar camiones se controla la masa, no solo el volumen: se evita sobrepasar la capacidad, concentrar todo el peso en un extremo o dejar bloques inestables, y los grandes bloques se colocan de forma que no dañen la caja. El impacto se limita bajando la altura y abriendo progresivamente. Las tolvas crean riesgo de caída, atrapamiento y colapso de material: se respetan barreras, topes y distancias, y no se usan como freno. Un atasco no se resuelve introduciendo la cuchara ni una persona sin procedimiento y consignación. En acopios se controla la pendiente y se evita formar paredes inestables o voladizos.

Aplicación práctica

El operador se aproxima a la tolva perpendicularmente cuando así está diseñado y a velocidad mínima, manteniendo la visibilidad del borde mediante limpieza y señalización. Si faltan topes, la plataforma está dañada o el nivel de la tolva impide descargar, se detiene y se comunica.

Errores críticos que deben evitarse

• Empujar material mientras haya personas en el punto de vertido.
• Resolver el material adherido con sacudidas violentas o golpes improvisados.

Comprobación antes de continuar

• Receptor inmovilizado, dentro de capacidad y con posición acordada
• Topes o protecciones presentes, sin usarlos como sistema de frenado
• Derrames retirados antes de que afecten a neumáticos o rutas

Idea clave

La descarga se realiza sobre un receptor inmovilizado y capaz, con altura e impacto mínimos y sin usar topes o bermas como sistema de frenado.$b$ where id = 'd6e6c935-5bcf-4eb1-b8a5-fc8ed9c957ff';

update public.lesson_segment_slides set body = $b$Objetivo

Elevar solo cuando la máquina está prevista y configurada para ello, y dentro de su tabla de capacidad.

Explicación detallada

El manual debe contemplar la elevación y definir las configuraciones admitidas. La máquina necesita punto de izado identificado, dispositivos de retención o control que correspondan y tabla de capacidad para radio, altura y orientación, y esa capacidad disminuye al aumentar el alcance. Los accesorios de elevación deben estar marcados, inspeccionados y ser adecuados: no se eslinga en dientes ni se improvisan puntos. La masa incluye carga, accesorios y efectos dinámicos, y si se desconoce no se eleva. La fuerza hidráulica puede levantar momentáneamente una carga que reduce peligrosamente el margen de vuelco.

Aplicación práctica

Se realiza una prueba inicial a pocos centímetros para confirmar equilibrio, freno y aparejo; si la carga gira o el terreno se asienta, se baja. El receptor está preparado antes de levantar, para no mantener la carga suspendida mientras se improvisa.

Errores críticos que deben evitarse

• Trabajar intencionadamente hasta activar el limitador de carga, tomándolo como referencia de trabajo.
• Pasar la carga sobre personas o envolverse al cuerpo las cuerdas guía.

Comprobación antes de continuar

• Masa, radio, altura y tabla de capacidad conocidos
• Puntos de izado previstos y accesorios de elevación certificados
• Señalista coordinando si la visibilidad es limitada

Idea clave

La elevación depende de la tabla de capacidad y de la configuración; que el hidráulico pueda mover la carga no significa que la máquina pueda elevarla con seguridad.$b$ where id = 'cb4c8d4f-e5fa-4415-9a5e-f94aa7a5b9ed';

update public.lesson_segment_slides set body = $b$Objetivo

Cerrar el turno dejando la máquina estable y la incidencia registrada de forma clara.

Explicación detallada

Se estaciona en zona autorizada, nivelada, firme, fuera del tráfico, de bordes, frentes, drenajes y líneas, sin bloquear rutas de emergencia. Se coloca la transmisión en neutro, se acciona el freno, se apoya por completo el equipo y se dejan los mandos sin energía. El enfriamiento y la parada del motor siguen las instrucciones del fabricante, especialmente tras trabajos intensos, y después se retira la llave, se cierra la cabina y se colocan calzos cuando el procedimiento lo exija. El parte debe describir síntoma, momento, carga, ubicación y acción: «hace ruido» aporta mucho menos que indicar que aparece al girar a la derecha con el hidráulico caliente.

Aplicación práctica

Si existe una alarma, la máquina se detiene en el primer lugar seguro, se registra el código y las condiciones, y no se reinicia repetidamente. Una máquina fuera de servicio se identifica para impedir un arranque no autorizado y solo personal competente la libera.

Errores críticos que deben evitarse

• Dejar la máquina con carga suspendida, motor en marcha sin vigilancia o llave accesible, incluso en una pausa breve.
• Comentar la incidencia informalmente en vez de registrarla.

Comprobación antes de continuar

• Terreno firme y preferentemente horizontal, equipo apoyado por completo
• Freno aplicado, mandos sin energía y llave retirada
• Alarmas, golpes, fugas o comportamiento anormal transmitidos al relevo

Idea clave

El fin del ciclo deja implemento apoyado, mandos neutros, freno aplicado, motor detenido y cualquier incidencia claramente registrada.$b$ where id = '5af93268-fbe1-4b19-a38e-658343e8b5ef';

-- Bloque 4 · Conocimiento de la máquina y sistemas de seguridad

update public.lesson_segment_slides set body = $b$Objetivo

Interpretar los síntomas del motor, la refrigeración y la lubricación antes de que la desviación acabe en rotura o incendio.

Explicación detallada

El motor depende de aire limpio, alimentación correcta y lubricación. Filtros saturados, entradas de polvo, fugas o combustible contaminado reducen el rendimiento y elevan la temperatura, y aumentar carga para comprobar si se limpia no es un diagnóstico. Una temperatura alta puede deberse a radiadores obstruidos, nivel insuficiente o avería del ventilador. El circuito evacua calor mediante refrigerante, radiador, ventilador, bomba y termostato, y el polvo o el barro sobre el paquete de enfriamiento reducen el caudal de aire. El aceite forma película, refrigera y transporta contaminantes al filtro: presión baja, temperatura alta o nivel incorrecto dañan rápidamente motor y transmisión.

Aplicación práctica

La limpieza del radiador se realiza con el motor parado y frío, sin doblar aletas ni proyectar polvo hacia las personas, y después se confirma que resguardos y tapas quedan montados. Los puntos de engrase se atienden con el equipo apoyado o bloqueado.

Errores críticos que deben evitarse

• Mantener la máquina en marcha para ver si recupera cuando la presión de aceite es crítica.
• Eliminar una alarma sin haber identificado y corregido su causa.

Comprobación antes de continuar

• Presión de aceite, temperatura, nivel de combustible y filtros revisados
• Compartimento libre de material combustible y acumulaciones de aceite
• Circuitos calientes manipulados solo tras enfriamiento y según el manual

Idea clave

Una alarma de temperatura o lubricación es una orden de diagnóstico: se detiene conforme al procedimiento y nunca se oculta para continuar.$b$ where id = 'd8d8d8c5-1e15-4fe3-b3f7-8fe868f80211';

update public.lesson_segment_slides set body = $b$Objetivo

Mantener la potencia dentro del margen en que sigue habiendo control, y bloquear la articulación antes de entrar en ella.

Explicación detallada

La transmisión entrega la potencia a ruedas o cadenas y permite adaptar velocidad y esfuerzo; su configuración puede incluir transmisión hidrostática, convertidor y caja, ejes o accionamiento final, cada uno con sus límites de temperatura y modos de retención. Seleccionar una marcha inadecuada en pendiente obliga a un frenado continuo y genera calentamiento. En la pala articulada el giro se produce en el bastidor central, lo que desplaza el centro de gravedad y crea una zona de aplastamiento. La fuerza disponible debe ser compatible con la adherencia: el patinamiento prolongado daña neumáticos o cadenas y puede hacer que la máquina derive hacia un borde.

Aplicación práctica

Ante pérdida de tracción se reduce carga, se mejora la ruta o se cambia de método, en lugar de responder siempre con más aceleración. En máquinas de cadenas, los giros cerrados aumentan el desgaste y pueden desestabilizar sobre terreno irregular.

Errores críticos que deben evitarse

• Cambiar bruscamente de sentido mientras la máquina mantiene velocidad.
• Entrar entre semibastidores confiando en la dirección hidráulica o en un calzo improvisado.

Comprobación antes de continuar

• Modo y marcha recomendados para la pendiente y la carga
• Bloqueo mecánico de articulación instalado antes de cualquier acceso
• Tirones, ruidos o pérdida de tracción anormal comunicados

Idea clave

La potencia solo es útil mientras existe control; patinamiento, deriva o respuesta retardada indican que debe reducirse carga y revisar el sistema.$b$ where id = '77380c71-e3e8-4ac7-85a6-b5ffae324ef2';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar el circuito hidráulico como una fuente de energía que sigue activa después de apagar.

Explicación detallada

Las bombas generan caudal, las válvulas dirigen y limitan, los cilindros o motores convierten la energía y el depósito acondiciona el fluido. La presión aparece por resistencia al movimiento y no es sinónimo de trabajo útil: una válvula de alivio que actúa continuamente indica sobrecarga o maniobra incorrecta y genera calor. Incluso con el motor parado, acumuladores, cilindros cargados e implementos elevados conservan energía, y la gravedad se considera una fuente independiente. Una fuga a alta presión puede inyectar fluido bajo la piel y la lesión requiere atención médica urgente aunque la herida parezca pequeña.

Aplicación práctica

Las fugas se buscan con cartón, pantalla u otro medio previsto, nunca con la mano, y no se reaprieta un racor presurizado. Los latiguillos se protegen frente a roce, calor y aplastamiento, y se sustituyen cuando presentan daños.

Errores críticos que deben evitarse

• Golpear topes o mantener los mandos al final de carrera, calentando el sistema.
• Permanecer bajo el implemento para observar un movimiento anormal.

Comprobación antes de continuar

• Equipo apoyado y presión descargada según el procedimiento
• Bloqueo mecánico colocado y movimientos posibles impedidos
• Mandos sin retraso, sin movimientos espontáneos ni descenso sin orden

Idea clave

El circuito hidráulico conserva energía después de la parada; toda intervención exige apoyo, aislamiento, descarga y verificación.$b$ where id = '77d8f321-8957-45cc-bbcd-15f308bea7f9';

update public.lesson_segment_slides set body = $b$Objetivo

Leer la capacidad como una propiedad de la configuración completa, no de la máquina sola.

Explicación detallada

La cuchara se elige por densidad y granulometría, no solo por volumen: una cuchara ligera para material suelto puede sobrecargar la máquina con roca densa. Unas horquillas desplazan el centro de gravedad y un martillo introduce vibraciones y proyecciones, además de requerir caudal y presión concretos. Las placas y tablas indican límites bajo condiciones: en palas importan carga de vuelco, carga operativa y posición; en excavadoras, radio, altura, orientación y accesorio; en tractores, esfuerzo y capacidad de implementos. El peso del acoplamiento y del accesorio reduce la carga disponible, y el material adherido también cuenta.

Aplicación práctica

Si el peso se desconoce, se estima por procedimiento o se mide, y se planifica con margen. Cuando cambia el material o el alcance, se vuelve a evaluar la capacidad y la estabilidad.

Errores críticos que deben evitarse

• Usar la alarma o el limitador como método normal para determinar el máximo.
• Emplear el equipo para funciones no previstas, como empujar lateralmente con la cuchara o izar desde un diente.

Comprobación antes de continuar

• Compatibilidad, peso, presión y caudal requeridos verificados
• Dispositivos de retención presentes y limitaciones del manual conocidas
• Tabla de carga correspondiente a la configuración real, con contrapeso y accesorio

Idea clave

La capacidad corresponde a una configuración, no a la máquina aislada; accesorio, radio, material y terreno deben coincidir con la tabla aplicable.$b$ where id = 'f70bc3a3-c987-4a22-977a-ea5972fb0676';

update public.lesson_segment_slides set body = $b$Objetivo

Cuidar el único contacto que la máquina tiene con el terreno y reconocer cuándo el firme no da más.

Explicación detallada

La presión del neumático modifica la huella y la flexión: una presión baja aumenta el calentamiento y el daño, una alta reduce el contacto y la absorción. La carga lateral en los giros, el cucharón alto y la pendiente aumentan el esfuerzo, y un neumático dañado puede fallar de forma súbita. Las cadenas distribuyen peso y proporcionan tracción, pero dependen de tensión y apoyo: una floja puede salirse, una tensa consume potencia y daña, y el material atrapado altera la tensión. El ajuste sigue el manual y controla la energía del tensor, que puede estar presurizado. La presión media sobre el suelo no detecta cavidades.

Aplicación práctica

Antes de trabajar sobre rellenos, bordes o plataformas recientes se confirma su capacidad portante y se evita concentrar cargas cerca de zonas debilitadas. Si la máquina patina o se hunde, se detiene antes de perder el control y la recuperación se planifica.

Errores críticos que deben evitarse

• Aflojar un componente del tren de rodaje sin procedimiento, con el tensor presurizado.
• Mantener la velocidad sobre firme deteriorado confiando en los neumáticos, o dar por seguro un borde saturado por llevar cadenas.

Comprobación antes de continuar

• Presión, cortes y fijaciones inspeccionados a distancia segura
• Tensión, tejas, rodillos y ruedas revisados y material atrapado retirado
• Ruta reconocida y derrames corregidos

Idea clave

Rodaje y terreno forman un sistema: presión o tensión correcta no compensan un firme incapaz, ni una buena pista compensa un componente dañado.$b$ where id = '9f383f16-5a13-4556-af1a-faeef7b93908';

update public.lesson_segment_slides set body = $b$Objetivo

Distinguir cada sistema de frenado y dirección, y retirar la máquina cuando su respuesta se degrada.

Explicación detallada

El freno de servicio controla el movimiento, el de estacionamiento mantiene la máquina y el de emergencia o secundario actúa ante un fallo según el diseño; en la excavadora, el freno de giro controla la superestructura. La máquina no se estaciona confiando solo en la transmisión. La dirección puede ser articulada, hidrostática o mediante cadenas, y su respuesta depende de presión, velocidad y terreno. La dirección de emergencia permite conservar el control, pero no autoriza a continuar la producción tras una avería. El operador debe saber qué ocurre si se pierde presión, se para el motor o falla un circuito.

Aplicación práctica

Si falla la dirección o el freno, se reduce energía, se usa el sistema previsto y se orienta hacia la zona más segura sin maniobras bruscas, sin saltar de la cabina, porque el cinturón y la ROPS mantienen la protección. Tras detener, se inmoviliza y se señaliza.

Errores críticos que deben evitarse

• Usar una pendiente para probar los frenos.
• Ajustar los hábitos de conducción para convivir con un freno deficiente.

Comprobación antes de continuar

• Frenos probados a baja velocidad en zona segura, según el manual
• Dirección comprobada en ambos sentidos, sin holgura ni retardo
• Bloqueos hidráulicos y control de giro operativos en la excavadora

Idea clave

Un freno o dirección degradados no admiten compensación operativa; la máquina se inmoviliza y solo vuelve tras reparación y prueba.$b$ where id = '72faa5ec-8c6e-4dcf-809b-6da084fc3407';

update public.lesson_segment_slides set body = $b$Objetivo

Conservar el volumen de supervivencia y permanecer dentro de él.

Explicación detallada

La estructura ROPS limita la deformación de la cabina durante un vuelco bajo condiciones de ensayo y la FOPS protege frente a objetos que caen según el nivel previsto; ninguna hace invulnerable la máquina ni cubre cualquier impacto. Una cabina cerrada no es necesariamente ROPS o FOPS si no está diseñada como tal. Soldar, perforar o enderezar una estructura puede alterar su resistencia, y los daños no se valoran solo por apariencia. Durante un vuelco existe tendencia a salir despedido o a quedar entre la máquina y el suelo: el cinturón es lo que mantiene al operador dentro del volumen protegido, y su uso es necesario incluso a baja velocidad.

Aplicación práctica

Ante una inestabilidad el operador no salta: mantiene el cinturón, reduce o detiene según su capacidad, baja el equipo si puede hacerlo sin agravar la situación y sigue el plan de emergencia. Tras un vuelco la máquina se retira de servicio, se controla el combustible y se evalúan todos los sistemas.

Errores críticos que deben evitarse

• Perforar, soldar o modificar la estructura sin autorización técnica.
• Enderezar una parte deformada y volver al servicio sin evaluación.

Comprobación antes de continuar

• Placas de identificación, anclajes y estado de la estructura conservados
• Cinturón abrochado, ajustado y con sus anclajes revisados
• Ventanas de emergencia y martillo disponibles y accesibles

Idea clave

La ROPS protege un espacio y el cinturón mantiene al operador dentro; ninguno justifica operar sobre terreno o bajo material inseguro.$b$ where id = '3f60c428-f377-47d1-ab1d-4b5ffd6a8a89';

update public.lesson_segment_slides set body = $b$Objetivo

Instalar la barrera que corresponde a cada energía y reponerla antes de devolver la máquina al servicio.

Explicación detallada

Los resguardos cubren correas, ventiladores, ejes y zonas peligrosas; los bloqueos mecánicos sostienen el equipo, la articulación o la superestructura; los interbloqueos impiden funciones en condiciones no permitidas; y los bloqueos de transmisión y mandos reducen la puesta en movimiento. Cada elemento responde a un riesgo y no es intercambiable: una llave retirada no sostiene una cuchara y un soporte hidráulico no evita un arranque eléctrico. Si se retira una protección, primero se separan las energías, se bloquea, se disipa y se verifica, y el soporte mecánico se coloca en la posición diseñada.

Aplicación práctica

Antes de trabajar en una zona peligrosa se identifica qué energía puede mover cada componente y se instala el dispositivo previsto, no una pieza improvisada. Las anulaciones temporales de diagnóstico exigen procedimiento técnico y no quedan en producción.

Errores críticos que deben evitarse

• Anular un bloqueo o resguardo para ganar tiempo o facilitar una comprobación.
• Usar las protecciones como peldaños o puntos de amarre.

Comprobación antes de continuar

• Resguardos presentes y sin deformaciones que rocen
• Bloqueo adecuado a la energía concreta que se quiere controlar
• Herramientas, soportes y personas fuera antes de retirar bloqueos

Idea clave

Cada energía necesita su barrera; retirar una protección exige consignar y la máquina no vuelve al trabajo hasta que todo quede repuesto y probado.$b$ where id = 'e6094e80-a320-437c-995c-c322b49f9a81';

update public.lesson_segment_slides set body = $b$Objetivo

Dar a cada aviso la respuesta que define el manual, y conservar la información que aporta.

Explicación detallada

Manómetros, termómetros, niveles, contadores e indicadores de carga muestran el estado, y su lectura se relaciona con la fase: frío, trabajo normal, carga o parada. Un valor aislado puede ser menos útil que la tendencia, y un indicador averiado se considera defecto, no autorización para trabajar a ciegas. Los avisos informativos requieren vigilancia o registro, las advertencias exigen reducir carga, buscar posición y comunicar, y las paradas críticas requieren detener de forma segura e inmediata. El color ayuda, pero la respuesta la define el fabricante: dos alarmas parecidas pueden exigir actuaciones distintas.

Aplicación práctica

Bocina, alarma de retroceso, luces, rotativos, cámaras y espejos ayudan a comunicar el movimiento y ampliar la visión, pero no sustituyen una zona despejada ni una maniobra controlada. Una alarma intermitente puede señalar una condición que aparece bajo giro, pendiente o temperatura, y se documenta.

Errores críticos que deben evitarse

• Tapar una luz o desconectar una alarma, convirtiendo una desviación detectada en desconocida.
• Borrar códigos antes del diagnóstico o reiniciar repetidamente para que el aviso desaparezca.

Comprobación antes de continuar

• Lectura normal, zonas de advertencia y acción requerida conocidas
• Indicadores legibles y avisos externos operativos
• Códigos registrados con exactitud y condiciones en que aparecen

Idea clave

Toda alarma exige una respuesta definida; registrar el código y detener cuando corresponde preserva la información y evita trabajar a ciegas.$b$ where id = '82314a23-4cf2-4048-ac20-5a9b284cee66';

update public.lesson_segment_slides set body = $b$Objetivo

Hacer coincidir el papel con la máquina real: manual, adecuación y estado del equipo.

Explicación detallada

El manual de instrucciones define el uso previsto, capacidades, mantenimiento, advertencias y procedimientos de emergencia de cada modelo, y debe estar disponible y ser comprensible; se consulta la edición del modelo, no un manual genérico. El Real Decreto 1215/1997 obliga al empresario a seleccionar, mantener y utilizar equipos adecuados: su anexo I contempla órganos de accionamiento, puesta en marcha, parada y protección frente a proyecciones, vuelco, caída de objetos y contacto, y para equipos móviles exige, según el riesgo, frenos, visibilidad, iluminación, protección contra incendio y señal acústica. Una adecuación documental no sustituye el buen estado real del equipo.

Aplicación práctica

Si la configuración se modifica o se incorpora un accesorio, se evalúa cómo afecta a los riesgos y, tras modificar, se forma y se prueba. La verificación física cierra el sistema: placa, equipo, accesorios y estado deben coincidir con lo escrito.

Errores críticos que deben evitarse

• Inventar un valor por experiencia cuando el manual no está disponible o hay contradicción.
• Aceptar ajustes informales en lugar de comunicar el cambio y esperar la evaluación.

Comprobación antes de continuar

• Manual del modelo accesible y etiquetas legibles
• Informe de adecuación coincidente con resguardos, alarmas y configuración reales
• Ante contradicción, aplicada la limitación más segura y consultado el responsable técnico

Idea clave

La adecuación documental solo es válida si coincide con máquina, accesorio, uso y estado reales; cualquier cambio obliga a reevaluar.$b$ where id = 'db363a78-53b1-4052-a680-c0fd753683a7';

-- Bloque 5 · Control del entorno, interferencias, emergencias y normativa

update public.lesson_segment_slides set body = $b$Objetivo

Vigilar frente, plataforma y talud como condiciones que cambian dentro del propio turno.

Explicación detallada

El lugar de trabajo cambia por excavación, voladura, lluvia, tránsito y vertido. Se observan geometría, discontinuidades, bloques, voladizos, grietas, caída reciente y agua, comparando siempre con el estado previo. Tras una voladura se respeta la autorización de entrada y los barrenos fallidos se atienden mediante procedimiento. La plataforma debe soportar la máquina y las cargas dinámicas: se revisan hundimientos, roderas, rellenos, drenaje y proximidad a vacíos, y su anchura útil incluye contrapeso, implemento y margen. La vigilancia es continua porque la propia tarea cambia la geometría: la excavadora puede socavar, la pala retirar el pie y el tractor cargar el borde.

Aplicación práctica

La inspección se repite después de lluvia intensa, heladas, voladuras o trabajos que alteren el terreno. Si una cadena o una rueda se hunde, se baja el equipo y se detiene antes de intentar salir.

Errores críticos que deben evitarse

• Confiar en la cabina para trabajar bajo una zona sin sanear.
• Tapar una grieta con material para ocultarla en lugar de retirarse, delimitar y comunicar.

Comprobación antes de continuar

• Coronaciones y pie de talud observados desde lugar seguro
• Plataforma sin hundimientos, roderas ni proximidad a vacíos
• Ruta de retirada libre y evaluación solicitada ante cualquier duda

Idea clave

Frentes y plataformas se vuelven a inspeccionar tras cualquier cambio; una grieta o caída exige retirada, delimitación y evaluación.$b$ where id = '7655ba24-d07d-4ef6-ae92-3c26a703eaa9';

update public.lesson_segment_slides set body = $b$Objetivo

Mantener la pista como una instalación que se conserva, con el polvo controlado sin perder adherencia.

Explicación detallada

La pista necesita anchura, pendiente, radios, firme y señalización adecuados a los equipos que circulan; los márgenes permiten recuperación y las intersecciones deben ofrecer visibilidad o control. Los derrames dañan neumáticos y obligan a desviar, así que se retiran con medios planificados: la pista no es un depósito temporal. Una berma señala o contiene dentro de su diseño, pero no debe utilizarse como freno ni asumirse capaz de detener cualquier máquina, y en escombreras el material reciente puede ceder detrás de una berma aparentemente intacta. Las cunetas, el bombeo y las pendientes evacuan agua sin socavar, y los charcos pueden ocultar la profundidad.

Aplicación práctica

El riego se coordina para no generar barro, deslumbramiento ni interferencia con el tráfico, y la cabina y los filtros complementan pero no sustituyen el control del polvo en origen. Si el polvo impide ver, se detiene aunque exista un límite señalizado superior.

Errores críticos que deben evitarse

• Golpear la berma o el tope para comprobar su resistencia.
• Confiar en la experiencia individual para superar una pista que ya no permite circular con seguridad.

Comprobación antes de continuar

• Anchura, pendiente, firme, visibilidad y drenaje compatibles con los equipos
• Bermas con continuidad, altura y compactación revisadas
• Deterioros comunicados con su ubicación y señalizados si es posible

Idea clave

Una pista segura necesita firme, berma y drenaje mantenidos; el control de polvo nunca debe degradar la adherencia ni la visibilidad.$b$ where id = '628f4e51-2a5d-4f5d-b4b9-60a7e7cd6d95';

update public.lesson_segment_slides set body = $b$Objetivo

Fijar un esquema de posición y comunicación para que la carga del camión no dependa de interpretaciones.

Explicación detallada

La pala y el camión comparten espacio durante la carga, y el riesgo se concentra en la aproximación, la inmovilización, las zonas ciegas y la trayectoria de la cuchara. El camión espera fuera de la envolvente hasta recibir señal, entra por la ruta definida y se coloca en posición visible mientras la pala mantiene el implemento controlado; después se confirma la inmovilización. Si llega otro vehículo no se improvisa una segunda posición. La pala recoge el material con los bastidores alineados, retrocede, traslada con carga baja y eleva al aproximarse, minimizando el giro y evitando la cabina.

Aplicación práctica

El conductor sabe de antemano si debe permanecer en cabina o dirigirse a un refugio, y nunca camina por la zona sin contacto. Si el camión se posiciona mal, se le ordena salir y repetir, en lugar de corregir con la cuchara elevada alrededor de la cabina.

Errores críticos que deben evitarse

• Mover el camión mientras la cuchara está sobre la caja.
• Continuar el ciclo tras perder el contacto visual o la radio, en vez de parar ambos equipos.

Comprobación antes de continuar

• Punto de espera, aproximación y salida definidos
• Autorización de entrada dada y posición confirmada por ambos
• Señales o radio conocidas por los dos operadores

Idea clave

Camión inmovilizado, posición fija y comunicación confirmada: si uno pierde contacto o cambia de lugar, ambos equipos se detienen.$b$ where id = 'f848e41c-3ce0-4827-9512-e76f2d453526';

update public.lesson_segment_slides set body = $b$Objetivo

Segregar el radio completo de la excavadora y hacer que el camión entre, permanezca y salga bajo secuencia.

Explicación detallada

La interacción entre excavadora y transporte añade el barrido del contrapeso al giro de la pluma, así que la zona de espera se define fuera del radio y el camión se aproxima por el lado que maximiza la visión y evita el frente. La posición reduce el giro sin comprometer el terreno, y el contrapeso conserva margen. La cuchara viaja sin sobrepasar la cabina y con la altura mínima, y el material se deposita distribuido. La plataforma se vigila porque los movimientos repetidos pueden asentarla, y cargar a alcance excesivo reduce la capacidad: se replantea la posición en lugar de forzar.

Aplicación práctica

Cuando el terreno obliga a trabajar a diferente cota se evalúan el borde, el alcance y la caída del material. Tras completar la carga, la cuchara sale de la caja y queda controlada antes de dar la señal, y el camión sale por una ruta separada.

Errores críticos que deben evitarse

• Usar la cuchara para empujar, retener o avisar al vehículo mediante golpes.
• Dejar caer bloques desde altura para romperlos dentro de la caja.

Comprobación antes de continuar

• Radio de giro despejado, incluido el barrido del contrapeso
• Punto estable para el camión y trayectoria que no pasa sobre la cabina
• Una única persona dirigiendo, con parada inmediata si se pierde la comunicación

Idea clave

La zona de exclusión incluye contrapeso, pluma y cuchara; el camión entra, permanece y sale únicamente bajo la secuencia acordada.$b$ where id = 'be5a548d-e74a-4998-8c1a-d3941e68535d';

update public.lesson_segment_slides set body = $b$Objetivo

Proteger a quien va a pie con segregación, contacto confirmado y un único interlocutor.

Explicación detallada

Las personas de tierra son especialmente vulnerables porque el operador puede no verlas y porque una máquina no se detiene instantáneamente. Se diseñan rutas peatonales y refugios separados, y nadie entra en el radio sin autorización y contacto: la ropa de alta visibilidad ayuda, pero no hace visible a una persona oculta. El acceso a la cabina se hace con la máquina detenida, el implemento apoyado y la señal confirmada. El señalista está formado, identificado y visible, se sitúa fuera de la zona de atrapamiento y no camina de espaldas. La radio usa mensajes breves: identificación, orden y confirmación.

Aplicación práctica

Los trabajos de topografía, limpieza o inspección se coordinan antes, y si necesitan entrar se inmoviliza la máquina o se establece una condición segura. Las contratas reciben las mismas reglas y los mismos mapas.

Errores críticos que deben evitarse

• Actuar sobre gestos ambiguos o sobre órdenes de terceros, salvo una parada de emergencia, que cualquiera puede indicar.
• Continuar cuando varias personas dan instrucciones, en lugar de detener y designar un único interlocutor.

Comprobación antes de continuar

• Rutas peatonales, zonas de exclusión y puntos de acceso señalizados
• Contacto establecido y confirmación del operador antes de aproximarse
• Cobertura de radio y señales acordadas probadas en la zona

Idea clave

La alta visibilidad no sustituye el contacto; ninguna persona entra en la envolvente hasta que máquina y operador estén en condición segura.$b$ where id = 'ffbb80a3-2689-45af-adce-392fd1d61fe2';

update public.lesson_segment_slides set body = $b$Objetivo

Planificar la proximidad a líneas por tensión y geometría, sabiendo que el arco no necesita contacto.

Explicación detallada

Una máquina puede invadir la zona de peligro de una línea sin contacto directo, por alcance, balanceo, terreno o arco. Se aplican el Real Decreto 614/2001 y el procedimiento eléctrico del centro: se localizan líneas aéreas y enterradas, tensión, altura y zonas, y una persona autorizada o cualificada determina la viabilidad, priorizando desenergizar, desviar o proteger. La planificación contempla todas las posiciones de pluma, cuchara, hoja y carga, además de la antena, el balanceo y el posible rebote, porque el terreno puede inclinar la máquina y reducir el margen. El material del curso usa un aviso previo de veinticinco metros, que no sustituye las distancias reglamentarias calculadas por tensión.

Aplicación práctica

Las líneas enterradas se localizan y marcan, y una señal antigua no basta: se verifica. Si la máquina entra en contacto, el operador permanece en la cabina salvo incendio u otro peligro inmediato, advierte que nadie se acerque y solicita el corte.

Errores críticos que deben evitarse

• Estimar la distancia a ojo en lugar de aplicar la que fija el procedimiento por tensión.
• Tocar simultáneamente la máquina y el suelo, o reanudar tras aparentemente separarse sin confirmación competente.

Comprobación antes de continuar

• Tensión, altura, recorrido y zona de seguridad identificados
• Pórticos, limitadores, vigilancia o desenergización aplicados si se requieren
• Actuación ante contacto conocida y entrenada

Idea clave

No existe una distancia única: se determina por tensión, movimiento posible y procedimiento; el arco puede producirse antes del contacto.$b$ where id = 'fe830d7b-08c3-4af9-89ca-1a3a06777f21';

update public.lesson_segment_slides set body = $b$Objetivo

Pasar la máquina a mantenimiento y recuperarla mediante entrega formal y liberación inequívoca.

Explicación detallada

Las reparaciones generan riesgos distintos de la producción: equipos elevados, pruebas con motor en marcha, presencia de técnicos y energías liberadas. El operador estaciona, apoya, limpia lo necesario y describe el defecto con códigos, síntomas y condiciones; mantenimiento identifica la máquina y el alcance, se delimitan zonas y se acuerda quién controla la consignación. La llave no es la única medida. Se identifican las energías, se separan, se bloquean, se disipan y se verifican, colocando apoyos, bloqueo de articulación o giro y calzos. Si se necesita energizar para diagnóstico se aplica un procedimiento específico con zona despejada y después se vuelve a consignar.

Aplicación práctica

Si una prueba requiere movimiento, la zona se delimita, se restablecen los resguardos necesarios y una persona coordina la operación. El operador no acciona mandos hasta que el responsable lo indique y confirme que todos están fuera.

Errores críticos que deben evitarse

• Entregar o eliminar la llave y los dispositivos de consignación sin autorización.
• Permanecer en la articulación, bajo un implemento o dentro del radio de giro sin protección física adecuada.

Comprobación antes de continuar

• Acuerdo previo sobre quién controla la máquina y qué sistemas quedan aislados
• Cada persona retirando su propio bloqueo al terminar
• Entrega formal e inspección funcional antes de volver a producir

Idea clave

La máquina pasa de producción a mantenimiento y vuelve mediante una entrega formal, consignación verificada y liberación inequívoca.$b$ where id = 'f6de687a-63ab-4b53-afd9-55c53416c487';

update public.lesson_segment_slides set body = $b$Objetivo

Ordenar la respuesta con PAS y actuar sin generar una segunda víctima.

Explicación detallada

Ante un accidente se aplica la conducta PAS: primero se evita que la máquina, el tráfico, la electricidad o el terreno provoquen nuevas víctimas; después se activa el sistema de emergencia con información precisa, indicando ubicación, número de afectados y riesgos; y solo entonces se presta ayuda dentro de la propia formación. En un accidente eléctrico no se toca nada hasta el corte. Ante un incendio incipiente se detiene la máquina en un lugar que no bloquee la evacuación, se baja el implemento, se para el motor y se corta la energía si es seguro. El extintor se usa solo en conato, con salida disponible y agente adecuado.

Aplicación práctica

Si el fuego crece, los neumáticos se calientan o hay combustible implicado, se evacua y se establece distancia, porque los neumáticos pueden fallar violentamente. Una inyección hidráulica requiere urgencia médica aunque la herida parezca pequeña.

Errores críticos que deben evitarse

• Mover a una persona lesionada salvo peligro inmediato y con formación para hacerlo.
• Entrar bajo un implemento o sobre terreno inestable para socorrer.

Comprobación antes de continuar

• Extintor, botiquín, salida alternativa y medios de comunicación localizables con rapidez
• Escena protegida antes de avisar y socorrer
• Aviso dado con ubicación, máquina y combustible implicado

Idea clave

PAS ordena la respuesta: proteger la escena, avisar con datos precisos y socorrer únicamente dentro de la formación y sin exponerse.$b$ where id = '844ab826-f043-413d-9706-c0f662f7b8a5';

update public.lesson_segment_slides set body = $b$Objetivo

Saber detener, evacuar, comunicar y reunirse sin improvisar la ruta.

Explicación detallada

El plan de emergencia define alarmas, responsables, comunicaciones, vías de evacuación y puntos de reunión, e incluye cómo detener equipos, asegurar zonas, evacuar y recibir ayuda externa. Los planos y las rutas se actualizan conforme cambian los frentes. Al oír la alarma se detiene sin bloquear rutas, se apoya el implemento, se aplica el freno, se apaga y se evacua según indicación, sin volver por objetos. Si mover la máquina mejora la seguridad, solo se hace bajo instrucción y sin retrasar la salida. En humo o polvo se reduce la velocidad y no se conduce a ciegas, respetando la prioridad de los vehículos de emergencia.

Aplicación práctica

En el punto de reunión se contabiliza al personal y no se abandona hasta recibir autorización. Los simulacros permiten comprobar tiempos, cobertura de radio y acceso de los servicios de ayuda.

Errores críticos que deben evitarse

• Improvisar rutas a través de frentes, taludes o zonas de tráfico durante una evacuación.
• Volver por cuenta propia a buscar a un compañero ausente en lugar de informar.

Comprobación antes de continuar

• Alarmas, responsables, vías de evacuación y punto de reunión conocidos
• Alternativas previstas si una pista queda bloqueada
• Escena conservada cuando sea seguro y colaboración en la investigación

Idea clave

El plan solo funciona si cada operador sabe detener, evacuar, comunicar y reunirse; los simulacros convierten instrucciones en conducta.$b$ where id = '62ecee60-dfc8-4ce0-8d51-0af2698cb351';

update public.lesson_segment_slides set body = $b$Objetivo

Situar la norma, los derechos y las obligaciones dentro del trabajo diario.

Explicación detallada

Esta formación se encuadra en la ITC 02.1.02 y en la Especificación Técnica 2001-1-08 para operadores de maquinaria de arranque, carga y viales. La Ley 31/1995 establece el deber de protección, evaluación, información, formación y participación; el Real Decreto 1389/1997 concreta los mínimos en industrias extractivas y exige organización, trabajadores competentes e instrucciones escritas; el Real Decreto 1215/1997 regula la selección, adecuación y uso de los equipos; y el Real Decreto 171/2004 coordina la actividad entre empresas. La formación inicial es de veinte horas y el reciclaje presencial de al menos cinco, con una frecuencia máxima de dos años. Las NTP y guías son criterios de apoyo y no sustituyen la norma.

Aplicación práctica

El trabajador usa correctamente la máquina, los dispositivos y los EPI, no anula protecciones, respeta las DIS e informa de inmediato de cualquier situación que pueda suponer un riesgo grave. Parar ante una pérdida de control no es improductividad.

Errores críticos que deben evitarse

• Dar por cumplida la norma con un documento firmado que no se aplica en el trabajo real.
• Tratar la acreditación como sustituto de seguir el manual y comunicar los defectos cada día.

Comprobación antes de continuar

• Marco aplicable y DIS del centro conocidos y vigentes
• Formación inicial y reciclaje dentro de la frecuencia exigida
• Registros de inspección, mantenimiento e incidentes al día

Idea clave

La normativa se cumple cuando se transforma en condiciones reales: equipo adecuado, formación presencial, instrucciones claras y capacidad efectiva de detener.$b$ where id = 'e7a0c3f7-18f7-4a1f-9d63-4341d856a6f5';

-- Títulos: redacción del manual maestro, que conserva la puntuación que el
-- nombre del fichero de audio pierde (por ejemplo, «1215/1997»).

update public.lesson_audio_segments set title = 'Objeto de la formación y ámbito de aplicación' where id = '3ea6cb5d-e436-40be-8dca-c92a0470eaf8';
update public.lesson_audio_segments set title = 'Fases del movimiento de tierras' where id = '08c554d8-6c31-4a49-9978-95d0e5b92cc3';
update public.lesson_audio_segments set title = 'Arranque del material y elección del método' where id = 'dc01d8d2-1bd8-433c-b4a7-530d63155247';
update public.lesson_audio_segments set title = 'Pala cargadora: definición y funciones' where id = '6f6597c3-6082-449a-8e3e-af472dd254f0';
update public.lesson_audio_segments set title = 'Excavadora hidráulica de cadenas: definición y funciones' where id = 'b374d4bd-447b-4cc0-a314-7a67106171d3';
update public.lesson_audio_segments set title = 'Tractor de cadenas: definición y aplicaciones' where id = '532f1067-082d-4f33-8090-d5e9328d8292';
update public.lesson_audio_segments set title = 'Máquina base, equipos y accesorios' where id = 'c96d3d11-ccb4-465e-8e1f-4a4d90c22d30';
update public.lesson_audio_segments set title = 'Tareas comunes del operador' where id = 'fb98e5bd-72e1-41ea-8c24-9dffac5c2c44';
update public.lesson_audio_segments set title = 'Planificación, autorización y DIS' where id = '5ee8cb0b-5de2-4884-bc28-a2cd4a416418';
update public.lesson_audio_segments set title = 'El ciclo de trabajo como sistema preventivo' where id = '26982b5d-85ee-44e5-9145-41394c1b59d8';
update public.lesson_audio_segments set title = 'Preparación personal y equipos de protección' where id = 'bed26a0f-cafd-4f6d-92fd-d99a799bccc6';
update public.lesson_audio_segments set title = 'Inspección perimetral de la máquina' where id = '03afedbe-c237-4d5b-a512-128d2b1ad439';
update public.lesson_audio_segments set title = 'Niveles, fugas y circuitos calientes' where id = '1b0c89db-60b0-4fea-9dab-d75535477d1c';
update public.lesson_audio_segments set title = 'Neumáticos y tren de rodaje' where id = 'eb0d2592-5c36-4246-81d5-38b3c1e469f2';
update public.lesson_audio_segments set title = 'Equipo de trabajo y sistema hidráulico' where id = 'cf65a99a-7066-41a1-953b-30a9abe7744a';
update public.lesson_audio_segments set title = 'Acceso seguro y acondicionamiento de la cabina' where id = '4a35e368-9ce3-4311-9097-68aa0696b40d';
update public.lesson_audio_segments set title = 'Comprobaciones funcionales antes de desplazarse' where id = '8e252487-7232-4403-a21c-b60dfa509076';
update public.lesson_audio_segments set title = 'Mantenimiento básico, bloqueo y consignación' where id = '1bb107f7-aa0f-483e-9f1c-4cd420f4d99c';
update public.lesson_audio_segments set title = 'Cambio seguro de accesorios' where id = '2e836979-67e6-4ec6-af42-bd8a534fedbc';
update public.lesson_audio_segments set title = 'Embarque, transporte, remolcado y recuperación' where id = '59053542-f55f-48bc-b9ae-6d34486ba367';
update public.lesson_audio_segments set title = 'Arranque, calentamiento y preparación operativa' where id = '4787b4f2-2066-4550-aba6-93fde7106745';
update public.lesson_audio_segments set title = 'Visibilidad, zonas ciegas y control del área' where id = 'fa6aa3cc-b90f-4d02-8b99-499898aa0271';
update public.lesson_audio_segments set title = 'Carga segura con pala cargadora' where id = '0c9784bc-b394-4355-b462-eba7a6e53d2b';
update public.lesson_audio_segments set title = 'Excavación y carga con excavadora hidráulica' where id = '3d8d087e-0329-4bdb-86f4-1b1a39af3d0b';
update public.lesson_audio_segments set title = 'Operación segura con tractor de cadenas' where id = '34aac588-62ea-4e25-a161-8a421e403498';
update public.lesson_audio_segments set title = 'Circulación por pistas, rampas y cruces' where id = '2a5e83bc-34d2-462c-94ef-ae3172c7aabc';
update public.lesson_audio_segments set title = 'Taludes, frentes, zanjas y bordes' where id = '8a23e403-cb8a-4f84-b869-b1fec4a57eb2';
update public.lesson_audio_segments set title = 'Descarga en camiones, tolvas y acopios' where id = '1dbdc46e-7cc5-4fff-b95a-f7d4b0dc5fa5';
update public.lesson_audio_segments set title = 'Elevación de cargas con maquinaria' where id = '0785e7ef-6e46-49b4-9088-ab911ac310c1';
update public.lesson_audio_segments set title = 'Estacionamiento, parada y comunicación de incidencias' where id = '1608bffc-f128-492d-ad6a-7ba50d39e1a1';
update public.lesson_audio_segments set title = 'Motor, refrigeración y lubricación' where id = 'd24e2e89-b7dc-4402-889a-af2edb90d741';
update public.lesson_audio_segments set title = 'Transmisión, articulación y tracción' where id = '572ed493-f96d-4a04-95ce-9bb7baeff4ca';
update public.lesson_audio_segments set title = 'Sistema hidráulico y energía acumulada' where id = '5a137e81-bcf5-459d-a3ac-1fe8b813ea60';
update public.lesson_audio_segments set title = 'Equipos de trabajo, accesorios y capacidades' where id = '1d109b47-1c32-421a-b955-7e224005ab98';
update public.lesson_audio_segments set title = 'Neumáticos, cadenas y contacto con el terreno' where id = 'f83383ba-9d29-418f-b7b8-4efe4e36a1f6';
update public.lesson_audio_segments set title = 'Frenos, dirección y control de movimiento' where id = '7bda6a8d-1482-4273-82f9-d410f53bebd9';
update public.lesson_audio_segments set title = 'ROPS, FOPS y cinturón de seguridad' where id = 'cff70fcd-f740-454e-b929-c77e427a922f';
update public.lesson_audio_segments set title = 'Bloqueos, resguardos y prevención del movimiento' where id = '61f6701f-1cd3-4ad6-b156-af7d8002e4ae';
update public.lesson_audio_segments set title = 'Instrumentos, alarmas y dispositivos de aviso' where id = '8ee83de1-3f3c-4623-a4a4-68fd0b970d49';
update public.lesson_audio_segments set title = 'Manual del fabricante y adecuación al Real Decreto 1215/1997' where id = '5ae4bf4b-77d9-4927-81fe-38225bc95d18';
update public.lesson_audio_segments set title = 'Vigilancia de frentes, plataformas y taludes' where id = '428bd246-86e2-4374-9b7c-7201bd8b489b';
update public.lesson_audio_segments set title = 'Pistas, bermas, drenaje y control del polvo' where id = '56f038d1-68b6-4043-8bf0-cdcedd1150fd';
update public.lesson_audio_segments set title = 'Interferencia entre pala cargadora y camión' where id = '6beaf9e3-7163-4569-a85c-9d08fc179525';
update public.lesson_audio_segments set title = 'Interferencia entre excavadora y vehículo de transporte' where id = 'a047bed6-d93b-4a6e-8c68-d9183416a1ab';
update public.lesson_audio_segments set title = 'Personal de tierra, señalistas y comunicaciones' where id = '5d21d606-7e55-4bbb-b906-98712fdb4b2e';
update public.lesson_audio_segments set title = 'Trabajos próximos a líneas eléctricas' where id = 'be26e482-31f8-47e3-a360-c4f0cd381fa9';
update public.lesson_audio_segments set title = 'Interferencias durante mantenimiento y reparación' where id = 'e0fe5d49-ec2d-4557-ac2d-c7256a572eb8';
update public.lesson_audio_segments set title = 'Incendio, primeros auxilios y conducta PAS' where id = 'cdf49c8b-876a-4ecd-a617-a27e1e40e350';
update public.lesson_audio_segments set title = 'Plan de emergencia y evacuación' where id = 'ef16ec71-c956-4d5a-a57a-c0a4026e64ac';
update public.lesson_audio_segments set title = 'Marco normativo, derechos y obligaciones' where id = '66fd077b-add7-468d-ac7a-4e4a0789c37c';
update public.lesson_segment_slides set title = 'Objeto de la formación y ámbito de aplicación', alt_text = 'Diapositiva 1.1: Objeto de la formación y ámbito de aplicación' where id = 'ed0449de-2629-4025-b4f0-c8d159c19f20';
update public.lesson_segment_slides set title = 'Fases del movimiento de tierras', alt_text = 'Diapositiva 1.2: Fases del movimiento de tierras' where id = 'e6f67aa3-84e1-48b8-901d-81c9e4abada7';
update public.lesson_segment_slides set title = 'Arranque del material y elección del método', alt_text = 'Diapositiva 1.3: Arranque del material y elección del método' where id = '17fbd61c-106a-4e75-b912-4f7afaee5017';
update public.lesson_segment_slides set title = 'Pala cargadora: definición y funciones', alt_text = 'Diapositiva 1.4: Pala cargadora: definición y funciones' where id = '51ac4415-1f64-4554-b958-a54ed209c8b8';
update public.lesson_segment_slides set title = 'Excavadora hidráulica de cadenas: definición y funciones', alt_text = 'Diapositiva 1.5: Excavadora hidráulica de cadenas: definición y funciones' where id = 'cca95302-9afc-4642-8392-90b0827f18f0';
update public.lesson_segment_slides set title = 'Tractor de cadenas: definición y aplicaciones', alt_text = 'Diapositiva 1.6: Tractor de cadenas: definición y aplicaciones' where id = '49d9a7d6-7285-4caf-9b9b-bda5e39ef188';
update public.lesson_segment_slides set title = 'Máquina base, equipos y accesorios', alt_text = 'Diapositiva 1.7: Máquina base, equipos y accesorios' where id = 'f62d93ae-fae1-4027-a995-d146f96a7164';
update public.lesson_segment_slides set title = 'Tareas comunes del operador', alt_text = 'Diapositiva 1.8: Tareas comunes del operador' where id = '60e4e60b-a4ad-4bce-afb9-a78e298110c3';
update public.lesson_segment_slides set title = 'Planificación, autorización y DIS', alt_text = 'Diapositiva 1.9: Planificación, autorización y DIS' where id = 'e2bc0d31-3455-453d-af31-ca6dbe6fcf51';
update public.lesson_segment_slides set title = 'El ciclo de trabajo como sistema preventivo', alt_text = 'Diapositiva 1.10: El ciclo de trabajo como sistema preventivo' where id = 'b452849f-c694-40b3-ad0e-5f3d8c699357';
update public.lesson_segment_slides set title = 'Preparación personal y equipos de protección', alt_text = 'Diapositiva 2.1: Preparación personal y equipos de protección' where id = 'cd183281-4620-469f-97b2-cef2a2f968b5';
update public.lesson_segment_slides set title = 'Inspección perimetral de la máquina', alt_text = 'Diapositiva 2.2: Inspección perimetral de la máquina' where id = 'ecf80587-c1a7-41aa-9aca-06542af842be';
update public.lesson_segment_slides set title = 'Niveles, fugas y circuitos calientes', alt_text = 'Diapositiva 2.3: Niveles, fugas y circuitos calientes' where id = 'eee53940-8c63-4267-847a-61ad03c29ed6';
update public.lesson_segment_slides set title = 'Neumáticos y tren de rodaje', alt_text = 'Diapositiva 2.4: Neumáticos y tren de rodaje' where id = '98e7b040-528b-4dc4-8c63-c212a7d8acf4';
update public.lesson_segment_slides set title = 'Equipo de trabajo y sistema hidráulico', alt_text = 'Diapositiva 2.5: Equipo de trabajo y sistema hidráulico' where id = '91230ea1-2cc2-40f1-bdd8-cd4fe917f5fe';
update public.lesson_segment_slides set title = 'Acceso seguro y acondicionamiento de la cabina', alt_text = 'Diapositiva 2.6: Acceso seguro y acondicionamiento de la cabina' where id = 'fc1acb6d-ec08-48c2-88c1-8cdc65f7bf3b';
update public.lesson_segment_slides set title = 'Comprobaciones funcionales antes de desplazarse', alt_text = 'Diapositiva 2.7: Comprobaciones funcionales antes de desplazarse' where id = '75876829-4441-455b-b122-c1d9e37fb7bf';
update public.lesson_segment_slides set title = 'Mantenimiento básico, bloqueo y consignación', alt_text = 'Diapositiva 2.8: Mantenimiento básico, bloqueo y consignación' where id = 'e6f01f65-97ef-4946-baab-0efa85b16441';
update public.lesson_segment_slides set title = 'Cambio seguro de accesorios', alt_text = 'Diapositiva 2.9: Cambio seguro de accesorios' where id = '6b0a3901-d016-4d80-a230-dab52a5f153b';
update public.lesson_segment_slides set title = 'Embarque, transporte, remolcado y recuperación', alt_text = 'Diapositiva 2.10: Embarque, transporte, remolcado y recuperación' where id = '7fab83a8-2b71-4992-b632-8e641f25e7dd';
update public.lesson_segment_slides set title = 'Arranque, calentamiento y preparación operativa', alt_text = 'Diapositiva 3.1: Arranque, calentamiento y preparación operativa' where id = 'bb49b22b-f61b-4f15-a939-655967431829';
update public.lesson_segment_slides set title = 'Visibilidad, zonas ciegas y control del área', alt_text = 'Diapositiva 3.2: Visibilidad, zonas ciegas y control del área' where id = '04beb5b2-3666-4c8a-b3ed-d4d529f022ed';
update public.lesson_segment_slides set title = 'Carga segura con pala cargadora', alt_text = 'Diapositiva 3.3: Carga segura con pala cargadora' where id = 'd26126e1-59f5-4597-816e-e3163aa05c2b';
update public.lesson_segment_slides set title = 'Excavación y carga con excavadora hidráulica', alt_text = 'Diapositiva 3.4: Excavación y carga con excavadora hidráulica' where id = '121875a7-f5b4-4513-9cc0-49b778442617';
update public.lesson_segment_slides set title = 'Operación segura con tractor de cadenas', alt_text = 'Diapositiva 3.5: Operación segura con tractor de cadenas' where id = '2bc1a971-f6fb-490e-91bf-582623799af0';
update public.lesson_segment_slides set title = 'Circulación por pistas, rampas y cruces', alt_text = 'Diapositiva 3.6: Circulación por pistas, rampas y cruces' where id = '8eaade53-b2de-4761-bb1a-512dbc66214a';
update public.lesson_segment_slides set title = 'Taludes, frentes, zanjas y bordes', alt_text = 'Diapositiva 3.7: Taludes, frentes, zanjas y bordes' where id = '23ff4912-49c4-4125-b367-37db45c564f8';
update public.lesson_segment_slides set title = 'Descarga en camiones, tolvas y acopios', alt_text = 'Diapositiva 3.8: Descarga en camiones, tolvas y acopios' where id = 'd6e6c935-5bcf-4eb1-b8a5-fc8ed9c957ff';
update public.lesson_segment_slides set title = 'Elevación de cargas con maquinaria', alt_text = 'Diapositiva 3.9: Elevación de cargas con maquinaria' where id = 'cb4c8d4f-e5fa-4415-9a5e-f94aa7a5b9ed';
update public.lesson_segment_slides set title = 'Estacionamiento, parada y comunicación de incidencias', alt_text = 'Diapositiva 3.10: Estacionamiento, parada y comunicación de incidencias' where id = '5af93268-fbe1-4b19-a38e-658343e8b5ef';
update public.lesson_segment_slides set title = 'Motor, refrigeración y lubricación', alt_text = 'Diapositiva 4.1: Motor, refrigeración y lubricación' where id = 'd8d8d8c5-1e15-4fe3-b3f7-8fe868f80211';
update public.lesson_segment_slides set title = 'Transmisión, articulación y tracción', alt_text = 'Diapositiva 4.2: Transmisión, articulación y tracción' where id = '77380c71-e3e8-4ac7-85a6-b5ffae324ef2';
update public.lesson_segment_slides set title = 'Sistema hidráulico y energía acumulada', alt_text = 'Diapositiva 4.3: Sistema hidráulico y energía acumulada' where id = '77d8f321-8957-45cc-bbcd-15f308bea7f9';
update public.lesson_segment_slides set title = 'Equipos de trabajo, accesorios y capacidades', alt_text = 'Diapositiva 4.4: Equipos de trabajo, accesorios y capacidades' where id = 'f70bc3a3-c987-4a22-977a-ea5972fb0676';
update public.lesson_segment_slides set title = 'Neumáticos, cadenas y contacto con el terreno', alt_text = 'Diapositiva 4.5: Neumáticos, cadenas y contacto con el terreno' where id = '9f383f16-5a13-4556-af1a-faeef7b93908';
update public.lesson_segment_slides set title = 'Frenos, dirección y control de movimiento', alt_text = 'Diapositiva 4.6: Frenos, dirección y control de movimiento' where id = '72faa5ec-8c6e-4dcf-809b-6da084fc3407';
update public.lesson_segment_slides set title = 'ROPS, FOPS y cinturón de seguridad', alt_text = 'Diapositiva 4.7: ROPS, FOPS y cinturón de seguridad' where id = '3f60c428-f377-47d1-ab1d-4b5ffd6a8a89';
update public.lesson_segment_slides set title = 'Bloqueos, resguardos y prevención del movimiento', alt_text = 'Diapositiva 4.8: Bloqueos, resguardos y prevención del movimiento' where id = 'e6094e80-a320-437c-995c-c322b49f9a81';
update public.lesson_segment_slides set title = 'Instrumentos, alarmas y dispositivos de aviso', alt_text = 'Diapositiva 4.9: Instrumentos, alarmas y dispositivos de aviso' where id = '82314a23-4cf2-4048-ac20-5a9b284cee66';
update public.lesson_segment_slides set title = 'Manual del fabricante y adecuación al Real Decreto 1215/1997', alt_text = 'Diapositiva 4.10: Manual del fabricante y adecuación al Real Decreto 1215/1997' where id = 'db363a78-53b1-4052-a680-c0fd753683a7';
update public.lesson_segment_slides set title = 'Vigilancia de frentes, plataformas y taludes', alt_text = 'Diapositiva 5.1: Vigilancia de frentes, plataformas y taludes' where id = '7655ba24-d07d-4ef6-ae92-3c26a703eaa9';
update public.lesson_segment_slides set title = 'Pistas, bermas, drenaje y control del polvo', alt_text = 'Diapositiva 5.2: Pistas, bermas, drenaje y control del polvo' where id = '628f4e51-2a5d-4f5d-b4b9-60a7e7cd6d95';
update public.lesson_segment_slides set title = 'Interferencia entre pala cargadora y camión', alt_text = 'Diapositiva 5.3: Interferencia entre pala cargadora y camión' where id = 'f848e41c-3ce0-4827-9512-e76f2d453526';
update public.lesson_segment_slides set title = 'Interferencia entre excavadora y vehículo de transporte', alt_text = 'Diapositiva 5.4: Interferencia entre excavadora y vehículo de transporte' where id = 'be5a548d-e74a-4998-8c1a-d3941e68535d';
update public.lesson_segment_slides set title = 'Personal de tierra, señalistas y comunicaciones', alt_text = 'Diapositiva 5.5: Personal de tierra, señalistas y comunicaciones' where id = 'ffbb80a3-2689-45af-adce-392fd1d61fe2';
update public.lesson_segment_slides set title = 'Trabajos próximos a líneas eléctricas', alt_text = 'Diapositiva 5.6: Trabajos próximos a líneas eléctricas' where id = 'fe830d7b-08c3-4af9-89ca-1a3a06777f21';
update public.lesson_segment_slides set title = 'Interferencias durante mantenimiento y reparación', alt_text = 'Diapositiva 5.7: Interferencias durante mantenimiento y reparación' where id = 'f6de687a-63ab-4b53-afd9-55c53416c487';
update public.lesson_segment_slides set title = 'Incendio, primeros auxilios y conducta PAS', alt_text = 'Diapositiva 5.8: Incendio, primeros auxilios y conducta PAS' where id = '844ab826-f043-413d-9706-c0f662f7b8a5';
update public.lesson_segment_slides set title = 'Plan de emergencia y evacuación', alt_text = 'Diapositiva 5.9: Plan de emergencia y evacuación' where id = '62ecee60-dfc8-4ce0-8d51-0af2698cb351';
update public.lesson_segment_slides set title = 'Marco normativo, derechos y obligaciones', alt_text = 'Diapositiva 5.10: Marco normativo, derechos y obligaciones' where id = 'e7a0c3f7-18f7-4a1f-9d63-4341d856a6f5';

-- Transcripciones: guion registrado de cada locución, tomado del manual maestro.

update public.lesson_audio_segments set narration_text = $n$Este curso proporciona la formación preventiva inicial para operadores de maquinaria de arranque, carga y viales en actividades extractivas de exterior. Se aplica especialmente a quienes manejan palas cargadoras, excavadoras hidráulicas de cadenas y tractores de cadenas, tanto si pertenecen a la empresa explotadora como a una contrata. Su finalidad no es enseñar únicamente a mover los mandos, sino a reconocer los peligros de cada operación, aplicar las medidas preventivas y trabajar conforme al manual de la máquina y a las disposiciones internas de seguridad. La formación tiene una duración reglamentaria de veinte horas y debe relacionarse siempre con el equipo concreto, el terreno y la organización real de la explotación.$n$ where id = '3ea6cb5d-e436-40be-8dca-c92a0470eaf8';
update public.lesson_audio_segments set narration_text = $n$El movimiento de tierras comprende una secuencia de operaciones relacionadas: arranque, carga, transporte y descarga. Según el trabajo, también puede incluir extendido, nivelación, compactación y refino. Cada fase modifica las condiciones del terreno y genera riesgos propios, pero ninguna debe analizarse de forma aislada. Una carga mal ejecutada puede desestabilizar el vehículo de transporte; una pista deficiente puede provocar vuelcos; y una descarga incorrecta puede comprometer el borde de una escombrera. Por eso, antes de iniciar el ciclo, el operador debe conocer el material, el recorrido, las zonas de cruce, el punto de descarga y la presencia de personas o equipos que puedan interferir.$n$ where id = '08c554d8-6c31-4a49-9978-95d0e5b92cc3';
update public.lesson_audio_segments set narration_text = $n$Arrancar un material significa separarlo de su estado natural para que pueda cargarse y transportarse. El método depende de su dureza, fracturación, humedad, pendiente y volumen. En roca competente puede ser necesaria una voladura previamente diseñada y ejecutada por personal autorizado. En materiales ripables puede utilizarse un tractor de cadenas con escarificador, mientras que una excavadora puede realizar arranque mecánico con cuchara, ripper o martillo cuando el fabricante lo permite. El operador no debe improvisar el método ni superar las capacidades del equipo. Si aparecen bloques inestables, vibraciones anormales o un frente con riesgo de desprendimiento, se detiene la operación y se comunica la incidencia.$n$ where id = 'dc01d8d2-1bd8-433c-b4a7-530d63155247';
update public.lesson_audio_segments set narration_text = $n$La pala cargadora es una máquina autopropulsada, normalmente sobre ruedas, con un equipo frontal destinado principalmente a cargar mediante el avance de la propia máquina. Su ciclo habitual combina aproximación al material, llenado del cucharón, retroceso, desplazamiento corto y descarga sobre un camión, una tolva o un acopio. También puede limpiar pistas, alimentar instalaciones o manipular materiales con accesorios autorizados. Su articulación central le da maniobrabilidad, pero crea una zona peligrosa de atrapamiento. Además, el peso del cucharón elevado altera la estabilidad y reduce la visibilidad. La conducción debe hacerse con el equipo bajo, velocidad adaptada y bastidores alineados al penetrar en el acopio.$n$ where id = '6f6597c3-6082-449a-8e3e-af472dd254f0';
update public.lesson_audio_segments set narration_text = $n$La excavadora hidráulica de cadenas dispone de una superestructura que normalmente gira trescientos sesenta grados sobre un tren de rodaje. Excava y carga sin desplazar la base durante cada ciclo, utilizando pluma, balancín, cuchara u otros accesorios admitidos. Es adecuada para trabajar desde una plataforma estable, formar frentes, abrir zanjas y cargar vehículos situados dentro de su alcance. Sus principales riesgos proceden del giro, las zonas ciegas, la pérdida de estabilidad, los taludes y la energía hidráulica. Antes de comenzar, el operador debe comprobar la capacidad portante del terreno, mantener el tren de rodaje bien apoyado y delimitar el radio de giro para impedir el acceso de personas.$n$ where id = 'b374d4bd-447b-4cc0-a314-7a67106171d3';
update public.lesson_audio_segments set narration_text = $n$El tractor de cadenas es una máquina autopropulsada equipada con una hoja para cortar, empujar y nivelar materiales, o con equipos que ejercen fuerza de empuje o tracción. Puede incorporar escarificador para ripar terrenos compactos o roca blanda, acondicionar pistas, conformar escombreras y apoyar la recuperación de otras máquinas cuando existe un procedimiento autorizado. Su capacidad de tracción no elimina el riesgo de vuelco, deslizamiento o caída por un borde. El operador debe conocer la pendiente máxima permitida, evitar giros bruscos en laderas, mantener distancia a coronaciones y no utilizar el tractor como equipo de remolque o elevación fuera de las condiciones definidas por el fabricante y la explotación.$n$ where id = '532f1067-082d-4f33-8090-d5e9328d8292';
update public.lesson_audio_segments set narration_text = $n$La máquina base es el conjunto autopropulsado sin los implementos que determinan la tarea. El equipo de trabajo y los accesorios -como cucharas, horquillas, martillos, escarificadores o pinzas- modifican la capacidad, el centro de gravedad, la visibilidad y los riesgos. Un accesorio compatible físicamente no es necesariamente seguro: debe estar autorizado por el fabricante o evaluado técnicamente, tener capacidad adecuada y utilizar el sistema de acoplamiento previsto. Tras un cambio, se comprueba visual y funcionalmente el bloqueo, se realiza una prueba a baja altura y se verifica que las tablas de carga o limitaciones aplicables siguen siendo válidas. Nunca se trabaja confiando solo en que el enganche parece cerrado.$n$ where id = 'c96d3d11-ccb4-465e-8e1f-4a4d90c22d30';
update public.lesson_audio_segments set narration_text = $n$Además de manejar la máquina, el operador realiza tareas preventivas esenciales: inspección diaria, comprobación de niveles, limpieza de elementos de visibilidad, comunicación de defectos y mantenimiento básico autorizado. También debe interpretar alarmas, respetar la señalización, circular por las rutas establecidas y dejar el equipo estacionado de forma segura. Estas obligaciones no convierten al operador en mecánico. Las reparaciones, reglajes complejos o intervenciones con energías peligrosas corresponden a personal competente y deben realizarse con bloqueo y consignación. La responsabilidad del operador consiste en detectar, informar y no utilizar una máquina cuando un defecto pueda comprometer la seguridad propia o la de terceros.$n$ where id = 'fb98e5bd-72e1-41ea-8c24-9dffac5c2c44';
update public.lesson_audio_segments set narration_text = $n$El trabajo comienza antes de subir a la cabina. El operador necesita una orden clara, autorización para el equipo y conocimiento de las disposiciones internas de seguridad, conocidas como DIS. Estas reglas concretan la circulación, prioridades, velocidades, comunicaciones, mantenimiento, vertido, trabajos cerca de líneas eléctricas y actuación ante emergencias. También deben coordinarse las contratas y las actividades simultáneas. Si el procedimiento real no coincide con la orden recibida, si el terreno ha cambiado o si falta una protección prevista, no se debe resolver mediante una maniobra improvisada. La acción correcta es detenerse en una zona segura, comunicar la desviación y obtener instrucciones antes de continuar.$n$ where id = '5ee8cb0b-5de2-4884-bc28-a2cd4a416418';
update public.lesson_audio_segments set narration_text = $n$Un ciclo seguro integra persona, máquina, material y entorno. Antes de cada maniobra se observa; durante la ejecución se controla la estabilidad, la visibilidad y la trayectoria; y al finalizar se deja el área preparada para el siguiente equipo. La productividad no consiste en acelerar cada movimiento, sino en mantener un flujo uniforme sin golpes, derrames, esperas ni correcciones peligrosas. El operador debe anticipar qué ocurrirá si cambia la pendiente, cede el terreno, entra un vehículo o falla un sistema. Esta forma de pensar permite reconocer señales tempranas y detener el ciclo antes de que una condición insegura se convierta en accidente. La seguridad forma parte de la operación, no es una comprobación separada.$n$ where id = '26982b5d-85ee-44e5-9145-41394c1b59d8';
update public.lesson_audio_segments set narration_text = $n$Antes de acceder a la máquina, el operador debe encontrarse en condiciones físicas y mentales adecuadas, sin fatiga incapacitante ni efectos de alcohol, drogas o medicamentos que reduzcan la atención. La ropa ha de quedar ajustada y sin elementos colgantes que puedan engancharse. El casco, el calzado de seguridad, el chaleco de alta visibilidad, los guantes y las protecciones auditiva, ocular o respiratoria se seleccionan según la evaluación de riesgos. Los EPI complementan las medidas colectivas, pero no sustituyen una cabina segura, una zona delimitada o un sistema de captación de polvo. También debe conocerse dónde guardarlos para evitar contaminación y cómo comprobar su estado antes de usarlos.$n$ where id = 'bed26a0f-cafd-4f6d-92fd-d99a799bccc6';
update public.lesson_audio_segments set narration_text = $n$La revisión diaria empieza desde el suelo y con la máquina inmovilizada. Se recorre todo el perímetro buscando personas, obstáculos, daños, piezas sueltas, fugas, acumulaciones de material y signos de incendio. Se comprueban peldaños, pasamanos, cristales, cámaras, espejos, luces y señalización. Bajo la máquina se observa si existen manchas recientes de combustible, aceite, refrigerante o fluido hidráulico. El cucharón, la hoja o el accesorio deben estar apoyados y sin deformaciones evidentes. Esta inspección no es un trámite: permite descubrir defectos antes de presurizar sistemas o poner en movimiento toneladas de masa. Cualquier anomalía se registra y se valora antes del arranque.$n$ where id = '03afedbe-c237-4d5b-a512-128d2b1ad439';
update public.lesson_audio_segments set narration_text = $n$Los niveles se comprueban siguiendo el manual y con la máquina en la posición indicada, porque una lectura incorrecta puede provocar sobrellenado o falta de lubricación. Nunca se abre en caliente un tapón de refrigerante ni se busca una fuga hidráulica con la mano: el fluido a presión puede penetrar la piel y causar lesiones graves. Para localizar pérdidas se emplean medios adecuados y personal competente. Al repostar, se detiene el motor, se evita cualquier fuente de ignición y se controla el derrame. Si aparece olor a combustible, una manguera dañada o pérdida importante, la máquina queda fuera de servicio hasta que se elimine la causa, no solo hasta limpiar la mancha.$n$ where id = '1b0c89db-60b0-4fea-9dab-d75535477d1c';
update public.lesson_audio_segments set narration_text = $n$En una pala se revisan presión, cortes, abultamientos, desgaste, llantas y fijaciones. Los neumáticos de gran tamaño pueden liberar mucha energía; su inflado y reparación exigen procedimientos y equipos específicos, sin situarse frente al aro o a la trayectoria de una posible proyección. En máquinas de cadenas se inspeccionan tejas, bulones, rodillos, rueda guía, rueda motriz y tensión aparente. Una cadena excesivamente floja puede salirse y una demasiado tensa acelera el desgaste. También se retiran piedras atrapadas solo con el equipo parado y asegurado. El operador comunica daños o desgaste anormal y no intenta intervenir si la tarea excede el mantenimiento autorizado.$n$ where id = 'eb0d2592-5c36-4246-81d5-38b3c1e469f2';
update public.lesson_audio_segments set narration_text = $n$El cucharón, la hoja, la pluma, el balancín y los accesorios soportan esfuerzos elevados. Antes del uso se inspeccionan soldaduras, pasadores, bulones, dientes, cuchillas, retenedores, cilindros y latiguillos. Una fisura, un pasador desplazado o una fuga puede terminar en caída del accesorio o pérdida de control. Las mangueras no deben presentar rozaduras, ampollas ni alambres expuestos. Ninguna persona debe situarse bajo un equipo elevado sin bloqueo mecánico certificado. Si se necesita limpiar o revisar una articulación, se apoya el equipo, se descarga la presión residual, se detiene el motor y se aplica el procedimiento de aislamiento previsto.$n$ where id = 'cf65a99a-7066-41a1-953b-30a9abe7744a';
update public.lesson_audio_segments set narration_text = $n$Se sube y baja mirando hacia la máquina y manteniendo tres puntos de apoyo. Los peldaños y asideros deben estar limpios de barro, grasa, hielo o material suelto. No se utiliza el volante, una palanca ni una manguera como agarradero, y nunca se salta desde la cabina. Una vez dentro, se ajustan asiento, reposabrazos, espejos y mandos para trabajar sin posturas forzadas. Se limpia el parabrisas, se comprueba la salida de emergencia y se retiran objetos sueltos que podrían bloquear pedales. El cinturón se abrocha antes de mover la máquina; la estructura ROPS protege de forma eficaz cuando el operador permanece dentro del espacio protegido.$n$ where id = '4a35e368-9ce3-4311-9097-68aa0696b40d';
update public.lesson_audio_segments set narration_text = $n$Tras arrancar, se observan el panel y las alarmas mientras el motor alcanza las condiciones indicadas por el fabricante. Antes de entrar en producción se prueban freno de servicio, estacionamiento, dirección, bocina, alarma de retroceso, luces, limpiaparabrisas y mandos del equipo en una zona segura. En excavadoras se comprueba el bloqueo hidráulico y el freno o control de giro; en palas, la dirección de emergencia cuando proceda. La prueba se realiza a baja velocidad, sin personas cerca y atendiendo a ruidos, vibraciones o respuestas lentas. Una alarma no se anula para continuar trabajando: se identifica su causa y se aplica el procedimiento correspondiente.$n$ where id = '8e252487-7232-4403-a21c-b60dfa509076';
update public.lesson_audio_segments set narration_text = $n$El operador puede realizar las operaciones básicas asignadas por el fabricante y la empresa, como limpieza, engrase o comprobaciones sencillas. Antes de intervenir se estaciona en terreno firme, se apoya el equipo, se acciona el freno, se detiene el motor y se retira o controla la llave. Cuando exista riesgo por energía eléctrica, hidráulica, neumática, mecánica o térmica, se bloquea, se consigna y se verifica la ausencia de energía. Un cartel sin aislamiento físico puede ser insuficiente. Las protecciones retiradas deben colocarse antes del arranque. Si el trabajo requiere elevar la máquina o el implemento, se utilizan soportes diseñados para ello; nunca se confía únicamente en los cilindros hidráulicos.$n$ where id = '1bb107f7-aa0f-483e-9f1c-4cd420f4d99c';
update public.lesson_audio_segments set narration_text = $n$El cambio de cucharas, martillos, horquillas u otros accesorios se realiza en una superficie estable, dentro de una zona sin personas y siguiendo la secuencia del fabricante. Antes de desconectar circuitos se apaga el motor y se libera la presión residual. Los acoplamientos se mantienen limpios para evitar fallos y contaminación del sistema. Una vez instalado el accesorio, el operador verifica que los pasadores o indicadores de bloqueo estén en la posición correcta, comprueba conexiones y hace una prueba funcional próxima al suelo. Si el acoplador dispone de confirmación visual o acústica, se utiliza, pero no sustituye la inspección directa. Un accesorio mal enganchado puede desprenderse sin previo aviso.$n$ where id = '2e836979-67e6-4ec6-af42-bd8a534fedbc';
update public.lesson_audio_segments set narration_text = $n$Subir una máquina a una góndola requiere un plan: capacidad del vehículo, rampas adecuadas, terreno nivelado, alineación, ausencia de personas y guía de un señalista cuando la visibilidad sea limitada. La máquina se centra, se inmoviliza y se asegura mediante los puntos de amarre definidos. El remolcado o recuperación solo se realiza con procedimiento autorizado, elementos certificados y puntos de anclaje previstos por el fabricante. Cables y eslingas pueden romperse y generar una zona de latigazo que debe quedar despejada. Si la máquina está en pendiente, hundida o cerca de un borde, primero se estabiliza la situación y se designa una única persona para dirigir la maniobra.$n$ where id = '59053542-f55f-48bc-b9ae-6d34486ba367';
update public.lesson_audio_segments set narration_text = $n$El motor se arranca desde el puesto del operador, con los mandos neutralizados y después de confirmar que no hay nadie alrededor. No se puentean sistemas de arranque ni se pone en marcha la máquina desde el suelo. En recintos con ventilación insuficiente, los gases de escape pueden alcanzar concentraciones peligrosas. Durante el calentamiento se vigilan presión de aceite, temperatura, carga eléctrica y mensajes del panel. Antes de aplicar carga se comprueba que los sistemas responden de forma normal. El tiempo y régimen de calentamiento dependen del fabricante y de la temperatura ambiente. Si la máquina produce humo anormal, golpeteos o una alarma persistente, se detiene y se informa antes de iniciar el trabajo.$n$ where id = '4787b4f2-2066-4550-aba6-93fde7106745';
update public.lesson_audio_segments set narration_text = $n$Las máquinas grandes tienen zonas ciegas que pueden ocultar por completo a una persona o a un vehículo ligero. Cámaras, espejos, alarmas y sensores ayudan, pero no eliminan la obligación de observar. Antes de moverse se revisa el entorno, se avisa y se espera el tiempo suficiente para que todos reaccionen. Cuando la maniobra no puede controlarse desde la cabina, interviene un señalista identificado, situado en un lugar visible y utilizando señales acordadas. Si se pierde el contacto, la máquina se detiene. Está prohibido permitir pasajeros salvo que exista un asiento homologado. El radio de giro y la zona bajo el equipo de trabajo se mantienen libres.$n$ where id = 'fa6aa3cc-b90f-4d02-8b99-499898aa0271';
update public.lesson_audio_segments set narration_text = $n$Para cargar con pala, se aproxima el cucharón bajo y con los bastidores alineados. El ataque se realiza sobre una superficie firme y lo más horizontal posible, utilizando el ancho del cucharón sin embestir el acopio. Se evita hacer girar la articulación con el cucharón enterrado, porque aumenta esfuerzos y reduce estabilidad. Tras el llenado se inclina el cucharón para retener el material y se retrocede mirando la trayectoria. Durante el desplazamiento se mantiene bajo, sin superar la carga nominal. La descarga sobre un camión se hace sin golpear la caja ni pasar sobre la cabina. El operador distribuye la carga de forma uniforme siguiendo la comunicación establecida con el conductor.$n$ where id = '0c9784bc-b394-4355-b462-eba7a6e53d2b';
update public.lesson_audio_segments set narration_text = $n$La excavadora trabaja sobre una plataforma resistente, nivelada y con espacio para el giro. Antes de excavar se identifica la presencia de servicios enterrados y se evalúa el frente o la zanja. El vehículo de transporte se coloca fuera de la zona de caída de material y, cuando sea posible, de forma que la cuchara no pase sobre la cabina. Los movimientos deben ser suaves, evitando giros bruscos con carga máxima y golpes laterales con la cuchara. No se socava la base del terreno que sostiene la máquina. Si el operador pierde visibilidad del camión o de la persona que dirige la maniobra, detiene el ciclo hasta recuperar una comunicación segura.$n$ where id = '3d8d087e-0329-4bdb-86f4-1b1a39af3d0b';
update public.lesson_audio_segments set narration_text = $n$Con el tractor se empuja o ripa manteniendo una trayectoria que preserve la estabilidad. En pendientes se trabaja preferentemente en la dirección definida por el fabricante y por el procedimiento de la explotación, evitando cruzarlas lateralmente o girar bruscamente. La hoja se lleva baja durante los desplazamientos y nunca se utiliza como freno improvisado salvo en una emergencia contemplada. Cerca de un borde, la distancia debe considerar grietas, material suelto y posible rotura del terreno, no solo la posición visible de la coronación. Al ripar se evita enganchar obstáculos desconocidos y se detiene la operación si aparecen vibraciones, pérdida de control o una resistencia superior a la prevista.$n$ where id = '34aac588-62ea-4e25-a161-8a421e403498';
update public.lesson_audio_segments set narration_text = $n$La velocidad se adapta a la carga, visibilidad, anchura, pendiente, firme y tráfico; el límite indicado es un máximo, no una velocidad obligatoria. En palas, el cucharón se transporta bajo tanto cargado como vacío, dejando altura suficiente para no golpear el terreno. Se respetan sentidos, prioridades y distancias de seguridad de las DIS. En rampas se utiliza la marcha y el sistema de retención recomendados, sin circular en punto muerto. Los adelantamientos solo se realizan donde estén permitidos y exista visibilidad. Antes de cruzar una zona ocupada, se confirma la intención por radio o señalización. Polvo, lluvia, barro o baches obligan a reducir la velocidad o detener la circulación.$n$ where id = '2a5e83bc-34d2-462c-94ef-ae3172c7aabc';
update public.lesson_audio_segments set narration_text = $n$El terreno próximo a un talud o una zanja puede fallar sin que el borde aparente se mueva. Se respetan las distancias definidas tras evaluar altura, material, fracturas, humedad, sobrecargas y vibraciones. Nunca se trabaja bajo bloques o viseras sin sanear. En zanjas se identifican servicios, se controla la estabilidad y se aplican entibación, taludes o accesos seguros cuando correspondan. La máquina no debe socavar su propia plataforma. Tras lluvias, voladuras o cambios del frente se repite la inspección. Si aparecen grietas, caída de pequeños fragmentos o deformaciones, se retira el equipo a una zona segura y se informa; continuar para terminar una pasada puede agravar el fallo.$n$ where id = '8a23e403-cb8a-4f84-b869-b1fec4a57eb2';
update public.lesson_audio_segments set narration_text = $n$La descarga exige coordinación y control de la trayectoria del material. Al cargar camiones se evita sobrepasar la capacidad, concentrar todo el peso en un extremo o dejar bloques inestables. En tolvas, la pala se aproxima sobre firme estable, con topes o protecciones adecuados y sin confiar en ellos como freno. No se empuja material mientras haya personas en el punto de vertido. En acopios se controla la pendiente y se evita formar paredes inestables. Si el material queda adherido, no se realizan sacudidas violentas ni golpes improvisados. La limpieza o desatasco se efectúa con el equipo parado, aislado y conforme al procedimiento específico de la instalación.$n$ where id = '1dbdc46e-7cc5-4fff-b95a-f7d4b0dc5fa5';
update public.lesson_audio_segments set narration_text = $n$Una pala o excavadora solo puede elevar cargas cuando el fabricante lo permite, el equipo está configurado para esa función y la explotación dispone del procedimiento correspondiente. Deben conocerse la masa, el radio, la altura y la tabla de capacidad, que disminuye al aumentar el alcance. La carga se engancha en puntos previstos con accesorios de elevación certificados; nunca en dientes, cucharas o elementos no diseñados. Se utiliza dispositivo de control de carga cuando sea exigible y se evita el paso sobre personas. Un señalista coordina la maniobra si la visibilidad es limitada. Las cargas se desplazan bajas, lentamente y sin tirones, considerando pendiente, viento y estabilidad del terreno.$n$ where id = '0785e7ef-6e46-49b4-9088-ab911ac310c1';
update public.lesson_audio_segments set narration_text = $n$Al terminar, la máquina se estaciona en la zona designada, sobre terreno firme y preferentemente horizontal. Se coloca la transmisión en neutro, se acciona el freno, se apoya por completo el equipo y se dejan los mandos sin energía. El enfriamiento y la parada del motor siguen las instrucciones del fabricante, especialmente después de trabajos intensos. Se retira la llave, se cierra la cabina y se colocan calzos cuando el procedimiento lo exija. El relevo recibe información sobre alarmas, golpes, fugas o comportamiento anormal. Una incidencia pendiente debe quedar registrada de forma clara; no basta con comentarla informalmente. Si afecta a la seguridad, la máquina permanece señalizada y fuera de servicio.$n$ where id = '1608bffc-f128-492d-ad6a-7ba50d39e1a1';
update public.lesson_audio_segments set narration_text = $n$El motor transforma la energía del combustible en movimiento y calor. Su seguridad depende de una correcta lubricación, refrigeración y admisión de aire. El operador vigila presión de aceite, temperatura del refrigerante, nivel de combustible y estado de filtros e indicadores. Una temperatura alta puede deberse a radiadores obstruidos, nivel insuficiente o avería del ventilador; continuar trabajando puede causar incendio o rotura grave. La limpieza del radiador se realiza con el motor parado y medios adecuados, evitando aire o agua a presión que dañen componentes. Los productos calientes se manipulan solo tras enfriamiento y siguiendo el manual. Nunca se elimina una alarma sin haber identificado y corregido su causa.$n$ where id = 'd24e2e89-b7dc-4402-889a-af2edb90d741';
update public.lesson_audio_segments set narration_text = $n$La transmisión entrega la potencia a ruedas o cadenas y permite adaptar velocidad y esfuerzo. En una pala articulada, el giro se produce en el bastidor central, creando una zona de aplastamiento que debe bloquearse mecánicamente antes de realizar trabajos entre ambos semibastidores. Diferenciales y sistemas de tracción mejoran la movilidad, pero no compensan un firme sin capacidad ni una pendiente excesiva. El operador debe evitar cambios bruscos de sentido, patinamientos prolongados y esfuerzos que superen las limitaciones del fabricante. En máquinas de cadenas, los giros cerrados aumentan desgaste y pueden desestabilizar sobre terreno irregular. Cualquier tirón, ruido o pérdida de tracción anormal se comunica antes de que evolucione a una avería peligrosa.$n$ where id = '572ed493-f96d-4a04-95ce-9bb7baeff4ca';
update public.lesson_audio_segments set narration_text = $n$El sistema hidráulico transmite grandes fuerzas mediante fluido a presión. Incluso con el motor parado puede conservar energía en acumuladores, cilindros o implementos elevados. Por eso, antes de intervenir se apoya el equipo, se descarga la presión según el procedimiento y se bloquean los movimientos posibles. Una fuga fina puede atravesar la piel; no se busca con la mano ni se aprieta una conexión presurizada. Los latiguillos se protegen frente a roce, calor y aplastamiento, y se sustituyen cuando presentan daños. Si un mando responde con retraso, aparecen movimientos espontáneos o baja el equipo sin orden, la máquina se retira de servicio hasta que personal competente revise el circuito.$n$ where id = '5a137e81-bcf5-459d-a3ac-1fe8b813ea60';
update public.lesson_audio_segments set narration_text = $n$Cada accesorio cambia la geometría y las prestaciones de la máquina. Una cuchara de mayor volumen puede superar la carga admisible con materiales densos; unas horquillas desplazan el centro de gravedad; y un martillo introduce vibraciones y proyecciones. Antes de utilizarlo se comprueban compatibilidad, peso, presión y caudal requeridos, dispositivos de retención y limitaciones del manual. La tabla de carga debe corresponder a la configuración real, incluyendo contrapeso, pluma y accesorio. El operador no emplea el equipo para funciones no previstas, como empujar lateralmente con una cuchara o izar desde un punto improvisado. Si cambia el material o el alcance, se vuelve a evaluar la capacidad y estabilidad.$n$ where id = '1d109b47-1c32-421a-b955-7e224005ab98';
update public.lesson_audio_segments set narration_text = $n$Los neumáticos y el tren de rodaje son el único contacto de la máquina con el terreno. Su estado condiciona dirección, frenado, tracción y estabilidad. En palas, una presión incorrecta o un corte puede provocar pérdida de control y calentamiento. En excavadoras y tractores, la acumulación de barro o piedras, el desgaste desigual y la tensión incorrecta afectan la marcha y aumentan el riesgo de salida de cadena. El operador debe reconocer los límites de presión sobre el suelo: una máquina pesada puede hundirse aunque la superficie parezca firme. Antes de trabajar sobre rellenos, bordes o plataformas recientes se confirma su capacidad portante y se evita concentrar cargas cerca de zonas debilitadas.$n$ where id = 'f83383ba-9d29-418f-b7b8-4efe4e36a1f6';
update public.lesson_audio_segments set narration_text = $n$La pala dispone de freno de servicio, estacionamiento y, según su diseño, sistema de emergencia. Todos cumplen funciones diferentes y deben probarse conforme al manual. La dirección principal y la de emergencia permiten conservar el control, pero esta última no autoriza a continuar la producción tras una avería. En la excavadora, el control de giro y los bloqueos hidráulicos evitan movimientos no deseados. El operador debe saber qué ocurre si se pierde presión, se para el motor o falla un circuito. Nunca se utiliza una pendiente para probar frenos. Si la respuesta cambia, aumenta el recorrido del pedal o aparece una alarma, se estaciona en un lugar seguro y se solicita revisión.$n$ where id = '7bda6a8d-1482-4273-82f9-d410f53bebd9';
update public.lesson_audio_segments set narration_text = $n$Las estructuras ROPS protegen el espacio del operador en caso de vuelco y las FOPS frente a caída de objetos, dentro de las condiciones para las que fueron diseñadas. No deben perforarse, soldarse ni modificarse sin autorización técnica, porque una alteración puede reducir su resistencia. Puertas, cristales y anclajes forman parte del conjunto de protección. El cinturón mantiene al operador dentro de ese volumen seguro y debe utilizarse siempre que la máquina se desplace o trabaje. Saltar de una máquina que vuelca suele exponer al aplastamiento. Después de un vuelco, impacto importante o daño visible, la estructura requiere evaluación; no basta con enderezar una parte deformada y volver al servicio.$n$ where id = 'cff70fcd-f740-454e-b929-c77e427a922f';
update public.lesson_audio_segments set narration_text = $n$Los bloqueos mecánicos del equipo, bastidor articulado o superestructura evitan movimientos causados por pérdida de presión, accionamiento involuntario o gravedad. Los bloqueos de mandos y transmisión reducen el riesgo de puesta en movimiento inesperada. Los resguardos separan a las personas de correas, ventiladores y elementos giratorios. Ninguno debe anularse para ganar tiempo o facilitar una comprobación. Antes de trabajar en una zona peligrosa se identifica qué energía puede mover cada componente y se instala el dispositivo previsto, no una pieza improvisada. Al finalizar, se comprueba que herramientas, soportes y personas estén fuera antes de retirar bloqueos y devolver la máquina a servicio.$n$ where id = '61f6701f-1cd3-4ad6-b156-af7d8002e4ae';
update public.lesson_audio_segments set narration_text = $n$Manómetros, termómetros, indicadores de nivel y paneles de alarma informan del estado de los sistemas principales. El operador debe conocer la lectura normal, las zonas de advertencia y la acción requerida, porque dos alarmas parecidas pueden exigir respuestas distintas. Bocina, alarma de retroceso, luces, rotativos, cámaras y espejos ayudan a comunicar el movimiento y ampliar la visión. No sustituyen una zona despejada ni una maniobra controlada. Si un indicador es ilegible o un aviso no funciona, se valora si la máquina puede utilizarse conforme al manual y al procedimiento. Tapar una luz o desconectar una alarma elimina información esencial y puede ocultar un fallo progresivo.$n$ where id = '8ee83de1-3f3c-4623-a4a4-68fd0b970d49';
update public.lesson_audio_segments set narration_text = $n$El manual de instrucciones define el uso previsto, capacidades, mantenimiento, advertencias y procedimientos de emergencia de cada modelo. Debe estar disponible y ser comprensible para el operador. Las máquinas puestas a disposición de los trabajadores deben cumplir las disposiciones aplicables del Real Decreto 1215/1997, incluyendo mandos seguros, protección frente a vuelco o caída de objetos, frenado, visibilidad y prevención del acceso a partes peligrosas. Una adecuación documental no sustituye el buen estado real del equipo. Si la configuración se modifica o se incorpora un accesorio, debe evaluarse cómo afecta a los riesgos. Ante una contradicción, prevalecen las limitaciones más seguras y se consulta al responsable técnico.$n$ where id = '5ae4bf4b-77d9-4927-81fe-38225bc95d18';
update public.lesson_audio_segments set narration_text = $n$El lugar de trabajo cambia durante la jornada. El operador observa el frente, la plataforma, las coronaciones y el pie de los taludes antes y durante la operación. Grietas, bloques sueltos, agua, deformaciones, material recién volado o pérdida de visibilidad pueden modificar el riesgo. La inspección debe repetirse después de lluvia intensa, heladas, voladuras o trabajos que alteren el terreno. La cabina no protege frente a todos los desprendimientos y nunca justifica trabajar bajo una zona sin sanear. Si existe duda sobre la estabilidad, la máquina se retira fuera del alcance posible y se solicita evaluación. La continuidad de la producción no debe anteponerse a una señal de inestabilidad.$n$ where id = '428bd246-86e2-4374-9b7c-7201bd8b489b';
update public.lesson_audio_segments set narration_text = $n$Las pistas deben mantener anchura, pendiente, firme, visibilidad y drenaje compatibles con los equipos que circulan. Baches, roderas, barro, polvo y acumulaciones en los bordes reducen el control y ocultan obstáculos. Las bermas ayudan a delimitar y contener, pero no son un sistema de frenado ni garantizan que el borde soporte una máquina. El riego y otras medidas de control del polvo deben aplicarse sin crear superficies deslizantes. El operador informa de deterioros, señaliza cuando sea posible y adapta la velocidad. Si una pista no permite circular con seguridad, se detiene su uso hasta corregirla, en lugar de confiar en la experiencia individual para superar una condición deficiente.$n$ where id = '56f038d1-68b6-4043-8bf0-cdcedd1150fd';
update public.lesson_audio_segments set narration_text = $n$La carga de un camión combina dos equipos con zonas ciegas y trayectorias distintas. El punto de espera, la aproximación y la salida deben estar definidos. El camión no entra en la zona hasta recibir autorización y la pala no inicia el ciclo hasta confirmar que está correctamente posicionado. Se evita pasar el cucharón sobre la cabina y se distribuye el material sin golpes. Ningún conductor abandona su puesto salvo que el procedimiento establezca una zona protegida. Las comunicaciones se realizan mediante señales o radio conocidas por ambos. Si aparece una persona, se pierde contacto visual o un vehículo cambia de posición sin aviso, la operación se detiene y se restablece la coordinación.$n$ where id = '6beaf9e3-7163-4569-a85c-9d08fc179525';
update public.lesson_audio_segments set narration_text = $n$La excavadora necesita un radio de giro despejado y un punto estable para el camión. La colocación se elige para reducir el giro, evitar que la cuchara pase sobre la cabina y mantener el vehículo fuera del alcance de una posible caída del frente. El conductor permanece donde establezca el procedimiento y no mueve el camión hasta recibir la señal. La excavadora no utiliza la cuchara para empujar, retener o avisar al vehículo mediante golpes. Cuando el terreno obliga a trabajar a diferente cota, se evalúan el borde, el alcance y la caída del material. Una única persona dirige la maniobra y cualquier pérdida de comunicación implica parada inmediata.$n$ where id = 'a047bed6-d93b-4a6e-8c68-d9183416a1ab';
update public.lesson_audio_segments set narration_text = $n$Las personas a pie son especialmente vulnerables frente a maquinaria móvil. Las rutas peatonales, zonas de exclusión y puntos de acceso deben estar definidos y señalizados. Para aproximarse a una máquina se establece contacto con el operador, se espera su confirmación y solo se entra cuando el equipo está inmovilizado. El señalista utiliza señales acordadas, se mantiene visible y nunca se coloca entre la máquina y un obstáculo. La radio debe emplear mensajes breves, identificando equipo, lugar e instrucción; ante una duda se repite la orden. El operador no actúa basándose en gestos ambiguos. Si varias personas dan instrucciones, se detiene el trabajo hasta designar un único interlocutor.$n$ where id = '5d21d606-7e55-4bbb-b906-98712fdb4b2e';
update public.lesson_audio_segments set narration_text = $n$Una línea aérea puede producir arco eléctrico sin contacto directo. Antes de trabajar se identifica su tensión, altura, recorrido y zona de seguridad, aplicando las distancias y medidas definidas por la normativa y el procedimiento específico. La explotación debe señalizar la aproximación -el material del curso utiliza aviso previo de veinticinco metros- y puede requerir pórticos, limitadores, vigilancia o desenergización. Se consideran todas las posiciones de pluma, cuchara, hoja y carga, así como el balanceo y las irregularidades del terreno. Si una máquina entra en contacto, el operador permanece en la cabina salvo incendio u otro peligro inmediato y se sigue el plan de emergencia para evitar tensiones de paso.$n$ where id = 'be26e482-31f8-47e3-a360-c4f0cd381fa9';
update public.lesson_audio_segments set narration_text = $n$Las reparaciones generan riesgos diferentes a la producción: equipos elevados, pruebas con motor en marcha, presencia de técnicos y energías liberadas. Antes de intervenir, operador y mantenimiento acuerdan quién controla la máquina, qué sistemas quedan aislados y cuándo puede retirarse cada bloqueo. La llave y los dispositivos de consignación no se entregan ni se eliminan sin autorización. Si una prueba requiere movimiento, la zona se delimita, se restablecen resguardos necesarios y una persona coordina la operación. Nadie permanece en la articulación, bajo un implemento o dentro del radio de giro sin protección física adecuada. Tras la reparación se realiza una entrega formal e inspección funcional antes de volver a producir.$n$ where id = 'e0fe5d49-ec2d-4557-ac2d-c7256a572eb8';
update public.lesson_audio_segments set narration_text = $n$Ante un accidente se aplica la conducta PAS: proteger, avisar y socorrer. Primero se evita que la máquina, el tráfico, la electricidad o el terreno provoquen nuevas víctimas; después se activa el sistema de emergencia con información precisa; y solo se presta ayuda dentro de la propia formación. En un incendio incipiente puede utilizarse el extintor si existe vía de escape y no se asume un riesgo adicional. Se detiene el motor cuando sea seguro y se abandona por la ruta prevista. No se mueve a una persona lesionada salvo peligro inmediato. Toda máquina debe permitir localizar con rapidez extintor, botiquín, salida alternativa y medios de comunicación.$n$ where id = 'cdf49c8b-876a-4ecd-a617-a27e1e40e350';
update public.lesson_audio_segments set narration_text = $n$El plan de emergencia define alarmas, responsables, comunicaciones, vías de evacuación y puntos de reunión. El operador debe conocer cómo dejar la máquina sin crear un obstáculo, qué hacer si una pista queda bloqueada y cómo informar de su ubicación. En una evacuación no se improvisan rutas a través de frentes, taludes o zonas de tráfico. Los simulacros permiten comprobar tiempos, cobertura de radio y acceso de los servicios de ayuda. Después de cualquier incidente se conserva la escena cuando sea seguro, se informa y se colabora en la investigación. El objetivo no es buscar culpables, sino identificar fallos técnicos u organizativos y evitar que la situación se repita.$n$ where id = 'ef16ec71-c956-4d5a-a57a-c0a4026e64ac';
update public.lesson_audio_segments set narration_text = $n$Esta formación se encuadra en la ITC 02.1.02 y en la Especificación Técnica 2001-1-08 para operadores de maquinaria de arranque, carga y viales. Se relaciona además con la Ley 31/1995, el Real Decreto 1215/1997 sobre equipos de trabajo, el Real Decreto 1389/1997 para actividades mineras y las normas de coordinación empresarial. La formación inicial tiene veinte horas y la frecuencia máxima obligatoria indicada por la especificación es de dos años. El empresario debe proporcionar equipos seguros, información, formación y organización preventiva. El trabajador debe utilizar correctamente la máquina, los dispositivos y los EPI, respetar las DIS y comunicar de inmediato cualquier situación que pueda suponer un riesgo grave.$n$ where id = '66fd077b-add7-468d-ac7a-4e4a0789c37c';

do $val$
declare
  version_id constant uuid := 'ce4a139a-877f-4da4-a77a-41a9c2309fd2';
  total integer;
  fallos integer;
begin
  select count(*)
    into total
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5;
  if total <> 50 then
    raise exception 'El reciclaje de arranque debe tener 50 diapositivas en los bloques 1 a 5 y tiene %', total;
  end if;

  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5
     and (
       s.body not like '%Idea clave%'
       or s.body not like '%Errores críticos que deben evitarse%'
       or s.body not like '%Comprobación antes de continuar%'
       or length(s.body) < 1200
     );
  if fallos > 0 then
    raise exception '% diapositivas de arranque 5 h conservan el cuerpo antiguo o no tienen las seis secciones', fallos;
  end if;

  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5
     and seg.title is distinct from s.title;
  if fallos > 0 then
    raise exception '% diapositivas no comparten el título de su locución', fallos;
  end if;

  select count(*)
    into fallos
    from public.lesson_audio_segments seg
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5
     and (
       seg.narration_text is null
       or length(seg.narration_text) < 600
       or seg.audio_storage_path is null
       or seg.audio_storage_path not like '%.mp3'
     );
  if fallos > 0 then
    raise exception '% locuciones de arranque 5 h no tienen el guion registrado o el audio definitivo', fallos;
  end if;

  -- El bloque 1 arrastraba el temario de transporte: ninguna unidad debe
  -- volver a titularse por fases de transporte, costes o descarga en tolva.
  select count(*)
    into fallos
    from public.lesson_audio_segments seg
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position = 1
     and (seg.title ilike '%transporte%' or seg.title ilike '%tolva%');
  if fallos > 0 then
    raise exception '% unidades del bloque 1 conservan títulos del temario anterior', fallos;
  end if;
end;
$val$;

commit;
