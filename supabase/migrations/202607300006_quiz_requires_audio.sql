begin;

create or replace function app_private.require_audio_before_quiz()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if exists (
    select 1
    from public.quizzes q
    join public.lesson_audio_segments s on s.lesson_id = q.lesson_id
    where q.id = new.quiz_id
      and (
        s.published = false
        or not exists (
          select 1
          from public.lesson_audio_progress p
          where p.enrollment_id = new.enrollment_id
            and p.segment_id = s.id
            and p.completed_at is not null
        )
      )
  ) then
    raise exception 'Complete every lesson audio before starting the quiz';
  end if;

  return new;
end;
$$;

drop trigger if exists quiz_attempts_require_audio
  on public.quiz_attempts;
create trigger quiz_attempts_require_audio
before insert on public.quiz_attempts
for each row execute function app_private.require_audio_before_quiz();

revoke all on function app_private.require_audio_before_quiz()
  from public, anon, authenticated;

commit;
