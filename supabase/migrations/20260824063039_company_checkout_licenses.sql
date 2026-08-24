begin;

do $$
begin
  create type public.company_license_delivery_status as enum (
    'pending', 'sending', 'sent', 'failed'
  );
exception when duplicate_object then null;
end $$;

alter table public.purchases
  add column if not exists gross_subtotal_cents bigint,
  add column if not exists discount_basis_points integer not null default 0,
  add column if not exists discount_amount_cents bigint not null default 0,
  add column if not exists buyer_given_name text,
  add column if not exists buyer_family_name text,
  add column if not exists buyer_contact_email text,
  add column if not exists buyer_contact_phone text,
  add column if not exists participant_privacy_confirmed_at timestamptz,
  add column if not exists participant_privacy_version text,
  add column if not exists stripe_discount_coupon_id text;

update public.purchases
set gross_subtotal_cents = subtotal_net_cents
where gross_subtotal_cents is null and subtotal_net_cents is not null;

alter table public.purchases
  drop constraint if exists purchases_company_discount_snapshot_check,
  add constraint purchases_company_discount_snapshot_check check (
    gross_subtotal_cents is null or (
      gross_subtotal_cents >= 0
      and discount_basis_points between 0 and 10000
      and discount_amount_cents >= 0
      and subtotal_net_cents = gross_subtotal_cents - discount_amount_cents
      and (
        kind = 'company'
        or (discount_basis_points = 0 and discount_amount_cents = 0)
      )
    )
  ),
  drop constraint if exists purchases_company_contact_snapshot_check,
  add constraint purchases_company_contact_snapshot_check check (
    kind <> 'company' or billing_snapshot_version < 2 or (
      buyer_given_name is not null and char_length(trim(buyer_given_name)) between 1 and 100
      and buyer_family_name is not null and char_length(trim(buyer_family_name)) between 1 and 160
      and buyer_contact_email is not null and char_length(trim(buyer_contact_email)) between 5 and 320
      and participant_privacy_confirmed_at is not null
      and participant_privacy_version is not null
    )
  );

alter table public.purchases
  drop constraint if exists purchases_billing_snapshot_version_check,
  add constraint purchases_billing_snapshot_version_check
    check (billing_snapshot_version in (0, 1, 2));

alter table public.purchase_items
  add column if not exists gross_line_net_cents bigint,
  add column if not exists discount_basis_points integer not null default 0,
  add column if not exists discount_amount_cents bigint not null default 0;

update public.purchase_items
set gross_line_net_cents = line_net_cents
where gross_line_net_cents is null and line_net_cents is not null;

alter table public.purchase_items
  drop constraint if exists purchase_items_company_discount_snapshot_check,
  add constraint purchase_items_company_discount_snapshot_check check (
    gross_line_net_cents is null or (
      gross_line_net_cents >= 0
      and discount_basis_points between 0 and 10000
      and discount_amount_cents >= 0
      and line_net_cents = gross_line_net_cents - discount_amount_cents
    )
  ),
  drop constraint if exists purchase_items_snapshot_version_check,
  add constraint purchase_items_snapshot_version_check
    check (snapshot_version in (0, 1, 2));

create table if not exists public.company_license_recipients (
  id uuid primary key default gen_random_uuid(),
  purchase_id uuid not null references public.purchases(id) on delete cascade,
  purchase_item_id uuid not null references public.purchase_items(id) on delete cascade,
  organization_id uuid not null references public.organizations(id) on delete restrict,
  given_name text not null,
  family_name text not null,
  email text not null,
  access_code_id uuid unique references public.access_codes(id) on delete set null,
  delivery_status public.company_license_delivery_status not null default 'pending',
  delivery_attempts integer not null default 0,
  next_attempt_at timestamptz default now(),
  delivery_locked_at timestamptz,
  email_sent_at timestamptz,
  email_message_id text,
  last_error text,
  redeemed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint company_license_recipient_name_check check (
    char_length(trim(given_name)) between 1 and 100
    and char_length(trim(family_name)) between 1 and 160
  ),
  constraint company_license_recipient_email_check check (
    email = lower(trim(email)) and char_length(email) between 5 and 320
  ),
  constraint company_license_delivery_attempts_check check (delivery_attempts >= 0),
  unique (purchase_id, email),
  unique (purchase_item_id, email)
);

create index if not exists company_license_recipients_org_idx
  on public.company_license_recipients (organization_id, created_at desc);
create index if not exists company_license_recipients_delivery_idx
  on public.company_license_recipients (delivery_status, next_attempt_at)
  where delivery_status in ('pending', 'failed', 'sending');

-- Ciphertext is deliberately separated from the browser-readable recipient
-- record. There is no authenticated policy or table grant on this table.
create table if not exists public.company_access_code_secrets (
  access_code_id uuid primary key references public.access_codes(id) on delete cascade,
  encryption_version smallint not null,
  ciphertext text not null,
  iv text not null,
  auth_tag text not null,
  created_at timestamptz not null default now(),
  constraint company_access_code_encryption_version_check check (encryption_version > 0)
);

alter table public.company_license_recipients enable row level security;
alter table public.company_license_recipients force row level security;
alter table public.company_access_code_secrets enable row level security;
alter table public.company_access_code_secrets force row level security;

drop policy if exists company_license_recipients_visible
  on public.company_license_recipients;
create policy company_license_recipients_visible
on public.company_license_recipients for select
to authenticated
using (
  (select app_private.current_user_manages_org(organization_id))
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

revoke all on public.company_license_recipients,
  public.company_access_code_secrets from public, anon, authenticated;
grant select on public.company_license_recipients to authenticated;
grant select, insert, update, delete on public.company_license_recipients
  to service_role;
grant select, insert on public.company_access_code_secrets to service_role;

create or replace function public.create_company_checkout_order(
  p_buyer_user_id uuid,
  p_existing_organization_id uuid,
  p_order_number text,
  p_idempotency_key text,
  p_course_version_id uuid,
  p_quantity integer,
  p_currency text,
  p_billing jsonb,
  p_invoice_email text,
  p_accepted_at timestamptz,
  p_legal_version text,
  p_contact jsonb,
  p_recipients jsonb,
  p_unit_net_cents bigint,
  p_gross_subtotal_cents bigint,
  p_discount_basis_points integer,
  p_discount_amount_cents bigint,
  p_subtotal_net_cents bigint,
  p_tax_rate_basis_points integer,
  p_tax_amount_cents bigint,
  p_total_amount_cents bigint,
  p_course_title text,
  p_course_code text,
  p_course_version integer,
  p_modality public.course_modality,
  p_duration_hours integer,
  p_description text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_org public.organizations%rowtype;
  target_purchase_id uuid;
  target_item_id uuid;
  recipient jsonb;
  normalized_tax_id text;
begin
  if p_quantity < 1 or p_quantity > 500 or p_recipients is null
     or jsonb_typeof(p_recipients) <> 'array'
     or jsonb_array_length(p_recipients) <> p_quantity
  then
    raise exception 'invalid_company_quantity_or_recipients';
  end if;

  if p_existing_organization_id is not null then
    select * into target_org from public.organizations
    where id = p_existing_organization_id for update;
    if not found then raise exception 'organization_not_found'; end if;
    if upper(regexp_replace(target_org.tax_id, '[^A-Za-z0-9]', '', 'g')) <>
       upper(regexp_replace(p_billing->>'taxId', '[^A-Za-z0-9]', '', 'g'))
    then raise exception 'organization_tax_id_mismatch'; end if;
    if not exists (
      select 1 from public.organization_members om
      where om.organization_id = target_org.id
        and om.user_id = p_buyer_user_id
        and om.role = 'responsable_empresa'
        and om.status = 'active'
    ) and not exists (
      select 1 from public.user_roles ur
      where ur.user_id = p_buyer_user_id and ur.role = 'superadministrador'
    ) then
      raise exception 'organization_forbidden';
    end if;
  else
    normalized_tax_id := upper(
      regexp_replace(p_billing->>'taxId', '[^A-Za-z0-9]', '', 'g')
    );
    -- Serialize concurrent first purchases for the same legal entity so a
    -- unique-index race becomes a deterministic ownership decision.
    perform pg_catalog.pg_advisory_xact_lock(
      pg_catalog.hashtextextended(normalized_tax_id, 0)
    );
    select * into target_org from public.organizations o
    where upper(regexp_replace(o.tax_id, '[^A-Za-z0-9]', '', 'g')) =
      normalized_tax_id
    for update;
    if found then
      if not exists (
        select 1 from public.organization_members om
        where om.organization_id = target_org.id
          and om.user_id = p_buyer_user_id
          and om.role = 'responsable_empresa'
          and om.status = 'active'
      ) then
        raise exception 'organization_already_registered';
      end if;
    else
      insert into public.organizations (
        legal_name, tax_id, billing_email, billing_address, status, created_by
      ) values (
        trim(p_billing->>'fiscalName'),
        upper(regexp_replace(p_billing->>'taxId', '[^A-Za-z0-9]', '', 'g')),
        lower(trim(p_billing->>'billingEmail')),
        jsonb_build_object(
          'line1', p_billing->>'addressLine1',
          'postal_code', p_billing->>'postalCode',
          'city', p_billing->>'city',
          'province', p_billing->>'province',
          'country_code', p_billing->>'countryCode'
        ),
        'pending', p_buyer_user_id
      ) returning * into target_org;

      insert into public.organization_members (
        organization_id, user_id, role, status, joined_at
      ) values (
        target_org.id, p_buyer_user_id, 'responsable_empresa', 'active', now()
      );
      insert into public.user_roles (user_id, role, source)
      values (p_buyer_user_id, 'responsable_empresa', 'company_checkout')
      on conflict (user_id, role) do nothing;
    end if;
  end if;

  insert into public.purchases (
    order_number, kind, buyer_user_id, organization_id, status,
    subtotal_net, tax_amount, total_amount, currency, billing_details,
    idempotency_key, billing_snapshot_version, billing_buyer_type,
    billing_name, billing_tax_id, billing_address_line1, billing_postal_code,
    billing_city, billing_province, billing_country_code, billing_email,
    billing_phone, invoice_email, contract_terms_accepted_at,
    contract_terms_version, privacy_policy_version, subtotal_net_cents,
    tax_amount_cents, total_amount_cents, tax_rate_basis_points,
    invoice_status, admin_notification_status, gross_subtotal_cents,
    discount_basis_points, discount_amount_cents, buyer_given_name,
    buyer_family_name, buyer_contact_email, buyer_contact_phone,
    participant_privacy_confirmed_at, participant_privacy_version
  ) values (
    p_order_number, 'company', p_buyer_user_id, target_org.id, 'draft',
    p_subtotal_net_cents::numeric / 100, p_tax_amount_cents::numeric / 100,
    p_total_amount_cents::numeric / 100, p_currency, p_billing,
    p_idempotency_key, 2, 'business', trim(p_billing->>'fiscalName'),
    upper(regexp_replace(p_billing->>'taxId', '[^A-Za-z0-9]', '', 'g')),
    trim(p_billing->>'addressLine1'), trim(p_billing->>'postalCode'),
    trim(p_billing->>'city'), trim(p_billing->>'province'),
    upper(trim(p_billing->>'countryCode')), lower(trim(p_billing->>'billingEmail')),
    nullif(trim(p_billing->>'phone'), ''), p_invoice_email, p_accepted_at,
    p_legal_version, p_legal_version, p_subtotal_net_cents,
    p_tax_amount_cents, p_total_amount_cents, p_tax_rate_basis_points,
    'pending_invoice', 'pending', p_gross_subtotal_cents,
    p_discount_basis_points, p_discount_amount_cents,
    trim(p_contact->>'givenName'), trim(p_contact->>'familyName'),
    lower(trim(p_contact->>'email')), nullif(trim(p_contact->>'phone'), ''),
    p_accepted_at, p_legal_version
  ) returning id into target_purchase_id;

  insert into public.purchase_items (
    purchase_id, course_version_id, quantity, unit_net, tax_rate,
    line_net, line_tax, line_total, currency, snapshot_version,
    course_title_snapshot, course_code_snapshot, course_version_snapshot,
    modality_snapshot, duration_hours_snapshot, description_snapshot,
    unit_net_cents, line_net_cents, line_tax_cents, line_total_cents,
    tax_rate_basis_points, gross_line_net_cents, discount_basis_points,
    discount_amount_cents
  ) values (
    target_purchase_id, p_course_version_id, p_quantity,
    p_unit_net_cents::numeric / 100, p_tax_rate_basis_points::numeric / 100,
    p_subtotal_net_cents::numeric / 100, p_tax_amount_cents::numeric / 100,
    p_total_amount_cents::numeric / 100, p_currency, 2, p_course_title,
    p_course_code, p_course_version, p_modality, p_duration_hours, p_description,
    p_unit_net_cents, p_subtotal_net_cents, p_tax_amount_cents,
    p_total_amount_cents, p_tax_rate_basis_points, p_gross_subtotal_cents,
    p_discount_basis_points, p_discount_amount_cents
  ) returning id into target_item_id;

  for recipient in select value from jsonb_array_elements(p_recipients)
  loop
    insert into public.company_license_recipients (
      purchase_id, purchase_item_id, organization_id,
      given_name, family_name, email
    ) values (
      target_purchase_id, target_item_id, target_org.id,
      trim(recipient->>'givenName'), trim(recipient->>'familyName'),
      lower(trim(recipient->>'email'))
    );
  end loop;

  return jsonb_build_object(
    'purchase_id', target_purchase_id,
    'purchase_item_id', target_item_id,
    'organization_id', target_org.id
  );
end;
$$;

revoke all on function public.create_company_checkout_order(
  uuid, uuid, text, text, uuid, integer, text, jsonb, text, timestamptz,
  text, jsonb, jsonb, bigint, bigint, integer, bigint, bigint, integer,
  bigint, bigint, text, text, integer, public.course_modality, integer, text
) from public, anon, authenticated;
grant execute on function public.create_company_checkout_order(
  uuid, uuid, text, text, uuid, integer, text, jsonb, text, timestamptz,
  text, jsonb, jsonb, bigint, bigint, integer, bigint, bigint, integer,
  bigint, bigint, text, text, integer, public.course_modality, integer, text
) to service_role;

create or replace function public.verify_company_stripe_amounts(
  p_purchase_id uuid,
  p_gross_subtotal_cents bigint,
  p_discount_amount_cents bigint,
  p_subtotal_net_cents bigint,
  p_tax_amount_cents bigint,
  p_total_amount_cents bigint
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare target public.purchases%rowtype;
begin
  select * into target from public.purchases where id = p_purchase_id for update;
  if not found then raise exception 'purchase_not_found'; end if;
  if target.kind = 'company' and (
    target.gross_subtotal_cents <> p_gross_subtotal_cents
    or target.discount_amount_cents <> p_discount_amount_cents
    or target.subtotal_net_cents <> p_subtotal_net_cents
    or target.tax_amount_cents <> p_tax_amount_cents
    or target.total_amount_cents <> p_total_amount_cents
  ) then raise exception 'stripe_totals_do_not_match_company_snapshot'; end if;
  return true;
end;
$$;
revoke all on function public.verify_company_stripe_amounts(
  uuid, bigint, bigint, bigint, bigint, bigint
) from public, anon, authenticated;
grant execute on function public.verify_company_stripe_amounts(
  uuid, bigint, bigint, bigint, bigint, bigint
) to service_role;

create or replace function public.provision_company_licenses(
  p_purchase_id uuid,
  p_licenses jsonb
)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_purchase public.purchases%rowtype;
  target_item public.purchase_items%rowtype;
  license jsonb;
  target_recipient public.company_license_recipients%rowtype;
  new_access_code_id uuid;
  created_count integer := 0;
  normalized_code text;
  missing_count integer;
begin
  select * into target_purchase from public.purchases
  where id = p_purchase_id for update;
  if not found or target_purchase.kind <> 'company'
     or target_purchase.status <> 'paid' or target_purchase.organization_id is null
  then raise exception 'purchase_not_eligible_for_licenses'; end if;

  select * into target_item from public.purchase_items
  where purchase_id = p_purchase_id order by created_at, id limit 1 for update;
  if not found then raise exception 'purchase_item_not_found'; end if;
  if (select count(*) from public.company_license_recipients
      where purchase_id = p_purchase_id) <> target_item.quantity
  then raise exception 'recipient_count_does_not_match_quantity'; end if;
  select count(*) into missing_count
  from public.company_license_recipients
  where purchase_id = p_purchase_id and access_code_id is null;
  if p_licenses is null or jsonb_typeof(p_licenses) <> 'array'
     or jsonb_array_length(p_licenses) <> missing_count
  then raise exception 'license_payload_does_not_match_missing_recipients'; end if;

  for license in select value from jsonb_array_elements(p_licenses)
  loop
    select * into target_recipient from public.company_license_recipients
    where id = (license->>'recipient_id')::uuid
      and purchase_id = p_purchase_id for update;
    if not found then raise exception 'recipient_not_found'; end if;
    if target_recipient.access_code_id is not null then continue; end if;

    normalized_code := upper(trim(license->>'plaintext_code'));
    if normalized_code !~ '^INM-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$'
    then raise exception 'invalid_access_code_format'; end if;

    insert into public.access_codes (
      purchase_item_id, course_version_id, organization_id, code_hash,
      code_last_four, status, reserved_for_email, reserved_at
    ) values (
      target_item.id, target_item.course_version_id, target_purchase.organization_id,
      extensions.digest(normalized_code, 'sha256'), right(normalized_code, 4),
      'reserved', target_recipient.email, now()
    ) returning id into new_access_code_id;

    insert into public.company_access_code_secrets (
      access_code_id, encryption_version, ciphertext, iv, auth_tag
    ) values (
      new_access_code_id, (license->>'encryption_version')::smallint,
      license->>'ciphertext', license->>'iv', license->>'auth_tag'
    );

    update public.company_license_recipients set
      access_code_id = new_access_code_id, updated_at = now()
    where id = target_recipient.id;
    created_count := created_count + 1;
  end loop;

  if (select count(*) from public.access_codes
      where purchase_item_id = target_item.id) <> target_item.quantity
  then raise exception 'license_count_does_not_match_quantity'; end if;
  return created_count;
end;
$$;
revoke all on function public.provision_company_licenses(uuid, jsonb)
  from public, anon, authenticated;
grant execute on function public.provision_company_licenses(uuid, jsonb)
  to service_role;

create or replace function public.claim_company_license_email(p_recipient_id uuid)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare affected integer;
begin
  update public.company_license_recipients set
    delivery_status = 'sending',
    delivery_attempts = delivery_attempts + 1,
    delivery_locked_at = now(),
    last_error = null,
    updated_at = now()
  where id = p_recipient_id
    and access_code_id is not null
    and (
      delivery_status in ('pending', 'failed')
      or (delivery_status = 'sending' and delivery_locked_at < now() - interval '15 minutes')
    )
    and (next_attempt_at is null or next_attempt_at <= now())
    and delivery_attempts < 6;
  get diagnostics affected = row_count;
  return affected = 1;
end;
$$;

create or replace function public.complete_company_license_email(
  p_recipient_id uuid, p_success boolean, p_message_id text, p_error text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.company_license_recipients set
    delivery_status = case
      when p_success then 'sent'::public.company_license_delivery_status
      else 'failed'::public.company_license_delivery_status
    end,
    email_sent_at = case when p_success then now() else email_sent_at end,
    email_message_id = case when p_success then nullif(p_message_id, '') else email_message_id end,
    last_error = case when p_success then null else left(coalesce(p_error, 'Error de envío'), 1000) end,
    next_attempt_at = case
      when p_success or delivery_attempts >= 6 then null
      else now() + (interval '5 minutes' * greatest(delivery_attempts, 1))
    end,
    delivery_locked_at = null,
    updated_at = now()
  where id = p_recipient_id and delivery_status = 'sending';
end;
$$;

revoke all on function public.claim_company_license_email(uuid),
  public.complete_company_license_email(uuid, boolean, text, text)
  from public, anon, authenticated;
grant execute on function public.claim_company_license_email(uuid),
  public.complete_company_license_email(uuid, boolean, text, text)
  to service_role;

create or replace function app_private.sync_company_license_redemption()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.status = 'used' and old.status is distinct from 'used' then
    update public.company_license_recipients
    set redeemed_at = coalesce(new.used_at, now()), updated_at = now()
    where access_code_id = new.id;
  end if;
  return new;
end;
$$;
revoke all on function app_private.sync_company_license_redemption() from public;
drop trigger if exists access_codes_sync_company_license_redemption
  on public.access_codes;
create trigger access_codes_sync_company_license_redemption
after update of status on public.access_codes
for each row execute function app_private.sync_company_license_redemption();

create or replace function app_private.protect_paid_company_snapshot()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.paid_at is not null and row(
    old.gross_subtotal_cents, old.discount_basis_points,
    old.discount_amount_cents, old.buyer_given_name, old.buyer_family_name,
    old.buyer_contact_email, old.buyer_contact_phone,
    old.participant_privacy_confirmed_at, old.participant_privacy_version
  ) is distinct from row(
    new.gross_subtotal_cents, new.discount_basis_points,
    new.discount_amount_cents, new.buyer_given_name, new.buyer_family_name,
    new.buyer_contact_email, new.buyer_contact_phone,
    new.participant_privacy_confirmed_at, new.participant_privacy_version
  ) then raise exception 'Paid company snapshot is immutable'; end if;
  return new;
end;
$$;
revoke all on function app_private.protect_paid_company_snapshot() from public;
drop trigger if exists purchases_protect_paid_company_snapshot on public.purchases;
create trigger purchases_protect_paid_company_snapshot
before update on public.purchases
for each row execute function app_private.protect_paid_company_snapshot();

create or replace function app_private.protect_paid_company_item_snapshot()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if exists (
    select 1 from public.purchases p
    where p.id = old.purchase_id and p.paid_at is not null
  ) and row(
    old.gross_line_net_cents, old.discount_basis_points,
    old.discount_amount_cents
  ) is distinct from row(
    new.gross_line_net_cents, new.discount_basis_points,
    new.discount_amount_cents
  ) then
    raise exception 'Paid company item snapshot is immutable';
  end if;
  return new;
end;
$$;
revoke all on function app_private.protect_paid_company_item_snapshot()
  from public;
drop trigger if exists purchase_items_protect_paid_company_snapshot
  on public.purchase_items;
create trigger purchase_items_protect_paid_company_snapshot
before update on public.purchase_items
for each row execute function app_private.protect_paid_company_item_snapshot();

create or replace function app_private.protect_company_recipient_identity()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if row(
    old.purchase_id, old.purchase_item_id, old.organization_id,
    old.given_name, old.family_name, old.email
  ) is distinct from row(
    new.purchase_id, new.purchase_item_id, new.organization_id,
    new.given_name, new.family_name, new.email
  ) or (
    old.access_code_id is not null
    and old.access_code_id is distinct from new.access_code_id
  ) then
    raise exception 'Company license recipient identity is immutable';
  end if;
  return new;
end;
$$;
revoke all on function app_private.protect_company_recipient_identity()
  from public;
drop trigger if exists company_license_recipients_protect_identity
  on public.company_license_recipients;
create trigger company_license_recipients_protect_identity
before update on public.company_license_recipients
for each row execute function app_private.protect_company_recipient_identity();

commit;
