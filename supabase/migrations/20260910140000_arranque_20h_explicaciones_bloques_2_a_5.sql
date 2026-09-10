-- Escribe las cuarenta explicaciones detalladas que faltaban en los bloques 2
-- a 5 del curso de arranque, carga y viales en su modalidad de 20 horas.
--
-- Situación de partida: el bloque 1 tenía sus diez explicaciones completas, de
-- unos dos mil caracteres cada una, pero las cuarenta partes restantes se
-- quedaban en un párrafo suelto de entre 240 y 500 caracteres, sin ninguna de
-- las secciones que el reproductor sabe representar. El alumno de 20 horas veía
-- la diapositiva y una nota breve donde el de 5 horas ya tenía el desarrollo
-- completo.
--
-- Fuente: «Curso 4 · 20 horas · Bloques 2, 3, 4 y 5 · 40 explicaciones»
-- (Inmíner Campus, desarrollo técnico y preventivo ampliado para las partes 2.1
-- a 5.10). El documento dedica una página a cada parte y ya está redactado con
-- los ocho encabezados del reproductor: Objetivo, Explicación de base,
-- Profundización técnica y criterio preventivo, Secuencia operativa
-- recomendada, Caso práctico razonado, Errores críticos que deben evitarse,
-- Comprobación antes de continuar e Idea clave.
--
-- Es material propio de la modalidad de 20 horas, distinto del manual maestro
-- que alimenta el reciclaje de 5 horas, de modo que las dos modalidades
-- conservan su propia redacción como ya ocurría en el bloque 1.
--
-- No se tocan el bloque 1, el bloque 6 de evaluación, las transcripciones, los
-- audios, las imágenes, las matrículas ni el progreso.

begin;

update public.lesson_segment_slides s set body = $b$Objetivo
Preparar al operador y sus EPI sin confundir protección individual con control del riesgo en origen.

Explicación de base
Antes de acceder a la máquina, el operador debe encontrarse en condiciones físicas y mentales adecuadas, sin fatiga incapacitante ni efectos de alcohol, drogas o medicamentos que reduzcan la atención. La ropa ha de quedar ajustada y sin elementos colgantes que puedan engancharse. El casco, el calzado de seguridad, el chaleco de alta visibilidad, los guantes y las protecciones auditiva, ocular o respiratoria se seleccionan según la evaluación de riesgos. Los EPI complementan las medidas colectivas, pero no sustituyen una cabina segura, una zona delimitada o un sistema de captación de polvo. También debe conocerse dónde guardarlos para evitar contaminación y cómo comprobar su estado antes de usarlos.

Profundización técnica y criterio preventivo
La fatiga, la medicación sedante, el calor o una ropa inadecuada alteran percepción, reacción y movilidad. Los EPI se eligen por riesgo residual: por ejemplo, la protección respiratoria exige filtro adecuado, ajuste facial, conservación limpia y sustitución según criterio; no compensa una cabina sin estanqueidad o un foco de polvo no controlado.

Secuencia operativa recomendada
• Confirmar aptitud física y mental antes de asumir el equipo.
• Revisar ropa ajustada, calzado, alta visibilidad y casco.
• Seleccionar protección ocular, auditiva y respiratoria según evaluación.
• Comprobar marcado, talla, limpieza, fecha y ausencia de daños.
• Guardar los EPI sin contaminación y comunicar cualquier incompatibilidad.

Caso práctico razonado
Un operador ha tomado un medicamento con advertencia de somnolencia. Aunque se encuentre aparentemente bien, no debe probar su reacción conduciendo: informa al responsable para valorar aptitud y reasignación sin exponer a terceros.

Errores críticos que deben evitarse
• Ocultar fatiga para no retrasar el relevo.
• Usar un respirador sin prueba de ajuste o con barba en el sello.
• Confiar en el EPI para aceptar una cabina o zona de trabajo deficiente.

Comprobación antes de continuar
• Estado personal comunicado
• Ropa sin elementos colgantes
• EPI específico revisado
• Cabina y medidas colectivas disponibles

Idea clave
La primera autorización del turno es la aptitud del propio operador; un EPI correcto complementa, pero nunca sustituye, las medidas técnicas y organizativas.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Realizar una inspección perimetral sistemática capaz de detectar defectos antes de presurizar o mover la máquina.

Explicación de base
La revisión diaria empieza desde el suelo y con la máquina inmovilizada. Se recorre todo el perímetro buscando personas, obstáculos, daños, piezas sueltas, fugas, acumulaciones de material y signos de incendio. Se comprueban peldaños, pasamanos, cristales, cámaras, espejos, luces y señalización. Bajo la máquina se observa si existen manchas recientes de combustible, aceite, refrigerante o fluido hidráulico. El cucharón, la hoja o el accesorio deben estar apoyados y sin deformaciones evidentes. Esta inspección no es un trámite: permite descubrir defectos antes de presurizar sistemas o poner en movimiento toneladas de masa. Cualquier anomalía se registra y se valora antes del arranque.

Profundización técnica y criterio preventivo
El recorrido debe tener siempre el mismo sentido para evitar zonas olvidadas. Las manchas recientes se interpretan por color, olor y punto de origen, pero el diagnóstico corresponde a personal competente. También se buscan huellas de impacto, piezas flojas, material acumulado cerca de superficies calientes y objetos dentro del radio de giro.

Secuencia operativa recomendada
• Inmovilizar, apoyar el equipo y asegurar el área.
• Recorrer 360 grados desde el suelo con buena iluminación.
• Observar parte inferior, articulaciones, ruedas o cadenas y accesorio.
• Revisar accesos, cristales, luces, cámaras, espejos y señalización.
• Registrar el defecto y decidir aptitud antes del arranque.

Caso práctico razonado
Aparece una pequeña mancha bajo el eje sin goteo visible. Limpiarla impediría saber si reaparece; se marca su posición, se identifica el circuito afectado y se comunica antes de mover la máquina.

Errores críticos que deben evitarse
• Subir directamente a cabina por haber usado la máquina el día anterior.
• Tocar o probar una fuga con la mano.
• Normalizar daños pequeños que afectan a retención, visión o incendio.

Comprobación antes de continuar
• Perímetro libre
• Sin fugas ni piezas sueltas
• Accesos limpios
• Equipo apoyado y sin deformaciones

Idea clave
La inspección perimetral no busca demostrar que la máquina funciona, sino encontrar razones por las que no debería arrancarse.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Comprobar fluidos y detectar fugas sin exponerse a presión, temperatura, incendio o contaminación.

Explicación de base
Los niveles se comprueban siguiendo el manual y con la máquina en la posición indicada, porque una lectura incorrecta puede provocar sobrellenado o falta de lubricación. Nunca se abre en caliente un tapón de refrigerante ni se busca una fuga hidráulica con la mano: el fluido a presión puede penetrar la piel y causar lesiones graves. Para localizar pérdidas se emplean medios adecuados y personal competente. Al repostar, se detiene el motor, se evita cualquier fuente de ignición y se controla el derrame. Si aparece olor a combustible, una manguera dañada o pérdida importante, la máquina queda fuera de servicio hasta que se elimine la causa, no solo hasta limpiar la mancha.

Profundización técnica y criterio preventivo
La lectura de un nivel depende de temperatura, horizontalidad y posición de cilindros. Un circuito hidráulico puede superar centenares de bar y una microfuga producir inyección subcutánea. El refrigerante caliente puede liberar vapor de forma súbita. Por ello se espera el enfriamiento, se despresuriza y se utilizan cartón, pantalla o instrumental, nunca la piel.

Secuencia operativa recomendada
• Estacionar según la posición de lectura indicada por el fabricante.
• Esperar el tiempo de estabilización o enfriamiento exigido.
• Leer niveles y comparar con rangos, no solo con presencia de fluido.
• Buscar indicios de fuga sin contacto corporal.
• Reponer con producto correcto y controlar derrames; aislar ante defecto.

Caso práctico razonado
El depósito hidráulico parece bajo con el implemento elevado. Antes de añadir aceite se coloca la máquina en la configuración prescrita; de lo contrario podría sobrellenarse y expulsar fluido al bajar los cilindros.

Errores críticos que deben evitarse
• Abrir el vaso de expansión en caliente.
• Apretar una conexión presurizada.
• Mezclar productos incompatibles o continuar tras limpiar el derrame.

Comprobación antes de continuar
• Máquina en posición de lectura
• Circuito frío/despresurizado
• Producto y nivel correctos
• Derrames contenidos y causa evaluada

Idea clave
La ausencia de alarma no convierte una fuga o un nivel dudoso en aceptable: la verificación debe realizarse en la condición técnica definida.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Evaluar el contacto con el terreno y reconocer cuándo neumáticos o cadenas exigen inmovilización o intervención especializada.

Explicación de base
En una pala se revisan presión, cortes, abultamientos, desgaste, llantas y fijaciones. Los neumáticos de gran tamaño pueden liberar mucha energía; su inflado y reparación exigen procedimientos y equipos específicos, sin situarse frente al aro o a la trayectoria de una posible proyección. En máquinas de cadenas se inspeccionan tejas, bulones, rodillos, rueda guía, rueda motriz y tensión aparente. Una cadena excesivamente floja puede salirse y una demasiado tensa acelera el desgaste. También se retiran piedras atrapadas solo con el equipo parado y asegurado. El operador comunica daños o desgaste anormal y no intenta intervenir si la tarea excede el mantenimiento autorizado.

Profundización técnica y criterio preventivo
En neumáticos grandes, presión, aro, llanta y fijaciones almacenan energía capaz de proyectar componentes. En cadenas, la tensión cambia con suciedad y temperatura y afecta desgaste, guía y esfuerzo. El operador inspecciona; el inflado, desmontaje o ajuste se ejecuta con útiles, posición y competencia definidos.

Secuencia operativa recomendada
• Inspeccionar cortes, bultos, desgaste, fijaciones y presión aparente.
• En cadenas, revisar tejas, bulones, rodillos, guías y tensión.
• Buscar desgaste desigual, calentamiento o piedras atrapadas.
• No colocarse en la trayectoria potencial del aro o del equipo.
• Comunicar y bloquear la máquina cuando el defecto comprometa control.

Caso práctico razonado
Una pala presenta un abultamiento lateral, aunque la presión es correcta. El daño estructural puede evolucionar a reventón; no se acepta por cumplir el valor del manómetro.

Errores críticos que deben evitarse
• Golpear o calentar una llanta para liberar una pieza.
• Retirar piedras con la máquina en movimiento.
• Ajustar una cadena sin considerar el procedimiento de despresurización.

Comprobación antes de continuar
• Sin cortes ni abultamientos
• Fijaciones completas
• Tren sin piezas sueltas
• Tensión/desgaste dentro de criterio

Idea clave
Presión correcta no equivale a neumático seguro, y capacidad de avance no equivale a tren de rodaje apto.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Comprobar la integridad del equipo de trabajo y neutralizar la energía hidráulica y gravitatoria antes de aproximarse.

Explicación de base
El cucharón, la hoja, la pluma, el balancín y los accesorios soportan esfuerzos elevados. Antes del uso se inspeccionan soldaduras, pasadores, bulones, dientes, cuchillas, retenedores, cilindros y latiguillos. Una fisura, un pasador desplazado o una fuga puede terminar en caída del accesorio o pérdida de control. Las mangueras no deben presentar rozaduras, ampollas ni alambres expuestos. Ninguna persona debe situarse bajo un equipo elevado sin bloqueo mecánico certificado. Si se necesita limpiar o revisar una articulación, se apoya el equipo, se descarga la presión residual, se detiene el motor y se aplica el procedimiento de aislamiento previsto.

Profundización técnica y criterio preventivo
Pasadores, retenedores, soldaduras y latiguillos transmiten cargas cíclicas. Una pequeña fisura puede propagarse, y un cilindro aparentemente estable puede descender por fuga interna o rotura. Apoyar el implemento elimina parte del riesgo; cuando debe permanecer elevado se añade un bloqueo mecánico certificado.

Secuencia operativa recomendada
• Apoyar el equipo y observar geometría, soldaduras y elementos de unión.
• Revisar dientes, cuchillas, pasadores y retenedores.
• Inspeccionar cilindros y latiguillos por roce, ampollas o alambre expuesto.
• Descargar presión y aplicar aislamiento antes de tocar.
• Usar soporte mecánico diseñado si el implemento debe quedar elevado.

Caso práctico razonado
Para limpiar material detrás de una hoja elevada no basta con parar el motor: el peso sigue almacenando energía. La hoja se apoya o se instala el bloqueo previsto antes de entrar en la zona.

Errores críticos que deben evitarse
• Trabajar bajo un implemento sostenido solo por cilindros.
• Recolocar un pasador desplazado con el sistema presurizado.
• Aceptar una fisura por no existir deformación visible.

Comprobación antes de continuar
• Equipo apoyado/bloqueado
• Uniones y retenedores íntegros
• Latiguillos sin daño
• Presión residual descargada

Idea clave
La prevención efectiva combina inspección de integridad y eliminación física de cualquier movimiento posible.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Acceder a cabina y adaptar el puesto reduciendo caídas, posturas forzadas, pérdida de control y exposición en caso de vuelco.

Explicación de base
Se sube y baja mirando hacia la máquina y manteniendo tres puntos de apoyo. Los peldaños y asideros deben estar limpios de barro, grasa, hielo o material suelto. No se utiliza el volante, una palanca ni una manguera como agarradero, y nunca se salta desde la cabina. Una vez dentro, se ajustan asiento, reposabrazos, espejos y mandos para trabajar sin posturas forzadas. Se limpia el parabrisas, se comprueba la salida de emergencia y se retiran objetos sueltos que podrían bloquear pedales. El cinturón se abrocha antes de mover la máquina; la estructura ROPS protege de forma eficaz cuando el operador permanece dentro del espacio protegido.

Profundización técnica y criterio preventivo
Tres puntos de apoyo significan dos manos y un pie o dos pies y una mano en contacto estable, siempre mirando a la máquina. Dentro, la ergonomía influye en precisión y fatiga: asiento, reposabrazos y espejos se ajustan antes de moverse. El cinturón es parte funcional de la protección ROPS.

Secuencia operativa recomendada
• Limpiar peldaños y asideros antes de subir.
• Subir de frente usando únicamente puntos diseñados.
• Ajustar asiento, mandos, espejos y climatización.
• Retirar objetos que puedan trabar pedales o controles.
• Comprobar salida de emergencia y abrochar cinturón.

Caso práctico razonado
Un operador baja con una carpeta en la mano. Al perder uno de los apoyos aumenta el riesgo de caída; el objeto debe transportarse en una bolsa, subirlo por otro medio o depositarlo antes de descender.

Errores críticos que deben evitarse
• Usar volante o manguera como asidero.
• Saltar desde el último peldaño.
• Trabajar sin cinturón porque la cabina dispone de ROPS.

Comprobación antes de continuar
• Peldaños limpios
• Tres puntos mantenidos
• Puesto ajustado
• Cinturón colocado y salida libre

Idea clave
ROPS, asiento y cinturón forman un sistema: la estructura pierde gran parte de su eficacia si el operador puede salir del volumen protegido.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Verificar a baja velocidad que los sistemas de control y aviso responden antes de entrar en la zona productiva.

Explicación de base
Tras arrancar, se observan el panel y las alarmas mientras el motor alcanza las condiciones indicadas por el fabricante. Antes de entrar en producción se prueban freno de servicio, estacionamiento, dirección, bocina, alarma de retroceso, luces, limpiaparabrisas y mandos del equipo en una zona segura. En excavadoras se comprueba el bloqueo hidráulico y el freno o control de giro; en palas, la dirección de emergencia cuando proceda. La prueba se realiza a baja velocidad, sin personas cerca y atendiendo a ruidos, vibraciones o respuestas lentas. Una alarma no se anula para continuar trabajando: se identifica su causa y se aplica el procedimiento correspondiente.

Profundización técnica y criterio preventivo
La prueba funcional debe aislar variables: primero indicadores y alarmas, después mandos, frenos, dirección y ayudas de visibilidad. Se realiza en una zona conocida y despejada, porque un sistema defectuoso no debe descubrirse en una rampa o junto a personal. Una respuesta lenta también es una anomalía aunque el movimiento termine produciéndose.

Secuencia operativa recomendada
• Arrancar con mandos neutros y observar autodiagnóstico.
• Esperar condiciones de presión y temperatura del fabricante.
• Probar freno de servicio y estacionamiento en zona segura.
• Comprobar dirección, bocina, retroceso, luces y limpiaparabrisas.
• Mover el equipo cerca del suelo y detener ante respuesta anormal.

Caso práctico razonado
La alarma de retroceso no suena, pero la cámara funciona. Son barreras diferentes: la cámara ayuda al operador y la alarma avisa a terceros. No se considera compensada automáticamente.

Errores críticos que deben evitarse
• Probar frenos en una pendiente.
• Anular una alarma persistente.
• Entrar en producción para comprobar si la avería se mantiene bajo carga.

Comprobación antes de continuar
• Panel sin avisos no resueltos
• Frenos y dirección probados
• Avisos audibles/visuales operativos
• Mandos con respuesta normal

Idea clave
La prueba previa debe crear un fallo seguro: cualquier duda aparece en una zona controlada, no durante una maniobra crítica.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar bloqueo y consignación identificando todas las energías capaces de provocar movimiento o lesión.

Explicación de base
El operador puede realizar las operaciones básicas asignadas por el fabricante y la empresa, como limpieza, engrase o comprobaciones sencillas. Antes de intervenir se estaciona en terreno firme, se apoya el equipo, se acciona el freno, se detiene el motor y se retira o controla la llave. Cuando exista riesgo por energía eléctrica, hidráulica, neumática, mecánica o térmica, se bloquea, se consigna y se verifica la ausencia de energía. Un cartel sin aislamiento físico puede ser insuficiente. Las protecciones retiradas deben colocarse antes del arranque. Si el trabajo requiere elevar la máquina o el implemento, se utilizan soportes diseñados para ello; nunca se confía únicamente en los cilindros hidráulicos.

Profundización técnica y criterio preventivo
Parar el motor no elimina gravedad, presión residual, acumuladores, temperatura, baterías ni tensión elástica. La consignación exige aislar cada fuente, bloquear el dispositivo, identificar al responsable y verificar que el sistema no puede ponerse en marcha. Un cartel informa, pero sin aislamiento puede no impedir la energización.

Secuencia operativa recomendada
• Estacionar firme, apoyar equipo, frenar y detener motor.
• Identificar energía eléctrica, hidráulica, mecánica, neumática y térmica.
• Aislar y bloquear con dispositivos previstos.
• Descargar acumulaciones y verificar cero energía con método seguro.
• Restituir resguardos y retirar bloqueos solo por procedimiento.

Caso práctico razonado
Para intervenir en la articulación de una pala, retirar la llave no impide que el bastidor se cierre por fuerza externa o residual. Se instala además la barra o bloqueo mecánico de articulación.

Errores críticos que deben evitarse
• Confiar solo en un letrero de no arrancar.
• Usar madera o piezas improvisadas como soporte.
• Retirar el bloqueo de otra persona para acelerar la puesta en servicio.

Comprobación antes de continuar
• Todas las energías identificadas
• Aislamiento físico aplicado
• Ausencia de energía verificada
• Restitución controlada

Idea clave
Consignar no es apagar: es impedir, demostrar y controlar cualquier liberación de energía.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Cambiar accesorios garantizando compatibilidad, conexión limpia, bloqueo positivo y prueba controlada.

Explicación de base
El cambio de cucharas, martillos, horquillas u otros accesorios se realiza en una superficie estable, dentro de una zona sin personas y siguiendo la secuencia del fabricante. Antes de desconectar circuitos se apaga el motor y se libera la presión residual. Los acoplamientos se mantienen limpios para evitar fallos y contaminación del sistema. Una vez instalado el accesorio, el operador verifica que los pasadores o indicadores de bloqueo estén en la posición correcta, comprueba conexiones y hace una prueba funcional próxima al suelo. Si el acoplador dispone de confirmación visual o acústica, se utiliza, pero no sustituye la inspección directa. Un accesorio mal enganchado puede desprenderse sin previo aviso.

Profundización técnica y criterio preventivo
El acoplador rápido reduce tiempo pero introduce un modo de fallo grave: cierre aparente sin retención real. La verificación debe combinar indicador, inspección directa y prueba cerca del suelo. Los circuitos se despresurizan y se mantienen limpios para evitar inyección, fugas y contaminación que dañe válvulas.

Secuencia operativa recomendada
• Confirmar compatibilidad, masa, caudal y presión.
• Delimitar una superficie estable y mantener terceros fuera.
• Apoyar, parar y descargar presión antes de desconectar.
• Acoplar y verificar visualmente pasadores/indicadores.
• Probar retención y función a baja altura; revisar fugas.

Caso práctico razonado
El indicador de cabina muestra bloqueo, pero un pasador no es visible en su alojamiento. La señal no prevalece sobre una inspección incoherente: se repite el acoplamiento y se inmoviliza si persiste.

Errores críticos que deben evitarse
• Conectar bajo presión.
• Confiar únicamente en el indicador acústico.
• Levantar la cuchara sobre personas para “confirmar” el enganche.

Comprobación antes de continuar
• Accesorio compatible
• Acoplamientos limpios
• Bloqueo visual confirmado
• Prueba próxima al suelo superada

Idea clave
La prueba de un accesorio debe hacerse donde un fallo tenga consecuencias mínimas: despacio, cerca del suelo y sin personas.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Planificar embarque, amarre, remolcado o recuperación sin exponer a personas a caída, vuelco o latigazo.

Explicación de base
Subir una máquina a una góndola requiere un plan: capacidad del vehículo, rampas adecuadas, terreno nivelado, alineación, ausencia de personas y guía de un señalista cuando la visibilidad sea limitada. La máquina se centra, se inmoviliza y se asegura mediante los puntos de amarre definidos. El remolcado o recuperación solo se realiza con procedimiento autorizado, elementos certificados y puntos de anclaje previstos por el fabricante. Cables y eslingas pueden romperse y generar una zona de latigazo que debe quedar despejada. Si la máquina está en pendiente, hundida o cerca de un borde, primero se estabiliza la situación y se designa una única persona para dirigir la maniobra.

Profundización técnica y criterio preventivo
Estas maniobras combinan pendiente, cambios de apoyo y esfuerzos de tiro difíciles de estimar. La capacidad de rampa, góndola, puntos de amarre y accesorios debe superar las cargas previstas con el margen exigido. La zona de posible rotura de cables se mantiene vacía y una sola persona dirige la secuencia.

Secuencia operativa recomendada
• Evaluar masas, dimensiones, pendientes, firme y capacidad del transporte.
• Alinear rampas, calzar y delimitar la zona.
• Embarcar centrado y a velocidad mínima con señalista si procede.
• Apoyar equipo, inmovilizar y amarrar en puntos previstos.
• En recuperación, estabilizar primero y definir tiro, exclusión y mando único.

Caso práctico razonado
Una máquina hundida junto a un borde no se extrae aumentando el tirón. Primero se valora estabilidad del terreno, trayectoria de salida y resistencia de anclajes; un esfuerzo brusco puede desplazar ambos equipos.

Errores críticos que deben evitarse
• Usar dientes o puntos no diseñados como anclaje.
• Permanecer dentro del ángulo formado por una eslinga.
• Guiar con varias personas dando órdenes simultáneas.

Comprobación antes de continuar
• Capacidades verificadas
• Rampas y vehículo estabilizados
• Zona de latigazo vacía
• Amarres/puntos certificados

Idea clave
En transporte y recuperación, controlar geometría y energía de tiro es más importante que disponer de potencia suficiente.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 2 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Arrancar y acondicionar la máquina sin puentear protecciones ni aplicar carga antes de estabilizar sus sistemas.

Explicación de base
El motor se arranca desde el puesto del operador, con los mandos neutralizados y después de confirmar que no hay nadie alrededor. No se puentean sistemas de arranque ni se pone en marcha la máquina desde el suelo. En recintos con ventilación insuficiente, los gases de escape pueden alcanzar concentraciones peligrosas. Durante el calentamiento se vigilan presión de aceite, temperatura, carga eléctrica y mensajes del panel. Antes de aplicar carga se comprueba que los sistemas responden de forma normal. El tiempo y régimen de calentamiento dependen del fabricante y de la temperatura ambiente. Si la máquina produce humo anormal, golpeteos o una alarma persistente, se detiene y se informa antes de iniciar el trabajo.

Profundización técnica y criterio preventivo
El arranque desde cabina confirma neutralización y permite leer el autodiagnóstico. En frío, lubricantes viscosos y presiones transitorias exigen el régimen indicado; calentar con aceleraciones bruscas aumenta desgaste. En recintos, el escape debe evacuar gases para impedir acumulación de monóxido de carbono y otros contaminantes.

Secuencia operativa recomendada
• Comprobar neutralización, freno y área despejada.
• Arrancar únicamente desde el puesto del operador.
• Interpretar testigos, presiones, temperatura y mensajes.
• Calentar al régimen y tiempo del fabricante.
• Probar respuesta y detener ante humo, ruido o alarma anormal.

Caso práctico razonado
El motor arranca, pero la presión de aceite tarda más de lo habitual. No se acelera para “hacer subir” la presión; se detiene según procedimiento y se investiga la causa.

Errores críticos que deben evitarse
• Puenteo desde el suelo.
• Calentamiento prolongado en local mal ventilado.
• Aplicar carga con una alarma persistente.

Comprobación antes de continuar
• Mandos neutros
• Área avisada
• Parámetros estabilizados
• Sin humo, ruido o alarma anormal

Idea clave
El calentamiento es una comprobación activa, no un tiempo muerto: confirma que la máquina puede aceptar carga sin degradar seguridad.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Gestionar zonas ciegas mediante segregación, ayudas técnicas y comunicación inequívoca.

Explicación de base
Las máquinas grandes tienen zonas ciegas que pueden ocultar por completo a una persona o a un vehículo ligero. Cámaras, espejos, alarmas y sensores ayudan, pero no eliminan la obligación de observar. Antes de moverse se revisa el entorno, se avisa y se espera el tiempo suficiente para que todos reaccionen. Cuando la maniobra no puede controlarse desde la cabina, interviene un señalista identificado, situado en un lugar visible y utilizando señales acordadas. Si se pierde el contacto, la máquina se detiene. Está prohibido permitir pasajeros salvo que exista un asiento homologado. El radio de giro y la zona bajo el equipo de trabajo se mantienen libres.

Profundización técnica y criterio preventivo
El tamaño de una zona ciega cambia con cucharón, pluma, giro y suciedad de cristales. Una cámara ofrece un campo limitado y puede distorsionar distancias. El señalista debe situarse fuera de trayectoria y ser visible; la pérdida de contacto se interpreta como orden de parada, no como permiso para completar el movimiento.

Secuencia operativa recomendada
• Revisar entorno, espejos y cámaras antes de mover.
• Avisar con medios establecidos y esperar respuesta.
• Mantener radio de giro y zona bajo equipo libres.
• Usar señalista identificado cuando no exista visión suficiente.
• Parar inmediatamente al perder contacto o aparecer un tercero.

Caso práctico razonado
Durante una reversa, el señalista desaparece detrás de un volquete. Aunque la cámara muestre libre la zona inmediata, se detiene hasta recuperar comunicación y conocer su posición.

Errores críticos que deben evitarse
• Dar por despejada una zona porque sonó la alarma.
• Aceptar pasajeros sin asiento homologado.
• Seguir una señal de una persona no designada.

Comprobación antes de continuar
• Cristales/ayudas limpios
• Área segregada
• Señalista identificado
• Regla de pérdida de contacto aplicada

Idea clave
La incertidumbre sobre la posición de una persona equivale a una condición de parada.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Ejecutar el ciclo de pala manteniendo alineación, estabilidad, carga baja y coordinación con el camión.

Explicación de base
Para cargar con pala, se aproxima el cucharón bajo y con los bastidores alineados. El ataque se realiza sobre una superficie firme y lo más horizontal posible, utilizando el ancho del cucharón sin embestir el acopio. Se evita hacer girar la articulación con el cucharón enterrado, porque aumenta esfuerzos y reduce estabilidad. Tras el llenado se inclina el cucharón para retener el material y se retrocede mirando la trayectoria. Durante el desplazamiento se mantiene bajo, sin superar la carga nominal. La descarga sobre un camión se hace sin golpear la caja ni pasar sobre la cabina. El operador distribuye la carga de forma uniforme siguiendo la comunicación establecida con el conductor.

Profundización técnica y criterio preventivo
La penetración alineada reduce esfuerzos laterales en articulación, neumáticos y cucharón. Con la carga elevada aumenta el momento de vuelco y se reduce la visión. El cucharón no debe cruzar la cabina del camión; la distribución uniforme evita sobrecarga de ejes y caída de bloques durante el transporte.

Secuencia operativa recomendada
• Entrar recto, bajo y sobre firme resistente.
• Llenar sin embestir ni articular con la cuchara enterrada.
• Recoger el material y retroceder mirando la trayectoria.
• Transportar bajo, estable y dentro de capacidad.
• Elevar solo al final y descargar sin pasar sobre cabina ni golpear.

Caso práctico razonado
El material no llena el cucharón en una pasada. Girar la articulación mientras sigue enterrado aumentaría esfuerzos; se retrocede, se realinea y se repite con técnica adecuada.

Errores críticos que deben evitarse
• Elevar temprano para ahorrar tiempo.
• Sacudir violentamente material adherido.
• Concentrar carga en un extremo del vehículo.

Comprobación antes de continuar
• Bastidores alineados
• Carga dentro de nominal
• Cucharón bajo en traslado
• Camión coordinado

Idea clave
La pala gana estabilidad y vida útil cuando el llenado es recto, el traslado bajo y la elevación se limita al punto de descarga.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Excavar y cargar desde una plataforma estable, sin socavar apoyos ni introducir terceros en el radio de giro.

Explicación de base
La excavadora trabaja sobre una plataforma resistente, nivelada y con espacio para el giro. Antes de excavar se identifica la presencia de servicios enterrados y se evalúa el frente o la zanja. El vehículo de transporte se coloca fuera de la zona de caída de material y, cuando sea posible, de forma que la cuchara no pase sobre la cabina. Los movimientos deben ser suaves, evitando giros bruscos con carga máxima y golpes laterales con la cuchara. No se socava la base del terreno que sostiene la máquina. Si el operador pierde visibilidad del camión o de la persona que dirige la maniobra, detiene el ciclo hasta recuperar una comunicación segura.

Profundización técnica y criterio preventivo
Al aumentar el alcance disminuye la capacidad y crece la influencia de terreno y giro. Los servicios enterrados requieren localización, marcado y método de aproximación. Los esfuerzos laterales con la cuchara y los giros bruscos no equivalen a la capacidad de excavación prevista y pueden dañar equipo o desestabilizar la base.

Secuencia operativa recomendada
• Confirmar plataforma, borde, frente y servicios.
• Organizar camión fuera de contrapeso y caída de material.
• Excavar sin socavar la base ni golpear lateralmente.
• Girar suave con carga compatible con radio y configuración.
• Detener al perder visión o comunicación.

Caso práctico razonado
Una zanja se aproxima a la cadena del lado de trabajo. Aunque alcance el fondo, continuar puede quitar apoyo a la propia máquina; se reposiciona sobre terreno evaluado.

Errores críticos que deben evitarse
• Trabajar sobre relleno sin confirmar capacidad.
• Usar la cuchara como martillo lateral.
• Pasar material sobre la cabina.

Comprobación antes de continuar
• Plataforma resistente
• Servicios identificados
• Radio despejado
• Base no socavada

Idea clave
El alcance operativo nunca debe comprarse a costa del apoyo estructural de la máquina.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Operar el tractor de cadenas respetando orientación en pendientes, distancia a bordes y límites del ripado.

Explicación de base
Con el tractor se empuja o ripa manteniendo una trayectoria que preserve la estabilidad. En pendientes se trabaja preferentemente en la dirección definida por el fabricante y por el procedimiento de la explotación, evitando cruzarlas lateralmente o girar bruscamente. La hoja se lleva baja durante los desplazamientos y nunca se utiliza como freno improvisado salvo en una emergencia contemplada. Cerca de un borde, la distancia debe considerar grietas, material suelto y posible rotura del terreno, no solo la posición visible de la coronación. Al ripar se evita enganchar obstáculos desconocidos y se detiene la operación si aparecen vibraciones, pérdida de control o una resistencia superior a la prevista.

Profundización técnica y criterio preventivo
La hoja baja ayuda a controlar el centro de gravedad, pero no convierte un borde débil en resistente. Grietas, humedad y vibración amplían la zona potencial de rotura. En ripado, un obstáculo enterrado puede detener bruscamente el diente y transmitir esfuerzos a máquina y operador.

Secuencia operativa recomendada
• Evaluar pendiente, firme, borde y trayectoria.
• Trabajar en la orientación prescrita y evitar cruce lateral.
• Transportar con hoja baja y giros progresivos.
• Mantener margen respecto a grietas y coronación.
• Detener ante rebote, resistencia o pérdida de control anormal.

Caso práctico razonado
Aparece una grieta paralela a la coronación. La referencia ya no es el borde visible: la zona entre grieta y talud puede desprenderse y se amplía la exclusión hasta evaluación.

Errores críticos que deben evitarse
• Girar bruscamente a media ladera.
• Usar la hoja como freno habitual.
• Forzar el ripper al enganchar un elemento desconocido.

Comprobación antes de continuar
• Orientación autorizada
• Hoja baja
• Borde evaluado
• Ripado sin señales anormales

Idea clave
La distancia a un borde se calcula desde la posible superficie de rotura, no desde la línea que parece firme.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Circular adaptando velocidad, marcha y distancias a la condición más desfavorable del recorrido.

Explicación de base
La velocidad se adapta a la carga, visibilidad, anchura, pendiente, firme y tráfico; el límite indicado es un máximo, no una velocidad obligatoria. En palas, el cucharón se transporta bajo tanto cargado como vacío, dejando altura suficiente para no golpear el terreno. Se respetan sentidos, prioridades y distancias de seguridad de las DIS. En rampas se utiliza la marcha y el sistema de retención recomendados, sin circular en punto muerto. Los adelantamientos solo se realizan donde estén permitidos y exista visibilidad. Antes de cruzar una zona ocupada, se confirma la intención por radio o señalización. Polvo, lluvia, barro o baches obligan a reducir la velocidad o detener la circulación.

Profundización técnica y criterio preventivo
La energía cinética crece con el cuadrado de la velocidad, por lo que una pequeña subida aumenta mucho la distancia de detención. En descenso se selecciona la marcha y retención antes de la rampa; el punto muerto elimina control del tren motriz. Polvo, barro y cruces convierten el límite de velocidad en un máximo no necesariamente seguro.

Secuencia operativa recomendada
• Comprobar ruta, carga, prioridad y estado del firme.
• Llevar equipo bajo con altura de despeje suficiente.
• Seleccionar marcha y retención antes de la pendiente.
• Mantener distancia acorde con visibilidad y frenado.
• Reducir o detener ante polvo, agua, baches o comunicación dudosa.

Caso práctico razonado
El límite es 30 km/h, pero el polvo reduce la visibilidad a pocos metros. Circular a 30 no es cumplir de forma segura; se reduce hasta poder detenerse dentro del campo visible o se suspende el paso.

Errores críticos que deben evitarse
• Descender en punto muerto.
• Tomar el límite como velocidad objetivo.
• Adelantar sin autorización ni campo visual suficiente.

Comprobación antes de continuar
• Ruta y prioridad conocidas
• Equipo bajo
• Marcha elegida antes de rampa
• Distancia de detención disponible

Idea clave
La velocidad correcta es la que permite detener la máquina dentro del espacio visible y libre, aunque sea muy inferior al límite.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Reconocer indicadores de inestabilidad en taludes, frentes, zanjas y bordes y reaccionar antes del fallo.

Explicación de base
El terreno próximo a un talud o una zanja puede fallar sin que el borde aparente se mueva. Se respetan las distancias definidas tras evaluar altura, material, fracturas, humedad, sobrecargas y vibraciones. Nunca se trabaja bajo bloques o viseras sin sanear. En zanjas se identifican servicios, se controla la estabilidad y se aplican entibación, taludes o accesos seguros cuando correspondan. La máquina no debe socavar su propia plataforma. Tras lluvias, voladuras o cambios del frente se repite la inspección. Si aparecen grietas, caída de pequeños fragmentos o deformaciones, se retira el equipo a una zona segura y se informa; continuar para terminar una pasada puede agravar el fallo.

Profundización técnica y criterio preventivo
El terreno falla por geometría, discontinuidades, agua, sobrecarga y vibración. Pequeñas caídas, grietas nuevas o abombamientos son señales precursoras. Tras lluvia o voladura, la evaluación anterior deja de ser suficiente; el equipo se retira fuera del alcance estimado, no solo unos metros.

Secuencia operativa recomendada
• Inspeccionar coronación, pie, grietas, agua y bloques.
• Respetar distancias y saneo definidos.
• Evitar sobrecargar o socavar la plataforma.
• Repetir inspección tras eventos que alteren el terreno.
• Retirar, delimitar y comunicar cualquier indicio de movimiento.

Caso práctico razonado
Caen fragmentos pequeños de una visera sin impactar la máquina. No es un incidente menor: indican pérdida de estabilidad y obligan a salir del alcance y sanear o reevaluar.

Errores críticos que deben evitarse
• Terminar una pasada bajo material suelto.
• Confiar solo en la protección de cabina.
• Mantener distancias antiguas tras lluvia o voladura.

Comprobación antes de continuar
• Sin grietas ni caída de material
• Drenaje controlado
• Distancia vigente
• Plataforma no socavada

Idea clave
Una señal pequeña puede ser el aviso temprano de un fallo grande; la acción segura se toma antes de que el terreno confirme la sospecha.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Descargar sin sobrecargar estructuras, perder control del borde ni exponer personas a material o atascos.

Explicación de base
La descarga exige coordinación y control de la trayectoria del material. Al cargar camiones se evita sobrepasar la capacidad, concentrar todo el peso en un extremo o dejar bloques inestables. En tolvas, la pala se aproxima sobre firme estable, con topes o protecciones adecuados y sin confiar en ellos como freno. No se empuja material mientras haya personas en el punto de vertido. En acopios se controla la pendiente y se evita formar paredes inestables. Si el material queda adherido, no se realizan sacudidas violentas ni golpes improvisados. La limpieza o desatasco se efectúa con el equipo parado, aislado y conforme al procedimiento específico de la instalación.

Profundización técnica y criterio preventivo
El material modifica reparto de masas y puede formar puentes o bloques inestables. Los topes de tolva son referencias, no frenos. Sacudir o golpear para desatascar añade cargas dinámicas no previstas. El desatasco es una intervención con energías mecánicas y gravitatorias que exige aislamiento específico.

Secuencia operativa recomendada
• Confirmar capacidad, firme y zona de vertido despejada.
• Aproximar lentamente sin usar topes como freno.
• Distribuir carga y controlar trayectoria del material.
• Evitar paredes de acopio inestables y derrames.
• Aislar completamente antes de limpiar o desatascar.

Caso práctico razonado
Material húmedo queda adherido al cucharón. En lugar de golpear la tolva o hacer sacudidas bruscas, se aplica el método autorizado y, si requiere intervención, se estaciona y consigna.

Errores críticos que deben evitarse
• Empujar con personas en la descarga.
• Confiar en una berma o tope para detener la máquina.
• Entrar en una tolva sin consignación.

Comprobación antes de continuar
• Capacidad confirmada
• Borde/tope en buen estado
• Personas fuera
• Desatasco bajo procedimiento

Idea clave
Cuando el material no fluye como se esperaba, cambia el riesgo y debe cambiar el método; la violencia no es un procedimiento.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Elevar cargas solo con configuración autorizada, capacidad conocida y accesorios certificados.

Explicación de base
Una pala o excavadora solo puede elevar cargas cuando el fabricante lo permite, el equipo está configurado para esa función y la explotación dispone del procedimiento correspondiente. Deben conocerse la masa, el radio, la altura y la tabla de capacidad, que disminuye al aumentar el alcance. La carga se engancha en puntos previstos con accesorios de elevación certificados; nunca en dientes, cucharas o elementos no diseñados. Se utiliza dispositivo de control de carga cuando sea exigible y se evita el paso sobre personas. Un señalista coordina la maniobra si la visibilidad es limitada. Las cargas se desplazan bajas, lentamente y sin tirones, considerando pendiente, viento y estabilidad del terreno.

Profundización técnica y criterio preventivo
La tabla de carga depende del radio, altura, orientación, contrapeso, apoyo y accesorio. Un pequeño aumento del alcance puede reducir mucho la capacidad. La masa real incluye aparejos y cualquier material adherido. El enganche debe realizarse en punto previsto, nunca en dientes o componentes de retención dudosa.

Secuencia operativa recomendada
• Confirmar que fabricante y explotación permiten elevar.
• Determinar masa total, radio, altura y configuración real.
• Consultar tabla y considerar terreno, pendiente y viento.
• Usar punto y accesorios certificados con señalista cuando proceda.
• Mover bajo, lento, sin tirones y sin personas bajo la carga.

Caso práctico razonado
Una tubería pesa menos que la capacidad máxima anunciada, pero debe colocarse con gran alcance. La capacidad aplicable es la de ese radio y configuración, no la cifra comercial máxima.

Errores críticos que deben evitarse
• Enganchar en un diente.
• Ignorar el peso de eslingas y accesorio.
• Usar la carga nominal de otra configuración.

Comprobación antes de continuar
• Uso autorizado
• Masa total conocida
• Tabla correspondiente
• Accesorios certificados y zona vacía

Idea clave
En elevación, la pregunta no es cuánto levanta la máquina, sino cuánto puede levantar en ese radio, configuración y terreno.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Finalizar el turno dejando la máquina sin energía peligrosa y transmitiendo incidencias de forma trazable.

Explicación de base
Al terminar, la máquina se estaciona en la zona designada, sobre terreno firme y preferentemente horizontal. Se coloca la transmisión en neutro, se acciona el freno, se apoya por completo el equipo y se dejan los mandos sin energía. El enfriamiento y la parada del motor siguen las instrucciones del fabricante, especialmente después de trabajos intensos. Se retira la llave, se cierra la cabina y se colocan calzos cuando el procedimiento lo exija. El relevo recibe información sobre alarmas, golpes, fugas o comportamiento anormal. Una incidencia pendiente debe quedar registrada de forma clara; no basta con comentarla informalmente. Si afecta a la seguridad, la máquina permanece señalizada y fuera de servicio.

Profundización técnica y criterio preventivo
Apoyar el equipo elimina el riesgo de descenso; el freno y los calzos controlan desplazamiento; el enfriamiento protege turbo y sistemas; retirar llave evita uso no autorizado. El relevo debe poder distinguir un defecto pendiente de una observación ya resuelta, por lo que se registra condición, momento y acción adoptada.

Secuencia operativa recomendada
• Elegir zona firme, horizontal y autorizada.
• Neutralizar, frenar y apoyar completamente el equipo.
• Enfriar y detener conforme al fabricante.
• Retirar llave, cerrar y calzar si procede.
• Registrar y comunicar alarmas, daños o comportamiento anormal.

Caso práctico razonado
Una alarma intermitente desaparece al reiniciar. El hecho debe anotarse; borrar el síntoma sin diagnóstico priva al relevo de información y puede permitir la evolución del fallo.

Errores críticos que deben evitarse
• Dejar implemento suspendido.
• Aparcar bloqueando evacuación o tráfico.
• Confiar en un comentario verbal no registrado.

Comprobación antes de continuar
• Equipo apoyado
• Freno/neutralización aplicados
• Llave controlada
• Parte de incidencias completo

Idea clave
El turno termina cuando la máquina queda segura y la información crítica ha sido transferida, no cuando se apaga el motor.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 3 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Interpretar motor, lubricación y refrigeración como sistemas de seguridad y no solo de producción.

Explicación de base
El motor transforma la energía del combustible en movimiento y calor. Su seguridad depende de una correcta lubricación, refrigeración y admisión de aire. El operador vigila presión de aceite, temperatura del refrigerante, nivel de combustible y estado de filtros e indicadores. Una temperatura alta puede deberse a radiadores obstruidos, nivel insuficiente o avería del ventilador; continuar trabajando puede causar incendio o rotura grave. La limpieza del radiador se realiza con el motor parado y medios adecuados, evitando aire o agua a presión que dañen componentes. Los productos calientes se manipulan solo tras enfriamiento y siguiendo el manual. Nunca se elimina una alarma sin haber identificado y corregido su causa.

Profundización técnica y criterio preventivo
La lubricación forma una película que evita contacto metal-metal; la refrigeración extrae calor y mantiene tolerancias. Radiadores obstruidos, ventilador defectuoso o nivel bajo pueden elevar temperatura. Una alarma de presión de aceite exige reducir la energía del fallo: detener conforme al manual, no esperar a que aparezca ruido.

Secuencia operativa recomendada
• Observar presión, temperatura, carga y testigos.
• Comparar tendencia con valores normales del equipo.
• Detener ante alarma crítica según secuencia del fabricante.
• Dejar enfriar antes de abrir o limpiar.
• Investigar causa y usar técnicas de limpieza que no dañen el radiador.

Caso práctico razonado
La temperatura aumenta solo en una zona polvorienta. Aunque baje al ralentí, el patrón sugiere restricción de refrigeración; no se normaliza como consecuencia inevitable del ambiente.

Errores críticos que deben evitarse
• Abrir refrigerante caliente.
• Soplar a presión excesiva deformando aletas.
• Reiniciar repetidamente una alarma de lubricación.

Comprobación antes de continuar
• Presión normal
• Temperatura estable
• Radiadores limpios
• Sin fugas ni avisos

Idea clave
Una tendencia anormal es información preventiva; esperar a una parada total convierte una señal controlable en avería peligrosa.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Comprender transmisión, tracción y articulación para prevenir pérdida de control y atrapamiento.

Explicación de base
La transmisión entrega la potencia a ruedas o cadenas y permite adaptar velocidad y esfuerzo. En una pala articulada, el giro se produce en el bastidor central, creando una zona de aplastamiento que debe bloquearse mecánicamente antes de realizar trabajos entre ambos semibastidores. Diferenciales y sistemas de tracción mejoran la movilidad, pero no compensan un firme sin capacidad ni una pendiente excesiva. El operador debe evitar cambios bruscos de sentido, patinamientos prolongados y esfuerzos que superen las limitaciones del fabricante. En máquinas de cadenas, los giros cerrados aumentan desgaste y pueden desestabilizar sobre terreno irregular. Cualquier tirón, ruido o pérdida de tracción anormal se comunica antes de que evolucione a una avería peligrosa.

Profundización técnica y criterio preventivo
La transmisión multiplica par, pero el agarre disponible sigue limitado por el terreno. El patinamiento prolongado calienta y desgasta componentes sin crear capacidad portante. En palas, el cilindro de dirección puede cerrar la articulación incluso con pequeños movimientos; el bloqueo mecánico es obligatorio para entrar en esa zona.

Secuencia operativa recomendada
• Detectar tirones, ruidos, patinamiento o respuesta desigual.
• Adaptar marcha y esfuerzo al firme.
• Evitar cambios bruscos de sentido y giros cerrados innecesarios.
• Bloquear articulación antes de intervenir entre bastidores.
• Retirar de servicio ante pérdida anormal de tracción o control.

Caso práctico razonado
Una rueda patina sobre relleno blando. Activar más tracción puede hundirla y desestabilizar; se reduce esfuerzo, se detiene y se evalúa el apoyo.

Errores críticos que deben evitarse
• Aumentar potencia sobre terreno que cede.
• Entrar en articulación sin barra de bloqueo.
• Continuar con tirones en transmisión.

Comprobación antes de continuar
• Tracción uniforme
• Sin ruidos/tirones
• Articulación protegida
• Firme con capacidad

Idea clave
La transmisión entrega esfuerzo; no crea estabilidad ni resistencia del suelo.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Controlar energía hidráulica acumulada y reconocer síntomas de fallo que exigen retirada de servicio.

Explicación de base
El sistema hidráulico transmite grandes fuerzas mediante fluido a presión. Incluso con el motor parado puede conservar energía en acumuladores, cilindros o implementos elevados. Por eso, antes de intervenir se apoya el equipo, se descarga la presión según el procedimiento y se bloquean los movimientos posibles. Una fuga fina puede atravesar la piel; no se busca con la mano ni se aprieta una conexión presurizada. Los latiguillos se protegen frente a roce, calor y aplastamiento, y se sustituyen cuando presentan daños. Si un mando responde con retraso, aparecen movimientos espontáneos o baja el equipo sin orden, la máquina se retira de servicio hasta que personal competente revise el circuito.

Profundización técnica y criterio preventivo
Bombas generan caudal y válvulas regulan dirección y presión, pero acumuladores y cargas suspendidas conservan energía tras parar. Un descenso espontáneo puede indicar fuga interna o válvula defectuosa. La inyección hidráulica requiere atención médica urgente aunque la herida parezca pequeña.

Secuencia operativa recomendada
• Apoyar cargas y detener la fuente de presión.
• Accionar mandos según procedimiento para descargar residual.
• Bloquear mecánicamente cualquier parte elevada.
• Buscar fugas con medios indirectos y protección.
• Aislar ante movimientos lentos, retardados o espontáneos.

Caso práctico razonado
La pluma desciende lentamente con el mando neutro. No se compensa corrigiendo periódicamente: se inmoviliza porque el defecto puede progresar y revela pérdida de retención.

Errores críticos que deben evitarse
• Buscar fuga con la mano.
• Aflojar conexión presurizada.
• Confiar en válvulas para permanecer bajo el equipo.

Comprobación antes de continuar
• Equipo apoyado
• Presión residual descargada
• Sin descenso espontáneo
• Latiguillos íntegros

Idea clave
Un movimiento no ordenado, por lento que sea, demuestra que la energía no está bajo control.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Evaluar cómo cada accesorio modifica capacidad, estabilidad, visibilidad y solicitaciones.

Explicación de base
Cada accesorio cambia la geometría y las prestaciones de la máquina. Una cuchara de mayor volumen puede superar la carga admisible con materiales densos; unas horquillas desplazan el centro de gravedad; y un martillo introduce vibraciones y proyecciones. Antes de utilizarlo se comprueban compatibilidad, peso, presión y caudal requeridos, dispositivos de retención y limitaciones del manual. La tabla de carga debe corresponder a la configuración real, incluyendo contrapeso, pluma y accesorio. El operador no emplea el equipo para funciones no previstas, como empujar lateralmente con una cuchara o izar desde un punto improvisado. Si cambia el material o el alcance, se vuelve a evaluar la capacidad y estabilidad.

Profundización técnica y criterio preventivo
El volumen del cucharón no determina la masa: un material más denso puede superar carga. Horquillas llevan el centro de gravedad hacia delante; martillos añaden vibración y caudal; extensiones cambian el radio. La tabla aplicable debe corresponder al conjunto real y a su punto de carga.

Secuencia operativa recomendada
• Verificar homologación/compatibilidad y límites.
• Identificar masa del accesorio y material.
• Comprobar presión, caudal, retención y contrapeso.
• Usar la tabla de carga de la configuración real.
• Reevaluar ante cambio de material, alcance o herramienta.

Caso práctico razonado
Una cuchara de gran volumen trabajó con material ligero sin problemas; al cargar mineral más denso, el mismo llenado puede superar masa admisible. Se reduce volumen efectivo según densidad.

Errores críticos que deben evitarse
• Equiparar volumen con carga segura.
• Empujar lateralmente con herramienta no prevista.
• Usar tabla de la cuchara estándar.

Comprobación antes de continuar
• Accesorio autorizado
• Densidad/masa consideradas
• Tabla correcta
• Retención comprobada

Idea clave
La capacidad se evalúa en masa y momento, no por la apariencia o el volumen del accesorio.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Relacionar neumáticos y cadenas con frenado, dirección, presión sobre el suelo y estabilidad.

Explicación de base
Los neumáticos y el tren de rodaje son el único contacto de la máquina con el terreno. Su estado condiciona dirección, frenado, tracción y estabilidad. En palas, una presión incorrecta o un corte puede provocar pérdida de control y calentamiento. En excavadoras y tractores, la acumulación de barro o piedras, el desgaste desigual y la tensión incorrecta afectan la marcha y aumentan el riesgo de salida de cadena. El operador debe reconocer los límites de presión sobre el suelo: una máquina pesada puede hundirse aunque la superficie parezca firme. Antes de trabajar sobre rellenos, bordes o plataformas recientes se confirma su capacidad portante y se evita concentrar cargas cerca de zonas debilitadas.

Profundización técnica y criterio preventivo
La capacidad portante no se deduce por aspecto superficial: una costra seca puede ocultar relleno saturado. La presión sobre el suelo se concentra cerca de bordes y cambia con carga y giro. Desgaste desigual o tensión incorrecta altera guiado y puede anunciar desalineación.

Secuencia operativa recomendada
• Inspeccionar estado y desgaste en todo el perímetro.
• Comprobar presión/tensión por procedimiento.
• Limpiar acumulaciones con máquina segura.
• Confirmar capacidad del terreno antes de entrar.
• Evitar bordes, rellenos y apoyos puntuales no evaluados.

Caso práctico razonado
Una plataforma parece seca, pero ha sido rellenada recientemente. La ausencia de huellas no acredita compactación; se confirma capacidad antes de apoyar una excavadora pesada.

Errores críticos que deben evitarse
• Usar una pasada de prueba como ensayo geotécnico.
• Circular con desgaste desigual acusado.
• Concentrar carga cerca de coronación.

Comprobación antes de continuar
• Contacto en buen estado
• Presión/tensión correcta
• Terreno evaluado
• Sin acumulaciones

Idea clave
El tren de rodaje solo es seguro si tanto sus componentes como el suelo que los sostiene conservan capacidad.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Distinguir funciones de frenado, dirección y bloqueo, y responder correctamente ante degradación.

Explicación de base
La pala dispone de freno de servicio, estacionamiento y, según su diseño, sistema de emergencia. Todos cumplen funciones diferentes y deben probarse conforme al manual. La dirección principal y la de emergencia permiten conservar el control, pero esta última no autoriza a continuar la producción tras una avería. En la excavadora, el control de giro y los bloqueos hidráulicos evitan movimientos no deseados. El operador debe saber qué ocurre si se pierde presión, se para el motor o falla un circuito. Nunca se utiliza una pendiente para probar frenos. Si la respuesta cambia, aumenta el recorrido del pedal o aparece una alarma, se estaciona en un lugar seguro y se solicita revisión.

Profundización técnica y criterio preventivo
Freno de servicio detiene durante circulación; estacionamiento inmoviliza; emergencia controla una pérdida prevista. La dirección de emergencia permite llevar el equipo a condición segura, no completar producción. Probar en pendiente convierte una comprobación en exposición; las pruebas se hacen en zona plana y despejada.

Secuencia operativa recomendada
• Identificar función y testigo de cada sistema.
• Probar en zona segura según manual.
• Observar recorrido, respuesta, desvío y alarmas.
• Ante degradación, reducir movimiento y estacionar seguro.
• Solicitar revisión; no usar sistemas de emergencia como normales.

Caso práctico razonado
La dirección principal falla y la de emergencia responde. Se utiliza solo para retirar la máquina de la trayectoria inmediata y detenerla, no para terminar el ciclo de carga.

Errores críticos que deben evitarse
• Probar freno en rampa.
• Usar estacionamiento para frenar habitualmente.
• Continuar con dirección de emergencia.

Comprobación antes de continuar
• Servicio probado
• Estacionamiento retiene
• Dirección normal
• Sin alarmas ni recorrido anormal

Idea clave
Un sistema de emergencia conserva una salida controlada; no restablece la aptitud productiva de la máquina.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Entender la protección ROPS/FOPS como un conjunto estructural que requiere integridad y cinturón.

Explicación de base
Las estructuras ROPS protegen el espacio del operador en caso de vuelco y las FOPS frente a caída de objetos, dentro de las condiciones para las que fueron diseñadas. No deben perforarse, soldarse ni modificarse sin autorización técnica, porque una alteración puede reducir su resistencia. Puertas, cristales y anclajes forman parte del conjunto de protección. El cinturón mantiene al operador dentro de ese volumen seguro y debe utilizarse siempre que la máquina se desplace o trabaje. Saltar de una máquina que vuelca suele exponer al aplastamiento. Después de un vuelco, impacto importante o daño visible, la estructura requiere evaluación; no basta con enderezar una parte deformada y volver al servicio.

Profundización técnica y criterio preventivo
ROPS preserva un volumen de supervivencia ante vuelco; FOPS resiste impactos definidos, no cualquier desprendimiento. Soldar, perforar o enderezar puede alterar material y concentrar tensiones. Puertas y anclajes también forman parte del entorno protegido. Tras impacto se requiere evaluación técnica.

Secuencia operativa recomendada
• Inspeccionar deformaciones, corrosión, fijaciones y cristales.
• No perforar ni soldar sin autorización.
• Mantener puertas y salida de emergencia operativas.
• Ajustar y usar cinturón en todo movimiento.
• Retirar de servicio tras vuelco o daño significativo.

Caso práctico razonado
Tras un golpe, un montante presenta una pequeña deformación y la puerta cierra. El funcionamiento de la puerta no certifica resistencia; la estructura se evalúa antes de volver.

Errores críticos que deben evitarse
• Enderezar localmente sin cálculo.
• Trabajar sin cinturón.
• Confiar en FOPS bajo un frente no saneado.

Comprobación antes de continuar
• Estructura íntegra
• Anclajes sin daño
• Cinturón operativo
• Salida disponible

Idea clave
La estructura protege dentro de su diseño solo si no se modifica y el operador permanece sujeto en el volumen seguro.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Seleccionar bloqueos y resguardos según el movimiento y la energía concreta que deben impedir.

Explicación de base
Los bloqueos mecánicos del equipo, bastidor articulado o superestructura evitan movimientos causados por pérdida de presión, accionamiento involuntario o gravedad. Los bloqueos de mandos y transmisión reducen el riesgo de puesta en movimiento inesperada. Los resguardos separan a las personas de correas, ventiladores y elementos giratorios. Ninguno debe anularse para ganar tiempo o facilitar una comprobación. Antes de trabajar en una zona peligrosa se identifica qué energía puede mover cada componente y se instala el dispositivo previsto, no una pieza improvisada. Al finalizar, se comprueba que herramientas, soportes y personas estén fuera antes de retirar bloqueos y devolver la máquina a servicio.

Profundización técnica y criterio preventivo
Un bloqueo debe resistir la carga previsible y colocarse en el punto diseñado. Resguardos evitan contacto con piezas giratorias, pero retirarlos puede además alterar ventilación o contención. Antes de liberar bloqueos se hace recuento de personas, útiles y soportes y se comunica la energización.

Secuencia operativa recomendada
• Identificar cada movimiento potencial y su fuente.
• Parar, aislar y descargar energía.
• Instalar bloqueo específico, nunca improvisado.
• Mantener resguardos hasta que el procedimiento requiera retirarlos.
• Verificar zona libre antes de restitución y prueba.

Caso práctico razonado
Un técnico propone una viga de madera para sostener el cucharón. Aunque parezca robusta, no tiene capacidad ni encaje certificados; se usa el soporte específico o se apoya el equipo.

Errores críticos que deben evitarse
• Anular enclavamientos.
• Usar soportes improvisados.
• Retirar bloqueo sin confirmar presencia de personas.

Comprobación antes de continuar
• Movimiento identificado
• Bloqueo correcto
• Resguardos restituidos
• Zona libre antes de energizar

Idea clave
El bloqueo seguro es específico, verificable y dimensionado; la improvisación no demuestra capacidad.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Interpretar instrumentos y alarmas y diferenciar ayudas de aviso de medidas de control del área.

Explicación de base
Manómetros, termómetros, indicadores de nivel y paneles de alarma informan del estado de los sistemas principales. El operador debe conocer la lectura normal, las zonas de advertencia y la acción requerida, porque dos alarmas parecidas pueden exigir respuestas distintas. Bocina, alarma de retroceso, luces, rotativos, cámaras y espejos ayudan a comunicar el movimiento y ampliar la visión. No sustituyen una zona despejada ni una maniobra controlada. Si un indicador es ilegible o un aviso no funciona, se valora si la máquina puede utilizarse conforme al manual y al procedimiento. Tapar una luz o desconectar una alarma elimina información esencial y puede ocultar un fallo progresivo.

Profundización técnica y criterio preventivo
Los valores deben leerse como tendencia y dentro de rangos. Una alarma puede ser informativa, de advertencia o de parada; el manual define respuesta. Bocina, rotativo y retroceso comunican intención, pero no comprueban que la persona haya salido. Tapar un aviso elimina una barrera y rompe la trazabilidad del fallo.

Secuencia operativa recomendada
• Conocer lectura normal y prioridad de avisos.
• Comprobar autodiagnóstico y legibilidad.
• Responder con la acción prescrita, no por costumbre.
• Verificar ayudas de visibilidad y señalización.
• Detener si el aviso esencial no funciona y no existe medida autorizada.

Caso práctico razonado
Un testigo molesto aparece de forma intermitente. Cubrirlo impide ver cuándo cambia a estado crítico; se registra el patrón y se diagnostica.

Errores críticos que deben evitarse
• Desconectar zumbador.
• Confiar en alarma para mover con zona ocupada.
• Interpretar por color sin consultar significado del modelo.

Comprobación antes de continuar
• Instrumentos legibles
• Rangos conocidos
• Avisos operativos
• Respuesta prescrita disponible

Idea clave
Una alarma no es el fallo: es información para reducir sus consecuencias; eliminarla aumenta incertidumbre.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar el manual del fabricante y el RD 1215/1997 a la configuración real y al estado efectivo del equipo.

Explicación de base
El manual de instrucciones define el uso previsto, capacidades, mantenimiento, advertencias y procedimientos de emergencia de cada modelo. Debe estar disponible y ser comprensible para el operador. Las máquinas puestas a disposición de los trabajadores deben cumplir las disposiciones aplicables del Real Decreto 1215/1997, incluyendo mandos seguros, protección frente a vuelco o caída de objetos, frenado, visibilidad y prevención del acceso a partes peligrosas. Una adecuación documental no sustituye el buen estado real del equipo. Si la configuración se modifica o se incorpora un accesorio, debe evaluarse cómo afecta a los riesgos. Ante una contradicción, prevalecen las limitaciones más seguras y se consulta al responsable técnico.

Profundización técnica y criterio preventivo
El RD establece requisitos mínimos de uso seguro, mientras el manual concreta capacidades, mandos, mantenimiento y emergencias del modelo. Un certificado o adecuación histórica no prueba que frenos, protecciones y avisos sigan funcionando. Las modificaciones requieren evaluar nuevos riesgos y actualizar documentación e instrucciones.

Secuencia operativa recomendada
• Disponer del manual comprensible y de la configuración exacta.
• Contrastar uso previsto, capacidades y advertencias.
• Verificar físicamente requisitos de mando, frenado y protección.
• Evaluar modificaciones y accesorios antes de usar.
• Aplicar la limitación más segura y consultar ante contradicción.

Caso práctico razonado
Una empresa añade un accesorio compatible mecánicamente pero sin evaluación de estabilidad. La declaración original de la máquina no cubre automáticamente el nuevo conjunto.

Errores críticos que deben evitarse
• Considerar suficiente un documento antiguo.
• Usar un manual de modelo parecido.
• Modificar sistemas sin reevaluación.

Comprobación antes de continuar
• Manual exacto disponible
• Uso previsto respetado
• Estado real comprobado
• Modificaciones evaluadas

Idea clave
La conformidad documental debe coincidir con la máquina real, su accesorio actual y su estado de mantenimiento.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 4 and seg.position = 10;
update public.lesson_segment_slides s set body = $b$Objetivo
Mantener vigilancia geotécnica operativa y repetirla cuando cambien las condiciones del terreno.

Explicación de base
El lugar de trabajo cambia durante la jornada. El operador observa el frente, la plataforma, las coronaciones y el pie de los taludes antes y durante la operación. Grietas, bloques sueltos, agua, deformaciones, material recién volado o pérdida de visibilidad pueden modificar el riesgo. La inspección debe repetirse después de lluvia intensa, heladas, voladuras o trabajos que alteren el terreno. La cabina no protege frente a todos los desprendimientos y nunca justifica trabajar bajo una zona sin sanear. Si existe duda sobre la estabilidad, la máquina se retira fuera del alcance posible y se solicita evaluación. La continuidad de la producción no debe anteponerse a una señal de inestabilidad.

Profundización técnica y criterio preventivo
El operador no sustituye al técnico geotécnico, pero detecta indicadores visibles: grietas, agua, abombamiento, caída de finos, bloques y cambios de drenaje. Tras lluvia, helada o voladura, el alcance potencial puede aumentar; la retirada debe situar la máquina fuera de la zona de impacto estimada.

Secuencia operativa recomendada
• Observar frente, coronación, pie, plataforma y drenajes.
• Comparar con el estado anterior y registrar cambios.
• Reinspeccionar tras lluvia, helada, voladura o excavación.
• Retirar fuera del alcance ante cualquier señal.
• Solicitar saneo/evaluación y nueva autorización.

Caso práctico razonado
Tras lluvia, una zona mantiene aspecto estable pero aparece agua turbia en el pie. Puede indicar circulación interna y arrastre de finos; se comunica y se reevalúa antes de acercarse.

Errores críticos que deben evitarse
• Confiar en la cabina ante grandes desprendimientos.
• Acercarse para inspeccionar desde la máquina.
• Esperar a ver movimiento evidente.

Comprobación antes de continuar
• Sin grietas/bloques
• Drenaje sin cambios
• Plataforma estable
• Inspección vigente

Idea clave
La vigilancia busca cambios respecto del estado conocido; una señal indirecta de agua puede ser tan relevante como una grieta.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 1;
update public.lesson_segment_slides s set body = $b$Objetivo
Evaluar pistas como infraestructura de seguridad, considerando firme, drenaje, visibilidad, bermas y polvo.

Explicación de base
Las pistas deben mantener anchura, pendiente, firme, visibilidad y drenaje compatibles con los equipos que circulan. Baches, roderas, barro, polvo y acumulaciones en los bordes reducen el control y ocultan obstáculos. Las bermas ayudan a delimitar y contener, pero no son un sistema de frenado ni garantizan que el borde soporte una máquina. El riego y otras medidas de control del polvo deben aplicarse sin crear superficies deslizantes. El operador informa de deterioros, señaliza cuando sea posible y adapta la velocidad. Si una pista no permite circular con seguridad, se detiene su uso hasta corregirla, en lugar de confiar en la experiencia individual para superar una condición deficiente.

Profundización técnica y criterio preventivo
La berma reduce consecuencias y marca borde, pero puede ceder y no debe usarse como guía de contacto. El riego reduce polvo, aunque un exceso baja adherencia. Baches y roderas aumentan cargas dinámicas y pueden hacer perder material. El operador informa y adapta; si el defecto supera el control mediante velocidad, se cierra la vía.

Secuencia operativa recomendada
• Revisar anchura, pendientes, firme, drenaje y visibilidad.
• Comprobar bermas, señalización y cruces.
• Adaptar riego sin crear barro o deslizamiento.
• Reducir velocidad y comunicar deterioros.
• Suspender circulación si no puede mantenerse control.

Caso práctico razonado
El riego elimina polvo pero forma una película deslizante en la rampa. La medida ambiental ha generado un riesgo de tráfico y debe ajustarse antes de continuar.

Errores críticos que deben evitarse
• Rozar la berma para guiarse.
• Mantener velocidad sobre baches.
• Regar sin vigilar adherencia y drenaje.

Comprobación antes de continuar
• Firme estable
• Visibilidad suficiente
• Berma íntegra
• Riego compatible con adherencia

Idea clave
Una medida correcta puede crear un riesgo secundario; el control debe comprobar el resultado real, no solo la acción ejecutada.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 2;
update public.lesson_segment_slides s set body = $b$Objetivo
Coordinar pala y camión mediante posiciones, señales y secuencias que eliminen trayectorias simultáneas incompatibles.

Explicación de base
La carga de un camión combina dos equipos con zonas ciegas y trayectorias distintas. El punto de espera, la aproximación y la salida deben estar definidos. El camión no entra en la zona hasta recibir autorización y la pala no inicia el ciclo hasta confirmar que está correctamente posicionado. Se evita pasar el cucharón sobre la cabina y se distribuye el material sin golpes. Ningún conductor abandona su puesto salvo que el procedimiento establezca una zona protegida. Las comunicaciones se realizan mediante señales o radio conocidas por ambos. Si aparece una persona, se pierde contacto visual o un vehículo cambia de posición sin aviso, la operación se detiene y se restablece la coordinación.

Profundización técnica y criterio preventivo
Ambos equipos tienen puntos ciegos. El punto de espera evita que el camión invada el ciclo de la pala; la autorización confirma que el operador lo ha identificado. El conductor no abandona una zona protegida sin regla expresa y la pala no pasa carga sobre cabina ni usa golpes como comunicación.

Secuencia operativa recomendada
• Definir espera, entrada, carga y salida.
• Autorizar entrada cuando la pala esté en posición segura.
• Confirmar inmovilización y ubicación del conductor.
• Cargar sin sobrepasar cabina, capacidad ni distribución.
• Dar señal de salida y detener ante cualquier cambio no acordado.

Caso práctico razonado
El camión avanza unos centímetros para repartir carga sin aviso. La pala detiene el cucharón y restablece la secuencia; no intenta corregir su trayectoria durante el movimiento simultáneo.

Errores críticos que deben evitarse
• Entrada por iniciativa del conductor.
• Conductor a pie en zona no protegida.
• Golpear caja para dar señales.

Comprobación antes de continuar
• Punto de espera claro
• Autorización confirmada
• Conductor ubicado
• Salida ordenada

Idea clave
La coordinación segura elimina decisiones simultáneas: cada movimiento comienza tras una autorización inequívoca.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 3;
update public.lesson_segment_slides s set body = $b$Objetivo
Organizar excavadora y transporte evitando radio de contrapeso, paso sobre cabina y caída desde frente o cota.

Explicación de base
La excavadora necesita un radio de giro despejado y un punto estable para el camión. La colocación se elige para reducir el giro, evitar que la cuchara pase sobre la cabina y mantener el vehículo fuera del alcance de una posible caída del frente. El conductor permanece donde establezca el procedimiento y no mueve el camión hasta recibir la señal. La excavadora no utiliza la cuchara para empujar, retener o avisar al vehículo mediante golpes. Cuando el terreno obliga a trabajar a diferente cota, se evalúan el borde, el alcance y la caída del material. Una única persona dirige la maniobra y cualquier pérdida de comunicación implica parada inmediata.

Profundización técnica y criterio preventivo
La colocación eficiente reduce el ángulo de giro, pero nunca debe acercar el camión a un borde o al frente inestable. Diferencias de cota alteran trayectoria de caída y alcance. La cuchara no es un medio para empujar o retener vehículos; una persona designada controla la secuencia.

Secuencia operativa recomendada
• Evaluar plataforma, frente, cota y radio de giro.
• Definir posición y punto de espera del camión.
• Mantener cabina fuera de la trayectoria de cuchara.
• Coordinar inmovilización, carga y salida con una señal única.
• Parar al perder visión o cambiar la posición.

Caso práctico razonado
Para acortar el ciclo se propone colocar el camión junto al pie de un frente. El menor giro no compensa el riesgo de caída de material; se selecciona una posición protegida.

Errores críticos que deben evitarse
• Empujar el camión con la cuchara.
• Aceptar posición bajo un frente.
• Permitir varios señalistas.

Comprobación antes de continuar
• Radio libre
• Camión fuera de caída
• Cabina no sobrevolada
• Mando único

Idea clave
La posición óptima es la que reduce exposición total, no necesariamente la que minimiza segundos de giro.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 4;
update public.lesson_segment_slides s set body = $b$Objetivo
Proteger al personal de tierra con segregación, contacto positivo y un único sistema de señales.

Explicación de base
Las personas a pie son especialmente vulnerables frente a maquinaria móvil. Las rutas peatonales, zonas de exclusión y puntos de acceso deben estar definidos y señalizados. Para aproximarse a una máquina se establece contacto con el operador, se espera su confirmación y solo se entra cuando el equipo está inmovilizado. El señalista utiliza señales acordadas, se mantiene visible y nunca se coloca entre la máquina y un obstáculo. La radio debe emplear mensajes breves, identificando equipo, lugar e instrucción; ante una duda se repite la orden. El operador no actúa basándose en gestos ambiguos. Si varias personas dan instrucciones, se detiene el trabajo hasta designar un único interlocutor.

Profundización técnica y criterio preventivo
El contacto visual del peatón no garantiza que el operador lo haya visto. La aproximación requiere confirmación bidireccional y equipo inmovilizado. El señalista se coloca fuera de atrapamientos, mantiene escape y usa mensajes que identifican máquina, lugar y acción. Una orden ambigua se rechaza y se repite.

Secuencia operativa recomendada
• Definir rutas peatonales y zonas de exclusión.
• Establecer contacto y esperar confirmación antes de entrar.
• Inmovilizar el equipo para aproximaciones autorizadas.
• Designar un único señalista visible y protegido.
• Detener ante señal dudosa, pérdida de contacto o múltiples órdenes.

Caso práctico razonado
Dos personas hacen gestos distintos. El operador no elige la señal que parece lógica: para y exige un único interlocutor antes de mover.

Errores críticos que deben evitarse
• Acercarse por detrás tras tocar la bocina.
• Señalista entre máquina y pared.
• Mensajes de radio sin identificar equipo.

Comprobación antes de continuar
• Ruta segregada
• Contacto bidireccional
• Señalista visible
• Una sola autoridad

Idea clave
Una comunicación segura no se presume: se confirma por ambas partes y mantiene una regla automática de parada ante duda.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 5;
update public.lesson_segment_slides s set body = $b$Objetivo
Prevenir contacto y arco eléctrico considerando todas las posiciones posibles de máquina, carga y terreno.

Explicación de base
Una línea aérea puede producir arco eléctrico sin contacto directo. Antes de trabajar se identifica su tensión, altura, recorrido y zona de seguridad, aplicando las distancias y medidas definidas por la normativa y el procedimiento específico. La explotación debe señalizar la aproximación -el material del curso utiliza aviso previo de veinticinco metros- y puede requerir pórticos, limitadores, vigilancia o desenergización. Se consideran todas las posiciones de pluma, cuchara, hoja y carga, así como el balanceo y las irregularidades del terreno. Si una máquina entra en contacto, el operador permanece en la cabina salvo incendio u otro peligro inmediato y se sigue el plan de emergencia para evitar tensiones de paso.

Profundización técnica y criterio preventivo
La electricidad puede saltar sin contacto y generar tensiones de paso alrededor de la máquina. La distancia debe determinarse según tensión y procedimiento, no por estimación visual. La señal previa de 25 m citada en el material es un aviso de aproximación, no la distancia eléctrica de seguridad.

Secuencia operativa recomendada
• Identificar línea, tensión, altura y recorrido.
• Definir distancia de seguridad y medidas específicas.
• Instalar señal previa, pórticos, limitadores o vigilancia si procede.
• Considerar pluma, carga, balanceo y desniveles en peor posición.
• En contacto, permanecer en cabina y activar emergencia salvo peligro inmediato.

Caso práctico razonado
La pluma pasa por debajo en posición recogida, pero al descargar podría elevarse y entrar en zona peligrosa. La evaluación usa la envolvente completa de movimientos, no la posición de tránsito.

Errores críticos que deben evitarse
• Confundir aviso de 25 m con distancia eléctrica.
• Medir a ojo desde cabina.
• Bajar de la máquina tras contacto sin necesidad inmediata.

Comprobación antes de continuar
• Tensión conocida
• Distancia definida
• Envolvente completa evaluada
• Plan de contacto conocido

Idea clave
La distancia se aplica al punto de la máquina o carga que más pueda acercarse, incluida oscilación y terreno irregular.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 6;
update public.lesson_segment_slides s set body = $b$Objetivo
Coordinar producción y mantenimiento mediante consignación compartida, mando definido y entrega formal.

Explicación de base
Las reparaciones generan riesgos diferentes a la producción: equipos elevados, pruebas con motor en marcha, presencia de técnicos y energías liberadas. Antes de intervenir, operador y mantenimiento acuerdan quién controla la máquina, qué sistemas quedan aislados y cuándo puede retirarse cada bloqueo. La llave y los dispositivos de consignación no se entregan ni se eliminan sin autorización. Si una prueba requiere movimiento, la zona se delimita, se restablecen resguardos necesarios y una persona coordina la operación. Nadie permanece en la articulación, bajo un implemento o dentro del radio de giro sin protección física adecuada. Tras la reparación se realiza una entrega formal e inspección funcional antes de volver a producir.

Profundización técnica y criterio preventivo
Durante reparación cambian roles y pueden coexistir energías aisladas con pruebas necesarias. Cada bloqueo personal se retira por su titular o por procedimiento excepcional controlado. Si una prueba exige movimiento, se restablece una zona de exclusión y una sola persona autoriza energización y parada.

Secuencia operativa recomendada
• Acordar alcance, responsable y estado de la máquina.
• Identificar, aislar y bloquear todas las energías.
• Delimitar zonas de articulación, giro y equipos elevados.
• Planificar pruebas con mando único y área vacía.
• Realizar inspección funcional y entrega documentada.

Caso práctico razonado
El técnico termina pero no está presente para retirar su candado. El operador no lo corta por indicación verbal; se aplica el procedimiento excepcional autorizado.

Errores críticos que deben evitarse
• Compartir una llave de consignación.
• Probar con personas en radio.
• Volver a producción sin entrega formal.

Comprobación antes de continuar
• Responsable designado
• Bloqueos personales controlados
• Prueba delimitada
• Entrega registrada

Idea clave
La consignación protege también la autoridad de cada interviniente; nadie elimina la barrera de otro por conveniencia.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 7;
update public.lesson_segment_slides s set body = $b$Objetivo
Aplicar PAS y usar medios de extinción o auxilio sin generar nuevas víctimas.

Explicación de base
Ante un accidente se aplica la conducta PAS: proteger, avisar y socorrer. Primero se evita que la máquina, el tráfico, la electricidad o el terreno provoquen nuevas víctimas; después se activa el sistema de emergencia con información precisa; y solo se presta ayuda dentro de la propia formación. En un incendio incipiente puede utilizarse el extintor si existe vía de escape y no se asume un riesgo adicional. Se detiene el motor cuando sea seguro y se abandona por la ruta prevista. No se mueve a una persona lesionada salvo peligro inmediato. Toda máquina debe permitir localizar con rapidez extintor, botiquín, salida alternativa y medios de comunicación.

Profundización técnica y criterio preventivo
Proteger precede a socorrer porque tráfico, energía, fuego o terreno pueden multiplicar daños. El aviso debe incluir ubicación, acceso, número de afectados y riesgos activos. Un extintor se usa solo en fase incipiente, con agente adecuado y vía de escape; la prioridad es evacuar si el incendio supera el control inicial.

Secuencia operativa recomendada
• Detener o aislar peligros sin exponerse.
• Avisar con información precisa y confirmar recepción.
• Socorrer dentro de la formación y sin mover salvo peligro inmediato.
• Usar extintor solo con salida segura y fuego incipiente.
• Guiar ayudas y conservar acceso libre.

Caso práctico razonado
Arde el compartimento motor y el fuego crece pese a un intento. No se abre de golpe una tapa ni se agotan extintores sin salida: se evacua, se amplía aislamiento y se avisa.

Errores críticos que deben evitarse
• Correr hacia la víctima sin controlar tráfico.
• Mover a un lesionado sin peligro inmediato.
• Combatir un fuego sin vía de escape.

Comprobación antes de continuar
• Zona protegida
• Aviso completo
• Auxilio dentro de competencia
• Escape disponible

Idea clave
Ayudar de forma segura significa evitar una segunda víctima y activar pronto recursos adecuados.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 8;
update public.lesson_segment_slides s set body = $b$Objetivo
Ejecutar una evacuación ordenada y convertir simulacros e incidentes en mejora preventiva.

Explicación de base
El plan de emergencia define alarmas, responsables, comunicaciones, vías de evacuación y puntos de reunión. El operador debe conocer cómo dejar la máquina sin crear un obstáculo, qué hacer si una pista queda bloqueada y cómo informar de su ubicación. En una evacuación no se improvisan rutas a través de frentes, taludes o zonas de tráfico. Los simulacros permiten comprobar tiempos, cobertura de radio y acceso de los servicios de ayuda. Después de cualquier incidente se conserva la escena cuando sea seguro, se informa y se colabora en la investigación. El objetivo no es buscar culpables, sino identificar fallos técnicos u organizativos y evitar que la situación se repita.

Profundización técnica y criterio preventivo
El plan asigna alarmas, rutas, reunión y responsables. La máquina debe quedar sin bloquear vías y, si existe tiempo seguro, con implemento apoyado. Los simulacros validan cobertura de radio y acceso de emergencias. La investigación conserva evidencias y analiza barreras técnicas y organizativas, no solo conducta individual.

Secuencia operativa recomendada
• Reconocer alarma y confirmar instrucción.
• Dejar equipo en condición segura sin obstaculizar.
• Seguir ruta autorizada al punto de reunión.
• Comunicar ubicación y no regresar sin autorización.
• Tras el evento, preservar escena y participar en investigación.

Caso práctico razonado
La ruta habitual queda bloqueada por un desprendimiento. No se improvisa un paso bajo otro talud; se usa la alternativa del plan y se comunica el bloqueo.

Errores críticos que deben evitarse
• Usar atajos por frentes.
• Mover evidencias innecesariamente.
• Abandonar el punto de reunión sin control.

Comprobación antes de continuar
• Alarma conocida
• Ruta alternativa prevista
• Punto de reunión alcanzado
• Ubicación comunicada

Idea clave
La evacuación eficaz se decide antes de la emergencia y se valida mediante simulacro; improvisar rutas añade exposición.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 9;
update public.lesson_segment_slides s set body = $b$Objetivo
Relacionar el marco normativo con obligaciones concretas de empresa y operador.

Explicación de base
Esta formación se encuadra en la ITC 02.1.02 y en la Especificación Técnica 2001-1-08 para operadores de maquinaria de arranque, carga y viales. Se relaciona además con la Ley 31/1995, el Real Decreto 1215/1997 sobre equipos de trabajo, el Real Decreto 1389/1997 para actividades mineras y las normas de coordinación empresarial. La formación inicial tiene veinte horas y la frecuencia máxima obligatoria indicada por la especificación es de dos años. El empresario debe proporcionar equipos seguros, información, formación y organización preventiva. El trabajador debe utilizar correctamente la máquina, los dispositivos y los EPI, respetar las DIS y comunicar de inmediato cualquier situación que pueda suponer un riesgo grave.

Profundización técnica y criterio preventivo
La formación específica se integra con evaluación, equipos adecuados, DIS, información y supervisión; por sí sola no autoriza cualquier trabajo. El trabajador usa correctamente, no anula protecciones y comunica riesgo grave. La frecuencia máxima de actualización indicada por la ET es de dos años, sin impedir formación adicional cuando cambien equipo o condiciones.

Secuencia operativa recomendada
• Verificar formación y autorización para puesto/equipo.
• Aplicar ITC, ET, RD 1215, RD 1389 y DIS pertinentes.
• Exigir equipo seguro, información y coordinación.
• Usar dispositivos y EPI conforme a instrucciones.
• Comunicar riesgo grave y actualizar formación cuando proceda.

Caso práctico razonado
Un operador está dentro del plazo bienal, pero cambia a un modelo con mandos y emergencias diferentes. El plazo no sustituye la familiarización e información específica antes de usarlo.

Errores críticos que deben evitarse
• Tomar el certificado como autorización universal.
• Esperar dos años pese a cambios relevantes.
• Aceptar órdenes contrarias a dispositivos de seguridad.

Comprobación antes de continuar
• Formación vigente
• Autorización específica
• DIS conocidas
• Cambios cubiertos

Idea clave
Cumplir el plazo formativo es una condición, no toda la competencia: el equipo, la tarea y el centro reales deben estar cubiertos.$b$, updated_at = now() from public.lesson_audio_segments seg join public.lessons l on l.id = seg.lesson_id join public.course_modules m on m.id = l.module_id where s.segment_id = seg.id and m.course_version_id = '406c3a42-426e-4d05-90d9-27b484f7a799' and m.position = 5 and seg.position = 10;

do $val$
declare
  version_id constant uuid := '406c3a42-426e-4d05-90d9-27b484f7a799';
  fallos integer;
begin
  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 2 and 5;
  if fallos <> 40 then
    raise exception 'Los bloques 2 a 5 de arranque 20 h deben tener 40 diapositivas y tienen %', fallos;
  end if;

  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position between 2 and 5
     and (
       length(s.body) < 1500
       or s.body not like 'Objetivo%'
       or s.body not like '%Explicación de base%'
       or s.body not like '%Profundización técnica y criterio preventivo%'
       or s.body not like '%Secuencia operativa recomendada%'
       or s.body not like '%Caso práctico razonado%'
       or s.body not like '%Errores críticos que deben evitarse%'
       or s.body not like '%Comprobación antes de continuar%'
       or s.body not like '%Idea clave%'
     );
  if fallos > 0 then
    raise exception '% partes de los bloques 2 a 5 no llevan las ocho secciones', fallos;
  end if;

  -- El bloque 1 ya tenía su propia redacción y no entra en esta migración.
  select count(*)
    into fallos
    from public.lesson_segment_slides s
    join public.lesson_audio_segments seg on seg.id = s.segment_id
    join public.lessons l on l.id = seg.lesson_id
    join public.course_modules m on m.id = l.module_id
   where m.course_version_id = version_id
     and m.position = 1
     and length(s.body) < 1500;
  if fallos > 0 then
    raise exception '% partes del bloque 1 han perdido su explicación', fallos;
  end if;

  -- Las dos modalidades de arranque mantienen redacciones distintas.
  select count(*)
    into fallos
    from public.lesson_segment_slides a
    join public.lesson_audio_segments sa on sa.id = a.segment_id
    join public.lessons la on la.id = sa.lesson_id
    join public.course_modules ma on ma.id = la.module_id
    join public.course_modules mb
      on mb.course_version_id = 'ce4a139a-877f-4da4-a77a-41a9c2309fd2'::uuid
     and mb.position = ma.position
    join public.lessons lb on lb.module_id = mb.id
    join public.lesson_audio_segments sb
      on sb.lesson_id = lb.id and sb.position = sa.position
    join public.lesson_segment_slides b
      on b.segment_id = sb.id and b.position = a.position
   where ma.course_version_id = version_id
     and ma.position between 1 and 5
     and a.body = b.body;
  if fallos > 0 then
    raise exception '% explicaciones de arranque son idénticas en las dos modalidades', fallos;
  end if;
end;
$val$;

commit;
