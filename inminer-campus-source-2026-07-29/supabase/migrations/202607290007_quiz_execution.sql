-- InmínerCampus
-- Server-authoritative quiz creation, grading and perfect-streak progression.

create table if not exists public.quiz_attempt_questions (
  quiz_attempt_id uuid not null
    references public.quiz_attempts(id) on delete cascade,
  question_id uuid not null
    references public.questions(id) on delete restrict,
  position integer not null,
  option_order uuid[] not null default '{}'::uuid[],
  created_at timestamptz not null default now(),
  primary key (quiz_attempt_id, question_id),
  unique (quiz_attempt_id, position),
  constraint quiz_attempt_questions_position_positive check (position > 0)
);

create index if not exists quiz_attempt_questions_question_idx
  on public.quiz_attempt_questions (question_id);

alter table public.quiz_attempt_questions enable row level security;
alter table public.quiz_attempt_questions force row level security;

revoke all on table public.quiz_attempt_questions from anon, authenticated;
grant select on table public.quiz_attempt_questions to authenticated;

drop policy if exists quiz_attempt_questions_visible
  on public.quiz_attempt_questions;
create policy quiz_attempt_questions_visible
on public.quiz_attempt_questions
for select
to authenticated
using (
  exists (
    select 1
    from public.quiz_attempts qa
    where qa.id = quiz_attempt_id
      and (
        qa.user_id = (select auth.uid())
        or (select app_private.current_user_has_role(
          array[
            'tutor'::public.app_role,
            'administrador'::public.app_role,
            'superadministrador'::public.app_role
          ]
        ))
      )
  )
);

create or replace function public.start_quiz_attempt(
  p_quiz_id uuid,
  p_enrollment_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  quiz_record public.quizzes%rowtype;
  attempt_id uuid;
  next_attempt_number integer;
  prior_streak integer := 0;
  last_submitted_at timestamptz;
  question_total integer;
  result jsonb;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  perform pg_advisory_xact_lock(
    hashtextextended(p_quiz_id::text || ':' || p_enrollment_id::text, 0)
  );

  select q.*
  into quiz_record
  from public.quizzes q
  join public.lessons l on l.id = q.lesson_id
  join public.course_modules m on m.id = l.module_id
  join public.enrollments e
    on e.course_version_id = m.course_version_id
  join public.lesson_progress lp
    on lp.enrollment_id = e.id
   and lp.lesson_id = l.id
  where q.id = p_quiz_id
    and q.active = true
    and e.id = p_enrollment_id
    and e.user_id = current_user_id
    and e.status not in ('failed', 'expired')
    and lp.status <> 'locked';

  if not found then
    raise exception 'Quiz is not available';
  end if;

  select qa.id, qa.attempt_number
  into attempt_id, next_attempt_number
  from public.quiz_attempts qa
  where qa.quiz_id = p_quiz_id
    and qa.enrollment_id = p_enrollment_id
    and qa.user_id = current_user_id
    and qa.status = 'in_progress'
  order by qa.attempt_number desc
  limit 1;

  if found then
    select coalesce(qa.perfect_streak_after, 0)
    into prior_streak
    from public.quiz_attempts qa
    where qa.quiz_id = p_quiz_id
      and qa.enrollment_id = p_enrollment_id
      and qa.status = 'graded'
    order by qa.attempt_number desc
    limit 1;

    prior_streak := coalesce(prior_streak, 0);
  else
    select
      coalesce(max(attempt_number), 0) + 1,
      coalesce(
        (array_agg(perfect_streak_after order by attempt_number desc)
          filter (where status = 'graded'))[1],
        0
      ),
      max(submitted_at)
    into next_attempt_number, prior_streak, last_submitted_at
    from public.quiz_attempts
    where quiz_id = p_quiz_id
      and enrollment_id = p_enrollment_id;

    if last_submitted_at is not null
       and last_submitted_at
         + make_interval(secs => quiz_record.minimum_retry_seconds) > now()
    then
      raise exception 'Retry interval has not elapsed';
    end if;

    select count(*)
    into question_total
    from public.questions
    where question_bank_id = quiz_record.question_bank_id
      and active = true;

    if question_total < quiz_record.question_count then
      raise exception 'Question bank does not contain enough active questions';
    end if;

    insert into public.quiz_attempts (
      quiz_id,
      enrollment_id,
      user_id,
      attempt_number,
      status
    )
    values (
      p_quiz_id,
      p_enrollment_id,
      current_user_id,
      next_attempt_number,
      'in_progress'
    )
    returning id into attempt_id;

    insert into public.quiz_attempt_questions (
      quiz_attempt_id,
      question_id,
      position,
      option_order
    )
    select
      attempt_id,
      chosen.id,
      row_number() over (),
      case
        when quiz_record.randomize_options then (
          select array_agg(o.id order by random())
          from public.question_options o
          where o.question_id = chosen.id
        )
        else (
          select array_agg(o.id order by o.position)
          from public.question_options o
          where o.question_id = chosen.id
        )
      end
    from (
      select q.id
      from public.questions q
      where q.question_bank_id = quiz_record.question_bank_id
        and q.active = true
      order by
        case when quiz_record.randomize_questions then random() else 0 end,
        q.created_at,
        q.id
      limit quiz_record.question_count
    ) chosen;
  end if;

  select jsonb_build_object(
    'attemptId', attempt_id,
    'attemptNumber', next_attempt_number,
    'title', quiz_record.title,
    'currentStreak', prior_streak,
    'requiredStreak', quiz_record.required_perfect_streak,
    'questions', coalesce(
      jsonb_agg(
        jsonb_build_object(
          'id', q.id,
          'prompt', q.prompt,
          'type', q.type,
          'options', (
            select jsonb_agg(
              jsonb_build_object(
                'id', ordered_option.option_id,
                'text', qo.option_text
              )
              order by ordered_option.ordinality
            )
            from unnest(aq.option_order) with ordinality
              as ordered_option(option_id, ordinality)
            join public.question_options qo
              on qo.id = ordered_option.option_id
          )
        )
        order by aq.position
      ),
      '[]'::jsonb
    )
  )
  into result
  from public.quiz_attempt_questions aq
  join public.questions q on q.id = aq.question_id
  where aq.quiz_attempt_id = attempt_id;

  return result;
end;
$$;

create or replace function public.submit_quiz_attempt(
  p_attempt_id uuid,
  p_answers jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  attempt_record public.quiz_attempts%rowtype;
  quiz_record public.quizzes%rowtype;
  total_questions integer;
  correct_questions integer;
  score numeric(5,2);
  perfect boolean;
  prior_streak integer := 0;
  resulting_streak integer;
  v_course_version_id uuid;
  v_lesson_id uuid;
  completed_lessons integer;
  total_lessons integer;
  progress numeric(5,2);
  practice_is_required boolean;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  if jsonb_typeof(p_answers) <> 'array' then
    raise exception 'Answers must be a JSON array';
  end if;

  select *
  into attempt_record
  from public.quiz_attempts
  where id = p_attempt_id
    and user_id = current_user_id
  for update;

  if not found or attempt_record.status <> 'in_progress' then
    raise exception 'Attempt is not available for submission';
  end if;

  select *
  into quiz_record
  from public.quizzes
  where id = attempt_record.quiz_id;

  with submitted as (
    select
      answer.question_id,
      coalesce(
        array(
          select value::uuid
          from jsonb_array_elements_text(answer.selected_option_ids) value
          order by value::uuid
        ),
        '{}'::uuid[]
      ) as selected_ids
    from jsonb_to_recordset(p_answers) as answer(
      question_id uuid,
      selected_option_ids jsonb
    )
  ),
  graded as (
    select
      aq.question_id,
      coalesce(s.selected_ids, '{}'::uuid[]) as selected_ids,
      coalesce(s.selected_ids, '{}'::uuid[]) = array(
        select qo.id
        from public.question_options qo
        where qo.question_id = aq.question_id
          and qo.is_correct = true
        order by qo.id
      ) as is_correct
    from public.quiz_attempt_questions aq
    left join submitted s on s.question_id = aq.question_id
    where aq.quiz_attempt_id = p_attempt_id
  )
  insert into public.quiz_attempt_answers (
    quiz_attempt_id,
    question_id,
    selected_option_ids,
    is_correct
  )
  select
    p_attempt_id,
    question_id,
    selected_ids,
    is_correct
  from graded;

  select
    count(*),
    count(*) filter (where is_correct)
  into total_questions, correct_questions
  from public.quiz_attempt_answers
  where quiz_attempt_id = p_attempt_id;

  if total_questions = 0 then
    raise exception 'Attempt has no questions';
  end if;

  score := round((correct_questions::numeric / total_questions::numeric) * 100, 2);
  perfect := correct_questions = total_questions;

  select coalesce(perfect_streak_after, 0)
  into prior_streak
  from public.quiz_attempts
  where quiz_id = attempt_record.quiz_id
    and enrollment_id = attempt_record.enrollment_id
    and status = 'graded'
    and attempt_number < attempt_record.attempt_number
  order by attempt_number desc
  limit 1;

  prior_streak := coalesce(prior_streak, 0);
  resulting_streak := case when perfect then prior_streak + 1 else 0 end;

  update public.quiz_attempts
  set
    status = 'graded',
    score_percent = score,
    is_perfect = perfect,
    perfect_streak_after = resulting_streak,
    submitted_at = now(),
    graded_at = now()
  where id = p_attempt_id;

  select q.lesson_id, m.course_version_id
  into v_lesson_id, v_course_version_id
  from public.quizzes q
  join public.lessons l on l.id = q.lesson_id
  join public.course_modules m on m.id = l.module_id
  where q.id = attempt_record.quiz_id;

  if resulting_streak >= quiz_record.required_perfect_streak then
    update public.lesson_progress
    set
      status = 'completed',
      completed_at = coalesce(completed_at, now())
    where enrollment_id = attempt_record.enrollment_id
      and public.lesson_progress.lesson_id = v_lesson_id;

    update public.lesson_progress target_progress
    set status = 'available'
    where target_progress.enrollment_id = attempt_record.enrollment_id
      and target_progress.status = 'locked'
      and target_progress.lesson_id = (
        select ordered.id
        from (
          select
            l.id,
            row_number() over (order by m.position, l.position) as sequence_number
          from public.course_modules m
          join public.lessons l on l.module_id = m.id
          where m.course_version_id = v_course_version_id
            and l.active = true
        ) ordered
        where ordered.sequence_number = (
          select current_lesson.sequence_number + 1
          from (
            select
              l.id,
              row_number() over (order by m.position, l.position) as sequence_number
            from public.course_modules m
            join public.lessons l on l.module_id = m.id
            where m.course_version_id = v_course_version_id
              and l.active = true
          ) current_lesson
          where current_lesson.id = v_lesson_id
        )
      );
  end if;

  select
    count(*) filter (where lp.status = 'completed'),
    count(*)
  into completed_lessons, total_lessons
  from public.lesson_progress lp
  where lp.enrollment_id = attempt_record.enrollment_id;

  progress := case
    when total_lessons = 0 then 0
    else round((completed_lessons::numeric / total_lessons::numeric) * 100, 2)
  end;

  select practice_required
  into practice_is_required
  from public.course_versions
  where id = v_course_version_id;

  update public.enrollments
  set
    progress_percent = progress,
    status = case
      when completed_lessons = total_lessons and practice_is_required
        then 'practice_pending'::public.enrollment_status
      when completed_lessons = total_lessons
        then 'completed'::public.enrollment_status
      else 'in_progress'::public.enrollment_status
    end,
    started_at = coalesce(started_at, now()),
    theory_completed_at = case
      when completed_lessons = total_lessons then coalesce(theory_completed_at, now())
      else theory_completed_at
    end,
    completed_at = case
      when completed_lessons = total_lessons and not practice_is_required
        then coalesce(completed_at, now())
      else completed_at
    end
  where id = attempt_record.enrollment_id;

  return jsonb_build_object(
    'scorePercent', score,
    'isPerfect', perfect,
    'perfectStreak', resulting_streak,
    'requiredStreak', quiz_record.required_perfect_streak,
    'evaluationCompleted',
      resulting_streak >= quiz_record.required_perfect_streak
  );
end;
$$;

revoke all on function public.start_quiz_attempt(uuid, uuid)
  from public, anon;
revoke all on function public.submit_quiz_attempt(uuid, jsonb)
  from public, anon;

grant execute on function public.start_quiz_attempt(uuid, uuid)
  to authenticated;
grant execute on function public.submit_quiz_attempt(uuid, jsonb)
  to authenticated;
