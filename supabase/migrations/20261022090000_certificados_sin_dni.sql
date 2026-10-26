begin;

-- La entrega de un certificado definitivo depende de que la matrícula esté
-- completada, no de que el alumno haya informado el DNI/NIE en el campus.
-- Esta reparación completa las matrículas de camión y volquete que una
-- migración anterior dejó bloqueadas únicamente por no tener DNI.
update public.enrollments e
set
  status = 'completed'::public.enrollment_status,
  progress_percent = 100,
  completed_at = coalesce(e.completed_at, e.theory_completed_at, now())
from public.course_versions cv
where cv.id = e.course_version_id
  and cv.course_id = '362231f3-3900-4b23-a59c-4afc0830134d'
  and e.status in (
    'practice_pending'::public.enrollment_status,
    'practice_completed'::public.enrollment_status,
    'validation_pending'::public.enrollment_status
  )
  and e.theory_completed_at is not null
  and not cv.practice_required;

-- Los avisos que fallaron expresamente por faltar el DNI se pueden procesar
-- de nuevo; el registro interno indicará "No informado".
update public.internal_completion_records record
set
  status = 'pending',
  next_attempt_at = now(),
  locked_at = null,
  last_error = null
where record.email_sent_at is null
  and record.snapshot is null
  and record.status = 'failed'
  and coalesce(record.last_error, '') ilike '%DNI%';

commit;
