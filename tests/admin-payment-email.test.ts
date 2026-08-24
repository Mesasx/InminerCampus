import assert from 'node:assert/strict'
import test from 'node:test'
import {
  buildPaymentEmailHtml,
  buildPaymentEmailText,
  type PurchaseForNotification,
} from '../src/server/admin-payment-email-content.ts'

const purchase: PurchaseForNotification = {
  id: '0f747d75-3fd4-4e38-b54c-c7e1bcbdb614',
  order_number: 'INM-TEST-001',
  kind: 'company',
  paid_at: '2026-08-20T10:00:00.000Z',
  billing_name: 'Empresa <Prueba>',
  billing_tax_id: 'B12345678',
  billing_address_line1: 'Calle Mayor, 1',
  billing_postal_code: '13001',
  billing_city: 'Ciudad Real',
  billing_province: 'Ciudad Real',
  billing_country_code: 'ES',
  billing_email: 'compras@example.com',
  billing_phone: '+34 600 000 000',
  invoice_email: 'facturas@example.com',
  subtotal_net_cents: 29_800,
  tax_amount_cents: 6_258,
  total_amount_cents: 36_058,
  tax_rate_basis_points: 2_100,
  currency: 'EUR',
  stripe_checkout_session_id: 'cs_test_123',
  stripe_payment_intent_id: 'pi_test_123',
  purchase_items: [
    {
      course_title_snapshot: 'Curso de prueba',
      course_code_snapshot: 'curso-prueba',
      course_version_snapshot: 2,
      modality_snapshot: 'online',
      duration_hours_snapshot: 20,
      description_snapshot: 'Curso de prueba · Versión 2 · 20 horas',
      quantity: 2,
      unit_net_cents: 14_900,
      line_net_cents: 29_800,
      line_tax_cents: 6_258,
      line_total_cents: 36_058,
    },
  ],
}

test('el aviso contiene los datos necesarios para facturar en MNprogram', () => {
  const text = buildPaymentEmailText(purchase, 'https://inminercampus.com')
  for (const expected of [
    'generar y enviar la factura manualmente desde MNprogram',
    'INM-TEST-001',
    'B12345678',
    'Descripción para factura',
    'Precio unitario sin IVA',
    'Base imponible',
    'IVA (21%)',
    'facturas@example.com',
    'cs_test_123',
    'pi_test_123',
    '/admin/facturacion?pedido=0f747d75-3fd4-4e38-b54c-c7e1bcbdb614',
  ]) {
    assert.match(text, new RegExp(expected.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')))
  }
})

test('el HTML escapa los datos fiscales aportados por el cliente', () => {
  const html = buildPaymentEmailHtml(purchase, 'https://inminercampus.com')
  assert.match(html, /Empresa &lt;Prueba&gt;/)
  assert.doesNotMatch(html, /Empresa <Prueba>/)
  assert.match(html, /Acción requerida/)
})
