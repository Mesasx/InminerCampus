import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'

const migrationUrl = new URL(
  '../supabase/migrations/20260820160000_automate_billing_mnprogram.sql',
  import.meta.url,
)

test('la automatización de facturas es idempotente y usa contador transaccional', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  assert.match(sql, /purchase_id uuid not null unique/)
  assert.match(sql, /unique \(invoice_id, type\)/)
  assert.match(sql, /on conflict \(invoice_series, invoice_year\) do update/)
  assert.match(sql, /for update skip locked/)
  assert.match(sql, /claim_archive_jobs/)
  assert.match(sql, /locked_at < now\(\) - interval '15 minutes'/)
  assert.doesNotMatch(sql, /max\s*\(\s*invoice_sequence/i)
  assert.match(sql, /perform app_private\.enqueue_invoice_for_purchase\(p_purchase_id\)/)
})

test('protege PDF, RLS, cola con backoff y reembolsos rectificativos', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  assert.match(sql, /Issued invoice PDF is immutable/)
  assert.match(sql, /billing-documents[\s\S]*?false/)
  assert.match(sql, /enable row level security/g)
  assert.match(sql, /to service_role/)
  assert.match(sql, /interval '1 minute'/)
  assert.match(sql, /interval '5 minutes'/)
  assert.match(sql, /interval '15 minutes'/)
  assert.match(sql, /interval '1 hour'/)
  assert.match(sql, /interval '6 hours'/)
  assert.match(sql, /refund_requires_credit_note = true/)
})

test('incluye el rate limiter requerido por el agente de archivo', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const rateLimitDefinition = sql.indexOf(
    'create or replace function app_private.check_rate_limit',
  )
  const archiveRateLimitUsage = sql.indexOf(
    'create or replace function public.check_archive_agent_rate_limit',
  )

  assert.match(sql, /create table if not exists app_private\.rate_limit_hits/)
  assert.ok(rateLimitDefinition >= 0)
  assert.ok(archiveRateLimitUsage > rateLimitDefinition)
  assert.match(
    sql,
    /revoke all on function app_private\.check_rate_limit\([\s\S]*?from public, anon, authenticated/,
  )
})
