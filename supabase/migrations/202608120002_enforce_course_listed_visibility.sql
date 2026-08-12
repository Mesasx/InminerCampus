-- Auditoría de seguridad: `courses.listed` (202608110001) documenta que
-- "false oculta el curso del catálogo público sin despublicarlo", pero
-- ninguna política de RLS lo comprobaba — solo `status = 'published'`. Un
-- curso con `listed = false` seguía siendo legible directamente por
-- anon/authenticated vía `courses`, `course_versions`, `course_modules` y
-- `lessons`, saltándose el filtro que aplica el catálogo en la aplicación.
--
-- Hoy ningún curso sembrado tiene `listed = false` (Formación STVH usa
-- `listed = true` a propósito, para aparecer en el catálogo con "Acceso por
-- código"), así que esto no cambia el comportamiento visible de ningún
-- curso existente. Cierra el hueco para el día en que se use `listed =
-- false` de verdad.

begin;

drop policy if exists courses_public_published on public.courses;
create policy courses_public_published
on public.courses for select
to anon, authenticated
using (
  status = 'published'
  and listed
);

drop policy if exists course_versions_visible on public.course_versions;
create policy course_versions_visible
on public.course_versions for select
to anon, authenticated
using (
  status = 'published'
  and exists (
    select 1 from public.courses c
    where c.id = course_id and c.listed
  )
);

drop policy if exists course_modules_visible on public.course_modules;
create policy course_modules_visible
on public.course_modules for select
to anon, authenticated
using (
  exists (
    select 1
    from public.course_versions cv
    join public.courses c on c.id = cv.course_id
    where cv.id = course_version_id
      and cv.status = 'published'
      and c.listed
  )
);

drop policy if exists lessons_visible on public.lessons;
create policy lessons_visible
on public.lessons for select
to anon, authenticated
using (
  exists (
    select 1
    from public.course_modules cm
    join public.course_versions cv on cv.id = cm.course_version_id
    join public.courses c on c.id = cv.course_id
    where cm.id = module_id
      and cv.status = 'published'
      and c.listed
  )
);

commit;
