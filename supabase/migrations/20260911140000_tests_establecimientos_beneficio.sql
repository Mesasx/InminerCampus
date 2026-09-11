-- Tests del curso «Operadores en establecimientos de beneficio», a partir del
-- banco de preguntas aportado y validado.
--
-- El libro entregado trae 15 preguntas por bloque para la formación inicial de
-- 20 h y 10 por bloque para el reciclaje de 5 h, cinco bloques en cada
-- modalidad. Cada pregunta declara ya su unidad de origen, de modo que aquí se
-- enlaza con la unidad correspondiente del curso: así, cuando un intento no es
-- perfecto, el alumno recibe las partes que conviene repasar.
--
-- El enunciado, las cuatro opciones, la respuesta marcada y la justificación se
-- vuelcan tal cual vienen en el libro. No se reescribe ni se reordena nada. Las
-- columnas de procedencia documental del libro no se cargan: son referencias
-- editoriales y no deben llegar al alumno.
--
-- La versión de 20 h sigue en borrador mientras faltan locuciones, así que sus
-- bloques 3, 4 y 5 no tienen todavía unidades publicadas. Sus preguntas se
-- cargan igualmente y quedan sin enlazar a unidad; el enlace sólo alimenta la
-- lista de partes a repasar.
--
-- Es una migración aditiva: si un bloque ya tuviera test, se deja intacto y no
-- se toca. No se borra ninguna pregunta, banco ni matrícula existente.
begin;

create temporary table _eb_preguntas (
  externo text primary key,
  duracion integer not null,
  bloque smallint not null,
  orden smallint not null,
  codigo text not null,
  enunciado text not null,
  opcion_a text not null,
  opcion_b text not null,
  opcion_c text not null,
  opcion_d text not null,
  correcta text not null,
  justificacion text not null
) on commit drop;

insert into _eb_preguntas (
  externo, duracion, bloque, orden, codigo, enunciado,
  opcion_a, opcion_b, opcion_c, opcion_d, correcta, justificacion
) values
  ('EB-20H-B1-Q01', 20, 1, 1, '1.1', '¿Qué es un establecimiento de beneficio?', 'Una zona dedicada únicamente al almacenamiento de mineral', 'Un conjunto de instalaciones donde el material minero se prepara, transforma, clasifica, concentra o acondiciona para obtener un producto comercializable', 'Un taller exclusivo de mantenimiento', 'Una oficina de control administrativo', 'B', 'La diapositiva y el manual definen el establecimiento de beneficio como un conjunto de instalaciones de preparación y transformación del material minero.'),
  ('EB-20H-B1-Q02', 20, 1, 2, '1.1', '¿Qué formas de energía se citan en un establecimiento de beneficio?', 'Mecánica, eléctrica, hidráulica, neumática, térmica y, en determinados procesos, química', 'Solo energía mecánica', 'Únicamente electricidad y calor', 'Exclusivamente energía química', 'A', 'La diapositiva 1 y el manual enumeran esas formas de energía presentes en las instalaciones.'),
  ('EB-20H-B1-Q03', 20, 1, 3, '1.2', '¿Qué puesto del grupo 5.4 figura en la ITC 02.1.02 pero no está incluido en la ET 2004-1-10?', 'Operadores de trituración y clasificación', 'Operadores de laboratorio', 'Operadores de moldeo y/o sinterización', 'Operadores de mantenimiento mecánico y eléctrico', 'C', 'La presentación y el manual señalan expresamente que el puesto i), moldeo o sinterización, queda fuera del ámbito de la ET 2004-1-10.'),
  ('EB-20H-B1-Q04', 20, 1, 4, '1.3', '¿Por qué es importante conocer el flujo completo del proceso mineral?', 'Porque todos los equipos tienen exactamente los mismos riesgos', 'Porque un riesgo o una desviación en una etapa puede propagarse a etapas adyacentes', 'Porque elimina la necesidad de consignar equipos', 'Porque permite omitir la supervisión local', 'B', 'El mensaje clave de la diapositiva y el desarrollo del manual explican que los efectos de una etapa pueden propagarse aguas arriba o aguas abajo.'),
  ('EB-20H-B1-Q05', 20, 1, 5, '1.3', '¿Cuál de estas etapas forma parte del flujo general representado en el curso?', 'Molienda', 'Contabilidad', 'Publicidad', 'Selección de personal', 'A', 'El flujo visual de la diapositiva y el manual incluyen la molienda como etapa del proceso mineral.'),
  ('EB-20H-B1-Q06', 20, 1, 6, '1.4', '¿Cuáles son riesgos principales en la recepción, tolvas y alimentación de material?', 'Únicamente ruido y vibraciones', 'Atropello, caída a tolva, sepultamiento y atrapamiento', 'Solo exposición química', 'Solo quemaduras', 'B', 'La diapositiva enumera estos cuatro riesgos y el manual los desarrolla al describir descarga, material inestable y órganos de alimentación.'),
  ('EB-20H-B1-Q07', 20, 1, 7, '1.5', '¿Qué riesgos principales aparecen en trituración y clasificación?', 'Atrapamiento, proyección de fragmentos, ruido, polvo respirable y arranque inesperado', 'Solo cortes manuales', 'Únicamente estrés térmico', 'Exclusivamente contacto químico', 'A', 'La diapositiva y el manual relacionan trituración y cribado con atrapamientos, proyecciones, ruido, polvo y rearranques.'),
  ('EB-20H-B1-Q08', 20, 1, 8, '1.5', '¿Qué protecciones se consideran críticas en trituración y clasificación?', 'Resguardos, enclavamientos y paradas de emergencia', 'Solo carteles informativos', 'Únicamente guantes', 'Solo iluminación', 'A', 'La diapositiva y el manual identifican resguardos, enclavamientos y paradas de emergencia como protecciones críticas.'),
  ('EB-20H-B1-Q09', 20, 1, 9, '1.6', 'Antes de intervenir en un molino, ¿qué debe verificarse?', 'Que la producción esté al máximo', 'Que exista cero energía tras la consignación', 'Que se haya retirado la señalización', 'Que el motor esté caliente', 'B', 'Tanto la diapositiva como el manual insisten en la consignación y verificación de ausencia de energía antes de intervenir.'),
  ('EB-20H-B1-Q10', 20, 1, 10, '1.7', '¿Cuál es el principal riesgo del estrío manual junto a cintas transportadoras?', 'La proximidad de manos o herramientas a elementos móviles y puntos de atrapamiento', 'La combustión del material', 'La presión hidráulica del puesto', 'La radiación térmica', 'A', 'La diapositiva y el manual destacan el atrapamiento junto a cintas, rodillos y otros órganos móviles.'),
  ('EB-20H-B1-Q11', 20, 1, 11, '1.7', '¿Qué factores ergonómicos se citan en el estrío?', 'Altura de trabajo, alcance, ritmo y pausas', 'Solo temperatura del mineral', 'Solo velocidad del vehículo', 'Únicamente presión hidráulica', 'A', 'La diapositiva y el manual relacionan estos factores con fatiga y riesgo de error.'),
  ('EB-20H-B1-Q12', 20, 1, 12, '1.8', 'Cuando se emplean sustancias en separación y concentración, ¿qué documento debe conocerse?', 'La nómina del trabajador', 'La ficha de datos de seguridad', 'El parte meteorológico', 'El albarán de expedición', 'B', 'La presentación exige conocer las FDS y el manual desarrolla su uso para peligros, compatibilidad, EPI y derrames.'),
  ('EB-20H-B1-Q13', 20, 1, 13, '1.9', '¿Qué debe hacerse antes de abrir o entrar en un mezclador?', 'Aumentar la velocidad de giro', 'Consignar el equipo', 'Retirar todas las alarmas', 'Mantener la alimentación activa', 'B', 'La diapositiva y el manual señalan que las palas, ejes y transmisiones de alta energía requieren consignación antes del acceso.'),
  ('EB-20H-B1-Q14', 20, 1, 14, '1.9', '¿Qué variables son críticas en el funcionamiento de hornos?', 'Temperatura, combustión, ventilación y aislamiento térmico', 'Solo velocidad de cinta', 'Únicamente humedad ambiental', 'Solo nivel de tolva', 'A', 'La diapositiva y el manual destacan esas variables en los procesos térmicos.'),
  ('EB-20H-B1-Q15', 20, 1, 15, '1.10', '¿Qué riesgo se destaca en roca ornamental por la manipulación de piezas pesadas?', 'Vuelco de bloques o tablas', 'Únicamente ruido de oficina', 'Solo exposición biológica', 'Exceso de iluminación', 'A', 'La presentación y el manual identifican la estabilidad y el vuelco de bloques o tablas como riesgos relevantes.'),
  ('EB-20H-B2-Q01', 20, 2, 1, '2.1', 'Antes de comenzar el turno, ¿qué debe revisarse en el lugar de trabajo?', 'Accesos, pasarelas, escaleras, plataformas, orden, iluminación, señalización y derrames', 'Solo el reloj de fichaje', 'Únicamente el nivel de producción', 'Solo la documentación administrativa', 'A', 'La diapositiva enumera estos elementos y el manual explica que la revisión previa es la primera barrera preventiva.'),
  ('EB-20H-B2-Q02', 20, 2, 2, '2.1', '¿Qué debe verificarse respecto a protecciones colectivas antes de comenzar?', 'Que barandillas, huecos y resguardos retirados durante mantenimiento hayan sido restituidos', 'Que todas las protecciones hayan sido retiradas', 'Que las barandillas se usen como puntos de anclaje', 'Que los accesos estén cerrados', 'A', 'La diapositiva y el manual exigen verificar la restitución de protecciones antes del arranque.'),
  ('EB-20H-B2-Q03', 20, 2, 3, '2.2', 'Si el operador detecta una deficiencia que compromete la seguridad, ¿qué debe hacer?', 'Repararla aunque no esté autorizado', 'Detectarla, comunicarla y evitar el uso del equipo', 'Ocultarla hasta el final del turno', 'Puentear la protección para comprobar si funciona', 'B', 'La diapositiva y el manual fijan el límite de competencia del operador: detectar, comunicar y retirar o evitar el uso cuando proceda.'),
  ('EB-20H-B2-Q04', 20, 2, 4, '2.3', '¿Cuál es la secuencia preventiva indicada para una operación básica de mantenimiento?', 'Mantener, arrancar, revisar y aislar', 'Parar, aislar, verificar, mantener y restituir', 'Limpiar, abrir, probar y arrancar', 'Acelerar, reparar, verificar y cerrar', 'B', 'La diapositiva muestra expresamente la secuencia Parar → Aislar → Verificar → Mantener → Restituir, desarrollada en el manual.'),
  ('EB-20H-B2-Q05', 20, 2, 5, '2.3', '¿Cuándo debe derivarse una operación básica de mantenimiento a personal autorizado?', 'Cuando requiere desmontaje, acceso a zona peligrosa o conocimientos especializados', 'Siempre que haya que limpiar una plataforma', 'Solo cuando el turno está terminando', 'Nunca', 'A', 'La diapositiva y el manual marcan este límite de competencia.'),
  ('EB-20H-B2-Q06', 20, 2, 6, '2.4', '¿Cuál es un acceso correcto a un puesto o punto de mantenimiento?', 'Subir por la estructura de una cinta', 'Usar tambores o rodillos como apoyo', 'Utilizar una escalera fija o pasarela autorizada', 'Trepar por tuberías', 'C', 'La presentación y el manual exigen utilizar medios diseñados para el acceso, como escaleras y pasarelas autorizadas.'),
  ('EB-20H-B2-Q07', 20, 2, 7, '2.5', '¿Qué debe hacerse para aislar una instalación hidráulica antes de intervenir?', 'Cerrar una válvula y despresurizar', 'Buscar la fuga con la mano', 'Aumentar la presión', 'Abrir todos los racores', 'A', 'La diapositiva indica válvula más despresurización y el manual desarrolla el control de presión residual.'),
  ('EB-20H-B2-Q08', 20, 2, 8, '2.5', '¿Qué regla crítica se establece al buscar fugas en instalaciones a presión?', 'Nunca buscarlas con la mano', 'Comprobarlas tocando la manguera', 'Aumentar presión para localizarlas', 'Abrir el racor más cercano', 'A', 'La diapositiva y el manual lo indican expresamente por el riesgo de proyección o inyección.'),
  ('EB-20H-B2-Q09', 20, 2, 9, '2.6', '¿Cuál es la secuencia correcta de puesta en marcha mostrada en el curso?', 'Arrancar, avisar, verificar y confirmar', 'Verificar equipo, activar avisos, confirmar la zona y arrancar', 'Alimentar, arrancar y después revisar', 'Avisar únicamente después de arrancar', 'B', 'La diapositiva presenta esos cuatro pasos y el manual explica la puesta en marcha como transición controlada.'),
  ('EB-20H-B2-Q10', 20, 2, 10, '2.7', '¿Qué variables pueden vigilarse durante el funcionamiento?', 'Presión, temperatura, nivel, caudal, vibraciones, ruido, intensidad y alarmas', 'Solo el nombre del operador', 'Únicamente el número de pedidos', 'Solo el color exterior del equipo', 'A', 'La diapositiva y el manual enumeran variables de proceso e indicadores para detectar tendencias y desviaciones.'),
  ('EB-20H-B2-Q11', 20, 2, 11, '2.7', '¿Qué debe hacerse con una incidencia o alarma recurrente?', 'Registrarla y comunicarla para investigar la causa', 'Ignorarla por habitual', 'Silenciarla siempre', 'Aumentar la carga', 'A', 'La diapositiva y el manual rechazan normalizar desviaciones y piden registrar incidencias recurrentes.'),
  ('EB-20H-B2-Q12', 20, 2, 12, '2.8', '¿Qué estado permite intervenir tras aislar completamente y verificar cero energía?', 'Parada normal', 'Parada de emergencia', 'Consignación', 'Modo automático', 'C', 'La diapositiva diferencia parada normal, emergencia y consignación; el manual refuerza que solo la consignación prepara una intervención.'),
  ('EB-20H-B2-Q13', 20, 2, 13, '2.9', 'Ante un atasco, ¿cuál es la primera acción de la secuencia segura?', 'Introducir una barra', 'Detener la alimentación', 'Retirar protecciones', 'Golpear el equipo', 'B', 'La diapositiva y el manual inician la secuencia de desatasco cortando la aportación de material.'),
  ('EB-20H-B2-Q14', 20, 2, 14, '2.9', 'Si el atasco supera las competencias del operador, ¿qué debe hacerse?', 'Escalar la intervención a mantenimiento', 'Introducir una barra más larga', 'Pedir a otro operador que improvise', 'Continuar sin consignar', 'A', 'La diapositiva y el manual indican que debe intervenir personal competente cuando el atasco excede el alcance del operador.'),
  ('EB-20H-B2-Q15', 20, 2, 15, '2.10', '¿Qué conducta resume la actuación inicial en primeros auxilios?', 'Proteger, Alertar y Socorrer', 'Producir, Ajustar y Supervisar', 'Parar, Abrir y Señalizar', 'Prever, Acelerar y Salir', 'A', 'El mensaje clave de la diapositiva y el manual utilizan la conducta PAS: Proteger → Alertar → Socorrer.'),
  ('EB-20H-B3-Q01', 20, 3, 1, '3.1', 'Conocer técnicamente un equipo significa principalmente:', 'Saber repararlo por completo', 'Entender su función, sus límites, sus protecciones y sus riesgos residuales', 'Poder modificar sus sensores', 'Trabajar sin consultar procedimientos', 'B', 'La diapositiva y el manual distinguen conocer el equipo de saber repararlo, y centran el conocimiento en función, límites y protecciones.'),
  ('EB-20H-B3-Q02', 20, 3, 2, '3.1', '¿Qué puede ocurrir si se modifica de forma improvisada una cinta, un sensor o un enclavamiento?', 'Puede afectar a otros equipos interconectados', 'No ocurre nada fuera del equipo modificado', 'Se eliminan todos los riesgos', 'La modificación queda automáticamente autorizada', 'A', 'La diapositiva y el manual explican que los sistemas interconectados pueden verse afectados por cambios locales.'),
  ('EB-20H-B3-Q03', 20, 3, 3, '3.2', '¿Un enclavamiento sustituye a la consignación para mantenimiento?', 'Sí, siempre', 'No, tienen funciones diferentes', 'Solo en trituradoras', 'Solo si hay una parada de emergencia', 'B', 'La diapositiva y el manual explican que el enclavamiento impide determinadas maniobras, pero no garantiza aislamiento ni cero energía.'),
  ('EB-20H-B3-Q04', 20, 3, 4, '3.3', '¿Qué peligro concentran especialmente las cintas transportadoras?', 'Numerosos puntos de atrapamiento', 'Únicamente radiación térmica', 'Solo riesgo químico', 'Exclusivamente riesgo biológico', 'A', 'El mensaje clave de la diapositiva y el manual identifican múltiples puntos de atrapamiento en cintas y transferencias.'),
  ('EB-20H-B3-Q05', 20, 3, 5, '3.3', '¿Qué debe hacerse antes de intervenir en una cinta transportadora con riesgo de atrapamiento?', 'Aplicar consignación', 'Aumentar la velocidad', 'Retirar los resguardos en marcha', 'Usar solo guantes', 'A', 'El mensaje clave de la diapositiva y el manual vinculan la intervención segura con la consignación previa.'),
  ('EB-20H-B3-Q06', 20, 3, 6, '3.4', 'Antes de abrir una línea con fluido, ¿qué debe verificarse?', 'Solo que el manómetro marque cero', 'Aislamiento, vaciado y despresurización', 'Que la bomba siga funcionando', 'Que el tanque esté lleno', 'B', 'La diapositiva y el manual indican que no basta con el manómetro: deben aislarse, vaciarse y despresurizarse los circuitos.'),
  ('EB-20H-B3-Q07', 20, 3, 7, '3.5', '¿Qué papel tiene el EPI térmico en hornos y equipos térmicos?', 'Sustituye las distancias de seguridad', 'Es una medida complementaria y no sustituye el diseño seguro', 'Elimina el riesgo de incendio', 'Permite anular controles de temperatura', 'B', 'La diapositiva y el manual remarcan que el EPI térmico complementa, pero no reemplaza, medidas técnicas y distancias.'),
  ('EB-20H-B3-Q08', 20, 3, 8, '3.5', '¿Qué variables críticas deben mantenerse dentro de rango en hornos y equipos térmicos?', 'Temperatura, combustión, ventilación, presión y alarmas', 'Solo velocidad de cinta', 'Únicamente nivel de aceite', 'Solo humedad ambiental', 'A', 'La diapositiva y el manual enumeran estas variables como primera barrera preventiva.'),
  ('EB-20H-B3-Q09', 20, 3, 9, '3.6', 'En una planta de materiales para la construcción, ¿qué riesgo se identifica en los silos?', 'Sepultamiento y caída', 'Únicamente ruido', 'Solo riesgo eléctrico', 'Exclusivamente cortes manuales', 'A', 'El diagrama de la diapositiva identifica en los silos riesgo de sepultamiento y caída, y el manual desarrolla estos peligros.'),
  ('EB-20H-B3-Q10', 20, 3, 10, '3.7', '¿Qué regla debe cumplirse respecto a las cargas suspendidas en roca ornamental?', 'Permanecer debajo para controlar el movimiento', 'Nunca permanecer bajo cargas suspendidas', 'Sujetar la carga con la mano', 'Pasar por debajo si la maniobra es breve', 'B', 'La diapositiva y el manual establecen expresamente que nadie debe permanecer bajo cargas suspendidas.'),
  ('EB-20H-B3-Q11', 20, 3, 11, '3.7', '¿Qué debe comprobarse en los accesorios de elevación de roca ornamental?', 'Capacidad y estado antes de cada uso', 'Solo el color', 'Únicamente la marca', 'Nada si ya se usaron el día anterior', 'A', 'La diapositiva y el manual indican seleccionar por capacidad y estado e inspeccionar antes de usar.'),
  ('EB-20H-B3-Q12', 20, 3, 12, '3.8', 'Antes de manipular reactivos en laboratorio, ¿qué debe consultarse?', 'La ficha de datos de seguridad', 'El registro de visitas', 'El parte de producción', 'La orden de expedición', 'A', 'La diapositiva y el manual exigen revisar la FDS para conocer peligros, compatibilidad, EPI y respuesta ante incidentes.'),
  ('EB-20H-B3-Q13', 20, 3, 13, '3.9', '¿Es suficiente bloquear solo el interruptor principal para realizar mantenimiento?', 'Sí, siempre', 'No, deben identificarse y controlarse todas las fuentes de energía', 'Solo si el equipo es pequeño', 'Sí, si no hay ruido', 'B', 'La diapositiva y el manual insisten en la consignación multienergía: eléctrica, mecánica, gravitatoria, hidráulica, neumática y térmica.'),
  ('EB-20H-B3-Q14', 20, 3, 14, '3.9', '¿Cómo debe aislarse una fuente hidráulica durante mantenimiento?', 'Mediante válvula y despresurización', 'Solo con el interruptor general', 'Aumentando la presión', 'Dejando el circuito cargado', 'A', 'La tabla de la diapositiva y el manual asocian la energía hidráulica con válvula y despresurización.'),
  ('EB-20H-B3-Q15', 20, 3, 15, '3.10', '¿Qué afirmación es correcta sobre los sistemas de seguridad?', 'Eliminan todos los peligros', 'Son una capa de protección, pero pueden quedar riesgos residuales', 'Permiten trabajar fuera de los límites del equipo', 'Hacen innecesaria la formación', 'B', 'El mensaje clave de la diapositiva y el manual explica que las protecciones reducen riesgo, pero no eliminan todos los peligros.'),
  ('EB-20H-B4-Q01', 20, 4, 1, '4.1', '¿Qué debe hacer el trabajador si una lectura de un instrumento es incoherente con el comportamiento real del proceso?', 'Ignorarla', 'Investigarla y no confiar en una única lectura', 'Modificar el instrumento por su cuenta', 'Continuar hasta que aparezca una alarma', 'B', 'La diapositiva y el manual advierten que un instrumento defectuoso puede ocultar una condición peligrosa.'),
  ('EB-20H-B4-Q02', 20, 4, 2, '4.1', '¿Qué función preventiva tiene un manómetro según la diapositiva?', 'Detectar sobrepresión en circuitos', 'Medir únicamente el ruido', 'Detectar caída de objetos', 'Controlar la iluminación', 'A', 'La tabla de la diapositiva y el manual asignan al manómetro la detección de condiciones de presión.'),
  ('EB-20H-B4-Q03', 20, 4, 3, '4.2', '¿Cuál es la secuencia básica asociada a la gestión de alarmas?', 'Detectar, interpretar, actuar y registrar', 'Silenciar, olvidar y continuar', 'Arrancar, producir y cerrar', 'Desactivar, puentear y resetear', 'A', 'La diapositiva presenta expresamente Detectar → Interpretar → Actuar → Registrar, desarrollada después en el manual.'),
  ('EB-20H-B4-Q04', 20, 4, 4, '4.3', '¿Qué deben hacer las Disposiciones Internas de Seguridad?', 'Sustituir toda la legislación', 'Concretar reglas del centro y ser coherentes con la evaluación de riesgos', 'Eliminar los procedimientos', 'Aplicarse solo a contratistas', 'B', 'La diapositiva y el manual indican que las DIS concretan las reglas propias del centro y deben mantenerse actualizadas.'),
  ('EB-20H-B4-Q05', 20, 4, 5, '4.3', '¿Qué debe hacerse con los procedimientos internos cuando se producen cambios?', 'Actualizarlos', 'Ignorarlos', 'Sustituirlos por instrucciones verbales permanentes', 'Mantenerlos siempre sin revisión', 'A', 'La diapositiva y el manual señalan que los procedimientos deben mantenerse actualizados tras cambios relevantes.'),
  ('EB-20H-B4-Q06', 20, 4, 6, '4.4', '¿Qué principio preventivo se aplica al polvo, ruido y vibraciones?', 'El EPI sustituye los controles técnicos', 'La jerarquía de medidas empieza actuando en el origen', 'La única medida válida es limitar el tiempo', 'No es necesario controlar el polvo acumulado', 'B', 'La diapositiva y el manual priorizan eliminación/sustitución y controles de ingeniería antes de depender del EPI.'),
  ('EB-20H-B4-Q07', 20, 4, 7, '4.5', '¿Por qué son importantes el orden y la limpieza?', 'Solo por imagen de la planta', 'Porque actúan como barrera frente a caídas, obstrucciones y riesgos de incendio', 'Solo para facilitar auditorías', 'Porque sustituyen la señalización', 'B', 'La diapositiva y el manual presentan orden y limpieza como medidas preventivas permanentes.'),
  ('EB-20H-B4-Q08', 20, 4, 8, '4.5', '¿Qué práctica debe evitarse para limpiar polvo?', 'Usar aire comprimido para dispersarlo', 'Planificar la limpieza', 'Mantener libres las rutas', 'Señalizar derrames', 'A', 'La diapositiva y el manual advierten que el aire comprimido genera una nube inhalable.'),
  ('EB-20H-B4-Q09', 20, 4, 9, '4.6', '¿Qué puede ocurrir cuando dos tareas seguras por separado coinciden sin coordinación?', 'Siempre siguen siendo seguras', 'Pueden generar un riesgo grave por interferencia', 'Se anulan automáticamente sus riesgos', 'Solo aumenta el tiempo de trabajo', 'B', 'El mensaje clave de la diapositiva y el manual explica que la simultaneidad puede crear nuevos riesgos.'),
  ('EB-20H-B4-Q10', 20, 4, 10, '4.7', '¿Qué protocolo de comunicación cerrada se muestra para maniobras críticas?', 'Orden → Repetición → Confirmación', 'Orden → Silencio → Arranque', 'Aviso → Producción → Archivo', 'Señal → Espera → Olvido', 'A', 'La diapositiva muestra el esquema de orden, repetición y confirmación y el manual lo desarrolla para evitar ambigüedades.'),
  ('EB-20H-B4-Q11', 20, 4, 11, '4.7', '¿Qué información debe transferirse en un cambio de turno?', 'Equipos fuera de servicio, consignaciones activas, averías, alarmas y trabajos pendientes', 'Solo el nombre del relevo', 'Únicamente la producción del día', 'Solo el tiempo meteorológico', 'A', 'La diapositiva y el manual enumeran esos elementos como información crítica del relevo.'),
  ('EB-20H-B4-Q12', 20, 4, 12, '4.8', '¿Qué caracteriza una zona de exclusión alrededor de maquinaria móvil?', 'Puede entrar cualquiera si lleva casco', 'Nadie debe entrar sin autorización expresa del operador', 'Es solo una recomendación visual', 'Solo se aplica de noche', 'B', 'La diapositiva y el manual definen la zona de exclusión como radio mínimo de seguridad con acceso controlado.'),
  ('EB-20H-B4-Q13', 20, 4, 13, '4.9', '¿Cuándo puede producción reactivar un equipo que ha estado intervenido?', 'Cuando el técnico se aleja', 'Después de la liberación formal y la restitución', 'En cuanto desaparece la avería visualmente', 'Antes de reponer resguardos', 'B', 'La diapositiva y el manual indican que la restitución y liberación formal forman parte de la intervención.'),
  ('EB-20H-B4-Q14', 20, 4, 14, '4.9', '¿Cuáles son las fases generales mostradas para una intervención con producción?', 'Solicitud, consignación, intervención y restitución', 'Arranque, carga, descarga y venta', 'Aviso, silencio, puenteo y arranque', 'Limpieza, engrase, producción y cierre', 'A', 'La diapositiva representa estas cuatro fases y el manual desarrolla entrega, intervención y liberación.'),
  ('EB-20H-B4-Q15', 20, 4, 15, '4.10', '¿Qué norma se cita para la coordinación de actividades empresariales?', 'RD 171/2004', 'RD 286/2006', 'RD 614/2001', 'RD 485/1997', 'A', 'La diapositiva y el manual citan expresamente el RD 171/2004 en concurrencia de empresas.'),
  ('EB-20H-B5-Q01', 20, 5, 1, '5.1', '¿Qué norma aparece como base general de prevención en la jerarquía del curso?', 'Ley 31/1995 de Prevención de Riesgos Laborales', 'Solo la ET 2004-1-10', 'Únicamente las DIS', 'El manual del fabricante', 'A', 'La diapositiva y el manual sitúan la Ley 31/1995 en la base del marco preventivo.'),
  ('EB-20H-B5-Q02', 20, 5, 2, '5.1', '¿Qué Real Decreto se cita específicamente para equipos de trabajo?', 'RD 1215/1997', 'RD 171/2004', 'RD 286/2006', 'RD 614/2001', 'A', 'La diapositiva y el manual citan el RD 1215/1997 para adecuación y uso seguro de equipos.'),
  ('EB-20H-B5-Q03', 20, 5, 3, '5.2', '¿Cuál es una obligación del trabajador indicada en el curso?', 'Utilizar correctamente equipos y protecciones', 'Anular alarmas repetidas', 'Modificar procedimientos por iniciativa propia', 'Reducir la formación obligatoria', 'A', 'La diapositiva y el manual incluyen el uso correcto de equipos y protecciones entre las obligaciones del trabajador.'),
  ('EB-20H-B5-Q04', 20, 5, 4, '5.3', '¿Cuál es la duración oficial de la formación inicial indicada para este curso?', '5 horas', '10 horas', '20 horas', '40 horas', 'C', 'La diapositiva y el manual indican 20 horas presenciales para la formación inicial.'),
  ('EB-20H-B5-Q05', 20, 5, 5, '5.3', '¿Qué papel se atribuye a InmínerCampus en esta formación?', 'Soporte didáctico, documental y de trazabilidad, sin sustituir la presencialidad', 'Sustituir completamente la formación presencial', 'Reducir las 20 horas oficiales', 'Eliminar la necesidad de asistencia documentada', 'A', 'La diapositiva y el manual indican que InmínerCampus es un soporte y no reemplaza la presencialidad exigida.'),
  ('EB-20H-B5-Q06', 20, 5, 6, '5.4', '¿Qué perfil debe incluir el equipo docente como coordinador del curso?', 'Una persona acreditada para funciones de nivel superior en PRL', 'Cualquier trabajador con antigüedad', 'Solo un administrativo', 'Exclusivamente un conductor de maquinaria', 'A', 'La diapositiva y el manual exigen una persona acreditada para funciones de nivel superior en PRL como coordinador.'),
  ('EB-20H-B5-Q07', 20, 5, 7, '5.5', '¿Qué forma parte de la trazabilidad documental de la formación?', 'Asistencia documentada, evaluación, acreditación y registro oficial', 'Solo una fotografía del aula', 'Únicamente el recibo de pago', 'Solo una firma sin evaluación', 'A', 'La diapositiva y el manual presentan esos elementos como evidencia de la formación recibida y evaluada.'),
  ('EB-20H-B5-Q08', 20, 5, 8, '5.5', '¿Qué debe ocurrir para que se emita la acreditación?', 'Que el trabajador supere los niveles establecidos', 'Que solo firme asistencia', 'Que pague el curso', 'Que descargue el manual', 'A', 'La diapositiva y el manual vinculan la acreditación a la evaluación y superación de los niveles de conocimiento.'),
  ('EB-20H-B5-Q09', 20, 5, 9, '5.6', '¿Qué puestos aparecen con reciclaje máximo de cuatro años?', 'Técnicos titulados, encargados/vigilantes, operadores de hornos y operadores de laboratorio', 'Trituración, molienda, estrío y mantenimiento', 'Solo operadores de mezclas', 'Todos los puestos sin excepción', 'A', 'La tabla de la diapositiva y el manual asignan cuatro años a los puestos a), b), g) y l).'),
  ('EB-20H-B5-Q10', 20, 5, 10, '5.7', '¿Qué puestos operativos aparecen con reciclaje máximo de dos años?', 'Trituración/clasificación, molienda, estrío, separación/concentración, mezclas, plantas de materiales, roca ornamental y mantenimiento', 'Solo técnicos titulados', 'Solo laboratorio', 'Solo encargados', 'A', 'La diapositiva y el manual asignan dos años a los puestos c), d), e), f), h), j), k) y m).'),
  ('EB-20H-B5-Q11', 20, 5, 11, '5.7', '¿En qué debe centrarse el reciclaje de los puestos con actualización cada dos años?', 'Riesgos actualizados, incidentes, modificaciones y procedimientos vigentes', 'Solo en repetir el índice antiguo', 'Únicamente en documentación administrativa', 'Solo en normas que no hayan cambiado', 'A', 'La diapositiva y el manual indican que el reciclaje debe incorporar cambios e incidentes reales.'),
  ('EB-20H-B5-Q12', 20, 5, 12, '5.8', 'Si un trabajador desempeña varios puestos, ¿cómo deben tratarse los contenidos formativos?', 'Repetir todo el curso completo por cada puesto', 'Impartir los contenidos comunes una vez y añadir los específicos de cada función', 'Elegir únicamente el puesto más antiguo', 'Omitir los contenidos específicos', 'B', 'La diapositiva y el manual indican que los contenidos comunes pueden cubrirse una vez, pero los específicos de cada puesto deben añadirse.'),
  ('EB-20H-B5-Q13', 20, 5, 13, '5.9', 'En el caso de un atasco en planta, ¿qué debe hacerse antes de eliminar el atasco con el método previsto?', 'Aumentar la alimentación', 'Parar, consignar y verificar cero energía', 'Retirar resguardos con el equipo disponible', 'Introducir barras improvisadas', 'B', 'La diapositiva y el manual integran la secuencia segura: detener alimentación, consignar, verificar energías y después eliminar el atasco.'),
  ('EB-20H-B5-Q14', 20, 5, 14, '5.9', '¿Qué principio se destaca en el caso integrado de atasco?', 'La presión productiva nunca justifica saltarse el procedimiento', 'El tiempo de parada debe reducirse a cualquier coste', 'Las barras improvisadas son aceptables', 'Puede retirarse el bloqueo antes de reponer protecciones', 'A', 'La diapositiva y el manual cierran el caso integrado con este criterio preventivo fundamental.'),
  ('EB-20H-B5-Q15', 20, 5, 15, '5.10', '¿Qué cinco acciones resumen el comportamiento preventivo de cierre del curso?', 'Revisar, controlar, comunicar, aislar y proteger', 'Acelerar, producir, reparar, ocultar y reiniciar', 'Comprar, vender, registrar, cobrar y archivar', 'Arrancar, puentear, silenciar, improvisar y cerrar', 'A', 'La diapositiva y el manual resumen el comportamiento preventivo en revisar, controlar, comunicar, aislar y proteger.'),
  ('EB-5H-B1-Q01', 5, 1, 1, '1.1', '¿Qué es un establecimiento de beneficio?', 'Una zona dedicada únicamente al almacenamiento de mineral', 'Un conjunto de instalaciones donde el material minero se prepara, transforma, clasifica, concentra o acondiciona para obtener un producto comercializable', 'Un taller exclusivo de mantenimiento', 'Una oficina de control administrativo', 'B', 'La diapositiva y el manual definen el establecimiento de beneficio como un conjunto de instalaciones de preparación y transformación del material minero.'),
  ('EB-5H-B1-Q02', 5, 1, 2, '1.2', '¿Qué puesto del grupo 5.4 figura en la ITC 02.1.02 pero no está incluido en la ET 2004-1-10?', 'Operadores de trituración y clasificación', 'Operadores de laboratorio', 'Operadores de moldeo y/o sinterización', 'Operadores de mantenimiento mecánico y eléctrico', 'C', 'La presentación y el manual señalan expresamente que el puesto i), moldeo o sinterización, queda fuera del ámbito de la ET 2004-1-10.'),
  ('EB-5H-B1-Q03', 5, 1, 3, '1.3', '¿Por qué es importante conocer el flujo completo del proceso mineral?', 'Porque todos los equipos tienen exactamente los mismos riesgos', 'Porque un riesgo o una desviación en una etapa puede propagarse a etapas adyacentes', 'Porque elimina la necesidad de consignar equipos', 'Porque permite omitir la supervisión local', 'B', 'El mensaje clave de la diapositiva y el desarrollo del manual explican que los efectos de una etapa pueden propagarse aguas arriba o aguas abajo.'),
  ('EB-5H-B1-Q04', 5, 1, 4, '1.4', '¿Cuáles son riesgos principales en la recepción, tolvas y alimentación de material?', 'Únicamente ruido y vibraciones', 'Atropello, caída a tolva, sepultamiento y atrapamiento', 'Solo exposición química', 'Solo quemaduras', 'B', 'La diapositiva enumera estos cuatro riesgos y el manual los desarrolla al describir descarga, material inestable y órganos de alimentación.'),
  ('EB-5H-B1-Q05', 5, 1, 5, '1.5', '¿Qué riesgos principales aparecen en trituración y clasificación?', 'Atrapamiento, proyección de fragmentos, ruido, polvo respirable y arranque inesperado', 'Solo cortes manuales', 'Únicamente estrés térmico', 'Exclusivamente contacto químico', 'A', 'La diapositiva y el manual relacionan trituración y cribado con atrapamientos, proyecciones, ruido, polvo y rearranques.'),
  ('EB-5H-B1-Q06', 5, 1, 6, '1.6', 'Antes de intervenir en un molino, ¿qué debe verificarse?', 'Que la producción esté al máximo', 'Que exista cero energía tras la consignación', 'Que se haya retirado la señalización', 'Que el motor esté caliente', 'B', 'Tanto la diapositiva como el manual insisten en la consignación y verificación de ausencia de energía antes de intervenir.'),
  ('EB-5H-B1-Q07', 5, 1, 7, '1.7', '¿Cuál es el principal riesgo del estrío manual junto a cintas transportadoras?', 'La proximidad de manos o herramientas a elementos móviles y puntos de atrapamiento', 'La combustión del material', 'La presión hidráulica del puesto', 'La radiación térmica', 'A', 'La diapositiva y el manual destacan el atrapamiento junto a cintas, rodillos y otros órganos móviles.'),
  ('EB-5H-B1-Q08', 5, 1, 8, '1.8', 'Cuando se emplean sustancias en separación y concentración, ¿qué documento debe conocerse?', 'La nómina del trabajador', 'La ficha de datos de seguridad', 'El parte meteorológico', 'El albarán de expedición', 'B', 'La presentación exige conocer las FDS y el manual desarrolla su uso para peligros, compatibilidad, EPI y derrames.'),
  ('EB-5H-B1-Q09', 5, 1, 9, '1.9', '¿Qué debe hacerse antes de abrir o entrar en un mezclador?', 'Aumentar la velocidad de giro', 'Consignar el equipo', 'Retirar todas las alarmas', 'Mantener la alimentación activa', 'B', 'La diapositiva y el manual señalan que las palas, ejes y transmisiones de alta energía requieren consignación antes del acceso.'),
  ('EB-5H-B1-Q10', 5, 1, 10, '1.10', '¿Qué riesgo se destaca en roca ornamental por la manipulación de piezas pesadas?', 'Vuelco de bloques o tablas', 'Únicamente ruido de oficina', 'Solo exposición biológica', 'Exceso de iluminación', 'A', 'La presentación y el manual identifican la estabilidad y el vuelco de bloques o tablas como riesgos relevantes.'),
  ('EB-5H-B2-Q01', 5, 2, 1, '2.1', 'Antes de comenzar el turno, ¿qué debe revisarse en el lugar de trabajo?', 'Accesos, pasarelas, escaleras, plataformas, orden, iluminación, señalización y derrames', 'Solo el reloj de fichaje', 'Únicamente el nivel de producción', 'Solo la documentación administrativa', 'A', 'La diapositiva enumera estos elementos y el manual explica que la revisión previa es la primera barrera preventiva.'),
  ('EB-5H-B2-Q02', 5, 2, 2, '2.2', 'Si el operador detecta una deficiencia que compromete la seguridad, ¿qué debe hacer?', 'Repararla aunque no esté autorizado', 'Detectarla, comunicarla y evitar el uso del equipo', 'Ocultarla hasta el final del turno', 'Puentear la protección para comprobar si funciona', 'B', 'La diapositiva y el manual fijan el límite de competencia del operador: detectar, comunicar y retirar o evitar el uso cuando proceda.'),
  ('EB-5H-B2-Q03', 5, 2, 3, '2.3', '¿Cuál es la secuencia preventiva indicada para una operación básica de mantenimiento?', 'Mantener, arrancar, revisar y aislar', 'Parar, aislar, verificar, mantener y restituir', 'Limpiar, abrir, probar y arrancar', 'Acelerar, reparar, verificar y cerrar', 'B', 'La diapositiva muestra expresamente la secuencia Parar → Aislar → Verificar → Mantener → Restituir, desarrollada en el manual.'),
  ('EB-5H-B2-Q04', 5, 2, 4, '2.4', '¿Cuál es un acceso correcto a un puesto o punto de mantenimiento?', 'Subir por la estructura de una cinta', 'Usar tambores o rodillos como apoyo', 'Utilizar una escalera fija o pasarela autorizada', 'Trepar por tuberías', 'C', 'La presentación y el manual exigen utilizar medios diseñados para el acceso, como escaleras y pasarelas autorizadas.'),
  ('EB-5H-B2-Q05', 5, 2, 5, '2.5', '¿Qué debe hacerse para aislar una instalación hidráulica antes de intervenir?', 'Cerrar una válvula y despresurizar', 'Buscar la fuga con la mano', 'Aumentar la presión', 'Abrir todos los racores', 'A', 'La diapositiva indica válvula más despresurización y el manual desarrolla el control de presión residual.'),
  ('EB-5H-B2-Q06', 5, 2, 6, '2.6', '¿Cuál es la secuencia correcta de puesta en marcha mostrada en el curso?', 'Arrancar, avisar, verificar y confirmar', 'Verificar equipo, activar avisos, confirmar la zona y arrancar', 'Alimentar, arrancar y después revisar', 'Avisar únicamente después de arrancar', 'B', 'La diapositiva presenta esos cuatro pasos y el manual explica la puesta en marcha como transición controlada.'),
  ('EB-5H-B2-Q07', 5, 2, 7, '2.7', '¿Qué variables pueden vigilarse durante el funcionamiento?', 'Presión, temperatura, nivel, caudal, vibraciones, ruido, intensidad y alarmas', 'Solo el nombre del operador', 'Únicamente el número de pedidos', 'Solo el color exterior del equipo', 'A', 'La diapositiva y el manual enumeran variables de proceso e indicadores para detectar tendencias y desviaciones.'),
  ('EB-5H-B2-Q08', 5, 2, 8, '2.8', '¿Qué estado permite intervenir tras aislar completamente y verificar cero energía?', 'Parada normal', 'Parada de emergencia', 'Consignación', 'Modo automático', 'C', 'La diapositiva diferencia parada normal, emergencia y consignación; el manual refuerza que solo la consignación prepara una intervención.'),
  ('EB-5H-B2-Q09', 5, 2, 9, '2.9', 'Ante un atasco, ¿cuál es la primera acción de la secuencia segura?', 'Introducir una barra', 'Detener la alimentación', 'Retirar protecciones', 'Golpear el equipo', 'B', 'La diapositiva y el manual inician la secuencia de desatasco cortando la aportación de material.'),
  ('EB-5H-B2-Q10', 5, 2, 10, '2.10', '¿Qué conducta resume la actuación inicial en primeros auxilios?', 'Proteger, Alertar y Socorrer', 'Producir, Ajustar y Supervisar', 'Parar, Abrir y Señalizar', 'Prever, Acelerar y Salir', 'A', 'El mensaje clave de la diapositiva y el manual utilizan la conducta PAS: Proteger → Alertar → Socorrer.'),
  ('EB-5H-B3-Q01', 5, 3, 1, '3.1', 'Conocer técnicamente un equipo significa principalmente:', 'Saber repararlo por completo', 'Entender su función, sus límites, sus protecciones y sus riesgos residuales', 'Poder modificar sus sensores', 'Trabajar sin consultar procedimientos', 'B', 'La diapositiva y el manual distinguen conocer el equipo de saber repararlo, y centran el conocimiento en función, límites y protecciones.'),
  ('EB-5H-B3-Q02', 5, 3, 2, '3.2', '¿Un enclavamiento sustituye a la consignación para mantenimiento?', 'Sí, siempre', 'No, tienen funciones diferentes', 'Solo en trituradoras', 'Solo si hay una parada de emergencia', 'B', 'La diapositiva y el manual explican que el enclavamiento impide determinadas maniobras, pero no garantiza aislamiento ni cero energía.'),
  ('EB-5H-B3-Q03', 5, 3, 3, '3.3', '¿Qué peligro concentran especialmente las cintas transportadoras?', 'Numerosos puntos de atrapamiento', 'Únicamente radiación térmica', 'Solo riesgo químico', 'Exclusivamente riesgo biológico', 'A', 'El mensaje clave de la diapositiva y el manual identifican múltiples puntos de atrapamiento en cintas y transferencias.'),
  ('EB-5H-B3-Q04', 5, 3, 4, '3.4', 'Antes de abrir una línea con fluido, ¿qué debe verificarse?', 'Solo que el manómetro marque cero', 'Aislamiento, vaciado y despresurización', 'Que la bomba siga funcionando', 'Que el tanque esté lleno', 'B', 'La diapositiva y el manual indican que no basta con el manómetro: deben aislarse, vaciarse y despresurizarse los circuitos.'),
  ('EB-5H-B3-Q05', 5, 3, 5, '3.5', '¿Qué papel tiene el EPI térmico en hornos y equipos térmicos?', 'Sustituye las distancias de seguridad', 'Es una medida complementaria y no sustituye el diseño seguro', 'Elimina el riesgo de incendio', 'Permite anular controles de temperatura', 'B', 'La diapositiva y el manual remarcan que el EPI térmico complementa, pero no reemplaza, medidas técnicas y distancias.'),
  ('EB-5H-B3-Q06', 5, 3, 6, '3.6', 'En una planta de materiales para la construcción, ¿qué riesgo se identifica en los silos?', 'Sepultamiento y caída', 'Únicamente ruido', 'Solo riesgo eléctrico', 'Exclusivamente cortes manuales', 'A', 'El diagrama de la diapositiva identifica en los silos riesgo de sepultamiento y caída, y el manual desarrolla estos peligros.'),
  ('EB-5H-B3-Q07', 5, 3, 7, '3.7', '¿Qué regla debe cumplirse respecto a las cargas suspendidas en roca ornamental?', 'Permanecer debajo para controlar el movimiento', 'Nunca permanecer bajo cargas suspendidas', 'Sujetar la carga con la mano', 'Pasar por debajo si la maniobra es breve', 'B', 'La diapositiva y el manual establecen expresamente que nadie debe permanecer bajo cargas suspendidas.'),
  ('EB-5H-B3-Q08', 5, 3, 8, '3.8', 'Antes de manipular reactivos en laboratorio, ¿qué debe consultarse?', 'La ficha de datos de seguridad', 'El registro de visitas', 'El parte de producción', 'La orden de expedición', 'A', 'La diapositiva y el manual exigen revisar la FDS para conocer peligros, compatibilidad, EPI y respuesta ante incidentes.'),
  ('EB-5H-B3-Q09', 5, 3, 9, '3.9', '¿Es suficiente bloquear solo el interruptor principal para realizar mantenimiento?', 'Sí, siempre', 'No, deben identificarse y controlarse todas las fuentes de energía', 'Solo si el equipo es pequeño', 'Sí, si no hay ruido', 'B', 'La diapositiva y el manual insisten en la consignación multienergía: eléctrica, mecánica, gravitatoria, hidráulica, neumática y térmica.'),
  ('EB-5H-B3-Q10', 5, 3, 10, '3.10', '¿Qué afirmación es correcta sobre los sistemas de seguridad?', 'Eliminan todos los peligros', 'Son una capa de protección, pero pueden quedar riesgos residuales', 'Permiten trabajar fuera de los límites del equipo', 'Hacen innecesaria la formación', 'B', 'El mensaje clave de la diapositiva y el manual explica que las protecciones reducen riesgo, pero no eliminan todos los peligros.'),
  ('EB-5H-B4-Q01', 5, 4, 1, '4.1', '¿Qué debe hacer el trabajador si una lectura de un instrumento es incoherente con el comportamiento real del proceso?', 'Ignorarla', 'Investigarla y no confiar en una única lectura', 'Modificar el instrumento por su cuenta', 'Continuar hasta que aparezca una alarma', 'B', 'La diapositiva y el manual advierten que un instrumento defectuoso puede ocultar una condición peligrosa.'),
  ('EB-5H-B4-Q02', 5, 4, 2, '4.2', '¿Cuál es la secuencia básica asociada a la gestión de alarmas?', 'Detectar, interpretar, actuar y registrar', 'Silenciar, olvidar y continuar', 'Arrancar, producir y cerrar', 'Desactivar, puentear y resetear', 'A', 'La diapositiva presenta expresamente Detectar → Interpretar → Actuar → Registrar, desarrollada después en el manual.'),
  ('EB-5H-B4-Q03', 5, 4, 3, '4.3', '¿Qué deben hacer las Disposiciones Internas de Seguridad?', 'Sustituir toda la legislación', 'Concretar reglas del centro y ser coherentes con la evaluación de riesgos', 'Eliminar los procedimientos', 'Aplicarse solo a contratistas', 'B', 'La diapositiva y el manual indican que las DIS concretan las reglas propias del centro y deben mantenerse actualizadas.'),
  ('EB-5H-B4-Q04', 5, 4, 4, '4.4', '¿Qué principio preventivo se aplica al polvo, ruido y vibraciones?', 'El EPI sustituye los controles técnicos', 'La jerarquía de medidas empieza actuando en el origen', 'La única medida válida es limitar el tiempo', 'No es necesario controlar el polvo acumulado', 'B', 'La diapositiva y el manual priorizan eliminación/sustitución y controles de ingeniería antes de depender del EPI.'),
  ('EB-5H-B4-Q05', 5, 4, 5, '4.5', '¿Por qué son importantes el orden y la limpieza?', 'Solo por imagen de la planta', 'Porque actúan como barrera frente a caídas, obstrucciones y riesgos de incendio', 'Solo para facilitar auditorías', 'Porque sustituyen la señalización', 'B', 'La diapositiva y el manual presentan orden y limpieza como medidas preventivas permanentes.'),
  ('EB-5H-B4-Q06', 5, 4, 6, '4.6', '¿Qué puede ocurrir cuando dos tareas seguras por separado coinciden sin coordinación?', 'Siempre siguen siendo seguras', 'Pueden generar un riesgo grave por interferencia', 'Se anulan automáticamente sus riesgos', 'Solo aumenta el tiempo de trabajo', 'B', 'El mensaje clave de la diapositiva y el manual explica que la simultaneidad puede crear nuevos riesgos.'),
  ('EB-5H-B4-Q07', 5, 4, 7, '4.7', '¿Qué protocolo de comunicación cerrada se muestra para maniobras críticas?', 'Orden → Repetición → Confirmación', 'Orden → Silencio → Arranque', 'Aviso → Producción → Archivo', 'Señal → Espera → Olvido', 'A', 'La diapositiva muestra el esquema de orden, repetición y confirmación y el manual lo desarrolla para evitar ambigüedades.'),
  ('EB-5H-B4-Q08', 5, 4, 8, '4.8', '¿Qué caracteriza una zona de exclusión alrededor de maquinaria móvil?', 'Puede entrar cualquiera si lleva casco', 'Nadie debe entrar sin autorización expresa del operador', 'Es solo una recomendación visual', 'Solo se aplica de noche', 'B', 'La diapositiva y el manual definen la zona de exclusión como radio mínimo de seguridad con acceso controlado.'),
  ('EB-5H-B4-Q09', 5, 4, 9, '4.9', '¿Cuándo puede producción reactivar un equipo que ha estado intervenido?', 'Cuando el técnico se aleja', 'Después de la liberación formal y la restitución', 'En cuanto desaparece la avería visualmente', 'Antes de reponer resguardos', 'B', 'La diapositiva y el manual indican que la restitución y liberación formal forman parte de la intervención.'),
  ('EB-5H-B4-Q10', 5, 4, 10, '4.10', '¿Qué norma se cita para la coordinación de actividades empresariales?', 'RD 171/2004', 'RD 286/2006', 'RD 614/2001', 'RD 485/1997', 'A', 'La diapositiva y el manual citan expresamente el RD 171/2004 en concurrencia de empresas.'),
  ('EB-5H-B5-Q01', 5, 5, 1, '5.1', '¿Qué norma aparece como base general de prevención en la jerarquía del curso?', 'Ley 31/1995 de Prevención de Riesgos Laborales', 'Solo la ET 2004-1-10', 'Únicamente las DIS', 'El manual del fabricante', 'A', 'La diapositiva y el manual sitúan la Ley 31/1995 en la base del marco preventivo.'),
  ('EB-5H-B5-Q02', 5, 5, 2, '5.2', '¿Cuál es una obligación del trabajador indicada en el curso?', 'Utilizar correctamente equipos y protecciones', 'Anular alarmas repetidas', 'Modificar procedimientos por iniciativa propia', 'Reducir la formación obligatoria', 'A', 'La diapositiva y el manual incluyen el uso correcto de equipos y protecciones entre las obligaciones del trabajador.'),
  ('EB-5H-B5-Q03', 5, 5, 3, '5.3', '¿Cuál es la duración oficial de la formación inicial indicada para este curso?', '5 horas', '10 horas', '20 horas', '40 horas', 'C', 'La diapositiva y el manual indican 20 horas presenciales para la formación inicial.'),
  ('EB-5H-B5-Q04', 5, 5, 4, '5.4', '¿Qué perfil debe incluir el equipo docente como coordinador del curso?', 'Una persona acreditada para funciones de nivel superior en PRL', 'Cualquier trabajador con antigüedad', 'Solo un administrativo', 'Exclusivamente un conductor de maquinaria', 'A', 'La diapositiva y el manual exigen una persona acreditada para funciones de nivel superior en PRL como coordinador.'),
  ('EB-5H-B5-Q05', 5, 5, 5, '5.5', '¿Qué forma parte de la trazabilidad documental de la formación?', 'Asistencia documentada, evaluación, acreditación y registro oficial', 'Solo una fotografía del aula', 'Únicamente el recibo de pago', 'Solo una firma sin evaluación', 'A', 'La diapositiva y el manual presentan esos elementos como evidencia de la formación recibida y evaluada.'),
  ('EB-5H-B5-Q06', 5, 5, 6, '5.6', '¿Qué puestos aparecen con reciclaje máximo de cuatro años?', 'Técnicos titulados, encargados/vigilantes, operadores de hornos y operadores de laboratorio', 'Trituración, molienda, estrío y mantenimiento', 'Solo operadores de mezclas', 'Todos los puestos sin excepción', 'A', 'La tabla de la diapositiva y el manual asignan cuatro años a los puestos a), b), g) y l).'),
  ('EB-5H-B5-Q07', 5, 5, 7, '5.7', '¿Qué puestos operativos aparecen con reciclaje máximo de dos años?', 'Trituración/clasificación, molienda, estrío, separación/concentración, mezclas, plantas de materiales, roca ornamental y mantenimiento', 'Solo técnicos titulados', 'Solo laboratorio', 'Solo encargados', 'A', 'La diapositiva y el manual asignan dos años a los puestos c), d), e), f), h), j), k) y m).'),
  ('EB-5H-B5-Q08', 5, 5, 8, '5.8', 'Si un trabajador desempeña varios puestos, ¿cómo deben tratarse los contenidos formativos?', 'Repetir todo el curso completo por cada puesto', 'Impartir los contenidos comunes una vez y añadir los específicos de cada función', 'Elegir únicamente el puesto más antiguo', 'Omitir los contenidos específicos', 'B', 'La diapositiva y el manual indican que los contenidos comunes pueden cubrirse una vez, pero los específicos de cada puesto deben añadirse.'),
  ('EB-5H-B5-Q09', 5, 5, 9, '5.9', 'En el caso de un atasco en planta, ¿qué debe hacerse antes de eliminar el atasco con el método previsto?', 'Aumentar la alimentación', 'Parar, consignar y verificar cero energía', 'Retirar resguardos con el equipo disponible', 'Introducir barras improvisadas', 'B', 'La diapositiva y el manual integran la secuencia segura: detener alimentación, consignar, verificar energías y después eliminar el atasco.'),
  ('EB-5H-B5-Q10', 5, 5, 10, '5.10', '¿Qué cinco acciones resumen el comportamiento preventivo de cierre del curso?', 'Revisar, controlar, comunicar, aislar y proteger', 'Acelerar, producir, reparar, ocultar y reiniciar', 'Comprar, vender, registrar, cobrar y archivar', 'Arrancar, puentear, silenciar, improvisar y cerrar', 'A', 'La diapositiva y el manual resumen el comportamiento preventivo en revisar, controlar, comunicar, aislar y proteger.');

do $$
declare
  v_slug constant text := 'operadores-establecimientos-beneficio';
  v_duracion integer;
  v_bloque integer;
  v_version uuid;
  v_leccion uuid;
  v_banco uuid;
  v_pregunta uuid;
  v_unidad uuid;
  v_total integer;
  v_fila record;
  v_codigos text[];
begin
  foreach v_duracion in array array[5, 20] loop
    select cv.id into v_version
    from public.course_versions cv
    join public.courses c on c.id = cv.course_id
    where c.slug = v_slug
      and cv.duration_hours = v_duracion;

    if v_version is null then
      raise exception 'No existe la versión de % h de %', v_duracion, v_slug;
    end if;

    for v_bloque in 1..5 loop
      select l.id into v_leccion
      from public.course_modules cm
      join public.lessons l on l.module_id = cm.id
      where cm.course_version_id = v_version
        and cm.position = v_bloque
        and l.active
      order by l.position
      limit 1;

      if v_leccion is null then
        raise exception 'Falta la lección del bloque % (% h)', v_bloque, v_duracion;
      end if;

      -- Si el bloque ya tuviera evaluación, se respeta la que existe.
      if exists (select 1 from public.quizzes q where q.lesson_id = v_leccion) then
        continue;
      end if;

      select count(*) into v_total
      from _eb_preguntas p
      where p.duracion = v_duracion and p.bloque = v_bloque;

      if v_total = 0 then
        raise exception 'Sin preguntas para el bloque % (% h)', v_bloque, v_duracion;
      end if;

      insert into public.question_banks (course_version_id, title)
      values (
        v_version,
        format(
          'Evaluación aportada · Establecimientos de beneficio %s h · Bloque %s · 2026-09-11',
          v_duracion,
          v_bloque
        )
      )
      returning id into v_banco;

      -- El esquema admite una sola pregunta enlazada por unidad dentro de cada
      -- banco. Si la unidad todavía no está publicada, la pregunta queda sin
      -- enlazar: el enlace sólo alimenta la lista de partes a repasar.
      v_codigos := array[]::text[];

      for v_fila in
        select * from _eb_preguntas p
        where p.duracion = v_duracion and p.bloque = v_bloque
        order by p.orden
      loop
        if v_fila.codigo = any(v_codigos) then
          v_unidad := null;
        else
          select s.id into v_unidad
          from public.course_modules cm
          join public.lessons l on l.module_id = cm.id
          join public.lesson_audio_segments s on s.lesson_id = l.id
          where cm.course_version_id = v_version
            and s.lesson_code = v_fila.codigo
            and s.published
          limit 1;

          if v_unidad is not null then
            v_codigos := v_codigos || v_fila.codigo;
          end if;
        end if;

        insert into public.questions (
          question_bank_id, prompt, type, explanation, points, active,
          lesson_audio_segment_id
        )
        values (
          v_banco, v_fila.enunciado, 'single_choice', v_fila.justificacion,
          1, true, v_unidad
        )
        returning id into v_pregunta;

        insert into public.question_options (question_id, option_text, is_correct, position)
        values
          (v_pregunta, v_fila.opcion_a, v_fila.correcta = 'A', 1),
          (v_pregunta, v_fila.opcion_b, v_fila.correcta = 'B', 2),
          (v_pregunta, v_fila.opcion_c, v_fila.correcta = 'C', 3),
          (v_pregunta, v_fila.opcion_d, v_fila.correcta = 'D', 4);
      end loop;

      insert into public.quizzes (
        lesson_id, question_bank_id, title, question_count, passing_percent,
        required_perfect_streak, randomize_questions, randomize_options,
        minimum_retry_seconds, active, completion_mode
      )
      values (
        v_leccion, v_banco,
        format('Test del bloque %s · %s preguntas', v_bloque, v_total),
        v_total, 100, 3, true, true, 0, true, 'cumulative_perfect'
      );
    end loop;
  end loop;
end $$;

commit;
