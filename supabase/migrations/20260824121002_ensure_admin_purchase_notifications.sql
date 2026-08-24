-- Keep the administrative email durable for every current billing snapshot.
-- Delivery remains outside the database; this only prepares the outbox state.
create or replace function app_private.prepare_admin_purchase_notification()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.status = 'paid'
     and old.status is distinct from 'paid'
     and new.billing_snapshot_version in (1, 2)
     and new.admin_notification_status <> 'sent'
  then
    new.admin_notification_status = 'pending';
    new.admin_notification_error = null;
  end if;

  return new;
end;
$$;

revoke all on function app_private.prepare_admin_purchase_notification()
  from public;

drop trigger if exists purchases_prepare_admin_notification
  on public.purchases;

create trigger purchases_prepare_admin_notification
before update of status on public.purchases
for each row
execute function app_private.prepare_admin_purchase_notification();

comment on function app_private.prepare_admin_purchase_notification() is
  'Prepares one durable administrative email when a billing purchase becomes paid.';
