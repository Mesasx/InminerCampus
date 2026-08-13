-- Sincroniza la duración editorial del curso 4 con la duración real de cada
-- MP3. Los valores se obtuvieron de System.Media.Duration y se redondearon al
-- segundo más cercano.

begin;

create temporary table course_four_audio_durations (
  block_position smallint not null,
  segment_position smallint not null,
  duration_seconds integer not null,
  primary key (block_position, segment_position)
) on commit drop;

insert into course_four_audio_durations values
  (1, 1, 44), (1, 2, 42), (1, 3, 46), (1, 4, 44), (1, 5, 42),
  (1, 6, 44), (1, 7, 44), (1, 8, 44), (1, 9, 41), (1, 10, 48),
  (2, 1, 44), (2, 2, 39), (2, 3, 38), (2, 4, 43), (2, 5, 43),
  (2, 6, 41), (2, 7, 40), (2, 8, 43), (2, 9, 44), (2, 10, 43),
  (3, 1, 44), (3, 2, 37), (3, 3, 45), (3, 4, 36), (3, 5, 44),
  (3, 6, 40), (3, 7, 44), (3, 8, 40), (3, 9, 41), (3, 10, 40),
  (4, 1, 46), (4, 2, 48), (4, 3, 45), (4, 4, 43), (4, 5, 42),
  (4, 6, 41), (4, 7, 41), (4, 8, 42), (4, 9, 43), (4, 10, 51),
  (5, 1, 47), (5, 2, 43), (5, 3, 42), (5, 4, 38), (5, 5, 41),
  (5, 6, 44), (5, 7, 42), (5, 8, 39), (5, 9, 44), (5, 10, 47);

update public.lesson_audio_segments segment
set duration_seconds = duration.duration_seconds,
    updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_four_audio_durations duration
  on duration.block_position = module.position
where segment.lesson_id = lesson.id
  and segment.position = duration.segment_position
  and segment.published
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
  and version.status = 'published';

do $$
declare
  exact_duration_count integer;
begin
  select count(*)
  into exact_duration_count
  from public.lesson_audio_segments segment
  join public.lessons lesson on lesson.id = segment.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  join course_four_audio_durations duration
    on duration.block_position = module.position
   and duration.segment_position = segment.position
   and duration.duration_seconds = segment.duration_seconds
  where segment.published
    and course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20
    and version.status = 'published';

  if exact_duration_count <> 50 then
    raise exception 'Curso 4: solo % de 50 audios tienen su duración real.',
      exact_duration_count;
  end if;
end $$;

commit;
