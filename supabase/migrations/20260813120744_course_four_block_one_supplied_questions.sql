-- Preguntas aportadas para el Curso 4, Bloque 1.
-- Se crea un banco nuevo para conservar intactos los intentos históricos.

create temporary table _course4_block1_target on commit drop as
select
  cv.id as course_version_id,
  l.id as lesson_id,
  quiz.id as quiz_id
from public.courses course
join public.course_versions cv on cv.course_id = course.id
join public.course_modules module
  on module.course_version_id = cv.id and module.position = 1
join public.lessons l on l.module_id = module.id
join public.quizzes quiz on quiz.lesson_id = l.id and quiz.active = true
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and cv.duration_hours = 20
  and cv.status = 'published';

do $$
begin
  if (select count(*) from _course4_block1_target) <> 1 then
    raise exception 'Se esperaba un único test activo para el Curso 4, Bloque 1';
  end if;
end;
$$;

insert into public.question_banks (course_version_id, title)
select
  target.course_version_id,
  'Evaluación aportada · Curso 4 · Bloque 1 · 2026-08-13'
from _course4_block1_target target
on conflict (course_version_id, title) do update
set updated_at = now();

create temporary table _course4_block1_bank on commit drop as
select
  target.*,
  bank.id as bank_id
from _course4_block1_target target
join public.question_banks bank
  on bank.course_version_id = target.course_version_id
  and bank.title = 'Evaluación aportada · Curso 4 · Bloque 1 · 2026-08-13';

create temporary table _course4_block1_questions (
  position integer primary key,
  segment_position integer,
  prompt text not null,
  explanation text not null,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_position integer not null check (correct_position between 1 and 4)
) on commit drop;

insert into _course4_block1_questions (
  position, segment_position, prompt, explanation,
  option_a, option_b, option_c, option_d, correct_position
)
values
  (1, 1,
    'Un operador contratado por una empresa externa maneja una excavadora hidráulica dentro de una explotación minera. Posee experiencia acreditada en construcción, pero desconoce las DIS del centro. ¿Qué afirmación es correcta?',
    'La formación se aplica también a contratas y debe adaptarse al equipo, al terreno y a la organización real de la explotación.',
    'Su experiencia previa sustituye la formación preventiva específica si utiliza el mismo modelo de excavadora.',
    'Solo necesita conocer el manual del fabricante, ya que las DIS se aplican exclusivamente a la empresa titular.',
    'Debe recibir la formación preventiva correspondiente y conocer las condiciones reales, el terreno y las DIS de la explotación.',
    'Puede trabajar acompañado durante el primer turno y completar la formación posteriormente.',
    3),
  (2, 2,
    'Durante la carga, el operador distribuye incorrectamente el material en un volquete. El vehículo circula después por una pista con pendiente transversal. ¿Qué principio preventivo se está incumpliendo principalmente?',
    'Una deficiencia durante la carga puede generar riesgos posteriores durante el transporte y la descarga.',
    'Las fases del movimiento de tierras deben analizarse como operaciones interrelacionadas.',
    'La descarga determina por sí sola la estabilidad del transporte.',
    'La fase de carga termina cuando el cucharón deja de estar sobre la caja.',
    'Los riesgos de circulación dependen únicamente del estado de la pista.',
    1),
  (3, 3,
    'Una excavadora encuentra una zona más resistente que la prevista. El equipo pierde rendimiento, aparecen vibraciones anormales y se observan bloques inestables en el frente. ¿Cuál es la decisión técnicamente correcta?',
    'Las vibraciones y la inestabilidad del frente obligan a detenerse y reevaluar las condiciones; no se debe improvisar el método.',
    'Aumentar progresivamente la presión hidráulica hasta recuperar el rendimiento.',
    'Cambiar inmediatamente la cuchara por un martillo hidráulico, aunque no figure en la planificación.',
    'Continuar desde otro ángulo para evitar retrasar el ciclo de transporte.',
    'Detener la operación, comunicar la incidencia y reevaluar el método y las condiciones del frente.',
    4),
  (4, null,
    '¿Cuál de las siguientes asociaciones entre material y método de arranque es la más correcta?',
    'Es la correspondencia correcta entre las características del material y los métodos de arranque contemplados.',
    'Roca competente: pala cargadora; material ripable: voladura; roca blanda: motoniveladora.',
    'Roca competente: voladura autorizada; material ripable: tractor con escarificador; arranque mecánico: excavadora con equipo permitido.',
    'Roca competente: tractor de ruedas; material ripable: compactador; roca blanda: volquete articulado.',
    'Cualquier material puede arrancarse con excavadora si se reduce suficientemente la velocidad de trabajo.',
    2),
  (5, 4,
    'Una pala cargadora debe trasladar material a corta distancia. ¿Qué combinación describe mejor una operación segura?',
    'El equipo bajo mejora la estabilidad y los bastidores alineados optimizan la tracción durante la penetración en el material.',
    'Cucharón elevado para mejorar la visión del terreno y bastidores articulados al entrar en el acopio.',
    'Cucharón bajo durante el desplazamiento y bastidores alineados al penetrar en el material.',
    'Cucharón a media altura y giro pronunciado durante la penetración para aumentar el llenado.',
    'Cucharón bajo únicamente en pendientes; en terreno horizontal puede transportarse elevado.',
    2),
  (6, null,
    '¿Por qué no debe permanecer una persona en la zona de articulación central de una pala cargadora, aunque el motor esté funcionando al ralentí?',
    'El cierre de la articulación durante un movimiento de dirección puede provocar un atrapamiento grave o mortal.',
    'Porque la articulación puede cerrarse durante un movimiento de dirección y generar un atrapamiento grave.',
    'Porque es la zona en la que se concentra la mayor presión de los neumáticos.',
    'Porque el cucharón puede descargar automáticamente al cambiar el ángulo del bastidor.',
    'Porque la articulación modifica la presión interna del circuito de frenos.',
    1),
  (7, 5,
    'Una excavadora de cadenas debe cargar volquetes sin desplazar su base durante cada ciclo. Antes de empezar, ¿qué comprobación es prioritaria?',
    'La capacidad portante, el apoyo del tren de rodaje y la segregación del radio de giro son condiciones previas esenciales.',
    'Que la superestructura pueda girar a máxima velocidad sin detener el ciclo de carga.',
    'Que el volquete pueda situarse dentro del radio de giro trasero de la máquina.',
    'Que la plataforma tenga capacidad portante suficiente, el tren de rodaje esté bien apoyado y el radio de giro permanezca delimitado.',
    'Que la excavadora se coloque lo más cerca posible del borde para aumentar su alcance.',
    3),
  (8, null,
    'Un trabajador necesita inspeccionar visualmente una tubería situada dentro del radio de giro de una excavadora que está cargando material. ¿Cuál es la actuación correcta?',
    'El contacto visual no elimina el riesgo. El acceso exige la parada del trabajo, una condición segura y autorización.',
    'Acceder por el lado visible para el operador y mantener contacto visual.',
    'Esperar a que la máquina detenga el trabajo, quede en condición segura y se autorice el acceso.',
    'Entrar acompañado por un señalista mientras la excavadora reduce la velocidad.',
    'Acceder por la parte delantera, porque el principal riesgo se encuentra únicamente en el contrapeso.',
    2),
  (9, 6,
    '¿Cuál de las siguientes conclusiones sobre el tractor de cadenas es incorrecta?',
    'El remolcado debe estar autorizado y ajustarse al fabricante y al procedimiento de la explotación, no solamente a la potencia disponible.',
    'Su capacidad de tracción no elimina el riesgo de deslizamiento o vuelco.',
    'Puede emplearse para ripar determinados terrenos compactos o roca blanda.',
    'La operación en laderas requiere respetar los límites de pendiente y evitar giros bruscos.',
    'Puede utilizarse para cualquier remolcado si su potencia de tracción es superior al peso de la máquina recuperada.',
    4),
  (10, 7,
    'Se instala en una excavadora una pinza que encaja físicamente en su acoplamiento rápido. ¿Qué condición permite comenzar el trabajo?',
    'La compatibilidad física no garantiza que el accesorio tenga capacidad adecuada, mantenga la estabilidad ni quede bloqueado de forma segura.',
    'Que el accesorio encaje y el operador confirme visualmente que parece cerrado.',
    'Que se haya utilizado anteriormente en otra excavadora de potencia similar.',
    'Que esté autorizado o evaluado técnicamente, tenga capacidad adecuada y se compruebe el bloqueo mediante una prueba controlada a baja altura.',
    'Que la máquina pueda elevarlo sin activar una alarma hidráulica.',
    3),
  (11, null,
    '¿Por qué el cambio de una cuchara por un accesorio más pesado exige revisar las limitaciones operativas?',
    'Un accesorio distinto puede modificar parámetros fundamentales para la seguridad y la operación de la máquina.',
    'Porque puede modificar el centro de gravedad, la capacidad, la visibilidad y las condiciones de estabilidad de la máquina.',
    'Porque cualquier cambio de accesorio invalida automáticamente el marcado de la máquina.',
    'Porque el único efecto relevante es el aumento del consumo de combustible.',
    'Porque los accesorios pesados reducen siempre el radio de giro de la superestructura.',
    1),
  (12, 8,
    'Durante la inspección diaria, el operador detecta una fuga hidráulica próxima a un latiguillo de alta presión. ¿Qué actuación se ajusta mejor a sus responsabilidades?',
    'El operador debe detectar, informar y evitar el uso inseguro. No debe intervenir sobre sistemas hidráulicos con energía peligrosa si no está autorizado.',
    'Apretar la conexión con el motor en marcha para localizar el punto exacto.',
    'Limpiar la fuga y continuar si el nivel del depósito permanece dentro de límites.',
    'Cubrir la zona con material absorbente y comprobarla al terminar el turno.',
    'Inmovilizar la máquina, comunicar el defecto y dejar la reparación a personal competente.',
    4),
  (13, null,
    'Una alarma aparece de forma intermitente, pero la máquina sigue funcionando aparentemente con normalidad. ¿Qué razonamiento es correcto?',
    'Las alarmas deben interpretarse conforme al manual y a sus posibles consecuencias para la seguridad.',
    'Si no existe pérdida inmediata de potencia, puede ignorarse hasta el mantenimiento programado.',
    'El operador debe interpretar la alarma según el manual y no continuar si puede comprometer la seguridad.',
    'Basta con apagar y encender la máquina para considerar resuelta la incidencia.',
    'La decisión corresponde exclusivamente al mecánico, por lo que el operador debe terminar el ciclo.',
    2),
  (14, 9,
    'Una contrata recibe la orden de acondicionar una pista con un tractor de cadenas. Al llegar, el operador comprueba que la lluvia ha reblandecido el borde y que falta la protección prevista en el procedimiento. ¿Qué debe hacer?',
    'Una diferencia entre el procedimiento previsto y la situación real exige detenerse, comunicarla y obtener instrucciones antes de continuar.',
    'Continuar únicamente con la hoja apoyada para bajar el centro de gravedad.',
    'Trabajar en sentido contrario al borde, siempre que se reduzca la velocidad.',
    'Detenerse en zona segura, comunicar la desviación y solicitar nuevas instrucciones antes de continuar.',
    'Ejecutar una primera pasada sin carga para comprobar empíricamente la resistencia.',
    3),
  (15, 10,
    '¿Cuál de las siguientes situaciones representa mejor un ciclo de trabajo productivo y seguro?',
    'La productividad segura se basa en la continuidad, el control y la anticipación, no en acelerar maniobras aisladas.',
    'Ejecutar cada maniobra a la máxima velocidad permitida para reducir el tiempo unitario.',
    'Mantener un flujo uniforme, anticipar cambios y evitar golpes, derrames, esperas y correcciones peligrosas.',
    'Separar la comprobación preventiva del proceso productivo para que no interfiera con el rendimiento.',
    'Recuperar los retrasos reduciendo los tiempos de observación antes de las maniobras repetitivas.',
    2);

-- Completa el material didáctico para que todas las respuestas evaluadas se
-- hayan explicado previamente al alumno.
create temporary table _course4_block1_additions (
  segment_position integer primary key,
  additional_text text not null
) on commit drop;

insert into _course4_block1_additions (segment_position, additional_text)
values
  (3, 'La elección depende del material: la roca competente requiere voladura autorizada; el material ripable puede trabajarse con tractor y escarificador; y el arranque mecánico con excavadora exige un equipo permitido.'),
  (4, 'Nadie debe permanecer en la articulación central: un movimiento de dirección puede cerrar los bastidores y provocar un atrapamiento grave o mortal.'),
  (5, 'Si una persona necesita acceder al radio de giro, la máquina debe detener el trabajo, quedar en condición segura y autorizarse expresamente el acceso; el contacto visual por sí solo no elimina el riesgo.'),
  (7, 'Tras montar un accesorio se comprueba el bloqueo mediante una prueba controlada a baja altura. El cambio puede modificar el centro de gravedad, la capacidad, la visibilidad y la estabilidad, por lo que deben revisarse sus límites operativos.'),
  (8, 'Las alarmas se interpretan conforme al manual. Aunque sean intermitentes, no se continúa si indican una condición que pueda comprometer la seguridad.');

update public.lesson_segment_slides slide
set
  body = rtrim(slide.body) || ' ' || addition.additional_text,
  updated_at = now()
from _course4_block1_bank target
join public.lesson_audio_segments segment on segment.lesson_id = target.lesson_id
join _course4_block1_additions addition
  on addition.segment_position = segment.position
where slide.segment_id = segment.id
  and slide.position = 1
  and strpos(slide.body, addition.additional_text) = 0;

insert into public.questions (
  question_bank_id,
  lesson_audio_segment_id,
  prompt,
  type,
  explanation,
  points,
  active
)
select
  target.bank_id,
  segment.id,
  spec.prompt,
  'single_choice',
  spec.explanation,
  1,
  true
from _course4_block1_bank target
cross join _course4_block1_questions spec
left join public.lesson_audio_segments segment
  on segment.lesson_id = target.lesson_id
  and segment.position = spec.segment_position
where not exists (
  select 1
  from public.questions existing
  where existing.question_bank_id = target.bank_id
    and existing.prompt = spec.prompt
);

update public.questions question
set active = true, updated_at = now()
from _course4_block1_bank target
join _course4_block1_questions spec on true
where question.question_bank_id = target.bank_id
  and question.prompt = spec.prompt;

insert into public.question_options (
  question_id,
  position,
  option_text,
  is_correct
)
select
  question.id,
  option.ordinality::integer,
  option.option_text,
  option.ordinality = spec.correct_position
from _course4_block1_bank target
join public.questions question on question.question_bank_id = target.bank_id
join _course4_block1_questions spec on spec.prompt = question.prompt
cross join lateral unnest(array[
  spec.option_a,
  spec.option_b,
  spec.option_c,
  spec.option_d
]) with ordinality as option(option_text, ordinality)
where not exists (
  select 1 from public.question_options existing
  where existing.question_id = question.id
);

update public.quizzes quiz
set
  question_bank_id = target.bank_id,
  title = 'Test del bloque 1 · 15 preguntas',
  question_count = 15,
  passing_percent = 100,
  required_perfect_streak = 3,
  randomize_questions = true,
  randomize_options = true,
  minimum_retry_seconds = 0,
  active = true,
  completion_mode = 'cumulative_perfect',
  updated_at = now()
from _course4_block1_bank target
where quiz.id = target.quiz_id;

do $$
declare
  active_question_count integer;
  option_count integer;
  correct_option_count integer;
  explained_addition_count integer;
begin
  select
    count(distinct question.id),
    count(option.id),
    count(option.id) filter (where option.is_correct)
  into active_question_count, option_count, correct_option_count
  from _course4_block1_bank target
  join public.questions question
    on question.question_bank_id = target.bank_id and question.active = true
  left join public.question_options option on option.question_id = question.id;

  select count(*)
  into explained_addition_count
  from _course4_block1_bank target
  join public.lesson_audio_segments segment on segment.lesson_id = target.lesson_id
  join _course4_block1_additions addition
    on addition.segment_position = segment.position
  join public.lesson_segment_slides slide
    on slide.segment_id = segment.id and slide.position = 1
  where strpos(slide.body, addition.additional_text) > 0;

  if active_question_count <> 15
     or option_count <> 60
     or correct_option_count <> 15
     or explained_addition_count <> 5 then
    raise exception
      'Validación fallida: % preguntas, % opciones, % correctas, % ampliaciones',
      active_question_count, option_count, correct_option_count,
      explained_addition_count;
  end if;

  if exists (
    select 1
    from _course4_block1_bank target
    join public.quizzes quiz on quiz.id = target.quiz_id
    where quiz.question_bank_id <> target.bank_id
      or quiz.question_count <> 15
      or quiz.passing_percent <> 100
      or quiz.required_perfect_streak <> 3
      or quiz.completion_mode <> 'cumulative_perfect'
  ) then
    raise exception 'La configuración de superación del test no es correcta';
  end if;
end;
$$;
