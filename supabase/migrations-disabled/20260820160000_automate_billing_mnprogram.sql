-- Future design only. Disabled while invoices are created manually in MNprogram.
begin;

create table if not exists public.invoice_counters (
  invoice_series text not null,
  invoice_year integer not null,
  last_value bigint not null default 0,
  updated_at timestamptz not null default now(),
  primary key (invoice_series, invoice_year),
  constraint invoice_counters_series_check
    check (invoice_series ~ '^[A-Z0-9_-]{1,24}$'),
  constraint invoice_counters_year_check
    check (invoice_year between 2000 and 2200),
  constraint invoice_counters_value_check
    check (last_value >= 0)
);

create table if not exists public.invoices (
  id uuid primary key default gen_random_uuid(),
  purchase_id uuid not null unique
    references public.purchases(id) on delete restrict,
  invoice_number text not null unique,
  internal_invoice_reference text not null unique,
  official_invoice_number text unique,
  invoice_series text not null default 'CAMPUS',
  invoice_year integer not null,
  invoice_sequence bigint not null,
  status text not null default 'pending',
  provider text not null default 'internal_pending_mnprogram',
  customer_name text not null,
  customer_tax_id text not null,
  customer_email text not null,
  customer_address jsonb not null default '{}'::jsonb,
  subtotal_cents bigint not null,
  tax_cents bigint not null,
  total_cents bigint not null,
  currency text not null,
  issued_at timestamptz,
  pdf_storage_path text,
  pdf_sha256 text,
  stripe_checkout_session_id text,
  stripe_payment_intent_id text,
  stripe_customer_id text,
  mnprogram_reference text,
  mnprogram_invoice_reference text,
  local_archive_status text not null default 'pending',
  local_archive_path text,
  local_archived_at timestamptz,
  email_sent_at timestamptz,
  email_delivery_version integer not null default 1,
  refund_requires_credit_note boolean not null default false,
  last_error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint invoices_series_year_sequence_unique
    unique (invoice_series, invoice_year, invoice_sequence),
  constraint invoices_status_check check (status in (
    'pending', 'issuing', 'issued', 'email_pending', 'emailed',
    'archive_pending', 'archived', 'error', 'cancelled'
  )),
  constraint invoices_provider_check check (provider in (
    'mnprogram', 'internal_pending_mnprogram'
  )),
  constraint invoices_amounts_check check (
    subtotal_cents >= 0
    and tax_cents >= 0
    and total_cents = subtotal_cents + tax_cents
  ),
  constraint invoices_currency_check check (currency ~ '^[A-Z]{3}$'),
  constraint invoices_address_object_check
    check (jsonb_typeof(customer_address) = 'object'),
  constraint invoices_pdf_check check (
    (pdf_storage_path is null and pdf_sha256 is null)
    or (
      pdf_storage_path is not null
      and pdf_sha256 ~ '^[a-f0-9]{64}$'
    )
  ),
  constraint invoices_issued_check check (
    status not in (
      'issued', 'email_pending', 'emailed', 'archive_pending', 'archived'
    )
    or (
      official_invoice_number is not null
      and issued_at is not null
    )
  ),
  constraint invoices_archive_check check (
    local_archive_status in ('pending', 'processing', 'archived', 'error')
  ),
  constraint invoices_email_delivery_version_check
    check (email_delivery_version > 0)
);

create index if not exists invoices_status_created_idx
  on public.invoices (status, created_at);
create index if not exists invoices_archive_pending_idx
  on public.invoices (local_archive_status, issued_at)
  where pdf_storage_path is not null
    and local_archive_status in ('pending', 'error');

create table if not exists public.billing_jobs (
  id uuid primary key default gen_random_uuid(),
  purchase_id uuid not null
    references public.purchases(id) on delete restrict,
  invoice_id uuid not null
    references public.invoices(id) on delete cascade,
  type text not null,
  status text not null default 'pending',
  attempt_count integer not null default 0,
  next_attempt_at timestamptz default now(),
  last_error text,
  locked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint billing_jobs_invoice_type_unique unique (invoice_id, type),
  constraint billing_jobs_type_check check (type in (
    'mnprogram_sync', 'invoice_issue', 'invoice_email', 'local_archive'
  )),
  constraint billing_jobs_status_check check (status in (
    'pending', 'processing', 'completed', 'failed'
  )),
  constraint billing_jobs_attempts_check check (attempt_count >= 0)
);

create index if not exists billing_jobs_due_idx
  on public.billing_jobs (next_attempt_at, created_at)
  where status in ('pending', 'failed');

create table if not exists public.mnprogram_syncs (
  id uuid primary key default gen_random_uuid(),
  purchase_id uuid not null unique
    references public.purchases(id) on delete restrict,
  invoice_id uuid not null unique
    references public.invoices(id) on delete cascade,
  status text not null default 'pending',
  attempt_count integer not null default 0,
  last_error text,
  last_attempt_at timestamptz,
  synced_at timestamptz,
  mnprogram_client_ref text,
  mnprogram_expediente_ref text,
  mnprogram_actuacion_ref text,
  mnprogram_invoice_ref text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint mnprogram_syncs_status_check check (status in (
    'pending', 'syncing', 'synced', 'error', 'not_configured'
  )),
  constraint mnprogram_syncs_attempts_check check (attempt_count >= 0)
);

alter table public.purchase_items
  add column if not exists course_code_snapshot text,
  add column if not exists description_snapshot text;

alter table public.purchases
  add column if not exists refund_requires_credit_note boolean
    not null default false;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'billing-documents',
  'billing-documents',
  false,
  10485760,
  array['application/pdf']::text[]
)
on conflict (id) do update
set
  public = false,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop trigger if exists invoices_set_updated_at on public.invoices;
create trigger invoices_set_updated_at
before update on public.invoices
for each row execute function app_private.set_updated_at();

drop trigger if exists invoice_counters_set_updated_at
  on public.invoice_counters;
create trigger invoice_counters_set_updated_at
before update on public.invoice_counters
for each row execute function app_private.set_updated_at();

drop trigger if exists billing_jobs_set_updated_at on public.billing_jobs;
create trigger billing_jobs_set_updated_at
before update on public.billing_jobs
for each row execute function app_private.set_updated_at();

drop trigger if exists mnprogram_syncs_set_updated_at
  on public.mnprogram_syncs;
create trigger mnprogram_syncs_set_updated_at
before update on public.mnprogram_syncs
for each row execute function app_private.set_updated_at();

create or replace function app_private.protect_invoice_document()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.pdf_storage_path is not null and (
    old.pdf_storage_path is distinct from new.pdf_storage_path
    or old.pdf_sha256 is distinct from new.pdf_sha256
  ) then
    raise exception 'Issued invoice PDF is immutable';
  end if;

  if old.official_invoice_number is not null and (
    old.official_invoice_number is distinct from new.official_invoice_number
    or old.issued_at is distinct from new.issued_at
    or old.purchase_id is distinct from new.purchase_id
    or old.subtotal_cents is distinct from new.subtotal_cents
    or old.tax_cents is distinct from new.tax_cents
    or old.total_cents is distinct from new.total_cents
    or old.currency is distinct from new.currency
    or old.customer_name is distinct from new.customer_name
    or old.customer_tax_id is distinct from new.customer_tax_id
    or old.customer_email is distinct from new.customer_email
    or old.customer_address is distinct from new.customer_address
  ) then
    raise exception 'Issued invoice fiscal snapshot is immutable';
  end if;

  return new;
end;
$$;

revoke all on function app_private.protect_invoice_document() from public;

drop trigger if exists invoices_protect_document on public.invoices;
create trigger invoices_protect_document
before update on public.invoices
for each row execute function app_private.protect_invoice_document();

create or replace function app_private.enqueue_invoice_for_purchase(
  p_purchase_id uuid
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_purchase public.purchases%rowtype;
  existing_invoice_id uuid;
  next_sequence bigint;
  target_year integer;
  internal_reference text;
begin
  select *
  into target_purchase
  from public.purchases
  where id = p_purchase_id
  for update;

  if not found then
    raise exception 'Purchase not found';
  end if;

  if target_purchase.status not in ('paid', 'refunded', 'partially_refunded')
     or target_purchase.paid_at is null
  then
    raise exception 'Only paid purchases can be invoiced';
  end if;

  -- Historical purchases created before immutable fiscal snapshots cannot be
  -- invoiced automatically without inventing missing data. They remain in the
  -- legacy administrative flow and, importantly, never break Stripe replay.
  if target_purchase.billing_snapshot_version <> 1 then
    return null;
  end if;

  select id
  into existing_invoice_id
  from public.invoices
  where purchase_id = p_purchase_id;

  if existing_invoice_id is not null then
    insert into public.billing_jobs (
      purchase_id, invoice_id, type, status, next_attempt_at
    )
    values
      (p_purchase_id, existing_invoice_id, 'mnprogram_sync', 'pending', now()),
      (p_purchase_id, existing_invoice_id, 'invoice_issue', 'pending', now())
    on conflict (invoice_id, type) do nothing;

    insert into public.mnprogram_syncs (purchase_id, invoice_id)
    values (p_purchase_id, existing_invoice_id)
    on conflict (invoice_id) do nothing;

    return existing_invoice_id;
  end if;

  target_year := extract(year from target_purchase.paid_at
    at time zone 'Europe/Madrid')::integer;

  insert into public.invoice_counters (
    invoice_series, invoice_year, last_value
  )
  values ('CAMPUS', target_year, 1)
  on conflict (invoice_series, invoice_year) do update
    set last_value = public.invoice_counters.last_value + 1,
        updated_at = now()
  returning last_value into next_sequence;

  internal_reference := format(
    'CAMPUS-%s-%s',
    target_year,
    lpad(next_sequence::text, 6, '0')
  );

  insert into public.invoices (
    purchase_id,
    invoice_number,
    internal_invoice_reference,
    invoice_series,
    invoice_year,
    invoice_sequence,
    customer_name,
    customer_tax_id,
    customer_email,
    customer_address,
    subtotal_cents,
    tax_cents,
    total_cents,
    currency,
    stripe_checkout_session_id,
    stripe_payment_intent_id,
    stripe_customer_id,
    refund_requires_credit_note
  )
  values (
    target_purchase.id,
    internal_reference,
    internal_reference,
    'CAMPUS',
    target_year,
    next_sequence,
    target_purchase.billing_name,
    target_purchase.billing_tax_id,
    coalesce(target_purchase.invoice_email, target_purchase.billing_email),
    jsonb_build_object(
      'line1', target_purchase.billing_address_line1,
      'postalCode', target_purchase.billing_postal_code,
      'city', target_purchase.billing_city,
      'province', target_purchase.billing_province,
      'countryCode', target_purchase.billing_country_code,
      'phone', target_purchase.billing_phone
    ),
    target_purchase.subtotal_net_cents,
    target_purchase.tax_amount_cents,
    target_purchase.total_amount_cents,
    target_purchase.currency,
    target_purchase.stripe_checkout_session_id,
    target_purchase.stripe_payment_intent_id,
    target_purchase.stripe_customer_id,
    target_purchase.refund_requires_credit_note
  )
  returning id into existing_invoice_id;

  insert into public.billing_jobs (
    purchase_id, invoice_id, type, status, next_attempt_at
  )
  values
    (p_purchase_id, existing_invoice_id, 'mnprogram_sync', 'pending', now()),
    (p_purchase_id, existing_invoice_id, 'invoice_issue', 'pending', now());

  insert into public.mnprogram_syncs (purchase_id, invoice_id)
  values (p_purchase_id, existing_invoice_id);

  return existing_invoice_id;
end;
$$;

revoke all on function app_private.enqueue_invoice_for_purchase(uuid)
  from public, anon, authenticated;

create or replace function public.enqueue_paid_purchase_billing(
  p_purchase_id uuid
)
returns uuid
language sql
security definer
set search_path = ''
as $$
  select app_private.enqueue_invoice_for_purchase(p_purchase_id);
$$;

revoke all on function public.enqueue_paid_purchase_billing(uuid)
  from public, anon, authenticated;
grant execute on function public.enqueue_paid_purchase_billing(uuid)
  to service_role;

create or replace function public.claim_billing_jobs(p_limit integer default 10)
returns setof public.billing_jobs
language plpgsql
security definer
set search_path = ''
as $$
begin
  return query
  with candidates as (
    select job.id
    from public.billing_jobs job
    where job.type in ('mnprogram_sync', 'invoice_issue', 'invoice_email')
      and job.status in ('pending', 'failed')
      and job.next_attempt_at is not null
      and job.next_attempt_at <= now()
      and job.attempt_count < 6
    order by job.next_attempt_at, job.created_at
    for update skip locked
    limit greatest(1, least(coalesce(p_limit, 10), 50))
  )
  update public.billing_jobs job
  set
    status = 'processing',
    attempt_count = job.attempt_count + 1,
    locked_at = now(),
    last_error = null
  from candidates
  where job.id = candidates.id
  returning job.*;
end;
$$;

revoke all on function public.claim_billing_jobs(integer)
  from public, anon, authenticated;
grant execute on function public.claim_billing_jobs(integer)
  to service_role;

create or replace function public.claim_archive_jobs(p_limit integer default 50)
returns setof public.billing_jobs
language plpgsql
security definer
set search_path = ''
as $$
begin
  return query
  with candidates as (
    select job.id
    from public.billing_jobs job
    where job.type = 'local_archive'
      and job.attempt_count < 6
      and (
        (
          job.status in ('pending', 'failed')
          and job.next_attempt_at is not null
          and job.next_attempt_at <= now()
        )
        or (
          job.status = 'processing'
          and job.locked_at < now() - interval '15 minutes'
        )
      )
    order by job.next_attempt_at nulls first, job.created_at
    for update skip locked
    limit greatest(1, least(coalesce(p_limit, 50), 100))
  )
  update public.billing_jobs job
  set
    status = 'processing',
    attempt_count = job.attempt_count + 1,
    locked_at = now(),
    last_error = null
  from candidates
  where job.id = candidates.id
  returning job.*;
end;
$$;

revoke all on function public.claim_archive_jobs(integer)
  from public, anon, authenticated;
grant execute on function public.claim_archive_jobs(integer)
  to service_role;

create or replace function public.complete_billing_job(
  p_job_id uuid,
  p_success boolean,
  p_retryable boolean,
  p_error text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.billing_jobs
  set
    status = case
      when p_success then 'completed'
      else 'failed'
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
      else left(coalesce(nullif(p_error, ''), 'Unknown billing error'), 1000)
    end,
    locked_at = null
  where id = p_job_id
    and status = 'processing';
end;
$$;

revoke all on function public.complete_billing_job(uuid, boolean, boolean, text)
  from public, anon, authenticated;
grant execute on function public.complete_billing_job(
  uuid, boolean, boolean, text
) to service_role;

create or replace function public.retry_invoice_jobs(
  p_invoice_id uuid,
  p_type text default null
)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  affected integer;
begin
  update public.billing_jobs
  set
    status = 'pending',
    attempt_count = 0,
    next_attempt_at = now(),
    locked_at = null,
    last_error = null
  where invoice_id = p_invoice_id
    and (status <> 'completed' or p_type = 'invoice_email')
    and (p_type is null or type = p_type);

  get diagnostics affected = row_count;
  if affected > 0 and p_type = 'invoice_email' then
    update public.invoices
    set
      email_sent_at = null,
      email_delivery_version = email_delivery_version + 1,
      status = 'email_pending',
      last_error = null
    where id = p_invoice_id
      and official_invoice_number is not null
      and pdf_storage_path is not null;
  elsif affected > 0 and p_type = 'local_archive' then
    update public.invoices
    set local_archive_status = 'pending', last_error = null
    where id = p_invoice_id
      and pdf_storage_path is not null;
  end if;

  return affected;
end;
$$;

revoke all on function public.retry_invoice_jobs(uuid, text)
  from public, anon, authenticated;
grant execute on function public.retry_invoice_jobs(uuid, text)
  to service_role;

create or replace function public.check_archive_agent_rate_limit(
  p_subject uuid
)
returns boolean
language sql
security definer
set search_path = ''
as $$
  select app_private.check_rate_limit(
    'archive_agent',
    p_subject,
    240,
    interval '1 minute'
  );
$$;

revoke all on function public.check_archive_agent_rate_limit(uuid)
  from public, anon, authenticated;
grant execute on function public.check_archive_agent_rate_limit(uuid)
  to service_role;

create or replace function public.enqueue_invoice_delivery_jobs(
  p_invoice_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_invoice public.invoices%rowtype;
begin
  select * into target_invoice
  from public.invoices
  where id = p_invoice_id
  for update;

  if not found
     or target_invoice.official_invoice_number is null
     or target_invoice.pdf_storage_path is null
  then
    raise exception 'Issued invoice PDF is not ready';
  end if;

  insert into public.billing_jobs (
    purchase_id, invoice_id, type, status, next_attempt_at
  )
  values
    (
      target_invoice.purchase_id,
      target_invoice.id,
      'invoice_email',
      case when target_invoice.email_sent_at is null
        then 'pending' else 'completed' end,
      now()
    ),
    (
      target_invoice.purchase_id,
      target_invoice.id,
      'local_archive',
      case when target_invoice.local_archived_at is null
        then 'pending' else 'completed' end,
      now()
    )
  on conflict (invoice_id, type) do update
  set
    status = case
      when public.billing_jobs.status = 'completed'
        then public.billing_jobs.status
      else 'pending'
    end,
    next_attempt_at = case
      when public.billing_jobs.status = 'completed'
        then public.billing_jobs.next_attempt_at
      else now()
    end,
    last_error = case
      when public.billing_jobs.status = 'completed'
        then public.billing_jobs.last_error
      else null
    end;

  update public.invoices
  set
    status = case
      when email_sent_at is null then 'email_pending'
      else 'archive_pending'
    end,
    local_archive_status = case
      when local_archived_at is null then 'pending'
      else local_archive_status
    end
  where id = p_invoice_id;
end;
$$;

revoke all on function public.enqueue_invoice_delivery_jobs(uuid)
  from public, anon, authenticated;
grant execute on function public.enqueue_invoice_delivery_jobs(uuid)
  to service_role;

create or replace function public.fulfill_stripe_checkout_v2(
  p_stripe_event_id text,
  p_event_type text,
  p_livemode boolean,
  p_purchase_id uuid,
  p_checkout_session_id text,
  p_payment_intent_id text,
  p_invoice_id text,
  p_stripe_customer_id text,
  p_subtotal_net numeric,
  p_tax_amount numeric,
  p_total_amount numeric,
  p_paid_at timestamptz
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_event_status public.webhook_event_status;
  target_purchase public.purchases%rowtype;
  target_item public.purchase_items%rowtype;
  expected_subtotal numeric;
  expected_tax numeric;
  expected_total numeric;
begin
  insert into public.stripe_webhook_events (
    stripe_event_id,
    event_type,
    livemode,
    related_purchase_id,
    attempt_count
  )
  values (
    p_stripe_event_id,
    p_event_type,
    p_livemode,
    p_purchase_id,
    1
  )
  on conflict (stripe_event_id) do update
    set attempt_count = public.stripe_webhook_events.attempt_count + 1,
        updated_at = now();

  select status
  into current_event_status
  from public.stripe_webhook_events
  where stripe_event_id = p_stripe_event_id
  for update;

  if current_event_status = 'processed' then
    return false;
  end if;

  select *
  into target_purchase
  from public.purchases
  where id = p_purchase_id
  for update;

  if not found then
    raise exception 'Purchase not found';
  end if;

  if target_purchase.stripe_checkout_session_id is not null
     and target_purchase.stripe_checkout_session_id <> p_checkout_session_id
  then
    raise exception 'Checkout session does not match purchase';
  end if;

  if target_purchase.status in ('paid', 'refunded', 'partially_refunded') then
    perform app_private.enqueue_invoice_for_purchase(p_purchase_id);
    update public.stripe_webhook_events
    set
      status = 'processed',
      processed_at = now(),
      last_error = null,
      related_purchase_id = p_purchase_id
    where stripe_event_id = p_stripe_event_id;
    return false;
  end if;

  if target_purchase.billing_snapshot_version = 1 then
    expected_subtotal := target_purchase.subtotal_net_cents::numeric / 100;
    expected_tax := target_purchase.tax_amount_cents::numeric / 100;
    expected_total := target_purchase.total_amount_cents::numeric / 100;

    if p_subtotal_net <> expected_subtotal
       or p_tax_amount <> expected_tax
       or p_total_amount <> expected_total
    then
      raise exception 'Stripe totals do not match purchase snapshot';
    end if;
  end if;

  update public.purchases
  set
    status = 'paid',
    stripe_checkout_session_id = p_checkout_session_id,
    stripe_payment_intent_id = nullif(p_payment_intent_id, ''),
    stripe_invoice_id = nullif(p_invoice_id, ''),
    stripe_customer_id = nullif(p_stripe_customer_id, ''),
    stripe_event_id = coalesce(stripe_event_id, p_stripe_event_id),
    subtotal_net = p_subtotal_net,
    tax_amount = p_tax_amount,
    total_amount = p_total_amount,
    subtotal_net_cents = coalesce(
      subtotal_net_cents,
      round(p_subtotal_net * 100)::bigint
    ),
    tax_amount_cents = coalesce(
      tax_amount_cents,
      round(p_tax_amount * 100)::bigint
    ),
    total_amount_cents = coalesce(
      total_amount_cents,
      round(p_total_amount * 100)::bigint
    ),
    paid_at = coalesce(paid_at, p_paid_at, now()),
    admin_notification_status = case
      when billing_snapshot_version = 1
        and admin_notification_status <> 'sent'
        then 'pending'::public.admin_notification_status
      else admin_notification_status
    end
  where id = p_purchase_id;

  if target_purchase.billing_snapshot_version = 0 then
    update public.purchase_items
    set
      line_tax = p_tax_amount,
      line_total = p_total_amount
    where purchase_id = p_purchase_id;
  end if;

  if target_purchase.kind = 'individual' then
    select *
    into target_item
    from public.purchase_items
    where purchase_id = p_purchase_id
    order by created_at, id
    limit 1;

    if not found or target_purchase.buyer_user_id is null then
      raise exception 'Individual purchase cannot be enrolled';
    end if;

    insert into public.enrollments (
      user_id,
      course_version_id,
      source_type,
      source_reference,
      status
    )
    values (
      target_purchase.buyer_user_id,
      target_item.course_version_id,
      'purchase',
      p_purchase_id::text,
      'not_started'
    )
    on conflict (user_id, course_version_id) do nothing;
  end if;

  perform app_private.enqueue_invoice_for_purchase(p_purchase_id);

  update public.stripe_webhook_events
  set
    status = 'processed',
    processed_at = now(),
    last_error = null,
    related_purchase_id = p_purchase_id
  where stripe_event_id = p_stripe_event_id;

  insert into public.audit_logs (
    actor_user_id,
    organization_id,
    action,
    entity_type,
    entity_id,
    payload
  )
  values (
    null,
    target_purchase.organization_id,
    'purchase.payment_confirmed',
    'purchase',
    p_purchase_id::text,
    jsonb_build_object(
      'stripe_event_id', p_stripe_event_id,
      'checkout_session_id', p_checkout_session_id
    )
  );

  return true;
end;
$$;

revoke all on function public.fulfill_stripe_checkout_v2(
  text, text, boolean, uuid, text, text, text, text,
  numeric, numeric, numeric, timestamptz
) from public, anon, authenticated;
grant execute on function public.fulfill_stripe_checkout_v2(
  text, text, boolean, uuid, text, text, text, text,
  numeric, numeric, numeric, timestamptz
) to service_role;

create or replace function public.record_stripe_refund(
  p_stripe_event_id text,
  p_event_type text,
  p_livemode boolean,
  p_payment_intent_id text,
  p_refunded_amount_cents bigint,
  p_refunded_at timestamptz
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_purchase public.purchases%rowtype;
  current_event_status public.webhook_event_status;
  duplicate_purchase_id uuid;
begin
  insert into public.stripe_webhook_events (
    stripe_event_id,
    event_type,
    livemode,
    attempt_count
  )
  values (
    p_stripe_event_id,
    p_event_type,
    p_livemode,
    1
  )
  on conflict (stripe_event_id) do update
    set attempt_count = public.stripe_webhook_events.attempt_count + 1,
        updated_at = now();

  select status
  into current_event_status
  from public.stripe_webhook_events
  where stripe_event_id = p_stripe_event_id
  for update;

  if current_event_status = 'processed' then
    select related_purchase_id
    into duplicate_purchase_id
    from public.stripe_webhook_events
    where stripe_event_id = p_stripe_event_id;
    return duplicate_purchase_id;
  end if;

  select *
  into target_purchase
  from public.purchases
  where stripe_payment_intent_id = p_payment_intent_id
  for update;

  if not found then
    raise exception 'Purchase for refund not found';
  end if;

  update public.purchases
  set
    refunded_amount_cents = greatest(
      refunded_amount_cents,
      p_refunded_amount_cents
    ),
    status = case
      when p_refunded_amount_cents >= coalesce(total_amount_cents, 0)
        then 'refunded'::public.purchase_status
      else 'partially_refunded'::public.purchase_status
    end,
    invoice_status = case
      when p_refunded_amount_cents >= coalesce(total_amount_cents, 0)
        then 'refunded'::public.invoice_status
      else invoice_status
    end,
    refunded_at = case
      when p_refunded_amount_cents >= coalesce(total_amount_cents, 0)
        then coalesce(refunded_at, p_refunded_at, now())
      else refunded_at
    end,
    refund_requires_credit_note = true
  where id = target_purchase.id;

  update public.invoices
  set refund_requires_credit_note = true
  where purchase_id = target_purchase.id;

  update public.stripe_webhook_events
  set
    status = 'processed',
    processed_at = now(),
    last_error = null,
    related_purchase_id = target_purchase.id
  where stripe_event_id = p_stripe_event_id;

  insert into public.audit_logs (
    actor_user_id,
    organization_id,
    action,
    entity_type,
    entity_id,
    payload
  )
  values (
    null,
    target_purchase.organization_id,
    'purchase.refund_recorded',
    'purchase',
    target_purchase.id::text,
    jsonb_build_object(
      'stripe_event_id', p_stripe_event_id,
      'refunded_amount_cents', p_refunded_amount_cents,
      'requires_credit_note', true
    )
  );

  return target_purchase.id;
end;
$$;

revoke all on function public.record_stripe_refund(
  text, text, boolean, text, bigint, timestamptz
) from public, anon, authenticated;
grant execute on function public.record_stripe_refund(
  text, text, boolean, text, bigint, timestamptz
) to service_role;

alter table public.invoice_counters enable row level security;
alter table public.invoices enable row level security;
alter table public.billing_jobs enable row level security;
alter table public.mnprogram_syncs enable row level security;

drop policy if exists invoices_visible on public.invoices;
create policy invoices_visible
on public.invoices for select
to authenticated
using ((select app_private.current_user_can_access_purchase(purchase_id)));

drop policy if exists invoices_admin_manage on public.invoices;
create policy invoices_admin_manage
on public.invoices for all
to authenticated
using ((select app_private.current_user_has_role(
  array['administrador', 'superadministrador']::public.app_role[]
)))
with check ((select app_private.current_user_has_role(
  array['administrador', 'superadministrador']::public.app_role[]
)));

drop policy if exists billing_jobs_admin_visible on public.billing_jobs;
create policy billing_jobs_admin_visible
on public.billing_jobs for select
to authenticated
using ((select app_private.current_user_has_role(
  array['administrador', 'superadministrador']::public.app_role[]
)));

drop policy if exists mnprogram_syncs_admin_visible
  on public.mnprogram_syncs;
create policy mnprogram_syncs_admin_visible
on public.mnprogram_syncs for select
to authenticated
using ((select app_private.current_user_has_role(
  array['administrador', 'superadministrador']::public.app_role[]
)));

revoke all on public.invoice_counters, public.invoices,
  public.billing_jobs, public.mnprogram_syncs
  from public, anon, authenticated;

grant select on public.invoices to authenticated;
grant select on public.billing_jobs, public.mnprogram_syncs to authenticated;
grant select, insert, update, delete on public.invoice_counters,
  public.invoices, public.billing_jobs, public.mnprogram_syncs
  to service_role;

commit;
