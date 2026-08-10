begin;

do $$
declare
  updated_slide_count integer;
  uploaded_slide_count integer;
  current_slide_count integer;
begin
  select count(*)
  into uploaded_slide_count
  from storage.objects
  where bucket_id = 'course-materials'
    and name like 'course-1/5h-v2/%';

  if uploaded_slide_count <> 100 then
    raise exception
      'Las 100 diapositivas V2 del Curso 1 no están disponibles (encontradas: %)',
      uploaded_slide_count;
  end if;

  update public.lesson_segment_slides as slide
  set image_storage_path = regexp_replace(
    slide.image_storage_path,
    '^course-1/5h/',
    'course-1/5h-v2/'
  )
  from public.lesson_audio_segments as segment
  join public.lessons as lesson on lesson.id = segment.lesson_id
  join public.course_modules as module on module.id = lesson.module_id
  join public.course_versions as course_version
    on course_version.id = module.course_version_id
  join public.courses as course on course.id = course_version.course_id
  where slide.segment_id = segment.id
    and course.slug = 'operador-maquinaria-arranque-carga-viales'
    and course_version.duration_hours = 5
    and module.position between 1 and 5
    and segment.position between 1 and 10
    and slide.position between 1 and 2
    and slide.image_storage_path like 'course-1/5h/%';

  get diagnostics updated_slide_count = row_count;

  if updated_slide_count not in (0, 100) then
    raise exception
      'La sustitución de diapositivas del Curso 1 quedó incompleta: % actualizadas',
      updated_slide_count;
  end if;

  select count(*)
  into current_slide_count
  from public.lesson_segment_slides as slide
  join public.lesson_audio_segments as segment on segment.id = slide.segment_id
  join public.lessons as lesson on lesson.id = segment.lesson_id
  join public.course_modules as module on module.id = lesson.module_id
  join public.course_versions as course_version
    on course_version.id = module.course_version_id
  join public.courses as course on course.id = course_version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and course_version.duration_hours = 5
    and module.position between 1 and 5
    and segment.position between 1 and 10
    and slide.position between 1 and 2
    and slide.image_storage_path like 'course-1/5h-v2/%';

  if current_slide_count <> 100 then
    raise exception
      'El Curso 1 debe terminar con 100 diapositivas V2 (encontradas: %)',
      current_slide_count;
  end if;
end
$$;

commit;
