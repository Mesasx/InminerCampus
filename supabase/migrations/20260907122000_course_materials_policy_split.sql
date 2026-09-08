begin;

-- Avoid evaluating two permissive SELECT policies for administrators while
-- keeping the same authorization model.
drop policy if exists course_materials_admin_manage
  on public.course_materials;

create policy course_materials_admin_insert
on public.course_materials for insert
to authenticated
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

create policy course_materials_admin_update
on public.course_materials for update
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

create policy course_materials_admin_delete
on public.course_materials for delete
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

commit;
