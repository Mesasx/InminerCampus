-- Formación STVH pasa a ser un curso privado: sigue existiendo, publicado y
-- accesible para quien ya lo tiene, pero desaparece de todas las superficies
-- públicas. El único camino de alta es canjear un código de acceso, con el
-- mecanismo que ya usa el resto de la plataforma (`redeem_access_code`).
--
-- Oculto no es eliminado: no se toca `status`, ni las matrículas, ni los
-- certificados emitidos, ni los códigos ya generados. Sólo se marca
-- `listed = false`, que es lo que consulta `isCourseVisibleInCatalog` para
-- retirar el curso del catálogo, la home, el buscador, los cursos relacionados,
-- el sitemap y su propia ficha.
begin;

update public.courses
set listed = false,
    updated_at = now()
where slug = 'formacion-stvh'
  and listed;

-- `courses` sólo tenía política de lectura para el catálogo público
-- (`status = 'published'`) y para el personal interno. Mientras esa política no
-- comprueba `listed`, un alumno matriculado sigue leyendo la fila; pero
-- `202608120002_enforce_course_listed_visibility.sql` deja preparada la versión
-- que sí lo comprueba, y con ella un curso oculto dejaría de tener título
-- legible en «Mis cursos» o en la lección.
--
-- Esta política cierra ese hueco por adelantado y de forma aditiva: quien tiene
-- una matrícula viva en cualquier versión del curso puede leer su ficha básica,
-- esté listado o no. Es el mismo criterio que ya aplican
-- `course_versions_enrolled_or_staff` y `course_modules_enrolled_or_staff`.
drop policy if exists courses_enrolled_select on public.courses;
create policy courses_enrolled_select
on public.courses for select
to authenticated
using (
  exists (
    select 1
    from public.course_versions cv
    where cv.course_id = courses.id
      and (select app_private.current_user_is_enrolled(cv.id))
  )
);

commit;
