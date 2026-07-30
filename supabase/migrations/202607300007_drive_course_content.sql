begin;

create unique index if not exists question_banks_version_title_unique_idx
  on public.question_banks (course_version_id, title);

create temporary table drive_module_content (
  course_slug text not null,
  module_position integer not null,
  segment_titles text[] not null,
  segment_details text[] not null
) on commit drop;

insert into drive_module_content (
  course_slug,
  module_position,
  segment_titles,
  segment_details
) values
(
  'operador-maquinaria-arranque-carga-viales',
  1,
  array[
    'El ciclo del movimiento de tierras',
    'Arranque del material',
    'Carga y descarga',
    'Transporte, extendido y acabado',
    'Máquinas y sistemas mixtos'
  ],
  array[
    'El movimiento de tierras enlaza arranque, carga, transporte y descarga. Según la explotación puede completarse con extendido, nivelación, compactación y refino. Cada fase modifica el estado o la posición del material y condiciona los riesgos, los equipos y la coordinación necesaria.',
    'El arranque transforma el terreno o la roca en material suelto. En roca sana y dura suele requerir perforación y voladura; en materiales menos resistentes puede utilizarse tractor de cadenas, excavadora u otros medios mecánicos. Antes de actuar se comprueban frente, estabilidad, accesos y zona de exclusión.',
    'La carga desplaza el material hasta el vehículo de transporte. La pala debe trabajar sobre superficie estable, con los bastidores alineados y usando todo el ancho del cucharón. El exceso de carga provoca derrames, daños en neumáticos e impactos. La descarga se realiza manteniendo distancias y controlando el borde.',
    'El transporte concentra una parte importante del coste y del riesgo. Se planifican distancias, pendientes, cruces y prioridad de paso. El extendido es poco habitual salvo en escombreras; la motoniveladora realiza nivelación y refino, y los compactadores acondicionan pistas y explanadas.',
    'La excavadora hidráulica puede arrancar y cargar sin desplazarse; la pala cargadora arranca materiales fáciles y carga; la mototraílla integra arranque, carga, transporte, descarga y extendido. Motoniveladoras, tractores, retrocargadoras y manipuladoras completan tareas auxiliares.'
  ]
),
(
  'operador-maquinaria-arranque-carga-viales',
  2,
  array[
    'Preparación personal y acceso',
    'Revisión previa de la máquina',
    'Trabajo seguro con pala cargadora',
    'Trabajo seguro con excavadora',
    'Mantenimiento, estacionamiento y emergencias'
  ],
  array[
    'La ropa debe quedar ajustada y sin elementos que puedan engancharse. Se retiran anillos, relojes y colgantes y se usan los EPI definidos. El acceso se hace de cara a la máquina, con manos libres y tres puntos de apoyo. Nunca se sube o baja con la máquina en movimiento.',
    'La inspección comienza rodeando la máquina: fugas, grietas, neumáticos o cadenas, dientes, cuchillas, niveles, luces, espejos, peldaños y dispositivos de seguridad. Los tapones se abren lentamente, los niveles se comprueban según el manual y cualquier anomalía se comunica antes de arrancar.',
    'La pala ataca el acopio con los bastidores alineados, cucharón bajo durante el desplazamiento y zona de carga limpia. En tolvas no se eleva más de lo necesario. En pistas o rampas se evita trabajar cerca de bordes y se mantiene el implemento en posición que preserve estabilidad y visibilidad.',
    'La excavadora controla el radio de giro, la traslación inesperada y la proximidad a líneas eléctricas. En zanjas se verifica la existencia de servicios enterrados, la cohesión del terreno y la necesidad de entibación. Con martillo hidráulico se controla la proyección de partículas y el ruido.',
    'El estacionamiento se realiza en zona prevista, con implemento apoyado, transmisión segura y freno aplicado. El mantenimiento rutinario respeta bloqueo, descarga de presión y enfriamiento de fluidos. Ante una emergencia se sigue PAS: proteger, avisar y socorrer, conforme al plan del centro.'
  ]
),
(
  'operador-maquinaria-arranque-carga-viales',
  3,
  array[
    'Pala cargadora: órganos principales',
    'Excavadora hidráulica: órganos principales',
    'Frenos, dirección y bloqueos',
    'Dispositivos de aviso y protección',
    'EPI y mantenimiento autorizado'
  ],
  array[
    'La pala integra motor, transmisión, ejes, neumáticos, sistema hidráulico, cucharón y cabina. Radiador, bomba de agua, enfriadores, termostatos y válvulas mantienen condiciones de trabajo. El operador debe reconocer mandos, indicadores y límites sin sustituir las instrucciones del fabricante.',
    'La excavadora de cadenas combina tren de rodaje, corona de giro, superestructura, pluma, balancín, cucharón y circuito hidráulico. Puede girar 360 grados. El contrapeso y la configuración del equipo influyen en estabilidad, alcance y capacidad de carga.',
    'Se distinguen freno de servicio, estacionamiento y emergencia. Los bloqueos del implemento, bastidor articulado, mandos y transmisión evitan movimientos inesperados. La dirección de emergencia es obligatoria en los supuestos previstos y debe comprobarse dentro de la revisión funcional.',
    'ROPS y FOPS, cinturón, alarma de marcha atrás, luces, espejos, arranque en neutro, señalización e indicadores de carga reducen el riesgo residual. No se taladran ni sueldan estructuras protectoras sin autorización expresa del fabricante.',
    'Casco, calzado, guantes, protección ocular, auditiva, respiratoria y anticaídas se seleccionan según el riesgo. El mantenimiento se limita a operaciones autorizadas, con motor parado, energías aisladas, presión descargada y resguardos restituidos antes de volver al servicio.'
  ]
),
(
  'operador-maquinaria-arranque-carga-viales',
  4,
  array[
    'Qué forma parte del lugar de trabajo',
    'Instrumentos y alarmas',
    'Frentes, taludes y bermas',
    'Pistas, viales y zonas de carga',
    'Estacionamiento, talleres y almacenes'
  ],
  array[
    'El lugar de trabajo incluye cabina, accesos, frentes, áreas de carga y descarga, pistas, talleres, almacenes y zonas comunes. El operador observa cambios en terreno, visibilidad, orden, presencia de personas y condiciones meteorológicas antes y durante la tarea.',
    'Termómetros controlan temperatura; manómetros, presión; amperímetros, intensidad; voltímetros, tensión; e indicadores de nivel, disponibilidad de fluidos. Una lectura anormal exige aplicar el manual: adaptar el trabajo, detener con seguridad o comunicar la avería según gravedad.',
    'En frentes y taludes se vigilan grietas, bloques inestables, desprendimientos y presencia de agua. Las bermas ayudan a contener material desprendido, pero no sustituyen el saneo ni la distancia de seguridad. Nadie permanece dentro del radio de acción.',
    'Las pistas deben conservar anchura, firme, drenaje, señalización y visibilidad adecuados. Se retiran piedras y roderas y se riegan cuando sea necesario. Motoniveladora y vagón regador son equipos habituales de mantenimiento. Carga y descarga requieren superficies estables y sin obstáculos.',
    'La máquina se estaciona sin impedir circulación ni visibilidad. En talleres se delimita el área, se bloquea la máquina, se retira la llave y se señaliza la reparación. Los almacenes mantienen productos y repuestos identificados, ordenados y protegidos frente a derrames.'
  ]
),
(
  'operador-maquinaria-arranque-carga-viales',
  5,
  array[
    'Comunicación por radio y señales',
    'Coordinación pala–vehículo',
    'Trabajos simultáneos',
    'Peatones y equipos móviles',
    'Líneas eléctricas y gálibos'
  ],
  array[
    'La radio y las señales acordadas permiten coordinar maniobras. Los mensajes deben ser breves, identificando emisor, destinatario, ubicación y acción. Una maniobra de riesgo no comienza hasta recibir conformidad y se detiene ante pérdida de comunicación.',
    'La pala y el vehículo respetan una secuencia común: posicionamiento visible, inmovilización, carga equilibrada y salida autorizada. El cucharón circula bajo incluso vacío. Ninguna persona se sitúa entre equipos ni bajo un implemento suspendido.',
    'Cuando coinciden producción, mantenimiento, perforación, voladura o circulación se aplican procedimientos internos, zonas de exclusión y prioridades. Cada responsable conoce el trabajo ajeno y cualquier cambio se comunica antes de modificar la secuencia prevista.',
    'Los peatones usan itinerarios separados, chaleco de alta visibilidad y contacto visual con el operador. Si deben circular por una pista, siguen la norma interna y se mantienen fuera de puntos ciegos. El tamaño de la máquina nunca sustituye la vigilancia activa.',
    'Las líneas eléctricas se señalizan con antelación y se respetan distancias de seguridad según tensión y procedimiento. Antes de pasar bajo estructuras se comprueba el gálibo, incluida la altura del implemento y la carga. Ante duda se detiene la operación.'
  ]
),
(
  'operador-maquinaria-arranque-carga-viales',
  6,
  array[
    'Ley de Prevención de Riesgos Laborales',
    'Equipos de trabajo: RD 1215/1997',
    'Seguridad minera: RD 1389/1997',
    'ITC 02.1.02 y ET 2001-1-08',
    'Procedimientos internos y repaso final'
  ],
  array[
    'La Ley 31/1995 establece derechos, obligaciones y principios preventivos. La empresa evalúa riesgos, planifica medidas, informa y forma; el trabajador usa correctamente equipos y EPI, sigue instrucciones y comunica de inmediato las situaciones peligrosas.',
    'El Real Decreto 1215/1997 exige que los equipos sean adecuados, se mantengan y se utilicen por personal capacitado. Resguardos, mandos, parada, estabilidad, señalización y documentación deben responder al riesgo real y a las condiciones del centro.',
    'El Real Decreto 1389/1997 fija disposiciones mínimas para proteger la seguridad y salud en actividades mineras. Se integra con el Reglamento General de Normas Básicas de Seguridad Minera y con las disposiciones internas de cada explotación.',
    'La ITC 02.1.02 regula la formación preventiva para el desempeño del puesto. La especificación técnica 2001-1-08 concreta el itinerario del operador de maquinaria de arranque, carga y viales, diferenciando formación inicial y actualización periódica.',
    'Las normas generales se completan con el manual del fabricante, la evaluación del puesto, las disposiciones internas de seguridad y las instrucciones de trabajo. El criterio final es sencillo: detener, asegurar y consultar cuando una condición no esté prevista.'
  ]
),
(
  'operador-maquinaria-transporte-camion-volquete',
  1,
  array[
    'Ciclo de movimiento de tierras',
    'Camión y volquete: diferencias',
    'Carga y posicionamiento',
    'Transporte y retorno vacío',
    'Descarga y salida a carretera'
  ],
  array[
    'Arranque, carga, transporte y descarga forman un ciclo continuo. El conductor recibe material, lo traslada por pistas o carretera y descarga en tolva, escombrera o punto autorizado. Cada transición exige comunicación, control del entorno e inmovilización cuando corresponda.',
    'El volquete es una máquina autopropulsada sobre ruedas concebida para explotación; puede ser rígido o articulado. El camión puede trabajar dentro de la explotación y circular por carretera si cumple los requisitos. Dimensiones, velocidad, radio de giro y capacidad condicionan el procedimiento.',
    'El vehículo se posiciona según la indicación del operador de carga, normalmente sesgado respecto al frente y sin invadirlo con las ruedas posteriores. Se aplica freno, se permanece en zona segura y se controla que la carga quede centrada y no exceda límites.',
    'Durante el transporte se respetan prioridad, velocidad, distancia, sentido de circulación y señalización. En pendientes se selecciona la relación adecuada antes de iniciar el descenso y se evitan cambios bruscos. El retorno vacío mantiene idéntica disciplina preventiva.',
    'La descarga se realiza en superficie estable, con visibilidad y tope resistente cuando existe borde. La caja se eleva de forma progresiva vigilando estabilidad. Antes de salir a carretera se cubre la carga, se limpian bajos y ruedas y se verifica la aptitud legal del vehículo.'
  ]
),
(
  'operador-maquinaria-transporte-camion-volquete',
  2,
  array[
    'Acceso y revisión inicial',
    'Seguridad durante la carga',
    'Circulación por pistas y pendientes',
    'Descarga en tolvas y escombreras',
    'Mantenimiento y riesgo residual'
  ],
  array[
    'El acceso se realiza con tres puntos de apoyo, usando todos los peldaños y asideros y sin objetos que puedan engancharse. La revisión comprueba fugas, neumáticos, niveles, luces, espejos, frenos, dirección, basculante, alarma y estado de la caja.',
    'Durante la carga nadie permanece fuera de la cabina en la zona de alcance del cucharón. Se evita impacto del implemento y caída de material sobre la cabina. El conductor mantiene comunicación y no mueve el vehículo hasta recibir autorización.',
    'En pistas se adapta la velocidad a firme, visibilidad, carga y tráfico. Antes de bajar se elige la marcha, evitando confiar solo en el freno de servicio. Deslizamiento, vuelco lateral y salida de vía aumentan con velocidad, pendiente, carga descentrada y maniobras bruscas.',
    'En tolvas y bordes se usan topes dimensionados, aproximación perpendicular y velocidad mínima. La zona debe estar iluminada y libre de personas. En escombreras se comprueba estabilidad del borde y no se continúa si existen grietas, asentamientos o falta de visibilidad.',
    'Los riesgos residuales se controlan con formación específica, manual y procedimientos. Aceites, filtros, correas y basculante requieren aislamiento de energías y bloqueo mecánico de la caja. Nunca se trabaja bajo una caja elevada sin su dispositivo de retención.'
  ]
),
(
  'operador-maquinaria-transporte-camion-volquete',
  3,
  array[
    'Motor, refrigeración y lubricación',
    'Transmisión y dirección',
    'Frenos y sistema basculante',
    'Neumáticos y articulación',
    'Alarmas, ROPS y bloqueos'
  ],
  array[
    'Motor, radiador, bomba de agua, enfriadores, termostatos, válvulas y lubricación trabajan como sistema. Temperatura, presión y niveles se vigilan desde el panel. Una alarma no se anula: se interpreta y se actúa conforme al manual.',
    'La transmisión puede ser mecánica, Power Shift, hidrostática o eléctrica según el equipo. La dirección es rígida o articulada. La pérdida de control en equipos pesados exige dirección de emergencia cuando sea aplicable y una comprobación funcional antes del turno.',
    'Frenos de servicio, estacionamiento y emergencia cumplen funciones distintas. El basculante eleva la caja mediante circuito hidráulico y crea riesgo de atrapamiento y bajada imprevista. Palancas, válvulas y bloqueos deben quedar en posición segura durante mantenimiento.',
    'El neumático se selecciona según transporte, carga, empuje, nivelación o compactación. Se revisan presión, cortes, banda, piedras y tornillos sin situarse en la trayectoria de una posible explosión. En volquetes articulados se bloquea la articulación antes de entrar entre bastidores.',
    'Indicadores ópticos, acústicos y placas advierten peligros. ROPS, cinturón, alarma de marcha atrás, control de carga y bloqueos de caja, mandos y transmisión reducen consecuencias. No se modifica una estructura protectora sin autorización del fabricante.'
  ]
),
(
  'operador-maquinaria-transporte-camion-volquete',
  4,
  array[
    'Tres niveles de alarma',
    'Frentes y zonas de carga',
    'Diseño y mantenimiento de pistas',
    'Puntos especiales y pendientes',
    'Descarga, estacionamiento y taller'
  ],
  array[
    'Una alarma de primer nivel informa sin peligro grave inmediato; la de segundo exige cambiar la forma de trabajo o corregir al terminar el turno; la de tercer nivel requiere parada inmediata y suele incorporar aviso sonoro. El manual determina la respuesta exacta.',
    'La zona de carga debe ser amplia, horizontal, limpia y visible. Las bermas ayudan ante desprendimientos, pero se vigila el frente y se conserva distancia. El conductor se posiciona donde la pala pueda verlo y evita las zonas de caída de material.',
    'Las pistas mantienen anchura, drenaje, firme, señalización y separación suficientes. No se normalizan baches, roderas ni piedras. El polvo se controla mediante riego y la visibilidad manda sobre cualquier objetivo de producción.',
    'Apartaderos, cruces y curvas se diseñan para evitar maniobras peligrosas. Como referencia del material formativo, las pendientes se controlan con límites internos y peralte dirigido correctamente. La señalización y el procedimiento del centro prevalecen para cada trazado.',
    'Descargas exigen espacio, visibilidad, firme y ausencia de obstáculos. El estacionamiento evita pendientes siempre que sea posible y aplica freno y calzos según procedimiento. En reparaciones se delimita, bloquea, desconecta y señaliza la máquina.'
  ]
),
(
  'operador-maquinaria-transporte-camion-volquete',
  5,
  array[
    'Radio y autorización de maniobra',
    'Acople pala–volquete',
    'Cruces, adelantamientos y prioridad',
    'Circulación peatonal',
    'Líneas eléctricas y pasos limitados'
  ],
  array[
    'La maniobra se anuncia por radio o señal acordada y espera confirmación de quienes puedan verse afectados. Si la instrucción no es clara, se detiene. La comunicación nunca sustituye la comprobación visual del entorno.',
    'El volquete se posiciona de forma estable y visible, con su eje según el procedimiento de carga. La limpieza del frente y el acople entre capacidades de pala y vehículo evitan derrames, impactos y ciclos inseguros.',
    'Los cruces se realizan en zonas con anchura y visibilidad. No se adelanta salvo autorización y condiciones previstas. La prioridad se fija en las normas internas considerando vehículos cargados, pendientes, equipos especiales y emergencias.',
    'Los peatones usan itinerarios definidos, casco y alta visibilidad. En pista mantienen separación y contacto visual; no atraviesan puntos ciegos ni se aproximan a un vehículo que maniobra. El conductor detiene si pierde de vista a una persona.',
    'La presencia de líneas eléctricas se avisa con antelación y se respetan distancias de seguridad. En túneles, cintas o estructuras se comprueba altura libre con caja bajada y configuración de transporte. Nunca se circula con la caja elevada.'
  ]
),
(
  'operador-maquinaria-transporte-camion-volquete',
  6,
  array[
    'Principios de la Ley 31/1995',
    'Uso seguro según RD 1215/1997',
    'Actividad minera y RD 1389/1997',
    'ITC 02.1.02 y ET 2000-1-08',
    'Disposiciones internas y evaluación'
  ],
  array[
    'La prevención se integra en la organización: evaluación, planificación, información, formación, consulta y vigilancia. El trabajador coopera, usa los medios correctamente e informa de defectos o riesgos sin esperar a que se produzca un incidente.',
    'El Real Decreto 1215/1997 exige equipos adecuados, mantenidos y con protecciones eficaces. El operador debe estar capacitado y autorizado. Mandos, parada, estabilidad, visibilidad y señalización se revisan en las condiciones reales de utilización.',
    'El Real Decreto 1389/1997 desarrolla la protección en actividades mineras. Se aplica junto con el Reglamento General de Normas Básicas de Seguridad Minera y las instrucciones técnicas y disposiciones internas de la explotación.',
    'La ITC 02.1.02 regula la formación del puesto y la especificación técnica 2000-1-08 concreta el programa para operador de maquinaria de transporte, camión y volquete, tanto inicial como periódico de actualización.',
    'El manual, la evaluación del puesto, el plan de tráfico y las disposiciones internas completan la norma. La evaluación final comprueba comprensión, pero la competencia se demuestra aplicando el procedimiento y deteniendo la operación ante una condición insegura.'
  ]
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  1,
  array[
    'Qué es el polvo',
    'Qué es la sílice cristalina respirable',
    'Fracciones y entrada al organismo',
    'Efectos inmediatos y crónicos',
    'Silicosis y otras enfermedades'
  ],
  array[
    'El polvo es materia sólida particulada suspendida en el aire por procesos mecánicos o movimientos de aire. En minería se genera al perforar, arrancar, cargar, transportar, triturar o manipular material y se considera un agente químico peligroso.',
    'La sílice está formada por silicio y oxígeno y aparece en numerosos minerales. La sílice cristalina respirable, o SCR, es la fracción de partículas cristalinas suficientemente pequeñas para alcanzar la región alveolar. Su presencia depende de la roca y del proceso que genera polvo.',
    'La fracción inhalable entra por nariz y boca; la torácica alcanza vías respiratorias; la respirable puede llegar a alvéolos. El riesgo no se estima por lo que se ve: las partículas más finas permanecen suspendidas y pueden ser invisibles.',
    'Una exposición elevada produce irritación, estornudos, conjuntivitis y molestias respiratorias. La exposición prolongada puede causar daño irreversible. El riesgo depende de concentración, duración, composición, tamaño de partícula y eficacia de las medidas preventivas.',
    'La silicosis es una neumoconiosis por inhalación de sílice. Puede ser crónica tras exposiciones prolongadas, acelerada en periodos intermedios o aguda ante concentraciones extremadamente altas. La SCR generada en procesos de trabajo está tratada como agente cancerígeno.'
  ]
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  2,
  array[
    'Procesos que generan polvo y SCR',
    'Fuentes fijas, móviles y lineales',
    'Duración de las emisiones',
    'Factores que aumentan la exposición',
    'Del foco al trabajador'
  ],
  array[
    'Extracción, perforación, trituración, cribado, transporte, descarga, secado y ensacado pueden liberar polvo. También tareas secundarias como limpieza en seco o mantenimiento remueven material depositado. Cada puesto debe analizarse en condiciones habituales y anómalas.',
    'Una fuente puede ser fija, como una trituradora; móvil, como un volquete; o lineal, como una pista o cinta. Esta clasificación ayuda a decidir confinamiento, captación, riego, ventilación y separación entre foco y trabajador.',
    'Las emisiones pueden ser permanentes, semipermanentes o intermitentes. Una tarea breve pero intensa no se descarta: debe contemplarse en la evaluación, incluida la apertura de equipos, averías, derrames y limpieza.',
    'Influyen mineralogía y humedad de la roca, granulometría, energía del proceso, maquinaria, viento, temperatura, mantenimiento y posibilidad de usar agua. El terreno seco, la velocidad y una cabina mal sellada elevan la exposición.',
    'El control actúa sobre tres eslabones: evitar o reducir la emisión en el foco; limitar la transmisión mediante confinamiento, extracción o humedad; y proteger al receptor con organización, información, vigilancia y protección respiratoria cuando siga siendo necesaria.'
  ]
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  3,
  array[
    'SCR como agente cancerígeno',
    'Obligaciones del empresario',
    'ITC 02.0.02',
    'Valor límite y principio de reducción',
    'Guías técnicas de referencia'
  ],
  array[
    'La normativa española incluye los trabajos con exposición a polvo respirable de sílice cristalina generado en un proceso de trabajo dentro de la protección frente a agentes cancerígenos. Esto refuerza sustitución, reducción al mínimo, documentación, formación y vigilancia.',
    'La empresa identifica, evalúa, previene y reduce el riesgo; implanta higiene, informa, forma, consulta, vigila la salud y comunica a las autoridades cuando corresponda. Las decisiones deben quedar documentadas y actualizarse cuando cambian procesos o resultados.',
    'La Orden TED/723/2021 aprueba la ITC 02.0.02 sobre protección frente a polvo y SCR en minería. Regula evaluación, muestreo, valores, medidas, vigilancia y documentación para integrarlos en la gestión preventiva de la explotación.',
    'El material formativo aplica un valor límite de 0,05 mg/m³ para SCR. Cumplir un límite no elimina la obligación de reducir la exposición tanto como sea técnicamente posible, especialmente por tratarse de un cancerígeno sin umbral de seguridad garantizado.',
    'Las guías del INSST y del Instituto Nacional de Silicosis orientan la aplicación técnica aunque no sustituyen la norma. NEPSI aporta fichas de buenas prácticas por proceso. Siempre se consulta la edición vigente y la evaluación concreta del centro.'
  ]
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  4,
  array[
    'Identificación de materiales y tareas',
    'Muestreo personal representativo',
    'Periodicidad y estrategia de medición',
    'Laboratorios y resultados',
    'Revisión de la evaluación'
  ],
  array[
    'La identificación combina análisis del material a granel y estudio de las tareas de cada puesto. Si no hay SCR puede seguir existiendo riesgo por polvo. Se documentan equipos, tiempos, condiciones, medidas existentes y trabajadores potencialmente expuestos.',
    'El muestreo se realiza con aparatos personales portados por el trabajador, compuestos por muestreador y bomba. Debe representar la exposición habitual y cubrir las fases relevantes de la jornada sin interferir en el trabajo.',
    'La ITC establece mediciones al menos una vez por cuatrimestre del año natural en los supuestos aplicables. La estrategia aumenta frecuencia ante cambios, resultados elevados, fallos de control o tareas no representadas.',
    'Personal competente permanece durante el muestreo y los análisis se encargan a laboratorios autorizados por la autoridad minera. El resultado se relaciona con duración, puesto, fracción de polvo y porcentaje de sílice; un número aislado no basta.',
    'La evaluación se actualiza con los resultados y revisa medidas preventivas. Si el control es insuficiente se actúa sobre foco, transmisión y receptor, se verifica la eficacia y se informa a las personas afectadas.'
  ]
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  5,
  array[
    'Sustitución y cambio de proceso',
    'Confinamiento y captación',
    'Control por vía húmeda',
    'Medidas organizativas y transporte',
    'Higiene, EPR y exposición accidental'
  ],
  array[
    'La primera opción es evitar el agente o sustituir proceso y material. En minería la sílice suele formar parte natural de la roca, por lo que la imposibilidad de sustitución se justifica documentalmente y se estudian procedimientos menos emisores.',
    'Carenados, capotajes, cabinas cerradas y presurizadas, campanas de extracción y separadores impiden que el polvo alcance el ambiente. El sistema debe diseñarse para el foco, mantenerse y verificarse; una puerta abierta o un filtro saturado anulan su eficacia.',
    'La inyección o pulverización de agua, espuma y niebla reduce la puesta en suspensión. Pistas y plazas conservan humedad suficiente sin crear nuevos riesgos de deslizamiento. El agua se aplica cerca del punto de generación y se mantiene durante la operación.',
    'Se limitan velocidad, acceso, desplazamientos y tiempo de exposición. Cargas se riegan o cubren, ruedas se lavan y vías se mantienen. Pantallas vegetales o físicas reducen el viento. Limpieza en seco y aire comprimido se sustituyen por métodos controlados.',
    'No se come, bebe ni fuma en zonas expuestas; ropa de trabajo y calle se guardan separadas. La protección respiratoria se selecciona, ajusta, limpia y almacena correctamente. Ante exposición accidental se restringe el acceso, limita el tiempo y protege al personal imprescindible.'
  ]
),
(
  'prevencion-polvo-silice-cristalina-respirable',
  6,
  array[
    'Vigilancia de la salud',
    'Documentación preventiva',
    'Información a las autoridades',
    'Formación, consulta y EPR',
    'Buenas prácticas y evaluación final'
  ],
  array[
    'La vigilancia se realiza antes de la exposición, periódicamente y cuando aparecen trastornos en personas con exposición similar. Incluye historia clínico-laboral, exploración, pruebas pertinentes, puesto, tiempo, mediciones, riesgos y medidas. La periodicidad depende de la exposición y del protocolo aplicable.',
    'Se conservan evaluación, metodología, análisis de sustitución, listado de personas expuestas, niveles, historiales médicos y compatibilidad de puestos. La documentación permite demostrar decisiones y mantener continuidad aunque cambie el servicio preventivo.',
    'Las enfermedades profesionales se comunican a autoridades laboral y minera. En cese se remiten listas e historiales según corresponda. Las paralizaciones y reinicios por sobreexposición siguen un circuito formal de información entre empresa, personal e inspección.',
    'La plantilla recibe información sobre material, riesgos, resultados, medidas, higiene, EPR, vigilancia y actuación en incidentes. La formación práctica incluye colocación, comprobación de ajuste, retirada, limpieza y almacenamiento de la protección respiratoria.',
    'Las fichas NEPSI cubren limpieza, ventilación, edificios, almacenamiento, carga, descarga, trituración, perforación y gestión de contratas. La evaluación final refuerza que la prevención es una cadena: identificar, medir, controlar, verificar y mejorar.'
  ]
);

with expanded as (
  select
    d.course_slug,
    d.module_position,
    title.ordinality::smallint as segment_position,
    title.value as segment_title,
    detail.value as segment_detail
  from drive_module_content d
  cross join lateral unnest(d.segment_titles)
    with ordinality as title(value, ordinality)
  join lateral unnest(d.segment_details)
    with ordinality as detail(value, ordinality)
    on detail.ordinality = title.ordinality
)
insert into public.lesson_audio_segments (
  lesson_id,
  position,
  title,
  narration_text,
  duration_seconds,
  published
)
select
  l.id,
  e.segment_position,
  e.segment_title,
  e.segment_detail,
  120,
  false
from expanded e
join public.courses c on c.slug = e.course_slug
join public.course_versions cv on cv.course_id = c.id
join public.course_modules cm
  on cm.course_version_id = cv.id
 and cm.position = e.module_position
join public.lessons l
  on l.module_id = cm.id
 and l.position = 1
on conflict (lesson_id, position) do update set
  title = excluded.title,
  narration_text = excluded.narration_text,
  duration_seconds = excluded.duration_seconds,
  updated_at = now();

with expanded as (
  select
    d.course_slug,
    d.module_position,
    title.ordinality::smallint as segment_position,
    title.value as segment_title,
    detail.value as segment_detail
  from drive_module_content d
  cross join lateral unnest(d.segment_titles)
    with ordinality as title(value, ordinality)
  join lateral unnest(d.segment_details)
    with ordinality as detail(value, ordinality)
    on detail.ordinality = title.ordinality
),
segment_rows as (
  select
    s.id as segment_id,
    e.segment_title,
    e.segment_detail
  from expanded e
  join public.courses c on c.slug = e.course_slug
  join public.course_versions cv on cv.course_id = c.id
  join public.course_modules cm
    on cm.course_version_id = cv.id
   and cm.position = e.module_position
  join public.lessons l on l.module_id = cm.id and l.position = 1
  join public.lesson_audio_segments s
    on s.lesson_id = l.id
   and s.position = e.segment_position
)
insert into public.lesson_segment_slides (
  segment_id,
  position,
  title,
  body
)
select
  segment_id,
  1,
  segment_title,
  segment_detail
from segment_rows
union all
select
  segment_id,
  2,
  'Aplicación en el puesto',
  'Comprueba la situación real, aplica el procedimiento del centro y detén la tarea si cambia una condición de seguridad. Comunica la incidencia antes de continuar.'
from segment_rows
on conflict (segment_id, position) do update set
  title = excluded.title,
  body = excluded.body,
  updated_at = now();

create temporary table drive_questions (
  course_slug text not null,
  prompt text not null,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_position integer not null,
  explanation text
) on commit drop;

insert into drive_questions values
('operador-maquinaria-arranque-carga-viales','¿Qué fases forman el movimiento de tierras completo?','Solo arranque y carga','Arranque, carga, transporte y descarga, con posibles acabados','Solo transporte y compactación','Únicamente perforación y voladura',2,'El ciclo básico enlaza arranque, carga, transporte y descarga.'),
('operador-maquinaria-arranque-carga-viales','¿Cómo se accede correctamente a la cabina?','De espaldas y con rapidez','Con la máquina en movimiento','De cara a la máquina y con tres puntos de apoyo','Saltando el último peldaño',3,'Los tres puntos de apoyo reducen caídas.'),
('operador-maquinaria-arranque-carga-viales','¿Qué se revisa antes de arrancar?','Solo combustible','Fugas, rodaje, implementos, niveles y sistemas de seguridad','Solo la documentación','Nada si funcionó el turno anterior',2,'La revisión previa es integral y se documenta según el centro.'),
('operador-maquinaria-arranque-carga-viales','¿Cómo debe circular una pala cargadora?','Con el cucharón elevado','Con el cucharón lo más bajo posible','Con el cucharón abierto','En punto muerto',2,'La posición baja mejora estabilidad y visibilidad.'),
('operador-maquinaria-arranque-carga-viales','¿Qué riesgo destaca en una excavadora?','Solo el ruido','Giro de superestructura, traslación y líneas eléctricas','Únicamente polvo','Ninguno dentro de la cabina',2,'El radio de giro y la traslación requieren zona de exclusión.'),
('operador-maquinaria-arranque-carga-viales','¿Qué frenos incorpora habitualmente una pala?','Servicio, estacionamiento y emergencia','Solo servicio','Motor y mano','Ninguno',1,'Cada freno tiene una función diferente.'),
('operador-maquinaria-arranque-carga-viales','¿Se puede soldar una estructura ROPS sin autorización?','Sí, siempre','Solo al final del turno','No, debe autorizarlo el fabricante','Sí, con cualquier electrodo',3,'Modificar ROPS puede invalidar su protección.'),
('operador-maquinaria-arranque-carga-viales','¿Para qué sirve una berma?','Para aumentar velocidad','Como apoyo de control ante desprendimientos','Para aparcar','Para almacenar combustible',2,'No sustituye el saneo ni la distancia de seguridad.'),
('operador-maquinaria-arranque-carga-viales','¿Qué significa PAS?','Parar, andar, salir','Proteger, avisar, socorrer','Prevenir, asegurar, señalizar','Pensar, actuar, seguir',2,'Es la secuencia básica de primeros auxilios.'),
('operador-maquinaria-arranque-carga-viales','¿Quién puede mover una máquina?','Cualquier trabajador','Personal capacitado y autorizado','Solo quien tenga permiso de conducir','Una visita acompañada',2,'Capacitación y autorización son imprescindibles.'),
('operador-maquinaria-arranque-carga-viales','¿Qué norma regula requisitos mínimos de equipos de trabajo?','RD 1215/1997','Código Civil','Ley de Tráfico únicamente','RD 665/1997',1,'El RD 1215/1997 regula el uso seguro de equipos.'),
('operador-maquinaria-arranque-carga-viales','¿Qué debe hacerse ante una instrucción de maniobra confusa?','Continuar despacio','Detener y confirmar','Acelerar para terminar','Ignorar la radio',2,'Una maniobra no se inicia sin confirmación clara.'),
('operador-maquinaria-transporte-camion-volquete','¿Cuál es el ciclo habitual del vehículo de transporte?','Carga, transporte, descarga, retorno y maniobra','Solo carga','Arranque y trituración','Perforación y voladura',1,'El ciclo incluye también retorno vacío y posicionamiento.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué diferencia al camión del volquete minero?','El camión puede cumplir requisitos para circular por carretera','El volquete siempre circula por carretera','No existe diferencia','El camión no transporta material',1,'El ámbito de uso y los requisitos de circulación son diferentes.'),
('operador-maquinaria-transporte-camion-volquete','¿Cómo se accede a la cabina?','Con tres puntos de apoyo','Saltando desde el suelo','Con el motor acelerado','Por cualquier zona del chasis',1,'Se usan peldaños y asideros previstos.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué riesgo presenta revisar neumáticos?','Solo suciedad','Corte, reventón y explosión','Únicamente ruido','Ninguno',2,'La posición del cuerpo y el procedimiento de inflado son críticos.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué hacer antes de bajar una pendiente?','Seleccionar la relación adecuada','Poner punto muerto','Apagar el motor','Elevar la caja',1,'La marcha se selecciona antes del descenso.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué protege en una descarga junto a un borde?','Un tope resistente y un firme estable','Solo la bocina','Una cuerda','La velocidad',1,'El tope no sustituye la comprobación del terreno.'),
('operador-maquinaria-transporte-camion-volquete','¿Se trabaja bajo una caja elevada sin bloqueo?','Sí, si está vacía','No','Solo de día','Sí, con freno aplicado',2,'Debe existir retención mecánica segura.'),
('operador-maquinaria-transporte-camion-volquete','¿Cuándo exige parada inmediata una alarma?','En el tercer nivel','Siempre en el primero','Nunca','Solo al finalizar el turno',1,'El tercer nivel indica riesgo grave o avería.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué debe hacerse antes de salir a carretera?','Cubrir la carga y limpiar bajos y ruedas','Aumentar la carga','Elevar la caja','Desconectar luces',1,'Se evita caída de material y suciedad en la vía.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué protege la articulación del chasis?','Un bloqueo mecánico durante intervención','La radio','El cinturón únicamente','El limpiaparabrisas',1,'El bloqueo evita atrapamiento entre bastidores.'),
('operador-maquinaria-transporte-camion-volquete','¿Cómo se coordinan maniobras de riesgo?','Se comunican y esperan conformidad','Se ejecutan sin aviso','Se dejan al azar','Se hacen siempre marcha atrás',1,'La confirmación previa evita interferencias.'),
('operador-maquinaria-transporte-camion-volquete','¿Qué ET corresponde al operador de transporte?','ET 2000-1-08','ET 2001-1-08','ITC 02.0.02','Ninguna',1,'La ET 2000-1-08 concreta este puesto.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué es el polvo?','Materia sólida particulada suspendida en el aire','Vapor de agua','Solo humo visible','Un gas inerte',1,'El tamaño y la composición determinan su comportamiento.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué fracción puede alcanzar los alvéolos?','La respirable','Solo la sedimentada','La fracción gruesa únicamente','Ninguna',1,'Las partículas respirables penetran más profundamente.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué condición permite presencia de SCR?','Material con sílice y generación de partículas respirables','Solo humedad','Únicamente alta temperatura','Ausencia de maquinaria',1,'Deben coincidir composición y proceso emisor.'),
('prevencion-polvo-silice-cristalina-respirable','¿Cuál es una enfermedad asociada a SCR?','Silicosis','Miopía','Dermatitis solar','Esguince',1,'La silicosis es una neumoconiosis irreversible.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué valor límite aplica el material formativo?','0,05 mg/m³','5 mg/m³','50 mg/m³','0,5 g/m³',1,'El cumplimiento no elimina el deber de minimizar.'),
('prevencion-polvo-silice-cristalina-respirable','¿Cómo se realiza el muestreo representativo?','Con equipo personal portado por el trabajador','Mirando el polvo','Solo al aire libre','Con una fotografía',1,'Muestreador y bomba recogen la fracción adecuada.'),
('prevencion-polvo-silice-cristalina-respirable','¿Quién analiza las muestras?','Laboratorios autorizados por la autoridad minera','Cualquier taller','El propio operario','El proveedor de EPI',1,'La competencia y autorización garantizan trazabilidad.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué medida actúa en el foco?','Confinamiento, captación o agua','Solo mascarilla','Rotación sin control técnico','Reconocimiento médico',1,'La prioridad es evitar que el polvo llegue al ambiente.'),
('prevencion-polvo-silice-cristalina-respirable','¿Se justifica no sustituir el agente?','Sí, documentalmente cuando no sea técnicamente viable','Nunca','Solo verbalmente','No hace falta evaluarlo',1,'La sustitución debe contemplarse antes de descartarse.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué práctica higiénica es correcta?','Separar ropa de trabajo y ropa de calle','Comer en la zona de polvo','Limpiar con aire comprimido','Guardar el respirador sucio',1,'La higiene evita exposición secundaria.'),
('prevencion-polvo-silice-cristalina-respirable','¿Cuándo se realiza vigilancia de la salud?','Antes de exposición, periódicamente y cuando proceda','Solo al jubilarse','Nunca si hay EPI','Solo tras un accidente',1,'La vigilancia se adapta al riesgo y protocolo.'),
('prevencion-polvo-silice-cristalina-respirable','¿Qué norma minera específica regula polvo y SCR?','ITC 02.0.02 aprobada por Orden TED/723/2021','ET 2000-1-08','Código de circulación','RD 1215/1997 únicamente',1,'La ITC 02.0.02 es la referencia minera específica.');

insert into public.question_banks (
  course_version_id,
  title
)
select
  cv.id,
  'Evaluación final · contenido Cursos Pedro'
from public.course_versions cv
join public.courses c on c.id = cv.course_id
where c.slug in (
  'operador-maquinaria-arranque-carga-viales',
  'operador-maquinaria-transporte-camion-volquete',
  'prevencion-polvo-silice-cristalina-respirable'
)
on conflict (course_version_id, title) do nothing;

insert into public.questions (
  question_bank_id,
  prompt,
  type,
  explanation,
  points,
  active
)
select
  qb.id,
  dq.prompt,
  'single_choice',
  dq.explanation,
  1,
  true
from drive_questions dq
join public.courses c on c.slug = dq.course_slug
join public.course_versions cv on cv.course_id = c.id
join public.question_banks qb
  on qb.course_version_id = cv.id
 and qb.title = 'Evaluación final · contenido Cursos Pedro'
where not exists (
  select 1
  from public.questions q
  where q.question_bank_id = qb.id
    and q.prompt = dq.prompt
);

insert into public.question_options (
  question_id,
  position,
  option_text,
  is_correct
)
select
  q.id,
  option_row.position,
  option_row.option_text,
  option_row.position = dq.correct_position
from drive_questions dq
join public.courses c on c.slug = dq.course_slug
join public.course_versions cv on cv.course_id = c.id
join public.question_banks qb
  on qb.course_version_id = cv.id
 and qb.title = 'Evaluación final · contenido Cursos Pedro'
join public.questions q
  on q.question_bank_id = qb.id
 and q.prompt = dq.prompt
cross join lateral (
  values
    (1, dq.option_a),
    (2, dq.option_b),
    (3, dq.option_c),
    (4, dq.option_d)
) as option_row(position, option_text)
on conflict (question_id, position) do update set
  option_text = excluded.option_text,
  is_correct = excluded.is_correct,
  updated_at = now();

insert into public.quizzes (
  lesson_id,
  question_bank_id,
  title,
  question_count,
  passing_percent,
  required_perfect_streak,
  randomize_questions,
  randomize_options,
  minimum_retry_seconds,
  active
)
select
  l.id,
  qb.id,
  'Evaluación final',
  10,
  100,
  cv.required_perfect_streak,
  true,
  true,
  0,
  true
from public.course_versions cv
join public.courses c on c.id = cv.course_id
join public.course_modules cm
  on cm.course_version_id = cv.id
 and cm.position = 6
join public.lessons l on l.module_id = cm.id and l.position = 1
join public.question_banks qb
  on qb.course_version_id = cv.id
 and qb.title = 'Evaluación final · contenido Cursos Pedro'
where c.slug in (
  'operador-maquinaria-arranque-carga-viales',
  'operador-maquinaria-transporte-camion-volquete',
  'prevencion-polvo-silice-cristalina-respirable'
)
on conflict (lesson_id) do update set
  question_bank_id = excluded.question_bank_id,
  title = excluded.title,
  question_count = excluded.question_count,
  passing_percent = excluded.passing_percent,
  required_perfect_streak = excluded.required_perfect_streak,
  active = true,
  updated_at = now();

commit;
