import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202607300009_billing_admin_notifications.sql',
  import.meta.url,
)
const commerceMigrationUrl = new URL(
  '../supabase/migrations/202607290003_commerce_practices_support_certificates.sql',
  import.meta.url,
)
const hardeningMigrationUrl = new URL(
  '../supabase/migrations/202607300010_billing_permissions_hardening.sql',
  import.meta.url,
)

test('la migración protege snapshots, webhooks y permisos económicos', async () => {
  const [billingSql, commerceSql, hardeningSql] = await Promise.all([
    readFile(migrationUrl, 'utf8'),
    readFile(commerceMigrationUrl, 'utf8'),
    readFile(hardeningMigrationUrl, 'utf8'),
  ])
  const sql = `${commerceSql}\n${billingSql}\n${hardeningSql}`
  assert.match(sql, /purchases_idempotency_key_unique_idx/i)
  assert.match(sql, /purchase_items_protect_paid_snapshot/i)
  assert.match(sql, /fulfill_stripe_checkout_v2/i)
  assert.match(sql, /current_event_status = 'processed'/i)
  assert.match(sql, /claim_admin_payment_notification/i)
  assert.match(sql, /revoke insert, update, delete on public\.purchases/i)
  assert.match(
    hardeningSql,
    /revoke select on public\.purchases from authenticated/i,
  )
  const buyerColumnGrant =
    hardeningSql.match(
      /grant select \(([\s\S]*?)\) on public\.purchases to authenticated/i,
    )?.[0] ?? ''
  assert.ok(buyerColumnGrant)
  assert.doesNotMatch(
    buyerColumnGrant,
    /admin_notes|admin_notification_error|idempotency_key/i,
  )
  assert.match(sql, /grant execute on function public\.fulfill_stripe_checkout_v2[\s\S]*to service_role/i)
})
