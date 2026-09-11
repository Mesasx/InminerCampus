-- Tests del curso «Operador de perforadora / perforista», a partir del banco de
-- preguntas aportado y validado.
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
-- Las dos modalidades están publicadas con sus cincuenta unidades, así que
-- todas las preguntas encuentran su unidad y la primera de cada una queda
-- enlazada.
--
-- Es una migración aditiva: si un bloque ya tuviera test, se deja intacto y no
-- se toca. No se borra ninguna pregunta, banco ni matrícula existente.
begin;

create temporary table _pf_preguntas (
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

insert into _pf_preguntas (
  externo, duracion, bloque, orden, codigo, enunciado,
  opcion_a, opcion_b, opcion_c, opcion_d, correcta, justificacion
) values
  ('PERF-20H-B1-Q01', 20, 1, 1, '1.1', '¿Cuál describe mejor la función del perforista en una explotación minera?', 'Solo accionar los mandos de la perforadora', 'Convertir un diseño en barrenos reales con geometría verificada y comunicar desviaciones', 'Diseñar por su cuenta la malla de perforación', 'Manipular explosivos una vez terminados los barrenos', 'B', 'La diapositiva y el manual definen al perforista como quien ejecuta el diseño, verifica la geometría y comunica desviaciones.'),
  ('PERF-20H-B1-Q02', 20, 1, 2, '1.1', '¿Qué información debe comunicar el perforista al entregar la fase de perforación?', 'Solo el número total de barrenos', 'Profundidades reales, incidencias, huecos, presencia de agua y desviaciones', 'Únicamente el nombre del operador', 'Solo el consumo de combustible', 'B', 'La diapositiva 1.2 y el manual exigen una entrega completa de información a la fase siguiente.'),
  ('PERF-20H-B1-Q03', 20, 1, 3, '1.2', '¿Qué debe hacer el perforista respecto a la malla de perforación?', 'Rediseñarla cuando crea que puede mejorarla', 'Respetarla y no rediseñarla unilateralmente', 'Modificarla si cambia el turno', 'Sustituirla por referencias visuales aproximadas', 'B', 'La presentación y el manual indican que el operador ejecuta el diseño y no rediseña unilateralmente la malla.'),
  ('PERF-20H-B1-Q04', 20, 1, 4, '1.3', '¿En qué debe basarse la selección de una perforadora?', 'En la disponibilidad inmediata del equipo', 'En la tarea y el entorno, comprobando capacidad de plataforma, gálibo, control de polvo y terreno', 'Solo en el diámetro de la broca', 'Únicamente en la antigüedad de la máquina', 'B', 'La diapositiva y el manual establecen que la selección depende de la tarea y del entorno, no de la mera disponibilidad.'),
  ('PERF-20H-B1-Q05', 20, 1, 5, '1.3', '¿La autorización para operar una perforadora concreta acredita competencia automática en otra?', 'Sí, si es del mismo fabricante', 'No, cada equipo requiere formación y habilitación específica', 'Sí, si tiene mandos parecidos', 'Solo si el operador tiene más de cinco años de experiencia', 'B', 'La diapositiva 1.3 y el manual indican que la autorización de una máquina no se traslada automáticamente a otra.'),
  ('PERF-20H-B1-Q06', 20, 1, 6, '1.4', '¿Qué caracteriza al martillo en fondo?', 'La percusión se genera únicamente en la cabina', 'El percutor se sitúa junto a la broca dentro del barreno', 'No utiliza aire comprimido', 'Siempre es superior al martillo en cabeza', 'B', 'La diapositiva y el manual explican que en martillo en fondo el percutor trabaja junto a la broca.'),
  ('PERF-20H-B1-Q07', 20, 1, 7, '1.5', '¿Qué función realiza la sarta de perforación?', 'Solo sostiene la broca', 'Transmite par, empuje y percusión y conduce el fluido de barrido', 'Únicamente elimina el polvo', 'Solo mide la profundidad del barreno', 'B', 'La presentación y el manual describen la sarta como la cadena que transmite energía y conduce el fluido de barrido.'),
  ('PERF-20H-B1-Q08', 20, 1, 8, '1.5', '¿Qué regla absoluta se establece durante la manipulación de elementos de la sarta?', 'Guiarlos siempre con la mano', 'Nunca guiar con la mano un elemento que puede girar, caer o recibir presión residual', 'Sujetar las varillas mientras giran lentamente', 'Introducir las manos en las mordazas para alinear', 'B', 'La diapositiva 1.5 y el manual formulan esta prohibición de manera expresa.'),
  ('PERF-20H-B1-Q09', 20, 1, 9, '1.6', '¿Qué parámetros definen principalmente la geometría de un barreno?', 'Posición, diámetro, profundidad e inclinación', 'Color, dureza y temperatura', 'Velocidad del vehículo y consumo', 'Ruido, iluminación y humedad', 'A', 'La diapositiva y el manual identifican posición, diámetro, profundidad e inclinación como parámetros esenciales.'),
  ('PERF-20H-B1-Q10', 20, 1, 10, '1.7', '¿Qué debe hacerse si aparece una grieta paralela a la coronación del banco?', 'Continuar con menor velocidad', 'Suspender la operación, balizar y esperar evaluación competente', 'Acercar la máquina para observar mejor', 'Rellenar la grieta y continuar', 'B', 'La diapositiva y el manual señalan la grieta paralela a la coronación como señal de parada.'),
  ('PERF-20H-B1-Q11', 20, 1, 11, '1.8', 'Antes de perforar en la base del banco, ¿qué debe confirmarse?', 'Que el frente está saneado y autorizado', 'Que la cabina esté cerrada', 'Que haya otra máquina cerca', 'Que el turno esté terminando', 'A', 'La diapositiva y el manual exigen comprobar el saneo del frente y la autorización antes de acercarse.'),
  ('PERF-20H-B1-Q12', 20, 1, 12, '1.8', 'Durante la perforación en la base del banco, ¿qué señales obligan a retirar el equipo y comunicar?', 'Caída de finos, crujidos, cambios de agua o aparición de nuevas fisuras', 'Solo una bajada del combustible', 'Únicamente ruido del motor', 'Cambio de turno', 'A', 'La diapositiva 1.8 y el manual enumeran estas señales de inestabilidad del frente.'),
  ('PERF-20H-B1-Q13', 20, 1, 13, '1.9', '¿Qué riesgo específico presenta un bloque mal apoyado durante el taqueo?', 'Puede bascular, abrirse o proyectar fragmentos', 'Solo produce ruido', 'Únicamente aumenta el consumo de combustible', 'Elimina el riesgo de atrapamiento', 'A', 'La presentación y el manual explican que un bloque inestable puede moverse o fracturarse de forma imprevista.'),
  ('PERF-20H-B1-Q14', 20, 1, 14, '1.10', '¿Qué debe hacerse si falla el sistema de captación de polvo durante la perforación?', 'Continuar con más velocidad', 'Detener la perforación y comunicar', 'Abrir la cabina para ventilar', 'Ignorar el fallo si el polvo visible es pequeño', 'B', 'La diapositiva y el manual establecen que un fallo del sistema de captación obliga a detener y comunicar.'),
  ('PERF-20H-B1-Q15', 20, 1, 15, '1.10', '¿Qué características del detritus pueden informar sobre cambios del terreno?', 'Color, granulometría, humedad y caudal', 'Solo temperatura exterior', 'Únicamente olor', 'Color de la máquina y velocidad de giro', 'A', 'La diapositiva 1.10 y el manual presentan el detritus como indicador operativo a través de estas características.'),
  ('PERF-20H-B2-Q01', 20, 2, 1, '2.1', '¿Cómo debe realizarse el reconocimiento del terreno antes de perforar?', 'Desde la cabina exclusivamente', 'Desde una posición segura, a pie y contrastando con los planos disponibles', 'Solo después de arrancar la máquina', 'Únicamente mediante fotografías', 'B', 'La diapositiva y el manual señalan que la visión desde cabina es insuficiente y que debe inspeccionarse desde una posición segura.'),
  ('PERF-20H-B2-Q02', 20, 2, 2, '2.1', 'Si existe duda sobre la capacidad portante del terreno, ¿qué debe hacerse?', 'Probar con la máquina a baja velocidad', 'No probar con la máquina y solicitar evaluación competente', 'Añadir calzos improvisados', 'Aumentar la presión de las orugas', 'B', 'La diapositiva 2.1 y el manual señalan que una duda de estabilidad no se resuelve ensayando con la perforadora.'),
  ('PERF-20H-B2-Q03', 20, 2, 3, '2.2', '¿Qué riesgo puede generar una perforadora mal nivelada?', 'Solo un aumento de ruido', 'Errores de inclinación, esfuerzos laterales y riesgo de vuelco', 'Únicamente desgaste de pintura', 'Mejorar la precisión del barreno', 'B', 'La diapositiva y el manual vinculan la mala nivelación con errores geométricos, cargas no previstas y vuelco.'),
  ('PERF-20H-B2-Q04', 20, 2, 4, '2.3', '¿Qué finalidad tiene la revisión perimetral antes de arrancar?', 'Detectar daños, fugas, elementos sueltos, desgaste y obstáculos', 'Únicamente comprobar el combustible', 'Solo verificar la documentación', 'Calentar el equipo antes del turno', 'A', 'La diapositiva y el manual describen la vuelta perimetral como inspección sistemática de máquina y entorno.'),
  ('PERF-20H-B2-Q05', 20, 2, 5, '2.3', '¿Qué debe hacerse con cada defecto detectado en el checklist previo?', 'Ignorarlo si es pequeño', 'Clasificarlo y registrarlo antes de arrancar', 'Repararlo siempre el operador', 'Esperar a que aparezca una alarma', 'B', 'La diapositiva 2.3 y el manual indican que ningún defecto debe normalizarse y debe registrarse antes de arrancar.'),
  ('PERF-20H-B2-Q06', 20, 2, 6, '2.4', '¿Cómo debe acceder el operador al puesto de mando?', 'De espaldas y con rapidez', 'De cara a la máquina, manteniendo tres puntos de apoyo y sin objetos en las manos', 'Saltando desde el último peldaño', 'Usando mangueras como asidero', 'B', 'La presentación y el manual fijan tres puntos de apoyo, orientación hacia la máquina y manos libres.'),
  ('PERF-20H-B2-Q07', 20, 2, 7, '2.5', '¿Qué debe hacerse antes de manipular conexiones presurizadas o elementos eléctricos?', 'Aumentar la presión', 'Aislar la energía según el procedimiento', 'Golpear la conexión para comprobarla', 'Mover los cables hasta que desaparezca la alarma', 'B', 'La diapositiva y el manual prohíben intervenir en conexiones presurizadas o eléctricas sin aislamiento previo.'),
  ('PERF-20H-B2-Q08', 20, 2, 8, '2.6', '¿Cuál es una regla absoluta al buscar una fuga hidráulica?', 'Buscarla con la mano', 'Nunca buscarla con la mano', 'Aumentar la presión para verla mejor', 'Aflojar el racor para comprobar si existe presión', 'B', 'La diapositiva y el manual advierten del riesgo de inyección de fluido y prohíben buscar fugas con la mano.'),
  ('PERF-20H-B2-Q09', 20, 2, 9, '2.6', '¿Por qué una fuga hidráulica de alta presión es especialmente peligrosa?', 'Porque puede penetrar la piel y causar una lesión interna grave', 'Porque solo mancha el suelo', 'Porque reduce el ruido de la máquina', 'Porque enfría demasiado el circuito', 'A', 'La diapositiva 2.6 y el manual destacan el riesgo de inyección de fluido bajo la piel.'),
  ('PERF-20H-B2-Q10', 20, 2, 10, '2.7', '¿Cómo debe realizarse el cambio de una herramienta de perforación?', 'Con la máquina detenida y asegurada, sin presión residual ni personas en la zona de riesgo', 'Con el equipo girando lentamente', 'Aumentando el empuje para liberar la herramienta', 'Con una persona sujetando manualmente el varillaje', 'A', 'La diapositiva y el manual exigen inmovilización, ausencia de presión residual y control de la zona.'),
  ('PERF-20H-B2-Q11', 20, 2, 11, '2.8', '¿Qué debe hacerse si falla el sistema antipolvo?', 'Continuar únicamente con protección respiratoria', 'Detener, comunicar y no continuar hasta recuperar el control', 'Abrir las puertas de la cabina', 'Reducir el agua para evitar barro', 'B', 'La diapositiva y el manual dejan claro que el EPI no sustituye un sistema colectivo antipolvo averiado.'),
  ('PERF-20H-B2-Q12', 20, 2, 12, '2.8', '¿Cuál es la primera barrera de control del polvo en perforación según la jerarquía mostrada?', 'Protección respiratoria', 'Perforación húmeda y control en el foco', 'Abrir la cabina', 'Trabajar más rápido', 'B', 'La diapositiva 2.8 y el manual priorizan el control en la fuente mediante humectación o captación.'),
  ('PERF-20H-B2-Q13', 20, 2, 13, '2.9', '¿Qué relación existe entre los EPI y las protecciones colectivas?', 'Los EPI sustituyen siempre a las protecciones colectivas', 'Los EPI complementan las protecciones colectivas, no las sustituyen', 'Solo se utilizan EPI cuando falla una alarma', 'Las protecciones colectivas son opcionales', 'B', 'La presentación y el manual formulan expresamente este principio.'),
  ('PERF-20H-B2-Q14', 20, 2, 14, '2.10', '¿Qué debe hacer el operador si una persona entra en la zona de exclusión?', 'Continuar con cuidado', 'Detener la maniobra', 'Avisar después de terminar', 'Aumentar la señalización sin parar', 'B', 'La diapositiva y el manual indican que la entrada de una persona al área de riesgo obliga a detener.'),
  ('PERF-20H-B2-Q15', 20, 2, 15, '2.10', '¿La geometría de la zona de exclusión alrededor de la perforadora es siempre fija?', 'Sí, siempre es un círculo del mismo radio', 'No, cambia con posición del mástil, terreno, tráfico y tarea', 'Solo cambia por el turno', 'Únicamente cambia con la meteorología', 'B', 'La diapositiva 2.10 y el manual explican que la zona de exclusión se adapta a la configuración y al entorno.'),
  ('PERF-20H-B3-Q01', 20, 3, 1, '3.1', '¿Qué factores integra el posicionamiento sobre el punto de perforación?', 'Replanteo, estabilidad de la plataforma y cinemática del mástil', 'Solo orientación del mástil', 'Únicamente velocidad de avance', 'Consumo de combustible y temperatura', 'A', 'La diapositiva y el manual explican que posicionar no es solo situar la máquina, sino integrar replanteo, estabilidad y movimiento del mástil.'),
  ('PERF-20H-B3-Q02', 20, 3, 2, '3.2', 'Ante una alarma desconocida durante la puesta en marcha, ¿qué debe hacerse?', 'Ignorarla si la máquina arranca', 'Detener y consultar el manual antes de continuar', 'Borrar el historial', 'Reiniciar varias veces', 'B', 'La diapositiva y el manual indican que una alarma no conocida debe investigarse antes de seguir.'),
  ('PERF-20H-B3-Q03', 20, 3, 3, '3.2', '¿Qué debe verificarse antes de embocar durante la puesta en marcha?', 'Que el sistema de barrido o captación esté operativo', 'Solo que el motor esté caliente', 'Que no haya registro de alarmas antiguas', 'Que la broca tenga barro', 'A', 'La diapositiva 3.2 y el manual incluyen el sistema de barrido/captación entre las comprobaciones previas.'),
  ('PERF-20H-B3-Q04', 20, 3, 4, '3.3', '¿Qué debe hacer el operador ante un cambio brusco en velocidad de penetración, par o vibración?', 'Aumentar todos los parámetros', 'Reducir la energía de entrada y diagnosticar antes de continuar', 'Mantener el ritmo de avance a toda costa', 'Desactivar el sistema de barrido', 'B', 'La diapositiva y el manual señalan que un cambio brusco es una señal de desviación y no debe corregirse a ciegas.'),
  ('PERF-20H-B3-Q05', 20, 3, 5, '3.3', '¿Qué efecto puede tener un barrido insuficiente?', 'Atranque y aumento de polvo', 'Menor desgaste y mejor limpieza', 'Mejor refrigeración de la broca', 'Menor acumulación de detritus', 'A', 'La diapositiva 3.3 y el manual relacionan barrido insuficiente con atranque, polvo y mala evacuación.'),
  ('PERF-20H-B3-Q06', 20, 3, 6, '3.4', '¿Qué debe hacerse si la desviación del barreno supera la tolerancia?', 'Forzar la trayectoria', 'Informar al responsable y no forzar la corrección', 'Aumentar el empuje', 'Cambiar la broca con el equipo en marcha', 'B', 'La presentación y el manual establecen que la desviación fuera de tolerancia se comunica y no se corrige forzando.'),
  ('PERF-20H-B3-Q07', 20, 3, 7, '3.5', '¿Dónde deben permanecer manos y cuerpo durante el cambio de varillaje?', 'Dentro de la línea de caída', 'Fuera de la línea de caída y giro', 'Junto a las mordazas para guiar la varilla', 'Bajo el elemento suspendido', 'B', 'La diapositiva y el manual señalan expresamente mantener el cuerpo fuera de líneas de caída, giro y atrapamiento.'),
  ('PERF-20H-B3-Q08', 20, 3, 8, '3.6', '¿Qué indica una reducción del retorno de detritus?', 'Que nada ha cambiado', 'Puede existir obstrucción, cavidad, fuga de aire o acumulación en el fondo', 'Que el barreno ya ha terminado', 'Que debe aumentarse siempre el empuje', 'B', 'La diapositiva y el manual usan el retorno de detritus como indicador del estado del barreno.'),
  ('PERF-20H-B3-Q09', 20, 3, 9, '3.6', '¿Qué debe hacerse si desaparece completamente el retorno de detritus?', 'Seguir perforando unos metros', 'Parar la perforación y diagnosticar', 'Aumentar automáticamente el empuje', 'Reducir solo la rotación', 'B', 'La diapositiva 3.6 y el manual marcan la ausencia de retorno como condición de parada.'),
  ('PERF-20H-B3-Q10', 20, 3, 10, '3.7', '¿Qué debe hacerse antes de intervenir en un circuito con presión almacenada?', 'Identificar, aislar, descargar, verificar y bloquear', 'Aflojar un racor para comprobar', 'Aumentar presión y cerrar una válvula', 'Solo apagar la pantalla', 'A', 'La diapositiva y el manual muestran la secuencia de control de energía a presión.'),
  ('PERF-20H-B3-Q11', 20, 3, 11, '3.7', '¿Por qué no debe aflojarse un racor para comprobar si existe presión?', 'Porque la presión residual puede expulsarlo o inyectar fluido', 'Porque empeora la iluminación', 'Porque aumenta el polvo', 'Porque solo afecta al rendimiento', 'A', 'La diapositiva 3.7 y el manual prohíben esta práctica por la energía almacenada en el circuito.'),
  ('PERF-20H-B3-Q12', 20, 3, 12, '3.8', '¿Cuál es la primera respuesta correcta ante un atranque?', 'Aplicar más fuerza', 'Detener y diagnosticar', 'Aumentar la percusión', 'Introducir una herramienta improvisada', 'B', 'La diapositiva y el manual indican que el atranque es un síntoma y la respuesta empieza por detener.'),
  ('PERF-20H-B3-Q13', 20, 3, 13, '3.9', '¿Cuándo puede considerarse terminado un barreno?', 'En cuanto se alcanza la profundidad', 'Cuando además queda limpio, la sarta se retira ordenadamente y la boca está señalizada', 'Cuando el operador abandona la zona', 'Cuando deja de salir detritus', 'B', 'La diapositiva y el manual explican que alcanzar profundidad no completa la operación.'),
  ('PERF-20H-B3-Q14', 20, 3, 14, '3.10', '¿Qué debe comunicarse al siguiente turno?', 'Solo el nivel de combustible', 'Defectos y trabajos pendientes por escrito', 'Únicamente el número de barrenos', 'Nada si el equipo está apagado', 'B', 'La diapositiva y el manual exigen registrar defectos y trabajos pendientes para no trasladar riesgos ocultos.'),
  ('PERF-20H-B3-Q15', 20, 3, 15, '3.10', '¿Qué configuración debe dejarse al final del turno respecto al mástil?', 'Elevado para facilitar el siguiente arranque', 'Recogido en posición de transporte con retención activa', 'Apoyado contra el banco', 'Sin ninguna retención', 'B', 'La diapositiva 3.10 y el manual incluyen esta condición en el checklist de estacionamiento seguro.'),
  ('PERF-20H-B4-Q01', 20, 4, 1, '4.1', 'Si falla el sistema colectivo antipolvo, ¿es suficiente continuar solo con protección respiratoria?', 'Sí', 'No', 'Solo durante cinco minutos', 'Solo si no se ve polvo', 'B', 'La diapositiva y el manual establecen que la protección respiratoria es complementaria y no sustituye el control colectivo averiado.'),
  ('PERF-20H-B4-Q02', 20, 4, 2, '4.1', '¿La ausencia de una nube visible de polvo garantiza una exposición segura a sílice respirable?', 'Sí', 'No', 'Solo si hay viento', 'Solo si la máquina es nueva', 'B', 'La diapositiva 4.1 y el manual explican que la fracción respirable peligrosa puede ser invisible.'),
  ('PERF-20H-B4-Q03', 20, 4, 3, '4.2', '¿Qué efecto puede tener el ruido además de causar pérdida auditiva?', 'Mejora la comunicación', 'Puede ocultar alarmas y dificultar la comunicación', 'Elimina la necesidad de señalización', 'Reduce la fatiga', 'B', 'La presentación y el manual explican que el ruido también enmascara señales y comunicaciones.'),
  ('PERF-20H-B4-Q04', 20, 4, 4, '4.3', '¿Qué indica un aumento de vibración respecto al nivel habitual?', 'Siempre es normal', 'Puede ser señal de montaje incorrecto, desgaste, cambio de terreno o fallo incipiente', 'Solo falta de combustible', 'Que el equipo está bien nivelado', 'B', 'La diapositiva y el manual consideran la vibración anormal una señal de desviación a investigar.'),
  ('PERF-20H-B4-Q05', 20, 4, 5, '4.3', '¿Qué dos vías de vibración se diferencian en el curso?', 'Vibración de cuerpo entero y vibración mano-brazo', 'Vibración térmica y química', 'Vibración acústica y lumínica', 'Solo vibración del mástil', 'A', 'La diapositiva 4.3 y el manual distinguen VCE y VMB como vías de exposición diferentes.'),
  ('PERF-20H-B4-Q06', 20, 4, 6, '4.4', '¿Qué debe hacerse antes de aproximarse a una parte que pueda moverse?', 'Comprobar una parada total', 'Reducir velocidad pero mantener movimiento', 'Confiar en que el movimiento es lento', 'Permanecer dentro de la zona de proyección', 'A', 'La diapositiva y el manual indican detener completamente y verificar antes de aproximarse.'),
  ('PERF-20H-B4-Q07', 20, 4, 7, '4.5', '¿Qué factores influyen en el riesgo de vuelco cerca del borde del banco?', 'Centro de gravedad, resistencia del terreno, pendiente y configuración del mástil', 'Solo el color del equipo', 'Únicamente la experiencia del operador', 'Solo la velocidad de perforación', 'A', 'La diapositiva y el manual enumeran estos factores de estabilidad.'),
  ('PERF-20H-B4-Q08', 20, 4, 8, '4.6', '¿Es necesario tocar una línea eléctrica aérea para sufrir un accidente eléctrico?', 'Sí, siempre', 'No, puede producirse arco eléctrico a distancia', 'Solo si llueve', 'Solo en líneas de baja tensión', 'B', 'La presentación y el manual explican que el arco puede producirse sin contacto directo.'),
  ('PERF-20H-B4-Q09', 20, 4, 9, '4.6', '¿Cuándo aparece el riesgo de una línea eléctrica aérea?', 'Solo durante la perforación', 'También durante desplazamiento, montaje y posicionamiento del mástil', 'Solo cuando la máquina toca físicamente el conductor', 'Únicamente con lluvia', 'B', 'La diapositiva 4.6 y el manual indican que el riesgo existe en varias fases de movimiento de la perforadora.'),
  ('PERF-20H-B4-Q10', 20, 4, 10, '4.7', '¿Qué debe hacerse si se pierde visibilidad por polvo, niebla o condiciones nocturnas durante la interacción con maquinaria móvil?', 'Continuar más despacio', 'Detener hasta restablecer el control visual', 'Confiar en la baliza', 'Aumentar la velocidad para salir antes', 'B', 'La diapositiva y el manual fijan la pérdida de visibilidad como criterio de parada.'),
  ('PERF-20H-B4-Q11', 20, 4, 11, '4.8', '¿Quién puede manipular explosivos en la fase de voladura?', 'El perforista si conoce el frente', 'Solo el personal autorizado y habilitado para ello', 'Cualquier operador con experiencia', 'El conductor del dumper', 'B', 'La diapositiva y el manual separan claramente el rol del perforista del personal habilitado para explosivos.'),
  ('PERF-20H-B4-Q12', 20, 4, 12, '4.8', '¿Puede el perforista volver al frente de voladura simplemente porque ha pasado tiempo y no oye actividad?', 'Sí', 'No, solo con autorización expresa de la persona responsable', 'Solo si va acompañado', 'Solo si el equipo está apagado', 'B', 'La diapositiva 4.8 y el manual exigen autorización expresa antes del retorno.'),
  ('PERF-20H-B4-Q13', 20, 4, 13, '4.9', '¿Qué debe hacer el perforista ante un barreno fallido o una zona con posible explosivo?', 'Investigar introduciendo una herramienta', 'Detener, mantener distancia, impedir el acceso y avisar al responsable habilitado', 'Reperforar el barreno', 'Escarbar hasta confirmar si existe explosivo', 'B', 'La presentación y el manual prohíben investigar por iniciativa propia y marcan una secuencia de aislamiento y aviso.'),
  ('PERF-20H-B4-Q14', 20, 4, 14, '4.10', '¿Cuál es la primera acción de la secuencia PAS en un accidente?', 'Socorrer', 'Proteger', 'Avisar', 'Evacuar', 'B', 'La diapositiva y el manual señalan que primero hay que controlar el peligro para no multiplicar las víctimas.'),
  ('PERF-20H-B4-Q15', 20, 4, 15, '4.10', 'En primeros auxilios, ¿qué debe comunicarse al activar la alarma?', 'La ubicación exacta y el tipo de accidente', 'Solo el nombre del accidentado', 'Únicamente la hora', 'Solo el número de máquina', 'A', 'La diapositiva 4.10 y el manual incluyen ubicación y tipo de accidente en la fase de aviso.'),
  ('PERF-20H-B5-Q01', 20, 5, 1, '5.1', '¿Qué debe hacerse si un dispositivo de seguridad impide arrancar o continuar?', 'Puentearlo', 'Investigar la causa y reparar antes de continuar', 'Desactivarlo temporalmente', 'Ignorar la señal', 'B', 'La diapositiva y el manual explican que un bloqueo es información de seguridad, no un obstáculo productivo.'),
  ('PERF-20H-B5-Q02', 20, 5, 2, '5.1', '¿Qué función tiene un final de carrera?', 'Detectar posiciones extremas y limitar el movimiento antes de daño estructural', 'Aumentar automáticamente la velocidad', 'Eliminar el mantenimiento', 'Sustituir la parada de emergencia', 'A', 'La diapositiva 5.1 y el manual describen esta función de los finales de carrera.'),
  ('PERF-20H-B5-Q03', 20, 5, 3, '5.2', '¿Qué indica una zona roja en el control de presión y temperatura?', 'Funcionamiento normal', 'Atención sin necesidad de actuar', 'Umbral superado: detener la operación', 'Solo registrar el dato', 'C', 'La diapositiva y el manual asocian la zona roja con parada inmediata.'),
  ('PERF-20H-B5-Q04', 20, 5, 4, '5.2', '¿Puede ser anormal un valor que todavía se encuentra en zona verde?', 'No, nunca', 'Sí, si cambia rápidamente o se aparta del comportamiento habitual', 'Solo si hay una alarma roja', 'Solo durante el arranque', 'B', 'La diapositiva 5.2 y el manual destacan que las tendencias pueden revelar problemas antes de alcanzar un umbral.'),
  ('PERF-20H-B5-Q05', 20, 5, 5, '5.3', '¿Qué debe hacerse con las alarmas repetidas?', 'Borrar el historial', 'Documentarlas y comunicarlas para su análisis', 'Ignorarlas por habituales', 'Reiniciar hasta que desaparezcan', 'B', 'La diapositiva y el manual indican que las alarmas repetidas deben conservarse y analizarse.'),
  ('PERF-20H-B5-Q06', 20, 5, 6, '5.4', '¿Qué debe hacerse si no se controla visualmente el área de trabajo?', 'Continuar esperando que mejore', 'Detener la maniobra', 'Confiar solo en la baliza', 'Aumentar la iluminación sin detener', 'B', 'La diapositiva y el manual establecen la parada cuando no existe control visual suficiente.'),
  ('PERF-20H-B5-Q07', 20, 5, 7, '5.5', '¿Qué documento define los límites técnicos del modelo concreto de perforadora?', 'El manual del fabricante', 'El parte de producción', 'El albarán', 'El registro de entrada', 'A', 'La presentación y el manual sitúan el manual del fabricante como referencia técnica del equipo concreto.'),
  ('PERF-20H-B5-Q08', 20, 5, 8, '5.5', '¿Qué relación existe entre manual del fabricante, procedimiento interno e instrucción diaria?', 'La instrucción diaria puede superar los límites del fabricante', 'El procedimiento adapta los límites al centro y la instrucción diaria debe mantenerse dentro de ambos', 'El manual del fabricante es opcional', 'Cada documento puede contradecir al anterior', 'B', 'La diapositiva 5.5 y el manual establecen una jerarquía en la que los niveles inferiores no rebajan los límites superiores.'),
  ('PERF-20H-B5-Q09', 20, 5, 9, '5.6', '¿Cuál es la secuencia de aislamiento mostrada para mantenimiento de primer nivel?', 'Parar, aislar, descargar, bloquear, verificar cero e intervenir', 'Limpiar, arrancar, revisar y reparar', 'Apagar pantalla, intervenir y después aislar', 'Bloquear, arrancar y descargar', 'A', 'La diapositiva y el manual muestran esta secuencia obligatoria para controlar todas las energías.'),
  ('PERF-20H-B5-Q10', 20, 5, 10, '5.7', '¿Qué son los peligros residuales?', 'Riesgos que desaparecen por completo con el diseño', 'Peligros que permanecen aunque se hayan aplicado medidas de diseño y requieren medidas adicionales', 'Solo fallos de mantenimiento', 'Riesgos exclusivos de equipos antiguos', 'B', 'La diapositiva y el manual definen los peligros residuales como riesgos que permanecen tras las medidas de diseño.'),
  ('PERF-20H-B5-Q11', 20, 5, 11, '5.8', 'Si se pierde el contacto de radio durante una maniobra coordinada, ¿qué debe hacerse?', 'Continuar por señales visuales aproximadas', 'Detener hasta restablecer la comunicación', 'Considerar el silencio como consentimiento', 'Acelerar para terminar antes', 'B', 'La diapositiva y el manual establecen que el silencio no es consentimiento y que debe detenerse al perder comunicación.'),
  ('PERF-20H-B5-Q12', 20, 5, 12, '5.8', '¿Qué elementos debe incluir una comunicación segura?', 'Emisor, destinatario, ubicación, acción y confirmación', 'Solo una palabra breve', 'Únicamente el nombre del equipo', 'Silencio y gesto visual', 'A', 'La diapositiva 5.8 y el manual enumeran estos cinco elementos.'),
  ('PERF-20H-B5-Q13', 20, 5, 13, '5.9', '¿Cuál es una obligación del trabajador indicada en el curso?', 'Usar correctamente equipos, protecciones y procedimientos establecidos', 'Reducir las medidas cuando tenga experiencia', 'Modificar el manual del fabricante', 'Ignorar riesgos si no han causado accidente', 'A', 'La diapositiva y el manual incluyen el uso correcto de equipos y protecciones entre las obligaciones del trabajador.'),
  ('PERF-20H-B5-Q14', 20, 5, 14, '5.10', '¿Cuál es la periodicidad máxima del reciclaje para el grupo 5.2.d?', 'Cada año', 'Cada dos años', 'Cada cuatro años', 'Cada diez años', 'B', 'La diapositiva y el manual indican reciclaje obligatorio con periodicidad máxima de dos años y un mínimo de cinco horas.'),
  ('PERF-20H-B5-Q15', 20, 5, 15, '5.10', '¿Cuál es la duración mínima indicada para el reciclaje del grupo 5.2.d?', '2 horas', '5 horas lectivas', '10 horas', '20 horas', 'B', 'La diapositiva 5.10 y el manual establecen un mínimo de cinco horas lectivas para el reciclaje.'),
  ('PERF-5H-B1-Q01', 5, 1, 1, '1.1', '¿Cuál describe mejor la función del perforista en una explotación minera?', 'Solo accionar los mandos de la perforadora', 'Convertir un diseño en barrenos reales con geometría verificada y comunicar desviaciones', 'Diseñar por su cuenta la malla de perforación', 'Manipular explosivos una vez terminados los barrenos', 'B', 'La diapositiva y el manual definen al perforista como quien ejecuta el diseño, verifica la geometría y comunica desviaciones.'),
  ('PERF-5H-B1-Q02', 5, 1, 2, '1.2', '¿Qué debe hacer el perforista respecto a la malla de perforación?', 'Rediseñarla cuando crea que puede mejorarla', 'Respetarla y no rediseñarla unilateralmente', 'Modificarla si cambia el turno', 'Sustituirla por referencias visuales aproximadas', 'B', 'La presentación y el manual indican que el operador ejecuta el diseño y no rediseña unilateralmente la malla.'),
  ('PERF-5H-B1-Q03', 5, 1, 3, '1.3', '¿En qué debe basarse la selección de una perforadora?', 'En la disponibilidad inmediata del equipo', 'En la tarea y el entorno, comprobando capacidad de plataforma, gálibo, control de polvo y terreno', 'Solo en el diámetro de la broca', 'Únicamente en la antigüedad de la máquina', 'B', 'La diapositiva y el manual establecen que la selección depende de la tarea y del entorno, no de la mera disponibilidad.'),
  ('PERF-5H-B1-Q04', 5, 1, 4, '1.4', '¿Qué caracteriza al martillo en fondo?', 'La percusión se genera únicamente en la cabina', 'El percutor se sitúa junto a la broca dentro del barreno', 'No utiliza aire comprimido', 'Siempre es superior al martillo en cabeza', 'B', 'La diapositiva y el manual explican que en martillo en fondo el percutor trabaja junto a la broca.'),
  ('PERF-5H-B1-Q05', 5, 1, 5, '1.5', '¿Qué función realiza la sarta de perforación?', 'Solo sostiene la broca', 'Transmite par, empuje y percusión y conduce el fluido de barrido', 'Únicamente elimina el polvo', 'Solo mide la profundidad del barreno', 'B', 'La presentación y el manual describen la sarta como la cadena que transmite energía y conduce el fluido de barrido.'),
  ('PERF-5H-B1-Q06', 5, 1, 6, '1.6', '¿Qué parámetros definen principalmente la geometría de un barreno?', 'Posición, diámetro, profundidad e inclinación', 'Color, dureza y temperatura', 'Velocidad del vehículo y consumo', 'Ruido, iluminación y humedad', 'A', 'La diapositiva y el manual identifican posición, diámetro, profundidad e inclinación como parámetros esenciales.'),
  ('PERF-5H-B1-Q07', 5, 1, 7, '1.7', '¿Qué debe hacerse si aparece una grieta paralela a la coronación del banco?', 'Continuar con menor velocidad', 'Suspender la operación, balizar y esperar evaluación competente', 'Acercar la máquina para observar mejor', 'Rellenar la grieta y continuar', 'B', 'La diapositiva y el manual señalan la grieta paralela a la coronación como señal de parada.'),
  ('PERF-5H-B1-Q08', 5, 1, 8, '1.8', 'Antes de perforar en la base del banco, ¿qué debe confirmarse?', 'Que el frente está saneado y autorizado', 'Que la cabina esté cerrada', 'Que haya otra máquina cerca', 'Que el turno esté terminando', 'A', 'La diapositiva y el manual exigen comprobar el saneo del frente y la autorización antes de acercarse.'),
  ('PERF-5H-B1-Q09', 5, 1, 9, '1.9', '¿Qué riesgo específico presenta un bloque mal apoyado durante el taqueo?', 'Puede bascular, abrirse o proyectar fragmentos', 'Solo produce ruido', 'Únicamente aumenta el consumo de combustible', 'Elimina el riesgo de atrapamiento', 'A', 'La presentación y el manual explican que un bloque inestable puede moverse o fracturarse de forma imprevista.'),
  ('PERF-5H-B1-Q10', 5, 1, 10, '1.10', '¿Qué debe hacerse si falla el sistema de captación de polvo durante la perforación?', 'Continuar con más velocidad', 'Detener la perforación y comunicar', 'Abrir la cabina para ventilar', 'Ignorar el fallo si el polvo visible es pequeño', 'B', 'La diapositiva y el manual establecen que un fallo del sistema de captación obliga a detener y comunicar.'),
  ('PERF-5H-B2-Q01', 5, 2, 1, '2.1', '¿Cómo debe realizarse el reconocimiento del terreno antes de perforar?', 'Desde la cabina exclusivamente', 'Desde una posición segura, a pie y contrastando con los planos disponibles', 'Solo después de arrancar la máquina', 'Únicamente mediante fotografías', 'B', 'La diapositiva y el manual señalan que la visión desde cabina es insuficiente y que debe inspeccionarse desde una posición segura.'),
  ('PERF-5H-B2-Q02', 5, 2, 2, '2.2', '¿Qué riesgo puede generar una perforadora mal nivelada?', 'Solo un aumento de ruido', 'Errores de inclinación, esfuerzos laterales y riesgo de vuelco', 'Únicamente desgaste de pintura', 'Mejorar la precisión del barreno', 'B', 'La diapositiva y el manual vinculan la mala nivelación con errores geométricos, cargas no previstas y vuelco.'),
  ('PERF-5H-B2-Q03', 5, 2, 3, '2.3', '¿Qué finalidad tiene la revisión perimetral antes de arrancar?', 'Detectar daños, fugas, elementos sueltos, desgaste y obstáculos', 'Únicamente comprobar el combustible', 'Solo verificar la documentación', 'Calentar el equipo antes del turno', 'A', 'La diapositiva y el manual describen la vuelta perimetral como inspección sistemática de máquina y entorno.'),
  ('PERF-5H-B2-Q04', 5, 2, 4, '2.4', '¿Cómo debe acceder el operador al puesto de mando?', 'De espaldas y con rapidez', 'De cara a la máquina, manteniendo tres puntos de apoyo y sin objetos en las manos', 'Saltando desde el último peldaño', 'Usando mangueras como asidero', 'B', 'La presentación y el manual fijan tres puntos de apoyo, orientación hacia la máquina y manos libres.'),
  ('PERF-5H-B2-Q05', 5, 2, 5, '2.5', '¿Qué debe hacerse antes de manipular conexiones presurizadas o elementos eléctricos?', 'Aumentar la presión', 'Aislar la energía según el procedimiento', 'Golpear la conexión para comprobarla', 'Mover los cables hasta que desaparezca la alarma', 'B', 'La diapositiva y el manual prohíben intervenir en conexiones presurizadas o eléctricas sin aislamiento previo.'),
  ('PERF-5H-B2-Q06', 5, 2, 6, '2.6', '¿Cuál es una regla absoluta al buscar una fuga hidráulica?', 'Buscarla con la mano', 'Nunca buscarla con la mano', 'Aumentar la presión para verla mejor', 'Aflojar el racor para comprobar si existe presión', 'B', 'La diapositiva y el manual advierten del riesgo de inyección de fluido y prohíben buscar fugas con la mano.'),
  ('PERF-5H-B2-Q07', 5, 2, 7, '2.7', '¿Cómo debe realizarse el cambio de una herramienta de perforación?', 'Con la máquina detenida y asegurada, sin presión residual ni personas en la zona de riesgo', 'Con el equipo girando lentamente', 'Aumentando el empuje para liberar la herramienta', 'Con una persona sujetando manualmente el varillaje', 'A', 'La diapositiva y el manual exigen inmovilización, ausencia de presión residual y control de la zona.'),
  ('PERF-5H-B2-Q08', 5, 2, 8, '2.8', '¿Qué debe hacerse si falla el sistema antipolvo?', 'Continuar únicamente con protección respiratoria', 'Detener, comunicar y no continuar hasta recuperar el control', 'Abrir las puertas de la cabina', 'Reducir el agua para evitar barro', 'B', 'La diapositiva y el manual dejan claro que el EPI no sustituye un sistema colectivo antipolvo averiado.'),
  ('PERF-5H-B2-Q09', 5, 2, 9, '2.9', '¿Qué relación existe entre los EPI y las protecciones colectivas?', 'Los EPI sustituyen siempre a las protecciones colectivas', 'Los EPI complementan las protecciones colectivas, no las sustituyen', 'Solo se utilizan EPI cuando falla una alarma', 'Las protecciones colectivas son opcionales', 'B', 'La presentación y el manual formulan expresamente este principio.'),
  ('PERF-5H-B2-Q10', 5, 2, 10, '2.10', '¿Qué debe hacer el operador si una persona entra en la zona de exclusión?', 'Continuar con cuidado', 'Detener la maniobra', 'Avisar después de terminar', 'Aumentar la señalización sin parar', 'B', 'La diapositiva y el manual indican que la entrada de una persona al área de riesgo obliga a detener.'),
  ('PERF-5H-B3-Q01', 5, 3, 1, '3.1', '¿Qué factores integra el posicionamiento sobre el punto de perforación?', 'Replanteo, estabilidad de la plataforma y cinemática del mástil', 'Solo orientación del mástil', 'Únicamente velocidad de avance', 'Consumo de combustible y temperatura', 'A', 'La diapositiva y el manual explican que posicionar no es solo situar la máquina, sino integrar replanteo, estabilidad y movimiento del mástil.'),
  ('PERF-5H-B3-Q02', 5, 3, 2, '3.2', 'Ante una alarma desconocida durante la puesta en marcha, ¿qué debe hacerse?', 'Ignorarla si la máquina arranca', 'Detener y consultar el manual antes de continuar', 'Borrar el historial', 'Reiniciar varias veces', 'B', 'La diapositiva y el manual indican que una alarma no conocida debe investigarse antes de seguir.'),
  ('PERF-5H-B3-Q03', 5, 3, 3, '3.3', '¿Qué debe hacer el operador ante un cambio brusco en velocidad de penetración, par o vibración?', 'Aumentar todos los parámetros', 'Reducir la energía de entrada y diagnosticar antes de continuar', 'Mantener el ritmo de avance a toda costa', 'Desactivar el sistema de barrido', 'B', 'La diapositiva y el manual señalan que un cambio brusco es una señal de desviación y no debe corregirse a ciegas.'),
  ('PERF-5H-B3-Q04', 5, 3, 4, '3.4', '¿Qué debe hacerse si la desviación del barreno supera la tolerancia?', 'Forzar la trayectoria', 'Informar al responsable y no forzar la corrección', 'Aumentar el empuje', 'Cambiar la broca con el equipo en marcha', 'B', 'La presentación y el manual establecen que la desviación fuera de tolerancia se comunica y no se corrige forzando.'),
  ('PERF-5H-B3-Q05', 5, 3, 5, '3.5', '¿Dónde deben permanecer manos y cuerpo durante el cambio de varillaje?', 'Dentro de la línea de caída', 'Fuera de la línea de caída y giro', 'Junto a las mordazas para guiar la varilla', 'Bajo el elemento suspendido', 'B', 'La diapositiva y el manual señalan expresamente mantener el cuerpo fuera de líneas de caída, giro y atrapamiento.'),
  ('PERF-5H-B3-Q06', 5, 3, 6, '3.6', '¿Qué indica una reducción del retorno de detritus?', 'Que nada ha cambiado', 'Puede existir obstrucción, cavidad, fuga de aire o acumulación en el fondo', 'Que el barreno ya ha terminado', 'Que debe aumentarse siempre el empuje', 'B', 'La diapositiva y el manual usan el retorno de detritus como indicador del estado del barreno.'),
  ('PERF-5H-B3-Q07', 5, 3, 7, '3.7', '¿Qué debe hacerse antes de intervenir en un circuito con presión almacenada?', 'Identificar, aislar, descargar, verificar y bloquear', 'Aflojar un racor para comprobar', 'Aumentar presión y cerrar una válvula', 'Solo apagar la pantalla', 'A', 'La diapositiva y el manual muestran la secuencia de control de energía a presión.'),
  ('PERF-5H-B3-Q08', 5, 3, 8, '3.8', '¿Cuál es la primera respuesta correcta ante un atranque?', 'Aplicar más fuerza', 'Detener y diagnosticar', 'Aumentar la percusión', 'Introducir una herramienta improvisada', 'B', 'La diapositiva y el manual indican que el atranque es un síntoma y la respuesta empieza por detener.'),
  ('PERF-5H-B3-Q09', 5, 3, 9, '3.9', '¿Cuándo puede considerarse terminado un barreno?', 'En cuanto se alcanza la profundidad', 'Cuando además queda limpio, la sarta se retira ordenadamente y la boca está señalizada', 'Cuando el operador abandona la zona', 'Cuando deja de salir detritus', 'B', 'La diapositiva y el manual explican que alcanzar profundidad no completa la operación.'),
  ('PERF-5H-B3-Q10', 5, 3, 10, '3.10', '¿Qué debe comunicarse al siguiente turno?', 'Solo el nivel de combustible', 'Defectos y trabajos pendientes por escrito', 'Únicamente el número de barrenos', 'Nada si el equipo está apagado', 'B', 'La diapositiva y el manual exigen registrar defectos y trabajos pendientes para no trasladar riesgos ocultos.'),
  ('PERF-5H-B4-Q01', 5, 4, 1, '4.1', 'Si falla el sistema colectivo antipolvo, ¿es suficiente continuar solo con protección respiratoria?', 'Sí', 'No', 'Solo durante cinco minutos', 'Solo si no se ve polvo', 'B', 'La diapositiva y el manual establecen que la protección respiratoria es complementaria y no sustituye el control colectivo averiado.'),
  ('PERF-5H-B4-Q02', 5, 4, 2, '4.2', '¿Qué efecto puede tener el ruido además de causar pérdida auditiva?', 'Mejora la comunicación', 'Puede ocultar alarmas y dificultar la comunicación', 'Elimina la necesidad de señalización', 'Reduce la fatiga', 'B', 'La presentación y el manual explican que el ruido también enmascara señales y comunicaciones.'),
  ('PERF-5H-B4-Q03', 5, 4, 3, '4.3', '¿Qué indica un aumento de vibración respecto al nivel habitual?', 'Siempre es normal', 'Puede ser señal de montaje incorrecto, desgaste, cambio de terreno o fallo incipiente', 'Solo falta de combustible', 'Que el equipo está bien nivelado', 'B', 'La diapositiva y el manual consideran la vibración anormal una señal de desviación a investigar.'),
  ('PERF-5H-B4-Q04', 5, 4, 4, '4.4', '¿Qué debe hacerse antes de aproximarse a una parte que pueda moverse?', 'Comprobar una parada total', 'Reducir velocidad pero mantener movimiento', 'Confiar en que el movimiento es lento', 'Permanecer dentro de la zona de proyección', 'A', 'La diapositiva y el manual indican detener completamente y verificar antes de aproximarse.'),
  ('PERF-5H-B4-Q05', 5, 4, 5, '4.5', '¿Qué factores influyen en el riesgo de vuelco cerca del borde del banco?', 'Centro de gravedad, resistencia del terreno, pendiente y configuración del mástil', 'Solo el color del equipo', 'Únicamente la experiencia del operador', 'Solo la velocidad de perforación', 'A', 'La diapositiva y el manual enumeran estos factores de estabilidad.'),
  ('PERF-5H-B4-Q06', 5, 4, 6, '4.6', '¿Es necesario tocar una línea eléctrica aérea para sufrir un accidente eléctrico?', 'Sí, siempre', 'No, puede producirse arco eléctrico a distancia', 'Solo si llueve', 'Solo en líneas de baja tensión', 'B', 'La presentación y el manual explican que el arco puede producirse sin contacto directo.'),
  ('PERF-5H-B4-Q07', 5, 4, 7, '4.7', '¿Qué debe hacerse si se pierde visibilidad por polvo, niebla o condiciones nocturnas durante la interacción con maquinaria móvil?', 'Continuar más despacio', 'Detener hasta restablecer el control visual', 'Confiar en la baliza', 'Aumentar la velocidad para salir antes', 'B', 'La diapositiva y el manual fijan la pérdida de visibilidad como criterio de parada.'),
  ('PERF-5H-B4-Q08', 5, 4, 8, '4.8', '¿Quién puede manipular explosivos en la fase de voladura?', 'El perforista si conoce el frente', 'Solo el personal autorizado y habilitado para ello', 'Cualquier operador con experiencia', 'El conductor del dumper', 'B', 'La diapositiva y el manual separan claramente el rol del perforista del personal habilitado para explosivos.'),
  ('PERF-5H-B4-Q09', 5, 4, 9, '4.9', '¿Qué debe hacer el perforista ante un barreno fallido o una zona con posible explosivo?', 'Investigar introduciendo una herramienta', 'Detener, mantener distancia, impedir el acceso y avisar al responsable habilitado', 'Reperforar el barreno', 'Escarbar hasta confirmar si existe explosivo', 'B', 'La presentación y el manual prohíben investigar por iniciativa propia y marcan una secuencia de aislamiento y aviso.'),
  ('PERF-5H-B4-Q10', 5, 4, 10, '4.10', '¿Cuál es la primera acción de la secuencia PAS en un accidente?', 'Socorrer', 'Proteger', 'Avisar', 'Evacuar', 'B', 'La diapositiva y el manual señalan que primero hay que controlar el peligro para no multiplicar las víctimas.'),
  ('PERF-5H-B5-Q01', 5, 5, 1, '5.1', '¿Qué debe hacerse si un dispositivo de seguridad impide arrancar o continuar?', 'Puentearlo', 'Investigar la causa y reparar antes de continuar', 'Desactivarlo temporalmente', 'Ignorar la señal', 'B', 'La diapositiva y el manual explican que un bloqueo es información de seguridad, no un obstáculo productivo.'),
  ('PERF-5H-B5-Q02', 5, 5, 2, '5.2', '¿Qué indica una zona roja en el control de presión y temperatura?', 'Funcionamiento normal', 'Atención sin necesidad de actuar', 'Umbral superado: detener la operación', 'Solo registrar el dato', 'C', 'La diapositiva y el manual asocian la zona roja con parada inmediata.'),
  ('PERF-5H-B5-Q03', 5, 5, 3, '5.3', '¿Qué debe hacerse con las alarmas repetidas?', 'Borrar el historial', 'Documentarlas y comunicarlas para su análisis', 'Ignorarlas por habituales', 'Reiniciar hasta que desaparezcan', 'B', 'La diapositiva y el manual indican que las alarmas repetidas deben conservarse y analizarse.'),
  ('PERF-5H-B5-Q04', 5, 5, 4, '5.4', '¿Qué debe hacerse si no se controla visualmente el área de trabajo?', 'Continuar esperando que mejore', 'Detener la maniobra', 'Confiar solo en la baliza', 'Aumentar la iluminación sin detener', 'B', 'La diapositiva y el manual establecen la parada cuando no existe control visual suficiente.'),
  ('PERF-5H-B5-Q05', 5, 5, 5, '5.5', '¿Qué documento define los límites técnicos del modelo concreto de perforadora?', 'El manual del fabricante', 'El parte de producción', 'El albarán', 'El registro de entrada', 'A', 'La presentación y el manual sitúan el manual del fabricante como referencia técnica del equipo concreto.'),
  ('PERF-5H-B5-Q06', 5, 5, 6, '5.6', '¿Cuál es la secuencia de aislamiento mostrada para mantenimiento de primer nivel?', 'Parar, aislar, descargar, bloquear, verificar cero e intervenir', 'Limpiar, arrancar, revisar y reparar', 'Apagar pantalla, intervenir y después aislar', 'Bloquear, arrancar y descargar', 'A', 'La diapositiva y el manual muestran esta secuencia obligatoria para controlar todas las energías.'),
  ('PERF-5H-B5-Q07', 5, 5, 7, '5.7', '¿Qué son los peligros residuales?', 'Riesgos que desaparecen por completo con el diseño', 'Peligros que permanecen aunque se hayan aplicado medidas de diseño y requieren medidas adicionales', 'Solo fallos de mantenimiento', 'Riesgos exclusivos de equipos antiguos', 'B', 'La diapositiva y el manual definen los peligros residuales como riesgos que permanecen tras las medidas de diseño.'),
  ('PERF-5H-B5-Q08', 5, 5, 8, '5.8', 'Si se pierde el contacto de radio durante una maniobra coordinada, ¿qué debe hacerse?', 'Continuar por señales visuales aproximadas', 'Detener hasta restablecer la comunicación', 'Considerar el silencio como consentimiento', 'Acelerar para terminar antes', 'B', 'La diapositiva y el manual establecen que el silencio no es consentimiento y que debe detenerse al perder comunicación.'),
  ('PERF-5H-B5-Q09', 5, 5, 9, '5.9', '¿Cuál es una obligación del trabajador indicada en el curso?', 'Usar correctamente equipos, protecciones y procedimientos establecidos', 'Reducir las medidas cuando tenga experiencia', 'Modificar el manual del fabricante', 'Ignorar riesgos si no han causado accidente', 'A', 'La diapositiva y el manual incluyen el uso correcto de equipos y protecciones entre las obligaciones del trabajador.'),
  ('PERF-5H-B5-Q10', 5, 5, 10, '5.10', '¿Cuál es la periodicidad máxima del reciclaje para el grupo 5.2.d?', 'Cada año', 'Cada dos años', 'Cada cuatro años', 'Cada diez años', 'B', 'La diapositiva y el manual indican reciclaje obligatorio con periodicidad máxima de dos años y un mínimo de cinco horas.');

do $$
declare
  v_slug constant text := 'operadores-perforacion-corte-exterior';
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
      from _pf_preguntas p
      where p.duracion = v_duracion and p.bloque = v_bloque;

      if v_total = 0 then
        raise exception 'Sin preguntas para el bloque % (% h)', v_bloque, v_duracion;
      end if;

      insert into public.question_banks (course_version_id, title)
      values (
        v_version,
        format(
          'Evaluación aportada · Perforadora %s h · Bloque %s · 2026-09-11',
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
        select * from _pf_preguntas p
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
