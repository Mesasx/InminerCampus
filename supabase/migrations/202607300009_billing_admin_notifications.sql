begin;

do $$
begin
  create type public.billing_buyer_type as enum ('individual', 'business');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.invoice_status as enum (
    'pending_invoice',
    'invoiced',
    'invoice_sent',
    'refunded'
  );
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.admin_notification_status as enum (
    'pending',
    'sending',
    'sent',
    'failed',
    'not_required'
  );
exception
  when duplicate_object then null;
end $$;

alter table public.purchases
  add column if not exists billing_snapshot_version smallint,
  add column if not exists billing_buyer_type public.billing_buyer_type,
  add column if not exists billing_name text,
  add column if not exists billing_tax_id text,
  add column if not exists billing_address_line1 text,
  add column if not exists billing_postal_code text,
  add column if not exists billing_city text,
  add column if not exists billing_province text,
  add column if not exists billing_country_code text,
  add column if not exists billing_email text,
  add column if not exists billing_phone text,
  add column if not exists invoice_email text,
  add column if not exists contract_terms_accepted_at timestamptz,
  add column if not exists contract_terms_version text,
  add column if not exists privacy_policy_version text,
  add column if not exists subtotal_net_cents bigint,
  add column if not exists tax_amount_cents bigint,
  add column if not exists total_amount_cents bigint,
  add column if not exists tax_rate_basis_points integer,
  add column if not exists stripe_event_id text,
  add column if not exists invoice_status public.invoice_status
    not null default 'pending_invoice',
  add column if not exists invoice_number text,
  add column if not exists invoiced_at timestamptz,
  add column if not exists invoice_sent_at timestamptz,
  add column if not exists admin_notes text,
  add column if not exists admin_notification_status
    public.admin_notification_status,
  add column if not exists admin_notification_attempts integer
    not null default 0,
  add column if not exists admin_notification_attempted_at timestamptz,
  add column if not exists admin_notification_sent_at timestamptz,
  add column if not exists admin_notification_error text,
  add column if not exists admin_notification_message_id text,
  add column if not exists refunded_amount_cents bigint not null default 0;

update public.purchases
set
  billing_snapshot_version = 0,
  admin_notification_status = 'not_required'
where billing_snapshot_version is null;

alter table public.purchases
  alter column billing_snapshot_version set default 1,
  alter column billing_snapshot_version set not null,
  alter column admin_notification_status set default 'pending',
  alter column admin_notification_status set not null;

alter table public.purchases
  drop constraint if exists purchases_billing_snapshot_version_check,
  add constraint purchases_billing_snapshot_version_check
    check (billing_snapshot_version in (0, 1)),
  drop constraint if exists purchases_billing_snapshot_complete_check,
  add constraint purchases_billing_snapshot_complete_check
    check (
      billing_snapshot_version = 0
      or (
        billing_buyer_type is not null
        and billing_name is not null
        and char_length(trim(billing_name)) between 2 and 200
        and billing_tax_id is not null
        and char_length(trim(billing_tax_id)) between 3 and 40
        and billing_address_line1 is not null
        and char_length(trim(billing_address_line1)) between 5 and 240
        and billing_postal_code is not null
        and char_length(trim(billing_postal_code)) between 3 and 20
        and billing_city is not null
        and char_length(trim(billing_city)) between 2 and 120
        and billing_province is not null
        and char_length(trim(billing_province)) between 2 and 120
        and billing_country_code is not null
        and billing_country_code ~ '^[A-Z]{2}$'
        and billing_email is not null
        and char_length(trim(billing_email)) between 5 and 320
        and invoice_email is not null
        and char_length(trim(invoice_email)) between 5 and 320
        and contract_terms_accepted_at is not null
        and contract_terms_version is not null
        and privacy_policy_version is not null
        and subtotal_net_cents is not null
        and tax_amount_cents is not null
        and total_amount_cents is not null
        and tax_rate_basis_points is not null
      )
    ),
  drop constraint if exists purchases_cents_nonnegative_check,
  add constraint purchases_cents_nonnegative_check
    check (
      (subtotal_net_cents is null or subtotal_net_cents >= 0)
      and (tax_amount_cents is null or tax_amount_cents >= 0)
      and (total_amount_cents is null or total_amount_cents >= 0)
      and refunded_amount_cents >= 0
    ),
  drop constraint if exists purchases_cents_total_consistency_check,
  add constraint purchases_cents_total_consistency_check
    check (
      billing_snapshot_version = 0
      or total_amount_cents = subtotal_net_cents + tax_amount_cents
    ),
  drop constraint if exists purchases_tax_basis_points_check,
  add constraint purchases_tax_basis_points_check
    check (
      tax_rate_basis_points is null
      or tax_rate_basis_points between 0 and 10000
    ),
  drop constraint if exists purchases_admin_notification_attempts_check,
  add constraint purchases_admin_notification_attempts_check
    check (admin_notification_attempts >= 0),
  drop constraint if exists purchases_invoice_state_check,
  add constraint purchases_invoice_state_check
    check (
      (invoice_status = 'pending_invoice')
      or (
        invoice_status = 'invoiced'
        and invoice_number is not null
        and invoiced_at is not null
      )
      or (
        invoice_status = 'invoice_sent'
        and invoice_number is not null
        and invoiced_at is not null
        and invoice_sent_at is not null
      )
      or invoice_status = 'refunded'
    );

create unique index if not exists purchases_stripe_event_unique_idx
  on public.purchases (stripe_event_id)
  where stripe_event_id is not null;

create index if not exists purchases_invoice_status_paid_idx
  on public.purchases (invoice_status, paid_at desc)
  where status in ('paid', 'refunded', 'partially_refunded');

create index if not exists purchases_admin_notification_pending_idx
  on public.purchases (admin_notification_status, paid_at)
  where admin_notification_status in ('pending', 'failed', 'sending');

create index if not exists purchases_billing_search_idx
  on public.purchases (
    lower(billing_name),
    lower(billing_email),
    upper(billing_tax_id)
  )
  where billing_snapshot_version = 1;

alter table public.purchase_items
  add column if not exists snapshot_version smallint,
  add column if not exists course_title_snapshot text,
  add column if not exists course_version_snapshot integer,
  add column if not exists modality_snapshot public.course_modality,
  add column if not exists duration_hours_snapshot integer,
  add column if not exists unit_net_cents bigint,
  add column if not exists line_net_cents bigint,
  add column if not exists line_tax_cents bigint,
  add column if not exists line_total_cents bigint,
  add column if not exists tax_rate_basis_points integer;

update public.purchase_items
set snapshot_version = 0
where snapshot_version is null;

alter table public.purchase_items
  alter column snapshot_version set default 1,
  alter column snapshot_version set not null;

alter table public.purchase_items
  drop constraint if exists purchase_items_snapshot_version_check,
  add constraint purchase_items_snapshot_version_check
    check (snapshot_version in (0, 1)),
  drop constraint if exists purchase_items_snapshot_complete_check,
  add constraint purchase_items_snapshot_complete_check
    check (
      snapshot_version = 0
      or (
        course_title_snapshot is not null
        and char_length(trim(course_title_snapshot)) between 2 and 240
        and course_version_snapshot is not null
        and course_version_snapshot > 0
        and modality_snapshot is not null
        and duration_hours_snapshot is not null
        and duration_hours_snapshot > 0
        and unit_net_cents is not null
        and line_net_cents is not null
        and line_tax_cents is not null
        and line_total_cents is not null
        and tax_rate_basis_points is not null
      )
    ),
  drop constraint if exists purchase_items_snapshot_amounts_check,
  add constraint purchase_items_snapshot_amounts_check
    check (
      (unit_net_cents is null or unit_net_cents >= 0)
      and (line_net_cents is null or line_net_cents >= 0)
      and (line_tax_cents is null or line_tax_cents >= 0)
      and (line_total_cents is null or line_total_cents >= 0)
      and (
        snapshot_version = 0
        or line_total_cents = line_net_cents + line_tax_cents
      )
    ),
  drop constraint if exists purchase_items_snapshot_tax_check,
  add constraint purchase_items_snapshot_tax_check
    check (
      tax_rate_basis_points is null
      or tax_rate_basis_points between 0 and 10000
    );

create or replace function app_private.protect_paid_purchase_snapshot()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.paid_at is not null and (
    row(
      old.kind,
      old.buyer_user_id,
      old.organization_id,
      old.billing_snapshot_version,
      old.billing_buyer_type,
      old.billing_name,
      old.billing_tax_id,
      old.billing_address_line1,
      old.billing_postal_code,
      old.billing_city,
      old.billing_province,
      old.billing_country_code,
      old.billing_email,
      old.billing_phone,
      old.invoice_email,
      old.contract_terms_accepted_at,
      old.contract_terms_version,
      old.privacy_policy_version,
      old.subtotal_net_cents,
      old.tax_amount_cents,
      old.total_amount_cents,
      old.tax_rate_basis_points,
      old.currency,
      old.billing_details
    ) is distinct from row(
      new.kind,
      new.buyer_user_id,
      new.organization_id,
      new.billing_snapshot_version,
      new.billing_buyer_type,
      new.billing_name,
      new.billing_tax_id,
      new.billing_address_line1,
      new.billing_postal_code,
      new.billing_city,
      new.billing_province,
      new.billing_country_code,
      new.billing_email,
      new.billing_phone,
      new.invoice_email,
      new.contract_terms_accepted_at,
      new.contract_terms_version,
      new.privacy_policy_version,
      new.subtotal_net_cents,
      new.tax_amount_cents,
      new.total_amount_cents,
      new.tax_rate_basis_points,
      new.currency,
      new.billing_details
    )
  ) then
    raise exception 'Paid purchase fiscal and economic snapshot is immutable';
  end if;

  return new;
end;
$$;

revoke all on function app_private.protect_paid_purchase_snapshot()
  from public;

drop trigger if exists purchases_protect_paid_snapshot
  on public.purchases;
create trigger purchases_protect_paid_snapshot
before update on public.purchases
for each row execute function app_private.protect_paid_purchase_snapshot();

create or replace function app_private.protect_paid_purchase_item_snapshot()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if exists (
    select 1
    from public.purchases p
    where p.id = old.purchase_id
      and p.paid_at is not null
  ) and (
    row(
      old.purchase_id,
      old.course_version_id,
      old.quantity,
      old.snapshot_version,
      old.course_title_snapshot,
      old.course_version_snapshot,
      old.modality_snapshot,
      old.duration_hours_snapshot,
      old.unit_net_cents,
      old.line_net_cents,
      old.line_tax_cents,
      old.line_total_cents,
      old.tax_rate_basis_points,
      old.currency
    ) is distinct from row(
      new.purchase_id,
      new.course_version_id,
      new.quantity,
      new.snapshot_version,
      new.course_title_snapshot,
      new.course_version_snapshot,
      new.modality_snapshot,
      new.duration_hours_snapshot,
      new.unit_net_cents,
      new.line_net_cents,
      new.line_tax_cents,
      new.line_total_cents,
      new.tax_rate_basis_points,
      new.currency
    )
  ) then
    raise exception 'Paid purchase item snapshot is immutable';
  end if;

  return new;
end;
$$;

revoke all on function app_private.protect_paid_purchase_item_snapshot()
  from public;

drop trigger if exists purchase_items_protect_paid_snapshot
  on public.purchase_items;
create trigger purchase_items_protect_paid_snapshot
before update on public.purchase_items
for each row execute function app_private.protect_paid_purchase_item_snapshot();

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
    end
  where id = target_purchase.id;

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
      'refunded_amount_cents', p_refunded_amount_cents
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

create or replace function public.claim_admin_payment_notification(
  p_purchase_id uuid
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  claimed_id uuid;
begin
  update public.purchases
  set
    admin_notification_status = 'sending',
    admin_notification_attempts = admin_notification_attempts + 1,
    admin_notification_attempted_at = now(),
    admin_notification_error = null
  where id = p_purchase_id
    and status in ('paid', 'refunded', 'partially_refunded')
    and (
      admin_notification_status in ('pending', 'failed')
      or (
        admin_notification_status = 'sending'
        and admin_notification_attempted_at < now() - interval '10 minutes'
      )
    )
  returning id into claimed_id;

  return claimed_id is not null;
end;
$$;

revoke all on function public.claim_admin_payment_notification(uuid)
  from public, anon, authenticated;
grant execute on function public.claim_admin_payment_notification(uuid)
  to service_role;

create or replace function public.complete_admin_payment_notification(
  p_purchase_id uuid,
  p_success boolean,
  p_message_id text,
  p_error text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.purchases
  set
    admin_notification_status = case
      when p_success then 'sent'::public.admin_notification_status
      else 'failed'::public.admin_notification_status
    end,
    admin_notification_sent_at = case
      when p_success then coalesce(admin_notification_sent_at, now())
      else admin_notification_sent_at
    end,
    admin_notification_message_id = case
      when p_success then nullif(p_message_id, '')
      else admin_notification_message_id
    end,
    admin_notification_error = case
      when p_success then null
      else left(coalesce(p_error, 'Unknown email error'), 1000)
    end
  where id = p_purchase_id
    and admin_notification_status = 'sending';
end;
$$;

revoke all on function public.complete_admin_payment_notification(
  uuid, boolean, text, text
) from public, anon, authenticated;
grant execute on function public.complete_admin_payment_notification(
  uuid, boolean, text, text
) to service_role;

drop policy if exists purchases_admin_manage on public.purchases;
drop policy if exists purchase_items_admin_manage on public.purchase_items;

revoke insert, update, delete on public.purchases, public.purchase_items
  from authenticated;
grant select on public.purchases, public.purchase_items to authenticated;

commit;
