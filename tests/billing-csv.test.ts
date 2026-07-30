import assert from 'node:assert/strict'
import test from 'node:test'
import { createBillingCsv, csvCell } from '../src/lib/billing-csv.ts'

test('neutraliza fórmulas y escapa comillas en el CSV', () => {
  assert.equal(csvCell('=HYPERLINK("https://example.com")'), `"'=HYPERLINK(""https://example.com"")"`)
})

test('exporta importes en euros con BOM y separador compatible', () => {
  const csv = createBillingCsv([
    {
      order_number: 'INM-001',
      paid_at: '2026-07-30T10:00:00.000Z',
      invoice_status: 'pending_invoice',
      invoice_number: null,
      billing_name: 'Cliente de prueba',
      billing_tax_id: '12345678Z',
      billing_email: 'cliente@example.com',
      invoice_email: 'facturas@example.com',
      subtotal_net_cents: 14_900,
      tax_amount_cents: 3_129,
      total_amount_cents: 18_029,
      currency: 'EUR',
      stripe_payment_intent_id: 'pi_test',
      purchase_items: [
        {
          course_title_snapshot: 'Curso',
          course_version_snapshot: 1,
          quantity: 1,
        },
      ],
    },
  ])
  assert.equal(csv.startsWith('\uFEFF'), true)
  assert.match(csv, /"149,00";"31,29";"180,29";"EUR"/)
})
