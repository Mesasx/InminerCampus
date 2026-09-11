-- Tests del curso «Administración y personal de servicios distintos a los de
-- mantenimiento», a partir del banco de preguntas aportado y validado.
--
-- El libro entregado trae 15 preguntas por bloque para la formación inicial de
-- 20 h y 10 por bloque para el reciclaje de 5 h, seis bloques en cada
-- modalidad. Cada pregunta declara su diapositiva de origen, de modo que aquí
-- se enlaza con la unidad correspondiente del curso: así, cuando un intento no
-- es perfecto, el alumno recibe las partes que conviene repasar.
--
-- El enunciado, las cuatro opciones, la respuesta marcada y la justificación se
-- vuelcan tal cual vienen en el libro. No se reescribe ni se reordena nada.
--
-- La configuración de cada test reproduce la del resto del campus: acierto del
-- 100 %, tres rondas perfectas no necesariamente consecutivas, y preguntas y
-- opciones barajadas en cada intento.
--
-- Es una migración aditiva: si un bloque ya tuviera test, se deja intacto y no
-- se toca. No se borra ninguna pregunta, banco ni matrícula existente.
begin;

create temporary table _adm_preguntas (
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

insert into _adm_preguntas (
  externo, duracion, bloque, orden, codigo, enunciado,
  opcion_a, opcion_b, opcion_c, opcion_d, correcta, justificacion
) values
  ('ADM-20H-B1-Q01', 20, 1, 1, '1.1', '¿Por qué necesita formación preventiva minera una persona que trabaja principalmente en administración?', 'Porque solo el personal administrativo está obligado por la ITC', 'Porque puede acceder a zonas del centro donde existen riesgos mineros distintos a los de una oficina', 'Porque debe aprender a reparar equipos si surge una avería', 'Porque toda persona administrativa debe conducir maquinaria', 'B', 'El entorno minero puede exponer también al personal de administración o servicios durante desplazamientos o accesos a zonas operativas.'),
  ('ADM-20H-B1-Q02', 20, 1, 2, '1.1', '¿Qué elementos se indica que conviven dentro de un mismo centro minero?', 'Solo oficinas y talleres', 'Personas, equipos, instalaciones, vehículos, procesos, contratistas y distintas zonas de trabajo', 'Solo maquinaria y vehículos', 'Únicamente personal propio de la empresa', 'B', 'La diapositiva y su explicación detallada describen el centro minero como un sistema complejo en el que conviven esos elementos.'),
  ('ADM-20H-B1-Q03', 20, 1, 3, '1.2', '¿Qué criterio debe utilizarse para encuadrar a una persona en el Grupo 5.5.d?', 'El nombre comercial del puesto', 'La antigüedad en la empresa', 'Las tareas que efectivamente realiza de forma habitual', 'El departamento al que pertenece en nómina', 'C', 'La ITC define el puesto por las tareas efectivamente desempeñadas, no solo por la denominación contractual.'),
  ('ADM-20H-B1-Q04', 20, 1, 4, '1.2', '¿Qué debe hacerse si una persona de servicios realiza habitualmente reparaciones o mantenimiento?', 'Mantenerla siempre en 5.5.d porque su contrato dice servicios', 'Revisar su encuadre y la formación preventiva aplicable', 'Permitirle intervenir si conoce el equipo', 'Sustituir la formación por instrucciones verbales', 'B', 'Las tareas de mantenimiento pueden requerir otro itinerario y personal específicamente capacitado.'),
  ('ADM-20H-B1-Q05', 20, 1, 5, '1.3', '¿Qué idea debe asumir el trabajador al pasar de una oficina a una zona operativa?', 'Que el nivel de riesgo se mantiene igual', 'Que la pertenencia a la misma empresa garantiza condiciones idénticas', 'Que pueden cambiar los riesgos y las reglas de acceso', 'Que el EPI deja de ser necesario en desplazamientos breves', 'C', 'El riesgo cambia con el entorno y las zonas pueden exigir medidas y autorizaciones distintas.'),
  ('ADM-20H-B1-Q06', 20, 1, 6, '1.4', 'Ante una protección abierta en una instalación, ¿cuál es la actuación más adecuada para un trabajador 5.5.d?', 'Cerrar la protección inmediatamente aunque desconozca la situación del equipo', 'Intentar reparar el mecanismo', 'Mantenerse fuera del peligro y comunicarlo por el canal establecido', 'Ignorarla si el equipo parece parado', 'C', 'El personal 5.5.d debe protegerse, no intervenir fuera de competencia y comunicar la anomalía.'),
  ('ADM-20H-B1-Q07', 20, 1, 7, '1.5', '¿Cuál de estas afirmaciones describe mejor la prevención en un puesto administrativo dentro de un centro minero?', 'Solo deben evaluarse los riesgos de oficina', 'Solo deben evaluarse los riesgos de las zonas operativas', 'Deben considerarse tanto los riesgos administrativos como los derivados de desplazamientos y accesos', 'La formación minera sustituye la prevención del puesto administrativo', 'C', 'La jornada completa puede combinar riesgos propios de oficina con exposiciones asociadas al entorno minero.'),
  ('ADM-20H-B1-Q08', 20, 1, 8, '1.6', '¿Qué principio es esencial para el personal de servicios distinto del mantenimiento?', 'Puede reparar un equipo si sabe utilizarlo', 'Debe improvisar soluciones sencillas para no detener el trabajo', 'Debe respetar el límite entre uso autorizado y mantenimiento', 'Debe aprender mantenimiento básico durante este curso', 'C', 'El curso no habilita para reparación o mantenimiento; saber usar no equivale a estar autorizado para intervenir técnicamente.'),
  ('ADM-20H-B1-Q09', 20, 1, 9, '1.7', '¿Por qué un recorrido habitual puede dejar de ser seguro?', 'Porque los recorridos nunca deben repetirse', 'Porque pueden cambiar las condiciones por averías, trabajos o climatología', 'Porque las señales dejan de aplicarse con el tiempo', 'Porque los viales solo son peligrosos para vehículos', 'B', 'Las condiciones del entorno pueden cambiar y obligan a mantener la observación incluso en trayectos rutinarios.'),
  ('ADM-20H-B1-Q10', 20, 1, 10, '1.7', '¿Qué efecto puede tener la familiaridad con un recorrido que se realiza todos los días?', 'Aumenta automáticamente la seguridad del trayecto', 'Puede reducir la percepción del riesgo y hacer que se dejen de observar cruces o delimitaciones', 'Elimina la necesidad de seguir la señalización', 'Permite utilizar atajos no previstos', 'B', 'La diapositiva y el manual advierten que la rutina puede reducir la atención incluso en trayectos habituales.'),
  ('ADM-20H-B1-Q11', 20, 1, 11, '1.8', '¿Qué comprobación debe hacerse antes de acceder a una zona operativa no habitual?', 'Solo verificar la hora de entrada', 'Autorización, EPI, señalización, actividad circundante y recorrido permitido', 'Únicamente comprobar si hay ruido', 'Solo ponerse casco, aunque no sea el EPI requerido', 'B', 'La transición de zona exige verificar las condiciones específicas de acceso y seguridad.'),
  ('ADM-20H-B1-Q12', 20, 1, 12, '1.8', '¿Por qué una estancia de solo un minuto no justifica incumplir el EPI obligatorio?', 'Porque el EPI es obligatorio únicamente por imagen', 'Porque una exposición breve puede ser suficiente para que ocurra un accidente', 'Porque todos los EPI deben usarse durante toda la jornada', 'Porque el EPI sustituye cualquier otra medida', 'B', 'Un atropello, una caída o una proyección pueden producirse inmediatamente.'),
  ('ADM-20H-B1-Q13', 20, 1, 13, '1.9', '¿Cuál resume mejor las responsabilidades preventivas básicas del trabajador?', 'Cumplir, utilizar correctamente, comunicar y no improvisar', 'Reparar, decidir, autorizar y supervisar', 'Inspeccionar técnicamente, sancionar, formar y coordinar', 'Evaluar formalmente todos los riesgos del centro', 'A', 'El manual resume la conducta esperada en cumplir instrucciones, usar medios y EPI correctamente, comunicar anomalías y no improvisar.'),
  ('ADM-20H-B1-Q14', 20, 1, 14, '1.9', 'Si se observa un cable deteriorado, ¿qué actuación corresponde?', 'Repararlo con cinta para evitar demoras', 'Seguir utilizándolo mientras funcione', 'Evitar su utilización y comunicar la anomalía', 'Desconectarlo y abrir el equipo para comprobarlo', 'C', 'La intervención técnica corresponde a personal competente; el trabajador debe evitar la exposición y comunicar.'),
  ('ADM-20H-B1-Q15', 20, 1, 15, '1.1', '¿Qué relación existe entre la formación general y las instrucciones concretas del centro?', 'La formación general sustituye cualquier instrucción local', 'Las instrucciones locales solo son necesarias para mantenimiento', 'La formación general aporta criterio, pero debe complementarse con las reglas concretas del centro', 'Son contenidos independientes y no deben relacionarse', 'C', 'El curso general no sustituye recorridos, autorizaciones, EPI, alarmas ni procedimientos específicos de cada centro.'),
  ('ADM-20H-B2-Q01', 20, 2, 1, '2.1', '¿Cuál es la diferencia principal entre peligro y riesgo?', 'El peligro es la probabilidad y el riesgo es la fuente de daño', 'El peligro es la fuente capaz de causar daño y el riesgo depende de la posibilidad de que ese daño se materialice', 'Son exactamente lo mismo', 'El riesgo existe solo cuando ya ha ocurrido un accidente', 'B', 'El manual diferencia la fuente de daño de la posibilidad de exposición y materialización del daño.'),
  ('ADM-20H-B2-Q02', 20, 2, 2, '2.1', '¿Qué medida debe priorizarse cuando sea posible?', 'Entregar EPI antes de analizar el problema', 'Controlar o eliminar el peligro en origen y priorizar la protección colectiva', 'Señalizar siempre como única medida', 'Depender de la experiencia individual', 'B', 'La jerarquía preventiva prioriza evitar, controlar en origen y aplicar protección colectiva antes que individual.'),
  ('ADM-20H-B2-Q03', 20, 2, 3, '2.2', '¿Cuál es el objetivo de la inspección previa para un trabajador 5.5.d?', 'Realizar una auditoría técnica completa', 'Detectar cambios evidentes antes de empezar o acceder', 'Sustituir la evaluación de riesgos', 'Autorizar trabajos de otras empresas', 'B', 'Se trata de una comprobación visual y funcional adaptada a sus competencias.'),
  ('ADM-20H-B2-Q04', 20, 2, 4, '2.2', '¿Qué significa la pauta P-A-R-A?', 'Proteger, Avisar, Reparar, Autorizar', 'Parar, Analizar entorno, Reconocer cambios y Actuar conforme a instrucciones', 'Preparar, Asegurar, Revisar y Archivar', 'Parar, Avisar, Retirar y Abandonar', 'B', 'El manual usa P-A-R-A como secuencia para evitar actuar por rutina en un entorno que puede haber cambiado.'),
  ('ADM-20H-B2-Q05', 20, 2, 5, '2.3', '¿Cuál de estas situaciones constituye una autorización válida para acceder a una zona?', 'La puerta está abierta', 'Otro compañero ha entrado', 'La autorización y condiciones de acceso definidas por el centro', 'La barrera está desplazada', 'C', 'Una puerta abierta o la presencia de otra persona no sustituyen la autorización requerida.'),
  ('ADM-20H-B2-Q06', 20, 2, 6, '2.4', '¿Qué principio básico reduce el riesgo entre peatones y maquinaria móvil?', 'Circular lo más cerca posible del vehículo para ser visto', 'Segregar recorridos y evitar áreas de maniobra', 'Confiar en la ropa de alta visibilidad', 'Cruzar rápido para reducir el tiempo de exposición', 'B', 'La segregación física y el uso de rutas peatonales son la base preventiva.'),
  ('ADM-20H-B2-Q07', 20, 2, 7, '2.4', '¿Por qué ''ver un vehículo'' no significa ''haber sido visto''?', 'Porque los vehículos industriales pueden tener puntos ciegos', 'Porque los conductores nunca miran al frente', 'Porque la alta visibilidad impide la comunicación visual', 'Porque los peatones siempre tienen prioridad', 'A', 'Los equipos móviles pueden tener zonas de visibilidad limitada y grandes radios de giro.'),
  ('ADM-20H-B2-Q08', 20, 2, 8, '2.5', 'Para alcanzar una carpeta situada en altura, ¿qué debe evitarse?', 'Utilizar un medio adecuado previsto para acceso', 'Solicitar ayuda si es necesario', 'Subirse a una silla con ruedas', 'Mantener despejada la zona', 'C', 'El manual pone como ejemplo negativo el uso de mobiliario inadecuado para alcanzar altura.'),
  ('ADM-20H-B2-Q09', 20, 2, 9, '2.6', '¿Qué expresa la frase ''parado no significa seguro''?', 'Que toda máquina debe seguir funcionando durante una revisión', 'Que puede permanecer energía eléctrica, presión, temperatura o capacidad de movimiento aunque el equipo no se mueva', 'Que solo los equipos eléctricos presentan riesgos residuales', 'Que un equipo parado siempre debe reiniciarse', 'B', 'Un equipo detenido puede conservar diferentes formas de energía peligrosa.'),
  ('ADM-20H-B2-Q10', 20, 2, 10, '2.7', 'Además del daño auditivo, ¿qué otro problema puede causar el ruido?', 'Mejorar la percepción de alarmas', 'Dificultar la comunicación y la percepción de señales', 'Eliminar la necesidad de señalización visual', 'Reducir el riesgo de atropello', 'B', 'El ruido puede ocultar avisos y dificultar la comunicación preventiva.'),
  ('ADM-20H-B2-Q11', 20, 2, 11, '2.8', '¿Qué debe hacerse ante un envase sin identificar?', 'Olerlo para reconocer el producto', 'Utilizar una pequeña cantidad como prueba', 'No manipularlo y seguir el sistema de identificación de la empresa', 'Trasvasarlo a un recipiente conocido', 'C', 'El manual establece que un producto desconocido no debe probarse, olerse ni utilizarse.'),
  ('ADM-20H-B2-Q12', 20, 2, 12, '2.8', '¿Por qué no existe una ''mascarilla universal'' para cualquier polvo o sustancia?', 'Porque la protección respiratoria depende del agente y de la exposición real', 'Porque todas las mascarillas protegen igual', 'Porque solo se usan en oficinas', 'Porque la protección respiratoria está prohibida en minería', 'A', 'La selección depende del contaminante, concentración, duración y evaluación correspondiente.'),
  ('ADM-20H-B2-Q13', 20, 2, 13, '2.9', '¿Qué información debería conocerse antes de una emergencia?', 'Solo el teléfono del responsable', 'Alarma, rutas, salidas, punto de reunión y canales de comunicación', 'Únicamente la ubicación de los extintores', 'Solo el plan de producción', 'B', 'La respuesta eficaz empieza conociendo previamente las instrucciones de emergencia.'),
  ('ADM-20H-B2-Q14', 20, 2, 14, '2.9', 'Durante una evacuación, ¿qué conducta es correcta?', 'Volver a recoger objetos personales si hay tiempo', 'Abandonar el punto de reunión una vez fuera', 'Seguir las instrucciones, evacuar con orden y no regresar hasta autorización', 'Combatir siempre el incendio antes de evacuar', 'C', 'La prioridad es seguir el procedimiento de evacuación y permanecer disponible para el control de ocupantes.'),
  ('ADM-20H-B2-Q15', 20, 2, 15, '2.10', '¿Qué significa la conducta PAS?', 'Prevenir, Aislar y Señalizar', 'Proteger, Alertar y Socorrer', 'Parar, Avisar y Salir', 'Proteger, Autorizar y Supervisar', 'B', 'PAS ordena la actuación inicial y evita que quien auxilia se convierta en una segunda víctima.'),
  ('ADM-20H-B3-Q01', 20, 3, 1, '3.1', 'Según el enfoque del curso, ¿qué puede considerarse equipo de trabajo?', 'Solo maquinaria pesada', 'Máquinas, aparatos, instrumentos o instalaciones utilizados en el trabajo', 'Solo equipos eléctricos', 'Únicamente herramientas manuales', 'B', 'El concepto es amplio y no se limita a grandes máquinas.'),
  ('ADM-20H-B3-Q02', 20, 3, 2, '3.1', '¿Qué afirmación es correcta sobre la sencillez aparente de un equipo?', 'Cuanto más pequeño, menor riesgo siempre', 'Los equipos sencillos no necesitan comprobaciones', 'La apariencia de sencillez no determina el nivel de riesgo', 'Solo la maquinaria compleja requiere instrucciones', 'C', 'Una escalera o un equipo pequeño también pueden producir lesiones graves si se usan mal.'),
  ('ADM-20H-B3-Q03', 20, 3, 3, '3.2', '¿Qué tres preguntas básicas debe hacerse una persona antes de utilizar un equipo?', '¿Es nuevo?, ¿es rápido?, ¿es pesado?', '¿Es parte de mi puesto?, ¿he recibido formación?, ¿estoy autorizado cuando procede?', '¿Lo usan mis compañeros?, ¿está cerca?, ¿parece sencillo?', '¿Tiene batería?, ¿tiene ruedas?, ¿tiene manual?', 'B', 'Estas preguntas ayudan a comprobar función, formación y autorización.'),
  ('ADM-20H-B3-Q04', 20, 3, 4, '3.2', '¿Por qué ''lo he visto hacer muchas veces'' no acredita competencia?', 'Porque la observación informal no garantiza conocer limitaciones, alarmas ni riesgos residuales', 'Porque está prohibido observar equipos', 'Porque solo cuenta la antigüedad', 'Porque cualquier equipo puede usarse sin formación', 'A', 'Ver a otros utilizar un equipo no sustituye la formación ni la autorización.'),
  ('ADM-20H-B3-Q05', 20, 3, 5, '3.3', '¿Qué debe hacerse si durante la revisión previa se detecta un cable con el aislamiento deteriorado?', 'Envolverlo y continuar', 'Usarlo solo unos minutos', 'Retirar el equipo de uso según el procedimiento y comunicarlo', 'Abrir el equipo para repararlo', 'C', 'La revisión sirve para detectar defectos, no para autorizar reparaciones improvisadas.'),
  ('ADM-20H-B3-Q06', 20, 3, 6, '3.3', '¿Cuál de estos elementos puede formar parte de una revisión previa del usuario?', 'Daños visibles, protecciones, cableado y fugas aparentes', 'Desmontaje interno del motor', 'Reprogramación de la electrónica', 'Ensayo destructivo de componentes', 'A', 'La revisión del usuario se limita a comprobaciones visibles y funcionales definidas por fabricante/procedimiento.'),
  ('ADM-20H-B3-Q07', 20, 3, 7, '3.4', '¿Qué información puede establecer el manual del fabricante?', 'Solo el precio del equipo', 'Límites de carga, accesorios compatibles, condiciones de uso y advertencias', 'Únicamente la fecha de compra', 'Solo instrucciones de limpieza estética', 'B', 'El manual fija condiciones técnicas y preventivas del uso previsto.'),
  ('ADM-20H-B3-Q08', 20, 3, 8, '3.4', '¿Qué significa ''capacidad física no equivale a diseño seguro''?', 'Que un equipo puede hacer algo físicamente y aun así no estar diseñado para hacerlo de forma segura', 'Que los equipos no deben utilizarse nunca al máximo', 'Que los fabricantes no definen límites', 'Que cualquier accesorio es válido si encaja', 'A', 'Poder realizar una acción no demuestra que esté contemplada en el uso previsto.'),
  ('ADM-20H-B3-Q09', 20, 3, 9, '3.5', '¿Qué debe hacerse si un enclavamiento impide que un equipo continúe funcionando?', 'Puentearlo para terminar la tarea', 'Anularlo temporalmente', 'Detenerse y comunicar para que se investigue la causa', 'Sujetarlo manualmente en posición', 'C', 'Los dispositivos de seguridad no deben neutralizarse; si actúan, debe averiguarse la causa.'),
  ('ADM-20H-B3-Q10', 20, 3, 10, '3.5', '¿Para qué están diseñados los resguardos y dispositivos de seguridad?', 'Para dificultar el trabajo', 'Para proteger a las personas frente a los riesgos del equipo', 'Para sustituir la formación del trabajador', 'Para permitir trabajar sin procedimientos', 'B', 'La diapositiva y la explicación detallada señalan que resguardos, enclavamientos, paradas y sensores están diseñados para proteger.'),
  ('ADM-20H-B3-Q11', 20, 3, 11, '3.6', '¿Qué conducta es incorrecta ante una alarma repetitiva?', 'Comunicarla', 'Observar qué indicador se activa', 'Asumir que es normal y resetearla sin investigar', 'Seguir el procedimiento del centro', 'C', 'La repetición de una alarma no demuestra que sea segura; puede indicar una condición que requiere análisis.'),
  ('ADM-20H-B3-Q12', 20, 3, 12, '3.7', '¿Qué medida debe anteponerse, con carácter general, a la protección individual?', 'La protección colectiva', 'El EPI más cómodo', 'La experiencia del trabajador', 'La señalización aislada', 'A', 'La Ley 31/1995 establece la prioridad de la protección colectiva sobre la individual.'),
  ('ADM-20H-B3-Q13', 20, 3, 13, '3.8', '¿Cuál es el criterio correcto para seleccionar un EPI?', 'Elegir siempre el más robusto', 'Usar el que haya disponible', 'Seleccionarlo según el riesgo concreto y la evaluación', 'Usar siempre casco y guantes, sin importar la tarea', 'C', 'No existe una combinación universal; la selección depende del riesgo y de las condiciones reales.'),
  ('ADM-20H-B3-Q14', 20, 3, 14, '3.9', '¿Qué debe hacerse con un casco que presenta daños visibles?', 'Conservarlo para visitas cortas', 'Seguir usándolo si resulta cómodo', 'Retirarlo según el procedimiento de sustitución', 'Repararlo con adhesivo', 'C', 'Un EPI deteriorado puede haber perdido capacidad de protección y no debe mantenerse por conveniencia.'),
  ('ADM-20H-B3-Q15', 20, 3, 15, '3.9', '¿Por qué no debe modificarse un EPI para mejorar su comodidad?', 'Porque cualquier modificación puede alterar prestaciones de protección', 'Porque el EPI solo puede tocarlo el fabricante', 'Porque la comodidad no importa', 'Porque todas las modificaciones están permitidas si son pequeñas', 'A', 'Cambios aparentemente menores pueden afectar a la protección prevista por el fabricante.'),
  ('ADM-20H-B4-Q01', 20, 4, 1, '4.1', '¿Por qué la seguridad no puede limitarse a una comprobación al inicio de la jornada?', 'Porque las condiciones pueden cambiar durante la actividad', 'Porque la inspección inicial está prohibida', 'Porque solo importan los cambios de turno', 'Porque las zonas mineras nunca son estables', 'A', 'Derrames, averías, nuevos trabajos o cambios de acceso pueden modificar el entorno durante la jornada.'),
  ('ADM-20H-B4-Q02', 20, 4, 2, '4.1', '¿Qué ejemplo muestra que una zona segura al inicio puede dejar de serlo durante la jornada?', 'La aparición de un derrame o de un nuevo trabajo en la zona', 'Que el trabajador conozca bien el recorrido', 'Que la jornada tenga la misma duración de siempre', 'Que la señalización permanezca sin cambios', 'A', 'La diapositiva y el manual citan derrames y nuevos trabajos como cambios que pueden modificar las condiciones de seguridad.'),
  ('ADM-20H-B4-Q03', 20, 4, 3, '4.2', '¿Qué debe saber el trabajador sobre las alarmas de su centro?', 'Solo cuáles son más frecuentes', 'Qué señales le afectan y qué respuesta corresponde', 'Cómo desactivarlas todas', 'Qué técnico las instaló', 'B', 'El significado y respuesta pueden variar según el centro y deben conocerse previamente.'),
  ('ADM-20H-B4-Q04', 20, 4, 4, '4.2', '¿Qué riesgo existe cuando una alarma se activa con frecuencia y el personal deja de reaccionar?', 'Que se normalice una desviación potencialmente peligrosa', 'Que aumente la producción', 'Que la alarma mejore su fiabilidad', 'Que la formación deje de ser necesaria', 'A', 'La repetición puede llevar a ignorar una señal que sigue siendo relevante.'),
  ('ADM-20H-B4-Q05', 20, 4, 5, '4.3', '¿Cuál es la respuesta adecuada cuando una tarea prevista se desarrolla bajo condiciones diferentes a las planificadas?', 'Continuar igual para no retrasarse', 'Reconocer el cambio, consultar y adaptar la actuación', 'Aplicar siempre el mismo procedimiento sin revisar', 'Abandonar definitivamente el puesto', 'B', 'Cuando cambia el escenario, deben revisarse las instrucciones o medidas necesarias.'),
  ('ADM-20H-B4-Q06', 20, 4, 6, '4.3', '¿Cuál de estas situaciones puede requerir revisar la forma de actuar?', 'Cambio de climatología', 'Cambio de iluminación', 'Entrada de personal externo', 'Todas las anteriores', 'D', 'El manual cita varios cambios del entorno o la actividad que pueden alterar las condiciones de seguridad.'),
  ('ADM-20H-B4-Q07', 20, 4, 7, '4.4', '¿Qué es una anomalía desde el punto de vista preventivo?', 'Solo una avería confirmada por mantenimiento', 'Cualquier condición inesperada que pueda afectar a la seguridad', 'Únicamente una alarma sonora', 'Un error administrativo sin relación con el entorno', 'B', 'Fugas, cables dañados, ruidos inusuales o protecciones abiertas son ejemplos de anomalías.'),
  ('ADM-20H-B4-Q08', 20, 4, 8, '4.4', '¿Necesita el trabajador conocer la causa técnica exacta de una anomalía antes de comunicarla?', 'Sí, siempre', 'Solo si afecta a un equipo eléctrico', 'No, puede comunicar hechos observables sin diagnosticar', 'Sí, porque de otro modo el aviso no sirve', 'C', 'El valor del aviso está en describir lo observado con precisión, no en diagnosticar técnicamente.'),
  ('ADM-20H-B4-Q09', 20, 4, 9, '4.5', '¿Qué elementos hacen útil una comunicación de incidencia?', 'Qué ocurre, dónde, cuándo y qué efecto se observa', 'Solo el nombre de quien comunica', 'Una hipótesis sobre la causa', 'Únicamente una fotografía', 'A', 'La comunicación precisa facilita una respuesta rápida y adecuada.'),
  ('ADM-20H-B4-Q10', 20, 4, 10, '4.5', '¿Cuál de estos avisos es más eficaz?', 'Hay algo raro por ahí', 'Creo que algo está mal', 'Derrame junto al acceso peatonal norte, detectado hace unos minutos y con superficie resbaladiza', 'Mirad la zona cuando podáis', 'C', 'Un aviso eficaz identifica ubicación, condición y efecto observable.'),
  ('ADM-20H-B4-Q11', 20, 4, 11, '4.6', '¿Qué debe hacer una persona ante una condición que no comprende y que puede afectar a su seguridad?', 'Improvisar una solución', 'Continuar con más cuidado', 'Detenerse, informar y pedir instrucciones', 'Esperar a que otro trabajador pase primero', 'C', 'No improvisar y consultar antes de continuar es una actuación preventiva profesional.'),
  ('ADM-20H-B4-Q12', 20, 4, 12, '4.6', '¿Qué reconoce la Ley ante un riesgo grave e inminente para la vida o la salud?', 'La obligación de continuar hasta recibir relevo', 'El derecho a interrumpir la actividad y abandonar el lugar', 'La obligación de reparar la causa', 'La posibilidad de ignorar las instrucciones', 'B', 'La Ley contempla la interrupción de la actividad ante riesgo grave e inminente.'),
  ('ADM-20H-B4-Q13', 20, 4, 13, '4.1', '¿Cuál es el papel del trabajador 5.5.d en la vigilancia del entorno?', 'Realizar supervisión técnica de todos los procesos', 'Detectar cambios relevantes para la seguridad y comunicar cuando proceda', 'Autorizar actividades de mantenimiento', 'Modificar procedimientos por iniciativa propia', 'B', 'Su papel es observar y comunicar dentro de sus competencias, no supervisar técnicamente operaciones ajenas.'),
  ('ADM-20H-B4-Q14', 20, 4, 14, '4.3', 'Si una ruta exterior se vuelve resbaladiza por lluvia, ¿qué principio debe aplicarse?', 'Mantener el plan inicial porque ya estaba aprobado', 'Reconocer el cambio de condiciones y revisar la forma de actuar', 'Caminar más rápido para reducir la exposición', 'Ignorar el cambio si se conoce bien la ruta', 'B', 'La gestión preventiva debe adaptarse cuando el escenario deja de ser el previsto.'),
  ('ADM-20H-B4-Q15', 20, 4, 15, '4.5', '¿Por qué describir hechos observables es mejor que especular sobre causas técnicas?', 'Porque permite informar con precisión sin asumir competencias que no corresponden', 'Porque las causas técnicas nunca importan', 'Porque evita tener que localizar la incidencia', 'Porque sustituye cualquier inspección posterior', 'A', 'El trabajador puede aportar información útil sin diagnosticar una avería.'),
  ('ADM-20H-B5-Q01', 20, 5, 1, '5.1', '¿Qué es una interferencia entre actividades?', 'Un error de planificación sin efecto preventivo', 'Una situación en la que una actividad modifica los riesgos de otra que coincide en espacio o tiempo', 'Una avería exclusiva de maquinaria', 'Un conflicto administrativo entre empresas', 'B', 'La ET incluye los trabajos simultáneos porque el riesgo real depende del conjunto de actividades presentes.'),
  ('ADM-20H-B5-Q02', 20, 5, 2, '5.1', '¿Qué puede ocurrir con un recorrido habitualmente seguro durante una descarga o reparación cercana?', 'Nada, porque el recorrido ya fue evaluado', 'Puede cambiar su nivel de riesgo y requerir medidas adicionales', 'Debe seguir utilizándose sin cambios', 'Deja automáticamente de pertenecer al centro', 'B', 'Una actividad ajena puede modificar temporalmente las condiciones del espacio.'),
  ('ADM-20H-B5-Q03', 20, 5, 3, '5.2', '¿Qué exige la coordinación cuando coinciden varias empresas?', 'Que cada empresa ignore los riesgos de las demás', 'Que se controlen también las interacciones entre actividades', 'Que solo el contratista reciba información', 'Que la empresa principal asuma todas las tareas de las demás', 'B', 'La coordinación complementa las obligaciones propias de cada empresa y controla interacciones.'),
  ('ADM-20H-B5-Q04', 20, 5, 4, '5.2', '¿Qué debe hacer un trabajador ante las instrucciones de acogida y coordinación de otra empresa presente en el centro?', 'Ignorarlas si no pertenecen a su empresa', 'Respetar las medidas de coordinación que le afecten', 'Aplicarlas solo si son verbales', 'Seguir únicamente sus hábitos habituales', 'B', 'Rutas, permisos, responsables y restricciones pueden formar parte de la coordinación preventiva.'),
  ('ADM-20H-B5-Q05', 20, 5, 5, '5.3', '¿Qué característica debe tener la información preventiva previa?', 'Ser muy extensa aunque no se entienda', 'Ser comprensible y útil para saber cómo actuar', 'Entregarse únicamente por escrito', 'Limitarse a normas generales', 'B', 'Documentar no basta si la persona no comprende qué debe hacer.'),
  ('ADM-20H-B5-Q06', 20, 5, 6, '5.3', '¿Qué debe hacer un trabajador si no entiende una instrucción esencial antes de comenzar?', 'Empezar y preguntar después', 'Seguir a otro trabajador', 'Pedir aclaración antes de iniciar la actividad', 'Ignorar la instrucción si tiene experiencia', 'C', 'Las dudas deben resolverse antes de exponerse al riesgo.'),
  ('ADM-20H-B5-Q07', 20, 5, 7, '5.4', '¿Qué frase suele indicar un fallo de coordinación?', 'He confirmado que la zona está liberada', 'El responsable ha autorizado el acceso', 'Creí que ya habían terminado', 'He recibido la instrucción por el canal previsto', 'C', 'Las suposiciones sobre el estado de equipos o zonas son una fuente clásica de fallos de coordinación.'),
  ('ADM-20H-B5-Q08', 20, 5, 8, '5.4', '¿Cómo debe confirmarse que una zona vuelve a estar disponible tras una intervención?', 'Por ausencia visible de trabajadores', 'Por una liberación o confirmación según el sistema establecido', 'Cuando desaparezcan las herramientas', 'Cuando alguien no relacionado diga que ya está', 'B', 'La ausencia de personal no equivale a liberación formal.'),
  ('ADM-20H-B5-Q09', 20, 5, 9, '5.5', '¿Qué regla básica debe seguirse al aproximarse a maquinaria en movimiento o con capacidad de movimiento?', 'Entrar en su radio para llamar la atención', 'Mantenerse fuera del espacio operativo y coordinar la aproximación', 'Acercarse por detrás para ser visto en el espejo', 'Tocar la máquina para avisar al operador', 'B', 'Los radios de giro y trayectorias son espacios dinámicos que requieren coordinación.'),
  ('ADM-20H-B5-Q10', 20, 5, 10, '5.6', '¿Cuál es la mejor medida cuando existe una alternativa segura?', 'Compartir trayectoria con el vehículo para ser visible', 'Evitar compartir espacio y trayectoria', 'Cruzar entre vehículos estacionados', 'Usar el móvil para avisar al conductor', 'B', 'La separación de trayectorias reduce el riesgo de atropello.'),
  ('ADM-20H-B5-Q11', 20, 5, 11, '5.7', '¿Cómo debe tratarse una zona que está en reparación o mantenimiento?', 'Como una zona normal si no se ve al técnico', 'Como una condición especial hasta su liberación formal', 'Como una zona libre si el equipo está parado', 'Como una zona accesible al personal habitual', 'B', 'Durante una intervención pueden faltar protecciones o existir condiciones temporales diferentes.'),
  ('ADM-20H-B5-Q12', 20, 5, 12, '5.7', '¿Qué debe evitar el personal ajeno durante un mantenimiento?', 'Respetar delimitaciones', 'Esperar la liberación formal', 'Recolocar resguardos o poner equipos en servicio por iniciativa propia', 'Mantenerse fuera de la zona', 'C', 'Una acción aparentemente útil puede interferir con la seguridad del trabajo técnico.'),
  ('ADM-20H-B5-Q13', 20, 5, 13, '5.8', 'Si una zona conocida está cerrada con conos por una inspección, ¿qué debe hacerse?', 'Retirar un cono y volverlo a colocar después', 'Acceder porque se conoce la zona', 'Respetar la restricción y solicitar acceso si es necesario', 'Entrar solo si no se ve ningún riesgo', 'C', 'El motivo del cierre puede no ser visible y la barrera debe respetarse mientras esté vigente.'),
  ('ADM-20H-B5-Q14', 20, 5, 14, '5.9', 'Si una tarea administrativa termina requiriendo entrar en una zona no prevista, ¿qué debe hacerse?', 'Entrar porque la tarea original estaba autorizada', 'Parar y revisar riesgos, autorización y medios para el nuevo alcance', 'Continuar si el tiempo de permanencia será breve', 'Pedir a otro compañero que entre sin más', 'B', 'Un cambio de alcance puede introducir riesgos y medidas no contemplados inicialmente.'),
  ('ADM-20H-B5-Q15', 20, 5, 15, '5.9', '¿Cuál es la secuencia adecuada ante un cambio de tarea?', 'Continuar, improvisar, informar después', 'Parar, definir el nuevo alcance, comprobar riesgos y autorización, y continuar solo cuando esté previsto', 'Entrar, comprobar y después pedir permiso', 'Aplicar las medidas de la tarea anterior sin revisar', 'B', 'El manual establece una secuencia explícita para evitar la improvisación ante cambios de alcance.'),
  ('ADM-20H-B6-Q01', 20, 6, 1, '6.1', '¿Qué relación existe entre derechos y obligaciones preventivas?', 'Solo existen obligaciones del trabajador', 'Solo existen obligaciones de la empresa', 'La empresa debe proteger y el trabajador debe utilizar medios, cumplir instrucciones y cooperar', 'El trabajador sustituye a la organización preventiva', 'C', 'La prevención combina el deber empresarial de protección con una conducta responsable del trabajador.'),
  ('ADM-20H-B6-Q02', 20, 6, 2, '6.1', '¿Cuál es un derecho preventivo básico?', 'Recibir información y formación adecuada sobre riesgos y medidas', 'Modificar equipos para adaptarlos al puesto', 'Elegir libremente cualquier EPI', 'Ignorar instrucciones si se tiene experiencia', 'A', 'El trabajador debe recibir información y formación suficiente y adecuada.'),
  ('ADM-20H-B6-Q03', 20, 6, 3, '6.2', '¿Cuál es el marco general de prevención citado en el curso?', 'Ley 31/1995', 'RD 171/2004 exclusivamente', 'Manual del fabricante', 'DIS únicamente', 'A', 'La Ley 31/1995 constituye el marco general de prevención de riesgos laborales.'),
  ('ADM-20H-B6-Q04', 20, 6, 4, '6.2', '¿Qué regula específicamente la ITC 02.1.02 dentro del marco formativo?', 'La compraventa de maquinaria', 'La formación preventiva por puesto de trabajo en su ámbito', 'La señalización de tráfico general', 'Los horarios del centro', 'B', 'La ITC 02.1.02 regula la formación profesional mínima en seguridad y salud por puesto.'),
  ('ADM-20H-B6-Q05', 20, 6, 5, '6.3', '¿Qué expresa el principio de integrar la prevención en la gestión?', 'Que basta con tener documentos archivados', 'Que la prevención debe formar parte de la organización normal del trabajo', 'Que solo actúa el servicio de prevención', 'Que la prevención se limita a emergencias', 'B', 'La Ley se presenta como un sistema de gestión conectado, no como documentación aislada.'),
  ('ADM-20H-B6-Q06', 20, 6, 6, '6.3', '¿Cuál es un principio de acción preventiva?', 'Priorizar siempre el EPI', 'Combatir los riesgos en origen', 'Esperar a que ocurra un accidente', 'Trasladar el riesgo a otra persona', 'B', 'La Ley prioriza evitar riesgos y combatirlos en origen, entre otros principios.'),
  ('ADM-20H-B6-Q07', 20, 6, 7, '6.4', '¿Cuándo debe actualizarse la formación preventiva?', 'Nunca, una vez realizada', 'Cuando cambian funciones, tecnologías, equipos o condiciones', 'Solo al cambiar de empresa', 'Solo si lo solicita el trabajador', 'B', 'La formación debe mantenerse adecuada al puesto y a sus cambios.'),
  ('ADM-20H-B6-Q08', 20, 6, 8, '6.4', '¿Por qué recibir un documento no sustituye necesariamente una información eficaz?', 'Porque la información debe ser comprendida para poder actuar correctamente', 'Porque la documentación está prohibida', 'Porque solo cuenta la formación práctica', 'Porque los documentos nunca contienen información preventiva', 'A', 'El objetivo es que el trabajador comprenda riesgos y medidas antes de exponerse.'),
  ('ADM-20H-B6-Q09', 20, 6, 9, '6.5', '¿Cuál es una obligación del trabajador?', 'Utilizar correctamente equipos y medios de protección', 'Reparar equipos averiados', 'Autorizar accesos a zonas restringidas', 'Modificar las instrucciones internas', 'A', 'El trabajador debe usar correctamente equipos y protecciones y comunicar situaciones peligrosas.'),
  ('ADM-20H-B6-Q10', 20, 6, 10, '6.5', '¿Qué debe hacer un trabajador ante un dispositivo de seguridad defectuoso?', 'Inutilizarlo para poder seguir', 'Informar y respetar los límites de su competencia', 'Repararlo aunque no esté capacitado', 'Ignorarlo si el equipo sigue funcionando', 'B', 'La obligación de cooperar no implica asumir tareas técnicas para las que no se está capacitado.'),
  ('ADM-20H-B6-Q11', 20, 6, 11, '6.6', '¿Por qué existe normativa específica de seguridad minera además de la prevención general?', 'Porque las actividades mineras tienen exigencias sectoriales propias', 'Porque la Ley 31/1995 no se aplica en minería', 'Porque solo importa la dirección facultativa', 'Porque las normas generales están prohibidas en minas', 'A', 'La minería combina el marco general de PRL con exigencias sectoriales específicas.'),
  ('ADM-20H-B6-Q12', 20, 6, 12, '6.6', '¿Qué función cumplen las DIS en el marco minero?', 'Sustituir toda la legislación', 'Adaptar requisitos a las condiciones concretas del centro cuando proceda', 'Autorizar cualquier modificación de equipos', 'Eliminar la necesidad de formación', 'B', 'Las Disposiciones Internas de Seguridad concretan reglas internas dentro del marco normativo.'),
  ('ADM-20H-B6-Q13', 20, 6, 13, '6.7', '¿Cuál de estas conductas forma parte del cierre preventivo del curso?', 'Anular protecciones para evitar paradas', 'Mantenerse fuera de radios de acción de maquinaria', 'Utilizar equipos fuera de competencia si la tarea es urgente', 'Ignorar cambios si el trabajo ya comenzó', 'B', 'Mantener separación de maquinaria en movimiento es una de las conductas esenciales.'),
  ('ADM-20H-B6-Q14', 20, 6, 14, '6.7', '¿Qué debe hacerse ante una situación no comprendida?', 'Continuar con precaución', 'Detenerse y consultar', 'Seguir a otro trabajador', 'Improvisar una solución temporal', 'B', 'Detenerse y consultar ante una situación no comprendida es una conducta esencial del curso.'),
  ('ADM-20H-B6-Q15', 20, 6, 15, '6.7', '¿Cuál es el objetivo final del curso según su cierre?', 'Memorizar literalmente todas las diapositivas', 'Aplicar un criterio preventivo coherente ante situaciones reales', 'Aprender mantenimiento básico', 'Sustituir las instrucciones específicas del centro', 'B', 'El cierre del curso busca transformar los contenidos en criterios de decisión aplicables al trabajo real.'),
  ('ADM-5H-B1-Q01', 5, 1, 1, '1.1', 'Aunque trabajes en administración, ¿puedes quedar expuesto a riesgos mineros?', 'No, nunca', 'Sí, al desplazarte o entrar en zonas operativas', 'Solo si conduces maquinaria', 'Solo durante emergencias', 'B', 'El entorno minero puede afectar también al personal administrativo o de servicios.'),
  ('ADM-5H-B1-Q02', 5, 1, 2, '1.2', '¿Qué define principalmente el encuadre en el Grupo 5.5.d?', 'El nombre del contrato', 'Las tareas reales del puesto', 'La edad del trabajador', 'El horario', 'B', 'El puesto se define por las tareas efectivamente realizadas.'),
  ('ADM-5H-B1-Q03', 5, 1, 3, '1.2', '¿Este curso habilita para reparar maquinaria?', 'Sí', 'Solo si la avería es sencilla', 'No', 'Solo con permiso verbal', 'C', 'El curso no habilita para reparación o mantenimiento.'),
  ('ADM-5H-B1-Q04', 5, 1, 4, '1.3', '¿El riesgo es igual en todas las zonas del centro?', 'Sí', 'No, cambia según el entorno', 'Solo cambia en exteriores', 'Solo cambia de noche', 'B', 'Oficinas, viales, almacenes y zonas operativas pueden tener riesgos distintos.'),
  ('ADM-5H-B1-Q05', 5, 1, 5, '1.4', 'Ante una anomalía, ¿qué debes hacer?', 'Repararla siempre', 'Protegerte, no intervenir y comunicar', 'Ignorarla', 'Esperar al final del turno', 'B', 'La actuación debe mantenerse dentro de las propias competencias.'),
  ('ADM-5H-B1-Q06', 5, 1, 6, '1.5', '¿La formación minera elimina los riesgos propios de oficina?', 'Sí', 'No, los complementa', 'Solo en cursos de 20 h', 'Solo si hay EPI', 'B', 'Los riesgos administrativos siguen existiendo.'),
  ('ADM-5H-B1-Q07', 5, 1, 7, '1.7', 'Si un recorrido habitual está cerrado, ¿qué debes hacer?', 'Quitar la barrera', 'Buscar una ruta autorizada o consultar', 'Pasar rápido', 'Crear un atajo', 'B', 'Las delimitaciones deben respetarse.'),
  ('ADM-5H-B1-Q08', 5, 1, 8, '1.8', 'Antes de entrar en una zona operativa, ¿qué debes comprobar?', 'Solo la hora', 'Autorización, EPI y señalización', 'Solo si hay ruido', 'Nada si es una visita breve', 'B', 'El cambio de zona exige volver a comprobar las condiciones.'),
  ('ADM-5H-B1-Q09', 5, 1, 9, '1.9', '¿Qué debes hacer con un cable deteriorado?', 'Repararlo con cinta', 'Seguir usándolo', 'Evitar su uso y comunicarlo', 'Abrir el equipo', 'C', 'No improvisar reparaciones forma parte de la conducta preventiva.'),
  ('ADM-5H-B1-Q10', 5, 1, 10, '1.9', '¿Cuál es una conducta preventiva correcta?', 'Improvisar', 'Comunicar anomalías', 'Anular protecciones', 'Usar equipos sin formación', 'B', 'Comunicar anomalías es una responsabilidad básica.'),
  ('ADM-5H-B2-Q01', 5, 2, 1, '2.1', '¿Qué es un peligro?', 'Una fuente capaz de producir daño', 'Un accidente ya ocurrido', 'Una sanción', 'Un EPI', 'A', 'El peligro es la fuente o situación con capacidad de causar daño.'),
  ('ADM-5H-B2-Q02', 5, 2, 2, '2.1', '¿Qué debe priorizarse antes que el EPI cuando sea posible?', 'La protección colectiva', 'La experiencia', 'La rapidez', 'La señalización sola', 'A', 'La protección colectiva debe anteponerse a la individual.'),
  ('ADM-5H-B2-Q03', 5, 2, 3, '2.2', '¿Qué debes hacer antes de entrar en una zona no inspeccionada?', 'Parar y observar', 'Entrar y comprobar después', 'Seguir a otro trabajador', 'Ignorar cambios', 'A', 'La inspección previa permite detectar cambios antes de exponerse.'),
  ('ADM-5H-B2-Q04', 5, 2, 4, '2.3', '¿Una puerta abierta significa que estás autorizado a entrar?', 'Sí', 'No', 'Solo de día', 'Solo si no hay señal', 'B', 'La autorización no se deduce de una puerta abierta.'),
  ('ADM-5H-B2-Q05', 5, 2, 5, '2.4', '¿Ver un vehículo significa que su conductor te ha visto?', 'Sí', 'No', 'Siempre de día', 'Solo con chaleco', 'B', 'Los vehículos pueden tener puntos ciegos.'),
  ('ADM-5H-B2-Q06', 5, 2, 6, '2.5', '¿Qué debes evitar para alcanzar un objeto en altura?', 'Usar un medio adecuado', 'Subirte a mobiliario inestable', 'Pedir ayuda', 'Despejar la zona', 'B', 'No deben improvisarse medios de acceso.'),
  ('ADM-5H-B2-Q07', 5, 2, 7, '2.6', '¿Un equipo parado puede seguir siendo peligroso?', 'No', 'Sí, puede conservar energía', 'Solo si está caliente', 'Solo si es eléctrico', 'B', 'Puede quedar presión, tensión, temperatura o capacidad de movimiento.'),
  ('ADM-5H-B2-Q08', 5, 2, 8, '2.8', '¿Qué debes hacer con un envase sin identificar?', 'Olerlo', 'Probarlo', 'No utilizarlo y comunicarlo', 'Trasvasarlo', 'C', 'Un producto desconocido no debe manipularse por intuición.'),
  ('ADM-5H-B2-Q09', 5, 2, 9, '2.9', 'Durante una evacuación, ¿puedes volver atrás por objetos personales?', 'Sí', 'No', 'Solo si están cerca', 'Solo con casco', 'B', 'Debe seguirse la evacuación y no regresar hasta autorización.'),
  ('ADM-5H-B2-Q10', 5, 2, 10, '2.10', '¿Qué significa PAS?', 'Proteger, Alertar, Socorrer', 'Parar, Avisar, Salir', 'Prevenir, Actuar, Señalizar', 'Proteger, Autorizar, Supervisar', 'A', 'PAS es la secuencia básica de primeros auxilios.'),
  ('ADM-5H-B3-Q01', 5, 3, 1, '3.1', '¿Qué puede ser un equipo de trabajo?', 'Solo una excavadora', 'Una máquina, aparato, instrumento o instalación de trabajo', 'Solo una herramienta manual', 'Solo un ordenador', 'B', 'El concepto de equipo es amplio.'),
  ('ADM-5H-B3-Q02', 5, 3, 2, '3.2', 'Antes de usar un equipo, ¿qué debes comprobar?', 'Si otros lo usan', 'Si forma parte de tu puesto, tienes formación y autorización cuando procede', 'Si es nuevo', 'Si parece sencillo', 'B', 'Función, formación y autorización son barreras básicas.'),
  ('ADM-5H-B3-Q03', 5, 3, 3, '3.3', 'Si detectas un defecto visible, ¿qué debes hacer?', 'Repararlo', 'Seguir usando el equipo', 'Retirarlo de uso y comunicarlo', 'Ocultarlo', 'C', 'La revisión no autoriza reparaciones.'),
  ('ADM-5H-B3-Q04', 5, 3, 4, '3.4', '¿Qué debe respetarse del manual del fabricante?', 'Solo la marca', 'Límites y condiciones de uso', 'Solo la garantía', 'Solo las recomendaciones estéticas', 'B', 'El manual fija condiciones técnicas de utilización segura.'),
  ('ADM-5H-B3-Q05', 5, 3, 5, '3.5', '¿Se puede puentear un dispositivo de seguridad para terminar antes?', 'Sí', 'No', 'Solo una vez', 'Solo si el equipo está parado', 'B', 'Los dispositivos de seguridad no deben anularse.'),
  ('ADM-5H-B3-Q06', 5, 3, 6, '3.6', '¿Qué debes hacer ante una alarma repetitiva?', 'Ignorarla', 'Resetearla siempre', 'Comunicarla y seguir el procedimiento', 'Taparla', 'C', 'La repetición no significa que sea segura.'),
  ('ADM-5H-B3-Q07', 5, 3, 7, '3.7', '¿Qué actúa sobre el entorno antes de que el riesgo llegue a la persona?', 'Protección colectiva', 'Solo el EPI', 'Experiencia', 'Señalización verbal', 'A', 'La protección colectiva actúa antes sobre el entorno.'),
  ('ADM-5H-B3-Q08', 5, 3, 8, '3.8', '¿Existe un EPI universal para todos los riesgos?', 'Sí', 'No', 'Solo el casco', 'Solo la alta visibilidad', 'B', 'La selección depende del riesgo concreto.'),
  ('ADM-5H-B3-Q09', 5, 3, 9, '3.9', '¿Un EPI dañado debe seguir usándose?', 'Sí, si es poco tiempo', 'No', 'Solo en oficina', 'Solo con autorización verbal', 'B', 'Debe retirarse o sustituirse según el procedimiento.'),
  ('ADM-5H-B3-Q10', 5, 3, 10, '3.9', '¿Se debe modificar un EPI para hacerlo más cómodo?', 'Sí', 'No', 'Solo si no se nota', 'Solo en verano', 'B', 'Una modificación puede afectar a su capacidad de protección.'),
  ('ADM-5H-B4-Q01', 5, 4, 1, '4.1', '¿La seguridad se comprueba solo al inicio de la jornada?', 'Sí', 'No', 'Solo en trabajos largos', 'Solo al cambiar de turno', 'B', 'Las condiciones pueden cambiar durante la actividad.'),
  ('ADM-5H-B4-Q02', 5, 4, 2, '4.1', '¿Qué puede cambiar durante la jornada?', 'Derrames, trabajos, averías o accesos', 'Nada importante', 'Solo el clima', 'Solo los horarios', 'A', 'El entorno puede variar por múltiples causas.'),
  ('ADM-5H-B4-Q03', 5, 4, 3, '4.2', '¿Debes conocer las alarmas que te afectan?', 'Sí', 'No', 'Solo si eres responsable', 'Solo en cursos de 20 h', 'A', 'Es necesario saber qué señales existen y cómo responder.'),
  ('ADM-5H-B4-Q04', 5, 4, 4, '4.2', '¿Una alarma repetitiva puede ignorarse?', 'Sí', 'No', 'Solo si suena poco', 'Solo si otros no reaccionan', 'B', 'Una alarma repetitiva puede indicar una desviación que requiere atención.'),
  ('ADM-5H-B4-Q05', 5, 4, 5, '4.3', 'Si cambia el escenario, ¿qué debes hacer?', 'Seguir igual', 'Revisar la forma de actuar', 'Trabajar más rápido', 'Ignorar el cambio', 'B', 'El procedimiento puede dejar de ser válido si cambian las condiciones.'),
  ('ADM-5H-B4-Q06', 5, 4, 6, '4.4', '¿Necesitas saber reparar una anomalía para comunicarla?', 'Sí', 'No', 'Solo si es eléctrica', 'Solo si hay una alarma', 'B', 'Comunicar hechos observables no exige conocer la causa técnica.'),
  ('ADM-5H-B4-Q07', 5, 4, 7, '4.5', '¿Qué información debe incluir un buen aviso?', 'Qué ocurre y dónde', 'Solo tu nombre', 'Solo una opinión', 'Solo una foto', 'A', 'La ubicación y la descripción objetiva mejoran la respuesta.'),
  ('ADM-5H-B4-Q08', 5, 4, 8, '4.5', '¿Qué aviso es mejor?', 'Hay algo raro', 'Derrame junto al acceso peatonal norte', 'Mirad esto', 'Creo que pasa algo', 'B', 'Un aviso localizado y concreto es más útil.'),
  ('ADM-5H-B4-Q09', 5, 4, 9, '4.6', 'Ante una condición que no comprendes, ¿qué haces?', 'Improvisas', 'Te detienes y consultas', 'Sigues a otra persona', 'Continúas más despacio', 'B', 'No improvisar forma parte de una actuación profesional.'),
  ('ADM-5H-B4-Q10', 5, 4, 10, '4.6', 'Ante un riesgo grave e inminente, ¿puede interrumpirse la actividad?', 'No', 'Sí', 'Solo si lo decide un compañero', 'Solo en exteriores', 'B', 'La Ley reconoce este derecho ante riesgo grave e inminente.'),
  ('ADM-5H-B5-Q01', 5, 5, 1, '5.1', '¿Puede el trabajo de otras personas crear riesgos para ti?', 'No', 'Sí', 'Solo en mantenimiento', 'Solo si son de otra empresa', 'B', 'Una actividad concurrente puede modificar las condiciones de tu zona.'),
  ('ADM-5H-B5-Q02', 5, 5, 2, '5.2', 'Cuando coinciden varias empresas, ¿qué debe existir?', 'Coordinación', 'Competencia entre ellas', 'Menos información', 'Acceso libre', 'A', 'La coordinación controla las interacciones entre actividades.'),
  ('ADM-5H-B5-Q03', 5, 5, 3, '5.3', '¿La información preventiva debe ser comprensible?', 'Sí', 'No', 'Solo para mandos', 'Solo si es verbal', 'A', 'La información debe permitir saber cómo actuar.'),
  ('ADM-5H-B5-Q04', 5, 5, 4, '5.3', 'Si una instrucción no está clara, ¿qué debes hacer?', 'Empezar igualmente', 'Pedir aclaración', 'Ignorarla', 'Copiar a otro trabajador', 'B', 'Las dudas deben resolverse antes de comenzar.'),
  ('ADM-5H-B5-Q05', 5, 5, 5, '5.4', '¿Debes suponer que una reparación ha terminado porque no ves al técnico?', 'Sí', 'No', 'Solo si el equipo está parado', 'Solo al final del turno', 'B', 'Debe existir confirmación según el sistema establecido.'),
  ('ADM-5H-B5-Q06', 5, 5, 6, '5.5', '¿Dónde debes situarte respecto a una máquina en maniobra?', 'Dentro de su radio de giro', 'Fuera de su espacio operativo', 'Detrás del equipo', 'Junto a las ruedas', 'B', 'Debe mantenerse separación de las trayectorias y radios de acción.'),
  ('ADM-5H-B5-Q07', 5, 5, 7, '5.6', '¿Cuál es la mejor opción cuando hay una ruta peatonal segura?', 'Usarla', 'Cruzar por cualquier punto', 'Caminar entre vehículos', 'Acortar por la calzada', 'A', 'La segregación de trayectorias reduce el riesgo.'),
  ('ADM-5H-B5-Q08', 5, 5, 8, '5.7', '¿Puedes utilizar un equipo que está en revisión?', 'Sí', 'No', 'Solo si parece funcionar', 'Solo unos minutos', 'B', 'Debe esperarse la liberación formal.'),
  ('ADM-5H-B5-Q09', 5, 5, 9, '5.8', '¿Puedes mover un cono para pasar y volver a colocarlo?', 'Sí', 'No', 'Solo si tienes prisa', 'Solo si conoces la zona', 'B', 'Una delimitación temporal debe respetarse mientras esté vigente.'),
  ('ADM-5H-B5-Q10', 5, 5, 10, '5.9', 'Si la tarea cambia y exige entrar en otra zona, ¿qué haces?', 'Entras directamente', 'Revisas riesgos y autorización antes de continuar', 'Sigues con las medidas antiguas', 'Esperas a que pase otro', 'B', 'Un cambio de alcance puede introducir riesgos nuevos.'),
  ('ADM-5H-B6-Q01', 5, 6, 1, '6.1', '¿Tienes derecho a recibir información y formación preventiva?', 'Sí', 'No', 'Solo si eres operador', 'Solo en la formación inicial', 'A', 'La información y formación adecuadas forman parte de la protección eficaz.'),
  ('ADM-5H-B6-Q02', 5, 6, 2, '6.1', '¿Debes utilizar correctamente los EPI?', 'Sí', 'No', 'Solo si hay inspección', 'Solo en exteriores', 'A', 'Es una obligación preventiva del trabajador.'),
  ('ADM-5H-B6-Q03', 5, 6, 3, '6.2', '¿Cuál es el marco general de prevención citado en el curso?', 'Ley 31/1995', 'Código Civil', 'RD 171/2004 únicamente', 'Manual interno', 'A', 'La Ley 31/1995 es el marco general de PRL.'),
  ('ADM-5H-B6-Q04', 5, 6, 4, '6.2', '¿Qué regula la ITC 02.1.02 en este contexto?', 'La formación preventiva por puesto', 'El precio de los cursos', 'El mantenimiento de equipos', 'Los horarios', 'A', 'La ITC regula la formación preventiva mínima por puesto en su ámbito.'),
  ('ADM-5H-B6-Q05', 5, 6, 5, '6.3', '¿La prevención debe integrarse en la gestión normal de la empresa?', 'Sí', 'No', 'Solo en minería subterránea', 'Solo en empresas grandes', 'A', 'La prevención forma parte de la organización del trabajo.'),
  ('ADM-5H-B6-Q06', 5, 6, 6, '6.4', '¿Cuándo debe actualizarse la formación?', 'Cuando cambian funciones o condiciones', 'Nunca', 'Solo cada diez años', 'Solo al cambiar de empresa', 'A', 'La formación debe seguir siendo adecuada al puesto real.'),
  ('ADM-5H-B6-Q07', 5, 6, 7, '6.5', '¿Debes comunicar una situación peligrosa?', 'Sí', 'No', 'Solo si ha ocurrido un accidente', 'Solo si afecta a otra persona', 'A', 'La comunicación de riesgos forma parte de las obligaciones del trabajador.'),
  ('ADM-5H-B6-Q08', 5, 6, 8, '6.6', '¿La minería tiene normas de seguridad específicas además de la prevención general?', 'Sí', 'No', 'Solo en canteras', 'Solo para mantenimiento', 'A', 'Existe normativa sectorial minera específica.'),
  ('ADM-5H-B6-Q09', 5, 6, 9, '6.7', '¿Debes anular una protección para terminar una tarea?', 'Sí', 'No', 'Solo con experiencia', 'Solo si no hay nadie cerca', 'B', 'No anular protecciones es una de las conductas preventivas esenciales.'),
  ('ADM-5H-B6-Q10', 5, 6, 10, '6.7', 'Ante una situación no comprendida, ¿qué conducta es correcta?', 'Continuar', 'Detenerse y consultar', 'Improvisar', 'Seguir a otro trabajador', 'B', 'Detenerse y consultar resume el criterio preventivo del curso.');

do $$
declare
  v_slug constant text := 'administracion-personal-servicios-no-mantenimiento';
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

    for v_bloque in 1..6 loop
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
      from _adm_preguntas p
      where p.duracion = v_duracion and p.bloque = v_bloque;

      if v_total = 0 then
        raise exception 'Sin preguntas para el bloque % (% h)', v_bloque, v_duracion;
      end if;

      insert into public.question_banks (course_version_id, title)
      values (
        v_version,
        format(
          'Evaluación aportada · Administración %s h · Bloque %s · 2026-09-11',
          v_duracion,
          v_bloque
        )
      )
      returning id into v_banco;

      -- El esquema admite una sola pregunta enlazada por unidad dentro de cada
      -- banco, que es como está cargado el resto del campus: se enlaza la
      -- primera pregunta de cada unidad y las demás quedan sin enlazar. El
      -- enlace sólo alimenta la lista de partes a repasar.
      v_codigos := array[]::text[];

      for v_fila in
        select * from _adm_preguntas p
        where p.duracion = v_duracion and p.bloque = v_bloque
        order by p.orden
      loop
        -- Unidad de la que procede la pregunta, para el repaso tras un fallo.
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

          if v_unidad is null then
            raise exception 'No se encuentra la unidad % (% h)', v_fila.codigo, v_duracion;
          end if;

          v_codigos := v_codigos || v_fila.codigo;
        end if;

        insert into public.questions (
          question_bank_id, prompt, type, explanation, points, active,
          lesson_audio_segment_id
        )
        values (
          v_banco,
          v_fila.enunciado,
          'single_choice',
          v_fila.justificacion,
          1,
          true,
          v_unidad
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
        v_leccion,
        v_banco,
        format('Test del bloque %s · %s preguntas', v_bloque, v_total),
        v_total,
        100,
        3,
        true,
        true,
        0,
        true,
        'cumulative_perfect'
      );
    end loop;
  end loop;
end $$;

commit;
