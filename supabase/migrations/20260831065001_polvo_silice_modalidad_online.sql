-- InmínerCampus
-- El curso "Prevención frente al polvo y la sílice cristalina respirable" es
-- 100% online, pero sus versiones heredaron `modality = 'hybrid'` del valor por
-- defecto de la tabla (202607290002_courses_learning_and_assessments.sql) y con
-- él `practice_required = true`. Consecuencia: al terminar toda la teoría, la
-- función de cierre de intento deja la matrícula en 'practice_pending' esperando
-- una práctica presencial que no existe, así que nunca llega a 'completed' ni se
-- rellena `completed_at`. Además el catálogo lo anunciaba como "Híbrido".

update public.course_versions
set
  modality = 'online'::public.course_modality,
  practice_required = false
where course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7';

-- Desatasca las matrículas que ya habían terminado la teoría y se quedaron
-- bloqueadas esperando la práctica inexistente.
update public.enrollments e
set
  status = 'completed'::public.enrollment_status,
  completed_at = coalesce(e.completed_at, e.theory_completed_at, now())
from public.course_versions cv
where cv.id = e.course_version_id
  and cv.course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'
  and e.status in (
    'practice_pending'::public.enrollment_status,
    'practice_completed'::public.enrollment_status,
    'validation_pending'::public.enrollment_status
  )
  and e.theory_completed_at is not null;

do $val$
declare
  pendientes integer;
  hibridas integer;
begin
  select count(*) into hibridas
  from public.course_versions
  where course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'
    and (modality <> 'online'::public.course_modality or practice_required);

  if hibridas > 0 then
    raise exception 'Quedan % versiones de Polvo y Sílice sin pasar a online', hibridas;
  end if;

  select count(*) into pendientes
  from public.enrollments e
  join public.course_versions cv on cv.id = e.course_version_id
  where cv.course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'
    and e.theory_completed_at is not null
    and e.status <> 'completed'::public.enrollment_status;

  if pendientes > 0 then
    raise exception 'Quedan % matrículas de Polvo y Sílice con teoría hecha sin completar', pendientes;
  end if;
end;
$val$;
