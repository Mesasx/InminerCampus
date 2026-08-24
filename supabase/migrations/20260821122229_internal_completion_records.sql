begin;

-- Los certificados oficiales quedan desactivados hasta que exista el flujo
-- definitivo de emisión. Los registros que ya existan se conservan, pero una
-- nueva finalización no crea filas en certificates.
drop trigger if exists enrollments_issue_stvh_certificate
  on public.enrollments;

-- El heartbeat existente era genérico en estructura pero estaba limitado a
-- STVH. Se generaliza para que todos los cursos compartan una sola fuente de
-- tiempo activo real y de días con actividad.
create or replace function public.record_learning_activity_heartbeat(
  p_enrollment_id uuid,
  p_session_id uuid,
  p_delta_seconds numeric
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_delta integer;
begin
  v_delta := greatest(
    0,
    least(30, floor(coalesce(p_delta_seconds, 0))::integer)
  );
  if v_delta <= 0 then
    return;
  end if;

  perform 1
  from public.enrollments e
  where e.id = p_enrollment_id
    and e.user_id = (select auth.uid())
    and e.status not in (
      'completed'::public.enrollment_status,
      'failed'::public.enrollment_status,
      'expired'::public.enrollment_status
    );

  if not found then
    return;
  end if;

  insert into public.learning_activity_events (
    enrollment_id,
    user_id,
    session_id,
    active_seconds_delta
  )
  values (
    p_enrollment_id,
    (select auth.uid()),
    p_session_id,
    v_delta
  );

  update public.enrollments
  set
    active_seconds = active_seconds + v_delta,
    started_at = coalesce(started_at, now())
  where id = p_enrollment_id;
end;
$$;

revoke all on function public.record_learning_activity_heartbeat(
  uuid,
  uuid,
  numeric
) from public, anon;
grant execute on function public.record_learning_activity_heartbeat(
  uuid,
  uuid,
  numeric
) to authenticated;

-- Compatibilidad con clientes que todavía tengan cargado el bundle anterior.
create or replace function public.record_stvh_activity_heartbeat(
  p_enrollment_id uuid,
  p_session_id uuid,
  p_delta_seconds numeric
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  perform public.record_learning_activity_heartbeat(
    p_enrollment_id,
    p_session_id,
    p_delta_seconds
  );
end;
$$;

revoke all on function public.record_stvh_activity_heartbeat(
  uuid,
  uuid,
  numeric
) from public, anon;
grant execute on function public.record_stvh_activity_heartbeat(
  uuid,
  uuid,
  numeric
) to authenticated;

-- Una práctica validada después de terminar la teoría cierra realmente la
-- matrícula y fija completed_at. Antes el flujo se detenía en
-- practice_completed, por lo que nunca disparaba una finalización completa.
create or replace function app_private.sync_practice_validation()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.result = 'passed'::public.practice_result then
    update public.enrollments
    set
      status = case
        when theory_completed_at is not null
          then 'completed'::public.enrollment_status
        else 'practice_completed'::public.enrollment_status
      end,
      completed_at = case
        when theory_completed_at is not null
          then coalesce(completed_at, new.validated_at, now())
        else completed_at
      end,
      progress_percent = case
        when theory_completed_at is not null then 100
        else progress_percent
      end
    where id = new.enrollment_id;
  elsif new.result = 'failed'::public.practice_result then
    update public.enrollments
    set status = 'practice_pending'::public.enrollment_status
    where id = new.enrollment_id
      and status <> 'completed'::public.enrollment_status;
  end if;

  return new;
end;
$$;

revoke all on function app_private.sync_practice_validation()
  from public, anon, authenticated;

create table public.internal_completion_records (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null unique
    references public.enrollments(id) on delete restrict,
  user_id uuid not null references auth.users(id) on delete restrict,
  course_version_id uuid not null
    references public.course_versions(id) on delete restrict,
  status text not null default 'pending',
  attempt_count integer not null default 0,
  next_attempt_at timestamptz default now(),
  locked_at timestamptz,
  generated_at timestamptz,
  snapshot jsonb,
  pdf_storage_path text,
  pdf_sha256 text,
  email_sent_at timestamptz,
  resend_message_id text,
  last_error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint internal_completion_records_status_check check (
    status in ('pending', 'processing', 'sent', 'failed')
  ),
  constraint internal_completion_records_attempts_check
    check (attempt_count >= 0),
  constraint internal_completion_records_snapshot_check
    check (snapshot is null or jsonb_typeof(snapshot) = 'object'),
  constraint internal_completion_records_pdf_check check (
    (pdf_storage_path is null and pdf_sha256 is null)
    or (
      pdf_storage_path is not null
      and pdf_sha256 ~ '^[a-f0-9]{64}$'
      and generated_at is not null
      and snapshot is not null
    )
  ),
  constraint internal_completion_records_email_check check (
    email_sent_at is null
    or (
      status = 'sent'
      and resend_message_id is not null
      and pdf_storage_path is not null
    )
  )
);

create index internal_completion_records_due_idx
  on public.internal_completion_records (status, next_attempt_at, created_at)
  where email_sent_at is null;

alter table public.internal_completion_records enable row level security;
alter table public.internal_completion_records force row level security;

revoke all on public.internal_completion_records
  from public, anon, authenticated;
grant select, insert, update, delete on public.internal_completion_records
  to service_role;

drop trigger if exists internal_completion_records_set_updated_at
  on public.internal_completion_records;
create trigger internal_completion_records_set_updated_at
before update on public.internal_completion_records
for each row execute function app_private.set_updated_at();

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'internal-completion-documents',
  'internal-completion-documents',
  false,
  10485760,
  array['application/pdf']::text[]
)
on conflict (id) do update
set
  public = false,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- No se crea ninguna política de storage para este bucket: solo service_role
-- puede leer o escribir los PDF y nunca se generan URLs firmadas para alumnos.

create or replace function app_private.enqueue_internal_completion()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'completed'::public.enrollment_status
    and new.completed_at is not null
  then
    if tg_op = 'INSERT'
      or (
        tg_op = 'UPDATE'
        and (
          old.status is distinct from new.status
          or old.completed_at is distinct from new.completed_at
        )
      )
    then
      insert into public.internal_completion_records (
        enrollment_id,
        user_id,
        course_version_id,
        status,
        next_attempt_at
      )
      values (
        new.id,
        new.user_id,
        new.course_version_id,
        'pending',
        now()
      )
      on conflict (enrollment_id) do nothing;
    end if;
  end if;

  return new;
end;
$$;

revoke all on function app_private.enqueue_internal_completion()
  from public, anon, authenticated;

drop trigger if exists enrollments_queue_internal_completion
  on public.enrollments;
create trigger enrollments_queue_internal_completion
after insert or update of status, completed_at on public.enrollments
for each row execute function app_private.enqueue_internal_completion();

create or replace function public.claim_internal_completion_jobs(
  p_limit integer default 10,
  p_enrollment_id uuid default null
)
returns setof public.internal_completion_records
language plpgsql
security definer
set search_path = ''
as $$
begin
  return query
  with candidates as (
    select record.id
    from public.internal_completion_records record
    where record.email_sent_at is null
      and (p_enrollment_id is null or record.enrollment_id = p_enrollment_id)
      and (
        (
          record.status in ('pending', 'failed')
          and (
            (p_enrollment_id is not null)
            or (
              record.next_attempt_at is not null
              and record.next_attempt_at <= now()
            )
          )
        )
        or (
          record.status = 'processing'
          and record.locked_at < now() - interval '15 minutes'
        )
      )
    order by record.next_attempt_at nulls first, record.created_at
    for update skip locked
    limit greatest(1, least(coalesce(p_limit, 10), 50))
  )
  update public.internal_completion_records record
  set
    status = 'processing',
    attempt_count = record.attempt_count + 1,
    locked_at = now(),
    last_error = null
  from candidates
  where record.id = candidates.id
  returning record.*;
end;
$$;

revoke all on function public.claim_internal_completion_jobs(integer, uuid)
  from public, anon, authenticated;
grant execute on function public.claim_internal_completion_jobs(integer, uuid)
  to service_role;

create or replace function public.complete_internal_completion_job(
  p_record_id uuid,
  p_success boolean,
  p_retryable boolean,
  p_resend_message_id text,
  p_error text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.internal_completion_records
  set
    status = case when p_success then 'sent' else 'failed' end,
    email_sent_at = case when p_success then now() else email_sent_at end,
    resend_message_id = case
      when p_success then nullif(btrim(p_resend_message_id), '')
      else resend_message_id
    end,
    next_attempt_at = case
      when p_success or not p_retryable or attempt_count >= 6 then null
      when attempt_count = 1 then now() + interval '1 minute'
      when attempt_count = 2 then now() + interval '5 minutes'
      when attempt_count = 3 then now() + interval '15 minutes'
      when attempt_count = 4 then now() + interval '1 hour'
      else now() + interval '6 hours'
    end,
    last_error = case
      when p_success then null
      else left(
        coalesce(nullif(btrim(p_error), ''), 'Unknown completion error'),
        1000
      )
    end,
    locked_at = null
  where id = p_record_id
    and status = 'processing';
end;
$$;

revoke all on function public.complete_internal_completion_job(
  uuid,
  boolean,
  boolean,
  text,
  text
) from public, anon, authenticated;
grant execute on function public.complete_internal_completion_job(
  uuid,
  boolean,
  boolean,
  text,
  text
) to service_role;

comment on table public.internal_completion_records is
  'Cola y trazabilidad privada de registros internos de finalización. Sin acceso de alumno.';

commit;
