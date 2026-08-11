-- InmínerCampus
-- Capacidades de plataforma necesarias para los cursos internos:
--   1. Cursos cuyo acceso es exclusivamente por código (sin pasarela de pago).
--   2. Códigos de acceso generados por el administrador, aleatorios y de un
--      solo uso, sin vincularlos a una compra.
--   3. Lecciones basadas en diapositivas, sin audio ni vídeo.
--   4. Contrato de confidencialidad firmable al terminar el curso.
--
-- Esta migración no modifica el comportamiento de los cursos existentes:
-- todos los valores por defecto reproducen el estado actual.

begin;

-- ---------------------------------------------------------------------------
-- 1. Cursos con acceso por código y cursos no listados en el catálogo público
-- ---------------------------------------------------------------------------

alter table public.courses
  add column if not exists access_mode text not null default 'purchase',
  add column if not exists listed boolean not null default true;

alter table public.courses
  drop constraint if exists courses_access_mode_valid;
alter table public.courses
  add constraint courses_access_mode_valid check (
    access_mode in ('purchase', 'access_code')
  );

comment on column public.courses.access_mode is
  'purchase: alta por compra o código de empresa. access_code: únicamente mediante código emitido por administración.';
comment on column public.courses.listed is
  'false oculta el curso del catálogo público sin despublicarlo.';

-- Las formaciones internas no encajan en la horquilla 5/20 h del catálogo
-- oficial; se amplía la comprobación manteniendo un valor razonable.
alter table public.course_versions
  drop constraint if exists course_versions_duration;
alter table public.course_versions
  add constraint course_versions_duration check (
    duration_hours between 1 and 200
  );

-- ---------------------------------------------------------------------------
-- 2. Códigos de acceso emitidos por administración
-- ---------------------------------------------------------------------------

alter table public.access_codes
  alter column purchase_item_id drop not null;

alter table public.access_codes
  add column if not exists created_by uuid references auth.users(id) on delete set null,
  add column if not exists note text;

alter table public.access_codes
  drop constraint if exists access_codes_origin_required;
alter table public.access_codes
  add constraint access_codes_origin_required check (
    purchase_item_id is not null or created_by is not null
  );

create index if not exists access_codes_created_by_idx
  on public.access_codes (created_by)
  where created_by is not null;

create index if not exists access_codes_version_status_idx
  on public.access_codes (course_version_id, status, created_at desc);

-- Alfabeto sin caracteres ambiguos (sin I, O, 0, 1).
create or replace function app_private.generate_access_code_text()
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  raw_bytes bytea;
  block_text text := '';
  index_position integer;
begin
  raw_bytes := extensions.gen_random_bytes(12);
  for index_position in 0..11 loop
    block_text := block_text || substr(
      alphabet,
      (get_byte(raw_bytes, index_position) % 32) + 1,
      1
    );
  end loop;

  return 'INM-'
    || substr(block_text, 1, 4) || '-'
    || substr(block_text, 5, 4) || '-'
    || substr(block_text, 9, 4);
end;
$$;

revoke all on function app_private.generate_access_code_text()
  from public, anon, authenticated;

-- Genera y devuelve UN código nuevo en texto plano. El texto plano solo se
-- devuelve en esta llamada: en la base de datos únicamente queda su hash.
create or replace function public.admin_generate_access_code(
  p_course_version_id uuid,
  p_note text default null,
  p_expires_at timestamptz default null
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  candidate_code text;
  inserted_id uuid;
  attempt integer := 0;
begin
  if not (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  )) then
    raise exception using errcode = '42501',
      message = 'Solo administración puede emitir códigos de acceso.';
  end if;

  if not exists (
    select 1 from public.course_versions cv where cv.id = p_course_version_id
  ) then
    raise exception using errcode = '22023',
      message = 'La versión del curso no existe.';
  end if;

  if p_expires_at is not null and p_expires_at <= now() then
    raise exception using errcode = '22023',
      message = 'La fecha de caducidad debe ser futura.';
  end if;

  loop
    attempt := attempt + 1;
    candidate_code := app_private.generate_access_code_text();

    begin
      insert into public.access_codes (
        purchase_item_id,
        course_version_id,
        organization_id,
        code_hash,
        code_last_four,
        status,
        expires_at,
        created_by,
        note
      )
      values (
        null,
        p_course_version_id,
        null,
        extensions.digest(candidate_code, 'sha256'),
        right(candidate_code, 4),
        'available',
        p_expires_at,
        current_user_id,
        nullif(trim(coalesce(p_note, '')), '')
      )
      returning id into inserted_id;

      exit;
    exception
      when unique_violation then
        if attempt >= 5 then
          raise exception using errcode = '40001',
            message = 'No se ha podido generar un código único, inténtelo de nuevo.';
        end if;
    end;
  end loop;

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
    null,
    'access_code.admin_generated',
    'access_code',
    inserted_id::text,
    jsonb_build_object('course_version_id', p_course_version_id)
  );

  return jsonb_build_object(
    'id', inserted_id,
    'code', candidate_code,
    'expiresAt', p_expires_at
  );
end;
$$;

revoke all on function public.admin_generate_access_code(uuid, text, timestamptz)
  from public, anon;
grant execute on function public.admin_generate_access_code(uuid, text, timestamptz)
  to authenticated;

create or replace function public.admin_list_access_codes(
  p_course_version_id uuid default null
)
returns table (
  id uuid,
  course_version_id uuid,
  course_title text,
  code_last_four text,
  status public.access_code_status,
  note text,
  expires_at timestamptz,
  created_at timestamptz,
  used_at timestamptz,
  used_by_email text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  )) then
    raise exception using errcode = '42501',
      message = 'Solo administración puede consultar los códigos de acceso.';
  end if;

  return query
  select
    ac.id,
    ac.course_version_id,
    c.title,
    ac.code_last_four,
    ac.status,
    ac.note,
    ac.expires_at,
    ac.created_at,
    ac.used_at,
    u.email::text
  from public.access_codes ac
  join public.course_versions cv on cv.id = ac.course_version_id
  join public.courses c on c.id = cv.course_id
  left join auth.users u on u.id = ac.used_by
  where ac.created_by is not null
    and (p_course_version_id is null or ac.course_version_id = p_course_version_id)
  order by ac.created_at desc
  limit 300;
end;
$$;

revoke all on function public.admin_list_access_codes(uuid) from public, anon;
grant execute on function public.admin_list_access_codes(uuid) to authenticated;

create or replace function public.admin_revoke_access_code(p_access_code_id uuid)
returns boolean
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  affected integer;
begin
  if not (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  )) then
    raise exception using errcode = '42501',
      message = 'Solo administración puede anular códigos de acceso.';
  end if;

  update public.access_codes
  set
    status = 'revoked',
    revoked_by = current_user_id,
    revoked_at = now(),
    updated_at = now()
  where id = p_access_code_id
    and status in ('available', 'reserved');

  get diagnostics affected = row_count;

  if affected = 0 then
    return false;
  end if;

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
    null,
    'access_code.admin_revoked',
    'access_code',
    p_access_code_id::text,
    '{}'::jsonb
  );

  return true;
end;
$$;

revoke all on function public.admin_revoke_access_code(uuid) from public, anon;
grant execute on function public.admin_revoke_access_code(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- 3. Lecciones basadas en diapositivas (sin audio)
-- ---------------------------------------------------------------------------

alter table public.lessons
  add column if not exists content_mode text not null default 'audio';

alter table public.lessons
  drop constraint if exists lessons_content_mode_valid;
alter table public.lessons
  add constraint lessons_content_mode_valid check (
    content_mode in ('audio', 'slides')
  );

comment on column public.lessons.content_mode is
  'audio: bloques narrados con diapositivas de apoyo. slides: presentación sin audio.';

-- Un capítulo de diapositivas puede publicarse sin fichero de audio siempre
-- que la lección sea de tipo «slides». La comprobación pasa de CHECK a
-- disparador porque necesita consultar la lección padre.
alter table public.lesson_audio_segments
  drop constraint if exists lesson_audio_segments_publishable;

create or replace function app_private.validate_segment_publishable()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  parent_mode text;
begin
  if not new.published then
    return new;
  end if;

  if new.audio_storage_path is not null or new.audio_external_url is not null then
    return new;
  end if;

  select l.content_mode into parent_mode
  from public.lessons l
  where l.id = new.lesson_id;

  if parent_mode is distinct from 'slides' then
    raise exception
      'Un capítulo sin audio solo puede publicarse en lecciones de tipo «slides»';
  end if;

  return new;
end;
$$;

revoke all on function app_private.validate_segment_publishable()
  from public, anon, authenticated;

drop trigger if exists lesson_audio_segments_validate_publishable
  on public.lesson_audio_segments;
create trigger lesson_audio_segments_validate_publishable
before insert or update on public.lesson_audio_segments
for each row execute function app_private.validate_segment_publishable();

-- El disparador que protege el test debe seguir exigiendo que se haya
-- recorrido todo el contenido, tanto si es audio como si son diapositivas.
create or replace function app_private.require_audio_before_quiz()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if exists (
    select 1
    from public.quizzes q
    join public.lesson_audio_segments s on s.lesson_id = q.lesson_id
    where q.id = new.quiz_id
      and (
        s.published = false
        or not exists (
          select 1
          from public.lesson_audio_progress p
          where p.enrollment_id = new.enrollment_id
            and p.segment_id = s.id
            and p.completed_at is not null
        )
      )
  ) then
    raise exception 'Complete todo el contenido de la lección antes de iniciar el test';
  end if;

  return new;
end;
$$;

-- Registro de avance en lecciones de diapositivas. Replica la lógica de
-- record_audio_segment_progress pero sin control de reproducción temporal:
-- exige haber visto todas las diapositivas del capítulo y respeta el orden.
create or replace function public.record_slide_chapter_progress(
  p_enrollment_id uuid,
  p_segment_id uuid,
  p_slides_viewed integer
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  v_lesson_id uuid;
  v_segment_position smallint;
  v_slide_count integer;
  v_completed_at timestamptz;
  v_lesson_complete boolean := false;
  v_has_quiz boolean := false;
  v_completed_lessons integer := 0;
  v_total_lessons integer := 0;
  v_next_lesson_id uuid;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  select s.lesson_id, s.position
  into v_lesson_id, v_segment_position
  from public.lesson_audio_segments s
  join public.lessons l on l.id = s.lesson_id
  join public.course_modules m on m.id = l.module_id
  join public.enrollments e on e.course_version_id = m.course_version_id
  join public.lesson_progress lp
    on lp.enrollment_id = e.id
   and lp.lesson_id = l.id
  where s.id = p_segment_id
    and s.published = true
    and l.content_mode = 'slides'
    and e.id = p_enrollment_id
    and e.user_id = current_user_id
    and e.status not in ('failed', 'expired')
    and lp.status <> 'locked';

  if not found then
    raise exception 'El capítulo de diapositivas no está disponible';
  end if;

  if exists (
    select 1
    from public.lesson_audio_segments previous_segment
    where previous_segment.lesson_id = v_lesson_id
      and previous_segment.published = true
      and previous_segment.position < v_segment_position
      and not exists (
        select 1
        from public.lesson_audio_progress previous_progress
        where previous_progress.enrollment_id = p_enrollment_id
          and previous_progress.segment_id = previous_segment.id
          and previous_progress.completed_at is not null
      )
  ) then
    raise exception 'Debe completar antes los capítulos anteriores';
  end if;

  select count(*) into v_slide_count
  from public.lesson_segment_slides
  where segment_id = p_segment_id;

  insert into public.lesson_audio_progress (
    enrollment_id,
    segment_id,
    max_position_seconds
  )
  values (p_enrollment_id, p_segment_id, 0)
  on conflict (enrollment_id, segment_id) do nothing;

  select completed_at into v_completed_at
  from public.lesson_audio_progress
  where enrollment_id = p_enrollment_id
    and segment_id = p_segment_id
  for update;

  if v_completed_at is null
    and v_slide_count > 0
    and coalesce(p_slides_viewed, 0) >= v_slide_count then
    v_completed_at := now();
  end if;

  update public.lesson_audio_progress
  set
    max_position_seconds = greatest(
      max_position_seconds,
      least(coalesce(p_slides_viewed, 0), v_slide_count)
    ),
    completed_at = v_completed_at
  where enrollment_id = p_enrollment_id
    and segment_id = p_segment_id;

  update public.lesson_progress
  set
    status = case
      when status = 'available' then 'in_progress'::public.lesson_progress_status
      else status
    end,
    first_started_at = coalesce(first_started_at, now()),
    last_activity_at = now()
  where enrollment_id = p_enrollment_id
    and lesson_id = v_lesson_id;

  select not exists (
    select 1
    from public.lesson_audio_segments required_segment
    where required_segment.lesson_id = v_lesson_id
      and required_segment.published = true
      and not exists (
        select 1
        from public.lesson_audio_progress completed_progress
        where completed_progress.enrollment_id = p_enrollment_id
          and completed_progress.segment_id = required_segment.id
          and completed_progress.completed_at is not null
      )
  )
  and exists (
    select 1
    from public.lesson_audio_segments published_segment
    where published_segment.lesson_id = v_lesson_id
      and published_segment.published = true
  )
  into v_lesson_complete;

  if v_lesson_complete then
    select exists (
      select 1 from public.quizzes q
      where q.lesson_id = v_lesson_id and q.active = true
    ) into v_has_quiz;

    if v_has_quiz then
      update public.lesson_progress
      set status = 'in_progress', last_activity_at = now()
      where enrollment_id = p_enrollment_id
        and lesson_id = v_lesson_id;
    else
      update public.lesson_progress
      set
        status = 'completed',
        completed_at = coalesce(completed_at, now()),
        last_activity_at = now()
      where enrollment_id = p_enrollment_id
        and lesson_id = v_lesson_id;

      select next_lesson.id
      into v_next_lesson_id
      from public.lessons current_lesson
      join public.course_modules current_module
        on current_module.id = current_lesson.module_id
      join public.course_modules next_module
        on next_module.course_version_id = current_module.course_version_id
      join public.lessons next_lesson
        on next_lesson.module_id = next_module.id
      where current_lesson.id = v_lesson_id
        and next_lesson.active = true
        and (next_module.position, next_lesson.position)
          > (current_module.position, current_lesson.position)
      order by next_module.position, next_lesson.position
      limit 1;

      if v_next_lesson_id is not null then
        update public.lesson_progress
        set status = 'available'
        where enrollment_id = p_enrollment_id
          and lesson_id = v_next_lesson_id
          and status = 'locked';
      end if;
    end if;
  end if;

  select
    count(*) filter (where lp.status = 'completed'),
    count(*)
  into v_completed_lessons, v_total_lessons
  from public.lesson_progress lp
  where lp.enrollment_id = p_enrollment_id;

  update public.enrollments
  set
    progress_percent = case
      when v_total_lessons = 0 then 0
      else round((v_completed_lessons::numeric / v_total_lessons::numeric) * 100, 2)
    end,
    status = case
      when status = 'not_started' then 'in_progress'::public.enrollment_status
      else status
    end,
    started_at = coalesce(started_at, now())
  where id = p_enrollment_id;

  return jsonb_build_object(
    'slidesViewed', least(coalesce(p_slides_viewed, 0), v_slide_count),
    'slideCount', v_slide_count,
    'completed', v_completed_at is not null,
    'lessonCompleted', v_lesson_complete
  );
end;
$$;

revoke all on function public.record_slide_chapter_progress(uuid, uuid, integer)
  from public, anon;
grant execute on function public.record_slide_chapter_progress(uuid, uuid, integer)
  to authenticated;

-- ---------------------------------------------------------------------------
-- 4. Contrato de confidencialidad
-- ---------------------------------------------------------------------------

create table if not exists public.confidentiality_agreements (
  id uuid primary key default gen_random_uuid(),
  course_version_id uuid not null
    references public.course_versions(id) on delete cascade,
  version_number integer not null default 1,
  title text not null,
  body text not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_version_id, version_number),
  constraint confidentiality_agreements_title_length check (
    char_length(title) between 3 and 240
  ),
  constraint confidentiality_agreements_body_length check (
    char_length(body) between 50 and 40000
  )
);

create index if not exists confidentiality_agreements_version_idx
  on public.confidentiality_agreements (course_version_id, active);

create table if not exists public.confidentiality_signatures (
  id uuid primary key default gen_random_uuid(),
  agreement_id uuid not null
    references public.confidentiality_agreements(id) on delete restrict,
  enrollment_id uuid not null unique
    references public.enrollments(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  signed_full_name text not null,
  signed_document_id text not null,
  signed_at timestamptz not null default now(),
  user_agent text,
  created_at timestamptz not null default now(),
  constraint confidentiality_signatures_name_length check (
    char_length(signed_full_name) between 3 and 200
  ),
  constraint confidentiality_signatures_document_length check (
    char_length(signed_document_id) between 5 and 40
  )
);

create index if not exists confidentiality_signatures_user_idx
  on public.confidentiality_signatures (user_id, signed_at desc);
create index if not exists confidentiality_signatures_agreement_idx
  on public.confidentiality_signatures (agreement_id);

drop trigger if exists confidentiality_agreements_set_updated_at
  on public.confidentiality_agreements;
create trigger confidentiality_agreements_set_updated_at
before update on public.confidentiality_agreements
for each row execute function app_private.set_updated_at();

alter table public.confidentiality_agreements enable row level security;
alter table public.confidentiality_signatures enable row level security;

drop policy if exists confidentiality_agreements_visible
  on public.confidentiality_agreements;
create policy confidentiality_agreements_visible
on public.confidentiality_agreements for select
to authenticated
using (
  (
    active
    and (select app_private.current_user_is_enrolled(course_version_id))
  )
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists confidentiality_agreements_admin_manage
  on public.confidentiality_agreements;
create policy confidentiality_agreements_admin_manage
on public.confidentiality_agreements for all
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

drop policy if exists confidentiality_signatures_visible
  on public.confidentiality_signatures;
create policy confidentiality_signatures_visible
on public.confidentiality_signatures for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

revoke all on public.confidentiality_agreements from anon, authenticated;
revoke all on public.confidentiality_signatures from anon, authenticated;
grant select on public.confidentiality_agreements to authenticated;
grant insert, update, delete on public.confidentiality_agreements to authenticated;
grant select on public.confidentiality_signatures to authenticated;

-- La firma se realiza siempre por función: garantiza que el curso está
-- terminado y evita que el alumno pueda escribir datos arbitrarios.
create or replace function public.sign_confidentiality_agreement(
  p_enrollment_id uuid,
  p_full_name text,
  p_document_id text,
  p_user_agent text default null
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  v_course_version_id uuid;
  v_status public.enrollment_status;
  v_agreement_id uuid;
  v_signature_id uuid;
  v_signed_at timestamptz;
  v_full_name text := trim(coalesce(p_full_name, ''));
  v_document_id text := upper(trim(coalesce(p_document_id, '')));
begin
  if current_user_id is null then
    raise exception using errcode = '42501',
      message = 'Debes iniciar sesión para firmar el contrato.';
  end if;

  if char_length(v_full_name) < 3 then
    raise exception using errcode = '22023',
      message = 'Indica tu nombre y apellidos completos.';
  end if;

  if char_length(v_document_id) < 5 then
    raise exception using errcode = '22023',
      message = 'Indica un documento de identidad válido.';
  end if;

  select e.course_version_id, e.status
  into v_course_version_id, v_status
  from public.enrollments e
  where e.id = p_enrollment_id
    and e.user_id = current_user_id;

  if not found then
    raise exception using errcode = '42501',
      message = 'No tienes acceso a esta matrícula.';
  end if;

  if v_status not in ('completed', 'theory_passed', 'practice_completed') then
    raise exception using errcode = '22023',
      message = 'Debes completar el curso antes de firmar el contrato.';
  end if;

  select id into v_agreement_id
  from public.confidentiality_agreements
  where course_version_id = v_course_version_id
    and active
  order by version_number desc
  limit 1;

  if v_agreement_id is null then
    raise exception using errcode = '22023',
      message = 'Este curso no tiene contrato de confidencialidad publicado.';
  end if;

  insert into public.confidentiality_signatures (
    agreement_id,
    enrollment_id,
    user_id,
    signed_full_name,
    signed_document_id,
    user_agent
  )
  values (
    v_agreement_id,
    p_enrollment_id,
    current_user_id,
    v_full_name,
    v_document_id,
    left(coalesce(p_user_agent, ''), 400)
  )
  on conflict (enrollment_id) do nothing
  returning id, signed_at into v_signature_id, v_signed_at;

  if v_signature_id is null then
    select id, signed_at into v_signature_id, v_signed_at
    from public.confidentiality_signatures
    where enrollment_id = p_enrollment_id;
  else
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
      null,
      'confidentiality.signed',
      'enrollment',
      p_enrollment_id::text,
      jsonb_build_object('agreement_id', v_agreement_id)
    );
  end if;

  return jsonb_build_object(
    'signatureId', v_signature_id,
    'signedAt', v_signed_at
  );
end;
$$;

revoke all on function public.sign_confidentiality_agreement(uuid, text, text, text)
  from public, anon;
grant execute on function public.sign_confidentiality_agreement(uuid, text, text, text)
  to authenticated;

commit;
