begin;

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
  block.position,
  'Bloque ' || block.position,
  '',
  120,
  false
from public.lessons l
cross join generate_series(1, 5) as block(position)
where l.active = true
on conflict (lesson_id, position) do nothing;

commit;
