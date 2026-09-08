begin;

update public.lesson_audio_segments segment
set
  lesson_code = module.position::text || '.' || segment.position::text,
  manual_chapter = module.position::text || '.' || segment.position::text
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
where segment.lesson_id = lesson.id
  and course.slug in (
    'operador-maquinaria-transporte-camion-volquete',
    'prevencion-polvo-silice-cristalina-respirable'
  )
  and module.position between 1 and 5
  and segment.position between 1 and 10;

commit;
