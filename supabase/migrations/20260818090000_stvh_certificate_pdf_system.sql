-- Sistema de certificado PDF personalizado para la Formación STVH.
--
-- Añade: DNI opcional en profiles, tiempo activo real acumulado en
-- enrollments (con registro auditable en learning_activity_events),
-- columnas de snapshot inmutable en certificates y un código correlativo
-- por año (STVH-YYYY-NNNNNN) generado con una secuencia sin condiciones de
-- carrera. No afecta a ningún otro curso: solo la formación con
-- slug = 'formacion-stvh' escribe en las columnas y funciones nuevas.

begin;

-- 1. DNI opcional en el perfil del alumno --------------------------------

alter table public.profiles
  add column if not exists dni text;

do $$
begin
  alter table public.profiles
    add constraint profiles_dni_format check (
      dni is null or dni ~ '^[0-9XYZxyz][0-9]{7}[A-Za-z]$'
    );
exception
  when duplicate_object then null;
end $$;

grant update (dni) on public.profiles to authenticated;

-- 2. Tiempo activo real acumulado por matrícula --------------------------
-- registered_seconds ya existe y se usa por otros mecanismos; active_seconds
-- es específico del nuevo heartbeat y solo lo escribe la función de abajo.

alter table public.enrollments
  add column if not exists active_seconds bigint not null default 0;

alter table public.enrollments
  add constraint enrollments_active_seconds_non_negative
  check (active_seconds >= 0);

-- Eventos de heartbeat de actividad real (visibilitychange + intervalo).
-- Genérico por diseño (no exclusivo de STVH) para poder reutilizarse en
-- futuras lecciones tipo presentación, pero hoy solo lo emite la vista de
-- lección de STVH.
create table if not exists public.learning_activity_events (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null references public.enrollments (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  session_id uuid not null,
  active_seconds_delta integer not null,
  created_at timestamptz not null default now(),
  constraint learning_activity_events_delta_range
    check (active_seconds_delta >= 0 and active_seconds_delta <= 30)
);

create index if not exists learning_activity_events_enrollment_idx
  on public.learning_activity_events (enrollment_id, created_at desc);

alter table public.learning_activity_events enable row level security;

drop policy if exists learning_activity_events_select_own_or_staff
  on public.learning_activity_events;
create policy learning_activity_events_select_own_or_staff
on public.learning_activity_events
for select
to authenticated
using (
  user_id = (select auth.uid())
  or app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  )
);

revoke all on public.learning_activity_events from public, anon, authenticated;
grant select on public.learning_activity_events to authenticated;

-- RPC de heartbeat: única forma de incrementar active_seconds. El cliente
-- nunca escribe enrollments.active_seconds directamente (no tiene grant de
-- update sobre esa columna), evitando manipulación arbitraria desde el
-- navegador.
create or replace function public.record_stvh_activity_heartbeat(
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
  v_is_owner boolean;
begin
  v_delta := greatest(0, least(30, floor(coalesce(p_delta_seconds, 0))::integer));
  if v_delta <= 0 then
    return;
  end if;

  select true
  into v_is_owner
  from public.enrollments e
  join public.course_versions cv on cv.id = e.course_version_id
  join public.courses c on c.id = cv.course_id
  where e.id = p_enrollment_id
    and e.user_id = (select auth.uid())
    and c.slug = 'formacion-stvh'
    and e.status <> 'completed'::public.enrollment_status;

  if not found then
    return;
  end if;

  insert into public.learning_activity_events (
    enrollment_id, user_id, session_id, active_seconds_delta
  )
  values (p_enrollment_id, (select auth.uid()), p_session_id, v_delta);

  update public.enrollments
  set
    active_seconds = active_seconds + v_delta,
    started_at = coalesce(started_at, now())
  where id = p_enrollment_id;
end;
$$;

revoke all on function public.record_stvh_activity_heartbeat(uuid, uuid, numeric)
  from public, anon;
grant execute on function public.record_stvh_activity_heartbeat(uuid, uuid, numeric)
  to authenticated;

-- 3. Snapshot inmutable y código correlativo en certificates --------------

alter table public.certificates
  add column if not exists holder_dni text,
  add column if not exists started_at timestamptz,
  add column if not exists active_seconds integer,
  add column if not exists validated_by text;

create sequence if not exists public.stvh_certificate_code_seq
  as bigint
  start with 1
  increment by 1;

revoke all on sequence public.stvh_certificate_code_seq from public, anon, authenticated;

-- 4. Emisión: código correlativo STVH-YYYY-NNNNNN + snapshot de DNI,
--    inicio real y tiempo activo acumulado.

create or replace function app_private.issue_stvh_certificate()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_course_title text;
  v_duration_hours integer;
  v_modality public.course_modality;
  v_holder_name text;
  v_holder_dni text;
  v_certificate_code text;
begin
  if new.status <> 'completed'::public.enrollment_status
    or new.completed_at is null
  then
    return new;
  end if;

  select
    c.title,
    cv.duration_hours,
    cv.modality,
    coalesce(
      nullif(btrim(concat_ws(' ', p.first_name, p.last_name)), ''),
      'Alumno/a'
    ),
    p.dni
  into
    v_course_title,
    v_duration_hours,
    v_modality,
    v_holder_name,
    v_holder_dni
  from public.course_versions cv
  join public.courses c on c.id = cv.course_id
  left join public.profiles p on p.id = new.user_id
  where cv.id = new.course_version_id
    and c.slug = 'formacion-stvh';

  if not found then
    return new;
  end if;

  v_certificate_code :=
    'STVH-'
    || extract(year from coalesce(new.completed_at, now()))::text
    || '-'
    || lpad(nextval('public.stvh_certificate_code_seq')::text, 6, '0');

  insert into public.certificates (
    enrollment_id,
    user_id,
    course_version_id,
    certificate_code,
    holder_name,
    holder_dni,
    course_title,
    duration_hours,
    modality,
    completion_date,
    started_at,
    active_seconds,
    validated_by
  )
  values (
    new.id,
    new.user_id,
    new.course_version_id,
    v_certificate_code,
    v_holder_name,
    v_holder_dni,
    v_course_title,
    v_duration_hours,
    v_modality,
    new.completed_at::date,
    coalesce(new.started_at, new.completed_at),
    coalesce(new.active_seconds, 0),
    'Pedro Mesas Riballo'
  )
  on conflict (enrollment_id) do nothing;

  return new;
end;
$$;

revoke all on function app_private.issue_stvh_certificate()
  from public, anon, authenticated;

-- El trigger ya existe (creado en 20260812130058); esta migración solo
-- reemplaza el cuerpo de la función, así que no hace falta recrearlo.

commit;
