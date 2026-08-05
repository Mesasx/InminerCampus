begin;

-- The first billing migration kept the legacy table-level SELECT grant for
-- compatibility. Replace it with an explicit buyer-safe column allowlist so
-- internal notes, notification failures and Stripe/idempotency identifiers
-- cannot be read through the browser API.
revoke select on public.purchases from authenticated;

grant select (
  id,
  order_number,
  kind,
  buyer_user_id,
  organization_id,
  status,
  subtotal_net,
  tax_amount,
  total_amount,
  currency,
  billing_details,
  paid_at,
  refunded_at,
  created_at,
  updated_at,
  billing_snapshot_version,
  billing_buyer_type,
  billing_name,
  billing_tax_id,
  billing_address_line1,
  billing_postal_code,
  billing_city,
  billing_province,
  billing_country_code,
  billing_email,
  billing_phone,
  invoice_email,
  contract_terms_accepted_at,
  contract_terms_version,
  privacy_policy_version,
  subtotal_net_cents,
  tax_amount_cents,
  total_amount_cents,
  tax_rate_basis_points,
  invoice_status,
  invoice_number,
  invoiced_at,
  invoice_sent_at,
  refunded_amount_cents
) on public.purchases to authenticated;

commit;
