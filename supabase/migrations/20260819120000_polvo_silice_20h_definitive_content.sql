-- Sustituye el material provisional del curso "Polvo y sílice cristalina
-- respirable · 20 horas" (versión ampliada) por el contenido definitivo:
-- 50 diapositivas nuevas (una por parte, en vez de las 2 provisionales
-- anteriores) extraídas de la presentación oficial, y las 50 explicaciones
-- detalladas correspondientes, extraídas del documento oficial de
-- explicaciones. Los audios NO se tocan (siguen siendo los ya grabados).
-- Alcance exclusivo: course_version_id = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24'
-- (prevencion-polvo-silice-cristalina-respirable, duration_hours = 20).
-- La versión de 5 horas del mismo curso no se modifica.

begin;

create temporary table _polvo20h_content (
  block_position integer not null,
  part_position integer not null,
  expected_title text not null,
  source_page integer not null,
  slide_storage_path text not null,
  note_summary text not null,
  primary key (block_position, part_position)
) on commit drop;

insert into _polvo20h_content
  (block_position, part_position, expected_title, source_page, slide_storage_path, note_summary)
values
  (1, 1, 'Qué es el polvo', 1, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-01/slide-01.jpg', 'Objetivo

Definir el polvo como aerosol sólido y distinguir peligro, emisión y exposición.

Explicación detallada

El polvo es materia sólida particulada y dispersa en la atmósfera, generada por procesos mecánicos o por el movimiento del aire. En minería aparece en numerosas operaciones y puede convertirse en un agente químico peligroso para la salud. En una explotación no todo el polvo tiene la misma composición ni el mismo tamaño. Por eso, una evaluación seria no se limita a observar si el ambiente parece limpio: identifica el material, el proceso que lo fragmenta y la fracción capaz de permanecer suspendida y llegar al trabajador. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

El polvo no es una sustancia única. Su peligrosidad depende de composición mineralógica, granulometría y propiedades; la emisión depende del proceso; y la exposición depende de cuánto llega a la zona de respiración y durante cuánto tiempo. Ver polvo depositado informa sobre limpieza, pero no cuantifica el aerosol respirable.

Caso práctico razonado

Una cinta parece limpia al inicio, pero un punto de transferencia libera material fino durante cada caída. El foco debe identificarse por operación y no por la apariencia general de la nave.

Secuencia operativa recomendada

• Identificar material y porcentaje de sílice.
• Localizar operaciones que fragmentan, caen o movilizan material.
• Distinguir polvo depositado de polvo en suspensión.
• Relacionar focos con personas, tiempo y trayectoria del aire.

Errores críticos que deben evitarse

• Llamar polvo únicamente a la nube visible.
• Suponer que todos los polvos tienen igual peligrosidad.
• Evaluar el material sin evaluar la tarea.

Comprobación antes de continuar

• Identificar material y porcentaje de sílice.
• Localizar operaciones que fragmentan, caen o movilizan material.
• Distinguir polvo depositado de polvo en suspensión.
• Relacionar focos con personas, tiempo y trayectoria del aire.

Idea clave

El riesgo se entiende al unir material, proceso y persona; observar suciedad no equivale a medir exposición.'),
  (1, 2, 'Qué es la sílice cristalina', 2, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-02/slide-01.jpg', 'Objetivo

Reconocer la sílice cristalina y diferenciar presencia en el material de exposición respirable.

Explicación detallada

La sílice cristalina es dióxido de silicio cristalizado, generalmente en forma de cuarzo o cristobalita. Está presente en muchas rocas y materiales minerales. El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas. El cuarzo es la forma más habitual, pero también debe considerarse la cristobalita cuando pueda estar presente. El porcentaje de sílice de la roca ayuda a caracterizar el peligro, aunque por sí solo no determina la exposición real: también influyen el proceso, la humedad, la ventilación y el tiempo de permanencia. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Cuarzo y cristobalita son formas cristalinas de dióxido de silicio. Un análisis a granel identifica el peligro en la materia prima, pero no predice por sí solo la concentración respirada. Humedad, energía del proceso, encerramiento, ventilación y duración pueden modificar ampliamente la exposición.

Caso práctico razonado

Dos rocas tienen el mismo contenido de cuarzo; una se manipula húmeda en sistema cerrado y otra se corta en seco. El peligro intrínseco es parecido, pero la exposición puede ser muy distinta.

Secuencia operativa recomendada

• Consultar análisis mineralógico representativo.
• Identificar la forma cristalina relevante.
• Relacionar el contenido con el método de trabajo.
• Confirmar exposición mediante evaluación y medición personal.

Errores críticos que deben evitarse

• Equiparar porcentaje en roca con concentración ambiental.
• Ignorar cristobalita cuando el proceso puede generarla o contenerla.
• Descartar riesgo por trabajar al aire libre.

Comprobación antes de continuar

• Consultar análisis mineralógico representativo.
• Identificar la forma cristalina relevante.
• Relacionar el contenido con el método de trabajo.
• Confirmar exposición mediante evaluación y medición personal.

Idea clave

El contenido de sílice caracteriza el peligro; la exposición real se determina en la tarea y la zona de respiración.'),
  (1, 3, 'Cuándo existe riesgo de exposición', 3, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-03/slide-01.jpg', 'Objetivo

Identificar exposición directa, indirecta y ocasional, incluso fuera del puesto emisor.

Explicación detallada

Para que exista exposición debe haber un material con sílice cristalina y una tarea capaz de liberar partículas respirables al aire. La evaluación debe considerar también el polvo procedente de focos cercanos, aunque no se genere directamente en el puesto. El análisis debe abarcar tanto a quien genera el polvo como a quienes trabajan cerca o acceden de forma puntual. Un mecánico, un técnico de laboratorio o personal de oficina que entra en producción puede recibir exposición aunque su tarea principal no sea triturar, perforar o transportar material. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La SCR puede desplazarse desde focos próximos y alcanzar mantenimiento, laboratorio, limpieza, vigilancia o accesos. El mapa de exposición debe incluir rutas de personas y corrientes de aire, tareas normales y anormales, y contratistas. La denominación administrativa del puesto no protege frente a una nube procedente de otra tarea.

Caso práctico razonado

Un electricista entra diez minutos en una trituradora parada mientras se limpia en seco cerca. Aunque no opere el proceso, puede recibir un pico relevante.

Secuencia operativa recomendada

• Inventariar focos propios y externos.
• Seguir rutas de propagación y permanencia.
• Incluir accesos breves, contratas y tareas auxiliares.
• Definir controles antes de autorizar la entrada.

Errores críticos que deben evitarse

• Limitar la evaluación a operadores de producción.
• Excluir tareas cortas por su duración.
• Suponer que la distancia elimina automáticamente el riesgo.

Comprobación antes de continuar

• Inventariar focos propios y externos.
• Seguir rutas de propagación y permanencia.
• Incluir accesos breves, contratas y tareas auxiliares.
• Definir controles antes de autorizar la entrada.

Idea clave

Se evalúa a toda persona que pueda inhalar SCR, no solo a quien genera el polvo.'),
  (1, 4, 'Procesos que pueden generar polvo', 4, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-04/slide-01.jpg', 'Objetivo

Recorrer todo el proceso y reconocer operaciones habituales, no regulares y de mantenimiento que generan polvo.

Explicación detallada

La extracción, perforación, trituración, molienda, tamizado, carga, transporte, limpieza y mantenimiento pueden generar polvo respirable. También pueden producir exposición el corte de piedra, los transvases, el almacenamiento y el acceso esporádico a zonas de producción. Conviene recorrer el proceso completo, desde el frente hasta el producto final, incluyendo paradas, averías y limpieza. Las tareas breves pueden producir picos intensos, especialmente al abrir equipos, vaciar filtros o retirar acumulaciones secas; por eso no deben desaparecer de la evaluación por ser poco frecuentes. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La emisión aumenta con trituración, impacto, abrasión, velocidad, altura de caída y manipulación de material seco. Las aperturas, vaciados de filtros y desatascos pueden producir picos mayores que la producción estable. Una matriz de tareas debe describir frecuencia, duración, material, controles y posibles fallos.

Caso práctico razonado

Una captación mantiene controlada la molienda, pero al vaciar el filtro una vez por semana se libera una nube concentrada. Esa tarea breve necesita evaluación y procedimiento propios.

Secuencia operativa recomendada

• Dibujar el flujo desde extracción hasta expedición.
• Anotar transferencias, caídas, corte, transporte y acopios.
• Añadir limpieza, averías y apertura de equipos.
• Priorizar escenarios por potencial de emisión y personas afectadas.

Errores críticos que deben evitarse

• Medir solo durante régimen estable.
• Olvidar contratistas y mantenedores.
• Considerar irrelevante una tarea por ser semanal.

Comprobación antes de continuar

• Dibujar el flujo desde extracción hasta expedición.
• Anotar transferencias, caídas, corte, transporte y acopios.
• Añadir limpieza, averías y apertura de equipos.
• Priorizar escenarios por potencial de emisión y personas afectadas.

Idea clave

Los picos de tareas breves pueden dominar la dosis y deben aparecer en la evaluación.'),
  (1, 5, 'Fracciones inhalable, torácica y respirable', 5, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-05/slide-01.jpg', 'Objetivo

Diferenciar fracciones inhalable, torácica y respirable según su penetración en el aparato respiratorio.

Explicación detallada

El polvo se clasifica según hasta dónde puede penetrar en el sistema respiratorio. La fracción respirable es la más relevante para la sílice porque puede alcanzar las zonas profundas del pulmón, donde su eliminación resulta especialmente difícil. La clasificación por fracciones explica por qué dos nubes aparentemente iguales pueden tener efectos diferentes. La fracción inhalable entra por nariz y boca; la torácica supera la laringe; y la respirable alcanza regiones pulmonares profundas. Para la SCR, esta última es la referencia higiénica esencial. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Las fracciones son convenciones relacionadas con la probabilidad de penetración, no rangos rígidos de diámetro. Para SCR interesa la masa de sílice en la fracción respirable, capaz de alcanzar vías no ciliadas. Por ello se emplea un selector o ciclón adecuado antes del filtro de muestreo.

Caso práctico razonado

Una medición de polvo total no puede sustituir automáticamente a la medición de fracción respirable, porque el muestreador y la magnitud evaluada son diferentes.

Secuencia operativa recomendada

• Identificar la fracción exigida por el límite.
• Usar el cabezal selector correspondiente.
• Evitar comparar resultados de fracciones distintas.
• Interpretar concentración y contenido de sílice conjuntamente.

Errores críticos que deben evitarse

• Usar “polvo fino” como medida técnica suficiente.
• Comparar polvo total con VLA respirable.
• Creer que solo penetran partículas invisibles.

Comprobación antes de continuar

• Identificar la fracción exigida por el límite.
• Usar el cabezal selector correspondiente.
• Evitar comparar resultados de fracciones distintas.
• Interpretar concentración y contenido de sílice conjuntamente.

Idea clave

Para evaluar SCR se necesita medir la fracción respirable con el método adecuado.'),
  (1, 6, 'Por qué el polvo fino es más peligroso', 6, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-06/slide-01.jpg', 'Objetivo

Explicar por qué las partículas finas permanecen suspendidas y pueden pasar inadvertidas.

Explicación detallada

Las partículas gruesas tienden a sedimentar antes, mientras que las finas permanecen más tiempo suspendidas y pueden desplazarse con el aire. Que una nube no sea visible no significa que el ambiente esté libre de partículas respirables. La partícula respirable puede permanecer suspendida durante mucho tiempo y desplazarse fuera del foco. La iluminación, el color del material o la humedad pueden ocultarla visualmente. La decisión preventiva debe apoyarse en mediciones representativas y en el conocimiento del proceso, no en la simple percepción del operador. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La velocidad de sedimentación disminuye al reducirse tamaño y puede verse alterada por turbulencia, viento y ventilación. La visibilidad depende de iluminación, contraste y concentración, por lo que no es un instrumento de medición. Una zona puede parecer despejada y mantener aerosol respirable después de cesar la operación.

Caso práctico razonado

Tras una limpieza con aire comprimido la nube visible desaparece, pero las partículas finas pueden seguir suspendidas y desplazarse a zonas limpias.

Secuencia operativa recomendada

• No usar la visión como criterio de conformidad.
• Considerar tiempo de permanencia y corrientes de aire.
• Mantener controles tras cesar el foco cuando proceda.
• Verificar con mediciones representativas.

Errores críticos que deben evitarse

• Retirarse el EPI en cuanto deja de verse polvo.
• Abrir puertas sin conocer el flujo del aire.
• Confundir sedimentación visible con eliminación.

Comprobación antes de continuar

• No usar la visión como criterio de conformidad.
• Considerar tiempo de permanencia y corrientes de aire.
• Mantener controles tras cesar el foco cuando proceda.
• Verificar con mediciones representativas.

Idea clave

Invisible no significa inexistente: la exposición se confirma mediante evaluación y medición.'),
  (1, 7, 'Efectos iniciales y enfermedades', 7, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-07/slide-01.jpg', 'Objetivo

Relacionar dosis de SCR con efectos respiratorios y sistémicos graves.

Explicación detallada

La exposición al polvo puede causar irritación, estornudos o molestias respiratorias. La exposición prolongada a sílice cristalina respirable puede provocar silicosis, pérdida de función pulmonar y aumentar el riesgo de tuberculosis, enfermedad renal y cáncer de pulmón. El daño depende de la dosis acumulada, que combina concentración y tiempo, pero también de exposiciones intensas puntuales. La asociación con cáncer de pulmón obliga a aplicar el principio de reducción al nivel más bajo técnicamente posible, incluso cuando todavía no existen síntomas ni se supera el valor límite. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La dosis acumulada combina concentración y tiempo, pero los picos intensos también importan. La SCR se asocia con silicosis, cáncer de pulmón, tuberculosis, pérdida de función pulmonar y otras patologías. La irritación temprana no es un indicador fiable de dosis: puede existir exposición relevante sin molestias inmediatas.

Caso práctico razonado

Un trabajador sin síntomas opera años cerca de un foco. Su buena tolerancia no valida el puesto; deben mantenerse medición, controles y vigilancia específica.

Secuencia operativa recomendada

• Reconocer efectos agudos de irritación y efectos crónicos.
• No esperar síntomas para actuar.
• Reducir exposición por debajo del límite tanto como sea técnicamente posible.
• Comunicar síntomas sin ocultarlos ni autodiagnosticarse.

Errores críticos que deben evitarse

• Usar síntomas como detector ambiental.
• Aceptar picos por ser esporádicos.
• Considerar suficiente una revisión médica normal.

Comprobación antes de continuar

• Reconocer efectos agudos de irritación y efectos crónicos.
• No esperar síntomas para actuar.
• Reducir exposición por debajo del límite tanto como sea técnicamente posible.
• Comunicar síntomas sin ocultarlos ni autodiagnosticarse.

Idea clave

La prevención primaria actúa sobre la exposición antes de que exista daño detectable.'),
  (1, 8, 'La silicosis', 8, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-08/slide-01.jpg', 'Objetivo

Comprender la silicosis como fibrosis pulmonar irreversible y prevenible.

Explicación detallada

La silicosis es una enfermedad pulmonar grave e irreversible causada por la inhalación de sílice cristalina respirable. Puede evolucionar incluso después de cesar la exposición. La prevención debe actuar antes de que aparezcan síntomas o alteraciones radiológicas. La silicosis se produce por la respuesta del tejido pulmonar frente a partículas retenidas y genera fibrosis. Esa cicatrización reduce progresivamente la capacidad respiratoria y no se revierte al abandonar el puesto. La prevención primaria, antes del daño, es mucho más eficaz que cualquier actuación posterior. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Las partículas retenidas activan una respuesta inflamatoria y fibrótica que reduce intercambio gaseoso. El cese de exposición evita dosis adicional, pero no revierte la cicatrización ya producida y la enfermedad puede progresar. De ahí la importancia de evitar el daño y detectar precozmente alteraciones.

Caso práctico razonado

Esperar a que aparezca dificultad respiratoria para instalar aspiración supondría actuar cuando el daño puede ser permanente; el control se diseña desde la evaluación inicial.

Secuencia operativa recomendada

• Controlar el foco antes de iniciar producción.
• Mantener vigilancia sanitaria específica.
• Investigar resultados o diagnósticos relacionados.
• Revisar exposición de personas comparables.

Errores críticos que deben evitarse

• Presentar la silicosis como curable al cambiar de puesto.
• Confiar solo en radiografías periódicas.
• Ocultar un diagnóstico para evitar revisar el proceso.

Comprobación antes de continuar

• Controlar el foco antes de iniciar producción.
• Mantener vigilancia sanitaria específica.
• Investigar resultados o diagnósticos relacionados.
• Revisar exposición de personas comparables.

Idea clave

La silicosis no se cura eliminando la exposición; se previene evitando que la SCR llegue al pulmón.'),
  (1, 9, 'Formas de evolución de la silicosis', 9, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-09/slide-01.jpg', 'Objetivo

Distinguir formas crónica, acelerada y aguda y relacionarlas con intensidad y duración.

Explicación detallada

Según la intensidad y duración de la exposición, la silicosis puede presentarse de forma crónica, acelerada o aguda. Las exposiciones más intensas pueden acortar mucho el tiempo de aparición, por lo que ninguna sobreexposición debe considerarse aceptable. Las categorías crónica, acelerada y aguda ayudan a entender que no existe una única evolución. Una concentración muy alta puede acortar notablemente los plazos de aparición. Por ello, una avería de aspiración, una limpieza incorrecta o una tarea excepcional requieren control inmediato y no pueden normalizarse. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Las categorías muestran que una exposición muy alta puede reducir drásticamente el tiempo de aparición. No existe una “cuota” aceptable de episodios intensos. Un fallo de captación, una reparación o una limpieza seca debe generar respuesta inmediata, registro y reevaluación.

Caso práctico razonado

Una avería libera polvo durante media hora. Aunque el promedio anual parezca bajo, el episodio no se normaliza: se limita acceso, protege, registra y corrige.

Secuencia operativa recomendada

• Detener y delimitar ante emisión anormal.
• Reducir número de expuestos y duración imprescindible.
• Usar protección adecuada al nivel previsto.
• Investigar y evitar repetición.

Errores críticos que deben evitarse

• Promediar el pico con días sin exposición.
• Considerar segura una sobreexposición corta.
• Esperar a la siguiente campaña rutinaria.

Comprobación antes de continuar

• Detener y delimitar ante emisión anormal.
• Reducir número de expuestos y duración imprescindible.
• Usar protección adecuada al nivel previsto.
• Investigar y evitar repetición.

Idea clave

La intensidad importa: los episodios excepcionales necesitan control tan riguroso como la rutina.'),
  (1, 10, 'Factores que favorecen el polvo', 10, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-10/slide-01.jpg', 'Objetivo

Evaluar la interacción entre material, humedad, clima, maquinaria, pistas y producción.

Explicación detallada

Influyen la naturaleza y humedad de la roca, el proceso productivo, la maquinaria, el estado de las pistas, la climatología, el viento y la posibilidad de aplicar agua. Estos factores deben valorarse para elegir medidas preventivas eficaces. Estos factores interactúan: una pista seca con viento y tráfico intenso puede emitir mucho más que la misma pista húmeda y estabilizada. El análisis debe actualizarse cuando cambien estación, producción, maquinaria o método. Una medida eficaz en invierno puede resultar insuficiente durante un periodo seco y ventoso. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Los factores no actúan aisladamente. Viento, sequedad y tráfico pueden multiplicar emisiones; agua excesiva puede crear barro y riesgo vial. La eficacia de una medida debe comprobarse en distintas estaciones y cargas de producción. Los cambios operativos actualizan la evaluación aunque el equipo sea el mismo.

Caso práctico razonado

El riego que funcionó en invierno resulta insuficiente en verano con viento y más tráfico. La campaña y la frecuencia de riego deben ajustarse a la nueva condición.

Secuencia operativa recomendada

• Registrar clima, humedad y producción durante mediciones.
• Relacionar emisiones con estado de pistas y equipos.
• Revisar medidas en cambios estacionales.
• Controlar riesgos secundarios del agua.

Errores críticos que deben evitarse

• Copiar una frecuencia fija todo el año.
• Aumentar agua sin revisar drenaje y adherencia.
• Ignorar cambios de material o tonelaje.

Comprobación antes de continuar

• Registrar clima, humedad y producción durante mediciones.
• Relacionar emisiones con estado de pistas y equipos.
• Revisar medidas en cambios estacionales.
• Controlar riesgos secundarios del agua.

Idea clave

La medida eficaz es la que se adapta a la condición real y mantiene control sin crear riesgos nuevos.'),
  (2, 1, 'Normativa principal aplicable', 11, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-01/slide-01.jpg', 'Objetivo

Integrar la ITC 02.0.02 con la normativa general de cancerígenos y agentes químicos.

Explicación detallada

La referencia específica en minería es la Orden TED 723 de 2021, que aprueba la ITC 02.0.02. También son aplicables el Real Decreto 665 de 1997 sobre agentes cancerígenos y el Real Decreto 374 de 2001 sobre agentes químicos. La ITC minera convive con la normativa general de agentes cancerígenos, agentes químicos, prevención y equipos de protección. Aplicar la norma más específica no elimina las obligaciones generales. La empresa debe integrar todas ellas en su evaluación y en el Documento sobre Seguridad y Salud, evitando referencias derogadas. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

La Orden TED/723/2021 aporta requisitos mineros específicos, pero no desplaza el RD 665/1997 ni el RD 374/2001. La evaluación debe reflejar la norma aplicable, versiones vigentes y obligaciones más rigurosas. Usar referencias derogadas puede conducir a límites, frecuencias o formación incorrectos.

Caso práctico razonado

Una empresa mantiene un procedimiento basado en la ITC de 2007. Aunque algunas medidas sean útiles, debe actualizar límites, muestreo, ajuste respiratorio y comunicaciones a la norma vigente.

Secuencia operativa recomendada

• Identificar ámbito y norma específica.
• Contrastar texto consolidado y derogaciones.
• Integrar obligaciones en DSS y procedimientos.
• Actualizar documentos, formación y registros.

Errores críticos que deben evitarse

• Citar solo la ITC y omitir cancerígenos.
• Mantener valores de una norma derogada.
• Confundir guía técnica con obligación jurídica.

Comprobación antes de continuar

• Identificar ámbito y norma específica.
• Contrastar texto consolidado y derogaciones.
• Integrar obligaciones en DSS y procedimientos.
• Actualizar documentos, formación y registros.

Idea clave

La prevención se apoya en un marco integrado y actualizado, no en una única norma aislada.'),
  (2, 2, 'La sílice como agente cancerígeno', 12, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-02/slide-01.jpg', 'Objetivo

Aplicar el enfoque de agente cancerígeno: evitar y reducir al nivel más bajo técnicamente posible.

Explicación detallada

Los trabajos que generan exposición a polvo respirable de sílice cristalina están incluidos entre los procedimientos cancerígenos. Por ello, la exposición debe evitarse y, cuando no sea posible, reducirse a un nivel tan bajo como sea técnicamente posible. Esta consideración modifica el enfoque: no basta con mantenerse por debajo de un número. Deben analizarse sustitución, sistemas cerrados, captación en origen, reducción del número de personas expuestas, higiene y vigilancia. Las decisiones han de quedar justificadas y revisarse cuando aparezcan alternativas técnicas mejores. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

Cumplir un límite es requisito mínimo, no licencia para mantener exposición evitable. Deben estudiarse sustitución del proceso, sistemas cerrados, captación, reducción de personas y tiempos, higiene y EPI residual. La viabilidad técnica se revisa al aparecer soluciones mejores.

Caso práctico razonado

Una medición de 0,04 mg/m³ cumple, pero una captación viable puede reducirla a 0,015. La mejora debe evaluarse y no descartarse solo por estar bajo el VLA.

Secuencia operativa recomendada

• Eliminar o sustituir cuando sea posible.
• Controlar el foco y el medio.
• Reducir personas y duración.
• Usar EPI únicamente para riesgo residual o temporal.

Errores críticos que deben evitarse

• Tomar 0,05 como objetivo de operación.
• Retirar medidas tras un resultado favorable.
• Justificar exposición evitable por costumbre.

Comprobación antes de continuar

• Eliminar o sustituir cuando sea posible.
• Controlar el foco y el medio.
• Reducir personas y duración.
• Usar EPI únicamente para riesgo residual o temporal.

Idea clave

Para cancerígenos, “por debajo del límite” y “tan bajo como sea técnicamente posible” son obligaciones simultáneas.'),
  (2, 3, 'Valores límite de exposición diaria', 13, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-03/slide-01.jpg', 'Objetivo

Interpretar simultáneamente los VLA-ED de polvo respirable y SCR.

Explicación detallada

Deben cumplirse simultáneamente dos límites: tres miligramos por metro cúbico para el polvo respirable total y cero coma cero cinco miligramos por metro cúbico para la sílice cristalina respirable. Son límites diarios referidos a una jornada estándar de ocho horas. Los dos valores se comparan por separado y deben cumplirse simultáneamente. Un resultado bajo de polvo total no garantiza que la concentración de sílice sea aceptable si la proporción de SCR es elevada. La interpretación debe considerar incertidumbre analítica, representatividad y jornada real antes de concluir conformidad. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

Los límites son 3 mg/m³ para polvo respirable y 0,05 mg/m³ para SCR, referidos a ocho horas. Se comparan por separado. Una baja concentración de polvo puede incumplir SCR si su proporción es alta. La jornada real se pondera y la decisión debe considerar incertidumbre y representatividad.

Caso práctico razonado

Una muestra arroja 1,2 mg/m³ de polvo respirable y 0,06 mg/m³ de SCR: cumple el primer límite, pero el puesto no es conforme por la sílice.

Secuencia operativa recomendada

• Verificar unidades, fracción y duración.
• Comparar cada resultado con su límite.
• Revisar incertidumbre y condiciones de jornada.
• Adoptar medidas si cualquiera incumple.

Errores críticos que deben evitarse

• Promediar ambos resultados entre sí.
• Concluir conformidad por cumplir polvo total.
• Redondear a la baja una cifra próxima.

Comprobación antes de continuar

• Verificar unidades, fracción y duración.
• Comparar cada resultado con su límite.
• Revisar incertidumbre y condiciones de jornada.
• Adoptar medidas si cualquiera incumple.

Idea clave

Los dos valores deben cumplirse simultáneamente; el más desfavorable gobierna la decisión.'),
  (2, 4, 'El límite no es un objetivo', 14, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-04/slide-01.jpg', 'Objetivo

Usar el límite como frontera legal y no como nivel deseado.

Explicación detallada

Cumplir el valor límite no permite dar por terminado el control. Al tratarse de un agente cancerígeno, la empresa debe reducir la exposición todo lo técnicamente posible y mantener las medidas preventivas, aunque las mediciones estén por debajo del límite. Trabajar cerca del límite deja poco margen frente a variaciones del proceso, viento, fallos de riego o aumento de producción. La mejora continua busca alejarse de esa situación mediante controles estables. Los resultados favorables sirven para confirmar medidas, no para retirar automáticamente barreras que ya funcionan. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

Trabajar cerca del VLA ofrece poco margen ante variaciones de viento, producción o fallo de controles. Las tendencias, no solo los puntos individuales, deben guiar mejora. Un resultado bajo confirma las barreras utilizadas durante esa muestra; retirarlas cambia la situación y anula la inferencia.

Caso práctico razonado

Tres campañas suben de 0,018 a 0,031 y 0,044 mg/m³. Aún cumplen, pero la tendencia exige investigar antes de superar.

Secuencia operativa recomendada

• Analizar series y variabilidad.
• Mantener controles presentes durante la medición.
• Investigar tendencias ascendentes.
• Planificar mejora con responsable y plazo.

Errores críticos que deben evitarse

• Esperar a superar 0,05.
• Retirar riego por resultado favorable.
• Usar el VLA como consigna de producción.

Comprobación antes de continuar

• Analizar series y variabilidad.
• Mantener controles presentes durante la medición.
• Investigar tendencias ascendentes.
• Planificar mejora con responsable y plazo.

Idea clave

La acción preventiva empieza con la tendencia y la causa, no solo después del incumplimiento.'),
  (2, 5, 'Identificación de materiales y tareas', 15, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-05/slide-01.jpg', 'Objetivo

Construir una identificación completa de materiales, tareas, puestos y situaciones anormales.

Explicación detallada

La evaluación comienza identificando materiales con sílice cristalina y tareas que puedan poner polvo respirable en suspensión. Deben incluirse operaciones habituales, mantenimiento, limpiezas, averías, trabajos no regulares y posibles exposiciones procedentes de otras áreas. Una matriz de tareas resulta útil para relacionar material, operación, duración, trabajadores, controles existentes y situaciones anormales. Debe incluir contratistas y puestos indirectos. Después se priorizan los escenarios con mayor potencial de generar SCR y se diseña una estrategia de medición representativa. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

La matriz debe relacionar material, porcentaje de sílice, operación, duración, número de personas, controles, fallos y exposición externa. Debe incluir mantenimiento, limpieza, contratas y accesos esporádicos. Esta base permite formar grupos de exposición y diseñar muestreo representativo.

Caso práctico razonado

La evaluación incluye trituración, pero no el desatasco manual. Un desatasco mensual puede liberar una dosis intensa y debe incorporarse como escenario propio.

Secuencia operativa recomendada

• Inventariar materias primas y productos.
• Descomponer cada puesto en tareas.
• Añadir averías, mantenimiento y limpieza.
• Mapear personas directas, indirectas y contratas.

Errores críticos que deben evitarse

• Usar solo nombres de puestos.
• Excluir tareas infrecuentes.
• Suponer que un análisis de roca sustituye al muestreo.

Comprobación antes de continuar

• Inventariar materias primas y productos.
• Descomponer cada puesto en tareas.
• Añadir averías, mantenimiento y limpieza.
• Mapear personas directas, indirectas y contratas.

Idea clave

Una evaluación útil describe lo que realmente se hace, también cuando el proceso deja de funcionar con normalidad.'),
  (2, 6, 'Muestreo personal en la zona de respiración', 16, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-06/slide-01.jpg', 'Objetivo

Comprender el muestreo personal en la zona de respiración y la función del personal competente.

Explicación detallada

La exposición se mide con equipos personales portados por el trabajador. El muestreador se coloca en su zona de respiración y la estrategia debe ser representativa de la actividad real. La toma la realiza personal competente y no el propio trabajador. El cabezal debe situarse correctamente y permanecer sin obstrucciones durante la jornada. El personal competente registra caudal, tiempos, incidencias y tareas realizadas. Si el trabajador cambia de zona o se produce una parada, esa información permite interpretar el resultado en lugar de tratarlo como un dato aislado. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

El muestreador debe acompañar al trabajador y situarse en la semiesfera de respiración, sin quedar tapado. El personal competente calibra, observa, registra tareas e incidencias y permanece durante el muestreo. Un captador fijo en la instalación puede caracterizar ambiente, pero no sustituye la medición personal exigida.

Caso práctico razonado

Un operador se quita el equipo durante una pausa y lo deja cerca de la trituradora: el resultado deja de representar su exposición y la incidencia debe registrarse.

Secuencia operativa recomendada

• Calibrar y montar el conjunto correctamente.
• Colocar el cabezal en la zona de respiración.
• Acompañar tareas reales y registrar cambios.
• Comprobar caudal y tratar incidencias.

Errores críticos que deben evitarse

• Colgar el muestreador en la cabina vacía.
• Dejar al trabajador gestionar solo la muestra.
• Ocultar el cabezal bajo ropa.

Comprobación antes de continuar

• Calibrar y montar el conjunto correctamente.
• Colocar el cabezal en la zona de respiración.
• Acompañar tareas reales y registrar cambios.
• Comprobar caudal y tratar incidencias.

Idea clave

La muestra válida sigue a la persona y documenta fielmente su jornada.'),
  (2, 7, 'Duración y representatividad de la muestra', 17, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-07/slide-01.jpg', 'Objetivo

Garantizar que duración y estrategia representen la jornada completa.

Explicación detallada

La toma de muestras debe extenderse a toda la jornada de trabajo. Solo puede reducirse excepcionalmente por exigencias analíticas, dejando constancia de la incidencia y garantizando que la muestra siga siendo suficiente y representativa de la exposición diaria. La representatividad exige cubrir las fases que definen la exposición habitual. Si la muestra se acorta por saturación, debe justificarse y seguir describiendo la jornada completa mediante una estrategia técnicamente válida. Una medición cómoda pero ajena al trabajo real puede conducir a decisiones preventivas equivocadas. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

La regla general es muestrear toda la jornada. Solo se reduce excepcionalmente por exigencias analíticas como saturación, dejando constancia y conservando representatividad de la actividad total. Elegir solo la fase limpia sesga el resultado aunque el tiempo sea largo.

Caso práctico razonado

Una muestra de cuatro horas cubre solo la mañana húmeda y omite la tarde seca con carga máxima: no representa la exposición diaria.

Secuencia operativa recomendada

• Planificar cobertura de todas las fases.
• Registrar tiempos y tareas.
• Justificar cualquier reducción excepcional.
• Interpretar jornada real y referencia de ocho horas.

Errores críticos que deben evitarse

• Muestrear la franja más cómoda.
• Eliminar picos para evitar saturación sin justificar.
• Extrapolar sin base técnica.

Comprobación antes de continuar

• Planificar cobertura de todas las fases.
• Registrar tiempos y tareas.
• Justificar cualquier reducción excepcional.
• Interpretar jornada real y referencia de ocho horas.

Idea clave

La representatividad depende de cubrir la variabilidad, no solo de acumular minutos.'),
  (2, 8, 'Frecuencia de las mediciones', 18, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-08/slide-01.jpg', 'Objetivo

Aplicar la frecuencia mínima cuatrimestral y ampliarla cuando el riesgo lo requiera.

Explicación detallada

En los puestos con riesgo de exposición a polvo se tomarán muestras, como mínimo, una vez cada cuatrimestre del año natural. Los análisis los realiza el Instituto Nacional de Silicosis o un laboratorio reconocido por la Autoridad Minera. La frecuencia mínima cuatrimestral no impide medir más cuando cambian condiciones, fallan controles o existe incertidumbre. Las campañas deben repartirse de forma que recojan variabilidad estacional y productiva. Repetir siempre el muestreo en el momento más favorable reduciría su utilidad preventiva. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

“Una vez cada cuatrimestre del año natural” implica al menos tres campañas distribuidas. Es un mínimo, no una prohibición de medir tras cambios, fallos o incertidumbre. Seleccionar siempre días favorables reduce la capacidad de detectar variabilidad estacional.

Caso práctico razonado

Las tres muestras se realizan en días lluviosos pese a que la mayor producción ocurre en verano. La frecuencia formal se cumple, pero la estrategia puede no ser representativa.

Secuencia operativa recomendada

• Distribuir campañas por cuatrimestres.
• Capturar estaciones y condiciones relevantes.
• Añadir mediciones tras cambios o fallos.
• Usar laboratorios reconocidos.

Errores críticos que deben evitarse

• Concentrar campañas en el mismo mes.
• Elegir solo condiciones favorables.
• Esperar al siguiente cuatrimestre tras una avería grave.

Comprobación antes de continuar

• Distribuir campañas por cuatrimestres.
• Capturar estaciones y condiciones relevantes.
• Añadir mediciones tras cambios o fallos.
• Usar laboratorios reconocidos.

Idea clave

Cumplir calendario no basta: cada campaña debe aportar evidencia representativa.'),
  (2, 9, 'Revisión de la evaluación de riesgos', 19, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-09/slide-01.jpg', 'Objetivo

Revisar la evaluación por cambios, daños o ineficacia y, en todo caso, cada tres años.

Explicación detallada

La evaluación se revisa cuando cambian las condiciones, aparecen daños para la salud o las medidas resultan insuficientes. En minería, la ITC exige además revisarla en todo caso cada tres años, sin esperar a que ocurra un incidente. La revisión trienal es un máximo ordinario, no una espera obligatoria. Una nueva trituradora, un cambio de material, un diagnóstico relacionado o resultados crecientes exigen actuar antes. Revisar significa volver a comprobar peligros, exposición y eficacia de controles, y actualizar medidas y documentación. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

El plazo trienal es máximo ordinario. Cambiar material, proceso, producción, control, diagnóstico o tendencia puede exigir revisión inmediata. Revisar no significa cambiar la fecha: implica reconsiderar peligros, grupos, mediciones, eficacia y medidas.

Caso práctico razonado

Se instala una trituradora nueva seis meses después de la última evaluación. No se espera dos años y medio; se revisa antes de exponer.

Secuencia operativa recomendada

• Definir disparadores de revisión.
• Reevaluar antes de cambios planificados.
• Incorporar resultados sanitarios y ambientales.
• Actualizar DSS, procedimientos y formación.

Errores críticos que deben evitarse

• Esperar siempre tres años.
• Limitarse a cambiar la portada.
• Revisar solo tras accidente.

Comprobación antes de continuar

• Definir disparadores de revisión.
• Reevaluar antes de cambios planificados.
• Incorporar resultados sanitarios y ambientales.
• Actualizar DSS, procedimientos y formación.

Idea clave

Cada tres años es el máximo; cualquier cambio relevante adelanta la revisión.'),
  (2, 10, 'Información individual sobre la exposición', 20, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-10/slide-01.jpg', 'Objetivo

Comunicar resultados individuales de manera comprensible y conservar trazabilidad con confidencialidad sanitaria.

Explicación detallada

Cada trabajador debe conocer los riesgos de su puesto, los resultados que le afecten y las medidas implantadas. Los valores de exposición se registran periódicamente en fichas individualizadas para conocer el riesgo acumulado y se incorporan al expediente médico. La comunicación debe ser comprensible y relacionar el dato con el puesto y las medidas necesarias. No basta con entregar una cifra sin contexto. La trazabilidad individual permite observar tendencias y vincular tareas, resultados y vigilancia sanitaria respetando la confidencialidad de la información médica. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

El trabajador debe conocer qué se midió, en qué tarea, qué resultado le afecta, cómo se interpreta y qué medidas siguen. Las fichas individualizadas se integran en su expediente médico, pero los datos sanitarios tienen acceso reservado. La comunicación preventiva no consiste en entregar una cifra sin contexto.

Caso práctico razonado

Un trabajador recibe “0,038 mg/m³” sin explicar tarea ni controles. No puede valorar significado ni saber qué conducta mantener; la información es incompleta.

Secuencia operativa recomendada

• Relacionar resultado, jornada y tarea.
• Explicar comparación y tendencia.
• Informar medidas y acciones previstas.
• Proteger confidencialidad médica.

Errores críticos que deben evitarse

• Publicar expedientes médicos.
• Comunicar solo si hay incumplimiento.
• Entregar cifras sin explicación.

Comprobación antes de continuar

• Relacionar resultado, jornada y tarea.
• Explicar comparación y tendencia.
• Informar medidas y acciones previstas.
• Proteger confidencialidad médica.

Idea clave

La transparencia preventiva exige contexto; la confidencialidad protege la información sanitaria, no oculta la exposición.'),
  (3, 1, 'Jerarquía de medidas preventivas', 21, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-01/slide-01.jpg', 'Objetivo

Aplicar la jerarquía: evitar, controlar en origen y medio, organizar y proteger el riesgo residual.

Explicación detallada

La prioridad es evitar la generación de polvo o reducirla en el foco. Después se actúa sobre el medio de propagación y, por último, sobre el trabajador. La protección respiratoria complementa estas medidas, pero no puede sustituirlas. La jerarquía evita convertir la mascarilla en solución automática. Primero se elimina o reduce el foco; después se encierra, capta o asienta el contaminante; a continuación se limita la exposición mediante organización; y solo como complemento se selecciona protección respiratoria adecuada al riesgo residual. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La mascarilla no debe convertirse en respuesta automática. Se prioriza eliminar o modificar el proceso; después cerramiento, captación o vía húmeda; luego separación, tiempo y acceso; por último EPI durante el tiempo imprescindible. Las capas se complementan y su eficacia se verifica.

Caso práctico razonado

Una perforadora emite polvo por una boquilla obstruida. Entregar mascarillas sin reparar el riego mantiene un foco evitable y contradice la jerarquía.

Secuencia operativa recomendada

• Identificar si puede evitarse la tarea o emisión.
• Actuar en el foco.
• Controlar propagación y acceso.
• Seleccionar EPI para el riesgo residual.

Errores críticos que deben evitarse

• Sustituir mantenimiento por EPI.
• Elegir primero la solución más barata.
• Retirar controles colectivos al usar mascarilla.

Comprobación antes de continuar

• Identificar si puede evitarse la tarea o emisión.
• Actuar en el foco.
• Controlar propagación y acceso.
• Seleccionar EPI para el riesgo residual.

Idea clave

El EPI protege a una persona; el control en origen evita que el contaminante alcance a todas.'),
  (3, 2, 'Sustitución y modificación del proceso', 22, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-02/slide-01.jpg', 'Objetivo

Reducir emisión modificando material, método, herramienta, velocidad, caída o secuencia.

Explicación detallada

Cuando sea técnicamente posible, deben sustituirse materiales o procedimientos por otros menos peligrosos. En minería la sustitución de la roca suele ser inviable, pero sí pueden modificarse métodos, herramientas, velocidades o secuencias para generar menos polvo. Aunque no pueda sustituirse el mineral, sí pueden compararse herramientas, métodos húmedos, velocidades de corte, alturas de caída o secuencias de apertura. Cada cambio debe evaluarse de forma global para no crear otros riesgos, como proyecciones, resbalones, atrapamientos o contaminación del agua. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Aunque no pueda sustituirse la roca, casi siempre pueden compararse métodos. El cambio se evalúa globalmente para evitar riesgos secundarios: agua y electricidad, barro, atrapamiento, proyección o residuo contaminado. La mejora se valida mediante observación, mantenimiento y medición.

Caso práctico razonado

Reducir altura de caída baja polvo, pero desplaza un punto de trabajo hacia una zona de atrapamiento. La solución debe rediseñarse sin intercambiar un riesgo por otro.

Secuencia operativa recomendada

• Generar varias alternativas técnicas.
• Comparar emisión y exposición esperada.
• Evaluar riesgos secundarios.
• Probar, medir y documentar la opción.

Errores críticos que deben evitarse

• Cambiar sin evaluar seguridad global.
• Descartar cambios porque la roca no es sustituible.
• Dar por eficaz una prueba visual.

Comprobación antes de continuar

• Generar varias alternativas técnicas.
• Comparar emisión y exposición esperada.
• Evaluar riesgos secundarios.
• Probar, medir y documentar la opción.

Idea clave

Modificar el proceso es prevención en origen solo si reduce la exposición sin crear un riesgo mayor.'),
  (3, 3, 'Confinamiento y cerramientos', 23, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-03/slide-01.jpg', 'Objetivo

Mantener confinamientos íntegros y compatibles con captación, acceso y limpieza.

Explicación detallada

Carenados, capotajes y cerramientos limitan la dispersión del polvo en trituradoras, cintas y puntos de transferencia. Para ser eficaces deben mantenerse íntegros, combinarse cuando proceda con aspiración y abrirse solo siguiendo el procedimiento establecido. Un cerramiento con huecos, tapas abiertas o juntas deterioradas pierde eficacia. También puede generar acumulaciones que después se liberan durante el mantenimiento. La inspección práctica debe comprobar integridad, depresión cuando proceda, acceso seguro y un método de limpieza que no vuelva a dispersar el polvo. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Un cerramiento necesita juntas, tapas y conductos en buen estado y, cuando procede, depresión suficiente. Abrirlo altera el flujo y puede liberar acumulaciones. Mantenimiento y limpieza deben planificarse con parada, aislamiento, aspiración y protección residual.

Caso práctico razonado

Una tapa queda abierta para observar el material. La aspiración continúa, pero el punto de entrada de aire cambia y puede escapar polvo hacia el trabajador.

Secuencia operativa recomendada

• Inspeccionar integridad y cierres.
• Verificar depresión o caudal de captación.
• Mantener accesos cerrados durante operación.
• Planificar apertura y limpieza segura.

Errores críticos que deben evitarse

• Retirar paneles para mejorar acceso.
• Sellar sin prever mantenimiento.
• Barrer acumulaciones del interior.

Comprobación antes de continuar

• Inspeccionar integridad y cierres.
• Verificar depresión o caudal de captación.
• Mantener accesos cerrados durante operación.
• Planificar apertura y limpieza segura.

Idea clave

Un cerramiento solo protege si conserva su geometría y se abre bajo procedimiento.'),
  (3, 4, 'Cabinas cerradas y presurizadas', 24, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-04/slide-01.jpg', 'Objetivo

Conservar la protección de cabinas mediante cierre, filtración, presurización y limpieza controlada.

Explicación detallada

Las cabinas cerradas, con filtración y presión positiva, aíslan al operador del ambiente contaminado. Su eficacia depende de mantener puertas y ventanas cerradas, revisar juntas y filtros y comprobar que el sistema funciona durante toda la tarea. La presión positiva solo protege si el caudal de aire filtrado compensa las entradas no controladas. Abrir una ventana, usar un filtro saturado o mantener una puerta con juntas dañadas puede anular el sistema. El operador debe reconocer indicadores de fallo y comunicar cualquier pérdida de estanqueidad. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La presión positiva evita entrada de polvo si puertas, ventanas y sellos están cerrados. Filtros saturados, fugas o climatización mal mantenida reducen el diferencial. Introducir ropa contaminada o barrer la cabina crea una fuente interior que la presurización no elimina.

Caso práctico razonado

Un operador abre la ventana por calor. Aunque el filtro sea nuevo, anula la barrera de presión y recibe aire sin filtrar.

Secuencia operativa recomendada

• Comprobar indicador o diferencial de presión.
• Revisar filtros, juntas y puertas.
• Mantener ventanas cerradas.
• Limpiar interior con aspiración adecuada.

Errores críticos que deben evitarse

• Abrir para desempañar.
• Sacudir ropa dentro.
• Cambiar filtro solo cuando se vea polvo.

Comprobación antes de continuar

• Comprobar indicador o diferencial de presión.
• Revisar filtros, juntas y puertas.
• Mantener ventanas cerradas.
• Limpiar interior con aspiración adecuada.

Idea clave

La cabina es un sistema de protección, no solo un habitáculo cerrado.'),
  (3, 5, 'Control por vía húmeda', 25, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-05/slide-01.jpg', 'Objetivo

Aplicar agua en cantidad, tamaño de gota y punto adecuados sin generar riesgos secundarios.

Explicación detallada

La inyección, pulverización o niebla de agua ayuda a impedir que las partículas pasen al aire y favorece su sedimentación. El sistema debe aplicarse en el punto adecuado y mantenerse operativo, evitando que el agua cree nuevos riesgos. Más agua no siempre significa mejor control. Deben ajustarse tamaño de gota, orientación, caudal y punto de aplicación al polvo generado. También se vigilan barro, visibilidad, estabilidad del firme, heladas y consumo. Una boquilla obstruida o mal orientada puede dejar el foco prácticamente sin protección. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La humectación evita que el material genere aerosol y la pulverización captura o asienta. Boquillas obstruidas, mala orientación o presión insuficiente dejan zonas secas. Demasiada agua puede crear barro, resbalones, drenajes contaminados o afectar al proceso.

Caso práctico razonado

El manómetro indica presión normal, pero varias boquillas están taponadas. El indicador general no demuestra cobertura efectiva; hay que observar el patrón.

Secuencia operativa recomendada

• Verificar suministro, presión y cobertura.
• Orientar al foco y sincronizar con proceso.
• Mantener boquillas limpias.
• Controlar drenaje, barro y calidad del producto.

Errores críticos que deben evitarse

• Regar solo cuando se ve nube.
• Aumentar caudal sin límite.
• Confiar únicamente en el manómetro.

Comprobación antes de continuar

• Verificar suministro, presión y cobertura.
• Orientar al foco y sincronizar con proceso.
• Mantener boquillas limpias.
• Controlar drenaje, barro y calidad del producto.

Idea clave

La vía húmeda se valida por cobertura efectiva del foco y control de sus consecuencias.'),
  (3, 6, 'Captación y aspiración localizada', 26, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-06/slide-01.jpg', 'Objetivo

Capturar el polvo cerca del foco con caudal y diseño compatibles con la emisión.

Explicación detallada

La aspiración localizada captura el polvo cerca del punto de generación antes de que alcance la zona de respiración. Campanas, conductos, filtros y separadores deben dimensionarse, revisarse y mantenerse para conservar el caudal y la eficacia previstos. La campana debe estar próxima al foco y el aire captado debe conducirse y filtrarse sin fugas. Pérdidas de carga, conductos rotos o filtros colmatados reducen el caudal. La verificación combina inspección, indicadores de presión y, cuando proceda, medición del rendimiento del sistema. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La aspiración localizada necesita velocidad de captura, proximidad, conductos estancos, filtros y descarga segura. Alejar la campana reduce rápidamente eficacia. Abrir cerramientos o aumentar producción puede superar el caudal disponible. El mantenimiento se hace sin liberar el polvo capturado.

Caso práctico razonado

Se aumenta el tonelaje un 30 % y aparece emisión pese a que el ventilador funciona. El sistema puede haber quedado subdimensionado y debe reevaluarse.

Secuencia operativa recomendada

• Comprobar posición de campana.
• Verificar caudal/depresión y conductos.
• Revisar filtros y alarmas.
• Reevaluar tras cambios de producción.

Errores críticos que deben evitarse

• Confundir ventilación general con captación.
• Vaciar filtros sin control.
• Aceptar emisión porque el motor gira.

Comprobación antes de continuar

• Comprobar posición de campana.
• Verificar caudal/depresión y conductos.
• Revisar filtros y alarmas.
• Reevaluar tras cambios de producción.

Idea clave

Que el ventilador funcione no prueba que el contaminante sea capturado.'),
  (3, 7, 'Pistas, transporte y acopios', 27, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-07/slide-01.jpg', 'Objetivo

Controlar emisiones de pistas, transporte y acopios mediante firme, agua, velocidad y geometría.

Explicación detallada

El riego o estabilización de pistas, la limitación de velocidad, la limpieza de ruedas y el cubrimiento de cargas reducen las emisiones del transporte. Los acopios pueden protegerse del viento y gestionarse para evitar caídas y manipulaciones innecesarias. El control del transporte exige coordinar riego, mantenimiento de firme, velocidad y limpieza. Regar sin reparar baches puede generar barro y pérdida de control; limitar velocidad sin supervisión puede no funcionar. En acopios, la altura de caída y la orientación respecto al viento son variables decisivas. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

El tráfico resuspende finos. Riego, estabilización, reparación, limpieza de derrames y velocidad actúan juntos. En acopios importan altura de caída, humedad y orientación al viento. La medida debe evitar barro, pérdida de adherencia y contaminación del agua.

Caso práctico razonado

Regar una pista con baches crea charcos y barro; reducir polvo a costa de perder control del vehículo no es aceptable.

Secuencia operativa recomendada

• Mantener firme y drenaje.
• Ajustar riego a clima y tráfico.
• Controlar velocidad y derrames.
• Reducir altura de caída y exposición al viento.

Errores críticos que deben evitarse

• Usar solo una señal de velocidad.
• Regar sin revisar adherencia.
• Dejar finos acumulados en bordes.

Comprobación antes de continuar

• Mantener firme y drenaje.
• Ajustar riego a clima y tráfico.
• Controlar velocidad y derrames.
• Reducir altura de caída y exposición al viento.

Idea clave

Las emisiones difusas se controlan con un sistema coordinado, no con una medida aislada.'),
  (3, 8, 'Limpieza segura', 28, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-08/slide-01.jpg', 'Objetivo

Limpiar sin volver a poner el contaminante en suspensión ni trasladarlo.

Explicación detallada

La limpieza debe realizarse por aspiración industrial o por vía húmeda. Barrer en seco o utilizar aire comprimido vuelve a poner el polvo en suspensión y aumenta la exposición, por lo que estas prácticas deben evitarse salvo procedimiento específicamente controlado. La aspiración debe ser apta para el polvo recogido y mantenerse conforme al fabricante. En limpieza húmeda se evita crear salpicaduras o arrastres contaminados. Antes de intervenir se planifica dónde irá el residuo y cómo se limpiará el propio equipo sin exponer nuevamente al trabajador. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La aspiración industrial adecuada o la vía húmeda son métodos preferentes. Aire comprimido y barrido seco dispersan el polvo y contaminan superficies cercanas. Debe definirse el destino del residuo y cómo se descontamina el propio aspirador o útil.

Caso práctico razonado

Un operario barre al final del turno cuando no hay producción. Aunque haya menos personas, genera exposición propia y contaminación residual.

Secuencia operativa recomendada

• Planificar área, método y residuo.
• Usar aspiración apta o vía húmeda.
• Delimitar y proteger según riesgo residual.
• Limpiar equipos sin dispersar.

Errores críticos que deben evitarse

• Barrer cuando no haya supervisión.
• Soplar ropa con aire.
• Vaciar aspirador en saco abierto.

Comprobación antes de continuar

• Planificar área, método y residuo.
• Usar aspiración apta o vía húmeda.
• Delimitar y proteger según riesgo residual.
• Limpiar equipos sin dispersar.

Idea clave

La limpieza elimina polvo; si lo suspende de nuevo, traslada el riesgo en vez de controlarlo.'),
  (3, 9, 'Mantenimiento de las medidas de control', 29, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-09/slide-01.jpg', 'Objetivo

Convertir el mantenimiento de controles en comprobaciones con criterios de aceptación y parada.

Explicación detallada

Una medida preventiva solo protege si funciona. Deben revisarse boquillas, captaciones, filtros, cerramientos, cabinas y sistemas de riego. Cualquier fallo se comunica y corrige antes de continuar si compromete el control de la exposición. El mantenimiento preventivo debe definir responsable, frecuencia, criterio de aceptación y registro. No basta con anotar que se ha revisado. Una lista útil obliga a comprobar caudal, presión, estado de filtros, boquillas, puertas y alarmas, y establece qué fallos requieren detener la tarea. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Una lista útil define qué se mide, rango aceptable, responsable, frecuencia y acción. “Revisado” no demuestra caudal, presión, saturación o cierre. El mantenimiento preventivo evita que la exposición sea el primer indicador del fallo.

Caso práctico razonado

Una boquilla se anota como revisada, pero no se registra patrón ni presión. No hay evidencia de que controle el foco.

Secuencia operativa recomendada

• Definir parámetro y rango.
• Inspeccionar con frecuencia basada en fallo.
• Registrar resultado, no solo firma.
• Establecer criterio de parada y reparación.

Errores críticos que deben evitarse

• Usar la nube como alarma de mantenimiento.
• Posponer defectos al mantenimiento anual.
• Aceptar controles sin indicadores.

Comprobación antes de continuar

• Definir parámetro y rango.
• Inspeccionar con frecuencia basada en fallo.
• Registrar resultado, no solo firma.
• Establecer criterio de parada y reparación.

Idea clave

Una barrera preventiva necesita condición verificable y respuesta definida cuando falla.'),
  (3, 10, 'Exposición accidental o no regular', 30, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-10/slide-01.jpg', 'Objetivo

Planificar averías, reparaciones e inspecciones como exposiciones no regulares de potencial elevado.

Explicación detallada

En averías, reparaciones, inspecciones y limpiezas extraordinarias puede aumentar la exposición. Se limitará el acceso a personal autorizado, se reducirá el tiempo imprescindible y se usarán medidas técnicas y protección respiratoria adecuadas al riesgo. Estas situaciones requieren planificación previa: delimitar la zona, informar al personal, reducir el número de expuestos y elegir controles temporales. Al finalizar se realiza limpieza segura y se verifica la recuperación del control normal. La urgencia de una reparación no elimina el riesgo cancerígeno. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Se limita acceso, número y tiempo; se aíslan energías; se aplican captación o humedad temporal; se selecciona EPI por concentración prevista y se limpia antes de reabrir. La urgencia productiva no reduce carcinogenicidad ni justifica exposición desconocida.

Caso práctico razonado

Una tubería de aspiración se rompe y mantenimiento entra sin delimitar porque la reparación durará cinco minutos. La corta duración no elimina el pico ni la dispersión.

Secuencia operativa recomendada

• Parar y delimitar.
• Evaluar tarea y concentración potencial.
• Autorizar personal mínimo con controles y EPI.
• Verificar limpieza y recuperación antes de abrir.

Errores críticos que deben evitarse

• Entrar por ser reparación breve.
• Usar mascarilla no seleccionada.
• Reabrir sin verificar control.

Comprobación antes de continuar

• Parar y delimitar.
• Evaluar tarea y concentración potencial.
• Autorizar personal mínimo con controles y EPI.
• Verificar limpieza y recuperación antes de abrir.

Idea clave

Las tareas excepcionales se planifican antes del fallo y se controlan hasta recuperar la condición normal.'),
  (4, 1, 'Cuándo utilizar protección respiratoria', 31, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-01/slide-01.jpg', 'Objetivo

Definir cuándo el EPI respiratorio es necesario y por qué su uso debe limitarse al riesgo residual.

Explicación detallada

La protección respiratoria se utiliza cuando las medidas técnicas y organizativas no eliminan suficientemente el riesgo, durante exposiciones accidentales o mientras se implantan soluciones más eficaces. Su uso debe limitarse al tiempo imprescindible y ajustarse a la evaluación. La decisión debe indicar para qué tarea, durante cuánto tiempo y con qué factor de protección se utiliza el equipo. Si la exposición es desconocida o puede ser muy alta, una mascarilla filtrante sencilla puede resultar insuficiente. La selección corresponde a la evaluación, no a la preferencia personal. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La evaluación determina tarea, concentración, tiempo y factor de protección. En condiciones desconocidas o muy altas puede requerirse un equipo distinto de una mascarilla filtrante. El EPI se usa durante implantación de controles, exposición accidental o insuficiencia residual, sin sustituir la corrección del foco.

Caso práctico razonado

Tras fallo de aspiración, se propone trabajar todo el turno con FFP2. Sin estimar concentración ni corregir el sistema, no puede asegurarse protección suficiente.

Secuencia operativa recomendada

• Caracterizar contaminante y concentración.
• Seleccionar factor de protección necesario.
• Limitar duración y usuarios.
• Corregir la medida colectiva.

Errores críticos que deben evitarse

• Elegir por comodidad.
• Usar el EPI como solución permanente.
• Entrar con concentración desconocida.

Comprobación antes de continuar

• Caracterizar contaminante y concentración.
• Seleccionar factor de protección necesario.
• Limitar duración y usuarios.
• Corregir la medida colectiva.

Idea clave

El equipo respiratorio se selecciona por riesgo evaluado; no convierte un ambiente desconocido en seguro.'),
  (4, 2, 'Selección del equipo adecuado', 32, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-02/slide-01.jpg', 'Objetivo

Seleccionar pieza facial, filtro o equipo asistido según exposición, tarea y persona.

Explicación detallada

El tipo de mascarilla, filtro o equipo asistido debe elegirse según la concentración, la tarea, el tiempo de uso y las características del trabajador. No todos los equipos protegen igual ni resultan adecuados para cualquier nivel de exposición. Además del contaminante se valoran esfuerzo físico, temperatura, compatibilidad con gafas o casco y posibles limitaciones médicas. El equipo debe disponer de marcado y documentación aplicables. Un filtro adecuado instalado en una pieza facial que no ajusta sigue ofreciendo una protección deficiente. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

Además del factor de protección se consideran esfuerzo, calor, duración, visión, comunicación, gafas, casco y limitaciones médicas. El marcado y la documentación deben corresponder al uso. Un filtro correcto con fuga facial no alcanza la protección nominal.

Caso práctico razonado

Un trabajador realiza esfuerzo intenso durante dos horas y no tolera bien la resistencia respiratoria. Debe valorarse un equipo asistido u otra solución, no aflojar la mascarilla.

Secuencia operativa recomendada

• Definir factor necesario.
• Evaluar ergonomía y compatibilidad.
• Comprobar documentación y talla.
• Validar ajuste individual y formación.

Errores críticos que deben evitarse

• Elegir un modelo universal.
• Compartir sin descontaminar.
• Aflojar correas para respirar mejor.

Comprobación antes de continuar

• Definir factor necesario.
• Evaluar ergonomía y compatibilidad.
• Comprobar documentación y talla.
• Validar ajuste individual y formación.

Idea clave

La selección correcta combina nivel de protección y capacidad real de uso durante toda la tarea.'),
  (4, 3, 'Ajuste y estanqueidad facial', 33, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-03/slide-01.jpg', 'Objetivo

Garantizar estanqueidad mediante ensayo cuantitativo y comprobación diaria de sellado.

Explicación detallada

Un equipo filtrante solo protege si sella correctamente sobre la cara. Debe realizarse el control de ajuste indicado y la formación práctica incluirá ensayos cuantitativos. Barba, patillas, suciedad o una talla incorrecta pueden romper la estanqueidad. El ensayo cuantitativo comprueba con una medida objetiva si un modelo y talla concretos sellan en esa persona. Debe repetirse cuando cambia la pieza facial o existen cambios físicos relevantes. La comprobación diaria de sellado complementa el ensayo, pero no lo sustituye. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

El ensayo cuantitativo verifica un modelo y talla en una persona; no se transfiere a otra. Se repite tras cambios de pieza facial o cambios físicos relevantes. Barba, patillas, cicatrices, suciedad o gafas interfiriendo rompen el sello. La comprobación diaria no sustituye al ensayo.

Caso práctico razonado

Un trabajador supera el ensayo afeitado y semanas después lleva barba en la línea de sellado. El resultado anterior deja de garantizar estanqueidad.

Secuencia operativa recomendada

• Elegir modelo/talla individual.
• Realizar ensayo cuantitativo.
• Mantener zona de sellado libre.
• Comprobar sellado en cada colocación.

Errores críticos que deben evitarse

• Aprobar por talla de ropa.
• Compartir resultado de ajuste.
• Confiar solo en presión manual.

Comprobación antes de continuar

• Elegir modelo/talla individual.
• Realizar ensayo cuantitativo.
• Mantener zona de sellado libre.
• Comprobar sellado en cada colocación.

Idea clave

El ajuste pertenece al conjunto persona-modelo-talla-condición facial.'),
  (4, 4, 'Colocación, retirada y conservación', 34, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-04/slide-01.jpg', 'Objetivo

Colocar antes de entrar, retirar fuera, descontaminar y almacenar sin deformar ni contaminar.

Explicación detallada

El equipo se coloca antes de entrar en la zona contaminada y se retira después de salir. Debe limpiarse, revisarse, almacenarse protegido y sustituir filtros o componentes según las instrucciones, sin compartirlo si no está previsto y descontaminado. La retirada es un momento crítico porque la superficie exterior puede estar contaminada. Se siguen pasos que eviten tocar cara y vías respiratorias, y después se limpia o desecha según el tipo. El almacenamiento protege de polvo, humedad, deformación, luz y productos químicos. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La superficie exterior puede contener SCR. La retirada evita tocar cara y parte interna; el filtro se cambia por criterio de fabricante/evaluación, no solo cuando se nota resistencia. El almacenamiento protege de polvo, humedad, luz, productos químicos y deformación.

Caso práctico razonado

Una mascarilla reutilizable se deja abierta sobre el salpicadero. El interior puede contaminarse y el calor deformar el sello.

Secuencia operativa recomendada

• Inspeccionar antes de usar.
• Colocar y comprobar en zona limpia.
• Retirar fuera evitando contacto contaminado.
• Limpiar, secar y guardar protegido.

Errores críticos que deben evitarse

• Retirar dentro para hablar.
• Lavar filtros no lavables.
• Guardar en bolsa contaminada.

Comprobación antes de continuar

• Inspeccionar antes de usar.
• Colocar y comprobar en zona limpia.
• Retirar fuera evitando contacto contaminado.
• Limpiar, secar y guardar protegido.

Idea clave

La protección continúa dependiendo del equipo cuando ya no se lleva: conservación y retirada son parte del uso.'),
  (4, 5, 'Higiene personal', 35, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-05/slide-01.jpg', 'Objetivo

Evitar ingestión y traslado del contaminante mediante separación limpia/sucia e higiene.

Explicación detallada

En las zonas con riesgo no se debe comer, beber ni fumar. Hay que lavarse antes de las pausas y al terminar, usar las instalaciones higiénicas previstas y evitar trasladar polvo a comedores, vehículos, viviendas u otras zonas limpias. La separación entre zonas limpias y sucias reduce la ingestión y el traslado de contaminante. Lavarse manos y cara, ducharse cuando proceda y respetar vestuarios separados forman parte del control. Comer dentro de la cabina solo sería admisible si el procedimiento garantiza realmente una zona limpia. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

No se come, bebe o fuma en zonas de riesgo. Lavado, duchas cuando proceda y vestuarios separados cortan la vía de transferencia. Una cabina solo es zona limpia si se mantiene cerrada, filtrada y sin contaminación interior; no basta con estar aislada visualmente.

Caso práctico razonado

Un operador come en una cabina con polvo en superficies y ropa contaminada. La presurización no elimina la contaminación ya introducida.

Secuencia operativa recomendada

• Respetar zonas de higiene.
• Lavarse antes de pausas.
• Mantener comedores y cabinas limpios.
• Evitar traslado a vehículos y hogares.

Errores críticos que deben evitarse

• Comer con guantes.
• Usar aire para limpiar ropa.
• Guardar comida junto a EPI.

Comprobación antes de continuar

• Respetar zonas de higiene.
• Lavarse antes de pausas.
• Mantener comedores y cabinas limpios.
• Evitar traslado a vehículos y hogares.

Idea clave

La higiene impide que el polvo pase de la zona de trabajo al organismo y a espacios limpios.'),
  (4, 6, 'Ropa de trabajo y descontaminación', 36, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-06/slide-01.jpg', 'Objetivo

Gestionar ropa contaminada sin liberar polvo ni llevarlo al domicilio.

Explicación detallada

La empresa debe proporcionar ropa de protección cuando proceda y organizar su limpieza o descontaminación. La ropa contaminada no debe llevarse a casa. Se guardará separada de la ropa de calle y se manipulará evitando liberar polvo. La ropa no debe sacudirse ni limpiarse con aire comprimido. Se retira siguiendo un método que limite la dispersión, se deposita en recipientes definidos y se lava por un sistema gestionado por la empresa. La familia del trabajador no debe quedar expuesta por contaminación doméstica. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La empresa organiza retirada, almacenamiento, transporte y lavado. La ropa de calle se separa; las prendas no se sacuden ni se soplan; los recipientes evitan dispersión y se identifican. La contaminación doméstica puede exponer a familiares ajenos al trabajo.

Caso práctico razonado

Un trabajador lleva el mono en una bolsa a casa para lavarlo. Aunque vaya cerrado, traslada la responsabilidad y el contaminante fuera del sistema empresarial.

Secuencia operativa recomendada

• Retirar sin sacudir.
• Depositar en recipiente definido.
• Separar de ropa de calle.
• Gestionar limpieza por la empresa.

Errores críticos que deben evitarse

• Lavar junto a ropa familiar.
• Soplar antes de guardar.
• Reutilizar hasta que se vea sucio.

Comprobación antes de continuar

• Retirar sin sacudir.
• Depositar en recipiente definido.
• Separar de ropa de calle.
• Gestionar limpieza por la empresa.

Idea clave

La ropa de trabajo contaminada no abandona el circuito de descontaminación de la empresa.'),
  (4, 7, 'Vigilancia específica de la salud', 37, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-07/slide-01.jpg', 'Objetivo

Entender la vigilancia sanitaria específica como detección precoz vinculada al riesgo.

Explicación detallada

La empresa garantizará una vigilancia adecuada y específica realizada por personal sanitario competente. Su contenido y periodicidad se fijan conforme a los protocolos sanitarios y al riesgo, no mediante una regla única basada solo en el porcentaje de sílice de la roca. La vigilancia sanitaria no sustituye el control ambiental ni demuestra por sí sola que un puesto sea seguro. Su objetivo es detectar precozmente posibles efectos y valorar la aptitud con criterios sanitarios. Los resultados colectivos también pueden revelar la necesidad de revisar la prevención. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

Personal sanitario competente define contenido y periodicidad según protocolos, exposición e historia. No existe una regla única basada solo en porcentaje de sílice. Los resultados individuales son confidenciales; las conclusiones preventivas y colectivas pueden exigir revisión de puestos y controles.

Caso práctico razonado

Un reconocimiento sin hallazgos no demuestra que la aspiración funcione ni permite suspender muestreos.

Secuencia operativa recomendada

• Garantizar vigilancia específica.
• Aportar historial de exposición.
• Respetar confidencialidad.
• Revisar prevención ante hallazgos.

Errores críticos que deben evitarse

• Usar reconocimiento como medición ambiental.
• Aplicar igual periodicidad a todos sin riesgo.
• Entregar diagnósticos a mandos no sanitarios.

Comprobación antes de continuar

• Garantizar vigilancia específica.
• Aportar historial de exposición.
• Respetar confidencialidad.
• Revisar prevención ante hallazgos.

Idea clave

Vigilar la salud detecta efectos; controlar el ambiente evita que aparezcan.'),
  (4, 8, 'Historial de exposición', 38, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-08/slide-01.jpg', 'Objetivo

Mantener un historial coherente de puestos, tareas, tiempos y resultados a lo largo de la vida laboral.

Explicación detallada

Los resultados de exposición de cada trabajador se registran para conocer el riesgo acumulado y se incorporan a su expediente médico. Esta trazabilidad permite relacionar los puestos, tareas, tiempos y mediciones con la vigilancia de la salud. El historial debe poder seguir cambios de puesto, centros, tareas y resultados a lo largo del tiempo. Los datos médicos permanecen bajo confidencialidad sanitaria, mientras que la empresa gestiona la información preventiva necesaria. Una trazabilidad incompleta dificulta valorar la dosis acumulada. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La dosis acumulada no coincide con el último resultado. Cambios de centro, contrata, tarea y controles deben quedar trazados. Las fichas se incorporan al expediente médico, mientras la empresa conserva los registros preventivos previstos. La falta de continuidad limita la interpretación sanitaria.

Caso práctico razonado

Un trabajador rota entre perforación y cabina, pero todas las mediciones figuran bajo “operario”. Sin tareas y tiempos, el historial pierde utilidad.

Secuencia operativa recomendada

• Identificar puesto y tarea real.
• Registrar fechas, duración y controles.
• Vincular mediciones al trabajador.
• Conservar y transferir según obligaciones.

Errores críticos que deben evitarse

• Usar categorías genéricas.
• Borrar datos al cambiar de puesto.
• Mezclar datos médicos con acceso general.

Comprobación antes de continuar

• Identificar puesto y tarea real.
• Registrar fechas, duración y controles.
• Vincular mediciones al trabajador.
• Conservar y transferir según obligaciones.

Idea clave

La trazabilidad convierte resultados aislados en una historia de exposición interpretable.'),
  (4, 9, 'Detección y comunicación de fallos', 39, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-09/slide-01.jpg', 'Objetivo

Comunicar fallos de control con información suficiente y detener cuando comprometan protección.

Explicación detallada

El trabajador debe avisar si una perforadora emite polvo, falla una boquilla, una cabina no presuriza, la ventilación se detiene o se limpia en seco. Comunicarlo pronto permite corregir la causa antes de que afecte a más personas. Una comunicación eficaz describe el equipo, el síntoma del fallo, el momento y la tarea afectada. También indica si se ha detenido el trabajo o delimitado la zona. Avisar sin abandonar la exposición o sin impedir que otro ocupe el puesto puede resultar insuficiente. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

El aviso debe identificar equipo, síntoma, momento, tarea, personas afectadas y condición adoptada. Comunicar sin salir del foco o sin impedir relevo no controla la exposición. Las reglas deben indicar qué defectos obligan a parada, zona restringida o método alternativo.

Caso práctico razonado

Una cabina pierde presión. El operador envía un mensaje pero sigue dos horas con ventanas cerradas. La comunicación no compensa la barrera perdida.

Secuencia operativa recomendada

• Detectar señal o indicador.
• Salir o detener según criterio.
• Delimitar y evitar relevo expuesto.
• Comunicar datos y registrar corrección.

Errores críticos que deben evitarse

• Avisar al final del turno.
• Abrir ventanas para ventilar.
• Continuar por no ver polvo.

Comprobación antes de continuar

• Detectar señal o indicador.
• Salir o detener según criterio.
• Delimitar y evitar relevo expuesto.
• Comunicar datos y registrar corrección.

Idea clave

Un aviso eficaz cambia la condición de trabajo y evita que otros hereden el riesgo.'),
  (4, 10, 'Actuación ante síntomas o sospecha', 40, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-10/slide-01.jpg', 'Objetivo

Actuar ante síntomas sin usar su presencia o ausencia como medida ambiental.

Explicación detallada

La aparición de tos persistente, dificultad respiratoria u otros síntomas debe comunicarse al servicio sanitario, sin esperar al reconocimiento programado. Los síntomas no sirven para medir la exposición, pero requieren valoración y pueden motivar la revisión de las medidas preventivas. La consulta sanitaria temprana permite valorar causas y decidir si procede adaptar el trabajo. No debe culpabilizarse al trabajador ni ocultarse información. Paralelamente se revisan mediciones, controles y personas potencialmente afectadas, porque un síntoma puede señalar una deficiencia colectiva. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

Tos persistente o disnea requieren consulta sanitaria temprana. Paralelamente se revisan exposición, controles y posibles personas comparables, sin invadir confidencialidad. Un síntoma puede tener otras causas, pero no se ignora ni se atribuye automáticamente sin valoración.

Caso práctico razonado

Dos trabajadores del mismo área comunican tos. El servicio sanitario evalúa y prevención revisa captación y mediciones; no se espera al reconocimiento anual.

Secuencia operativa recomendada

• Comunicar al servicio sanitario.
• Valorar urgencia y aptitud.
• Revisar tareas y controles.
• Proteger confidencialidad y no culpabilizar.

Errores críticos que deben evitarse

• Autodiagnosticarse silicosis.
• Esperar al examen periódico.
• Ocultar síntomas por temor laboral.

Comprobación antes de continuar

• Comunicar al servicio sanitario.
• Valorar urgencia y aptitud.
• Revisar tareas y controles.
• Proteger confidencialidad y no culpabilizar.

Idea clave

Los síntomas activan atención sanitaria y revisión preventiva, no sustituyen el diagnóstico ni la medición.'),
  (5, 1, 'Documentación preventiva', 41, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-01/slide-01.jpg', 'Objetivo

Mantener un DSS capaz de demostrar decisiones, controles, responsables y revisión.

Explicación detallada

La empresa debe conservar la documentación exigida para los trabajos con riesgo de sílice e integrarla en el Documento sobre Seguridad y Salud. Debe incluir la evaluación, los criterios de muestreo, los resultados y las medidas de prevención y protección. La documentación debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida. Incluye puestos, tareas, estrategia de medición, resultados, mantenimiento, formación y acciones correctoras. Un archivo extenso pero desactualizado no cumple la función preventiva del DSS. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La documentación integra evaluación, estrategia de muestreo, resultados, medidas, mantenimiento, formación y acciones correctoras. Debe permitir reconstruir por qué se tomó una decisión y si sigue vigente. Un archivo desactualizado o sin conexión con el trabajo real no cumple su función.

Caso práctico razonado

El DSS incluye una aspiración que fue retirada meses atrás. Aunque el documento sea extenso, describe barreras inexistentes y debe actualizarse.

Secuencia operativa recomendada

• Controlar versión y responsables.
• Vincular evaluación y medidas.
• Adjuntar criterios de muestreo.
• Cerrar acciones con verificación.

Errores críticos que deben evitarse

• Archivar sin revisar.
• Copiar un DSS de otro centro.
• Registrar medidas sin responsables.

Comprobación antes de continuar

• Controlar versión y responsables.
• Vincular evaluación y medidas.
• Adjuntar criterios de muestreo.
• Cerrar acciones con verificación.

Idea clave

Documentar no es acumular papel: es conservar evidencia vigente y trazable para decidir.'),
  (5, 2, 'Fichas individualizadas de medición', 42, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-02/slide-01.jpg', 'Objetivo

Completar fichas individualizadas con contexto suficiente para interpretar y comparar mediciones.

Explicación detallada

Los resultados de las tomas de muestras se registran mediante fichas individualizadas. Estas deben permitir identificar el puesto, la jornada, el equipo, las condiciones de trabajo y los resultados de polvo respirable y sílice cristalina respirable. La ficha debe relacionar resultado y condiciones: trabajador, puesto, duración, caudal, volumen, material, controles y anomalías. Esa información hace comparables las campañas y ayuda a explicar cambios. Sin contexto, dos concentraciones numéricamente distintas pueden interpretarse de forma errónea. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La ficha incluye trabajador/puesto, jornada, tareas, material, controles, aparato, caudal, volumen, incidencias y resultados de polvo y SCR. Una cifra sin condiciones no permite explicar diferencias ni saber si representa el escenario habitual. La calidad del dato comienza en el registro de campo.

Caso práctico razonado

Dos muestras difieren mucho; una se tomó con lluvia y otra con avería de riego, pero la ficha no lo indica. La comparación pierde capacidad diagnóstica.

Secuencia operativa recomendada

• Identificar persona, puesto y fecha.
• Describir tareas y controles.
• Registrar equipo, caudal y duración.
• Anotar incidencias y resultados.

Errores críticos que deben evitarse

• Omitir condiciones meteorológicas relevantes.
• Rellenar después de memoria.
• Confundir polvo respirable y SCR.

Comprobación antes de continuar

• Identificar persona, puesto y fecha.
• Describir tareas y controles.
• Registrar equipo, caudal y duración.
• Anotar incidencias y resultados.

Idea clave

La ficha convierte una concentración en evidencia auditable de una jornada concreta.'),
  (5, 3, 'Comunicación de resultados', 43, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-03/slide-01.jpg', 'Objetivo

Cumplir remisiones periódicas sin retrasar el análisis y la acción interna.

Explicación detallada

Las fichas estadísticas con los resultados se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre. Además, se presentan anualmente a la Autoridad Minera junto con las modificaciones del Documento sobre Seguridad y Salud. La obligación de remisión no sustituye el análisis interno. La empresa debe revisar resultados al recibirlos, informar a quienes corresponda y activar acciones si detecta desviaciones. Esperar al envío anual para reaccionar perdería la finalidad preventiva de la medición. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

Las fichas estadísticas se envían al INS al menos cuatrimestralmente y anualmente a la Autoridad Minera junto con modificaciones del DSS. La empresa debe analizar al recibir resultados, informar y corregir. La remisión administrativa no es una fase de espera.

Caso práctico razonado

Un resultado supera el VLA en febrero y se propone actuar al envío anual. Debe intervenirse de inmediato y después comunicar conforme al calendario.

Secuencia operativa recomendada

• Revisar resultado al recibirlo.
• Activar medidas y comunicación interna.
• Enviar al INS cuatrimestralmente.
• Presentar anualmente a Autoridad Minera.

Errores críticos que deben evitarse

• Esperar al cierre anual.
• Enviar sin analizar.
• Corregir el dato para evitar incidencia.

Comprobación antes de continuar

• Revisar resultado al recibirlo.
• Activar medidas y comunicación interna.
• Enviar al INS cuatrimestralmente.
• Presentar anualmente a Autoridad Minera.

Idea clave

La obligación de informar nunca aplaza la obligación de proteger.'),
  (5, 4, 'Comunicación de enfermedades', 44, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-04/slide-01.jpg', 'Objetivo

Comunicar enfermedades reconocidas y utilizar cada caso para revisar prevención.

Explicación detallada

Todo caso reconocido de neumoconiosis, silicosis o cáncer de pulmón derivado de la exposición laboral a polvo o sílice debe comunicarse a la Autoridad Minera y al Instituto Nacional de Silicosis, además de las obligaciones laborales aplicables. La comunicación institucional permite mejorar la vigilancia epidemiológica y orientar políticas preventivas. Debe realizarse sin perjuicio de la gestión como enfermedad profesional y de la protección de datos. Cada caso reconocido obliga además a revisar la evaluación y las medidas aplicadas. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

Los casos reconocidos de neumoconiosis, silicosis y cáncer de pulmón laboral por polvo o SCR se comunican a Autoridad Minera e INS, sin perjuicio de otras obligaciones. Se protege la información personal y se revisan evaluación, grupos comparables y barreras. La comunicación no busca culpables, sino prevención y vigilancia.

Caso práctico razonado

Se reconoce silicosis en un extrabajador. El tiempo transcurrido no elimina la necesidad de comunicación y revisión de exposiciones históricas comparables.

Secuencia operativa recomendada

• Activar circuitos sanitario/laboral.
• Comunicar a organismos exigidos.
• Preservar confidencialidad.
• Revisar puestos y medidas.

Errores críticos que deben evitarse

• Difundir el diagnóstico en la plantilla.
• Limitarse al trámite.
• No revisar por ser extrabajador.

Comprobación antes de continuar

• Activar circuitos sanitario/laboral.
• Comunicar a organismos exigidos.
• Preservar confidencialidad.
• Revisar puestos y medidas.

Idea clave

Cada enfermedad reconocida es también una señal preventiva que obliga a comprobar el sistema.'),
  (5, 5, 'Información que debe recibir el trabajador', 45, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-05/slide-01.jpg', 'Objetivo

Proporcionar información precisa, comprensible y vinculada al puesto real.

Explicación detallada

La información debe explicar los materiales y tareas de riesgo, los posibles efectos sobre la salud, los resultados de la evaluación, las medidas preventivas, los procedimientos de emergencia y el uso correcto de los equipos de protección. La información se adapta al lenguaje, experiencia y tareas del grupo. Debe explicar qué hacer ante un fallo, dónde consultar resultados y a quién comunicar incidencias. Una presentación genérica sin relación con la explotación difícilmente modifica conductas ni demuestra una formación adecuada. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

Debe explicar materiales, tareas, efectos, resultados, controles, emergencias, EPI y canales de comunicación. Se adapta a idioma, experiencia y responsabilidad. Una presentación general no enseña qué hacer cuando falla una boquilla concreta o cómo consultar un resultado individual.

Caso práctico razonado

Una contrata recibe un folleto genérico, pero desconoce zonas restringidas y alarmas del centro. La información no es suficiente para entrar.

Secuencia operativa recomendada

• Explicar riesgos del centro y tarea.
• Mostrar controles y fallos críticos.
• Indicar actuación y contactos.
• Comprobar comprensión.

Errores críticos que deben evitarse

• Entregar solo para firma.
• Usar lenguaje no entendido.
• Omitir resultados y cambios.

Comprobación antes de continuar

• Explicar riesgos del centro y tarea.
• Mostrar controles y fallos críticos.
• Indicar actuación y contactos.
• Comprobar comprensión.

Idea clave

Informar es conseguir que la persona sepa reconocer, decidir y actuar, no solo que reciba un documento.'),
  (5, 6, 'Formación teórica y práctica', 46, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-06/slide-01.jpg', 'Objetivo

Acreditar competencia teórica y práctica, no mera asistencia.

Explicación detallada

Cada trabajador debe recibir formación suficiente y adecuada para su puesto, tanto teórica como práctica. No basta con entregar documentación: hay que comprender los riesgos, aplicar las medidas de control y demostrar el uso correcto de la protección respiratoria. La parte práctica puede incluir inspección de cabinas y captaciones, identificación de focos, demostración de limpieza y ensayo de ajuste respiratorio. La competencia se comprueba observando la ejecución, no solo mediante asistencia. Los errores detectados durante la práctica se corrigen antes de volver al puesto. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La práctica incluye identificación de focos, inspección de controles, limpieza segura, colocación y retirada de EPI y ensayo cuantitativo de ajuste. La evaluación observa ejecución y corrige errores antes del puesto. Las locuciones y diapositivas apoyan, pero no equivalen por sí solas a veinte horas de actividad.

Caso práctico razonado

Un alumno aprueba test pero no consigue sellado facial. No se considera competente para usar ese equipo hasta corregir selección y práctica.

Secuencia operativa recomendada

• Explicar fundamentos.
• Demostrar procedimientos.
• Observar ejecución individual.
• Registrar evaluación y corrección.

Errores críticos que deben evitarse

• Convalidar por experiencia.
• Usar solo cuestionario.
• Dar por apto tras una firma.

Comprobación antes de continuar

• Explicar fundamentos.
• Demostrar procedimientos.
• Observar ejecución individual.
• Registrar evaluación y corrección.

Idea clave

La competencia preventiva se demuestra haciendo correctamente la tarea en condiciones representativas.'),
  (5, 7, 'Periodicidad anual obligatoria', 47, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-07/slide-01.jpg', 'Objetivo

Aplicar repetición mínima anual y actualización extraordinaria ante cambios.

Explicación detallada

La formación frente al polvo y la sílice debe repetirse, como mínimo, una vez al año. También se actualizará cuando cambien las funciones, el puesto, el lugar de trabajo, la tecnología, los equipos o los conocimientos sobre el riesgo. El refuerzo anual debe recuperar los riesgos esenciales y centrarse también en cambios, incidentes, mediciones y fallos observados desde la sesión anterior. Esta modalidad ampliada de veinte horas no elimina esa repetición. La actualización anual mantiene la formación conectada con el trabajo real. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La formación se repite al menos una vez al año y se adapta a cambios de función, puesto, lugar, tecnología, equipos o conocimiento. El curso ampliado de veinte horas no elimina el refuerzo anual mínimo. La sesión anual debe incorporar mediciones, fallos e incidentes recientes.

Caso práctico razonado

Se realiza el curso de veinte horas en enero y en julio cambia la tecnología de captación. La actualización procede en julio, no al siguiente enero.

Secuencia operativa recomendada

• Programar refuerzo anual.
• Definir disparadores por cambio.
• Adaptar a puesto y resultados.
• Conservar evidencia teórica y práctica.

Errores críticos que deben evitarse

• Confundir veinte horas con exención anual.
• Repetir material sin cambios.
• Esperar a aniversario tras nueva tecnología.

Comprobación antes de continuar

• Programar refuerzo anual.
• Definir disparadores por cambio.
• Adaptar a puesto y resultados.
• Conservar evidencia teórica y práctica.

Idea clave

Anual es frecuencia mínima; el cambio relevante exige formación antes.'),
  (5, 8, 'Consulta y participación', 48, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-08/slide-01.jpg', 'Objetivo

Convertir experiencia de trabajadores y representantes en mejora verificada.

Explicación detallada

Los trabajadores y sus representantes deben recibir información y participar conforme a la normativa preventiva. Su experiencia ayuda a detectar focos, fallos de mantenimiento y situaciones reales que pueden no aparecer durante una visita puntual. La participación convierte la experiencia diaria en información preventiva. Operadores y mantenedores pueden señalar boquillas que se obstruyen, puertas que no sellan o momentos con emisiones anormales. Estas observaciones se contrastan y se incorporan a la mejora, sin sustituir la evaluación técnica. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La participación ayuda a detectar emisiones, obstrucciones, fallos de sellado y tareas no previstas. Las observaciones se registran, contrastan y responden; no sustituyen medición o competencia técnica. Cerrar el ciclo exige comunicar qué se decidió y por qué.

Caso práctico razonado

Operadores informan de polvo al arrancar cada mañana. Aunque una visita posterior no lo observe, se investiga el patrón y el arranque.

Secuencia operativa recomendada

• Abrir canales de comunicación.
• Registrar observación y contexto.
• Investigar con participación.
• Responder y verificar la medida.

Errores críticos que deben evitarse

• Descartar por no reproducirse.
• Sustituir medición por opinión.
• No informar del cierre.

Comprobación antes de continuar

• Abrir canales de comunicación.
• Registrar observación y contexto.
• Investigar con participación.
• Responder y verificar la medida.

Idea clave

La participación aporta conocimiento del trabajo real; la evaluación técnica lo transforma en prevención.'),
  (5, 9, 'Comprobación antes de empezar', 49, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-09/slide-01.jpg', 'Objetivo

Realizar una comprobación previa observable de controles colectivos, EPI y zonas.

Explicación detallada

Antes de trabajar, comprueba que funcionan el riego, la aspiración, la ventilación o la presurización de la cabina. Verifica el estado del equipo respiratorio, conoce las zonas restringidas y comunica cualquier anomalía antes de exponerte. La comprobación previa se convierte en una rutina observable: mirar, probar, registrar y comunicar. Si un control esencial no funciona, se aplica el criterio definido de parada o trabajo alternativo. Empezar confiando en que el sistema se recuperará durante el turno aumenta innecesariamente la dosis. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La rutina es mirar, probar, registrar y comunicar. Se verifican riego, aspiración, ventilación, presión de cabina, filtros, EPI y restricciones. El procedimiento define qué fallo obliga a parada y qué trabajo alternativo es seguro. Comenzar esperando que el control se recupere añade dosis evitable.

Caso práctico razonado

La aspiración no alcanza depresión mínima al inicio. Aunque suele estabilizarse, no se expone al personal hasta cumplir criterio o aplicar alternativa autorizada.

Secuencia operativa recomendada

• Revisar indicadores y estado físico.
• Probar funcionamiento antes del foco.
• Registrar anomalías.
• Parar o cambiar tarea según criterio.

Errores críticos que deben evitarse

• Arrancar para ver si mejora.
• Confiar en ausencia de nube.
• Dejar el aviso al siguiente turno.

Comprobación antes de continuar

• Revisar indicadores y estado físico.
• Probar funcionamiento antes del foco.
• Registrar anomalías.
• Parar o cambiar tarea según criterio.

Idea clave

La jornada empieza cuando las barreras están operativas, no cuando arranca el proceso.'),
  (5, 10, 'Compromiso preventivo diario', 50, 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-10/slide-01.jpg', 'Objetivo

Integrar control en origen, mantenimiento, conducta, medición y mejora diaria.

Explicación detallada

La silicosis es prevenible si se controla el polvo desde el origen, se mantienen las medidas colectivas y cada persona aplica los procedimientos. Trabajar sin nube visible no garantiza seguridad: la evaluación, la medición y la disciplina preventiva deben acompañar cada tarea. El cierre del curso debe traducirse en compromisos verificables: controlar el foco, mantener cabinas y captaciones, limpiar sin dispersar, usar correctamente el EPI y comunicar desviaciones. La prevención funciona cuando estas decisiones se repiten cada día y quedan respaldadas por mediciones y supervisión. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La silicosis es prevenible si las barreras se repiten y verifican. El compromiso debe traducirse en acciones observables: no barrer en seco, mantener cierres, informar fallos, conservar EPI, respetar zonas y analizar tendencias. La ausencia de nube no elimina la disciplina.

Caso práctico razonado

Una planta obtiene buenos resultados durante un año. El éxito confirma el sistema utilizado; no justifica desmontarlo, sino mantenerlo y buscar mejora.

Secuencia operativa recomendada

• Controlar el foco.
• Mantener y comprobar barreras.
• Medir y analizar tendencias.
• Comunicar y corregir desviaciones.

Errores críticos que deben evitarse

• Depender de la memoria individual.
• Relajar controles por buenos datos.
• Normalizar fallos pequeños.

Comprobación antes de continuar

• Controlar el foco.
• Mantener y comprobar barreras.
• Medir y analizar tendencias.
• Comunicar y corregir desviaciones.

Idea clave

La prevención funciona cuando cada resultado favorable se utiliza para sostener y mejorar las barreras que lo hicieron posible.');

do $$
begin
  if (select count(*) from _polvo20h_content) <> 50 then
    raise exception 'Se esperaban 50 filas de contenido nuevo y hay %',
      (select count(*) from _polvo20h_content);
  end if;
end;
$$;

create temporary table _polvo20h_segments on commit drop as
select
  cm.position as block_position,
  seg.position as part_position,
  seg.id as segment_id,
  seg.title as segment_title,
  content.expected_title,
  content.source_page,
  content.slide_storage_path,
  content.note_summary
from public.course_versions cv
join public.course_modules cm on cm.course_version_id = cv.id
join public.lessons l on l.module_id = cm.id
join public.lesson_audio_segments seg on seg.lesson_id = l.id
join _polvo20h_content content
  on content.block_position = cm.position
  and content.part_position = seg.position
where cv.id = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24';

do $$
begin
  if (select count(*) from _polvo20h_segments) <> 50 then
    raise exception 'Se esperaban 50 segmentos de audio existentes y se encontraron %',
      (select count(*) from _polvo20h_segments);
  end if;
end;
$$;

-- 1. Diapositivas: una por parte (antes había 2, "resumen" y "detalle").
--    Se elimina la segunda y se sustituye la primera por la definitiva.
delete from public.lesson_segment_slides slide
using _polvo20h_segments target
where slide.segment_id = target.segment_id
  and slide.position = 2;

update public.lesson_segment_slides slide
set
  title = target.expected_title,
  body = '',
  image_storage_path = target.slide_storage_path,
  image_external_url = null,
  source_label = 'Presentación oficial InmínerCampus · Formación Polvo y sílice · 20 horas',
  source_page = target.source_page::text,
  alt_text = target.expected_title,
  updated_at = now()
from _polvo20h_segments target
where slide.segment_id = target.segment_id
  and slide.position = 1;

-- 2. Explicaciones detalladas: sustituyen el resumen breve provisional.
update public.lesson_segment_notes note
set
  summary = target.note_summary,
  key_points = '{}',
  stop_criterion = '',
  source_label = 'Explicaciones detalladas oficiales InmínerCampus · Curso 6 · Polvo y sílice · 20 horas',
  source_pages = 'Parte ' || target.block_position || '.' || target.part_position,
  approved = true,
  updated_at = now()
from _polvo20h_segments target
where note.segment_id = target.segment_id;

-- 3. Recurso descargable: presentación completa (50 páginas) por cada
--    lección de bloque 1-5. No existía ningún lesson_resources previo para
--    este curso, así que se inserta.
insert into public.lesson_resources
  (lesson_id, kind, title, storage_path, external_url, mime_type, size_bytes, downloadable, required, position)
select distinct
  l.id,
  'presentation'::public.resource_kind,
  'Presentación completa del curso · 50 diapositivas',
  'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf',
  null,
  'application/pdf',
  null::bigint,
  true,
  false,
  1
from public.course_versions cv
join public.course_modules cm on cm.course_version_id = cv.id
join public.lessons l on l.module_id = cm.id
where cv.id = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24'
  and cm.position between 1 and 5
on conflict do nothing;

do $$
declare
  updated_slides integer;
  remaining_old_slides integer;
  updated_notes integer;
  inserted_resources integer;
begin
  select count(*)
  into updated_slides
  from _polvo20h_segments target
  join public.lesson_segment_slides slide
    on slide.segment_id = target.segment_id and slide.position = 1
  where slide.image_storage_path = target.slide_storage_path
    and slide.title = target.expected_title
    and btrim(slide.body) = '';

  select count(*)
  into remaining_old_slides
  from _polvo20h_segments target
  join public.lesson_segment_slides slide
    on slide.segment_id = target.segment_id and slide.position = 2;

  select count(*)
  into updated_notes
  from _polvo20h_segments target
  join public.lesson_segment_notes note on note.segment_id = target.segment_id
  where note.approved = true
    and note.summary = target.note_summary;

  select count(*)
  into inserted_resources
  from public.lesson_resources resource
  join public.lessons lesson on lesson.id = resource.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  where module.course_version_id = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24'
    and module.position between 1 and 5
    and resource.storage_path = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf';

  if updated_slides <> 50 or remaining_old_slides <> 0
     or updated_notes <> 50 or inserted_resources <> 5 then
    raise exception
      'Validación fallida: % diapositivas actualizadas, % diapositivas antiguas restantes, % explicaciones actualizadas, % recursos insertados',
      updated_slides, remaining_old_slides, updated_notes, inserted_resources;
  end if;
end;
$$;

commit;
