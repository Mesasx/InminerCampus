-- InmínerCampus
-- Initialize sequential lesson state and fulfill paid individual orders in a
-- single database transaction.

create or replace function app_private.initialize_enrollment_progress()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.lesson_progress (
    enrollment_id,
    lesson_id,
    status
  )
  select
    new.id,
    ordered_lessons.id,
    case
      when ordered_lessons.sequence_number = 1
        then 'available'::public.lesson_progress_status
      else 'locked'::public.lesson_progress_status
    end
  from (
    select
      l.id,
      row_number() over (order by m.position, l.position) as sequence_number
    from public.course_modules m
    join public.lessons l on l.module_id = m.id
    where m.course_version_id = new.course_version_id
      and l.active = true
  ) ordered_lessons
  on conflict (enrollment_id, lesson_id) do nothing;

  return new;
end;
$$;

revoke all on function app_private.initialize_enrollment_progress() from public;

drop trigger if exists enrollments_initialize_progress on public.enrollments;
create trigger enrollments_initialize_progress
  after insert on public.enrollments
  for each row execute function app_private.initialize_enrollment_progress();

create or replace function public.fulfill_stripe_checkout(
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
  p_total_amount numeric
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

  update public.purchases
  set
    status = 'paid',
    stripe_checkout_session_id = p_checkout_session_id,
    stripe_payment_intent_id = nullif(p_payment_intent_id, ''),
    stripe_invoice_id = nullif(p_invoice_id, ''),
    stripe_customer_id = nullif(p_stripe_customer_id, ''),
    subtotal_net = p_subtotal_net,
    tax_amount = p_tax_amount,
    total_amount = p_total_amount,
    paid_at = coalesce(paid_at, now())
  where id = p_purchase_id;

  update public.purchase_items
  set
    line_tax = p_tax_amount,
    line_total = p_total_amount
  where purchase_id = p_purchase_id;

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

revoke all on function public.fulfill_stripe_checkout(
  text, text, boolean, uuid, text, text, text, text, numeric, numeric, numeric
) from public, anon, authenticated;

grant execute on function public.fulfill_stripe_checkout(
  text, text, boolean, uuid, text, text, text, text, numeric, numeric, numeric
) to service_role;
