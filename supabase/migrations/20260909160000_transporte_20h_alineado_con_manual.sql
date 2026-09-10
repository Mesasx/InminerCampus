-- Alinea la modalidad de 20 h de «Operador de maquinaria de transporte: camión y
-- volquete» con su propio material. Hasta ahora la versión mezclaba tres fuentes
-- distintas y el alumno veía tres cosas que no hablaban de lo mismo:
--
--   1. Las cincuenta transcripciones procedían de un guion anterior con otro
--      temario. La unidad 4.1 se titula «Motor, lubricación y refrigeración» y su
--      transcripción hablaba de la aproximación al punto de descarga; la 5.1,
--      «Panel de alarmas», hablaba de equipos de protección individual. Los
--      nombres de los ficheros de audio (parte-4.1-motor-lubricacion-y-
--      refrigeracion.mp3 y equivalentes) coinciden con los títulos, así que lo
--      desalineado era el texto, no la locución.
--   2. Las imágenes de diapositiva y el número de página eran los del deck de
--      reciclaje de 5 h, porque `scripts/upload-course-unit-decks.mjs` aplicaba
--      esa presentación de 55 páginas a las dos modalidades. La de 20 h tiene su
--      propia presentación de 100 páginas, dos por unidad.
--   3. Los cuerpos de diapositiva usaban encabezados en mayúsculas
--      («EXPLICACIÓN DETALLADA»), que `AudioLessonPlayer` no reconoce, de modo
--      que las seis secciones se renderizaban como un único párrafo corrido.
--      Además, «aplicación», «errores críticos» y «comprobación» repetían el
--      mismo texto en las diez unidades de cada bloque.
--
-- Fuente de las tres correcciones: «Manual maestro · Operador de maquinaria de
-- transporte, camión y volquete» (edición técnica 1.0, 3 de septiembre de 2026),
-- publicado como libro de texto de la propia versión. Su campo «síntesis de la
-- locución» reproduce el guion registrado en la hoja de producción de cada uno
-- de los cincuenta audios; el manual advierte de que la comprobación acústica
-- palabra por palabra exigiría los MP3 originales.
--
-- Los encabezados se escriben en el formato que reconoce el reproductor:
-- Objetivo, Explicación detallada, Aplicación práctica, Errores críticos que
-- deben evitarse, Comprobación antes de continuar e Idea clave.
--
-- No se tocan matrículas, audios, progreso ni la modalidad de 5 h. Las imágenes
-- de diapositiva las sube `scripts/sync-transport-20h-unit-slides.mjs`, que
-- renderiza las páginas impares de la presentación de 20 h.

begin;

-- Bloque 1 · Definición de los trabajos y organización del transporte

update public.lesson_segment_slides set body = $b$Objetivo

Situar la formación inicial de veinte horas dentro del sistema preventivo de la explotación y no como un permiso genérico de conducción.

Explicación detallada

La ITC 02.1.02 regula la formación preventiva mínima de quienes trabajan en centros mineros y señala expresamente al operador de maquinaria de transporte, camión y volquete. La ET 2000-1-08 desarrolla ese itinerario y alcanza también al personal de contratas y subcontratas, porque la obligación depende de la tarea y de la exposición al riesgo, no de la empresa que figure en la nómina. La finalidad no es enseñar a conducir: es reconocer los riesgos del ciclo completo, utilizar los sistemas de seguridad y aplicar las instrucciones del centro. La acreditación del curso no se confunde con la autorización minera para manejar el tipo de máquina ni, si se accede a vía pública, con el permiso de conducción.

Aplicación práctica

Antes del primer ciclo el operador contrasta la orden de trabajo con la unidad asignada y con la ruta real: dónde espera, quién autoriza la entrada, dónde carga y descarga y qué condiciones obligarían a parar.

Errores críticos que deben evitarse

• Tratar la acreditación del curso como autorización para manejar cualquier equipo, cuando la familiarización con el modelo concreto es obligatoria.
• Improvisar cuando dos instrucciones parecen incompatibles, en vez de dejar el equipo en condición segura y pedir aclaración.

Comprobación antes de continuar

• Manual del equipo, evaluación de riesgos y DIS conocidos
• Autorización vigente para el tipo de máquina asignado
• Criterio de parada segura identificado

Idea clave

La formación habilitante se refiere al puesto y debe adaptarse siempre a la máquina, al centro y a la tarea real; no es un permiso genérico para operar cualquier equipo.$b$ where id = '8c050689-0cce-4dc5-976b-1e6d6488e8e0';

update public.lesson_segment_slides set body = $b$Objetivo

Distinguir volquete y camión según la especificación técnica y entender qué cambia esa distinción en la operación diaria.

Explicación detallada

La ET 2000-1-08 define el volquete como máquina autopropulsada, sobre ruedas o cadenas, con caja abierta, destinada a transportar y volcar o extender materiales cargados por medios externos. El camión es un vehículo autopropulsado sobre ruedas que transporta material en las zonas previstas de la explotación y, cuando procede, por carretera. La diferencia afecta al diseño, la capacidad, la velocidad, el ámbito de circulación, las autorizaciones y el mantenimiento. La definición legal orienta el itinerario formativo pero no describe todas las configuraciones comerciales: existen rígidos, articulados, camiones convencionales, cabezas tractoras con semirremolque basculante y equipos especiales. Reconocer el nombre no basta.

Aplicación práctica

Antes de trabajar se verifican categoría, masa, dimensiones, capacidad, tipo de caja, neumáticos, dirección, frenado, sistema de descarga, protecciones y uso previsto del modelo concreto. Si la tarea exige circular por carretera se añaden los requisitos de tráfico aplicables.

Errores críticos que deben evitarse

• Tratar un volquete como un camión grande convencional o usar un camión de carretera fuera de sus condiciones de diseño.
• Extrapolar velocidades, pendientes o maniobras de un equipo a otro sin familiarización específica.

Comprobación antes de continuar

• Tipo de equipo y uso previsto identificados
• Documentación, placas y manual disponibles
• Ruta y autorización acreditadas, no supuestas

Idea clave

La denominación comercial nunca sustituye la comprobación del uso previsto, las capacidades, la ruta autorizada y los requisitos de circulación del equipo concreto.$b$ where id = 'cb92caa9-c371-48a1-8438-21e2cd502eef';

update public.lesson_segment_slides set body = $b$Objetivo

Leer el transporte como el eslabón que conecta las demás fases del movimiento de tierras y no como una tarea aislada.

Explicación detallada

El movimiento de tierras encadena arranque, carga, transporte y descarga, y en determinados trabajos añade extendido, nivelación, compactación y refino. El transporte enlaza el frente con la tolva, la escombrera, el acopio o el destino exterior. La calidad de cada operación condiciona la siguiente: un bloque de tamaño excesivo provoca carga irregular e impacto sobre la caja, una carga descentrada altera el comportamiento del vehículo y una pista con derrames o drenaje deficiente reduce la adherencia y obliga a maniobras imprevistas. En descarga, un borde debilitado puede culminar un riesgo originado mucho antes. El ciclo se evalúa como un sistema, no como una suma de puestos independientes.

Aplicación práctica

El operador observa cómo cambia la zona durante el turno: crecimiento del acopio, roderas, derrames, agua, tránsito de terceros o variaciones del frente. Esos cambios se comunican aunque la máquina propia todavía pueda continuar, porque afectan a quien interviene después.

Errores críticos que deben evitarse

• Medir la productividad solo por velocidad, cuando acortar ciclos elevando la velocidad aumenta daños, fatiga y probabilidad de parada.
• Abandonar la zona dejando bloques derramados en la pista o el punto de descarga sin preparar para la siguiente unidad.

Comprobación antes de continuar

• Origen y destino del material conocidos
• Estado de pista y punto de descarga valorados en este ciclo
• Anomalías del entorno comunicadas al relevo

Idea clave

La seguridad del movimiento de tierras depende de la continuidad entre fases: cada operador entrega a la siguiente máquina un material, una ruta y un entorno previsibles.$b$ where id = '6b5dc7fb-b535-4928-9101-ad3f9dee54ba';

update public.lesson_segment_slides set body = $b$Objetivo

Reconocer que cada fase del ciclo cambia el comportamiento de la unidad y exige un margen de control propio.

Explicación detallada

El ciclo habitual comprende posicionamiento, carga, transporte cargado, maniobra y descarga, retorno en vacío y nueva colocación. Con carga aumentan la masa, la distancia de frenado y la exigencia sobre dirección y suspensión. Con la caja elevada cambia la altura del centro de gravedad. En vacío puede aumentar la tendencia a perder adherencia o a circular demasiado rápido. Las maniobras marcha atrás concentran riesgos por zonas ciegas. Durante la maniobra se conservan velocidad, carga, alcance y trayectoria dentro de márgenes que permitan corregir sin brusquedad, y la atención alterna entre ruta, personas, otros equipos, carga, caja y panel.

Aplicación práctica

Antes del primer ciclo deben estar definidos ruta, prioridades, punto de espera, procedimiento de carga, lugar de descarga y comunicaciones. Al terminar, la unidad completa la descarga, baja la caja, se retira de zonas inestables y estaciona según el procedimiento.

Errores críticos que deben evitarse

• Trabajar al límite geométrico o de capacidad, porque una maniobra que solo es segura con precisión absoluta no está suficientemente controlada.
• Dejar de observar terreno y tráfico porque el ciclo se repite igual desde hace horas.

Comprobación antes de continuar

• Fase del ciclo identificada y sus márgenes definidos
• Trayectoria completa de cabina, ruedas, bastidor y caja anticipada
• Vía de escape disponible

Idea clave

Cada ciclo debe comenzar con un escenario conocido, mantenerse dentro de márgenes y terminar dejando condiciones seguras para la siguiente operación.$b$ where id = '66e32b20-0e10-474e-9532-1f1145052ba0';

update public.lesson_segment_slides set body = $b$Objetivo

Diferenciar la arquitectura del volquete rígido y la del articulado, y actuar según los riesgos propios de cada una.

Explicación detallada

El rígido tiene un bastidor principal continuo y gira mediante las ruedas directrices; su elevada masa exige radios amplios, distancia de detención suficiente y control estricto del firme. El articulado une dos bastidores mediante una articulación gobernada hidráulicamente que mejora la adaptación a terrenos irregulares, pero crea una zona crítica de atrapamiento y permite que las dos partes adopten inclinaciones distintas. Antes de acceder a la articulación se instala el bloqueo mecánico previsto en el manual. En curva, ladera o descarga la posición relativa de los bastidores influye directamente en la estabilidad, y la tracción en varios ejes no convierte un borde inestable en seguro.

Aplicación práctica

Cada cambio de unidad obliga a conocer dimensiones, panel, frenos, retarder, dirección de emergencia, caja y secuencias de parada. Una maniobra aceptable en un rígido puede ser inadecuada en un articulado.

Errores críticos que deben evitarse

• Acceder a la zona de articulación sin instalar el bloqueo mecánico previsto.
• Bascular con la unidad torcida, cruzada sobre roderas o apoyada en firme desigual.

Comprobación antes de continuar

• Tipo de bastidor y sus límites de pendiente conocidos
• Bloqueo de articulación disponible cuando proceda intervenir
• Ruta de salida conservada durante toda la maniobra

Idea clave

Rígido y articulado resuelven ciclos diferentes; sus ventajas solo son seguras dentro de la configuración, el terreno y los límites definidos para cada modelo.$b$ where id = '13a99a3e-3dad-4241-ab9e-65d3c3223f91';

update public.lesson_segment_slides set body = $b$Objetivo

Separar las condiciones del trabajo dentro de la explotación de las que exige el transporte exterior por carretera.

Explicación detallada

El camión que trabaja en pistas y frentes y el que sale por carretera pueden ser el mismo vehículo, pero el marco de circulación cambia y la transición exige una comprobación expresa. Dentro rigen las rutas, prioridades, velocidades, apartaderos, gálibos y comunicaciones del centro; la matrícula y el permiso de conducción no sustituyen la formación específica del puesto ni la autorización interna. El firme puede ser más agresivo que una carretera y la carga se recibe con impactos, así que caja, chasis, suspensión, neumáticos y estabilidad deben ser compatibles con el material y con la instalación de carga. Reducir el ritmo no corrige una incompatibilidad técnica.

Aplicación práctica

Antes de acceder a vía pública se verifican clasificación, documentación, inspecciones, masas y dimensiones, señalización, limpieza, neumáticos, frenos, acondicionamiento de la caja y requisitos del conductor. El barro y las piedras adheridos a ruedas, bajos o caja se retiran en el punto previsto.

Errores críticos que deben evitarse

• Salir con la caja sin bajar y cerrar por completo o con partes que excedan el gálibo autorizado.
• Aceptar bloques o impactos que superen la resistencia de caja, neumáticos o chasis.

Comprobación antes de continuar

• Carga distribuida, sujeta y cubierta cuando proceda
• Ruedas, bajos y caja limpios de barro y piedras
• Documentación y requisitos del trayecto acreditados

Idea clave

Salir de la explotación no es una continuación automática del ciclo minero: requiere verificar vehículo, carga, conductor y trayecto conforme al marco aplicable.$b$ where id = 'ece7e7fa-0cc6-4d17-9075-fecedc46960e';

update public.lesson_segment_slides set body = $b$Objetivo

Operar con el equipo de carga como un único sistema, con posiciones y señales fijadas de antemano.

Explicación detallada

La unidad de transporte depende de una pala, excavadora u otro equipo que deposita el material en la caja. Ambos operadores necesitan un método común: punto de espera, señal de entrada, posición de carga, número o criterio de pases y señal de salida. El camión espera fuera de la envolvente hasta recibir señal, entra por la ruta definida, se coloca en posición visible y confirma su inmovilización mientras el equipo de carga mantiene el implemento controlado. La carga se deposita de forma progresiva y distribuida, minimizando el giro sobre la cabina. Una sola persona dirige la maniobra; cámaras y alarmas complementan, no sustituyen.

Aplicación práctica

Si se pierde la comunicación, cambia la posición o aparece una persona dentro del área, el ciclo se detiene. Cuando el camión queda mal posicionado se le ordena salir y repetir, en vez de corregir con la cuchara elevada alrededor de la cabina.

Errores críticos que deben evitarse

• Iniciar un movimiento o abandonar la cabina sin acuerdo previo y sin condiciones seguras.
• Pasar el implemento sobre la cabina cuando la maniobra permite evitarlo.

Comprobación antes de continuar

• Señal de entrada recibida y confirmada
• Unidad inmovilizada en la posición acordada
• Área libre de personas y contacto establecido

Idea clave

Camión inmovilizado, posición fija y comunicación confirmada: si uno pierde contacto o cambia de lugar, ambos equipos se detienen.$b$ where id = 'eee84292-dcac-4a07-b44b-7049a938acd2';

update public.lesson_segment_slides set body = $b$Objetivo

Delimitar qué corresponde al operador durante el turno y dónde empieza la intervención de personal competente.

Explicación detallada

El operador inspecciona, realiza las comprobaciones funcionales, conduce, recibe la carga, transporta, descarga, estaciona y ejecuta el mantenimiento básico que tenga asignado: limpieza, engrase o comprobaciones definidas por el fabricante y la empresa. También registra defectos, interpreta alarmas y comunica cambios del entorno. No está autorizado a desmontar componentes presurizados, puentear sensores, ajustar sistemas de seguridad ni trabajar bajo un equipo elevado sin soporte mecánico. La observación debe ser activa: cambios de ruido, vibración, temperatura, deriva, recorrido de frenado o esfuerzo de dirección pueden preceder a un fallo, y describir cuándo aparece el síntoma y con qué carga facilita el diagnóstico.

Aplicación práctica

Ante una anomalía que pueda afectar a frenos, dirección, neumáticos, estructura, caja o visibilidad, la obligación es inmovilizar de forma segura e informar. La decisión de reparar o autorizar un uso limitado corresponde a personal competente y queda documentada.

Errores críticos que deben evitarse

• Continuar para terminar un viaje con un defecto conocido, convirtiendo una anomalía controlable en una pérdida de control.
• Normalizar una fuga pequeña, una alarma intermitente o un freno con más recorrido porque la máquina sigue funcionando.

Comprobación antes de continuar

• Incidencias del turno anterior revisadas
• Defectos detectados registrados y comunicados
• Tarea dentro del alcance autorizado al operador

Idea clave

Operar es observar, decidir y comunicar durante todo el turno; el manejo de mandos es solo una parte de la función preventiva.$b$ where id = '13c94c48-f10e-4275-a572-4103da1e6fd6';

update public.lesson_segment_slides set body = $b$Objetivo

Integrar orden de trabajo, DIS, evaluación de riesgos y manual antes de poner la máquina en movimiento.

Explicación detallada

Una orden eficaz identifica tarea, ubicación, material, máquina y accesorio, resultado esperado, secuencia, rutas, punto de carga o descarga, interferencias, comunicaciones y responsables, e incluye las condiciones que obligan a detener o a pedir nueva autorización. Instrucciones genéricas del tipo «limpiar el frente» son insuficientes cuando hay bordes, líneas eléctricas, tráfico o terreno alterado. Las Disposiciones Internas de Seguridad, aprobadas por la dirección facultativa, son de obligado cumplimiento y regulan circulación, velocidades, prioridades, señalización, comunicaciones, vertido, mantenimiento y respuesta ante emergencias. No sustituyen al manual ni amplían las capacidades técnicas del equipo.

Aplicación práctica

El operador contrasta la orden con el escenario visible: accesos, señalización, pendientes, estado del terreno, iluminación, meteorología, personas y equipos. Si el vehículo, el accesorio o las condiciones no coinciden, lo comunica antes de comenzar.

Errores críticos que deben evitarse

• Entrar en una pista cerrada o descargar en una zona no acondicionada por presión de producción.
• Apoyarse en una costumbre informal cuando contradice una instrucción escrita vigente.

Comprobación antes de continuar

• Ruta autorizada, sentidos, pendientes, cruces y gálibos conocidos
• Cambios del turno revisados: obras, voladuras, meteorología, mantenimiento
• Orden de trabajo compatible con la capacidad de la máquina

Idea clave

La orden de trabajo y las DIS convierten la prevención general en reglas concretas; si la realidad se aparta de ellas, se detiene y se replantea.$b$ where id = '038817a9-c889-4ab6-a6e2-7ca48a6b4456';

update public.lesson_segment_slides set body = $b$Objetivo

Decidir con margen de reacción y entender que la regularidad del ciclo, no la velocidad, es lo que sostiene la producción.

Explicación detallada

Un transporte eficaz mantiene un ritmo uniforme, reduce esperas y evita aceleraciones, frenadas o maniobras innecesarias. La velocidad excesiva rara vez mejora el resultado global: aumenta el desgaste, el consumo, los derrames y la probabilidad de accidente. Conducir con margen significa poder reaccionar ante un obstáculo, un cambio de adherencia o un vehículo detenido. La decisión segura se apoya en tres preguntas: qué puede cambiar, qué consecuencias tendría y qué medida permite conservar el control. Cuando la respuesta no está clara, se reduce la exposición o se detiene la operación.

Aplicación práctica

Tiempos de espera, maniobras cruzadas, frenadas frecuentes o avisos constantes señalan una organización deficiente. Registrar cuasi accidentes y dificultades permite ajustar rutas, posiciones y comunicaciones antes de que aparezca un daño.

Errores críticos que deben evitarse

• Recuperar tiempo perdido aumentando la velocidad en lugar de replantear la organización del ciclo.
• Reducir la distancia de separación entre equipos para acortar la espera.

Comprobación antes de continuar

• Velocidad compatible con la distancia de reacción disponible
• Ritmo del ciclo sostenible sin maniobras improvisadas
• Condiciones dudosas resueltas antes de continuar

Idea clave

Trabajar de forma previsible protege a las personas y, al mismo tiempo, mejora la continuidad del proceso: la seguridad no compite con la producción, la hace sostenible.$b$ where id = '4c93d629-32e7-4d06-9e73-4e6283db31d4';

-- Bloque 2 · Técnicas preventivas antes de comenzar el trabajo

update public.lesson_segment_slides set body = $b$Objetivo

Confirmar que la persona está apta, informada y equipada antes de acercarse a la máquina.

Explicación detallada

La fatiga, el alcohol, las drogas y determinados medicamentos reducen la percepción y el tiempo de reacción en un trabajo que exige atención sostenida y decisiones rápidas. La fatiga también aparece durante el turno por calor, vibración, monotonía o jornada prolongada, y se manifiesta en correcciones tardías, olvidos e irritabilidad. El Real Decreto 773/1997 establece que el equipo de protección individual se emplea frente a los riesgos que no han podido evitarse o limitarse por protección colectiva u organización: una mascarilla no reemplaza el control del polvo ni un chaleco permite mezclar peatones y maquinaria sin segregación. Los EPI deben ser adecuados al riesgo, compatibles entre sí y ajustados al usuario.

Aplicación práctica

La ropa queda ajustada, sin cordones, joyas ni objetos que puedan engancharse, y el calzado se mantiene limpio de barro o grasa para no resbalar en peldaños y pedales. Antes de subir se guardan herramientas y objetos que puedan caer o bloquear un pedal.

Errores críticos que deben evitarse

• Sustituir el descanso por ventilación o música cuando la atención ya no puede mantenerse.
• Usar un protector auditivo que impide oír señales críticas sin revisar antes el sistema de comunicación.

Comprobación antes de continuar

• Aptitud física y mental compatible con el turno
• EPI seleccionados según evaluación y en buen estado
• Medios de comunicación y emergencia conocidos

Idea clave

El EPI es la última barrera; la primera condición de seguridad es que la persona esté apta, informada y equipada para el riesgo real.$b$ where id = 'e66709c7-25a1-4c54-850f-e61041d9151f';

update public.lesson_segment_slides set body = $b$Objetivo

Recorrer el perímetro con un método estable que descubra los defectos invisibles desde la cabina.

Explicación detallada

La revisión previa se realiza siempre antes de poner en marcha la unidad, incluso si la ha utilizado otra persona durante el mismo turno. Se empieza a distancia, observando inclinación anormal, manchas en el suelo, piezas caídas, daños recientes y presencia de personas, y después se recorre la máquina en el mismo sentido cada día para reducir olvidos. Se comprueban accesos, pasamanos, cristales, espejos, luces, cámaras, extintor, señalización, resguardos, pasadores, mangueras, cilindros y neumáticos. La caja debe estar completamente bajada y la unidad inmovilizada. Mirar debajo permite detectar pérdidas recientes o elementos desplazados, y la vuelta confirma además que nadie permanece en un punto ciego.

Aplicación práctica

La lista de comprobación relaciona cada punto con una decisión: apto, defecto a vigilar dentro de un criterio autorizado o fuera de servicio. El parte registra fecha, máquina, horas, defecto, localización, condición en que aparece y acción adoptada.

Errores críticos que deben evitarse

• Pasar bajo una caja elevada o entrar en la articulación sin bloqueo durante la vuelta de inspección.
• Tratar la lista como un trámite de casillas en lugar de una decisión de puesta en servicio.

Comprobación antes de continuar

• Perímetro recorrido completo desde un punto fijo
• Caja bajada y unidad inmovilizada
• Defectos anotados y valorados antes del arranque

Idea clave

La inspección perimetral es una decisión de puesta en servicio: cualquier defecto de seguridad debe quedar comunicado y resuelto antes de operar.$b$ where id = '30fd2df2-0a4c-4059-b567-095af942ac32';

update public.lesson_segment_slides set body = $b$Objetivo

Inspeccionar la rodadura sin invadir el terreno que corresponde al especialista.

Explicación detallada

Los neumáticos soportan la carga y transmiten frenado y dirección, y en equipos pesados almacenan una energía considerable. La inspección se efectúa con la unidad inmovilizada, desde posiciones que no expongan a atropello ni a proyección, observando cortes, grietas, abultamientos, separación de capas, objetos incrustados, desgaste irregular, válvulas, llantas y tuercas. En ruedas gemelas se revisa el espacio intermedio y la presencia de piedras atrapadas. Restos brillantes, óxido desplazado o marcas en las fijaciones indican movimiento. El inflado, desinflado, desmontaje y reparación corresponden a personal competente con dispositivos de retención: nadie golpea, calienta, suelda ni ajusta una llanta presurizada.

Aplicación práctica

Vibración, deriva, olor, humo o aumento de temperatura durante la marcha obligan a detener en un lugar seguro. Tras sobrecalentamiento, incendio, impacto severo o circulación sin presión se aísla el área y se sigue el procedimiento del centro y del fabricante.

Errores críticos que deben evitarse

• Situarse frente a la trayectoria probable de proyección de piezas y aire.
• Compensar un daño conduciendo despacio hasta terminar el turno.

Comprobación antes de continuar

• Banda, flancos, llantas y fijaciones revisados desde posición protegida
• Presión comprobada con el método y el equipo previstos
• Anomalías derivadas a personal competente

Idea clave

La inspección del operador detecta y comunica; el inflado y la reparación de neumáticos pesados exigen personal competente, medios de retención y exclusión de la trayectoria de proyección.$b$ where id = '4e5beb91-ee7f-4b6e-b7bb-78790b71b8da';

update public.lesson_segment_slides set body = $b$Objetivo

Comprobar niveles y circuitos sabiendo que el motor parado no significa energía eliminada.

Explicación detallada

Cada nivel se verifica en la condición que indica el fabricante: terreno nivelado, motor frío o a determinada temperatura, equipo móvil apoyado y tiempo de espera tras la parada. Medir en otra condición produce lecturas falsas y llenados excesivos. El sistema hidráulico puede conservar presión en acumuladores, cilindros y tramos bloqueados aun con el motor detenido, y el equipo móvil puede descender por gravedad o por pérdida interna. Aflojar un racor para comprobar si queda presión es una práctica peligrosa: la fuga fina puede ser casi invisible y causar una lesión grave por inyección. Abrir un tapón presurizado en caliente puede producir ebullición súbita y proyección.

Aplicación práctica

Una bajada repetida de nivel no se resuelve añadiendo fluido: puede indicar fuga externa, consumo interno o comunicación entre circuitos, y debe registrarse la tendencia y solicitar diagnóstico. Para repostar se apaga el motor, se evita toda fuente de ignición, se controla el derrame y el equipo contra incendios permanece accesible.

Errores críticos que deben evitarse

• Buscar una fuga hidráulica con la mano o abrir un circuito caliente o presurizado.
• Limpiar la mancha sin eliminar la causa y dar la máquina por segura.

Comprobación antes de continuar

• Máquina situada como indica el fabricante para medir
• Mangueras y racores sin rozaduras, abultamientos ni holguras
• Origen de cualquier mancha bajo el vehículo localizado

Idea clave

Motor parado no significa energía eliminada: presión, temperatura y gravedad deben controlarse antes de abrir, limpiar o intervenir.$b$ where id = '13fd6d0c-86b5-47e5-b9c3-18f34eda2311';

update public.lesson_segment_slides set body = $b$Objetivo

Acceder sin caídas y dejar el puesto ajustado para controlar la máquina durante todo el turno.

Explicación detallada

Muchas lesiones ocurren al subir o bajar, no durante la operación principal. Se asciende de frente a la máquina manteniendo tres puntos de apoyo, usando solo peldaños, plataformas y pasamanos diseñados, nunca el volante, una palanca, un neumático o una manguera. El descenso se hace del mismo modo y no se salta aunque la altura parezca pequeña. La estructura ROPS protege frente al vuelco y la FOPS frente a la caída de objetos cuando el equipo las incorpora; no se taladran, sueldan ni modifican sin autorización técnica del fabricante. El cinturón se relaciona directamente con la ROPS: mantiene al operador dentro del volumen protegido durante una sacudida o un vuelco.

Aplicación práctica

Los espejos se ajustan desde la posición real de conducción, porque hacerlo desde otra postura deja zonas sin cubrir. La preparación de cabina termina con una prueba de claxon y avisos, ya que una señal descubierta como inoperativa al iniciar la maniobra ya ha reducido el margen preventivo.

Errores críticos que deben evitarse

• Subir o bajar con objetos en las manos, perdiendo los tres puntos de apoyo.
• Improvisar con cajones o escalas sueltas cuando el acceso de la máquina está dañado.

Comprobación antes de continuar

• Peldaños y asideros íntegros y limpios de barro, aceite o hielo
• Asiento, volante, espejos y mandos ajustados y objetos sueltos retirados
• Cinturón abrochado y salida de emergencia libre

Idea clave

El acceso seguro evita caídas y el ajuste de cabina permite usar cinturón, mandos y visión sin fatiga ni posturas que retrasen la respuesta.$b$ where id = '5c8e3d6c-8780-4a72-9c19-0e8fa4030083';

update public.lesson_segment_slides set body = $b$Objetivo

Probar las funciones críticas en zona despejada antes de incorporarse a producción.

Explicación detallada

El motor se arranca únicamente desde el puesto del operador, con cinturón colocado, mandos neutralizados y freno aplicado, observando el autodiagnóstico y comprobando que los testigos se encienden y apagan según el manual. El puenteo desde el exterior y la anulación de interbloqueos son prácticas prohibidas. La prueba de freno de servicio, de estacionamiento y, cuando proceda, de emergencia se realiza en una zona con superficie y espacio suficientes, a velocidad reducida y sin personas, verificando capacidad de detener y mantener la máquina, recorrido del mando y ausencia de desviaciones. La dirección se prueba en ambos sentidos observando holgura, esfuerzo y respuesta, y en articulados sin que nadie esté en la articulación.

Aplicación práctica

Se comprueban claxon, avisador de marcha atrás, luces de trabajo, rotativo, limpiaparabrisas y cámaras. La ausencia de un aviso no se compensa automáticamente con que el operador mire más: la medida alternativa debe estar evaluada y autorizada.

Errores críticos que deben evitarse

• Silenciar o puentear una alarma para seguir trabajando.
• Probar los frenos por primera vez al aproximarse a una pendiente, una tolva o un vehículo.

Comprobación antes de continuar

• Autochequeo del panel observado y testigos correctos
• Frenos y dirección probados en zona habilitada
• Avisos, luces y cámaras operativos y registrados en la lista diaria

Idea clave

Frenos y dirección se comprueban antes de necesitarlos: la primera prueba nunca debe producirse frente a una pendiente, un borde o un obstáculo.$b$ where id = '7b17e312-1e48-4fe9-a7a3-1da2c5bd9d2a';

update public.lesson_segment_slides set body = $b$Objetivo

Aplicar bloqueo y consignación antes de acceder a cualquier zona peligrosa de la máquina.

Explicación detallada

El operador realiza solo el mantenimiento asignado: limpieza, engrase o comprobaciones definidas por el manual y la empresa. Antes de intervenir se estaciona en terreno firme, se baja la caja, se coloca la transmisión en neutro, se aplica el freno y se detiene el motor. La consignación comprende separar la máquina de las fuentes, bloquear los dispositivos de separación, disipar o contener la energía acumulada y verificar que no queda energía peligrosa. Las fuentes pueden ser eléctrica, hidráulica, neumática, mecánica, gravitatoria y térmica. La verificación es indispensable: se comprueba la presión y se confirma que el equipo no puede moverse. Las piezas sostenidas solo por presión hidráulica no se consideran aseguradas.

Aplicación práctica

Trabajar bajo una caja elevada exige el bloqueo mecánico diseñado para ese fin. Al terminar se retiran herramientas, se montan los resguardos, se comprueba que todas las personas están fuera y cada responsable retira su bloqueo conforme a la secuencia.

Errores críticos que deben evitarse

• Confiar únicamente en los cilindros hidráulicos para impedir el descenso de la caja.
• Retirar el medio de bloqueo de otra persona sin seguir el procedimiento.

Comprobación antes de continuar

• Tarea dentro del alcance asignado al operador
• Energías separadas, bloqueadas, disipadas y verificadas
• Protecciones reinstaladas antes del arranque

Idea clave

La consignación no termina al apagar: hay que separar, bloquear, disipar y verificar todas las energías antes de acceder a una zona peligrosa.$b$ where id = '6fe0040d-ccb0-4c56-a969-2da08e8151ef';

update public.lesson_segment_slides set body = $b$Objetivo

Eliminar la combinación de combustible acumulado y superficie caliente que origina los incendios de máquina.

Explicación detallada

Se revisan compartimento motor, escape, frenos, baterías, cableado, conducciones de combustible e hidráulico y los huecos donde se depositan polvo, aceite o material vegetal. Una fuga pulverizada puede alcanzar el escape, un cable rozado puede crear un arco y un freno arrastrado genera calor. Las protecciones térmicas y los resguardos se conservan, y no se almacenan trapos, aerosoles ni recipientes en la cabina o el motor. La limpieza no es estética: mantiene la refrigeración, la visibilidad, el acceso a las salidas y la capacidad de descubrir una fuga antes de que alcance una superficie caliente. Aire, agua o productos se aplican sin proyectar partículas hacia el trabajador ni dañar radiadores, sensores o conexiones.

Aplicación práctica

Ante olor a quemado, humo o temperatura anormal se detiene la unidad en un lugar seguro, se para el motor, se avisa y se sigue el plan de emergencia. Tras un incendio no se vuelve al equipo hasta recibir autorización, porque un fuego aparentemente extinguido puede reactivarse.

Errores críticos que deben evitarse

• Abrir bruscamente un compartimento caliente, aportando oxígeno o exponiéndose a una llamarada.
• Dejar trapos, útiles o recipientes en el compartimento del motor después de una intervención.

Comprobación antes de continuar

• Puntos de acumulación limpios y resguardos térmicos colocados
• Extintor accesible, señalizado y dentro de revisión
• Cabina, accesos y elementos de visibilidad limpios

Idea clave

Una máquina limpia permite refrigerar, inspeccionar y evacuar; olor, humo o temperatura anormal justifican detener y activar el procedimiento antes de que el fuego se desarrolle.$b$ where id = 'bb24e604-6c62-499d-bdfc-c156f181231c';

update public.lesson_segment_slides set body = $b$Objetivo

Tratar la recuperación de una unidad averiada como una maniobra planificada y autorizada.

Explicación detallada

El remolcado cambia radicalmente según funcionen o no el motor, la dirección y los frenos, porque la pérdida de motor puede afectar a la vez a dirección, frenado, lubricación y liberación de frenos. Se identifican masa, posición, pendiente, estado de carga, daños, disponibilidad de frenos y dirección y puntos de conexión autorizados; el manual determina si puede remolcarse y en qué condiciones. No se usan ganchos, ejes, barandillas ni componentes que no sean puntos de tiro, y cables, eslingas, grilletes y barras deben ser compatibles y estar inspeccionados. Liberar un freno puede iniciar el movimiento, así que antes se instala un medio capaz de retener la unidad. La ITC 07.1.03 limita el remolque a 7 km/h como referencia general, sin sustituir límites inferiores del fabricante o de la DIS.

Aplicación práctica

Una sola persona dirige la maniobra y puede ordenar la parada. La tensión se aplica de forma progresiva, evitando tirones que multiplican los esfuerzos, y al alcanzar zona segura se inmoviliza antes de desconectar.

Errores críticos que deben evitarse

• Improvisar puntos de amarre con cables o cadenas no diseñados para el tiro.
• Situarse entre las unidades o dentro de la trayectoria de latigazo del elemento tensionado.

Comprobación antes de continuar

• Método de remolcado consultado en el manual y autorizado
• Unidad calzada y estabilizada antes de conectar
• Zona de exclusión cubriendo todas las trayectorias previsibles

Idea clave

Antes de liberar frenos o tensar un elemento de tiro debe existir un sistema capaz de controlar la unidad y una zona de exclusión que cubra todas las trayectorias previsibles.$b$ where id = '2c608d4d-a19b-42a9-af53-56544e4f39e4';

update public.lesson_segment_slides set body = $b$Objetivo

Cerrar el turno dejando la máquina estable y la información en manos del relevo.

Explicación detallada

La parada segura deja el equipo estable, sin energía de movimiento accesible y con los defectos comunicados. Se estaciona en zona autorizada, nivelada, firme, fuera del tráfico, de bordes, frentes, drenajes y líneas, sin bloquear rutas de emergencia. Se reduce régimen, se permite estabilizar temperaturas según el fabricante, se neutralizan mandos, se aplica freno, se apoya el equipo, se detiene el motor y se retira o controla la llave. El parte debe describir síntoma, momento, carga, ubicación y acción: «hace ruido» aporta mucho menos que indicar que aparece al girar a la derecha con el hidráulico caliente. Una máquina fuera de servicio se identifica para impedir un arranque no autorizado y solo personal competente la libera.

Aplicación práctica

El operador entrante confirma por sí mismo los puntos críticos: la lista de comprobación registra la inspección pero no sustituye la observación real. Se informa también de terreno, señalización, comunicaciones y tráfico, no solo del estado de la máquina.

Errores críticos que deben evitarse

• Ocultar una anomalía por miedo a retrasar la producción, cuando comunicarla pronto permite repararla antes.
• Dejar la máquina con carga suspendida, motor en marcha sin vigilancia o llave accesible.

Comprobación antes de continuar

• Equipo apoyado, mandos neutros, freno aplicado y motor detenido
• Defectos descritos con sistema afectado y condición en que aparecen
• Información entregada directamente al relevo cuando es posible

Idea clave

El fin del ciclo deja equipo móvil apoyado, mandos neutros, freno aplicado, motor detenido y cualquier incidencia claramente registrada.$b$ where id = 'fc9faaad-916f-425b-806c-3e1cb52543b8';

-- Bloque 3 · Técnicas preventivas durante la carga, transporte y descarga

update public.lesson_segment_slides set body = $b$Objetivo

Poner la máquina en servicio de forma gradual y comprobar que responde antes de entrar en el ciclo.

Explicación detallada

El motor se arranca desde el puesto del operador, sentado, con cinturón colocado, freno aplicado y mandos en neutro, tras confirmar que no hay etiquetas de consignación ni personas trabajando en la máquina. Arrancar desde el suelo o puentear bornes elimina interbloqueos y expone a un movimiento inesperado. El autodiagnóstico debe completar su secuencia y los testigos que permanecen activos se interpretan con el manual, no por costumbre. El calentamiento no consiste en dejar el motor a ralentí sin vigilancia: es permitir que alcance condiciones mientras se mueven las funciones suavemente. En hidráulica fría la respuesta puede ser lenta y la presión elevada, así que se realizan ciclos moderados en zona despejada.

Aplicación práctica

El primer desplazamiento se hace suavemente y sirve para confirmar dirección y frenado. La primera pasada se realiza de forma conservadora para contrastar terreno y máquina; si la respuesta no coincide con lo esperado se corrige antes de aumentar el ritmo.

Errores críticos que deben evitarse

• Normalizar una alarma persistente diciendo que la máquina siempre lo hace, o taparla y desconectarla.
• Acelerar el motor en frío para acortar el tiempo de calentamiento.

Comprobación antes de continuar

• Entorno libre y advertencia emitida antes del arranque
• Presión, temperatura, carga eléctrica y mensajes del panel dentro de rango
• Ventilación suficiente frente a los gases de escape

Idea clave

La máquina se arranca desde el puesto y se lleva gradualmente a servicio; ninguna alarma persistente se normaliza ni se anula.$b$ where id = '0270b345-cfbb-4bbc-98f0-da57df1eeaf2';

update public.lesson_segment_slides set body = $b$Objetivo

Resolver trayectoria, orientación, terreno e inmovilización antes de que llegue el primer pase a la caja.

Explicación detallada

La entrada al frente se hace solo cuando el equipo de carga autoriza y por la trayectoria establecida. La unidad espera fuera del radio de giro, de la trayectoria de otras máquinas y de la caída de material. El terreno debe ser firme, lo más horizontal posible y libre de bloques que dañen neumáticos o desestabilicen la unidad: situarse bajo un frente inestable o con las ruedas a distinta cota convierte la carga en un riesgo de vuelco. Con pala cargadora el volquete puede colocarse sesgado respecto al frente según el método aprobado, manteniendo la cabina alejada de la zona de caída; con excavadora se evita quedar bajo un talud inestable o dentro de un radio de giro no controlado.

Aplicación práctica

Una vez colocado se aplica el freno y se permanece en la cabina salvo procedimiento contrario. Si la posición no es segura, se sale, se reposiciona y se vuelve a inmovilizar; nunca se corrige mientras la unidad recibe material.

Errores críticos que deben evitarse

• Corregir la posición mientras cae material, lo que elimina el control compartido de la maniobra.
• Bajar de la cabina para dar indicaciones junto a las ruedas o entre máquinas.

Comprobación antes de continuar

• Señal de entrada recibida y trayectoria establecida
• Plataforma capaz de resistir la masa cargada
• Freno aplicado y salida prevista antes del primer pase

Idea clave

Primero se posiciona, se inmoviliza y se confirma la comunicación; después se carga. Corregir la posición mientras cae material elimina el control compartido.$b$ where id = '23fae774-4927-4576-a47f-04a90a627862';

update public.lesson_segment_slides set body = $b$Objetivo

Recibir la carga sin exceder capacidad y con una distribución que no comprometa estabilidad ni frenado.

Explicación detallada

Recibir la carga modifica masa, reparto por ejes, centro de gravedad y capacidad de frenado. El número de pases es secundario frente a cuatro condiciones: no exceder la capacidad, distribuir de forma estable, limitar los impactos y evitar que caiga material fuera de la caja. La densidad determina que una caja llena por volumen pueda estar sobrecargada en masa, y la granulometría, humedad, adherencia y temperatura influyen en el impacto y en la descarga posterior. Los pases se reparten longitudinal y transversalmente: una montaña lateral o adelantada sobrecarga un eje y genera deriva en curvas o frenada. El indicador de carga, cuando existe, complementa la observación pero no detecta por sí solo todos los desequilibrios.

Aplicación práctica

La salida se autoriza cuando el equipo de carga se ha retirado, la caja no presenta elementos sobresalientes peligrosos y la ruta está libre. El conductor arranca suavemente para detectar desplazamientos del material.

Errores críticos que deben evitarse

• Normalizar una sobrecarga porque el recorrido es corto, cuando somete a neumáticos, suspensión, bastidor, dirección y frenos a esfuerzos no previstos.
• Entrar en la caja o trabajar bajo un implemento suspendido para corregir la distribución.

Comprobación antes de continuar

• Carga dentro de los límites de masa y volumen del equipo
• Reparto longitudinal y transversal aceptable
• Golpes anormales, inclinación o derrames comunicados antes de salir

Idea clave

La carga segura es compatible, centrada y limitada por masa y volumen; si su distribución no puede verificarse o corregirse sin exposición, la unidad no inicia el trayecto.$b$ where id = '2b3ebe88-acba-4b9f-9d99-e6dbb405de90';

update public.lesson_segment_slides set body = $b$Objetivo

Circular con una separación que permita detenerse sin depender de la reacción del vehículo precedente.

Explicación detallada

Las pistas mineras son lugares de trabajo dinámicos: pendiente, anchura, firme, drenaje, polvo, prioridades y tráfico cambian la capacidad de detener y de evitar colisiones. La velocidad autorizada es un máximo condicionado, no una velocidad obligatoria. Se respetan sentidos, prioridades y separación definidos por la explotación, y la distancia debe permitir detenerse aunque el vehículo precedente frene, pierda carga o quede inmovilizado. La caja permanece completamente bajada durante la circulación. En una intersección se reduce la velocidad, se establece contacto y se respeta la prioridad de las DIS: el tamaño de la máquina no concede prioridad. El claxon o la radio advierten, pero no sustituyen la confirmación.

Aplicación práctica

Una pista deteriorada es un defecto preventivo: el operador comunica la ubicación y la gravedad de baches, pérdida de berma, agua, polvo o material caído. En tráfico bidireccional la anchura útil considera el barrido del vehículo, su caja y los posibles derrames, no solo la calzada aparente.

Errores críticos que deben evitarse

• Conducir mirando solo al vehículo anterior, lo que favorece errores en cadena.
• Adelantar fuera de las zonas permitidas o sin que el otro operador conozca la maniobra.

Comprobación antes de continuar

• Sentidos, prioridades, límites y puntos de cruce conocidos
• Distancia de seguridad adaptada a carga y firme
• Peatones, vehículos ligeros y maquinaria lenta localizados

Idea clave

La velocidad se adapta a visibilidad, firme, pendiente, carga y tráfico; el límite señalizado nunca sustituye el juicio preventivo.$b$ where id = '7cec3d4f-9f98-44bc-96f6-540fa48856a1';

update public.lesson_segment_slides set body = $b$Objetivo

Decidir marcha, velocidad y sistema de retención antes de entrar en la pendiente.

Explicación detallada

El descenso concentra energía potencial y puede agotar la capacidad térmica de los frenos. Se evalúan longitud, inclinación, firme, curvas, carga y tráfico, y la marcha o el modo se seleccionan antes del cambio de rasante, según el manual. Descender en neutro o cambiar de relación perdiendo retención elimina una barrera esencial. Cada sistema tiene su función y no se intercambian: el freno de servicio modula y detiene durante la conducción, el de estacionamiento inmoviliza, el de emergencia responde a determinados fallos y el retarder o freno motor controla la velocidad limitando el calentamiento. Mantener el pedal aplicado durante todo el descenso eleva la temperatura y degrada la respuesta.

Aplicación práctica

La velocidad de otro vehículo no es referencia suficiente, porque puede llevar carga y frenos distintos. En subida se mantiene una relación que evite cambios tardíos y se acelera con progresividad; si la unidad se detiene, se aplica el procedimiento de inmovilización y no se deja retroceder para ganar impulso.

Errores críticos que deben evitarse

• Descender en punto muerto o neutralizar la transmisión en cualquier tramo de pendiente.
• Continuar tras una alarma de frenos o de temperatura hasta perder capacidad de detención.

Comprobación antes de continuar

• Marcha y sistema de retención seleccionados antes del cambio de rasante
• Separación aumentada y tramo libre
• Rutas de escape conocidas, sin usarlas como sustituto del control

Idea clave

La pendiente se gana con una selección previa y margen térmico; el freno de emergencia no es una estrategia de conducción ni el retarder sustituye la prueba del sistema principal.$b$ where id = '00cd8b65-df21-4fb3-8c30-7363de449c72';

update public.lesson_segment_slides set body = $b$Objetivo

Reducir antes de girar y condicionar la continuidad del transporte a poder detenerse dentro del espacio visible.

Explicación detallada

La aproximación a una curva se realiza en línea con la velocidad ya reducida, porque frenar bruscamente dentro de la curva transfiere carga y reduce adherencia. El peralte, la pendiente transversal, las roderas y una carga descentrada modifican el margen de vuelco, agravado por la altura del centro de gravedad. En articulados, el ángulo entre bastidores y la oscilación cambian los apoyos, así que se considera el barrido posterior y no se acelera hasta recuperar la alineación. Los cambios de rasante se abordan suponiendo que puede haber un obstáculo fuera de la vista. Lluvia, hielo, barro, polvo, niebla, viento y baja iluminación afectan de forma distinta a adherencia, visibilidad y estabilidad.

Aplicación práctica

Si no se ve el espacio necesario para detenerse o el vehículo deriva aun a velocidad reducida, se suspende el tramo y se comunica. La mejora puede exigir mantenimiento, señalista, sentido único o cierre temporal.

Errores críticos que deben evitarse

• Recortar por el borde o invadir el carril contrario para suavizar la trayectoria.
• Seguir a otra unidad como referencia, cuando eso no aporta visión propia ni garantiza que el firme sea estable.

Comprobación antes de continuar

• Velocidad reducida antes de entrar en curva o cruce
• Adherencia y visibilidad suficientes para detenerse en el espacio visible
• Baches, roderas, piedras o pérdida de berma comunicados

Idea clave

La velocidad se decide antes de la curva o el cruce; cuando visibilidad y adherencia no permiten detener dentro del espacio visible, el transporte se reorganiza o se suspende.$b$ where id = 'afa50baf-0bbd-419a-be66-bad7474a2105';

update public.lesson_segment_slides set body = $b$Objetivo

Descargar en tolva llegando alineado y despacio, y salir solo con la caja completamente bajada.

Explicación detallada

Una tolva combina el movimiento de un vehículo pesado, la marcha atrás, un hueco de descarga y estructuras fijas. Antes de aproximarse se verifican autorización, señalización, iluminación, limpieza, resistencia de la plataforma y estado de topes, rejillas y barandillas; el material acumulado puede impedir posicionar o modificar la altura efectiva. La aproximación es lenta y recta. Los topes sirven como referencia o protección según su diseño, nunca como freno de impacto ni como garantía de que el borde resiste. Una vez alineada, la unidad se inmoviliza y se coloca la transmisión según el manual, y la caja se eleva progresivamente mientras se observan inclinación, movimiento y descarga.

Aplicación práctica

El conductor permanece en la cabina protegida salvo procedimiento específico, y nadie cruza por detrás ni accede bajo la caja. Cualquier contacto con la tolva, fallo de tope o caída fuera se comunica y se preserva para inspección.

Errores críticos que deben evitarse

• Compensar el material adherido con aceleraciones, golpes o frenadas no autorizadas.
• Reanudar la marcha sin confirmar que la caja está completamente bajada.

Comprobación antes de continuar

• Ausencia de personas, material acumulado y daños antes de retroceder
• Unidad alineada e inmovilizada según el fabricante
• Caja bajada, mando en la posición indicada y señal de salida confirmada

Idea clave

El tope de una tolva no sustituye ni al frenado ni a la inspección: se llega alineado y despacio, se bascula inmovilizado y se sale solo con la caja completamente bajada.$b$ where id = 'f41af251-0e8f-497f-a351-ddbf3ccc7685';

update public.lesson_segment_slides set body = $b$Objetivo

Descargar en borde solo donde el punto está acondicionado, protegido e inspeccionado.

Explicación detallada

El borde de una escombrera puede perder resistencia por agua, asentamiento, grietas o vertido reciente, y aparentar más capacidad de la que tiene. La protección visible solo es eficaz si ha sido diseñada, mantenida y comprobada para la unidad: un montón de material suelto no debe interpretarse como berma resistente. El método puede ser basculado en borde protegido o descarga a distancia seguida de empuje por otro equipo, y la explotación define el punto límite y el sistema físico de referencia. Se retrocede recto, a velocidad mínima y con la unidad alineada; en articulados se evitan ángulos entre bastidores durante el basculado, porque una rueda sobre material blando o a distinta cota puede desplazar el centro de gravedad fuera de la base.

Aplicación práctica

Lluvia, deshielo o crecimiento del vertido obligan a reevaluar el punto. Si la berma falta o está dañada, se suspende hasta recuperar la condición prevista, y tras cada incidencia se cierra el punto, se inspecciona y se actualiza el método.

Errores críticos que deben evitarse

• Superar el punto autorizado o confiar en montículos sueltos como tope.
• Girar o avanzar con la caja elevada, o continuar el basculado tras detectar grietas, asiento o desnivel.

Comprobación antes de continuar

• Zona habilitada, con berma o sistema de protección definido
• Unidad alineada y retroceso recto a velocidad mínima
• Terreno vigilado durante todo el basculado

Idea clave

La escombrera se considera segura por su diseño, inspección y mantenimiento, nunca por costumbre; ante grieta, asiento o falta de protección se interrumpe la descarga.$b$ where id = '5d05faae-cedf-4cad-9387-8da49f01b1d1';

update public.lesson_segment_slides set body = $b$Objetivo

Resolver el material adherido en zona preparada y con bloqueo, nunca improvisando bajo la caja.

Explicación detallada

El material húmedo o congelado puede adherirse a la caja y descargar de forma súbita, desplazar el centro de gravedad o impedir la bajada. La caja puede elevarse sin que la masa se desplace y liberarla después bruscamente, así que se observan ángulo, inclinación y respuesta sin agotar el recorrido como método de desatasco. Si la unidad permanece estable se interrumpe y se intenta bajar la caja conforme al procedimiento, y solo con la caja apoyada se traslada a un área designada donde se inmoviliza, se aísla y se aplica un método mecánico de limpieza. Para entrar bajo la caja se coloca el bloqueo mecánico previsto, se descarga la presión y se consigna: los cilindros no son soporte.

Aplicación práctica

Los sistemas calefactores, cuando existen, se usan y mantienen conforme al fabricante y con sus protecciones; no autorizan a transportar material incompatible ni a introducir llama o calor improvisado. Después se investiga la causa, porque resolver solo el viaje la deja intacta.

Errores críticos que deben evitarse

• Golpear, trepar o introducirse bajo una caja elevada sin inmovilización, aislamiento y bloqueo mecánico.
• Circular con la caja levantada, con riesgo de vuelco y de impacto con líneas o estructuras.

Comprobación antes de continuar

• Caja bajada por completo antes de trasladar la unidad
• Limpieza realizada en el área designada y con medios mecánicos
• Bloqueo del mando del basculante instalado y verificado

Idea clave

Una caja elevada y cargada es una fuente de energía gravitatoria: ante material adherido se interrumpe, se baja si es seguro y se limpia únicamente en zona preparada y con bloqueo.$b$ where id = '1b7cb841-9a22-4034-ae0a-793d73b032d0';

update public.lesson_segment_slides set body = $b$Objetivo

Estacionar dejando la unidad sin energía de movimiento accesible y saber actuar ante una emergencia.

Explicación detallada

Para estacionar se elige terreno firme y lo más llano posible, en zona autorizada, fuera del tráfico, de bordes, frentes, drenajes y líneas, y sin bloquear rutas de emergencia. Se detiene la unidad, se coloca la transmisión en neutro, se aplica el freno y se baja completamente la caja; si existe riesgo de movimiento se utilizan calzos según el procedimiento. Antes de parar el motor se respeta el tiempo de estabilización que indica el fabricante, sin aplicar una cifra universal. Se retira o controla la llave y se desciende con tres puntos de apoyo. Ante un accidente se aplica la conducta PAS: proteger, avisar y socorrer sin crear nuevas víctimas.

Aplicación práctica

El operador debe conocer las alarmas, las rutas de evacuación, el punto de reunión y la forma de comunicar ubicación, equipo, material y peligros presentes. Si existe una alarma, la máquina se detiene en el primer lugar seguro y se registra el código y las condiciones en que apareció.

Errores críticos que deben evitarse

• Dejar la unidad con el motor en marcha sin vigilancia o con la llave accesible, incluso en una pausa breve.
• Abrir un sistema caliente o reiniciar repetidamente la máquina tras una alarma.

Comprobación antes de continuar

• Terreno firme y llano, caja completamente bajada
• Freno aplicado y calzos colocados si hay riesgo de movimiento
• Tiempo de estabilización del fabricante respetado antes de parar el motor

Idea clave

El fin del ciclo deja el equipo apoyado, los mandos neutros, el freno aplicado, el motor detenido y cualquier incidencia claramente registrada.$b$ where id = 'd2c1bc6a-a941-4539-bf03-5e862ac119c7';

-- Bloque 4 · Conocimiento de la máquina y sistemas de seguridad

update public.lesson_segment_slides set body = $b$Objetivo

Interpretar los síntomas del motor, la lubricación y la refrigeración antes de que la desviación se convierta en avería.

Explicación detallada

El motor transforma la energía del combustible en movimiento y depende de la admisión, el escape, la lubricación y la refrigeración. El operador no necesita desmontarlos, pero sí reconocer la pérdida de presión de aceite, el aumento de temperatura, el humo anormal, las fugas y la reducción de potencia. Filtros saturados, entradas de polvo o combustible contaminado bajan el rendimiento y elevan la temperatura; aumentar carga para ver si se limpia no es un diagnóstico. El circuito de refrigeración evacua calor mediante refrigerante, radiador, ventilador, bomba y termostato, y el polvo o el barro sobre el paquete de enfriamiento reducen el caudal de aire. Un sistema caliente puede estar presurizado.

Aplicación práctica

Los radiadores y las entradas de aire se limpian con el método previsto, con el motor parado y frío, sin doblar aletas ni proyectar polvo hacia las personas. Tras la intervención se confirma que resguardos y tapas quedan montados.

Errores críticos que deben evitarse

• Mantener la máquina en marcha para ver si recupera cuando la presión de aceite es crítica.
• Abrir un tapón presurizado en caliente o añadir líquido frío sin esperar y verificar.

Comprobación antes de continuar

• Presión de aceite, temperatura y nivel dentro de lo previsto
• Compartimento libre de material combustible y acumulaciones de aceite
• Fluidos e intervalos según el manual, sin mezclar productos

Idea clave

Una alarma de temperatura o lubricación es una orden de diagnóstico: se detiene conforme al procedimiento y nunca se oculta para continuar.$b$ where id = '8aa0c995-8a46-4661-8d83-88c86ad6d117';

update public.lesson_segment_slides set body = $b$Objetivo

Gestionar la tracción antes de perder adherencia y usar la transmisión dentro de los regímenes del manual.

Explicación detallada

La transmisión lleva la potencia del motor hasta las ruedas y puede incorporar convertidor de par, caja de cambios, ejes, diferenciales y mandos finales, o soluciones eléctricas e hidrostáticas según el modelo. Su diseño condiciona cómo se seleccionan las marchas, cómo actúa el retarder y qué ocurre al perder presión. Seleccionar una marcha inadecuada en pendiente obliga a un frenado continuo y genera calentamiento. La fuerza disponible debe ser compatible con la adherencia: el patinamiento prolongado daña neumáticos o cadenas y puede hacer que la máquina derive hacia un borde, por lo que se reduce carga, se mejora la ruta o se cambia el método en vez de responder con más aceleración.

Aplicación práctica

El uso de bloqueos de diferencial o modos de tracción se ajusta al manual; accionarlos para forzar un giro puede dañar componentes y reducir el control. Una máquina que avanza con el mando en neutro, cambia de sentido con retardo o no mantiene posición se retira de servicio.

Errores críticos que deben evitarse

• Invertir el sentido de marcha con la unidad todavía en movimiento o hacer cambios bruscos de relación.
• Confiar el bloqueo de transmisión como sustituto del freno de estacionamiento o de los calzos.

Comprobación antes de continuar

• Modo y marcha recomendados para la pendiente y la carga
• Testigos de temperatura, presión o fallo sin avisos activos
• Ausencia de fugas o ruidos en ejes y mandos finales

Idea clave

La potencia solo es útil mientras existe control; patinamiento, deriva o respuesta retardada indican que debe reducirse carga y revisar el sistema.$b$ where id = '815f3fd9-9717-47c7-a2f7-2ef6223816b5';

update public.lesson_segment_slides set body = $b$Objetivo

Distinguir los cuatro sistemas de retención y saber cómo se prueba y se vigila cada uno.

Explicación detallada

El freno de servicio controla la marcha normal y detiene; el de estacionamiento mantiene la unidad inmóvil; el de emergencia aporta capacidad ante determinados fallos; y el retarder o freno motor ayuda a controlar la velocidad, especialmente en descensos, sin sobrecalentar el sistema principal. La arquitectura puede ser hidráulica, neumática, eléctrica o combinada, y algunos circuitos conservan presión acumulada. Usar un sistema fuera de su función puede sobrecalentarlo o impedir una inmovilización fiable: el freno de estacionamiento no se emplea como freno habitual y el retarder no garantiza la detención final. Ante una pérdida se mantiene la trayectoria, se aplican los sistemas conforme al manual y se busca la zona de detención prevista.

Aplicación práctica

La comprobación se hace antes de producción, en el terreno previsto y a baja velocidad, verificando respuesta, presión, recorrido, mantenimiento de la inmovilización y ausencia de desviación. Tras un calentamiento, una pérdida de presión o la actuación del freno de emergencia, el equipo queda fuera de servicio hasta inspección.

Errores críticos que deben evitarse

• Iniciar un descenso confiando en que el freno de emergencia corregirá una conducción inadecuada.
• Reiniciar o bombear repetidamente para ocultar un aviso, cuando eso no restablece la capacidad.

Comprobación antes de continuar

• Frenos probados según la secuencia del manual antes del turno
• Presión, recorrido y temperatura sin variación progresiva anómala
• Zona de detención prevista identificada en la ruta

Idea clave

Freno de servicio, estacionamiento, emergencia y retarder no son cuatro nombres para la misma función; deben probarse y utilizarse según la arquitectura concreta.$b$ where id = '2a753027-f564-45b2-b5d2-22550a1febc6';

update public.lesson_segment_slides set body = $b$Objetivo

Anticipar el barrido real de la unidad y tratar la articulación como zona de atrapamiento permanente.

Explicación detallada

En los volquetes rígidos la dirección actúa sobre las ruedas delanteras mientras el bastidor permanece continuo; en los articulados, los cilindros hidráulicos modifican el ángulo entre bastidores y la oscilación permite inclinaciones relativas. El conductor anticipa que la parte posterior recorta o barre zonas distintas y adapta la entrada en curva y la carga. La velocidad amplifica las fuerzas laterales y reduce el tiempo para corregir. Algunos equipos incorporan dirección de emergencia capaz de aportar control limitado si falla la fuente principal: su autonomía y su modo de activación varían y se comprueban según el manual. Es una función para detenerse con seguridad, no para completar el viaje.

Aplicación práctica

Para inspeccionar o reparar entre bastidores se alinea, se inmoviliza, se descarga la energía y se instala el bloqueo mecánico previsto, porque apagar el motor no impide por sí solo un cierre por gravedad, presión o movimiento externo.

Errores críticos que deben evitarse

• Continuar la producción tras activarse la dirección de emergencia en lugar de detenerse siguiendo el manual.
• Entrar entre bastidores confiando en la dirección hidráulica o en un calzo improvisado.

Comprobación antes de continuar

• Holgura, esfuerzo y respuesta de la dirección probados en ambos sentidos
• Barrido de caja y parte posterior considerado en maniobras cerradas
• Bloqueo de articulación instalado antes de cualquier acceso

Idea clave

La articulación se considera siempre una zona de atrapamiento y la dirección de emergencia un medio para detener, no una autorización para continuar el ciclo.$b$ where id = 'fb6be951-cef2-49bf-a034-68451adddeca';

update public.lesson_segment_slides set body = $b$Objetivo

Operar el basculante sabiendo que la presión eleva la caja pero solo el bloqueo mecánico protege una intervención.

Explicación detallada

La caja se eleva mediante cilindros y un circuito hidráulico gobernado por posiciones como subir, mantener, flotante o bajar, cuya denominación varía según el fabricante. A medida que sube la caja el centro de gravedad asciende y el efecto de un apoyo blando o de una carga adherida aumenta, por lo que solo se bascula con la unidad alineada, inmovilizada y sobre terreno apto, con la pendiente transversal dentro del límite definido. El riesgo más grave durante el mantenimiento es la bajada imprevista. Los movimientos a tirones, la deriva, una fuga, un ruido o la falta de respuesta son defectos: no se aumentan revoluciones ni se repite el ciclo para forzar un sistema que no funciona con normalidad.

Aplicación práctica

Para trabajar bajo la caja se vacía cuando es posible, se inmoviliza, se aísla, se descarga el circuito y se instala el soporte o bloqueo mecánico diseñado. Al finalizar se verifica que todos han salido y se prueba desde la cabina en zona despejada.

Errores críticos que deben evitarse

• Usar una barra improvisada o los propios cilindros como retención bajo la caja.
• Circular o pasar bajo estructuras y líneas sin confirmar que la caja está completamente apoyada.

Comprobación antes de continuar

• Unidad alineada, inmovilizada y sobre terreno apto antes de elevar
• Caja completamente bajada y mando en la posición indicada antes de circular
• Presión residual descargada antes de cualquier intervención

Idea clave

La presión eleva la caja, pero solo el bloqueo mecánico previsto protege una intervención; para circular, la caja debe estar completamente bajada y confirmada.$b$ where id = 'a9c4b4fc-3332-4d62-b5b3-208abbb3ca74';

update public.lesson_segment_slides set body = $b$Objetivo

Leer bastidor, suspensión y neumáticos como un sistema único que sostiene la estabilidad.

Explicación detallada

El bastidor transmite los esfuerzos entre carga, suspensión, ejes y articulación; las fisuras, deformaciones o reparaciones no autorizadas reducen su resistencia. La pintura agrietada, el óxido lineal o una marca reciente pueden revelar movimiento estructural, y soldar sin especificación técnica introduce tensiones o afecta a aceros especiales. La suspensión controla oscilaciones y mantiene el contacto con el terreno: una fuga, una diferencia de altura o un tope dañado cambian el reparto de masas y, con la caja cargada, amplifican el balanceo. En los neumáticos, carga, velocidad, presión, distancia y temperatura forman un conjunto, y rebasar uno solo puede dañar internamente la carcasa aunque la banda parezca entera.

Aplicación práctica

El operador compara la actitud de la unidad en terreno nivelado y comunica cualquier cambio. Una vibración o deriva se investiga antes de continuar, porque puede indicar un defecto de fijación, carcasa, suspensión o bastidor.

Errores críticos que deben evitarse

• Compensar una vibración o deriva con el volante en lugar de detener y diagnosticar.
• Ajustar presiones o alturas de suspensión sin procedimiento, cuando acumuladores y cilindros conservan energía.

Comprobación antes de continuar

• Fisuras, deformaciones, pasadores y zonas de impacto revisados
• Actitud de la unidad sin inclinaciones ni diferencias de altura nuevas
• Rutas libres de bloques y ciclos gestionados para no acumular calor

Idea clave

La estabilidad depende del sistema completo caja-bastidor-suspensión-neumático-terreno; una desviación de comportamiento exige diagnóstico, no compensación del conductor.$b$ where id = 'b58b4710-8e8f-4a9c-82a4-ee0a26655315';

update public.lesson_segment_slides set body = $b$Objetivo

Manejar baterías, circuitos e indicadores sabiendo que la energía eléctrica sigue presente con el motor parado.

Explicación detallada

El sistema eléctrico alimenta arranque, control, iluminación, comunicaciones y alarmas, combinando corriente elevada, electrolito, gases y electrónica sensible. Las baterías pueden generar gases, ácido y corrientes capaces de producir quemaduras o incendios, así que se revisan fijación, tapas, corrosión, cables, aislamiento y señales de calentamiento, y no se dejan herramientas metálicas sobre ellas. El arranque auxiliar utiliza el punto de conexión, la tensión, la polaridad y la secuencia del fabricante, con la última conexión situada donde determine el manual para limitar chispas cerca de los gases. Desconectar el seccionador no sustituye comprobar la ausencia de energía: algunos acumuladores o condensadores mantienen tensión.

Aplicación práctica

El panel integra información sobre presión, temperatura, niveles, transmisión, frenos y carga, pero el significado de colores y niveles no es idéntico en todas las marcas, así que el operador aprende el del manual específico y registra código, condiciones y momento de cada alarma.

Errores críticos que deben evitarse

• Puentear fusibles, cables o sensores, o sustituir un fusible fundido por otro de mayor valor.
• Reiniciar para borrar el aviso, lo que no elimina el problema y puede borrar información útil.

Comprobación antes de continuar

• Bornes protegidos, sin corrosión ni señales de calentamiento
• Secuencia y polaridad del fabricante respetadas en cualquier conexión
• Alarmas identificadas con la respuesta prevista en el manual

Idea clave

La energía eléctrica continúa siendo peligrosa con el motor parado; conexiones, polaridad, seccionamiento y descarga se realizan exactamente según el modelo y la consignación.$b$ where id = 'cfc101e1-2c2d-4a8e-b373-3ecc4145b63c';

update public.lesson_segment_slides set body = $b$Objetivo

Construir el mapa real de zonas ciegas y usar las ayudas de visión sin sustituir la segregación.

Explicación detallada

Las dimensiones de la maquinaria generan zonas que el operador no puede ver directamente. El mapa de visibilidad cambia con la caja baja y elevada, con carga y en vacío, durante el giro y en marcha atrás; en los articulados, la posición relativa de los bastidores lo modifica además mientras se gira. Las cámaras pueden perder imagen por suciedad, condensación, contraste o avería; los sensores detectan solo dentro de determinados rangos y materiales, y una alarma frecuente genera habituación; los espejos deforman la distancia y exigen interpretación. La señal acústica advierte pero no concede prioridad absoluta. La estructura ROPS y el cinturón actúan conjuntamente: el cinturón mantiene al ocupante dentro del volumen protegido durante un vuelco.

Aplicación práctica

Cuando la visión directa y los sistemas no bastan se recurre a un señalista formado, con alta visibilidad, situado donde vea la zona sin quedar en la trayectoria. Una sola persona dirige, y si se pierde al señalista, la orden es ambigua o falla la radio, la máquina se detiene.

Errores críticos que deben evitarse

• Mover la unidad cuando el área no está controlada, apoyándose solo en cámaras o alarmas.
• Presuponer que todas las personas oyeron el motor tras una parada, sin repetir la comprobación.

Comprobación antes de continuar

• Cristales, espejos y cámaras limpios y ajustados desde la posición real de conducción
• ROPS y FOPS con sus fijaciones íntegras y sin modificaciones
• Cinturón abrochado y salidas de emergencia operativas

Idea clave

Una ayuda de visión no sustituye la segregación; si se pierde el control visual o la señal del guía, la máquina se detiene.$b$ where id = 'cb3a6aa8-f292-4c28-8672-fd9e2f268bf3';

update public.lesson_segment_slides set body = $b$Objetivo

Usar cada bloqueo y cada resguardo para la función que fue diseñado y reponerlos antes de volver al trabajo.

Explicación detallada

Los resguardos cubren correas, ventiladores, ejes y zonas peligrosas; los bloqueos mecánicos sostienen la caja o inmovilizan la articulación; los interbloqueos impiden funciones en condiciones no permitidas; y los bloqueos de transmisión y mandos reducen la puesta en movimiento. Cada elemento responde a un riesgo y no es intercambiable: una llave retirada no sostiene una caja elevada y un soporte hidráulico no evita un arranque eléctrico. Bocina, luces, alarma de retroceso y señalización advierten, pero no crean por sí solas un espacio seguro. Si se retira una protección, primero se separan las energías, se bloquea, se disipa y se verifica, y el soporte mecánico se coloca en su posición diseñada.

Aplicación práctica

Al terminar se cuentan las herramientas, se montan los resguardos, se inspeccionan las fijaciones, cada responsable retira su bloqueo y se prueba sin carga y a baja velocidad. Las anulaciones temporales de diagnóstico exigen procedimiento técnico y no quedan en producción.

Errores críticos que deben evitarse

• Anular un interbloqueo para ganar tiempo, eliminando una barrera prevista frente a movimientos inesperados.
• Usar los resguardos como peldaños o puntos de amarre.

Comprobación antes de continuar

• Resguardos presentes, sin deformaciones ni roces
• Bloqueo adecuado a la energía concreta que se quiere controlar
• Personas fuera del área antes de iniciar cualquier maniobra

Idea clave

Cada energía necesita su barrera; retirar una protección exige consignar y la máquina no vuelve al trabajo hasta que todo quede repuesto y probado.$b$ where id = '189e18ab-6be9-47bd-b4de-4f4f4a42c91b';

update public.lesson_segment_slides set body = $b$Objetivo

Tomar del manual los límites del modelo y familiarizarse antes de usar una unidad distinta.

Explicación detallada

El manual de instrucciones define capacidades, cargas, pendientes, velocidades, presiones, fluidos, secuencias y advertencias del modelo concreto, y la formación general no puede sustituir esa información. El Real Decreto 1215/1997 obliga al empresario a seleccionar, mantener y utilizar equipos adecuados: su anexo I contempla órganos de accionamiento, puesta en marcha, parada y protección frente a proyecciones, vuelco, caída de objetos y contacto, y para equipos móviles exige, según el riesgo, frenos, visibilidad, iluminación, protección contra incendio y señal acústica. Un accesorio, una cabina, un cambio de software o un uso nuevo pueden crear riesgos y modificar los límites, por lo que requieren evaluación y autorización.

Aplicación práctica

Antes de utilizar una unidad distinta, incluso de la misma marca, el operador se familiariza con mandos, respuesta, dimensiones, zonas ciegas, alarmas y dispositivos de emergencia. La verificación física cierra el sistema: placa, equipo, accesorios y estado deben coincidir con lo escrito.

Errores críticos que deben evitarse

• Aplicar una costumbre que contradice el manual en lugar del procedimiento validado por la empresa.
• Aceptar ajustes o modificaciones informales sin evaluación, formación y prueba posterior.

Comprobación antes de continuar

• Manual de la edición del modelo disponible y comprensible
• Tablas y placas legibles y coincidentes con el equipo real
• Familiarización realizada tras cualquier cambio de unidad o accesorio

Idea clave

La adecuación documental solo es válida si coincide con máquina, accesorio, uso y estado reales; cualquier cambio obliga a reevaluar.$b$ where id = 'd742bf11-ffbf-4a66-bafc-318746ad50ed';

-- Bloque 5 · Control del entorno, interferencias, emergencias y normativa

update public.lesson_segment_slides set body = $b$Objetivo

Leer el panel como información para decidir y actuar sobre las tendencias antes de que salte la alarma máxima.

Explicación detallada

Manómetros, termómetros, indicadores de nivel, amperímetros, voltímetros y sistemas electrónicos muestran el estado de la máquina. Al conectar se observa que testigos y avisos completan la secuencia prevista: un indicador que nunca se enciende puede estar averiado, no significar ausencia de riesgo. El fabricante puede clasificar los avisos como información, precaución, parada segura o detención inmediata, y el manual define si se reduce carga, se sale del tráfico, se mantiene el motor para refrigerar o se para. No existe una reacción universal válida para todos los símbolos. Los valores se interpretan en relación con la carga y la pendiente: una temperatura que sube en cada vuelta o una presión inestable justifican comunicar aunque no haya alarma roja.

Aplicación práctica

El indicador de carga ayuda a evitar la sobrecarga pero requiere calibración y no corrige una distribución deficiente. Al comunicar un aviso se registra código, color, momento, carga, pendiente y síntomas, para poder reproducir el fallo.

Errores críticos que deben evitarse

• Borrar códigos, tapar testigos o continuar porque el equipo todavía se mueve.
• Silenciar el sonido como si eso anulara la causa del aviso.

Comprobación antes de continuar

• Autodiagnóstico completado y testigos críticos identificados
• Respuesta prevista en el manual para cada nivel de aviso
• Tendencias repetidas comunicadas antes de llegar a un nivel crítico

Idea clave

El panel no es decoración ni diagnóstico definitivo: informa para actuar según el manual, y las tendencias repetidas se comunican antes de alcanzar un nivel crítico.$b$ where id = 'cd37772c-5d2a-46f0-b8d8-75a021a33a9f';

update public.lesson_segment_slides set body = $b$Objetivo

Vigilar frente y plataforma como condiciones que cambian dentro del propio turno.

Explicación detallada

El lugar de trabajo cambia por excavación, voladura, lluvia, tránsito y vertido. La zona de carga debe ofrecer superficie resistente, espacio de maniobra, visibilidad y protección frente a desprendimientos, así que se observan geometría, discontinuidades, bloques, voladizos, grietas, caída reciente y agua. Tras una voladura se respeta la autorización de entrada y los barrenos fallidos se atienden mediante procedimiento. La plataforma debe soportar la máquina y las cargas dinámicas: se revisan hundimientos, roderas, rellenos, drenaje y proximidad a vacíos, y la anchura útil incluye la caja, el barrido del vehículo y un margen de separación. Las grietas paralelas, el abombamiento, las filtraciones y las caídas son señales de inestabilidad.

Aplicación práctica

El operador de transporte tiene derecho y obligación de rechazar una posición que comprometa cabina, neumáticos, estabilidad o ruta de salida. Si una rueda se hunde, se baja la caja cuando el basculado estuviera iniciándose y se detiene antes de intentar salir.

Errores críticos que deben evitarse

• Situarse bajo material inestable o probarlo golpeando desde una posición expuesta.
• Tapar una grieta con material en lugar de retirarse, delimitar y comunicar.

Comprobación antes de continuar

• Talud, acopio, bloques sueltos, agua y barro revisados
• Plataforma capaz y ruta de retirada libre
• Método revisado si cambia el frente, se sanea el terreno o entra otro equipo

Idea clave

Frentes y plataformas se vuelven a inspeccionar tras cualquier cambio; una grieta o caída exige retirada, delimitación y evaluación.$b$ where id = '6470f6d8-8dcc-4f66-b169-06f26c90563e';

update public.lesson_segment_slides set body = $b$Objetivo

Reconocer la pista como una instalación que se mantiene, no como un camino que simplemente existe.

Explicación detallada

Una pista segura necesita anchura, firme, drenaje, visibilidad, bermas y señalización acordes con los equipos. La ITC 07.1.03 fija referencias mínimas: una pista de un carril tendrá al menos 1,5 veces la anchura del vehículo mayor, o 2 veces con tráfico intenso y pesado, y una de dos carriles 3 veces la anchura del vehículo más ancho; los apartaderos tendrán al menos el doble de la longitud del vehículo más largo. La misma ITC establece una pendiente longitudinal media no superior al 10 %, con máximos aislados del 15 % y accesos especiales que no rebasen el 20 % con medidas específicas. Son mínimos que el proyecto, la geotecnia y las DIS pueden endurecer. Una berma señala o contiene dentro de su diseño, pero no es un freno.

Aplicación práctica

El polvo se reduce con riego, captación, velocidad y mantenimiento, pero el riego se coordina para no generar barro ni deslumbramiento. Si el polvo impide ver, se detiene aunque exista un límite señalizado superior.

Errores críticos que deben evitarse

• Circular fuera de la ruta para acortar camino o rebasar una barrera.
• Copiar cifras generales de pendiente o anchura sin comprobar el proyecto y las DIS.

Comprobación antes de continuar

• Firme, bermas, drenaje y señalización en la condición prevista
• Puntos especiales identificados con su velocidad y prioridad
• Baches, roderas, blandones, derrames o pérdida de protección comunicados

Idea clave

Una pista segura necesita firme, berma y drenaje mantenidos; el control de polvo nunca debe degradar la adherencia ni la visibilidad.$b$ where id = '01517a8e-692b-4053-bc69-ba1f116c25a3';

update public.lesson_segment_slides set body = $b$Objetivo

Inspeccionar los puntos repetitivos precisamente porque la repetición esconde el deterioro.

Explicación detallada

Tolvas, escombreras y estacionamientos son puntos fijos donde se repiten maniobras y pueden normalizarse los defectos. En una tolva se observan topes, rejillas, semáforos, barandillas, estructura, acumulaciones y derrames, y los enclavamientos con trituradoras o alimentadores se respetan: nadie entra a desatascar mientras continúe la descarga o exista energía sin consignar. En una escombrera la inspección busca grietas, erosión, agua, material reciente, pérdida de berma y pendiente transversal, y el lugar autorizado se actualiza y señaliza porque el frente cambia con cada vertido. Las zonas de estacionamiento deben permitir inmovilizar y separar unidades sin bloquear la evacuación ni exponer a peatones.

Aplicación práctica

Si falta una protección prevista, la descarga se suspende y se impide la entrada de la siguiente unidad. La aparente continuidad del terreno no prueba su capacidad portante.

Errores críticos que deben evitarse

• Aparcar por costumbre junto a un borde, bajo una línea o en pendiente.
• Reanudar la descarga tras una vibración, un asentamiento o un daño por impacto sin comunicarlo.

Comprobación antes de continuar

• Iluminación, señalización, limpieza y resistencia del terreno confirmadas
• Topes o bermas presentes y sin daño
• Zona libre de personas y rutas de emergencia despejadas

Idea clave

Los puntos repetitivos no son automáticamente seguros: se inspeccionan porque cada descarga, lluvia, impacto o reparación puede modificar su resistencia y sus protecciones.$b$ where id = '694162a4-6f0a-43a2-b3f8-5cbfcc704ada';

update public.lesson_segment_slides set body = $b$Objetivo

Dirigir las maniobras con un único emisor, mensajes confirmados y una parada acordada.

Explicación detallada

Las comunicaciones pueden realizarse por radio, señales manuales, semáforos o medios acústicos definidos por la explotación, y deben ser breves, inequívocas y confirmadas cuando afecten a una maniobra de riesgo. Se identifica quién da la orden y se evita que varias personas dirijan a la vez. El señalista está formado, identificado y visible, se sitúa fuera de la zona de atrapamiento, no camina de espaldas y conserva una salida. Las órdenes de terceros no se obedecen, salvo una parada de emergencia, que cualquiera puede indicar. La radio utiliza mensajes breves con identificación, orden y confirmación; una orden ambigua se repite, y el ruido y la cobertura se prueban antes.

Aplicación práctica

Antes de retroceder se comprueba el área, se avisa y se espera respuesta cuando el procedimiento lo exija. Los canales y palabras de emergencia deben ser conocidos por todo el personal y mantenerse libres de conversaciones innecesarias.

Errores críticos que deben evitarse

• Continuar la maniobra tras perder el contacto con el señalista o la radio.
• Aceptar gestos improvisados o varios guías dirigiendo la misma maniobra.

Comprobación antes de continuar

• Emisor de la orden identificado y único
• Señales y punto de parada acordados antes de empezar
• Cobertura de radio probada en la zona de trabajo

Idea clave

La alta visibilidad no sustituye el contacto; ninguna persona entra en la envolvente hasta que máquina y operador estén en condición segura.$b$ where id = '507c20d5-cd54-41a7-9da7-ced120570c83';

update public.lesson_segment_slides set body = $b$Objetivo

No dar por visto a nadie cuando coinciden máquinas pesadas, vehículos ligeros, mantenimiento y peatones.

Explicación detallada

En carga, descarga y circulación coinciden equipos de gran tamaño, vehículos ligeros, personal de mantenimiento y peatones. Las personas de tierra son especialmente vulnerables porque el operador puede no verlas y porque una máquina no puede detenerse instantáneamente. La prevención exige separar rutas, establecer prioridades y limitar accesos: se diseñan itinerarios peatonales y refugios, y nadie entra en el radio de trabajo sin autorización y contacto. La ropa de alta visibilidad ayuda, pero no hace visible a una persona oculta tras la caja o el capó. Los vehículos ligeros evitan permanecer en zonas ciegas y usan los puntos de espera. Las maniobras simultáneas se coordinan para que un movimiento no invada el radio de otro equipo.

Aplicación práctica

Durante una reparación en pista se señaliza y se protege la unidad antes de intervenir. El acceso a la cabina se hace con la máquina detenida, el equipo apoyado y la señal confirmada; las contratas reciben las mismas reglas y mapas.

Errores críticos que deben evitarse

• Aproximarse a un volquete sin comunicación y sin confirmación del operador.
• Confiar en la alarma de retroceso como si concediera prioridad o sustituyera la comprobación visual.

Comprobación antes de continuar

• Rutas separadas y prioridades definidas por procedimiento
• Contacto visual o por radio confirmado con cada persona expuesta
• Movimientos detenidos ante cualquier interferencia no prevista

Idea clave

La alta visibilidad no sustituye el contacto; ninguna persona entra en la envolvente hasta que máquina y operador estén en condición segura.$b$ where id = '7a30ff0c-cfd0-4f6a-843d-6f0f23488955';

update public.lesson_segment_slides set body = $b$Objetivo

Planificar el cruce de líneas y estructuras por tensión y geometría, no por una distancia genérica.

Explicación detallada

Una máquina puede invadir la zona de peligro de una línea sin contacto directo, por alcance, balanceo, terreno o arco. Se aplican el Real Decreto 614/2001 y el procedimiento eléctrico del centro: una persona autorizada o cualificada determina la viabilidad y se prioriza desenergizar, desviar o proteger. La planificación contempla la altura de la caja, la carga, la antena, la suspensión, la oscilación y el posible rebote del vehículo, porque el terreno puede inclinar la máquina y reducir el margen. La regulación minera prevé referencias de trazado y aviso, como señalización previa a cruces situada a 25 m, circulación con la caja bajada, separación de 15 m para itinerarios paralelos y una zona general de 10 m a cada lado de la línea. Esas referencias no sustituyen las zonas de peligro y proximidad del RD 614/2001.

Aplicación práctica

Las líneas enterradas se localizan y marcan, y una señal antigua no basta: se verifica. Si existe duda sobre altura o ruta, se detiene la unidad antes de entrar.

Errores críticos que deben evitarse

• Estimar la distancia a ojo o generalizar una cifra sin evaluación por tensión.
• Tocar simultáneamente la máquina y el suelo, o aproximarse antes de que personal competente confirme la ausencia de tensión.

Comprobación antes de continuar

• Tensión, altura y recorrido de las líneas identificados
• Caja completamente bajada y gálibo de la ruta autorizado
• Actuación ante contacto conocida y entrenada

Idea clave

No existe una distancia única: se determina por tensión, movimiento posible y procedimiento; el arco puede producirse antes del contacto.$b$ where id = '2c47b149-cd40-4677-9871-d2c29c619edc';

update public.lesson_segment_slides set body = $b$Objetivo

Pasar la máquina a mantenimiento y recuperarla mediante una entrega formal y una liberación inequívoca.

Explicación detallada

El mantenimiento introduce personas en zonas normalmente segregadas y puede exigir retirar resguardos, así que producción y taller coordinan inmovilización, consignación, prueba y liberación. El operador estaciona, apoya, limpia lo necesario y describe el defecto con códigos, síntomas y condiciones; mantenimiento identifica máquina y alcance, se delimitan zonas y se acuerda quién controla la consignación. Dejar la llave no es una medida suficiente. Si se necesita energizar para diagnóstico se aplica un procedimiento específico, con la zona despejada, y después se vuelve a consignar. Las empresas concurrentes intercambian riesgos y procedimientos, y la coordinación no consiste en intercambiar documentos sin más.

Aplicación práctica

Al terminar se retiran herramientas, se reponen resguardos, cada persona retira su bloqueo y el responsable confirma. La prueba funcional se hace en zona despejada, con funciones lentas y observación de fugas; si aparece un defecto, se vuelve a inmovilizar.

Errores críticos que deben evitarse

• Recuperar la máquina para producción sin confirmación expresa de quien la liberó.
• Puentear protecciones para poder producir o dejar un trabajo incompleto sin etiquetar.

Comprobación antes de continuar

• Unidad inmovilizada, delimitada y consignada antes de reparar
• Titular de la autorización de arranque identificado
• Permiso y análisis actualizados si cambia el alcance

Idea clave

La máquina pasa de producción a mantenimiento y vuelve mediante una entrega formal, consignación verificada y liberación inequívoca.$b$ where id = 'dc1ddff2-1dd6-4ee4-ad68-4d99dac16faf';

update public.lesson_segment_slides set body = $b$Objetivo

Convertir el plan de emergencia en conducta: detener, evacuar, comunicar y reunirse.

Explicación detallada

El plan de emergencia define alarmas, responsables, vías de evacuación, punto de reunión, comunicaciones y medios disponibles, e incluye cómo detener equipos, asegurar zonas, evacuar y recibir ayuda externa. El operador debe saber quién activa la alarma, qué señal se emplea, dónde reunirse y qué alternativas existen si una ruta está bloqueada. Al oír la alarma se detiene sin bloquear rutas, se apoya el equipo, se aplica el freno, se apaga y se evacua según indicación, sin volver por objetos. Ante un accidente se aplica PAS: proteger el lugar, avisar con información precisa y socorrer solo dentro de la propia competencia. En incendio, vuelco, pérdida de frenos o contacto eléctrico la conducta varía, por eso se practican escenarios.

Aplicación práctica

En el punto de reunión se contabiliza al personal y no se abandona hasta recibir autorización. Informar de un compañero ausente es esencial; volver a buscarlo por cuenta propia, no.

Errores críticos que deben evitarse

• Mover a una persona lesionada salvo peligro inmediato, o darle bebida si está inconsciente.
• Conducir a ciegas entre humo o polvo en lugar de reducir la velocidad y detenerse.

Comprobación antes de continuar

• Alarmas, rutas de evacuación y punto de reunión conocidos
• Salida de emergencia de la cabina localizada y operativa
• Área preservada según procedimiento tras el incidente

Idea clave

El plan solo funciona si cada operador sabe detener, evacuar, comunicar y reunirse; los simulacros convierten instrucciones en conducta.$b$ where id = '1a874fb5-4838-4292-a575-c3ab49018de0';

update public.lesson_segment_slides set body = $b$Objetivo

Situar la norma, las DIS y el reciclaje en su lugar dentro del trabajo diario.

Explicación detallada

La Ley 31/1995 establece el deber de protección, evaluación, información, formación y participación. El Real Decreto 1389/1997 concreta los mínimos en industrias extractivas y exige organización, trabajadores competentes e instrucciones escritas. El Reglamento General y sus ITC regulan la seguridad minera y las Disposiciones Internas de Seguridad. La ITC 02.1.02 y la ET 2000-1-08 fijan la formación del puesto: inicial de veinte horas para este itinerario y reciclaje presencial de al menos cinco horas, con una frecuencia máxima de dos años. El Real Decreto 1215/1997 regula la selección, adecuación y uso de los equipos, y el Real Decreto 171/2004 la coordinación entre empresas. Las NTP y guías son criterios de apoyo, no sustituyen la norma.

Aplicación práctica

El trabajador usa correctamente el equipo, no anula protecciones, informa de los defectos y coopera; tiene derecho a interrumpir ante un riesgo grave e inminente. Parar ante una pérdida de control no es improductividad.

Errores críticos que deben evitarse

• Dar por cumplida la norma con un documento firmado que no se aplica en el trabajo real.
• Tratar la acreditación como sustituto de seguir el manual y comunicar los defectos cada día.

Comprobación antes de continuar

• Marco aplicable y DIS del centro conocidos y vigentes
• Formación inicial y reciclaje dentro de la frecuencia exigida
• Registros de inspección, mantenimiento e incidentes al día

Idea clave

La normativa se cumple cuando se transforma en condiciones reales: equipo adecuado, formación presencial, instrucciones claras y capacidad efectiva de detener.$b$ where id = '6df35eb9-9c70-44b8-8b15-0d8015fdcf4a';

-- Transcripciones: guion registrado de cada locución, tomado del manual maestro.

update public.lesson_audio_segments set narration_text = $n$Este curso desarrolla la formación preventiva inicial para operadores de maquinaria de transporte en actividades extractivas de exterior, especialmente operadores de volquete y conductores de camión. También se aplica al personal de empresas contratistas que realiza estas tareas. Su duración mínima es de veinte horas y su finalidad no es enseñar únicamente a conducir, sino preparar al trabajador para reconocer los riesgos del ciclo completo, utilizar los sistemas de seguridad y aplicar las instrucciones de la explotación. El aprendizaje debe vincularse siempre con el manual del equipo concreto, la evaluación de riesgos, las disposiciones internas de seguridad y las condiciones reales del centro de trabajo.$n$ where id = '8b6b7b7a-076d-46ef-9911-1dbf23de0197';
update public.lesson_audio_segments set narration_text = $n$La especificación técnica distingue dos equipos. El volquete es una máquina autopropulsada, sobre ruedas o cadenas, con caja abierta, destinada a transportar y volcar o extender materiales cargados por medios externos. El camión es un vehículo autopropulsado sobre ruedas que transporta material dentro de las zonas previstas de la explotación y, cuando procede, también por carretera. Esta diferencia afecta al diseño, la capacidad, la velocidad, la circulación y las autorizaciones. Un volquete no debe tratarse como si fuera un turismo grande, y un camión de carretera no debe emplearse fuera de las condiciones para las que ha sido diseñado. Siempre prevalecen las limitaciones del fabricante y del centro.$n$ where id = '2850ccc1-c466-4686-aeea-774f1027c289';
update public.lesson_audio_segments set narration_text = $n$El movimiento de tierras integra arranque, carga, transporte y descarga; en determinados trabajos también incluye extendido, nivelación, compactación y refino. El transporte conecta el frente con la tolva, la escombrera, el acopio o el destino exterior, y suele representar una parte muy importante del coste y del tiempo del proceso. Sin embargo, la productividad no puede medirse solo por velocidad. Una pista deteriorada, una carga mal distribuida o una espera desordenada incrementan riesgos, consumo y averías. Por eso el operador debe comprender el proceso completo, anticipar cómo influyen las demás fases y comunicar cualquier condición que impida mantener un ciclo estable y seguro.$n$ where id = 'ba9629b9-b69d-4c4e-8476-47521a96d4ea';
update public.lesson_audio_segments set narration_text = $n$El ciclo habitual comprende posicionamiento, carga, transporte cargado, maniobra y descarga, retorno en vacío y nueva colocación. Cada fase cambia el comportamiento de la unidad: con carga aumentan la masa y la distancia de frenado; con la caja elevada cambia el centro de gravedad; y en vacío puede aumentar la tendencia a perder adherencia o a circular demasiado rápido. Las maniobras marcha atrás concentran además riesgos por zonas ciegas. Antes del primer ciclo deben definirse ruta, prioridades, punto de espera, procedimiento de carga, lugar de descarga y comunicaciones. Repetir el ciclo no elimina la necesidad de observar: el terreno, el tráfico y el material pueden cambiar en cualquier vuelta.$n$ where id = 'f1967bbc-e23b-402e-8ded-76f1d38f6eb6';
update public.lesson_audio_segments set narration_text = $n$Los volquetes rígidos disponen de un bastidor principal continuo y dirección mediante las ruedas delanteras. Los articulados se componen de bastidores unidos por una articulación, que permite dirigir y adaptarse mejor a terrenos irregulares. Esta movilidad crea una zona crítica de atrapamiento entre bastidores y exige colocar el bloqueo mecánico de articulación cuando se trabaja en ella. Ambos tipos presentan grandes masas, puntos ciegos y riesgo de vuelco, pero reaccionan de forma diferente en curvas, pendientes y descargas. El operador debe estar formado en el modelo asignado y conocer su transmisión, sus frenos, la dirección de emergencia, los límites de pendiente y las restricciones establecidas por el fabricante.$n$ where id = 'fa6b81d4-fb3b-41c5-86c7-f4a14acdea1c';
update public.lesson_audio_segments set narration_text = $n$El camión puede trabajar dentro de la explotación y, si cumple los requisitos aplicables, efectuar transporte exterior por carretera. Antes de salir deben revisarse la distribución y sujeción de la carga, el cierre o cubrición de la caja cuando proceda y la limpieza de elementos que puedan desprender barro o piedras. Dentro de la explotación se somete a la señalización, prioridades, velocidades y rutas definidas por las disposiciones internas. No debe recibir bloques o impactos que superen la resistencia de su caja, neumáticos o chasis. La decisión sobre qué material admite y dónde puede circular no corresponde a la improvisación del conductor, sino al diseño del equipo y al procedimiento del centro.$n$ where id = '5db85be3-2b9e-459f-be34-07c10d1a1e06';
update public.lesson_audio_segments set narration_text = $n$La unidad de transporte depende de una pala, excavadora u otro equipo que deposita el material en la caja. Ambos operadores forman un equipo y necesitan un método común: punto de espera, señal de entrada, posición de carga, número o criterio de pases y señal de salida. El conductor no abandona la cabina ni inicia un movimiento sin acuerdo, y el operador de carga no pasa el implemento sobre la cabina cuando puede evitarse. Si se pierde la comunicación, cambia la posición o aparece una persona dentro del área, el ciclo se detiene. La coordinación segura consiste en que cada participante pueda prever la maniobra del otro sin recurrir a suposiciones.$n$ where id = '8b6685fb-f78d-49c3-85f4-c18710029642';
update public.lesson_audio_segments set narration_text = $n$El operador realiza la inspección previa, las comprobaciones funcionales, la conducción, la carga pasiva, el transporte, la descarga, el estacionamiento y el mantenimiento básico que tenga asignado. También registra defectos, interpreta alarmas y comunica cambios del entorno. Estas responsabilidades no lo convierten en mecánico ni autorizan a anular protecciones, ajustar componentes o intervenir en sistemas presurizados sin competencia y procedimiento. Ante una anomalía que pueda afectar a frenos, dirección, neumáticos, estructura, caja o visibilidad, la obligación es inmovilizar de forma segura e informar. Continuar para terminar un viaje puede transformar un defecto controlable en una pérdida de control o un accidente grave.$n$ where id = 'c610fdf7-d1f6-4b95-b689-46bacff8fa72';
update public.lesson_audio_segments set narration_text = $n$Antes de iniciar la producción se debe conocer el origen y destino del material, la ruta autorizada, sentidos de circulación, pendientes, cruces, apartaderos, limitaciones de gálibo y zonas con personal. También se revisan los cambios del turno: obras, voladuras, lluvia, niebla, mantenimiento o modificaciones en la escombrera. La orden de trabajo debe ser clara y compatible con la capacidad de la máquina. Si la realidad no coincide con lo previsto, el operador se detiene en un lugar seguro y solicita instrucciones. Ninguna presión de producción justifica entrar en una pista cerrada, descargar sin acondicionamiento o utilizar un equipo diferente al autorizado.$n$ where id = '0971d355-8850-4c41-9fac-db5d10f34666';
update public.lesson_audio_segments set narration_text = $n$Un transporte eficaz mantiene un ritmo uniforme, reduce esperas y evita aceleraciones, frenadas o maniobras innecesarias. La velocidad excesiva rara vez mejora el resultado global: aumenta desgaste, consumo, derrames y probabilidad de accidente. El operador debe conducir con margen para reaccionar ante un obstáculo, un cambio de adherencia o un vehículo detenido. La decisión segura se apoya en tres preguntas: qué puede cambiar, qué consecuencias tendría y qué medida permite conservar el control. Cuando la respuesta no está clara, se reduce la exposición o se detiene la operación. Trabajar de forma previsible protege a las personas y, al mismo tiempo, mejora la continuidad del proceso.$n$ where id = 'a68b3ed9-764b-4e0b-a7d0-355ffca7332b';
update public.lesson_audio_segments set narration_text = $n$Antes de acercarse al equipo, el operador debe encontrarse en condiciones físicas y mentales adecuadas. La fatiga, el alcohol, las drogas o determinados medicamentos reducen la percepción y el tiempo de reacción. La ropa debe quedar ajustada, sin colgantes ni objetos que puedan engancharse. Casco, calzado de seguridad, alta visibilidad, guantes y las protecciones auditiva, ocular o respiratoria se seleccionan según la evaluación de riesgos. Los equipos individuales complementan, pero no sustituyen, una pista protegida, una cabina segura o una zona de trabajo delimitada. También se comprueba que los EPI estén en buen estado y que el operador conozca los medios de comunicación y emergencia.$n$ where id = 'cc6d75f0-1110-4200-b22e-df5384e8575f';
update public.lesson_audio_segments set narration_text = $n$La revisión previa se realiza siempre antes de poner en marcha la unidad, incluso si ha sido utilizada por otra persona durante el mismo turno. Se comienza por un punto fijo y se recorre todo el perímetro para no olvidar zonas. Desde el suelo se buscan personas, obstáculos, daños, piezas sueltas, acumulaciones, fugas y señales de incendio. Se comprueban escalones, pasamanos, cristales, espejos, cámaras, luces, avisadores, guardabarros y estado general de la caja. Mirar debajo permite detectar pérdidas recientes o elementos desplazados. Esta vuelta también confirma que nadie permanece en un punto ciego. Los defectos se anotan y se valoran antes del arranque, no después de iniciar el ciclo.$n$ where id = '70b27f66-5e9b-4176-a0c1-a2e5717d1168';
update public.lesson_audio_segments set narration_text = $n$Los neumáticos soportan la carga, transmiten frenado y dirección y absorben irregularidades. Se revisan cortes, abultamientos, desprendimientos, objetos incrustados, desgaste, presión aparente, llantas y fijaciones. En ruedas gemelas se observa si hay piedras atrapadas y si la separación es correcta. Un neumático de gran tamaño almacena mucha energía, por lo que su inflado, desmontaje o reparación corresponde a personal competente con medios adecuados. Nadie debe colocarse frente a una posible trayectoria de proyección ni golpear una llanta presurizada. Si existe daño estructural, calentamiento anormal o una fijación dudosa, la unidad se inmoviliza y se comunica; no se compensa conduciendo más despacio.$n$ where id = 'e3801998-e550-4107-922f-dcd94485e0ef';
update public.lesson_audio_segments set narration_text = $n$Los niveles de aceite, refrigerante, combustible, líquido hidráulico y otros fluidos se comprueban con la máquina situada como indica el fabricante. No se abre un circuito caliente o presurizado ni se busca una fuga hidráulica con la mano, porque el fluido puede penetrar la piel. Para repostar se apaga el motor, se evita toda fuente de ignición, se controla el derrame y se mantiene accesible el equipo contra incendios previsto. Las mangueras deben estar sin rozaduras, abultamientos ni racores flojos. Una mancha bajo el vehículo exige localizar su origen. Limpiar sin eliminar la causa no convierte la máquina en segura. Cualquier relleno o intervención se limita a las tareas autorizadas al operador.$n$ where id = '698deea2-b403-4eb5-af89-516188da08fe';
update public.lesson_audio_segments set narration_text = $n$El acceso se realiza mirando a la máquina y manteniendo tres puntos de apoyo, usando únicamente peldaños y asideros previstos. Se limpian barro, aceite o hielo y nunca se salta desde la cabina. La estructura ROPS protege frente al vuelco y la FOPS frente a caída de objetos cuando el equipo las incorpora; no deben taladrarse, soldarse ni modificarse sin autorización técnica del fabricante. Dentro se ajustan asiento, volante, espejos y mandos, se retiran objetos sueltos y se comprueba la salida de emergencia. El cinturón se abrocha antes de mover la unidad, porque mantiene al operador dentro del volumen protegido por la cabina durante una sacudida o vuelco.$n$ where id = 'f765da57-c487-48f5-8c8a-387b304cc7b3';
update public.lesson_audio_segments set narration_text = $n$Después del arranque y antes de incorporarse a producción se observa el autochequeo del panel y se comprueban freno de servicio, estacionamiento, dirección, bocina, alarma de retroceso, iluminación, limpiaparabrisas y cámaras. Cuando el fabricante lo contemple, también se verifica la dirección o frenado de emergencia mediante el procedimiento indicado. La prueba se hace a baja velocidad, en una zona despejada y sin comprometer a terceros. Se atiende a retardos, ruidos, vibraciones y testigos. Una alarma no se silencia ni se puentea para seguir trabajando. Si un sistema esencial no responde de manera normal, la unidad permanece fuera de servicio hasta que personal competente determine su aptitud.$n$ where id = 'cc03d21d-ff75-457d-bc62-d5de78ac958b';
update public.lesson_audio_segments set narration_text = $n$El operador solo realiza el mantenimiento básico asignado: limpieza, engrase o comprobaciones definidas por el manual y la empresa. Antes de intervenir se estaciona en terreno firme, se baja la caja, se coloca la transmisión en neutro, se aplica el freno y se detiene el motor. Cuando existen energías eléctrica, hidráulica, neumática, mecánica o térmica, se aplica bloqueo y consignación y se verifica que no queda energía peligrosa. Trabajar bajo una caja elevada exige el bloqueo mecánico diseñado para ese fin; nunca se confía únicamente en los cilindros. Las protecciones se reinstalan antes del arranque. Reparaciones, reglajes o soldaduras corresponden a personal autorizado y a procedimientos específicos.$n$ where id = '0a9d0c52-7e6e-4ff6-9341-9d8bceb56fbe';
update public.lesson_audio_segments set narration_text = $n$Combustible, aceite, polvo y restos acumulados sobre superficies calientes pueden iniciar un incendio. La inspección debe incluir compartimento motor, escape, batería, conexiones, zonas próximas a frenos y espacios donde se acumule material. Se mantienen limpios los accesos, la cabina y los elementos de visibilidad, sin usar productos incompatibles ni agua a presión sobre componentes sensibles. El extintor, si forma parte del equipo, debe estar accesible, señalizado y dentro de revisión. Ante olor a quemado, humo o temperatura anormal, se detiene la unidad en un lugar seguro, se para el motor, se avisa y se sigue el plan de emergencia. No se abre un compartimento caliente de forma que alimente el fuego con oxígeno.$n$ where id = '424bcb9e-dd0e-4151-923a-50f19400b522';
update public.lesson_audio_segments set narration_text = $n$El remolcado cambia radicalmente si funcionan o no el motor, la dirección y los frenos. No se improvisa con cables, cadenas o puntos de amarre no diseñados. Primero se consulta el manual, se estabiliza la unidad, se delimita la zona y se determina cómo liberar frenos o mantener dirección sin exponer a una persona. Los elementos de tiro deben tener capacidad suficiente y la zona de posible latigazo permanece vacía. Si la unidad carece de frenos, el método debe impedir que alcance al vehículo tractor. En pendientes o bordes se requiere un plan específico. Una sola persona dirige la maniobra y todos conocen las señales y el punto de parada.$n$ where id = 'c9432439-4192-4038-925c-d58a22c7cadc';
update public.lesson_audio_segments set narration_text = $n$El cambio de turno debe transmitir información útil: defectos observados, alarmas, trabajos pendientes, cambios de ruta, estado de la descarga y cualquier limitación temporal. La lista de comprobación permite registrar la inspección y evita depender de la memoria, pero no sustituye una observación real. El operador entrante confirma los puntos críticos por sí mismo. Los defectos se describen de forma concreta, indicando cuándo aparecen y qué sistema afectan; expresiones como funciona raro son insuficientes. La empresa define quién decide la inmovilización y cómo se etiqueta una máquina fuera de servicio. Nunca se oculta una anomalía por miedo a retrasar la producción: una comunicación temprana permite reparar antes de que el fallo sea mayor.$n$ where id = 'bc14eae9-d424-4357-9131-18bc3777a979';
update public.lesson_audio_segments set narration_text = $n$El motor se arranca desde el puesto del operador, con la transmisión en neutro, el freno aplicado y después de confirmar que el entorno está libre. No se puentea el arranque ni se pone en marcha desde el suelo. Durante el calentamiento se vigilan presión, temperatura, carga eléctrica y mensajes del panel, respetando el régimen y el tiempo indicados por el fabricante. Antes de moverse se abrocha el cinturón, se avisa y se comprueba de nuevo la trayectoria. Los gases de escape exigen ventilación suficiente. Si aparecen golpeteos, humo anormal, respuesta lenta o una alarma persistente, se detiene el proceso. El primer desplazamiento se realiza suavemente y sirve para confirmar dirección y frenado.$n$ where id = '43cfedd7-2df4-4cb4-b582-6dad717d63a8';
update public.lesson_audio_segments set narration_text = $n$La entrada al frente se hace solo cuando el equipo de carga autoriza y por la trayectoria establecida. El terreno debe ser firme, lo más horizontal posible y estar libre de bloques que dañen neumáticos o desestabilicen la unidad. Con pala cargadora, el volquete puede colocarse sesgado respecto al frente según el método aprobado, manteniendo la cabina alejada de la zona de caída. Con excavadora, se evita situarlo bajo un talud inestable o dentro de un radio de giro no controlado. Una vez colocado, se aplica el freno y se permanece en la cabina salvo procedimiento contrario. Si la posición no es segura, se sale y se repite la maniobra; nunca se corrige mientras recibe material.$n$ where id = '98cd6675-3507-4b18-a572-ab89cd7c7c1e';
update public.lesson_audio_segments set narration_text = $n$Durante la carga, la unidad permanece inmóvil y el conductor sigue las señales acordadas. El material se deposita de manera progresiva y uniforme, evitando impactos sobre la cabina, los laterales o un mismo punto de la caja. La carga nominal, el volumen útil y la distribución por ejes no deben superarse. Los bloques grandes, materiales adherentes o cargas con densidad variable requieren criterios específicos. Una carga descentrada modifica estabilidad, dirección y frenado; una sobrecarga somete neumáticos, suspensión y estructura a esfuerzos no previstos. Si el conductor detecta un golpe anormal, caída fuera de la caja o distribución peligrosa, comunica y no inicia el transporte hasta que se corrija de forma segura.$n$ where id = 'b99a8d57-ecbb-464a-8926-df92e751d7ab';
update public.lesson_audio_segments set narration_text = $n$En las pistas se respetan sentidos, prioridades, velocidad y separación definidos por la explotación. La distancia debe permitir detenerse aunque el vehículo precedente frene, pierda carga o quede inmovilizado. Se conduce con luces cuando esté establecido y se presta atención a peatones, vehículos ligeros, maquinaria lenta y zonas ciegas. No se adelanta salvo que el procedimiento lo permita, exista visibilidad y el otro operador conozca la maniobra. En cruces o estrechamientos se reduce la velocidad y se usa la comunicación acordada. Conducir mirando solo al vehículo anterior favorece errores en cadena: el operador debe observar también el firme, las bermas, señales, taludes y posibles rutas de escape.$n$ where id = '0e2f202f-4fe9-4f47-b708-5fad9127827b';
update public.lesson_audio_segments set narration_text = $n$Antes de entrar en una pendiente se selecciona la velocidad o marcha adecuada y se comprueba que puede mantenerse sin cambios bruscos. Nunca se desciende en neutro. El freno de servicio no debe utilizarse de forma continua hasta calentarlo; se emplean retarder, freno motor o sistemas auxiliares según el fabricante. La velocidad se decide antes del descenso, considerando carga, longitud, firme y tráfico. En subida se evita perder tracción con aceleraciones violentas. Si aparece una alarma de frenos o temperatura, se busca un punto seguro conforme al procedimiento, sin continuar hasta perder capacidad de detención. La experiencia con vehículos de carretera no sustituye las instrucciones específicas del volquete.$n$ where id = 'a3748da3-d7f0-4b4d-81bd-cc865f2f14ac';
update public.lesson_audio_segments set narration_text = $n$Las curvas se afrontan a velocidad reducida antes de girar, evitando frenar o cambiar de trayectoria bruscamente en su interior. La carga y la altura del centro de gravedad aumentan el riesgo de vuelco, especialmente con peralte incorrecto o arcén degradado. En barro, hielo, lluvia intensa, polvo o niebla disminuyen adherencia y visibilidad, por lo que se amplía la distancia, se reducen maniobras y se utilizan los medios de iluminación sin crear deslumbramiento. Baches, roderas, piedras o pérdida de berma se comunican para mantenimiento. Si no puede verse la distancia necesaria para detenerse, no basta con ir algo más despacio: puede ser necesario parar el transporte hasta recuperar condiciones seguras.$n$ where id = 'ced3f7eb-eba5-4d5d-9300-ac50149dbf66';
update public.lesson_audio_segments set narration_text = $n$La aproximación a una tolva se realiza lentamente, siguiendo señalización, semáforos, topes y comunicaciones. Los topes ayudan a posicionar, pero no deben utilizarse como freno ni garantizan por sí solos que el borde resista. Antes de retroceder se comprueba que no hay personas, material acumulado ni daños. La unidad se alinea, se inmoviliza según el fabricante y solo entonces se eleva la caja. Se observa la estabilidad durante todo el basculado. Si el material queda retenido, no se realizan aceleraciones, frenadas o balanceos no autorizados. La circulación se reanuda únicamente con la caja completamente bajada, el mando en la posición indicada y la señal de salida confirmada.$n$ where id = 'afba80b4-f974-4879-80aa-f01fb3eb07d3';
update public.lesson_audio_segments set narration_text = $n$En una escombrera, la resistencia del borde puede ser menor de lo que aparenta por grietas, agua, material recién vertido o asentamientos. La zona debe estar acondicionada y contar con el sistema de protección definido, como berma o descarga a distancia con posterior empuje. El operador no se aproxima más allá del punto autorizado ni confía en montículos sueltos como tope. Se retrocede recto, lentamente y con la unidad alineada; una caja elevada sobre terreno inclinado puede producir vuelco. Si el suelo cede, aparece una grieta o la unidad queda desnivelada, se interrumpe el basculado y se baja la caja cuando sea seguro siguiendo instrucciones. Nunca se descarga en una zona no habilitada.$n$ where id = 'bc7a6738-85cb-4001-8c4a-8628842fc310';
update public.lesson_audio_segments set narration_text = $n$El material húmedo o congelado puede adherirse a la caja y descargar de forma súbita, desplazar el centro de gravedad o impedir la bajada. Los sistemas calefactores, cuando existen, se usan según el fabricante y con sus protecciones. Está prohibido golpear, trepar o introducirse bajo una caja elevada sin inmovilización, aislamiento y bloqueo mecánico. Si la carga no sale, se baja la caja cuando sea posible, se traslada la unidad al área designada y se aplica un procedimiento de limpieza. El mando del basculante y la transmisión deben mantenerse en las posiciones previstas durante la descarga. Circular con la caja levantada expone a vuelco y a impactos con líneas o estructuras.$n$ where id = 'a3aee906-da7b-4b3d-93a0-d7ff7a7abe58';
update public.lesson_audio_segments set narration_text = $n$Para estacionar se elige terreno firme y lo más llano posible, se detiene la unidad, se coloca la transmisión en neutro, se aplica el freno y se baja completamente la caja. Si existe riesgo de movimiento se utilizan calzos según el procedimiento. Antes de parar el motor se respeta el tiempo de estabilización indicado por el fabricante, sin aplicar una cifra universal. Se retira o controla la llave y se baja con tres puntos de apoyo. Ante accidente se aplica PAS: proteger, avisar y socorrer sin crear nuevas víctimas. El operador debe conocer alarmas, rutas de evacuación, punto de reunión y forma de comunicar ubicación, equipo, material y peligros presentes.$n$ where id = '4a449c24-c158-4a91-ac4b-b4a2174f4d0f';
update public.lesson_audio_segments set narration_text = $n$El motor transforma la energía del combustible en movimiento y depende de sistemas de admisión, escape, lubricación y refrigeración. El operador no necesita desmontarlos, pero sí interpretar síntomas: pérdida de presión de aceite, aumento de temperatura, humo anormal, fugas o reducción de potencia. Continuar con una alarma crítica puede provocar incendio, gripaje o pérdida de control. Los radiadores y entradas de aire se mantienen limpios con el método previsto, evitando superficies calientes y partes móviles. Los tapones presurizados no se abren en caliente. El manual determina fluidos, intervalos y tiempos de espera. Mezclar productos o rellenar sin identificar la causa puede ocultar una avería y deteriorar el equipo.$n$ where id = '3db588fa-7236-406c-9ee0-96ab3f9c9779';
update public.lesson_audio_segments set narration_text = $n$La transmisión lleva la potencia del motor hasta las ruedas. Puede incorporar convertidor de par, caja de cambios, ejes, diferenciales y mandos finales, o soluciones eléctricas e hidrostáticas según el modelo. Su diseño condiciona cómo se seleccionan marchas, cómo actúa el retarder y qué ocurre al perder presión. El operador debe evitar cambios bruscos, inversiones de sentido con la unidad en movimiento y regímenes contrarios al manual. Testigos de temperatura, presión o fallo requieren la respuesta indicada por el fabricante. El bloqueo de transmisión impide movimientos inesperados durante determinadas operaciones, pero no sustituye el freno de estacionamiento ni el calzado cuando este sea necesario.$n$ where id = '96fd1dfc-24bf-4f59-969c-de5e4ff4c9d9';
update public.lesson_audio_segments set narration_text = $n$Los equipos pueden disponer de freno de servicio, freno de estacionamiento, freno de emergencia y sistemas auxiliares de retención. Cada uno tiene una función distinta. El de servicio controla la marcha normal; el de estacionamiento inmoviliza; el de emergencia actúa ante determinados fallos; y el retarder ayuda a mantener velocidad en descensos sin sobrecalentar el sistema principal. Antes del turno se prueban según el procedimiento. Una distancia de frenado creciente, tirones, baja presión o temperatura excesiva exige detener e informar. Nunca se desactiva una alarma ni se inicia un descenso confiando en que el freno de emergencia corregirá una conducción inadecuada.$n$ where id = '016bc360-46ba-4243-893d-d70726249d2b';
update public.lesson_audio_segments set narration_text = $n$En volquetes rígidos, la dirección actúa sobre las ruedas delanteras; en articulados, los cilindros modifican el ángulo entre bastidores. La articulación produce un área de atrapamiento que debe bloquearse mecánicamente antes de acceder. La dirección depende normalmente de presión hidráulica y algunos equipos incorporan dirección de emergencia para conservar control durante un tiempo limitado. Esta función no autoriza a continuar la producción: permite detenerse de forma segura siguiendo el manual. Holguras, respuesta lenta, vibraciones o fugas son señales de defecto. En maniobras cerradas se reduce la velocidad y se considera el barrido de la caja y de la parte posterior, no solo la trayectoria de la cabina.$n$ where id = '8e8019d5-3188-413f-bf72-ad67c80133b1';
update public.lesson_audio_segments set narration_text = $n$La caja se eleva mediante cilindros y un circuito hidráulico gobernado por posiciones como subir, mantener, flotante o bajar, cuya denominación varía según el fabricante. La operación modifica de forma importante el centro de gravedad. Solo se bascula con la unidad alineada, inmovilizada y sobre terreno apto. El riesgo más grave durante mantenimiento es la bajada imprevista; por eso se coloca el bloqueo mecánico previsto y se descarga la energía antes de entrar bajo la caja. Fugas, movimientos a tirones o falta de respuesta requieren inmovilización. El operador debe comprobar que la caja queda completamente apoyada antes de circular y que el mando retorna a la posición indicada.$n$ where id = '85f7aa79-6014-43e3-97f6-55f499227cc2';
update public.lesson_audio_segments set narration_text = $n$El bastidor transmite los esfuerzos entre carga, suspensión, ejes y articulación. Fisuras, deformaciones o reparaciones no autorizadas pueden reducir su resistencia. La suspensión mantiene contacto con el terreno y controla oscilaciones; una fuga o diferencia de altura altera estabilidad y reparto de carga. Los neumáticos deben corresponder a la aplicación, carga, velocidad y condiciones térmicas previstas. La combinación de sobrecarga, velocidad y temperatura puede provocar daños internos aunque el exterior parezca aceptable. El operador observa cambios de comportamiento, inclinación, vibraciones y desgaste irregular. Las decisiones sobre soldadura estructural, reglaje de suspensión o reparación de neumáticos corresponden a especialistas, no al mantenimiento cotidiano del conductor.$n$ where id = '4624b422-cec4-44ff-b563-321422763064';
update public.lesson_audio_segments set narration_text = $n$El sistema eléctrico alimenta arranque, control, iluminación, comunicaciones y alarmas. Las baterías pueden generar gases, ácido y corrientes capaces de producir quemaduras o incendios. Su desconexión, arranque auxiliar o carga se realiza con la secuencia y equipos definidos por el fabricante. Fusibles, cables o sensores no se puentean. El panel integra información sobre presión, temperatura, niveles, transmisión, frenos y carga; el significado de colores y niveles no es idéntico en todas las marcas. Por ello, el operador debe conocer el manual específico. Si aparece una alarma, se identifica el sistema, se adopta la respuesta prevista y se registra el hecho; reiniciar para borrar el aviso no elimina el problema.$n$ where id = 'acd7a4e7-9835-486e-8c5c-9a6de7e967cb';
update public.lesson_audio_segments set narration_text = $n$La cabina reúne puesto de conducción, mandos, cinturón, espejos, cámaras, climatización y estructuras de protección. Una buena visibilidad depende de cristales limpios, ajuste correcto y ausencia de objetos que obstruyan. Los sistemas de ayuda pueden tener zonas sin cobertura y no sustituyen la observación ni al señalista. ROPS y FOPS deben conservar sus fijaciones y no recibir modificaciones. El cinturón se usa siempre, porque evita que el ocupante sea expulsado o golpee el interior durante un vuelco. Puertas y salidas de emergencia deben poder abrirse. El ruido, las vibraciones y una postura deficiente también afectan a la atención; el asiento se regula y se respetan pausas y medidas ergonómicas.$n$ where id = '7deeffa3-f659-4eae-9662-58ff3a7cb6f3';
update public.lesson_audio_segments set narration_text = $n$Los bloqueos mecánicos de caja y articulación, los bloqueos de transmisión y mandos, los resguardos de correas y ventiladores y los interbloqueos reducen riesgos concretos. Cada elemento debe usarse para la operación para la que fue diseñado. Una protección retirada para mantenimiento se repone antes de arrancar. Bocina, luces, alarma de retroceso y señalización advierten, pero no crean un espacio seguro por sí solos. El operador confirma que las personas han salido del área y que la maniobra está controlada. Anular un interbloqueo para ganar tiempo elimina una barrera prevista frente a movimientos inesperados. Cualquier daño o falta de protección impide utilizar el equipo hasta su corrección o evaluación competente.$n$ where id = '3728c29c-e20f-4712-a377-fde14d8e1ed6';
update public.lesson_audio_segments set narration_text = $n$El manual de instrucciones define capacidades, cargas, pendientes, velocidades, presiones, fluidos, secuencias y advertencias del modelo. La formación general no puede sustituir esa información. Antes de utilizar una unidad distinta, incluso de la misma marca, el operador necesita familiarización con mandos, respuesta, dimensiones, zonas ciegas, alarmas y dispositivos de emergencia. Las tablas y placas deben ser legibles. Los accesorios o modificaciones pueden cambiar límites y requieren autorización. Si existe contradicción entre una costumbre y el manual, se aplica el procedimiento validado por la empresa con base técnica. Conocer el equipo significa también saber cuándo no debe emplearse y qué anomalías obligan a detenerlo.$n$ where id = 'bd159707-ab94-453c-9c26-938eb1e21b96';
update public.lesson_audio_segments set narration_text = $n$Manómetros, termómetros, indicadores de nivel, amperímetros, voltímetros y sistemas electrónicos muestran el estado de la máquina. Los paneles modernos agrupan avisos visuales y acústicos, pero sus niveles y respuestas varían. Antes del turno se comprueba el autodiagnóstico y se identifican los testigos críticos. Una alarma puede exigir cambiar la forma de trabajo, detenerse en un lugar seguro o parar inmediatamente; la decisión se toma según el manual, no por intuición. El indicador de carga ayuda a evitar sobrecarga, aunque no corrige una distribución deficiente. El operador debe observar tendencias: una temperatura que sube de forma repetida o una presión inestable puede anticipar un fallo aun sin alcanzar una alarma máxima.$n$ where id = '25e84625-4b39-47a0-b570-70fc45cf8cbc';
update public.lesson_audio_segments set narration_text = $n$La zona de carga debe ofrecer superficie resistente, espacio de maniobra, visibilidad y protección frente a desprendimientos. Se revisan talud, acopio, bloques sueltos, agua, barro y presencia de personas. El perímetro se controla mediante señalización, comunicaciones y reglas de acceso. La unidad de transporte entra solo con autorización del equipo de carga y espera en el punto definido. Ninguna persona se sitúa entre máquinas o bajo un implemento. Si cambia el frente, se sanea el terreno o se incorpora otro equipo, se revisa el método antes de continuar. El operador de transporte tiene derecho y obligación de rechazar una posición que comprometa cabina, neumáticos, estabilidad o ruta de salida.$n$ where id = 'c8a44fe6-1f8a-437e-b54c-3eefb81dc5fa';
update public.lesson_audio_segments set narration_text = $n$Una pista segura necesita anchura, firme, drenaje, visibilidad, bermas y señalización acordes con los equipos. El operador inspecciona durante la marcha y comunica baches, roderas, blandones, piedras, polvo, derrames o pérdida de protección. Cruces, curvas cerradas, cambios de rasante, estrechamientos y apartaderos son puntos especiales que requieren velocidad y prioridad definidas. No se circula fuera de la ruta para acortar camino ni se rebasa una barrera. Las pendientes admisibles dependen del diseño de la explotación y de la capacidad del equipo; no deben copiarse cifras generales sin comprobar el proyecto y las DIS. El mantenimiento de pistas es una medida preventiva colectiva y debe activarse antes de que el deterioro obligue a maniobras peligrosas.$n$ where id = '96aad74c-5700-45b7-a8e2-d84e4a32701f';
update public.lesson_audio_segments set narration_text = $n$En los puntos de descarga se comprueban iluminación, señalización, limpieza, resistencia del terreno, topes o bermas y ausencia de personas. Una tolva puede presentar huecos, material acumulado o estructuras dañadas. Una escombrera puede sufrir grietas, asientos o erosión por agua. Si falta una protección prevista, la descarga se suspende. Las zonas de estacionamiento deben permitir inmovilizar y separar unidades sin bloquear emergencias ni exponer a peatones. Talleres y áreas de repostaje requieren orden, control de derrames y rutas diferenciadas. La vigilancia no corresponde solo a supervisores: el operador que detecta un cambio es la primera barrera y debe comunicarlo antes de entrar en la zona.$n$ where id = 'd2e8ea79-d01e-4906-b647-b499dace10e6';
update public.lesson_audio_segments set narration_text = $n$Las comunicaciones pueden realizarse por radio, señales manuales, semáforos o medios acústicos definidos por la explotación. Deben ser breves, inequívocas y confirmadas cuando afecten a una maniobra de riesgo. Se identifica quién da la orden y se evita que varias personas dirijan a la vez. El señalista se coloca visible, fuera de la trayectoria y con una salida segura. Si el operador pierde contacto, detiene la unidad. La radio no sustituye mirar ni autoriza a circular sin visibilidad. Antes de retroceder se comprueba el área, se avisa y se espera respuesta cuando el procedimiento lo exija. Las palabras y canales de emergencia deben ser conocidos por todo el personal y mantenerse libres de conversaciones innecesarias.$n$ where id = '5218c538-50fc-40c0-b439-064304903267';
update public.lesson_audio_segments set narration_text = $n$En carga, descarga y circulación coinciden máquinas de gran tamaño, vehículos ligeros, mantenimiento y peatones. La prevención exige separar rutas, establecer prioridades y limitar accesos. Nadie se aproxima a un volquete sin comunicación y confirmación del operador. Los vehículos ligeros evitan permanecer en zonas ciegas y usan los puntos de espera. Durante una reparación en pista, se señaliza y protege la unidad antes de intervenir. Las maniobras simultáneas se coordinan para que un movimiento no invada el radio de otro equipo. El principio fundamental es no dar por visto a nadie: el contacto visual, la radio o la autorización deben confirmarse. Si aparece una interferencia no prevista, se detienen los movimientos hasta reorganizar el área.$n$ where id = '8376a191-a200-4219-85c8-9d85cbde5aba';
update public.lesson_audio_segments set narration_text = $n$Al atravesar una línea aérea o una estructura, la caja debe estar completamente bajada y la ruta debe disponer de señalización y gálibo autorizados. La documentación del curso utiliza avisos previos, pero las distancias de seguridad reales dependen de tensión, geometría, normativa y procedimiento del centro; no deben generalizarse sin evaluación. También se controlan tuberías, cintas, puentes y puertas. Si existe duda sobre altura o ruta, se detiene la unidad antes de entrar. Ante contacto eléctrico, el operador permanece en la cabina cuando sea seguro, evita tocar simultáneamente máquina y suelo, avisa y sigue el plan de emergencia. Nadie se aproxima hasta que personal competente confirme la ausencia de tensión.$n$ where id = '67ca6e37-93ed-4874-af6b-ffa9edf340b5';
update public.lesson_audio_segments set narration_text = $n$Cuando intervienen mantenimiento, contratas o varios equipos, la empresa debe coordinar riesgos, responsables, permisos y comunicaciones. Antes de reparar se inmoviliza, delimita y consigna la unidad; se identifica quién posee la llave o autorización de arranque. El operador entrega información sobre el defecto y no recupera la máquina hasta recibir confirmación. Una prueba funcional se realiza en zona controlada, con todas las protecciones colocadas. Las empresas concurrentes deben compartir las reglas de circulación, emergencias y acceso. La coordinación no consiste en intercambiar documentos sin más, sino en asegurar que quienes trabajan simultáneamente conocen las interferencias y las medidas aplicables. Si el alcance cambia, el permiso y el análisis deben actualizarse.$n$ where id = '7d2d06c1-618f-40b7-8254-df102c25a09c';
update public.lesson_audio_segments set narration_text = $n$El plan de emergencia define alarmas, responsables, vías de evacuación, punto de reunión, comunicaciones y medios disponibles. El operador debe saber cómo detener y asegurar la unidad sin bloquear el acceso de ayuda. Ante un accidente se aplica PAS: proteger el lugar, avisar con información precisa y socorrer solo dentro de la propia competencia. No se mueve a una persona lesionada salvo peligro inmediato, no se le da bebida si está inconsciente y se siguen las indicaciones del personal sanitario. En incendio, vuelco, pérdida de frenos o contacto eléctrico, la conducta puede variar; por eso se practican escenarios y se conoce la salida de emergencia de la cabina. Tras el incidente, el área permanece preservada según el procedimiento.$n$ where id = 'aa8fa388-06e5-473d-a032-a77c81872169';
update public.lesson_audio_segments set narration_text = $n$La formación se apoya en la Ley de Prevención de Riesgos Laborales, el Real Decreto 1215 sobre equipos de trabajo, el Real Decreto 1389 para actividades mineras, la ITC 02.1.02 y la Especificación Técnica 2000-1-08. A ellas se suman las instrucciones de trabajo y las disposiciones internas de seguridad, que concretan cómo se opera en cada centro. La formación inicial tiene una duración mínima de veinte horas. Para este puesto, la ET fija una frecuencia máxima obligatoria de dos años para recibir formación de actualización o reciclaje. La capacitación no elimina la obligación diaria de seguir el manual, comunicar defectos y adaptar el trabajo a las condiciones reales.$n$ where id = '7a113571-c6fe-4b82-85ed-1db2fbddd4a6';

-- Diapositivas: presentación propia de 20 h, página de contenido técnico de cada unidad.

update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.1/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '1', alt_text = 'Diapositiva 1.1: Objeto, alcance y duración de la formación' where id = '8c050689-0cce-4dc5-976b-1e6d6488e8e0';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.2/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '3', alt_text = 'Diapositiva 1.2: Qué es un volquete y qué es un camión' where id = 'cb92caa9-c371-48a1-8438-21e2cd502eef';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.3/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '5', alt_text = 'Diapositiva 1.3: El transporte dentro del movimiento de tierras' where id = '6b5dc7fb-b535-4928-9101-ad3f9dee54ba';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.4/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '7', alt_text = 'Diapositiva 1.4: Fases del ciclo de trabajo' where id = '66e32b20-0e10-474e-9532-1f1145052ba0';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.5/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '9', alt_text = 'Diapositiva 1.5: Volquetes rígidos y articulados' where id = '13a99a3e-3dad-4241-ab9e-65d3c3223f91';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.6/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '11', alt_text = 'Diapositiva 1.6: Camión de explotación y transporte exterior' where id = 'ece7e7fa-0cc6-4d17-9075-fecedc46960e';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.7/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '13', alt_text = 'Diapositiva 1.7: Coordinación con los equipos de carga' where id = 'eee84292-dcac-4a07-b44b-7049a938acd2';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.8/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '15', alt_text = 'Diapositiva 1.8: Tareas comunes y límites del operador' where id = '13c94c48-f10e-4275-a572-4103da1e6fd6';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.9/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '17', alt_text = 'Diapositiva 1.9: Planificación del recorrido y orden de trabajo' where id = '038817a9-c889-4ab6-a6e2-7ca48a6b4456';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/1.10/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '19', alt_text = 'Diapositiva 1.10: Productividad segura y toma de decisiones' where id = '4c93d629-32e7-4d06-9e73-4e6283db31d4';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.1/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '21', alt_text = 'Diapositiva 2.1: Preparación personal y equipos de protección' where id = 'e66709c7-25a1-4c54-850f-e61041d9151f';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.2/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '23', alt_text = 'Diapositiva 2.2: Inspección perimetral sistemática' where id = '30fd2df2-0a4c-4059-b567-095af942ac32';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.3/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '25', alt_text = 'Diapositiva 2.3: Neumáticos, llantas y elementos de rodadura' where id = '4e5beb91-ee7f-4b6e-b7bb-78790b71b8da';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.4/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '27', alt_text = 'Diapositiva 2.4: Niveles, fugas y repostaje' where id = '13fd6d0c-86b5-47e5-b9c3-18f34eda2311';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.5/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '29', alt_text = 'Diapositiva 2.5: Cabina, ROPS/FOPS y acceso seguro' where id = '5c8e3d6c-8780-4a72-9c19-0e8fa4030083';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.6/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '31', alt_text = 'Diapositiva 2.6: Comprobaciones funcionales y dispositivos de seguridad' where id = '7b17e312-1e48-4fe9-a7a3-1da2c5bd9d2a';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.7/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '33', alt_text = 'Diapositiva 2.7: Mantenimiento básico, aislamiento y consignación' where id = '6fe0040d-ccb0-4c56-a969-2da08e8151ef';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.8/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '35', alt_text = 'Diapositiva 2.8: Prevención de incendios y limpieza' where id = 'bb24e604-6c62-499d-bdfc-c156f181231c';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.9/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '37', alt_text = 'Diapositiva 2.9: Remolcado y recuperación de una unidad averiada' where id = '2c608d4d-a19b-42a9-af53-56544e4f39e4';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/2.10/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '39', alt_text = 'Diapositiva 2.10: Relevo, lista de comprobación y comunicación de defectos' where id = 'fc9faaad-916f-425b-806c-3e1cb52543b8';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.1/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '41', alt_text = 'Diapositiva 3.1: Arranque, calentamiento y puesta en movimiento' where id = '0270b345-cfbb-4bbc-98f0-da57df1eeaf2';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.2/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '43', alt_text = 'Diapositiva 3.2: Posicionamiento seguro en la zona de carga' where id = '23fae774-4927-4576-a47f-04a90a627862';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.3/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '45', alt_text = 'Diapositiva 3.3: Recepción y distribución de la carga' where id = '2b3ebe88-acba-4b9f-9d99-e6dbb405de90';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.4/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '47', alt_text = 'Diapositiva 3.4: Circulación por pistas y distancia de seguridad' where id = '7cec3d4f-9f98-44bc-96f6-540fa48856a1';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.5/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '49', alt_text = 'Diapositiva 3.5: Pendientes, selección de marcha y frenado' where id = '00cd8b65-df21-4fb3-8c30-7363de449c72';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.6/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '51', alt_text = 'Diapositiva 3.6: Curvas, cruces, firmes deficientes y meteorología' where id = 'afa50baf-0bbd-419a-be66-bad7474a2105';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.7/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '53', alt_text = 'Diapositiva 3.7: Descarga en tolvas' where id = 'f41af251-0e8f-497f-a351-ddbf3ccc7685';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.8/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '55', alt_text = 'Diapositiva 3.8: Descarga en escombreras y proximidad de bordes' where id = '5d05faae-cedf-4cad-9387-8da49f01b1d1';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.9/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '57', alt_text = 'Diapositiva 3.9: Material adherido, caja elevada y bloqueos' where id = '1b7cb841-9a22-4034-ae0a-793d73b032d0';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/3.10/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '59', alt_text = 'Diapositiva 3.10: Estacionamiento, abandono y actuación ante emergencia' where id = 'd2c1bc6a-a941-4539-bf03-5e862ac119c7';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.1/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '61', alt_text = 'Diapositiva 4.1: Motor, lubricación y refrigeración' where id = '8aa0c995-8a46-4661-8d83-88c86ad6d117';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.2/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '63', alt_text = 'Diapositiva 4.2: Transmisión y control de tracción' where id = '815f3fd9-9717-47c7-a2f7-2ef6223816b5';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.3/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '65', alt_text = 'Diapositiva 4.3: Frenos de servicio, estacionamiento, emergencia y retarder' where id = '2a753027-f564-45b2-b5d2-22550a1febc6';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.4/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '67', alt_text = 'Diapositiva 4.4: Dirección rígida, articulada y de emergencia' where id = 'fb6be951-cef2-49bf-a034-68451adddeca';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.5/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '69', alt_text = 'Diapositiva 4.5: Sistema hidráulico del basculante' where id = 'a9c4b4fc-3332-4d62-b5b3-208abbb3ca74';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.6/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '71', alt_text = 'Diapositiva 4.6: Bastidor, suspensión y neumáticos' where id = 'b58b4710-8e8f-4a9c-82a4-ee0a26655315';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.7/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '73', alt_text = 'Diapositiva 4.7: Sistema eléctrico, baterías e indicadores' where id = 'cfc101e1-2c2d-4a8e-b373-3ecc4145b63c';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.8/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '75', alt_text = 'Diapositiva 4.8: Cabina, visibilidad y protección del ocupante' where id = 'cb3a6aa8-f292-4c28-8672-fd9e2f268bf3';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.9/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '77', alt_text = 'Diapositiva 4.9: Bloqueos, resguardos y avisadores' where id = '189e18ab-6be9-47bd-b4de-4f4f4a42c91b';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/4.10/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '79', alt_text = 'Diapositiva 4.10: Manual, límites técnicos y familiarización' where id = 'd742bf11-ffbf-4a66-bafc-318746ad50ed';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.1/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '81', alt_text = 'Diapositiva 5.1: Panel de alarmas e instrumentos de control' where id = 'cd37772c-5d2a-46f0-b8d8-75a021a33a9f';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.2/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '83', alt_text = 'Diapositiva 5.2: Control de zonas de carga y frentes' where id = '6470f6d8-8dcc-4f66-b169-06f26c90563e';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.3/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '85', alt_text = 'Diapositiva 5.3: Control de pistas, accesos y puntos especiales' where id = '01517a8e-692b-4053-bc69-ba1f116c25a3';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.4/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '87', alt_text = 'Diapositiva 5.4: Control de tolvas, escombreras y zonas de estacionamiento' where id = '694162a4-6f0a-43a2-b3f8-5cbfcc704ada';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.5/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '89', alt_text = 'Diapositiva 5.5: Comunicaciones y maniobras dirigidas' where id = '507c20d5-cd54-41a7-9da7-ced120570c83';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.6/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '91', alt_text = 'Diapositiva 5.6: Interferencias con personas y otros equipos' where id = '7a30ff0c-cfd0-4f6a-843d-6f0f23488955';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.7/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '93', alt_text = 'Diapositiva 5.7: Líneas eléctricas, gálibos y estructuras' where id = '2c47b149-cd40-4677-9871-d2c29c619edc';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.8/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '95', alt_text = 'Diapositiva 5.8: Coordinación de reparaciones y actividades empresariales' where id = 'dc1ddff2-1dd6-4ee4-ad68-4d99dac16faf';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.9/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '97', alt_text = 'Diapositiva 5.9: Plan de emergencia, PAS y primera respuesta' where id = '1a874fb5-4838-4292-a575-c3ab49018de0';
update public.lesson_segment_slides set image_storage_path = '7abfcfd2-00a4-496d-acc0-d56fc3274ee2/slides/transporte-20h-2026/5.10/slide-01.png', image_external_url = null, source_label = 'Presentación completa · Transporte · Formación inicial 20 h', source_page = '99', alt_text = 'Diapositiva 5.10: Marco normativo, DIS y frecuencia de actualización' where id = '6df35eb9-9c70-44b8-8b15-0d8015fdcf4a';

do $val$
declare
  version_id constant uuid := '7abfcfd2-00a4-496d-acc0-d56fc3274ee2';
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
    raise exception 'La modalidad de 20 h debe tener 50 diapositivas en los bloques 1 a 5 y tiene %', total;
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
       or s.body like '%EXPLICACIÓN DETALLADA%'
       or s.body like '%APLICACIÓN EN LA EXPLOTACIÓN%'
     );
  if fallos > 0 then
    raise exception '% diapositivas de 20 h conservan el cuerpo antiguo o carecen de idea clave', fallos;
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
       s.image_storage_path is distinct from
         version_id::text || '/slides/transporte-20h-2026/' || m.position || '.' || seg.position || '/slide-01.png'
       or s.source_page is distinct from (2 * ((m.position - 1) * 10 + seg.position) - 1)::text
     );
  if fallos > 0 then
    raise exception '% diapositivas de 20 h no apuntan a su propia presentación de 100 páginas', fallos;
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
       or seg.narration_text like '%Aplicación práctica: Relaciona el recorrido real del material%'
       or length(seg.narration_text) < 600
     );
  if fallos > 0 then
    raise exception '% locuciones de 20 h conservan la transcripción del guion antiguo', fallos;
  end if;
end;
$val$;

commit;
