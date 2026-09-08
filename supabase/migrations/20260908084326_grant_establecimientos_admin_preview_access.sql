begin;

-- El curso permanece en borrador hasta disponer del contenido y precio
-- definitivos, pero los administradores necesitan una matrícula privada para
-- abrirlo desde "Mis cursos" y revisar su estructura completa.
insert into public.enrollments (
  user_id,
  course_version_id,
  source_type,
  source_reference,
  status,
  created_by
)
select
  ur.user_id,
  cv.id,
  'administrative_access',
  'establecimientos_draft_preview',
  'not_started'::public.enrollment_status,
  ur.user_id
from public.user_roles ur
cross join public.course_versions cv
join public.courses c on c.id = cv.course_id
where ur.role in (
    'administrador'::public.app_role,
    'superadministrador'::public.app_role
  )
  and c.slug = 'operadores-establecimientos-beneficio'
on conflict (user_id, course_version_id) do nothing;

commit;
