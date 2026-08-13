-- Restaura el reproductor combinado del curso 4 tras la actualización de su
-- presentación. Los MP3 seguían conectados, pero `content_mode = 'slides'`
-- hacía que el campus montase únicamente el visor de diapositivas.

begin;

update public.lessons lesson
set content_mode = 'audio',
    kind = 'mixed'::public.lesson_kind,
    updated_at = now()
from public.course_modules module
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where lesson.module_id = module.id
  and lesson.position = 1
  and module.position between 1 and 5
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20
  and version.status = 'published';

do $$
declare
  audio_lesson_count integer;
  playable_segment_count integer;
  stored_audio_count integer;
begin
  select count(*)
  into audio_lesson_count
  from public.lessons lesson
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  where lesson.position = 1
    and lesson.content_mode = 'audio'
    and module.position between 1 and 5
    and course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20
    and version.status = 'published';

  select count(*), count(object.id)
  into playable_segment_count, stored_audio_count
  from public.lesson_audio_segments segment
  join public.lessons lesson on lesson.id = segment.lesson_id
  join public.course_modules module on module.id = lesson.module_id
  join public.course_versions version on version.id = module.course_version_id
  join public.courses course on course.id = version.course_id
  left join storage.objects object
    on object.bucket_id = 'course-materials'
   and object.name = segment.audio_storage_path
   and object.metadata->>'mimetype' = 'audio/mpeg'
  where segment.published
    and module.position between 1 and 5
    and course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20
    and version.status = 'published';

  if audio_lesson_count <> 5
     or playable_segment_count <> 50
     or stored_audio_count <> 50 then
    raise exception
      'Curso 4 sin audio completo: % lecciones, % partes publicadas, % MP3 disponibles.',
      audio_lesson_count, playable_segment_count, stored_audio_count;
  end if;
end $$;

commit;
