-- Escribe las cincuenta explicaciones detalladas del curso de prevención del
-- polvo y la sílice cristalina respirable, y devuelve a sus títulos los acentos
-- que perdieron al importarse.
--
-- Situación de partida: los bloques 1 a 5 tenían sus cincuenta diapositivas con
-- imagen y locución, pero el cuerpo de todas ellas estaba vacío. Además sus
-- títulos se habían guardado sin acentuar («Que es el polvo», «Cuando existe
-- riesgo de exposicion»), de modo que la cabecera del visor mostraba una
-- redacción distinta de la del propio documento.
--
-- Fuente: «Curso 6 · Polvo y sílice · Explicaciones detalladas» (Inmíner
-- Campus). El documento dedica una página a cada parte, con ocho secciones
-- fijas. Se conservan siete: el documento repite la secuencia de aplicación
-- como lista de verificación en las cincuenta partes, y mostrar dos veces la
-- misma lista en la misma diapositiva no aporta nada al alumno.
--
-- El documento está rotulado para la modalidad de 20 horas, hoy retirada, pero
-- sus cincuenta partes son las mismas que conserva la modalidad vigente de 3
-- horas: coinciden código a código en numeración y título.
--
-- El bloque 6 de cierre no entra: sus cinco unidades tienen su propia redacción
-- y no aparecen en este documento. No se tocan audios, imágenes,
-- transcripciones, matrículas ni progreso.

begin;

update public.lesson_segment_slides s set body = $b$Objetivo
Definir el polvo como aerosol sólido y distinguir peligro, emisión y exposición.

Explicación vinculada al audio
El polvo es materia sólida particulada y dispersa en la atmósfera, generada por procesos mecánicos o por el movimiento del aire. En minería aparece en numerosas operaciones y puede convertirse en un agente químico peligroso para la salud. En una explotación no todo el polvo tiene la misma composición ni el mismo tamaño. Por eso, una evaluación seria no se limita a observar si el ambiente parece limpio: identifica el material, el proceso que lo fragmenta y la fracción capaz de permanecer suspendida y llegar al trabajador. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
El polvo no es una sustancia única. Su peligrosidad depende de composición mineralógica, granulometría y propiedades; la emisión depende del proceso; y la exposición depende de cuánto llega a la zona de respiración y durante cuánto tiempo. Ver polvo depositado informa sobre limpieza, pero no cuantifica el aerosol respirable.

Secuencia de aplicación
• Identificar material y porcentaje de sílice.
• Localizar operaciones que fragmentan, caen o movilizan material.
• Distinguir polvo depositado de polvo en suspensión.
• Relacionar focos con personas, tiempo y trayectoria del aire.

Caso práctico razonado
Una cinta parece limpia al inicio, pero un punto de transferencia libera material fino durante cada caída. El foco debe identificarse por operación y no por la apariencia general de la nave.

Errores críticos
• Llamar polvo únicamente a la nube visible.
• Suponer que todos los polvos tienen igual peligrosidad.
• Evaluar el material sin evaluar la tarea.

Idea clave
El riesgo se entiende al unir material, proceso y persona; observar suciedad no equivale a medir exposición.$b$, title = $b$Qué es el polvo$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 1;
update public.lesson_audio_segments seg set title = $b$Qué es el polvo$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Reconocer la sílice cristalina y diferenciar presencia en el material de exposición respirable.

Explicación vinculada al audio
La sílice cristalina es dióxido de silicio cristalizado, generalmente en forma de cuarzo o cristobalita. Está presente en muchas rocas y materiales minerales. El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas. El cuarzo es la forma más habitual, pero también debe considerarse la cristobalita cuando pueda estar presente. El porcentaje de sílice de la roca ayuda a caracterizar el peligro, aunque por sí solo no determina la exposición real: también influyen el proceso, la humedad, la ventilación y el tiempo de permanencia. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
Cuarzo y cristobalita son formas cristalinas de dióxido de silicio. Un análisis a granel identifica el peligro en la materia prima, pero no predice por sí solo la concentración respirada. Humedad, energía del proceso, encerramiento, ventilación y duración pueden modificar ampliamente la exposición.

Secuencia de aplicación
• Consultar análisis mineralógico representativo.
• Identificar la forma cristalina relevante.
• Relacionar el contenido con el método de trabajo.
• Confirmar exposición mediante evaluación y medición personal.

Caso práctico razonado
Dos rocas tienen el mismo contenido de cuarzo; una se manipula húmeda en sistema cerrado y otra se corta en seco. El peligro intrínseco es parecido, pero la exposición puede ser muy distinta.

Errores críticos
• Equiparar porcentaje en roca con concentración ambiental.
• Ignorar cristobalita cuando el proceso puede generarla o contenerla.
• Descartar riesgo por trabajar al aire libre.

Idea clave
El contenido de sílice caracteriza el peligro; la exposición real se determina en la tarea y la zona de respiración.$b$, title = $b$Qué es la sílice cristalina$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 2;
update public.lesson_audio_segments seg set title = $b$Qué es la sílice cristalina$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Identificar exposición directa, indirecta y ocasional, incluso fuera del puesto emisor.

Explicación vinculada al audio
Para que exista exposición debe haber un material con sílice cristalina y una tarea capaz de liberar partículas respirables al aire. La evaluación debe considerar también el polvo procedente de focos cercanos, aunque no se genere directamente en el puesto. El análisis debe abarcar tanto a quien genera el polvo como a quienes trabajan cerca o acceden de forma puntual. Un mecánico, un técnico de laboratorio o personal de oficina que entra en producción puede recibir exposición aunque su tarea principal no sea triturar, perforar o transportar material. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
La SCR puede desplazarse desde focos próximos y alcanzar mantenimiento, laboratorio, limpieza, vigilancia o accesos. El mapa de exposición debe incluir rutas de personas y corrientes de aire, tareas normales y anormales, y contratistas. La denominación administrativa del puesto no protege frente a una nube procedente de otra tarea.

Secuencia de aplicación
• Inventariar focos propios y externos.
• Seguir rutas de propagación y permanencia.
• Incluir accesos breves, contratas y tareas auxiliares.
• Definir controles antes de autorizar la entrada.

Caso práctico razonado
Un electricista entra diez minutos en una trituradora parada mientras se limpia en seco cerca. Aunque no opere el proceso, puede recibir un pico relevante.

Errores críticos
• Limitar la evaluación a operadores de producción.
• Excluir tareas cortas por su duración.
• Suponer que la distancia elimina automáticamente el riesgo.

Idea clave
Se evalúa a toda persona que pueda inhalar SCR, no solo a quien genera el polvo.$b$, title = $b$Cuándo existe riesgo de exposición$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 3;
update public.lesson_audio_segments seg set title = $b$Cuándo existe riesgo de exposición$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Recorrer todo el proceso y reconocer operaciones habituales, no regulares y de mantenimiento que generan polvo.

Explicación vinculada al audio
La extracción, perforación, trituración, molienda, tamizado, carga, transporte, limpieza y mantenimiento pueden generar polvo respirable. También pueden producir exposición el corte de piedra, los transvases, el almacenamiento y el acceso esporádico a zonas de producción. Conviene recorrer el proceso completo, desde el frente hasta el producto final, incluyendo paradas, averías y limpieza. Las tareas breves pueden producir picos intensos, especialmente al abrir equipos, vaciar filtros o retirar acumulaciones secas; por eso no deben desaparecer de la evaluación por ser poco frecuentes. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
La emisión aumenta con trituración, impacto, abrasión, velocidad, altura de caída y manipulación de material seco. Las aperturas, vaciados de filtros y desatascos pueden producir picos mayores que la producción estable. Una matriz de tareas debe describir frecuencia, duración, material, controles y posibles fallos.

Secuencia de aplicación
• Dibujar el flujo desde extracción hasta expedición.
• Anotar transferencias, caídas, corte, transporte y acopios.
• Añadir limpieza, averías y apertura de equipos.
• Priorizar escenarios por potencial de emisión y personas afectadas.

Caso práctico razonado
Una captación mantiene controlada la molienda, pero al vaciar el filtro una vez por semana se libera una nube concentrada. Esa tarea breve necesita evaluación y procedimiento propios.

Errores críticos
• Medir solo durante régimen estable.
• Olvidar contratistas y mantenedores.
• Considerar irrelevante una tarea por ser semanal.

Idea clave
Los picos de tareas breves pueden dominar la dosis y deben aparecer en la evaluación.$b$, title = $b$Procesos que pueden generar polvo$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 4;
update public.lesson_audio_segments seg set title = $b$Procesos que pueden generar polvo$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Diferenciar fracciones inhalable, torácica y respirable según su penetración en el aparato respiratorio.

Explicación vinculada al audio
El polvo se clasifica según hasta dónde puede penetrar en el sistema respiratorio. La fracción respirable es la más relevante para la sílice porque puede alcanzar las zonas profundas del pulmón, donde su eliminación resulta especialmente difícil. La clasificación por fracciones explica por qué dos nubes aparentemente iguales pueden tener efectos diferentes. La fracción inhalable entra por nariz y boca; la torácica supera la laringe; y la respirable alcanza regiones pulmonares profundas. Para la SCR, esta última es la referencia higiénica esencial. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
Las fracciones son convenciones relacionadas con la probabilidad de penetración, no rangos rígidos de diámetro. Para SCR interesa la masa de sílice en la fracción respirable, capaz de alcanzar vías no ciliadas. Por ello se emplea un selector o ciclón adecuado antes del filtro de muestreo.

Secuencia de aplicación
• Identificar la fracción exigida por el límite.
• Usar el cabezal selector correspondiente.
• Evitar comparar resultados de fracciones distintas.
• Interpretar concentración y contenido de sílice conjuntamente.

Caso práctico razonado
Una medición de polvo total no puede sustituir automáticamente a la medición de fracción respirable, porque el muestreador y la magnitud evaluada son diferentes.

Errores críticos
• Usar “polvo fino” como medida técnica suficiente.
• Comparar polvo total con VLA respirable.
• Creer que solo penetran partículas invisibles.

Idea clave
Para evaluar SCR se necesita medir la fracción respirable con el método adecuado.$b$, title = $b$Fracciones inhalable, torácica y respirable$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 5;
update public.lesson_audio_segments seg set title = $b$Fracciones inhalable, torácica y respirable$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Explicar por qué las partículas finas permanecen suspendidas y pueden pasar inadvertidas.

Explicación vinculada al audio
Las partículas gruesas tienden a sedimentar antes, mientras que las finas permanecen más tiempo suspendidas y pueden desplazarse con el aire. Que una nube no sea visible no significa que el ambiente esté libre de partículas respirables. La partícula respirable puede permanecer suspendida durante mucho tiempo y desplazarse fuera del foco. La iluminación, el color del material o la humedad pueden ocultarla visualmente. La decisión preventiva debe apoyarse en mediciones representativas y en el conocimiento del proceso, no en la simple percepción del operador. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
La velocidad de sedimentación disminuye al reducirse tamaño y puede verse alterada por turbulencia, viento y ventilación. La visibilidad depende de iluminación, contraste y concentración, por lo que no es un instrumento de medición. Una zona puede parecer despejada y mantener aerosol respirable después de cesar la operación.

Secuencia de aplicación
• No usar la visión como criterio de conformidad.
• Considerar tiempo de permanencia y corrientes de aire.
• Mantener controles tras cesar el foco cuando proceda.
• Verificar con mediciones representativas.

Caso práctico razonado
Tras una limpieza con aire comprimido la nube visible desaparece, pero las partículas finas pueden seguir suspendidas y desplazarse a zonas limpias.

Errores críticos
• Retirarse el EPI en cuanto deja de verse polvo.
• Abrir puertas sin conocer el flujo del aire.
• Confundir sedimentación visible con eliminación.

Idea clave
Invisible no significa inexistente: la exposición se confirma mediante evaluación y medición.$b$, title = $b$Por qué el polvo fino es más peligroso$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 6;
update public.lesson_audio_segments seg set title = $b$Por qué el polvo fino es más peligroso$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Relacionar dosis de SCR con efectos respiratorios y sistémicos graves.

Explicación vinculada al audio
La exposición al polvo puede causar irritación, estornudos o molestias respiratorias. La exposición prolongada a sílice cristalina respirable puede provocar silicosis, pérdida de función pulmonar y aumentar el riesgo de tuberculosis, enfermedad renal y cáncer de pulmón. El daño depende de la dosis acumulada, que combina concentración y tiempo, pero también de exposiciones intensas puntuales. La asociación con cáncer de pulmón obliga a aplicar el principio de reducción al nivel más bajo técnicamente posible, incluso cuando todavía no existen síntomas ni se supera el valor límite. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
La dosis acumulada combina concentración y tiempo, pero los picos intensos también importan. La SCR se asocia con silicosis, cáncer de pulmón, tuberculosis, pérdida de función pulmonar y otras patologías. La irritación temprana no es un indicador fiable de dosis: puede existir exposición relevante sin molestias inmediatas.

Secuencia de aplicación
• Reconocer efectos agudos de irritación y efectos crónicos.
• No esperar síntomas para actuar.
• Reducir exposición por debajo del límite tanto como sea técnicamente posible.
• Comunicar síntomas sin ocultarlos ni autodiagnosticarse.

Caso práctico razonado
Un trabajador sin síntomas opera años cerca de un foco. Su buena tolerancia no valida el puesto; deben mantenerse medición, controles y vigilancia específica.

Errores críticos
• Usar síntomas como detector ambiental.
• Aceptar picos por ser esporádicos.
• Considerar suficiente una revisión médica normal.

Idea clave
La prevención primaria actúa sobre la exposición antes de que exista daño detectable.$b$, title = $b$Efectos iniciales y enfermedades$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 7;
update public.lesson_audio_segments seg set title = $b$Efectos iniciales y enfermedades$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Comprender la silicosis como fibrosis pulmonar irreversible y prevenible.

Explicación vinculada al audio
La silicosis es una enfermedad pulmonar grave e irreversible causada por la inhalación de sílice cristalina respirable. Puede evolucionar incluso después de cesar la exposición. La prevención debe actuar antes de que aparezcan síntomas o alteraciones radiológicas. La silicosis se produce por la respuesta del tejido pulmonar frente a partículas retenidas y genera fibrosis. Esa cicatrización reduce progresivamente la capacidad respiratoria y no se revierte al abandonar el puesto. La prevención primaria, antes del daño, es mucho más eficaz que cualquier actuación posterior. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
Las partículas retenidas activan una respuesta inflamatoria y fibrótica que reduce intercambio gaseoso. El cese de exposición evita dosis adicional, pero no revierte la cicatrización ya producida y la enfermedad puede progresar. De ahí la importancia de evitar el daño y detectar precozmente alteraciones.

Secuencia de aplicación
• Controlar el foco antes de iniciar producción.
• Mantener vigilancia sanitaria específica.
• Investigar resultados o diagnósticos relacionados.
• Revisar exposición de personas comparables.

Caso práctico razonado
Esperar a que aparezca dificultad respiratoria para instalar aspiración supondría actuar cuando el daño puede ser permanente; el control se diseña desde la evaluación inicial.

Errores críticos
• Presentar la silicosis como curable al cambiar de puesto.
• Confiar solo en radiografías periódicas.
• Ocultar un diagnóstico para evitar revisar el proceso.

Idea clave
La silicosis no se cura eliminando la exposición; se previene evitando que la SCR llegue al pulmón.$b$, title = $b$La silicosis$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 8;
update public.lesson_audio_segments seg set title = $b$La silicosis$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Distinguir formas crónica, acelerada y aguda y relacionarlas con intensidad y duración.

Explicación vinculada al audio
Según la intensidad y duración de la exposición, la silicosis puede presentarse de forma crónica, acelerada o aguda. Las exposiciones más intensas pueden acortar mucho el tiempo de aparición, por lo que ninguna sobreexposición debe considerarse aceptable. Las categorías crónica, acelerada y aguda ayudan a entender que no existe una única evolución. Una concentración muy alta puede acortar notablemente los plazos de aparición. Por ello, una avería de aspiración, una limpieza incorrecta o una tarea excepcional requieren control inmediato y no pueden normalizarse. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
Las categorías muestran que una exposición muy alta puede reducir drásticamente el tiempo de aparición. No existe una “cuota” aceptable de episodios intensos. Un fallo de captación, una reparación o una limpieza seca debe generar respuesta inmediata, registro y reevaluación.

Secuencia de aplicación
• Detener y delimitar ante emisión anormal.
• Reducir número de expuestos y duración imprescindible.
• Usar protección adecuada al nivel previsto.
• Investigar y evitar repetición.

Caso práctico razonado
Una avería libera polvo durante media hora. Aunque el promedio anual parezca bajo, el episodio no se normaliza: se limita acceso, protege, registra y corrige.

Errores críticos
• Promediar el pico con días sin exposición.
• Considerar segura una sobreexposición corta.
• Esperar a la siguiente campaña rutinaria.

Idea clave
La intensidad importa: los episodios excepcionales necesitan control tan riguroso como la rutina.$b$, title = $b$Formas de evolución de la silicosis$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 9;
update public.lesson_audio_segments seg set title = $b$Formas de evolución de la silicosis$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Evaluar la interacción entre material, humedad, clima, maquinaria, pistas y producción.

Explicación vinculada al audio
Influyen la naturaleza y humedad de la roca, el proceso productivo, la maquinaria, el estado de las pistas, la climatología, el viento y la posibilidad de aplicar agua. Estos factores deben valorarse para elegir medidas preventivas eficaces. Estos factores interactúan: una pista seca con viento y tráfico intenso puede emitir mucho más que la misma pista húmeda y estabilizada. El análisis debe actualizarse cuando cambien estación, producción, maquinaria o método. Una medida eficaz en invierno puede resultar insuficiente durante un periodo seco y ventoso. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica
Los factores no actúan aisladamente. Viento, sequedad y tráfico pueden multiplicar emisiones; agua excesiva puede crear barro y riesgo vial. La eficacia de una medida debe comprobarse en distintas estaciones y cargas de producción. Los cambios operativos actualizan la evaluación aunque el equipo sea el mismo.

Secuencia de aplicación
• Registrar clima, humedad y producción durante mediciones.
• Relacionar emisiones con estado de pistas y equipos.
• Revisar medidas en cambios estacionales.
• Controlar riesgos secundarios del agua.

Caso práctico razonado
El riego que funcionó en invierno resulta insuficiente en verano con viento y más tráfico. La campaña y la frecuencia de riego deben ajustarse a la nueva condición.

Errores críticos
• Copiar una frecuencia fija todo el año.
• Aumentar agua sin revisar drenaje y adherencia.
• Ignorar cambios de material o tonelaje.

Idea clave
La medida eficaz es la que se adapta a la condición real y mantiene control sin crear riesgos nuevos.$b$, title = $b$Factores que favorecen el polvo$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 10;
update public.lesson_audio_segments seg set title = $b$Factores que favorecen el polvo$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 1 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Integrar la ITC 02.0.02 con la normativa general de cancerígenos y agentes químicos.

Explicación vinculada al audio
La referencia específica en minería es la Orden TED 723 de 2021, que aprueba la ITC 02.0.02. También son aplicables el Real Decreto 665 de 1997 sobre agentes cancerígenos y el Real Decreto 374 de 2001 sobre agentes químicos. La ITC minera convive con la normativa general de agentes cancerígenos, agentes químicos, prevención y equipos de protección. Aplicar la norma más específica no elimina las obligaciones generales. La empresa debe integrar todas ellas en su evaluación y en el Documento sobre Seguridad y Salud, evitando referencias derogadas. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
La Orden TED/723/2021 aporta requisitos mineros específicos, pero no desplaza el RD 665/1997 ni el RD 374/2001. La evaluación debe reflejar la norma aplicable, versiones vigentes y obligaciones más rigurosas. Usar referencias derogadas puede conducir a límites, frecuencias o formación incorrectos.

Secuencia de aplicación
• Identificar ámbito y norma específica.
• Contrastar texto consolidado y derogaciones.
• Integrar obligaciones en DSS y procedimientos.
• Actualizar documentos, formación y registros.

Caso práctico razonado
Una empresa mantiene un procedimiento basado en la ITC de 2007. Aunque algunas medidas sean útiles, debe actualizar límites, muestreo, ajuste respiratorio y comunicaciones a la norma vigente.

Errores críticos
• Citar solo la ITC y omitir cancerígenos.
• Mantener valores de una norma derogada.
• Confundir guía técnica con obligación jurídica.

Idea clave
La prevención se apoya en un marco integrado y actualizado, no en una única norma aislada.$b$, title = $b$Normativa principal aplicable$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 1;
update public.lesson_audio_segments seg set title = $b$Normativa principal aplicable$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar el enfoque de agente cancerígeno: evitar y reducir al nivel más bajo técnicamente posible.

Explicación vinculada al audio
Los trabajos que generan exposición a polvo respirable de sílice cristalina están incluidos entre los procedimientos cancerígenos. Por ello, la exposición debe evitarse y, cuando no sea posible, reducirse a un nivel tan bajo como sea técnicamente posible. Esta consideración modifica el enfoque: no basta con mantenerse por debajo de un número. Deben analizarse sustitución, sistemas cerrados, captación en origen, reducción del número de personas expuestas, higiene y vigilancia. Las decisiones han de quedar justificadas y revisarse cuando aparezcan alternativas técnicas mejores. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
Cumplir un límite es requisito mínimo, no licencia para mantener exposición evitable. Deben estudiarse sustitución del proceso, sistemas cerrados, captación, reducción de personas y tiempos, higiene y EPI residual. La viabilidad técnica se revisa al aparecer soluciones mejores.

Secuencia de aplicación
• Eliminar o sustituir cuando sea posible.
• Controlar el foco y el medio.
• Reducir personas y duración.
• Usar EPI únicamente para riesgo residual o temporal.

Caso práctico razonado
Una medición de 0,04 mg/m³ cumple, pero una captación viable puede reducirla a 0,015. La mejora debe evaluarse y no descartarse solo por estar bajo el VLA.

Errores críticos
• Tomar 0,05 como objetivo de operación.
• Retirar medidas tras un resultado favorable.
• Justificar exposición evitable por costumbre.

Idea clave
Para cancerígenos, “por debajo del límite” y “tan bajo como sea técnicamente posible” son obligaciones simultáneas.$b$, title = $b$La sílice como agente cancerígeno$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 2;
update public.lesson_audio_segments seg set title = $b$La sílice como agente cancerígeno$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Interpretar simultáneamente los VLA-ED de polvo respirable y SCR.

Explicación vinculada al audio
Deben cumplirse simultáneamente dos límites: tres miligramos por metro cúbico para el polvo respirable total y cero coma cero cinco miligramos por metro cúbico para la sílice cristalina respirable. Son límites diarios referidos a una jornada estándar de ocho horas. Los dos valores se comparan por separado y deben cumplirse simultáneamente. Un resultado bajo de polvo total no garantiza que la concentración de sílice sea aceptable si la proporción de SCR es elevada. La interpretación debe considerar incertidumbre analítica, representatividad y jornada real antes de concluir conformidad. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
Los límites son 3 mg/m³ para polvo respirable y 0,05 mg/m³ para SCR, referidos a ocho horas. Se comparan por separado. Una baja concentración de polvo puede incumplir SCR si su proporción es alta. La jornada real se pondera y la decisión debe considerar incertidumbre y representatividad.

Secuencia de aplicación
• Verificar unidades, fracción y duración.
• Comparar cada resultado con su límite.
• Revisar incertidumbre y condiciones de jornada.
• Adoptar medidas si cualquiera incumple.

Caso práctico razonado
Una muestra arroja 1,2 mg/m³ de polvo respirable y 0,06 mg/m³ de SCR: cumple el primer límite, pero el puesto no es conforme por la sílice.

Errores críticos
• Promediar ambos resultados entre sí.
• Concluir conformidad por cumplir polvo total.
• Redondear a la baja una cifra próxima.

Idea clave
Los dos valores deben cumplirse simultáneamente; el más desfavorable gobierna la decisión.$b$, title = $b$Valores límite de exposición diaria$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 3;
update public.lesson_audio_segments seg set title = $b$Valores límite de exposición diaria$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Usar el límite como frontera legal y no como nivel deseado.

Explicación vinculada al audio
Cumplir el valor límite no permite dar por terminado el control. Al tratarse de un agente cancerígeno, la empresa debe reducir la exposición todo lo técnicamente posible y mantener las medidas preventivas, aunque las mediciones estén por debajo del límite. Trabajar cerca del límite deja poco margen frente a variaciones del proceso, viento, fallos de riego o aumento de producción. La mejora continua busca alejarse de esa situación mediante controles estables. Los resultados favorables sirven para confirmar medidas, no para retirar automáticamente barreras que ya funcionan. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
Trabajar cerca del VLA ofrece poco margen ante variaciones de viento, producción o fallo de controles. Las tendencias, no solo los puntos individuales, deben guiar mejora. Un resultado bajo confirma las barreras utilizadas durante esa muestra; retirarlas cambia la situación y anula la inferencia.

Secuencia de aplicación
• Analizar series y variabilidad.
• Mantener controles presentes durante la medición.
• Investigar tendencias ascendentes.
• Planificar mejora con responsable y plazo.

Caso práctico razonado
Tres campañas suben de 0,018 a 0,031 y 0,044 mg/m³. Aún cumplen, pero la tendencia exige investigar antes de superar.

Errores críticos
• Esperar a superar 0,05.
• Retirar riego por resultado favorable.
• Usar el VLA como consigna de producción.

Idea clave
La acción preventiva empieza con la tendencia y la causa, no solo después del incumplimiento.$b$, title = $b$El límite no es un objetivo$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 4;
update public.lesson_audio_segments seg set title = $b$El límite no es un objetivo$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Construir una identificación completa de materiales, tareas, puestos y situaciones anormales.

Explicación vinculada al audio
La evaluación comienza identificando materiales con sílice cristalina y tareas que puedan poner polvo respirable en suspensión. Deben incluirse operaciones habituales, mantenimiento, limpiezas, averías, trabajos no regulares y posibles exposiciones procedentes de otras áreas. Una matriz de tareas resulta útil para relacionar material, operación, duración, trabajadores, controles existentes y situaciones anormales. Debe incluir contratistas y puestos indirectos. Después se priorizan los escenarios con mayor potencial de generar SCR y se diseña una estrategia de medición representativa. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
La matriz debe relacionar material, porcentaje de sílice, operación, duración, número de personas, controles, fallos y exposición externa. Debe incluir mantenimiento, limpieza, contratas y accesos esporádicos. Esta base permite formar grupos de exposición y diseñar muestreo representativo.

Secuencia de aplicación
• Inventariar materias primas y productos.
• Descomponer cada puesto en tareas.
• Añadir averías, mantenimiento y limpieza.
• Mapear personas directas, indirectas y contratas.

Caso práctico razonado
La evaluación incluye trituración, pero no el desatasco manual. Un desatasco mensual puede liberar una dosis intensa y debe incorporarse como escenario propio.

Errores críticos
• Usar solo nombres de puestos.
• Excluir tareas infrecuentes.
• Suponer que un análisis de roca sustituye al muestreo.

Idea clave
Una evaluación útil describe lo que realmente se hace, también cuando el proceso deja de funcionar con normalidad.$b$, title = $b$Identificación de materiales y tareas$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 5;
update public.lesson_audio_segments seg set title = $b$Identificación de materiales y tareas$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Comprender el muestreo personal en la zona de respiración y la función del personal competente.

Explicación vinculada al audio
La exposición se mide con equipos personales portados por el trabajador. El muestreador se coloca en su zona de respiración y la estrategia debe ser representativa de la actividad real. La toma la realiza personal competente y no el propio trabajador. El cabezal debe situarse correctamente y permanecer sin obstrucciones durante la jornada. El personal competente registra caudal, tiempos, incidencias y tareas realizadas. Si el trabajador cambia de zona o se produce una parada, esa información permite interpretar el resultado en lugar de tratarlo como un dato aislado. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
El muestreador debe acompañar al trabajador y situarse en la semiesfera de respiración, sin quedar tapado. El personal competente calibra, observa, registra tareas e incidencias y permanece durante el muestreo. Un captador fijo en la instalación puede caracterizar ambiente, pero no sustituye la medición personal exigida.

Secuencia de aplicación
• Calibrar y montar el conjunto correctamente.
• Colocar el cabezal en la zona de respiración.
• Acompañar tareas reales y registrar cambios.
• Comprobar caudal y tratar incidencias.

Caso práctico razonado
Un operador se quita el equipo durante una pausa y lo deja cerca de la trituradora: el resultado deja de representar su exposición y la incidencia debe registrarse.

Errores críticos
• Colgar el muestreador en la cabina vacía.
• Dejar al trabajador gestionar solo la muestra.
• Ocultar el cabezal bajo ropa.

Idea clave
La muestra válida sigue a la persona y documenta fielmente su jornada.$b$, title = $b$Muestreo personal en la zona de respiración$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 6;
update public.lesson_audio_segments seg set title = $b$Muestreo personal en la zona de respiración$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Garantizar que duración y estrategia representen la jornada completa.

Explicación vinculada al audio
La toma de muestras debe extenderse a toda la jornada de trabajo. Solo puede reducirse excepcionalmente por exigencias analíticas, dejando constancia de la incidencia y garantizando que la muestra siga siendo suficiente y representativa de la exposición diaria. La representatividad exige cubrir las fases que definen la exposición habitual. Si la muestra se acorta por saturación, debe justificarse y seguir describiendo la jornada completa mediante una estrategia técnicamente válida. Una medición cómoda pero ajena al trabajo real puede conducir a decisiones preventivas equivocadas. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
La regla general es muestrear toda la jornada. Solo se reduce excepcionalmente por exigencias analíticas como saturación, dejando constancia y conservando representatividad de la actividad total. Elegir solo la fase limpia sesga el resultado aunque el tiempo sea largo.

Secuencia de aplicación
• Planificar cobertura de todas las fases.
• Registrar tiempos y tareas.
• Justificar cualquier reducción excepcional.
• Interpretar jornada real y referencia de ocho horas.

Caso práctico razonado
Una muestra de cuatro horas cubre solo la mañana húmeda y omite la tarde seca con carga máxima: no representa la exposición diaria.

Errores críticos
• Muestrear la franja más cómoda.
• Eliminar picos para evitar saturación sin justificar.
• Extrapolar sin base técnica.

Idea clave
La representatividad depende de cubrir la variabilidad, no solo de acumular minutos.$b$, title = $b$Duración y representatividad de la muestra$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 7;
update public.lesson_audio_segments seg set title = $b$Duración y representatividad de la muestra$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar la frecuencia mínima cuatrimestral y ampliarla cuando el riesgo lo requiera.

Explicación vinculada al audio
En los puestos con riesgo de exposición a polvo se tomarán muestras, como mínimo, una vez cada cuatrimestre del año natural. Los análisis los realiza el Instituto Nacional de Silicosis o un laboratorio reconocido por la Autoridad Minera. La frecuencia mínima cuatrimestral no impide medir más cuando cambian condiciones, fallan controles o existe incertidumbre. Las campañas deben repartirse de forma que recojan variabilidad estacional y productiva. Repetir siempre el muestreo en el momento más favorable reduciría su utilidad preventiva. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
“Una vez cada cuatrimestre del año natural” implica al menos tres campañas distribuidas. Es un mínimo, no una prohibición de medir tras cambios, fallos o incertidumbre. Seleccionar siempre días favorables reduce la capacidad de detectar variabilidad estacional.

Secuencia de aplicación
• Distribuir campañas por cuatrimestres.
• Capturar estaciones y condiciones relevantes.
• Añadir mediciones tras cambios o fallos.
• Usar laboratorios reconocidos.

Caso práctico razonado
Las tres muestras se realizan en días lluviosos pese a que la mayor producción ocurre en verano. La frecuencia formal se cumple, pero la estrategia puede no ser representativa.

Errores críticos
• Concentrar campañas en el mismo mes.
• Elegir solo condiciones favorables.
• Esperar al siguiente cuatrimestre tras una avería grave.

Idea clave
Cumplir calendario no basta: cada campaña debe aportar evidencia representativa.$b$, title = $b$Frecuencia de las mediciones$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 8;
update public.lesson_audio_segments seg set title = $b$Frecuencia de las mediciones$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Revisar la evaluación por cambios, daños o ineficacia y, en todo caso, cada tres años.

Explicación vinculada al audio
La evaluación se revisa cuando cambian las condiciones, aparecen daños para la salud o las medidas resultan insuficientes. En minería, la ITC exige además revisarla en todo caso cada tres años, sin esperar a que ocurra un incidente. La revisión trienal es un máximo ordinario, no una espera obligatoria. Una nueva trituradora, un cambio de material, un diagnóstico relacionado o resultados crecientes exigen actuar antes. Revisar significa volver a comprobar peligros, exposición y eficacia de controles, y actualizar medidas y documentación. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
El plazo trienal es máximo ordinario. Cambiar material, proceso, producción, control, diagnóstico o tendencia puede exigir revisión inmediata. Revisar no significa cambiar la fecha: implica reconsiderar peligros, grupos, mediciones, eficacia y medidas.

Secuencia de aplicación
• Definir disparadores de revisión.
• Reevaluar antes de cambios planificados.
• Incorporar resultados sanitarios y ambientales.
• Actualizar DSS, procedimientos y formación.

Caso práctico razonado
Se instala una trituradora nueva seis meses después de la última evaluación. No se espera dos años y medio; se revisa antes de exponer.

Errores críticos
• Esperar siempre tres años.
• Limitarse a cambiar la portada.
• Revisar solo tras accidente.

Idea clave
Cada tres años es el máximo; cualquier cambio relevante adelanta la revisión.$b$, title = $b$Revisión de la evaluación de riesgos$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 9;
update public.lesson_audio_segments seg set title = $b$Revisión de la evaluación de riesgos$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Comunicar resultados individuales de manera comprensible y conservar trazabilidad con confidencialidad sanitaria.

Explicación vinculada al audio
Cada trabajador debe conocer los riesgos de su puesto, los resultados que le afecten y las medidas implantadas. Los valores de exposición se registran periódicamente en fichas individualizadas para conocer el riesgo acumulado y se incorporan al expediente médico. La comunicación debe ser comprensible y relacionar el dato con el puesto y las medidas necesarias. No basta con entregar una cifra sin contexto. La trazabilidad individual permite observar tendencias y vincular tareas, resultados y vigilancia sanitaria respetando la confidencialidad de la información médica. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica
El trabajador debe conocer qué se midió, en qué tarea, qué resultado le afecta, cómo se interpreta y qué medidas siguen. Las fichas individualizadas se integran en su expediente médico, pero los datos sanitarios tienen acceso reservado. La comunicación preventiva no consiste en entregar una cifra sin contexto.

Secuencia de aplicación
• Relacionar resultado, jornada y tarea.
• Explicar comparación y tendencia.
• Informar medidas y acciones previstas.
• Proteger confidencialidad médica.

Caso práctico razonado
Un trabajador recibe “0,038 mg/m³” sin explicar tarea ni controles. No puede valorar significado ni saber qué conducta mantener; la información es incompleta.

Errores críticos
• Publicar expedientes médicos.
• Comunicar solo si hay incumplimiento.
• Entregar cifras sin explicación.

Idea clave
La transparencia preventiva exige contexto; la confidencialidad protege la información sanitaria, no oculta la exposición.$b$, title = $b$Información individual sobre la exposición$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 10;
update public.lesson_audio_segments seg set title = $b$Información individual sobre la exposición$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 2 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar la jerarquía: evitar, controlar en origen y medio, organizar y proteger el riesgo residual.

Explicación vinculada al audio
La prioridad es evitar la generación de polvo o reducirla en el foco. Después se actúa sobre el medio de propagación y, por último, sobre el trabajador. La protección respiratoria complementa estas medidas, pero no puede sustituirlas. La jerarquía evita convertir la mascarilla en solución automática. Primero se elimina o reduce el foco; después se encierra, capta o asienta el contaminante; a continuación se limita la exposición mediante organización; y solo como complemento se selecciona protección respiratoria adecuada al riesgo residual. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
La mascarilla no debe convertirse en respuesta automática. Se prioriza eliminar o modificar el proceso; después cerramiento, captación o vía húmeda; luego separación, tiempo y acceso; por último EPI durante el tiempo imprescindible. Las capas se complementan y su eficacia se verifica.

Secuencia de aplicación
• Identificar si puede evitarse la tarea o emisión.
• Actuar en el foco.
• Controlar propagación y acceso.
• Seleccionar EPI para el riesgo residual.

Caso práctico razonado
Una perforadora emite polvo por una boquilla obstruida. Entregar mascarillas sin reparar el riego mantiene un foco evitable y contradice la jerarquía.

Errores críticos
• Sustituir mantenimiento por EPI.
• Elegir primero la solución más barata.
• Retirar controles colectivos al usar mascarilla.

Idea clave
El EPI protege a una persona; el control en origen evita que el contaminante alcance a todas.$b$, title = $b$Jerarquía de medidas preventivas$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 1;
update public.lesson_audio_segments seg set title = $b$Jerarquía de medidas preventivas$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Reducir emisión modificando material, método, herramienta, velocidad, caída o secuencia.

Explicación vinculada al audio
Cuando sea técnicamente posible, deben sustituirse materiales o procedimientos por otros menos peligrosos. En minería la sustitución de la roca suele ser inviable, pero sí pueden modificarse métodos, herramientas, velocidades o secuencias para generar menos polvo. Aunque no pueda sustituirse el mineral, sí pueden compararse herramientas, métodos húmedos, velocidades de corte, alturas de caída o secuencias de apertura. Cada cambio debe evaluarse de forma global para no crear otros riesgos, como proyecciones, resbalones, atrapamientos o contaminación del agua. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
Aunque no pueda sustituirse la roca, casi siempre pueden compararse métodos. El cambio se evalúa globalmente para evitar riesgos secundarios: agua y electricidad, barro, atrapamiento, proyección o residuo contaminado. La mejora se valida mediante observación, mantenimiento y medición.

Secuencia de aplicación
• Generar varias alternativas técnicas.
• Comparar emisión y exposición esperada.
• Evaluar riesgos secundarios.
• Probar, medir y documentar la opción.

Caso práctico razonado
Reducir altura de caída baja polvo, pero desplaza un punto de trabajo hacia una zona de atrapamiento. La solución debe rediseñarse sin intercambiar un riesgo por otro.

Errores críticos
• Cambiar sin evaluar seguridad global.
• Descartar cambios porque la roca no es sustituible.
• Dar por eficaz una prueba visual.

Idea clave
Modificar el proceso es prevención en origen solo si reduce la exposición sin crear un riesgo mayor.$b$, title = $b$Sustitución y modificación del proceso$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 2;
update public.lesson_audio_segments seg set title = $b$Sustitución y modificación del proceso$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Mantener confinamientos íntegros y compatibles con captación, acceso y limpieza.

Explicación vinculada al audio
Carenados, capotajes y cerramientos limitan la dispersión del polvo en trituradoras, cintas y puntos de transferencia. Para ser eficaces deben mantenerse íntegros, combinarse cuando proceda con aspiración y abrirse solo siguiendo el procedimiento establecido. Un cerramiento con huecos, tapas abiertas o juntas deterioradas pierde eficacia. También puede generar acumulaciones que después se liberan durante el mantenimiento. La inspección práctica debe comprobar integridad, depresión cuando proceda, acceso seguro y un método de limpieza que no vuelva a dispersar el polvo. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
Un cerramiento necesita juntas, tapas y conductos en buen estado y, cuando procede, depresión suficiente. Abrirlo altera el flujo y puede liberar acumulaciones. Mantenimiento y limpieza deben planificarse con parada, aislamiento, aspiración y protección residual.

Secuencia de aplicación
• Inspeccionar integridad y cierres.
• Verificar depresión o caudal de captación.
• Mantener accesos cerrados durante operación.
• Planificar apertura y limpieza segura.

Caso práctico razonado
Una tapa queda abierta para observar el material. La aspiración continúa, pero el punto de entrada de aire cambia y puede escapar polvo hacia el trabajador.

Errores críticos
• Retirar paneles para mejorar acceso.
• Sellar sin prever mantenimiento.
• Barrer acumulaciones del interior.

Idea clave
Un cerramiento solo protege si conserva su geometría y se abre bajo procedimiento.$b$, title = $b$Confinamiento y cerramientos$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 3;
update public.lesson_audio_segments seg set title = $b$Confinamiento y cerramientos$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Conservar la protección de cabinas mediante cierre, filtración, presurización y limpieza controlada.

Explicación vinculada al audio
Las cabinas cerradas, con filtración y presión positiva, aíslan al operador del ambiente contaminado. Su eficacia depende de mantener puertas y ventanas cerradas, revisar juntas y filtros y comprobar que el sistema funciona durante toda la tarea. La presión positiva solo protege si el caudal de aire filtrado compensa las entradas no controladas. Abrir una ventana, usar un filtro saturado o mantener una puerta con juntas dañadas puede anular el sistema. El operador debe reconocer indicadores de fallo y comunicar cualquier pérdida de estanqueidad. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
La presión positiva evita entrada de polvo si puertas, ventanas y sellos están cerrados. Filtros saturados, fugas o climatización mal mantenida reducen el diferencial. Introducir ropa contaminada o barrer la cabina crea una fuente interior que la presurización no elimina.

Secuencia de aplicación
• Comprobar indicador o diferencial de presión.
• Revisar filtros, juntas y puertas.
• Mantener ventanas cerradas.
• Limpiar interior con aspiración adecuada.

Caso práctico razonado
Un operador abre la ventana por calor. Aunque el filtro sea nuevo, anula la barrera de presión y recibe aire sin filtrar.

Errores críticos
• Abrir para desempañar.
• Sacudir ropa dentro.
• Cambiar filtro solo cuando se vea polvo.

Idea clave
La cabina es un sistema de protección, no solo un habitáculo cerrado.$b$, title = $b$Cabinas cerradas y presurizadas$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 4;
update public.lesson_audio_segments seg set title = $b$Cabinas cerradas y presurizadas$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar agua en cantidad, tamaño de gota y punto adecuados sin generar riesgos secundarios.

Explicación vinculada al audio
La inyección, pulverización o niebla de agua ayuda a impedir que las partículas pasen al aire y favorece su sedimentación. El sistema debe aplicarse en el punto adecuado y mantenerse operativo, evitando que el agua cree nuevos riesgos. Más agua no siempre significa mejor control. Deben ajustarse tamaño de gota, orientación, caudal y punto de aplicación al polvo generado. También se vigilan barro, visibilidad, estabilidad del firme, heladas y consumo. Una boquilla obstruida o mal orientada puede dejar el foco prácticamente sin protección. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
La humectación evita que el material genere aerosol y la pulverización captura o asienta. Boquillas obstruidas, mala orientación o presión insuficiente dejan zonas secas. Demasiada agua puede crear barro, resbalones, drenajes contaminados o afectar al proceso.

Secuencia de aplicación
• Verificar suministro, presión y cobertura.
• Orientar al foco y sincronizar con proceso.
• Mantener boquillas limpias.
• Controlar drenaje, barro y calidad del producto.

Caso práctico razonado
El manómetro indica presión normal, pero varias boquillas están taponadas. El indicador general no demuestra cobertura efectiva; hay que observar el patrón.

Errores críticos
• Regar solo cuando se ve nube.
• Aumentar caudal sin límite.
• Confiar únicamente en el manómetro.

Idea clave
La vía húmeda se valida por cobertura efectiva del foco y control de sus consecuencias.$b$, title = $b$Control por vía húmeda$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 5;
update public.lesson_audio_segments seg set title = $b$Control por vía húmeda$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Capturar el polvo cerca del foco con caudal y diseño compatibles con la emisión.

Explicación vinculada al audio
La aspiración localizada captura el polvo cerca del punto de generación antes de que alcance la zona de respiración. Campanas, conductos, filtros y separadores deben dimensionarse, revisarse y mantenerse para conservar el caudal y la eficacia previstos. La campana debe estar próxima al foco y el aire captado debe conducirse y filtrarse sin fugas. Pérdidas de carga, conductos rotos o filtros colmatados reducen el caudal. La verificación combina inspección, indicadores de presión y, cuando proceda, medición del rendimiento del sistema. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
La aspiración localizada necesita velocidad de captura, proximidad, conductos estancos, filtros y descarga segura. Alejar la campana reduce rápidamente eficacia. Abrir cerramientos o aumentar producción puede superar el caudal disponible. El mantenimiento se hace sin liberar el polvo capturado.

Secuencia de aplicación
• Comprobar posición de campana.
• Verificar caudal/depresión y conductos.
• Revisar filtros y alarmas.
• Reevaluar tras cambios de producción.

Caso práctico razonado
Se aumenta el tonelaje un 30 % y aparece emisión pese a que el ventilador funciona. El sistema puede haber quedado subdimensionado y debe reevaluarse.

Errores críticos
• Confundir ventilación general con captación.
• Vaciar filtros sin control.
• Aceptar emisión porque el motor gira.

Idea clave
Que el ventilador funcione no prueba que el contaminante sea capturado.$b$, title = $b$Captación y aspiración localizada$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 6;
update public.lesson_audio_segments seg set title = $b$Captación y aspiración localizada$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Controlar emisiones de pistas, transporte y acopios mediante firme, agua, velocidad y geometría.

Explicación vinculada al audio
El riego o estabilización de pistas, la limitación de velocidad, la limpieza de ruedas y el cubrimiento de cargas reducen las emisiones del transporte. Los acopios pueden protegerse del viento y gestionarse para evitar caídas y manipulaciones innecesarias. El control del transporte exige coordinar riego, mantenimiento de firme, velocidad y limpieza. Regar sin reparar baches puede generar barro y pérdida de control; limitar velocidad sin supervisión puede no funcionar. En acopios, la altura de caída y la orientación respecto al viento son variables decisivas. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
El tráfico resuspende finos. Riego, estabilización, reparación, limpieza de derrames y velocidad actúan juntos. En acopios importan altura de caída, humedad y orientación al viento. La medida debe evitar barro, pérdida de adherencia y contaminación del agua.

Secuencia de aplicación
• Mantener firme y drenaje.
• Ajustar riego a clima y tráfico.
• Controlar velocidad y derrames.
• Reducir altura de caída y exposición al viento.

Caso práctico razonado
Regar una pista con baches crea charcos y barro; reducir polvo a costa de perder control del vehículo no es aceptable.

Errores críticos
• Usar solo una señal de velocidad.
• Regar sin revisar adherencia.
• Dejar finos acumulados en bordes.

Idea clave
Las emisiones difusas se controlan con un sistema coordinado, no con una medida aislada.$b$, title = $b$Pistas, transporte y acopios$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 7;
update public.lesson_audio_segments seg set title = $b$Pistas, transporte y acopios$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Limpiar sin volver a poner el contaminante en suspensión ni trasladarlo.

Explicación vinculada al audio
La limpieza debe realizarse por aspiración industrial o por vía húmeda. Barrer en seco o utilizar aire comprimido vuelve a poner el polvo en suspensión y aumenta la exposición, por lo que estas prácticas deben evitarse salvo procedimiento específicamente controlado. La aspiración debe ser apta para el polvo recogido y mantenerse conforme al fabricante. En limpieza húmeda se evita crear salpicaduras o arrastres contaminados. Antes de intervenir se planifica dónde irá el residuo y cómo se limpiará el propio equipo sin exponer nuevamente al trabajador. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
La aspiración industrial adecuada o la vía húmeda son métodos preferentes. Aire comprimido y barrido seco dispersan el polvo y contaminan superficies cercanas. Debe definirse el destino del residuo y cómo se descontamina el propio aspirador o útil.

Secuencia de aplicación
• Planificar área, método y residuo.
• Usar aspiración apta o vía húmeda.
• Delimitar y proteger según riesgo residual.
• Limpiar equipos sin dispersar.

Caso práctico razonado
Un operario barre al final del turno cuando no hay producción. Aunque haya menos personas, genera exposición propia y contaminación residual.

Errores críticos
• Barrer cuando no haya supervisión.
• Soplar ropa con aire.
• Vaciar aspirador en saco abierto.

Idea clave
La limpieza elimina polvo; si lo suspende de nuevo, traslada el riesgo en vez de controlarlo.$b$, title = $b$Limpieza segura$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 8;
update public.lesson_audio_segments seg set title = $b$Limpieza segura$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Convertir el mantenimiento de controles en comprobaciones con criterios de aceptación y parada.

Explicación vinculada al audio
Una medida preventiva solo protege si funciona. Deben revisarse boquillas, captaciones, filtros, cerramientos, cabinas y sistemas de riego. Cualquier fallo se comunica y corrige antes de continuar si compromete el control de la exposición. El mantenimiento preventivo debe definir responsable, frecuencia, criterio de aceptación y registro. No basta con anotar que se ha revisado. Una lista útil obliga a comprobar caudal, presión, estado de filtros, boquillas, puertas y alarmas, y establece qué fallos requieren detener la tarea. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
Una lista útil define qué se mide, rango aceptable, responsable, frecuencia y acción. “Revisado” no demuestra caudal, presión, saturación o cierre. El mantenimiento preventivo evita que la exposición sea el primer indicador del fallo.

Secuencia de aplicación
• Definir parámetro y rango.
• Inspeccionar con frecuencia basada en fallo.
• Registrar resultado, no solo firma.
• Establecer criterio de parada y reparación.

Caso práctico razonado
Una boquilla se anota como revisada, pero no se registra patrón ni presión. No hay evidencia de que controle el foco.

Errores críticos
• Usar la nube como alarma de mantenimiento.
• Posponer defectos al mantenimiento anual.
• Aceptar controles sin indicadores.

Idea clave
Una barrera preventiva necesita condición verificable y respuesta definida cuando falla.$b$, title = $b$Mantenimiento de las medidas de control$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 9;
update public.lesson_audio_segments seg set title = $b$Mantenimiento de las medidas de control$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Planificar averías, reparaciones e inspecciones como exposiciones no regulares de potencial elevado.

Explicación vinculada al audio
En averías, reparaciones, inspecciones y limpiezas extraordinarias puede aumentar la exposición. Se limitará el acceso a personal autorizado, se reducirá el tiempo imprescindible y se usarán medidas técnicas y protección respiratoria adecuadas al riesgo. Estas situaciones requieren planificación previa: delimitar la zona, informar al personal, reducir el número de expuestos y elegir controles temporales. Al finalizar se realiza limpieza segura y se verifica la recuperación del control normal. La urgencia de una reparación no elimina el riesgo cancerígeno. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica
Se limita acceso, número y tiempo; se aíslan energías; se aplican captación o humedad temporal; se selecciona EPI por concentración prevista y se limpia antes de reabrir. La urgencia productiva no reduce carcinogenicidad ni justifica exposición desconocida.

Secuencia de aplicación
• Parar y delimitar.
• Evaluar tarea y concentración potencial.
• Autorizar personal mínimo con controles y EPI.
• Verificar limpieza y recuperación antes de abrir.

Caso práctico razonado
Una tubería de aspiración se rompe y mantenimiento entra sin delimitar porque la reparación durará cinco minutos. La corta duración no elimina el pico ni la dispersión.

Errores críticos
• Entrar por ser reparación breve.
• Usar mascarilla no seleccionada.
• Reabrir sin verificar control.

Idea clave
Las tareas excepcionales se planifican antes del fallo y se controlan hasta recuperar la condición normal.$b$, title = $b$Exposición accidental o no regular$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 10;
update public.lesson_audio_segments seg set title = $b$Exposición accidental o no regular$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 3 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Definir cuándo el EPI respiratorio es necesario y por qué su uso debe limitarse al riesgo residual.

Explicación vinculada al audio
La protección respiratoria se utiliza cuando las medidas técnicas y organizativas no eliminan suficientemente el riesgo, durante exposiciones accidentales o mientras se implantan soluciones más eficaces. Su uso debe limitarse al tiempo imprescindible y ajustarse a la evaluación. La decisión debe indicar para qué tarea, durante cuánto tiempo y con qué factor de protección se utiliza el equipo. Si la exposición es desconocida o puede ser muy alta, una mascarilla filtrante sencilla puede resultar insuficiente. La selección corresponde a la evaluación, no a la preferencia personal. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
La evaluación determina tarea, concentración, tiempo y factor de protección. En condiciones desconocidas o muy altas puede requerirse un equipo distinto de una mascarilla filtrante. El EPI se usa durante implantación de controles, exposición accidental o insuficiencia residual, sin sustituir la corrección del foco.

Secuencia de aplicación
• Caracterizar contaminante y concentración.
• Seleccionar factor de protección necesario.
• Limitar duración y usuarios.
• Corregir la medida colectiva.

Caso práctico razonado
Tras fallo de aspiración, se propone trabajar todo el turno con FFP2. Sin estimar concentración ni corregir el sistema, no puede asegurarse protección suficiente.

Errores críticos
• Elegir por comodidad.
• Usar el EPI como solución permanente.
• Entrar con concentración desconocida.

Idea clave
El equipo respiratorio se selecciona por riesgo evaluado; no convierte un ambiente desconocido en seguro.$b$, title = $b$Cuándo utilizar protección respiratoria$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 1;
update public.lesson_audio_segments seg set title = $b$Cuándo utilizar protección respiratoria$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Seleccionar pieza facial, filtro o equipo asistido según exposición, tarea y persona.

Explicación vinculada al audio
El tipo de mascarilla, filtro o equipo asistido debe elegirse según la concentración, la tarea, el tiempo de uso y las características del trabajador. No todos los equipos protegen igual ni resultan adecuados para cualquier nivel de exposición. Además del contaminante se valoran esfuerzo físico, temperatura, compatibilidad con gafas o casco y posibles limitaciones médicas. El equipo debe disponer de marcado y documentación aplicables. Un filtro adecuado instalado en una pieza facial que no ajusta sigue ofreciendo una protección deficiente. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
Además del factor de protección se consideran esfuerzo, calor, duración, visión, comunicación, gafas, casco y limitaciones médicas. El marcado y la documentación deben corresponder al uso. Un filtro correcto con fuga facial no alcanza la protección nominal.

Secuencia de aplicación
• Definir factor necesario.
• Evaluar ergonomía y compatibilidad.
• Comprobar documentación y talla.
• Validar ajuste individual y formación.

Caso práctico razonado
Un trabajador realiza esfuerzo intenso durante dos horas y no tolera bien la resistencia respiratoria. Debe valorarse un equipo asistido u otra solución, no aflojar la mascarilla.

Errores críticos
• Elegir un modelo universal.
• Compartir sin descontaminar.
• Aflojar correas para respirar mejor.

Idea clave
La selección correcta combina nivel de protección y capacidad real de uso durante toda la tarea.$b$, title = $b$Selección del equipo adecuado$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 2;
update public.lesson_audio_segments seg set title = $b$Selección del equipo adecuado$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Garantizar estanqueidad mediante ensayo cuantitativo y comprobación diaria de sellado.

Explicación vinculada al audio
Un equipo filtrante solo protege si sella correctamente sobre la cara. Debe realizarse el control de ajuste indicado y la formación práctica incluirá ensayos cuantitativos. Barba, patillas, suciedad o una talla incorrecta pueden romper la estanqueidad. El ensayo cuantitativo comprueba con una medida objetiva si un modelo y talla concretos sellan en esa persona. Debe repetirse cuando cambia la pieza facial o existen cambios físicos relevantes. La comprobación diaria de sellado complementa el ensayo, pero no lo sustituye. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
El ensayo cuantitativo verifica un modelo y talla en una persona; no se transfiere a otra. Se repite tras cambios de pieza facial o cambios físicos relevantes. Barba, patillas, cicatrices, suciedad o gafas interfiriendo rompen el sello. La comprobación diaria no sustituye al ensayo.

Secuencia de aplicación
• Elegir modelo/talla individual.
• Realizar ensayo cuantitativo.
• Mantener zona de sellado libre.
• Comprobar sellado en cada colocación.

Caso práctico razonado
Un trabajador supera el ensayo afeitado y semanas después lleva barba en la línea de sellado. El resultado anterior deja de garantizar estanqueidad.

Errores críticos
• Aprobar por talla de ropa.
• Compartir resultado de ajuste.
• Confiar solo en presión manual.

Idea clave
El ajuste pertenece al conjunto persona-modelo-talla-condición facial.$b$, title = $b$Ajuste y estanqueidad facial$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 3;
update public.lesson_audio_segments seg set title = $b$Ajuste y estanqueidad facial$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Colocar antes de entrar, retirar fuera, descontaminar y almacenar sin deformar ni contaminar.

Explicación vinculada al audio
El equipo se coloca antes de entrar en la zona contaminada y se retira después de salir. Debe limpiarse, revisarse, almacenarse protegido y sustituir filtros o componentes según las instrucciones, sin compartirlo si no está previsto y descontaminado. La retirada es un momento crítico porque la superficie exterior puede estar contaminada. Se siguen pasos que eviten tocar cara y vías respiratorias, y después se limpia o desecha según el tipo. El almacenamiento protege de polvo, humedad, deformación, luz y productos químicos. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
La superficie exterior puede contener SCR. La retirada evita tocar cara y parte interna; el filtro se cambia por criterio de fabricante/evaluación, no solo cuando se nota resistencia. El almacenamiento protege de polvo, humedad, luz, productos químicos y deformación.

Secuencia de aplicación
• Inspeccionar antes de usar.
• Colocar y comprobar en zona limpia.
• Retirar fuera evitando contacto contaminado.
• Limpiar, secar y guardar protegido.

Caso práctico razonado
Una mascarilla reutilizable se deja abierta sobre el salpicadero. El interior puede contaminarse y el calor deformar el sello.

Errores críticos
• Retirar dentro para hablar.
• Lavar filtros no lavables.
• Guardar en bolsa contaminada.

Idea clave
La protección continúa dependiendo del equipo cuando ya no se lleva: conservación y retirada son parte del uso.$b$, title = $b$Colocación, retirada y conservación$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 4;
update public.lesson_audio_segments seg set title = $b$Colocación, retirada y conservación$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Evitar ingestión y traslado del contaminante mediante separación limpia/sucia e higiene.

Explicación vinculada al audio
En las zonas con riesgo no se debe comer, beber ni fumar. Hay que lavarse antes de las pausas y al terminar, usar las instalaciones higiénicas previstas y evitar trasladar polvo a comedores, vehículos, viviendas u otras zonas limpias. La separación entre zonas limpias y sucias reduce la ingestión y el traslado de contaminante. Lavarse manos y cara, ducharse cuando proceda y respetar vestuarios separados forman parte del control. Comer dentro de la cabina solo sería admisible si el procedimiento garantiza realmente una zona limpia. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
No se come, bebe o fuma en zonas de riesgo. Lavado, duchas cuando proceda y vestuarios separados cortan la vía de transferencia. Una cabina solo es zona limpia si se mantiene cerrada, filtrada y sin contaminación interior; no basta con estar aislada visualmente.

Secuencia de aplicación
• Respetar zonas de higiene.
• Lavarse antes de pausas.
• Mantener comedores y cabinas limpios.
• Evitar traslado a vehículos y hogares.

Caso práctico razonado
Un operador come en una cabina con polvo en superficies y ropa contaminada. La presurización no elimina la contaminación ya introducida.

Errores críticos
• Comer con guantes.
• Usar aire para limpiar ropa.
• Guardar comida junto a EPI.

Idea clave
La higiene impide que el polvo pase de la zona de trabajo al organismo y a espacios limpios.$b$, title = $b$Higiene personal$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 5;
update public.lesson_audio_segments seg set title = $b$Higiene personal$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Gestionar ropa contaminada sin liberar polvo ni llevarlo al domicilio.

Explicación vinculada al audio
La empresa debe proporcionar ropa de protección cuando proceda y organizar su limpieza o descontaminación. La ropa contaminada no debe llevarse a casa. Se guardará separada de la ropa de calle y se manipulará evitando liberar polvo. La ropa no debe sacudirse ni limpiarse con aire comprimido. Se retira siguiendo un método que limite la dispersión, se deposita en recipientes definidos y se lava por un sistema gestionado por la empresa. La familia del trabajador no debe quedar expuesta por contaminación doméstica. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
La empresa organiza retirada, almacenamiento, transporte y lavado. La ropa de calle se separa; las prendas no se sacuden ni se soplan; los recipientes evitan dispersión y se identifican. La contaminación doméstica puede exponer a familiares ajenos al trabajo.

Secuencia de aplicación
• Retirar sin sacudir.
• Depositar en recipiente definido.
• Separar de ropa de calle.
• Gestionar limpieza por la empresa.

Caso práctico razonado
Un trabajador lleva el mono en una bolsa a casa para lavarlo. Aunque vaya cerrado, traslada la responsabilidad y el contaminante fuera del sistema empresarial.

Errores críticos
• Lavar junto a ropa familiar.
• Soplar antes de guardar.
• Reutilizar hasta que se vea sucio.

Idea clave
La ropa de trabajo contaminada no abandona el circuito de descontaminación de la empresa.$b$, title = $b$Ropa de trabajo y descontaminación$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 6;
update public.lesson_audio_segments seg set title = $b$Ropa de trabajo y descontaminación$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Entender la vigilancia sanitaria específica como detección precoz vinculada al riesgo.

Explicación vinculada al audio
La empresa garantizará una vigilancia adecuada y específica realizada por personal sanitario competente. Su contenido y periodicidad se fijan conforme a los protocolos sanitarios y al riesgo, no mediante una regla única basada solo en el porcentaje de sílice de la roca. La vigilancia sanitaria no sustituye el control ambiental ni demuestra por sí sola que un puesto sea seguro. Su objetivo es detectar precozmente posibles efectos y valorar la aptitud con criterios sanitarios. Los resultados colectivos también pueden revelar la necesidad de revisar la prevención. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
Personal sanitario competente define contenido y periodicidad según protocolos, exposición e historia. No existe una regla única basada solo en porcentaje de sílice. Los resultados individuales son confidenciales; las conclusiones preventivas y colectivas pueden exigir revisión de puestos y controles.

Secuencia de aplicación
• Garantizar vigilancia específica.
• Aportar historial de exposición.
• Respetar confidencialidad.
• Revisar prevención ante hallazgos.

Caso práctico razonado
Un reconocimiento sin hallazgos no demuestra que la aspiración funcione ni permite suspender muestreos.

Errores críticos
• Usar reconocimiento como medición ambiental.
• Aplicar igual periodicidad a todos sin riesgo.
• Entregar diagnósticos a mandos no sanitarios.

Idea clave
Vigilar la salud detecta efectos; controlar el ambiente evita que aparezcan.$b$, title = $b$Vigilancia específica de la salud$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 7;
update public.lesson_audio_segments seg set title = $b$Vigilancia específica de la salud$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Mantener un historial coherente de puestos, tareas, tiempos y resultados a lo largo de la vida laboral.

Explicación vinculada al audio
Los resultados de exposición de cada trabajador se registran para conocer el riesgo acumulado y se incorporan a su expediente médico. Esta trazabilidad permite relacionar los puestos, tareas, tiempos y mediciones con la vigilancia de la salud. El historial debe poder seguir cambios de puesto, centros, tareas y resultados a lo largo del tiempo. Los datos médicos permanecen bajo confidencialidad sanitaria, mientras que la empresa gestiona la información preventiva necesaria. Una trazabilidad incompleta dificulta valorar la dosis acumulada. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
La dosis acumulada no coincide con el último resultado. Cambios de centro, contrata, tarea y controles deben quedar trazados. Las fichas se incorporan al expediente médico, mientras la empresa conserva los registros preventivos previstos. La falta de continuidad limita la interpretación sanitaria.

Secuencia de aplicación
• Identificar puesto y tarea real.
• Registrar fechas, duración y controles.
• Vincular mediciones al trabajador.
• Conservar y transferir según obligaciones.

Caso práctico razonado
Un trabajador rota entre perforación y cabina, pero todas las mediciones figuran bajo “operario”. Sin tareas y tiempos, el historial pierde utilidad.

Errores críticos
• Usar categorías genéricas.
• Borrar datos al cambiar de puesto.
• Mezclar datos médicos con acceso general.

Idea clave
La trazabilidad convierte resultados aislados en una historia de exposición interpretable.$b$, title = $b$Historial de exposición$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 8;
update public.lesson_audio_segments seg set title = $b$Historial de exposición$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Comunicar fallos de control con información suficiente y detener cuando comprometan protección.

Explicación vinculada al audio
El trabajador debe avisar si una perforadora emite polvo, falla una boquilla, una cabina no presuriza, la ventilación se detiene o se limpia en seco. Comunicarlo pronto permite corregir la causa antes de que afecte a más personas. Una comunicación eficaz describe el equipo, el síntoma del fallo, el momento y la tarea afectada. También indica si se ha detenido el trabajo o delimitado la zona. Avisar sin abandonar la exposición o sin impedir que otro ocupe el puesto puede resultar insuficiente. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
El aviso debe identificar equipo, síntoma, momento, tarea, personas afectadas y condición adoptada. Comunicar sin salir del foco o sin impedir relevo no controla la exposición. Las reglas deben indicar qué defectos obligan a parada, zona restringida o método alternativo.

Secuencia de aplicación
• Detectar señal o indicador.
• Salir o detener según criterio.
• Delimitar y evitar relevo expuesto.
• Comunicar datos y registrar corrección.

Caso práctico razonado
Una cabina pierde presión. El operador envía un mensaje pero sigue dos horas con ventanas cerradas. La comunicación no compensa la barrera perdida.

Errores críticos
• Avisar al final del turno.
• Abrir ventanas para ventilar.
• Continuar por no ver polvo.

Idea clave
Un aviso eficaz cambia la condición de trabajo y evita que otros hereden el riesgo.$b$, title = $b$Detección y comunicación de fallos$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 9;
update public.lesson_audio_segments seg set title = $b$Detección y comunicación de fallos$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Actuar ante síntomas sin usar su presencia o ausencia como medida ambiental.

Explicación vinculada al audio
La aparición de tos persistente, dificultad respiratoria u otros síntomas debe comunicarse al servicio sanitario, sin esperar al reconocimiento programado. Los síntomas no sirven para medir la exposición, pero requieren valoración y pueden motivar la revisión de las medidas preventivas. La consulta sanitaria temprana permite valorar causas y decidir si procede adaptar el trabajo. No debe culpabilizarse al trabajador ni ocultarse información. Paralelamente se revisan mediciones, controles y personas potencialmente afectadas, porque un síntoma puede señalar una deficiencia colectiva. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica
Tos persistente o disnea requieren consulta sanitaria temprana. Paralelamente se revisan exposición, controles y posibles personas comparables, sin invadir confidencialidad. Un síntoma puede tener otras causas, pero no se ignora ni se atribuye automáticamente sin valoración.

Secuencia de aplicación
• Comunicar al servicio sanitario.
• Valorar urgencia y aptitud.
• Revisar tareas y controles.
• Proteger confidencialidad y no culpabilizar.

Caso práctico razonado
Dos trabajadores del mismo área comunican tos. El servicio sanitario evalúa y prevención revisa captación y mediciones; no se espera al reconocimiento anual.

Errores críticos
• Autodiagnosticarse silicosis.
• Esperar al examen periódico.
• Ocultar síntomas por temor laboral.

Idea clave
Los síntomas activan atención sanitaria y revisión preventiva, no sustituyen el diagnóstico ni la medición.$b$, title = $b$Actuación ante síntomas o sospecha$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 10;
update public.lesson_audio_segments seg set title = $b$Actuación ante síntomas o sospecha$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 4 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Mantener un DSS capaz de demostrar decisiones, controles, responsables y revisión.

Explicación vinculada al audio
La empresa debe conservar la documentación exigida para los trabajos con riesgo de sílice e integrarla en el Documento sobre Seguridad y Salud. Debe incluir la evaluación, los criterios de muestreo, los resultados y las medidas de prevención y protección. La documentación debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida. Incluye puestos, tareas, estrategia de medición, resultados, mantenimiento, formación y acciones correctoras. Un archivo extenso pero desactualizado no cumple la función preventiva del DSS. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La documentación integra evaluación, estrategia de muestreo, resultados, medidas, mantenimiento, formación y acciones correctoras. Debe permitir reconstruir por qué se tomó una decisión y si sigue vigente. Un archivo desactualizado o sin conexión con el trabajo real no cumple su función.

Secuencia de aplicación
• Controlar versión y responsables.
• Vincular evaluación y medidas.
• Adjuntar criterios de muestreo.
• Cerrar acciones con verificación.

Caso práctico razonado
El DSS incluye una aspiración que fue retirada meses atrás. Aunque el documento sea extenso, describe barreras inexistentes y debe actualizarse.

Errores críticos
• Archivar sin revisar.
• Copiar un DSS de otro centro.
• Registrar medidas sin responsables.

Idea clave
Documentar no es acumular papel: es conservar evidencia vigente y trazable para decidir.$b$, title = $b$Documentación preventiva$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 1;
update public.lesson_audio_segments seg set title = $b$Documentación preventiva$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Completar fichas individualizadas con contexto suficiente para interpretar y comparar mediciones.

Explicación vinculada al audio
Los resultados de las tomas de muestras se registran mediante fichas individualizadas. Estas deben permitir identificar el puesto, la jornada, el equipo, las condiciones de trabajo y los resultados de polvo respirable y sílice cristalina respirable. La ficha debe relacionar resultado y condiciones: trabajador, puesto, duración, caudal, volumen, material, controles y anomalías. Esa información hace comparables las campañas y ayuda a explicar cambios. Sin contexto, dos concentraciones numéricamente distintas pueden interpretarse de forma errónea. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La ficha incluye trabajador/puesto, jornada, tareas, material, controles, aparato, caudal, volumen, incidencias y resultados de polvo y SCR. Una cifra sin condiciones no permite explicar diferencias ni saber si representa el escenario habitual. La calidad del dato comienza en el registro de campo.

Secuencia de aplicación
• Identificar persona, puesto y fecha.
• Describir tareas y controles.
• Registrar equipo, caudal y duración.
• Anotar incidencias y resultados.

Caso práctico razonado
Dos muestras difieren mucho; una se tomó con lluvia y otra con avería de riego, pero la ficha no lo indica. La comparación pierde capacidad diagnóstica.

Errores críticos
• Omitir condiciones meteorológicas relevantes.
• Rellenar después de memoria.
• Confundir polvo respirable y SCR.

Idea clave
La ficha convierte una concentración en evidencia auditable de una jornada concreta.$b$, title = $b$Fichas individualizadas de medición$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 2;
update public.lesson_audio_segments seg set title = $b$Fichas individualizadas de medición$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Cumplir remisiones periódicas sin retrasar el análisis y la acción interna.

Explicación vinculada al audio
Las fichas estadísticas con los resultados se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre. Además, se presentan anualmente a la Autoridad Minera junto con las modificaciones del Documento sobre Seguridad y Salud. La obligación de remisión no sustituye el análisis interno. La empresa debe revisar resultados al recibirlos, informar a quienes corresponda y activar acciones si detecta desviaciones. Esperar al envío anual para reaccionar perdería la finalidad preventiva de la medición. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
Las fichas estadísticas se envían al INS al menos cuatrimestralmente y anualmente a la Autoridad Minera junto con modificaciones del DSS. La empresa debe analizar al recibir resultados, informar y corregir. La remisión administrativa no es una fase de espera.

Secuencia de aplicación
• Revisar resultado al recibirlo.
• Activar medidas y comunicación interna.
• Enviar al INS cuatrimestralmente.
• Presentar anualmente a Autoridad Minera.

Caso práctico razonado
Un resultado supera el VLA en febrero y se propone actuar al envío anual. Debe intervenirse de inmediato y después comunicar conforme al calendario.

Errores críticos
• Esperar al cierre anual.
• Enviar sin analizar.
• Corregir el dato para evitar incidencia.

Idea clave
La obligación de informar nunca aplaza la obligación de proteger.$b$, title = $b$Comunicación de resultados$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 3;
update public.lesson_audio_segments seg set title = $b$Comunicación de resultados$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Comunicar enfermedades reconocidas y utilizar cada caso para revisar prevención.

Explicación vinculada al audio
Todo caso reconocido de neumoconiosis, silicosis o cáncer de pulmón derivado de la exposición laboral a polvo o sílice debe comunicarse a la Autoridad Minera y al Instituto Nacional de Silicosis, además de las obligaciones laborales aplicables. La comunicación institucional permite mejorar la vigilancia epidemiológica y orientar políticas preventivas. Debe realizarse sin perjuicio de la gestión como enfermedad profesional y de la protección de datos. Cada caso reconocido obliga además a revisar la evaluación y las medidas aplicadas. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
Los casos reconocidos de neumoconiosis, silicosis y cáncer de pulmón laboral por polvo o SCR se comunican a Autoridad Minera e INS, sin perjuicio de otras obligaciones. Se protege la información personal y se revisan evaluación, grupos comparables y barreras. La comunicación no busca culpables, sino prevención y vigilancia.

Secuencia de aplicación
• Activar circuitos sanitario/laboral.
• Comunicar a organismos exigidos.
• Preservar confidencialidad.
• Revisar puestos y medidas.

Caso práctico razonado
Se reconoce silicosis en un extrabajador. El tiempo transcurrido no elimina la necesidad de comunicación y revisión de exposiciones históricas comparables.

Errores críticos
• Difundir el diagnóstico en la plantilla.
• Limitarse al trámite.
• No revisar por ser extrabajador.

Idea clave
Cada enfermedad reconocida es también una señal preventiva que obliga a comprobar el sistema.$b$, title = $b$Comunicación de enfermedades$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 4;
update public.lesson_audio_segments seg set title = $b$Comunicación de enfermedades$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Proporcionar información precisa, comprensible y vinculada al puesto real.

Explicación vinculada al audio
La información debe explicar los materiales y tareas de riesgo, los posibles efectos sobre la salud, los resultados de la evaluación, las medidas preventivas, los procedimientos de emergencia y el uso correcto de los equipos de protección. La información se adapta al lenguaje, experiencia y tareas del grupo. Debe explicar qué hacer ante un fallo, dónde consultar resultados y a quién comunicar incidencias. Una presentación genérica sin relación con la explotación difícilmente modifica conductas ni demuestra una formación adecuada. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
Debe explicar materiales, tareas, efectos, resultados, controles, emergencias, EPI y canales de comunicación. Se adapta a idioma, experiencia y responsabilidad. Una presentación general no enseña qué hacer cuando falla una boquilla concreta o cómo consultar un resultado individual.

Secuencia de aplicación
• Explicar riesgos del centro y tarea.
• Mostrar controles y fallos críticos.
• Indicar actuación y contactos.
• Comprobar comprensión.

Caso práctico razonado
Una contrata recibe un folleto genérico, pero desconoce zonas restringidas y alarmas del centro. La información no es suficiente para entrar.

Errores críticos
• Entregar solo para firma.
• Usar lenguaje no entendido.
• Omitir resultados y cambios.

Idea clave
Informar es conseguir que la persona sepa reconocer, decidir y actuar, no solo que reciba un documento.$b$, title = $b$Información que debe recibir el trabajador$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 5;
update public.lesson_audio_segments seg set title = $b$Información que debe recibir el trabajador$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Acreditar competencia teórica y práctica, no mera asistencia.

Explicación vinculada al audio
Cada trabajador debe recibir formación suficiente y adecuada para su puesto, tanto teórica como práctica. No basta con entregar documentación: hay que comprender los riesgos, aplicar las medidas de control y demostrar el uso correcto de la protección respiratoria. La parte práctica puede incluir inspección de cabinas y captaciones, identificación de focos, demostración de limpieza y ensayo de ajuste respiratorio. La competencia se comprueba observando la ejecución, no solo mediante asistencia. Los errores detectados durante la práctica se corrigen antes de volver al puesto. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La práctica incluye identificación de focos, inspección de controles, limpieza segura, colocación y retirada de EPI y ensayo cuantitativo de ajuste. La evaluación observa ejecución y corrige errores antes del puesto. Las locuciones y diapositivas apoyan, pero no equivalen por sí solas a veinte horas de actividad.

Secuencia de aplicación
• Explicar fundamentos.
• Demostrar procedimientos.
• Observar ejecución individual.
• Registrar evaluación y corrección.

Caso práctico razonado
Un alumno aprueba test pero no consigue sellado facial. No se considera competente para usar ese equipo hasta corregir selección y práctica.

Errores críticos
• Convalidar por experiencia.
• Usar solo cuestionario.
• Dar por apto tras una firma.

Idea clave
La competencia preventiva se demuestra haciendo correctamente la tarea en condiciones representativas.$b$, title = $b$Formación teórica y práctica$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 6;
update public.lesson_audio_segments seg set title = $b$Formación teórica y práctica$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar repetición mínima anual y actualización extraordinaria ante cambios.

Explicación vinculada al audio
La formación frente al polvo y la sílice debe repetirse, como mínimo, una vez al año. También se actualizará cuando cambien las funciones, el puesto, el lugar de trabajo, la tecnología, los equipos o los conocimientos sobre el riesgo. El refuerzo anual debe recuperar los riesgos esenciales y centrarse también en cambios, incidentes, mediciones y fallos observados desde la sesión anterior. Esta modalidad ampliada de veinte horas no elimina esa repetición. La actualización anual mantiene la formación conectada con el trabajo real. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La formación se repite al menos una vez al año y se adapta a cambios de función, puesto, lugar, tecnología, equipos o conocimiento. El curso ampliado de veinte horas no elimina el refuerzo anual mínimo. La sesión anual debe incorporar mediciones, fallos e incidentes recientes.

Secuencia de aplicación
• Programar refuerzo anual.
• Definir disparadores por cambio.
• Adaptar a puesto y resultados.
• Conservar evidencia teórica y práctica.

Caso práctico razonado
Se realiza el curso de veinte horas en enero y en julio cambia la tecnología de captación. La actualización procede en julio, no al siguiente enero.

Errores críticos
• Confundir veinte horas con exención anual.
• Repetir material sin cambios.
• Esperar a aniversario tras nueva tecnología.

Idea clave
Anual es frecuencia mínima; el cambio relevante exige formación antes.$b$, title = $b$Periodicidad anual obligatoria$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 7;
update public.lesson_audio_segments seg set title = $b$Periodicidad anual obligatoria$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Convertir experiencia de trabajadores y representantes en mejora verificada.

Explicación vinculada al audio
Los trabajadores y sus representantes deben recibir información y participar conforme a la normativa preventiva. Su experiencia ayuda a detectar focos, fallos de mantenimiento y situaciones reales que pueden no aparecer durante una visita puntual. La participación convierte la experiencia diaria en información preventiva. Operadores y mantenedores pueden señalar boquillas que se obstruyen, puertas que no sellan o momentos con emisiones anormales. Estas observaciones se contrastan y se incorporan a la mejora, sin sustituir la evaluación técnica. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La participación ayuda a detectar emisiones, obstrucciones, fallos de sellado y tareas no previstas. Las observaciones se registran, contrastan y responden; no sustituyen medición o competencia técnica. Cerrar el ciclo exige comunicar qué se decidió y por qué.

Secuencia de aplicación
• Abrir canales de comunicación.
• Registrar observación y contexto.
• Investigar con participación.
• Responder y verificar la medida.

Caso práctico razonado
Operadores informan de polvo al arrancar cada mañana. Aunque una visita posterior no lo observe, se investiga el patrón y el arranque.

Errores críticos
• Descartar por no reproducirse.
• Sustituir medición por opinión.
• No informar del cierre.

Idea clave
La participación aporta conocimiento del trabajo real; la evaluación técnica lo transforma en prevención.$b$, title = $b$Consulta y participación$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 8;
update public.lesson_audio_segments seg set title = $b$Consulta y participación$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Realizar una comprobación previa observable de controles colectivos, EPI y zonas.

Explicación vinculada al audio
Antes de trabajar, comprueba que funcionan el riego, la aspiración, la ventilación o la presurización de la cabina. Verifica el estado del equipo respiratorio, conoce las zonas restringidas y comunica cualquier anomalía antes de exponerte. La comprobación previa se convierte en una rutina observable: mirar, probar, registrar y comunicar. Si un control esencial no funciona, se aplica el criterio definido de parada o trabajo alternativo. Empezar confiando en que el sistema se recuperará durante el turno aumenta innecesariamente la dosis. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La rutina es mirar, probar, registrar y comunicar. Se verifican riego, aspiración, ventilación, presión de cabina, filtros, EPI y restricciones. El procedimiento define qué fallo obliga a parada y qué trabajo alternativo es seguro. Comenzar esperando que el control se recupere añade dosis evitable.

Secuencia de aplicación
• Revisar indicadores y estado físico.
• Probar funcionamiento antes del foco.
• Registrar anomalías.
• Parar o cambiar tarea según criterio.

Caso práctico razonado
La aspiración no alcanza depresión mínima al inicio. Aunque suele estabilizarse, no se expone al personal hasta cumplir criterio o aplicar alternativa autorizada.

Errores críticos
• Arrancar para ver si mejora.
• Confiar en ausencia de nube.
• Dejar el aviso al siguiente turno.

Idea clave
La jornada empieza cuando las barreras están operativas, no cuando arranca el proceso.$b$, title = $b$Comprobación antes de empezar$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 9;
update public.lesson_audio_segments seg set title = $b$Comprobación antes de empezar$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Integrar control en origen, mantenimiento, conducta, medición y mejora diaria.

Explicación vinculada al audio
La silicosis es prevenible si se controla el polvo desde el origen, se mantienen las medidas colectivas y cada persona aplica los procedimientos. Trabajar sin nube visible no garantiza seguridad: la evaluación, la medición y la disciplina preventiva deben acompañar cada tarea. El cierre del curso debe traducirse en compromisos verificables: controlar el foco, mantener cabinas y captaciones, limpiar sin dispersar, usar correctamente el EPI y comunicar desviaciones. La prevención funciona cuando estas decisiones se repiten cada día y quedan respaldadas por mediciones y supervisión. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica
La silicosis es prevenible si las barreras se repiten y verifican. El compromiso debe traducirse en acciones observables: no barrer en seco, mantener cierres, informar fallos, conservar EPI, respetar zonas y analizar tendencias. La ausencia de nube no elimina la disciplina.

Secuencia de aplicación
• Controlar el foco.
• Mantener y comprobar barreras.
• Medir y analizar tendencias.
• Comunicar y corregir desviaciones.

Caso práctico razonado
Una planta obtiene buenos resultados durante un año. El éxito confirma el sistema utilizado; no justifica desmontarlo, sino mantenerlo y buscar mejora.

Errores críticos
• Depender de la memoria individual.
• Relajar controles por buenos datos.
• Normalizar fallos pequeños.

Idea clave
La prevención funciona cuando cada resultado favorable se utiliza para sostener y mejorar las barreras que lo hicieron posible.$b$, title = $b$Compromiso preventivo diario$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 10;
update public.lesson_audio_segments seg set title = $b$Compromiso preventivo diario$b$, updated_at = now() from public.lessons l, public.course_modules m where l.id = seg.lesson_id and m.id = l.module_id and m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and m.position = 5 and seg.position = 10;

do $val$
declare
  version_id constant uuid := 'cd155d2b-1c6d-4cdd-8f40-84c830f75315';
  fallos integer;
begin
  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5;
  if fallos <> 50 then
    raise exception 'Los bloques 1 a 5 de polvo y sílice deben tener 50 diapositivas y tienen %', fallos;
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
       length(s.body) < 1200
       or s.body not like 'Objetivo%'
       or s.body not like '%Explicación vinculada al audio%'
       or s.body not like '%Profundización técnica%'
       or s.body not like '%Secuencia de aplicación%'
       or s.body not like '%Caso práctico razonado%'
       or s.body not like '%Errores críticos%'
       or s.body not like '%Idea clave%'
     );
  if fallos > 0 then
    raise exception '% diapositivas de polvo y sílice no llevan las siete secciones del documento', fallos;
  end if;

  -- La cabecera del visor toma el título de la diapositiva y la lista de
  -- unidades el de la locución: deben decir lo mismo.
  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5
     and s.title is distinct from seg.title;
  if fallos > 0 then
    raise exception '% unidades de polvo y sílice no comparten título entre locución y diapositiva', fallos;
  end if;

  -- Ninguna de las cincuenta debe seguir sin acentuar.
  select count(*)
    into fallos
    from public.lesson_audio_segments seg
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 1 and 5
     and (seg.title like 'Que %' or seg.title like 'Cuando %' or seg.title like '%exposicion%' or seg.title like '%silice%');
  if fallos > 0 then
    raise exception '% títulos de polvo y sílice siguen sin acentuar', fallos;
  end if;

  -- El bloque 6 de cierre conserva su propia redacción.
  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position = 6
     and s.body like 'Objetivo%';
  if fallos > 0 then
    raise exception '% diapositivas del bloque 6 han sido sobrescritas', fallos;
  end if;
end;
$val$;

commit;
