begin;

do $$
begin
  create type public.purchase_kind as enum ('individual', 'company');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.purchase_status as enum (
    'draft',
    'checkout_created',
    'payment_pending',
    'paid',
    'payment_failed',
    'refunded',
    'partially_refunded',
    'cancelled'
  );
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.access_code_status as enum ('available', 'reserved', 'used', 'expired', 'revoked');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.practice_session_status as enum ('draft', 'scheduled', 'completed', 'cancelled');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.practice_result as enum ('scheduled', 'present', 'absent', 'passed', 'failed', 'pending_validation');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.support_status as enum ('new', 'in_review', 'answered', 'closed');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.certificate_status as enum ('valid', 'revoked', 'replaced');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.webhook_event_status as enum ('received', 'processed', 'failed', 'ignored');
exception
  when duplicate_object then null;
end $$;

create table if not exists public.purchases (
  id uuid primary key default gen_random_uuid(),
  order_number text not null,
  kind public.purchase_kind not null,
  buyer_user_id uuid references auth.users(id) on delete set null,
  organization_id uuid references public.organizations(id) on delete set null,
  status public.purchase_status not null default 'draft',
  stripe_customer_id text,
  stripe_checkout_session_id text,
  stripe_payment_intent_id text,
  stripe_invoice_id text,
  stripe_invoice_url text,
  subtotal_net numeric(12,2) not null default 0,
  tax_amount numeric(12,2) not null default 0,
  total_amount numeric(12,2) not null default 0,
  currency text not null default 'EUR',
  billing_details jsonb not null default '{}'::jsonb,
  idempotency_key text not null,
  paid_at timestamptz,
  refunded_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint purchases_order_number_length check (char_length(order_number) between 6 and 60),
  constraint purchases_amounts_nonnegative check (
    subtotal_net >= 0 and tax_amount >= 0 and total_amount >= 0
  ),
  constraint purchases_total_consistency check (total_amount = subtotal_net + tax_amount),
  constraint purchases_currency check (currency ~ '^[A-Z]{3}$'),
  constraint purchases_billing_details_object check (jsonb_typeof(billing_details) = 'object'),
  constraint purchases_company_org_required check (
    kind <> 'company' or organization_id is not null
  )
);

create unique index if not exists purchases_order_number_unique_idx
  on public.purchases (order_number);
create unique index if not exists purchases_idempotency_key_unique_idx
  on public.purchases (idempotency_key);
create unique index if not exists purchases_checkout_session_unique_idx
  on public.purchases (stripe_checkout_session_id)
  where stripe_checkout_session_id is not null;
create unique index if not exists purchases_payment_intent_unique_idx
  on public.purchases (stripe_payment_intent_id)
  where stripe_payment_intent_id is not null;
create index if not exists purchases_buyer_status_idx
  on public.purchases (buyer_user_id, status, created_at desc);
create index if not exists purchases_org_status_idx
  on public.purchases (organization_id, status, created_at desc)
  where organization_id is not null;

create table if not exists public.purchase_items (
  id uuid primary key default gen_random_uuid(),
  purchase_id uuid not null references public.purchases(id) on delete cascade,
  course_version_id uuid not null references public.course_versions(id) on delete restrict,
  quantity integer not null default 1,
  unit_net numeric(12,2) not null,
  tax_rate numeric(5,2) not null,
  line_net numeric(12,2) not null,
  line_tax numeric(12,2) not null,
  line_total numeric(12,2) not null,
  currency text not null default 'EUR',
  created_at timestamptz not null default now(),
  constraint purchase_items_quantity_positive check (quantity > 0),
  constraint purchase_items_amounts_nonnegative check (
    unit_net >= 0 and line_net >= 0 and line_tax >= 0 and line_total >= 0
  ),
  constraint purchase_items_line_consistency check (line_total = line_net + line_tax),
  constraint purchase_items_currency check (currency ~ '^[A-Z]{3}$')
);

create index if not exists purchase_items_purchase_idx
  on public.purchase_items (purchase_id);
create index if not exists purchase_items_version_idx
  on public.purchase_items (course_version_id);

create table if not exists public.access_codes (
  id uuid primary key default gen_random_uuid(),
  purchase_item_id uuid not null references public.purchase_items(id) on delete cascade,
  course_version_id uuid not null references public.course_versions(id) on delete restrict,
  organization_id uuid references public.organizations(id) on delete set null,
  code_hash bytea not null,
  code_last_four text not null,
  status public.access_code_status not null default 'available',
  reserved_for_email text,
  reserved_at timestamptz,
  used_by uuid references auth.users(id) on delete set null,
  used_at timestamptz,
  expires_at timestamptz,
  revoked_by uuid references auth.users(id) on delete set null,
  revoked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint access_codes_last_four_length check (char_length(code_last_four) = 4),
  constraint access_codes_used_consistency check (
    (status <> 'used') or (used_by is not null and used_at is not null)
  ),
  constraint access_codes_revoked_consistency check (
    (status <> 'revoked') or revoked_at is not null
  )
);

create unique index if not exists access_codes_hash_unique_idx
  on public.access_codes (code_hash);
create index if not exists access_codes_purchase_status_idx
  on public.access_codes (purchase_item_id, status);
create index if not exists access_codes_org_status_idx
  on public.access_codes (organization_id, status)
  where organization_id is not null;
create index if not exists access_codes_expiry_idx
  on public.access_codes (expires_at)
  where expires_at is not null and status in ('available', 'reserved');

create table if not exists public.stripe_webhook_events (
  stripe_event_id text primary key,
  event_type text not null,
  status public.webhook_event_status not null default 'received',
  livemode boolean not null,
  related_purchase_id uuid references public.purchases(id) on delete set null,
  attempt_count integer not null default 0,
  last_error text,
  received_at timestamptz not null default now(),
  processed_at timestamptz,
  updated_at timestamptz not null default now(),
  constraint stripe_webhook_attempts_nonnegative check (attempt_count >= 0),
  constraint stripe_webhook_event_id_length check (char_length(stripe_event_id) between 5 and 255)
);

create index if not exists stripe_webhook_status_received_idx
  on public.stripe_webhook_events (status, received_at);

create table if not exists public.practice_sessions (
  id uuid primary key default gen_random_uuid(),
  course_version_id uuid not null references public.course_versions(id) on delete restrict,
  title text not null,
  venue_name text not null,
  venue_address text not null default '',
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  capacity integer,
  tutor_user_id uuid references auth.users(id) on delete set null,
  status public.practice_session_status not null default 'draft',
  notes text,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint practice_sessions_time_order check (ends_at > starts_at),
  constraint practice_sessions_capacity_positive check (capacity is null or capacity > 0),
  constraint practice_sessions_title_length check (char_length(title) between 2 and 240)
);

create index if not exists practice_sessions_version_start_idx
  on public.practice_sessions (course_version_id, starts_at);
create index if not exists practice_sessions_tutor_start_idx
  on public.practice_sessions (tutor_user_id, starts_at)
  where tutor_user_id is not null;

create table if not exists public.practice_attendance (
  id uuid primary key default gen_random_uuid(),
  practice_session_id uuid not null references public.practice_sessions(id) on delete cascade,
  enrollment_id uuid not null references public.enrollments(id) on delete cascade,
  result public.practice_result not null default 'scheduled',
  checked_in_at timestamptz,
  checked_out_at timestamptz,
  evidence_storage_path text,
  observations text,
  learner_confirmed_at timestamptz,
  validated_by uuid references auth.users(id) on delete set null,
  validated_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (practice_session_id, enrollment_id),
  constraint practice_attendance_time_order check (
    checked_out_at is null or checked_in_at is null or checked_out_at >= checked_in_at
  ),
  constraint practice_attendance_validation_consistency check (
    result not in ('passed', 'failed')
    or (validated_by is not null and validated_at is not null)
  )
);

create index if not exists practice_attendance_enrollment_idx
  on public.practice_attendance (enrollment_id, result);
create index if not exists practice_attendance_session_result_idx
  on public.practice_attendance (practice_session_id, result);

create table if not exists public.support_threads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  enrollment_id uuid references public.enrollments(id) on delete set null,
  lesson_id uuid references public.lessons(id) on delete set null,
  assigned_tutor_id uuid references auth.users(id) on delete set null,
  subject text not null,
  status public.support_status not null default 'new',
  last_message_at timestamptz not null default now(),
  closed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint support_threads_subject_length check (char_length(subject) between 3 and 240)
);

create index if not exists support_threads_user_status_idx
  on public.support_threads (user_id, status, last_message_at desc);
create index if not exists support_threads_tutor_status_idx
  on public.support_threads (assigned_tutor_id, status, last_message_at desc)
  where assigned_tutor_id is not null;

create table if not exists public.support_messages (
  id uuid primary key default gen_random_uuid(),
  thread_id uuid not null references public.support_threads(id) on delete cascade,
  sender_user_id uuid not null references auth.users(id) on delete cascade,
  body text not null,
  attachment_storage_path text,
  created_at timestamptz not null default now(),
  edited_at timestamptz,
  constraint support_messages_body_length check (char_length(body) between 1 and 10000)
);

create index if not exists support_messages_thread_time_idx
  on public.support_messages (thread_id, created_at);

create or replace function app_private.touch_support_thread()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.support_threads
  set last_message_at = new.created_at
  where id = new.thread_id;
  return new;
end;
$$;

drop trigger if exists support_messages_touch_thread on public.support_messages;
create trigger support_messages_touch_thread
after insert on public.support_messages
for each row execute function app_private.touch_support_thread();

revoke execute on function app_private.touch_support_thread() from public, anon, authenticated;

create table if not exists public.certificates (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null references public.enrollments(id) on delete restrict,
  user_id uuid not null references auth.users(id) on delete restrict,
  course_version_id uuid not null references public.course_versions(id) on delete restrict,
  certificate_code text not null,
  status public.certificate_status not null default 'valid',
  holder_name text not null,
  course_title text not null,
  duration_hours integer not null,
  modality public.course_modality not null,
  completion_date date not null,
  issued_at timestamptz not null default now(),
  issued_by uuid references auth.users(id) on delete set null,
  pdf_storage_path text,
  revoked_at timestamptz,
  revoked_by uuid references auth.users(id) on delete set null,
  revocation_reason text,
  replaced_by uuid references public.certificates(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (enrollment_id),
  constraint certificates_code_format check (certificate_code ~ '^[A-Z0-9-]{8,80}$'),
  constraint certificates_duration check (duration_hours > 0),
  constraint certificates_revocation_consistency check (
    status <> 'revoked' or (revoked_at is not null and revocation_reason is not null)
  )
);

create unique index if not exists certificates_code_unique_idx
  on public.certificates (certificate_code);
create index if not exists certificates_user_issued_idx
  on public.certificates (user_id, issued_at desc);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null,
  title text not null,
  body text not null default '',
  action_url text,
  read_at timestamptz,
  created_at timestamptz not null default now(),
  constraint notifications_type_length check (char_length(type) between 1 and 80),
  constraint notifications_title_length check (char_length(title) between 1 and 240)
);

create index if not exists notifications_user_unread_idx
  on public.notifications (user_id, created_at desc)
  where read_at is null;

create or replace function app_private.current_user_can_access_purchase(target_purchase_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select auth.uid()) is not null
    and exists (
      select 1
      from public.purchases p
      where p.id = target_purchase_id
        and (
          p.buyer_user_id = (select auth.uid())
          or (
            p.organization_id is not null
            and app_private.current_user_manages_org(p.organization_id)
          )
          or app_private.current_user_has_role(
            array['administrador', 'superadministrador']::public.app_role[]
          )
        )
    );
$$;

create or replace function app_private.current_user_can_access_support_thread(target_thread_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select auth.uid()) is not null
    and exists (
      select 1
      from public.support_threads st
      where st.id = target_thread_id
        and (
          st.user_id = (select auth.uid())
          or st.assigned_tutor_id = (select auth.uid())
          or app_private.current_user_has_role(
            array['administrador', 'superadministrador']::public.app_role[]
          )
        )
    );
$$;

revoke execute on function app_private.current_user_can_access_purchase(uuid) from public, anon;
revoke execute on function app_private.current_user_can_access_support_thread(uuid) from public, anon;
grant execute on function app_private.current_user_can_access_purchase(uuid) to authenticated;
grant execute on function app_private.current_user_can_access_support_thread(uuid) to authenticated;

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

revoke execute on function public.redeem_access_code(text) from public, anon;
grant execute on function public.redeem_access_code(text) to authenticated;

create or replace function public.verify_certificate(input_code text)
returns table (
  certificate_code text,
  certificate_status public.certificate_status,
  holder_name text,
  course_title text,
  duration_hours integer,
  modality public.course_modality,
  completion_date date,
  issued_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    c.certificate_code,
    c.status,
    c.holder_name,
    c.course_title,
    c.duration_hours,
    c.modality,
    c.completion_date,
    c.issued_at
  from public.certificates c
  where c.certificate_code = upper(trim(input_code))
  limit 1;
$$;

revoke execute on function public.verify_certificate(text) from public;
grant execute on function public.verify_certificate(text) to anon, authenticated;

do $$
declare
  target_table regclass;
begin
  foreach target_table in array array[
    'public.purchases'::regclass,
    'public.access_codes'::regclass,
    'public.stripe_webhook_events'::regclass,
    'public.practice_sessions'::regclass,
    'public.practice_attendance'::regclass,
    'public.support_threads'::regclass,
    'public.certificates'::regclass
  ]
  loop
    execute format(
      'drop trigger if exists %I on %s',
      replace(target_table::text, 'public.', '') || '_set_updated_at',
      target_table
    );
    execute format(
      'create trigger %I before update on %s for each row execute function app_private.set_updated_at()',
      replace(target_table::text, 'public.', '') || '_set_updated_at',
      target_table
    );
  end loop;
end $$;

alter table public.purchases enable row level security;
alter table public.purchase_items enable row level security;
alter table public.access_codes enable row level security;
alter table public.stripe_webhook_events enable row level security;
alter table public.practice_sessions enable row level security;
alter table public.practice_attendance enable row level security;
alter table public.support_threads enable row level security;
alter table public.support_messages enable row level security;
alter table public.certificates enable row level security;
alter table public.notifications enable row level security;

drop policy if exists purchases_visible on public.purchases;
create policy purchases_visible
on public.purchases for select
to authenticated
using (
  buyer_user_id = (select auth.uid())
  or (
    organization_id is not null
    and (select app_private.current_user_manages_org(organization_id))
  )
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists purchases_admin_manage on public.purchases;
create policy purchases_admin_manage
on public.purchases for all
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

drop policy if exists purchase_items_visible on public.purchase_items;
create policy purchase_items_visible
on public.purchase_items for select
to authenticated
using ((select app_private.current_user_can_access_purchase(purchase_id)));

drop policy if exists purchase_items_admin_manage on public.purchase_items;
create policy purchase_items_admin_manage
on public.purchase_items for all
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

drop policy if exists access_codes_visible on public.access_codes;
create policy access_codes_visible
on public.access_codes for select
to authenticated
using (
  (
    organization_id is not null
    and (select app_private.current_user_manages_org(organization_id))
  )
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists access_codes_admin_manage on public.access_codes;
create policy access_codes_admin_manage
on public.access_codes for all
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

drop policy if exists stripe_webhook_events_admin on public.stripe_webhook_events;
create policy stripe_webhook_events_admin
on public.stripe_webhook_events for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists practice_sessions_visible on public.practice_sessions;
create policy practice_sessions_visible
on public.practice_sessions for select
to authenticated
using (
  (select app_private.current_user_is_enrolled(course_version_id))
  or tutor_user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists practice_sessions_staff_manage on public.practice_sessions;
create policy practice_sessions_staff_manage
on public.practice_sessions for all
to authenticated
using (
  tutor_user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  tutor_user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists practice_attendance_visible on public.practice_attendance;
create policy practice_attendance_visible
on public.practice_attendance for select
to authenticated
using (
  (select app_private.current_user_owns_enrollment(enrollment_id))
  or exists (
    select 1
    from public.practice_sessions ps
    where ps.id = practice_session_id
      and ps.tutor_user_id = (select auth.uid())
  )
  or exists (
    select 1
    from public.enrollments e
    where e.id = enrollment_id
      and e.organization_id is not null
      and (select app_private.current_user_manages_org(e.organization_id))
  )
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists practice_attendance_staff_manage on public.practice_attendance;
create policy practice_attendance_staff_manage
on public.practice_attendance for all
to authenticated
using (
  exists (
    select 1
    from public.practice_sessions ps
    where ps.id = practice_session_id
      and ps.tutor_user_id = (select auth.uid())
  )
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (
    exists (
      select 1
      from public.practice_sessions ps
      join public.enrollments e on e.course_version_id = ps.course_version_id
      where ps.id = practice_session_id
        and e.id = enrollment_id
    )
  )
  and (
    exists (
    select 1
    from public.practice_sessions ps
    where ps.id = practice_session_id
      and ps.tutor_user_id = (select auth.uid())
    )
    or (select app_private.current_user_has_role(
      array['administrador', 'superadministrador']::public.app_role[]
    ))
  )
);

drop policy if exists support_threads_visible on public.support_threads;
create policy support_threads_visible
on public.support_threads for select
to authenticated
using (
  user_id = (select auth.uid())
  or assigned_tutor_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists support_threads_insert_own on public.support_threads;
create policy support_threads_insert_own
on public.support_threads for insert
to authenticated
with check (
  user_id = (select auth.uid())
  and (
    enrollment_id is null
    or (select app_private.current_user_owns_enrollment(enrollment_id))
  )
);

drop policy if exists support_threads_staff_update on public.support_threads;
create policy support_threads_staff_update
on public.support_threads for update
to authenticated
using (
  assigned_tutor_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  assigned_tutor_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists support_messages_visible on public.support_messages;
create policy support_messages_visible
on public.support_messages for select
to authenticated
using ((select app_private.current_user_can_access_support_thread(thread_id)));

drop policy if exists support_messages_insert_participant on public.support_messages;
create policy support_messages_insert_participant
on public.support_messages for insert
to authenticated
with check (
  sender_user_id = (select auth.uid())
  and (select app_private.current_user_can_access_support_thread(thread_id))
);

drop policy if exists certificates_visible on public.certificates;
create policy certificates_visible
on public.certificates for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists certificates_admin_manage on public.certificates;
create policy certificates_admin_manage
on public.certificates for all
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

drop policy if exists notifications_own_select on public.notifications;
create policy notifications_own_select
on public.notifications for select
to authenticated
using (user_id = (select auth.uid()));

drop policy if exists notifications_own_update on public.notifications;
create policy notifications_own_update
on public.notifications for update
to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

revoke all on public.purchases, public.purchase_items, public.access_codes,
  public.stripe_webhook_events, public.practice_sessions,
  public.practice_attendance, public.support_threads, public.support_messages,
  public.certificates, public.notifications
from anon, authenticated;

grant select on public.purchases, public.purchase_items to authenticated;
grant select (
  id, purchase_item_id, course_version_id, organization_id, code_last_four,
  status, reserved_for_email, reserved_at, used_by, used_at, expires_at,
  revoked_at, created_at, updated_at
) on public.access_codes to authenticated;
grant select on public.stripe_webhook_events to authenticated;
grant select, insert, update, delete on public.purchases, public.purchase_items
  to authenticated;
grant insert, update, delete on public.access_codes to authenticated;
grant select, insert on public.practice_sessions to authenticated;
grant update (
  title, venue_name, venue_address, starts_at, ends_at, capacity,
  tutor_user_id, status, notes
) on public.practice_sessions to authenticated;
grant select on public.practice_attendance to authenticated;
grant insert (
  practice_session_id, enrollment_id, result, checked_in_at, checked_out_at,
  evidence_storage_path, observations, learner_confirmed_at,
  validated_by, validated_at
) on public.practice_attendance to authenticated;
grant update (
  result, checked_in_at, checked_out_at, evidence_storage_path, observations,
  learner_confirmed_at, validated_by, validated_at
) on public.practice_attendance to authenticated;
grant select on public.support_threads to authenticated;
grant insert (user_id, enrollment_id, lesson_id, subject)
  on public.support_threads to authenticated;
grant update (assigned_tutor_id, status, last_message_at, closed_at)
  on public.support_threads to authenticated;
grant select, insert on public.support_messages to authenticated;
grant select, insert, update on public.certificates to authenticated;
grant select on public.notifications to authenticated;
grant update (read_at) on public.notifications to authenticated;

insert into storage.buckets (id, name, public, file_size_limit)
values
  ('course-materials', 'course-materials', false, 52428800),
  ('support-attachments', 'support-attachments', false, 10485760),
  ('practice-evidence', 'practice-evidence', false, 20971520),
  ('certificates', 'certificates', false, 10485760)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit;

commit;
