import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'

async function source(relativePath: string) {
  return readFile(new URL(`../${relativePath}`, import.meta.url), 'utf8')
}

test('Checkout conserva métodos dinámicos e idempotencia de Stripe', async () => {
  const checkout = await source('src/routes/api.checkout.ts')
  assert.doesNotMatch(checkout, /payment_method_types/)
  assert.match(checkout, /idempotencyKey/)
  assert.match(checkout, /integration_identifier/)
  assert.match(checkout, /STRIPE_INVOICE_CREATION_ENABLED/)
  assert.match(checkout, /toLowerCase\(\) ===\s*'true'/)
  assert.match(checkout, /course_code_snapshot/)
  assert.match(checkout, /description_snapshot/)
})

test('el webhook no llama directamente a MNprogram', async () => {
  const webhook = await source('src/routes/api.stripe-webhook.ts')
  assert.doesNotMatch(webhook, /MnProgram|ContratosCliente|mnprogram_sync/)
  assert.match(webhook, /fulfill_stripe_checkout_v2/)
})

test('la facturación automática no tiene cron ni migración activa', async () => {
  const vercel = JSON.parse(await source('vercel.json')) as { crons?: unknown[] }
  const disabledMigration = await source(
    'supabase/migrations-disabled/20260820160000_automate_billing_mnprogram.sql',
  )
  assert.equal(vercel.crons, undefined)
  assert.match(disabledMigration, /Future design only/)
})

test('un fallo posterior a la emisión reanuda el PDF sin volver a emitir', async () => {
  const jobs = await source('src/server/billing/billing-jobs.ts')
  const resumePosition = jobs.indexOf(
    'if (context.official_invoice_number && context.issued_at)',
  )
  const issuePosition = jobs.indexOf('provider.issueInvoice(context.id)')
  assert.ok(resumePosition >= 0)
  assert.ok(issuePosition > resumePosition)
  assert.match(jobs, /upsert: false/)
  assert.match(jobs, /Idempotency-Key/)
})

test('el proveedor MNprogram no inventa operaciones fiscales privadas', async () => {
  const provider = await source(
    'src/server/integrations/mnprogram/invoice-provider.ts',
  )
  assert.match(provider, /NOT_CONFIGURED/)
  assert.doesNotMatch(provider, /CrearFactura|CreateInvoice|AltaFactura|RegistrarCobro/)
})
