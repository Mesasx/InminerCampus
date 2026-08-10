-- Keep Course 1 materials private while allowing enrolled learners and staff
-- to sign both the original deck and V2 replacement deck paths.
drop policy if exists course_materials_enrolled_read on storage.objects;

create policy course_materials_enrolled_read
on storage.objects
for select
to authenticated
using (
  bucket_id = 'course-materials'
  and (
    (
      (storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'
      and (
        (select app_private.current_user_is_enrolled(((storage.foldername(name))[1])::uuid))
        or (select app_private.current_user_has_role(array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]))
      )
    )
    or (
      (
        name like 'course-1/5h/%'
        or name like 'course-1/5h-v2/%'
      )
      and (
        exists (
          select 1
          from public.course_versions cv
          join public.courses c on c.id = cv.course_id
          where c.slug = 'operador-maquinaria-arranque-carga-viales'
            and cv.duration_hours = 5
            and cv.status = 'published'
            and (select app_private.current_user_is_enrolled(cv.id))
        )
        or (select app_private.current_user_has_role(array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]))
      )
    )
  )
);
