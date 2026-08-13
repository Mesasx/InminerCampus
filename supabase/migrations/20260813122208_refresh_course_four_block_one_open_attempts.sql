-- Los intentos en curso conservan una instantánea de sus preguntas.
-- Al sustituir el banco del Curso 4, Bloque 1, se actualizan únicamente esas
-- instantáneas abiertas para que no sigan mostrando el banco anterior.

create temporary table _course4_block1_current_quiz on commit drop as
select
  quiz.id as quiz_id,
  quiz.question_bank_id,
  quiz.question_count,
  quiz.randomize_questions,
  quiz.randomize_options
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module
  on module.course_version_id = version.id and module.position = 1
join public.lessons lesson on lesson.module_id = module.id
join public.quizzes quiz on quiz.lesson_id = lesson.id and quiz.active = true
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
  and version.status = 'published';

do $$
begin
  if (select count(*) from _course4_block1_current_quiz) <> 1 then
    raise exception 'Se esperaba un único test activo para el Curso 4, Bloque 1';
  end if;
end;
$$;

create temporary table _course4_block1_stale_attempts on commit drop as
select distinct attempt.id as attempt_id
from _course4_block1_current_quiz current_quiz
join public.quiz_attempts attempt
  on attempt.quiz_id = current_quiz.quiz_id
  and attempt.status = 'in_progress'
join public.quiz_attempt_questions snapshot
  on snapshot.quiz_attempt_id = attempt.id
join public.questions question on question.id = snapshot.question_id
where question.question_bank_id <> current_quiz.question_bank_id;

delete from public.quiz_attempt_questions snapshot
using _course4_block1_stale_attempts stale
where snapshot.quiz_attempt_id = stale.attempt_id;

insert into public.quiz_attempt_questions (
  quiz_attempt_id,
  question_id,
  position,
  option_order
)
select
  stale.attempt_id,
  chosen.id,
  row_number() over (
    partition by stale.attempt_id
    order by
      case when current_quiz.randomize_questions then random() else 0 end,
      chosen.created_at,
      chosen.id
  ),
  case
    when current_quiz.randomize_options then (
      select array_agg(option.id order by random())
      from public.question_options option
      where option.question_id = chosen.id
    )
    else (
      select array_agg(option.id order by option.position)
      from public.question_options option
      where option.question_id = chosen.id
    )
  end
from _course4_block1_stale_attempts stale
cross join _course4_block1_current_quiz current_quiz
join lateral (
  select question.id, question.created_at
  from public.questions question
  where question.question_bank_id = current_quiz.question_bank_id
    and question.active = true
  order by
    case when current_quiz.randomize_questions then random() else 0 end,
    question.created_at,
    question.id
  limit current_quiz.question_count
) chosen on true;

do $$
begin
  if exists (
    select 1
    from _course4_block1_stale_attempts stale
    cross join _course4_block1_current_quiz current_quiz
    left join public.quiz_attempt_questions snapshot
      on snapshot.quiz_attempt_id = stale.attempt_id
    left join public.questions question on question.id = snapshot.question_id
    group by stale.attempt_id, current_quiz.question_bank_id,
      current_quiz.question_count
    having count(snapshot.question_id) <> current_quiz.question_count
      or count(snapshot.question_id) filter (
        where question.question_bank_id = current_quiz.question_bank_id
      ) <> current_quiz.question_count
  ) then
    raise exception 'Algún intento abierto conserva preguntas del banco anterior';
  end if;
end;
$$;
