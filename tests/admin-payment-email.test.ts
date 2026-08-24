import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import {
  createCustomerAdministrativeData,
  type PurchaseForAdministrativeNotification,
} from '../src/server/customer-administrative-data.ts'

const individualPurchase: PurchaseForAdministrativeNotification = {
  id: '11111111-1111-4111-8111-111111111111',
  order_number: 'INM-2026-0001',
  kind: 'individual',
  status: 'paid',
  paid_at: '2026-08-24T10:30:00.000Z',
  billing_buyer_type: 'individual',
  billing_name: 'Ana García López',
  billing_tax_id: '12345678Z',
  billing_address_line1: 'Calle Mayor 12',
  billing_postal_code: '28013',
  billing_city: 'Madrid',
  billing_province: 'Madrid',
  billing_country_code: 'ES',
  billing_email: 'ana@example.com',
  billing_phone: '+34 600 123 123',
  invoice_email: 'facturas@example.com',
  subtotal_net_cents: 14_900,
  tax_amount_cents: 3_129,
  total_amount_cents: 18_029,
  tax_rate_basis_points: 2_100,
  currency: 'EUR',
  stripe_event_id: 'evt_test_individual',
  stripe_payment_intent_id: 'pi_test_individual',
  stripe_checkout_session_id: 'cs_test_individual',
  invoice_status: 'pending_invoice',
  gross_subtotal_cents: 14_900,
  discount_basis_points: 0,
  discount_amount_cents: 0,
  buyer_given_name: 'Ana',
  buyer_family_name: 'García López',
  buyer_contact_email: 'ana@example.com',
  buyer_contact_phone: '+34 600 123 123',
  purchase_items: [
    {
      course_title_snapshot: 'Operador de maquinaria',
      course_code_snapshot: 'ITC 02.1.02',
      course_version_snapshot: 3,
      modality_snapshot: 'online',
      duration_hours_snapshot: 20,
      quantity: 1,
      unit_net_cents: 14_900,
      line_net_cents: 14_900,
      line_tax_cents: 3_129,
      line_total_cents: 18_029,
      description_snapshot: 'Formación preventiva',
    },
  ],
  company_license_recipients: [],
}

const companyPurchase: PurchaseForAdministrativeNotification = {
  ...individualPurchase,
  id: '22222222-2222-4222-8222-222222222222',
  order_number: 'INM-2026-0002',
  kind: 'company',
  billing_buyer_type: 'business',
  billing_name: 'Canteras Seguras, S.L.',
  billing_tax_id: 'B13476148',
  billing_email: 'facturacion@canteras.example',
  billing_phone: '+34 953 100 200',
  invoice_email: 'facturas@canteras.example',
  subtotal_net_cents: 42_465,
  tax_amount_cents: 8_918,
  total_amount_cents: 51_383,
  gross_subtotal_cents: 44_700,
  discount_basis_points: 500,
  discount_amount_cents: 2_235,
  buyer_given_name: 'Pedro',
  buyer_family_name: 'Muñoz Ruiz',
  buyer_contact_email: 'pedro@canteras.example',
  buyer_contact_phone: '+34 611 222 333',
  stripe_event_id: 'evt_test_company',
  stripe_payment_intent_id: 'pi_test_company',
  stripe_checkout_session_id: 'cs_test_company',
  purchase_items: [
    {
      ...individualPurchase.purchase_items[0],
      quantity: 3,
      line_net_cents: 42_465,
      line_tax_cents: 8_918,
      line_total_cents: 51_383,
    },
  ],
  company_license_recipients: [
    { given_name: 'Lucía', family_name: 'Sanz', email: 'lucia@example.com' },
    { given_name: 'Mario', family_name: 'Gil', email: 'mario@example.com' },
    { given_name: 'Eva', family_name: 'León', email: 'eva@example.com' },
  ],
}

test('el aviso de particular separa nombre y apellidos e incluye la compra', () => {
  const data = createCustomerAdministrativeData(individualPurchase)

  assert.equal(data.customerType, 'Particular')
  assert.equal(data.customer.givenName, 'Ana')
  assert.equal(data.customer.familyName, 'García López')
  assert.equal(data.purchase.courseCode, 'ITC 02.1.02')
  assert.equal(data.purchase.totalAmountCents, 18_029)
  assert.equal(data.purchase.stripeEventId, 'evt_test_individual')
})

test('el aviso de empresa no mezcla razón social y persona de contacto', async () => {
  const data = createCustomerAdministrativeData(companyPurchase)
  const emailSource = await readFile(
    new URL('../src/server/admin-payment-email.ts', import.meta.url),
    'utf8',
  )

  assert.equal(data.customerType, 'Empresa')
  assert.equal(data.customer.fiscalName, 'Canteras Seguras, S.L.')
  assert.equal(data.contact?.fullName, 'Pedro Muñoz Ruiz')
  assert.equal(data.purchase.quantity, 3)
  assert.equal(data.participants.length, 3)
  assert.match(emailSource, /brand\/inminer-campus-logo\.png/)
  assert.match(emailSource, /Datos del \$\{data\.customerType/)
  assert.match(emailSource, /Persona de contacto/)
  assert.match(emailSource, /Datos preparados para MN Program/)
  assert.match(emailSource, /no realiza ningún alta automática en MN Program/)
  assert.match(emailSource, /Plazas\/licencias/)
  assert.doesNotMatch(
    emailSource,
    /access_code|plaintext_code|company_access_code_secrets/,
  )
})

test('la entrega conserva idempotencia y el destinatario administrativo configurable', async () => {
  const [emailSource, envExample] = await Promise.all([
    readFile(
      new URL('../src/server/admin-payment-email.ts', import.meta.url),
      'utf8',
    ),
    readFile(new URL('../.env.example', import.meta.url), 'utf8'),
  ])

  assert.match(emailSource, /Idempotency-Key.*purchase-paid\//s)
  assert.match(emailSource, /process\.env\.ADMIN_SALES_EMAIL/)
  assert.match(envExample, /ADMIN_SALES_EMAIL=administracion@inminer\.es/)
})

test('la migración prepara el aviso al confirmar snapshots individuales y empresariales', async () => {
  const sql = await readFile(
    new URL(
      '../supabase/migrations/20260824121002_ensure_admin_purchase_notifications.sql',
      import.meta.url,
    ),
    'utf8',
  )

  assert.match(sql, /before update of status on public\.purchases/)
  assert.match(sql, /new\.status = 'paid'/)
  assert.match(sql, /billing_snapshot_version in \(1, 2\)/)
  assert.match(sql, /admin_notification_status <> 'sent'/)
})
