-- InmínerCampus
-- Create one-time company access codes without storing their plaintext value.

create or replace function public.create_company_access_code_batch(
  p_purchase_item_id uuid,
  p_plaintext_codes text[]
)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_item public.purchase_items%rowtype;
  target_purchase public.purchases%rowtype;
  existing_code_count integer;
  requested_code_count integer;
  normalized_code text;
begin
  requested_code_count := coalesce(array_length(p_plaintext_codes, 1), 0);
  if requested_code_count = 0 then
    raise exception 'At least one code is required';
  end if;

  select pi.*
  into target_item
  from public.purchase_items pi
  where pi.id = p_purchase_item_id
  for update;

  if not found then
    raise exception 'Purchase item not found';
  end if;

  select p.*
  into target_purchase
  from public.purchases p
  where p.id = target_item.purchase_id
  for update;

  if target_purchase.kind <> 'company'
     or target_purchase.status <> 'paid'
     or target_purchase.organization_id is null
  then
    raise exception 'Purchase is not eligible for company codes';
  end if;

  select count(*)
  into existing_code_count
  from public.access_codes
  where purchase_item_id = p_purchase_item_id;

  if existing_code_count + requested_code_count > target_item.quantity then
    raise exception 'Requested codes exceed purchased seats';
  end if;

  foreach normalized_code in array p_plaintext_codes loop
    normalized_code := upper(trim(normalized_code));
    if normalized_code !~ '^INM-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$' then
      raise exception 'Invalid access-code format';
    end if;

    insert into public.access_codes (
      purchase_item_id,
      course_version_id,
      organization_id,
      code_hash,
      code_last_four,
      status
    )
    values (
      p_purchase_item_id,
      target_item.course_version_id,
      target_purchase.organization_id,
      extensions.digest(normalized_code, 'sha256'),
      right(normalized_code, 4),
      'available'
    );
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
    null,
    target_purchase.organization_id,
    'access_codes.batch_created',
    'purchase_item',
    p_purchase_item_id::text,
    jsonb_build_object('count', requested_code_count)
  );

  return requested_code_count;
end;
$$;

revoke all on function public.create_company_access_code_batch(uuid, text[])
  from public, anon, authenticated;
grant execute on function public.create_company_access_code_batch(uuid, text[])
  to service_role;
