import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'

async function source(relativePath: string) {
  return readFile(new URL(`../${relativePath}`, import.meta.url), 'utf8')
}

test('Checkout queda deshabilitado y no inicia ningún pago', async () => {
  const checkout = await source('src/routes/api.checkout.ts')
  assert.match(checkout, /status: 410/)
  assert.match(checkout, /contratación por internet no está disponible/)
  assert.doesNotMatch(checkout, /stripe\.checkout|sessions\.create|coupons\.create/)
})

test('las antiguas rutas de compra redirigen a páginas informativas', async () => {
  const [individual, company, confirmation] = await Promise.all([
    source('src/routes/comprar.$courseSlug.tsx'),
    source('src/routes/comprar-empresa.$courseSlug.tsx'),
    source('src/routes/pago.confirmado.tsx'),
  ])
  assert.match(individual, /beforeLoad/)
  assert.match(individual, /to: '\/catalogo'/)
  assert.match(company, /beforeLoad/)
  assert.match(company, /to: '\/empresas'/)
  assert.match(confirmation, /beforeLoad/)
  assert.match(confirmation, /to: '\/catalogo'/)
})

test('el webhook reconcilia bruto, descuento, base e impuestos de Stripe', async () => {
  const webhook = await source('src/routes/api.stripe-webhook.ts')
  assert.match(webhook, /amount_subtotal/)
  assert.match(webhook, /amount_discount/)
  assert.match(webhook, /verify_company_stripe_amounts/)
  assert.match(webhook, /checkout\.session\.async_payment_succeeded/)
  assert.match(webhook, /session\.payment_status !== 'paid'/)
  assert.match(webhook, /confirmed payment received/)
  assert.match(webhook, /admin notification starting/)
  assert.match(webhook, /admin notification completed/)
})

test('el webhook no llama a MNprogram y encola dentro de la transacción', async () => {
  const webhook = await source('src/routes/api.stripe-webhook.ts')
  const migration = await source(
    'supabase/migrations/20260820160000_automate_billing_mnprogram.sql',
  )
  assert.doesNotMatch(webhook, /MnProgram|ContratosCliente|mnprogram_sync/)
  assert.match(webhook, /fulfill_stripe_checkout_v2/)
  assert.match(
    migration,
    /perform app_private\.enqueue_invoice_for_purchase\(p_purchase_id\)/,
  )
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
