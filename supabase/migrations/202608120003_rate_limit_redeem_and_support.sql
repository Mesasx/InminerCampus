-- Auditoría de seguridad: ni el canje de códigos de acceso
-- (redeem_access_code) ni la apertura de hilos de soporte
-- (create_support_thread) tenían ningún límite de frecuencia. Un usuario
-- autenticado podía reintentar códigos de acceso sin límite (el código
-- tiene ~60 bits de entropía, pero nada impedía fuerza bruta contra ese
-- espacio salvo la latencia de red) o inundar de hilos el buzón de
-- soporte. Login, registro y recuperación de contraseña usan
-- `supabase.auth.*` directamente desde el navegador (no pasan por una
-- función propia), así que su límite de frecuencia sigue dependiendo de
-- los límites nativos de Supabase Auth — ver el informe de auditoría para
-- la recomendación de configuración correspondiente.
--
-- Este límite es deliberadamente por usuario autenticado (auth.uid()), no
-- por IP: dentro de una función de Postgres no hay forma fiable de conocer
-- la IP real del cliente (la cabecera que llega a PostgREST puede venir de
-- un proxy), y ambas funciones ya exigen sesión iniciada.

begin;

create table if not exists app_private.rate_limit_hits (
  id bigint generated always as identity primary key,
  scope text not null,
  subject uuid not null,
  created_at timestamptz not null default now()
);

create index if not exists rate_limit_hits_scope_subject_idx
  on app_private.rate_limit_hits (scope, subject, created_at desc);

alter table app_private.rate_limit_hits enable row level security;
-- Sin políticas: la tabla solo se lee/escribe desde
-- app_private.check_rate_limit (security definer). anon/authenticated no
-- tienen ningún privilegio directo sobre ella.
revoke all on table app_private.rate_limit_hits from public, anon, authenticated;

create or replace function app_private.check_rate_limit(
  p_scope text,
  p_subject uuid,
  p_max_attempts integer,
  p_window interval
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count integer;
begin
  delete from app_private.rate_limit_hits
  where scope = p_scope
    and subject = p_subject
    and created_at < now() - p_window;

  select count(*) into v_count
  from app_private.rate_limit_hits
  where scope = p_scope
    and subject = p_subject
    and created_at >= now() - p_window;

  if v_count >= p_max_attempts then
    return false;
  end if;

  insert into app_private.rate_limit_hits (scope, subject) values (p_scope, p_subject);
  return true;
end;
$$;

revoke all on function app_private.check_rate_limit(text, uuid, integer, interval)
  from public, anon, authenticated;

-- redeem_access_code: máximo 8 intentos (válidos o no) cada 15 minutos por
-- usuario. Se cuenta cada intento, no solo los fallidos, para no dar pistas
-- de cuántos han fallado.
create or replace function public.redeem_access_code(input_code text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  matched_code public.access_codes%rowtype;
  enrollment_id uuid;
begin
  if current_user_id is null then
    raise exception using errcode = '42501', message = 'Debes iniciar sesión para canjear un código.';
  end if;

  if not (select app_private.check_rate_limit('redeem_access_code', current_user_id, 8, interval '15 minutes')) then
    raise exception using errcode = 'P0001', message = 'Demasiados intentos de canje. Espera unos minutos antes de volver a intentarlo.';
  end if;

  if input_code is null or char_length(trim(input_code)) < 8 then
    raise exception using errcode = '22023', message = 'El código no tiene un formato válido.';
  end if;

  select ac.*
  into matched_code
  from public.access_codes ac
  where ac.code_hash = extensions.digest(upper(trim(input_code)), 'sha256')
  for update;

  if not found then
    raise exception using errcode = '22023', message = 'El código no es válido.';
  end if;

  if matched_code.status not in ('available', 'reserved') then
    raise exception using errcode = '22023', message = 'El código ya no está disponible.';
  end if;

  if matched_code.expires_at is not null and matched_code.expires_at <= now() then
    update public.access_codes
    set status = 'expired', updated_at = now()
    where id = matched_code.id;
    raise exception using errcode = '22023', message = 'El código ha caducado.';
  end if;

  if matched_code.reserved_for_email is not null
     and lower(matched_code.reserved_for_email) <> lower(
       coalesce((select email from auth.users where id = current_user_id), '')
     ) then
    raise exception using errcode = '42501', message = 'El código está reservado para otra dirección de correo.';
  end if;

  if exists (
    select 1
    from public.enrollments e
    where e.user_id = current_user_id
      and e.course_version_id = matched_code.course_version_id
  ) then
    raise exception using errcode = '23505', message = 'Ya tienes una matrícula para este curso.';
  end if;

  insert into public.enrollments (
    user_id,
    course_version_id,
    organization_id,
    source_type,
    source_reference,
    status
  )
  values (
    current_user_id,
    matched_code.course_version_id,
    matched_code.organization_id,
    'access_code',
    matched_code.id::text,
    'not_started'
  )
  on conflict (user_id, course_version_id) do nothing
  returning id into enrollment_id;

  if enrollment_id is null then
    select e.id into enrollment_id
    from public.enrollments e
    where e.user_id = current_user_id
      and e.course_version_id = matched_code.course_version_id;
  end if;

  update public.access_codes
  set
    status = 'used',
    used_by = current_user_id,
    used_at = now(),
    updated_at = now()
  where id = matched_code.id;

  insert into public.audit_logs (
    actor_user_id,
    organization_id,
    action,
    entity_type,
    entity_id,
    payload
  )
  values (
    current_user_id,
    matched_code.organization_id,
    'access_code.redeemed',
    'access_code',
    matched_code.id::text,
    jsonb_build_object('enrollment_id', enrollment_id)
  );

  return enrollment_id;
end;
$$;

-- create_support_thread: máximo 5 hilos nuevos cada 60 minutos por usuario.
create or replace function public.create_support_thread(
  p_subject text,
  p_body text,
  p_enrollment_id uuid default null,
  p_lesson_id uuid default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  new_thread_id uuid;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  if not (select app_private.check_rate_limit('create_support_thread', current_user_id, 5, interval '60 minutes')) then
    raise exception 'Too many support threads. Please wait before opening another one.';
  end if;

  if char_length(trim(p_subject)) not between 3 and 240 then
    raise exception 'Invalid subject';
  end if;

  if char_length(trim(p_body)) not between 1 and 10000 then
    raise exception 'Invalid message';
  end if;

  if p_enrollment_id is not null and not exists (
    select 1
    from public.enrollments e
    where e.id = p_enrollment_id
      and e.user_id = current_user_id
  ) then
    raise exception 'Enrollment is not available';
  end if;

  if p_lesson_id is not null and (
    p_enrollment_id is null
    or not exists (
      select 1
      from public.enrollments e
      join public.course_modules m
        on m.course_version_id = e.course_version_id
      join public.lessons l on l.module_id = m.id
      where e.id = p_enrollment_id
        and e.user_id = current_user_id
        and l.id = p_lesson_id
    )
  ) then
    raise exception 'Lesson is not part of enrollment';
  end if;

  insert into public.support_threads (
    user_id,
    enrollment_id,
    lesson_id,
    subject,
    status
  )
  values (
    current_user_id,
    p_enrollment_id,
    p_lesson_id,
    trim(p_subject),
    'new'
  )
  returning id into new_thread_id;

  insert into public.support_messages (
    thread_id,
    sender_user_id,
    body
  )
  values (
    new_thread_id,
    current_user_id,
    trim(p_body)
  );

  return new_thread_id;
end;
$$;

commit;
