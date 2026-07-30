import assert from 'node:assert/strict'
import test from 'node:test'
import { runPaymentNotification } from '../src/server/payment-notification-orchestrator.ts'

const purchase = {
  id: '11111111-1111-4111-8111-111111111111',
  order_number: 'INM-001',
  kind: 'individual',
  paid_at: '2026-07-30T10:00:00.000Z',
  billing_name: 'Ana García López',
  billing_tax_id: '12345678Z',
  billing_address_line1: 'Calle Mayor 12',
  billing_postal_code: '28013',
  billing_city: 'Madrid',
  billing_province: 'Madrid',
  billing_country_code: 'ES',
  billing_email: 'ana@example.com',
  billing_phone: null,
  invoice_email: 'ana@example.com',
  subtotal_net_cents: 14_900,
  tax_amount_cents: 3_129,
  total_amount_cents: 18_029,
  tax_rate_basis_points: 2_100,
  currency: 'EUR',
  stripe_payment_intent_id: 'pi_test',
  purchase_items: [
    {
      course_title_snapshot: 'Curso',
      course_version_snapshot: 1,
      modality_snapshot: 'hybrid',
      duration_hours_snapshot: 5,
      quantity: 1,
    },
  ],
}

test('un pago repetido solo envía un aviso administrativo', async () => {
  let available = true
  let sends = 0
  const completed: boolean[] = []
  const dependencies = {
    claim: async () => {
      if (!available) return false
      available = false
      return true
    },
    load: async () => purchase,
    send: async () => {
      sends += 1
      return 'email_123'
    },
    complete: async ({ success }: { success: boolean }) => {
      completed.push(success)
    },
  }

  assert.equal(
    await runPaymentNotification(purchase.id, dependencies),
    'sent',
  )
  assert.equal(
    await runPaymentNotification(purchase.id, dependencies),
    'already_sent',
  )
  assert.equal(sends, 1)
  assert.deepEqual(completed, [true])
})

test('un fallo de correo se registra sin alterar el estado del pago', async () => {
  let paymentStatus = 'paid'
  let completed:
    | { success: boolean; error: string }
    | undefined
  await assert.rejects(
    runPaymentNotification(purchase.id, {
      claim: async () => true,
      load: async () => purchase,
      send: async () => {
        throw new Error('Resend unavailable')
      },
      complete: async ({ success, error }) => {
        completed = { success, error }
      },
    }),
    /Resend unavailable/,
  )
  assert.equal(paymentStatus, 'paid')
  assert.deepEqual(completed, {
    success: false,
    error: 'Resend unavailable',
  })
  paymentStatus = 'paid'
})
