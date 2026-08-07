begin;

create temporary table course_one_block_one_slides (
  audio_position smallint primary key,
  source_slide_one smallint not null,
  source_slide_two smallint,
  concept_title text not null,
  concept_body text not null,
  second_title text not null,
  second_body text not null,
  third_title text,
  third_body text
) on commit drop;

insert into course_one_block_one_slides values
(1, 4, null,
  'El ciclo completo del movimiento de tierras',
  E'El movimiento de tierras comprende las operaciones que modifican el terreno y desplazan el material hasta su destino. El ciclo básico empieza con el arranque, continúa con la carga y el transporte y termina con la descarga. Cuando el proyecto lo requiere, se añaden extendido, nivelación, compactación y refino.\n\nEstas fases forman un sistema: el rendimiento y la seguridad de una operación condicionan a las siguientes. Una fragmentación inadecuada dificulta la carga; una mala coordinación genera esperas; y una descarga deficiente obliga a repetir trabajos de acabado.',
  'Cómo se coordina el ciclo en una explotación',
  E'Antes de iniciar los trabajos deben definirse el material, las distancias, las pendientes, las zonas de carga y descarga y la capacidad de los equipos. El operador debe conocer su función dentro del ciclo y mantener comunicación con el resto de máquinas.\n\nSi cambian el terreno, la visibilidad, el tráfico o la estabilidad de una zona, la operación debe detenerse y reevaluarse. La productividad nunca debe conseguirse a costa de circular por rutas inseguras, trabajar junto a bordes inestables o invadir el radio de acción de otro equipo.',
  null, null),
(2, 5, null,
  'Qué significa arrancar el material',
  E'El arranque separa el material del macizo rocoso o del terreno natural y lo transforma en material suelto. El objetivo no es únicamente extraerlo: debe quedar con una fragmentación, un volumen y una disposición compatibles con la cuchara del equipo de carga y con el sistema de transporte.\n\nLa elección del método depende de la resistencia, fracturación, abrasividad, humedad y estructura del terreno. También influyen la geometría del frente, la producción prevista y las limitaciones ambientales o de seguridad existentes en la explotación.',
  'Resultado que debe obtenerse antes de cargar',
  E'Un arranque correcto deja el material estable, accesible y suficientemente fragmentado, sin bloques que superen la capacidad del equipo ni zonas colgadas que puedan desprenderse. Antes de aproximarse, el operador debe comprobar el estado del frente, la presencia de material inestable y la existencia de personas o maquinaria dentro de su zona de trabajo.\n\nSi el resultado del arranque no permite una carga segura, no debe compensarse aplicando golpes, esfuerzos laterales o maniobras para las que el implemento no está diseñado.',
  null, null),
(3, 5, null,
  'Perforación y voladura como método de arranque',
  E'Cuando la roca sana no puede excavarse de forma eficaz por medios mecánicos, se recurre a la perforación y la voladura. La perforación genera barrenos con la posición, profundidad e inclinación previstas; la voladura utiliza esos barrenos para fragmentar el macizo de manera controlada.\n\nEl diseño debe adaptarse a la roca y al frente para lograr una granulometría adecuada, limitar proyecciones, vibraciones y sobreexcavación y facilitar las operaciones posteriores. Una fragmentación deficiente aumenta los tiempos de carga, el desgaste de las máquinas y los riesgos durante la manipulación de bloques.',
  'Coordinación segura después de una voladura',
  E'El operador de maquinaria no manipula explosivos salvo que disponga de la habilitación específica de artillero. Debe respetar la señalización, las zonas de exclusión y las instrucciones del responsable de la voladura.\n\nLa entrada al frente solo se produce después de la autorización correspondiente. Antes de cargar se revisan el saneo, los posibles barrenos fallidos, la estabilidad del talud y la presencia de material proyectado. Cualquier anomalía se comunica y la zona se mantiene aislada hasta recibir instrucciones.',
  null, null),
(4, 5, null,
  'Arranque mecánico con tractor de cadenas y ripper',
  E'El ripper o escarificador concentra el esfuerzo del tractor de cadenas en uno o varios dientes que penetran, fracturan y aflojan materiales ripables. Es una alternativa al uso de explosivos cuando la resistencia y la estructura del terreno permiten romperlo mediante tracción y penetración mecánica.\n\nLa capacidad de ripado depende de la dureza, la fracturación, la orientación de estratos, la humedad, la abrasividad y la profundidad de trabajo. El peso y la potencia del tractor no garantizan por sí solos un resultado adecuado si el terreno no es ripable.',
  'Comprobaciones antes y durante el ripado',
  E'Antes de trabajar se estudian la dirección más favorable de ataque, la pendiente, la existencia de servicios enterrados y el estado del terreno. El operador debe evitar giros cerrados con el diente enterrado y esfuerzos laterales que puedan dañar el escarificador o desestabilizar la máquina.\n\nEl ripper se eleva para maniobrar y circular. La velocidad debe permitir controlar rebotes, pérdidas de tracción y cambios bruscos de resistencia. Si aparecen vibraciones anormales, obstáculos no identificados o falta de estabilidad, se interrumpe el trabajo.',
  null, null),
(5, 6, null,
  'La carga enlaza el arranque con el transporte',
  E'La fase de carga recoge el material suelto y lo deposita en un vehículo, una tolva o una instalación receptora. Los equipos más habituales son la pala cargadora y la excavadora hidráulica. La selección depende de la geometría del frente, las características del material, la producción necesaria y la compatibilidad con el equipo receptor.\n\nLa cuchara, la altura de descarga y el alcance deben permitir llenar el vehículo sin golpear la caja, sobrecargar un lateral ni derramar material sobre la cabina o la zona de circulación.',
  'Acoplamiento entre máquina de carga y vehículo',
  E'La zona debe permitir posicionar el vehículo de forma clara, estable y visible para el operador. La maniobra se coordina mediante señales previamente acordadas y nadie permanece entre la máquina de carga y el vehículo.\n\nLa carga se distribuye de manera uniforme y sin superar la capacidad autorizada. Un número excesivo de pases alarga el ciclo; una cuchara sobredimensionada puede causar impactos y sobrecarga. Si se pierde contacto visual o la señal resulta confusa, se detiene la maniobra hasta restablecer la comunicación.',
  null, null),
(6, 6, null,
  'Características de la pala cargadora sobre ruedas',
  E'La pala sobre ruedas combina una elevada movilidad con ciclos rápidos de carga y desplazamientos cortos. Es especialmente eficaz sobre firmes con capacidad portante suficiente y permite cambiar de zona con mayor facilidad que una máquina de cadenas.\n\nSu rendimiento depende de la tracción disponible, el estado de los neumáticos, el radio de giro, la estabilidad y la posición del cucharón. La articulación central mejora la maniobrabilidad, pero crea una zona de atrapamiento que debe quedar libre durante la operación y bloquearse mecánicamente durante determinadas intervenciones.',
  'Límites operativos y circulación segura',
  E'La movilidad no convierte a la pala en una máquina adecuada para cualquier terreno. El barro profundo, los rellenos sin compactar, la roca cortante, los baches y las pendientes transversales reducen estabilidad y adherencia y pueden dañar los neumáticos.\n\nDurante la circulación, el cucharón se mantiene bajo y recogido para reducir el centro de gravedad y mejorar la visibilidad. Se adapta la velocidad al firme y se evitan giros bruscos. Antes de entrar en una zona nueva se comprueban anchura, pendiente, bordes y capacidad portante.',
  null, null),
(7, 7, null,
  'El transporte se analiza mediante el tiempo de ciclo',
  E'El coste del transporte depende del tiempo necesario para cargar, desplazarse con material, maniobrar, descargar y regresar vacío. Por eso no basta con medir la distancia. Las pendientes, el estado del firme, las curvas, el tráfico, la visibilidad, la capacidad del vehículo y las esperas cambian de forma decisiva la productividad.\n\nUna ruta algo más larga puede resultar más segura y rápida si tiene mejor firme y menos interferencias. El dimensionamiento correcto equilibra el número de vehículos con la capacidad del equipo de carga para evitar colas o tiempos muertos.',
  'Factores que el operador debe vigilar en la ruta',
  E'Antes y durante el recorrido se comprueban pendientes, anchura, radios de giro, drenaje, señalización, cruces, prioridad de paso y estado de bermas. La velocidad se adapta a la carga, la visibilidad y las condiciones reales, no solo al límite indicado.\n\nEl operador debe comunicar baches, derrames, polvo excesivo, pérdida de adherencia o cualquier deterioro de la pista. Mantener una distancia segura evita colisiones y permite frenar sin maniobras bruscas. Las esperas se realizan únicamente en zonas previstas.',
  null, null),
(8, 7, 8,
  'Sistemas habituales de transporte',
  E'La elección entre volquete minero, dúmper articulado, camión bañera u otro sistema depende del material, la producción, la distancia y las condiciones de la pista. Los equipos rígidos ofrecen gran capacidad en rutas preparadas; los articulados se adaptan mejor a terrenos irregulares; y los camiones convencionales requieren condiciones compatibles con su diseño y, si circulan por vía pública, con la normativa de tráfico.\n\nCapacidad de carga, estabilidad, frenado y radio de giro deben analizarse conjuntamente.',
  'La descarga exige una zona estable y controlada',
  E'La descarga puede realizarse en tolvas, acopios o escombreras. Antes de elevar la caja o vaciar el cucharón se comprueban la horizontalidad, la capacidad portante del firme, la ausencia de personas y la distancia al borde. Los topes de seguridad ayudan a posicionar el vehículo, pero no sustituyen la inspección del terreno ni autorizan a empujar contra un borde inestable.\n\nLa descarga se interrumpe si el material queda adherido, la caja se inclina, el vehículo pierde apoyo o cambia cualquier condición de estabilidad.',
  'Secuencia práctica de aproximación y salida',
  E'El acceso se realiza a velocidad reducida siguiendo la señalización y las indicaciones del responsable de la zona. El vehículo se alinea antes de iniciar la descarga y evita correcciones bruscas con la caja elevada.\n\nUna vez vaciado, la caja se baja completamente antes de circular. Si existe material derramado, mala visibilidad o riesgo de colisión, se comunica la incidencia y se espera a que la zona vuelva a ser segura. Nunca se abandona la cabina en una posición de descarga peligrosa.'),
(9, 4, 9,
  'Operaciones que completan el movimiento de tierras',
  E'Después de transportar y descargar el material puede ser necesario extenderlo, nivelarlo, compactarlo y refinarlo. Cada operación controla una propiedad diferente del resultado. El extendido distribuye el material en capas; la nivelación ajusta cotas y pendientes; la compactación aumenta la densidad y reduce huecos; y el refino consigue la geometría y el acabado final previstos.\n\nNo son tareas intercambiables. Un material bien nivelado puede estar mal compactado, y una capa compactada con espesor excesivo puede no alcanzar una densidad uniforme.',
  'Dónde se aplican estas fases en una explotación',
  E'En minería y actividades extractivas, el extendido aparece especialmente en escombreras, rellenos, restauraciones, plataformas y construcción o mantenimiento de pistas. La nivelación garantiza drenaje y geometría; la compactación mejora capacidad portante y estabilidad; y el refino corrige irregularidades antes de entregar la superficie.\n\nEl procedimiento debe definir material, espesor de tongada, humedad, número de pasadas y criterio de aceptación. La maquinaria se selecciona según el espacio, la pendiente y el resultado exigido.',
  'Comprobación del resultado final',
  E'El operador no debe valorar el acabado únicamente a simple vista. Se siguen las cotas, pendientes, espesores y ensayos definidos por el proyecto o por el responsable de obra. También se vigila el drenaje para evitar acumulaciones de agua y pérdida de capacidad portante.\n\nSi aparecen blandones, bombeos, segregación, grietas o deformaciones, se detiene el acabado y se corrige la causa. Continuar pasando la máquina sin diagnóstico puede ocultar temporalmente el problema y aumentar el retrabajo.'),
(10, 10, null,
  'Sistemas mixtos: varias funciones en una máquina',
  E'Los sistemas mixtos reúnen dos o más fases del movimiento de tierras en un mismo equipo. Una excavadora puede arrancar y cargar; una pala cargadora puede cargar y realizar transporte corto; y una mototraílla puede arrancar, cargar, transportar, descargar y extender cuando el terreno y la distancia son adecuados.\n\nEsta clasificación funcional permite diseñar ciclos más simples, pero no significa que una máquina multifunción sea siempre la opción más productiva. Deben compararse capacidad, distancia, maniobrabilidad, mantenimiento, disponibilidad y condiciones del terreno.',
  'Cómo elegir entre un sistema simple y uno mixto',
  E'Un equipo mixto puede reducir transferencias de material y el número de máquinas, pero también concentrar la producción en un único elemento: una avería detiene varias fases a la vez. En distancias largas o grandes producciones suele ser más eficaz separar carga y transporte.\n\nLa elección se basa en el ciclo completo y no en una característica aislada. También se comprueba que el operador esté formado y autorizado para el equipo concreto, que los implementos sean compatibles y que las rutas y zonas de trabajo permitan utilizarlo con seguridad.',
  null, null);

with target_segments as (
  select s.id as segment_id, d.*
  from course_one_block_one_slides d
  join public.courses c
    on c.slug = 'operador-maquinaria-arranque-carga-viales'
  join public.course_versions cv
    on cv.course_id = c.id and cv.duration_hours = 5
  join public.course_modules cm
    on cm.course_version_id = cv.id and cm.position = 1
  join public.lessons l
    on l.module_id = cm.id and l.position = 1
  join public.lesson_audio_segments s
    on s.lesson_id = l.id and s.position = d.audio_position
),
visual_slides as (
  select
    segment_id,
    1::smallint as position,
    concept_title as title,
    concept_body as body,
    '/course-slides/course-1/block-1/source-slide-'
      || lpad(source_slide_one::text, 2, '0') || '.png' as image_external_url,
    'Presentación de Cursos Pedro en Google Drive'::text as source_label,
    'Diapositiva ' || source_slide_one::text as source_page,
    'Diapositiva original sobre ' || lower(concept_title) as alt_text
  from target_segments
  union all
  select
    segment_id,
    2::smallint,
    second_title,
    second_body,
    case
      when source_slide_two is null then null
      else '/course-slides/course-1/block-1/source-slide-'
        || lpad(source_slide_two::text, 2, '0') || '.png'
    end,
    case
      when source_slide_two is null then
        'Desarrollo didáctico de InmínerCampus'
      else 'Presentación de Cursos Pedro en Google Drive'
    end,
    case
      when source_slide_two is null then null
      else 'Diapositiva ' || source_slide_two::text
    end,
    case
      when source_slide_two is null then
        'Explicación aplicada: ' || second_title
      else 'Diapositiva original sobre ' || lower(second_title)
    end
  from target_segments
  union all
  select
    segment_id,
    3::smallint,
    third_title,
    third_body,
    null,
    'Desarrollo didáctico de InmínerCampus',
    null,
    'Explicación aplicada: ' || third_title
  from target_segments
  where third_title is not null and third_body is not null
)
insert into public.lesson_segment_slides (
  segment_id,
  position,
  title,
  body,
  image_storage_path,
  image_external_url,
  source_label,
  source_page,
  alt_text
)
select
  segment_id,
  position,
  title,
  body,
  null,
  image_external_url,
  source_label,
  source_page,
  alt_text
from visual_slides
on conflict (segment_id, position) do update set
  title = excluded.title,
  body = excluded.body,
  image_storage_path = null,
  image_external_url = excluded.image_external_url,
  source_label = excluded.source_label,
  source_page = excluded.source_page,
  alt_text = excluded.alt_text,
  updated_at = now();

commit;
