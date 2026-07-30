begin;

create index if not exists lesson_audio_progress_segment_idx
  on public.lesson_audio_progress (segment_id);

commit;
