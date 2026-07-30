import assert from 'node:assert/strict'
import test from 'node:test'
import {
  calculateOrderAmounts,
  checkoutRequestSchema,
  decimalToCents,
  isValidSpanishTaxIdentifier,
  taxRateToBasisPoints,
} from '../src/lib/billing.ts'

const validBilling = {
  buyerType: 'individual' as const,
  fiscalName: 'Ana García López',
  taxId: '12345678Z',
  addressLine1: 'Calle Mayor 12',
  postalCode: '28013',
  city: 'Madrid',
  province: 'Madrid',
  countryCode: 'ES',
  billingEmail: 'ana@example.com',
  phone: '',
  sendInvoiceToDifferentEmail: false,
  invoiceEmail: '',
  acceptLegal: true,
}

test('calcula los importes exactos de cada precio publicado al 21% de IVA', () => {
  const cases = [
    { net: '149.00', tax: 3_129, total: 18_029 },
    { net: '189.00', tax: 3_969, total: 22_869 },
    { net: '349.00', tax: 7_329, total: 42_229 },
  ]
  for (const expected of cases) {
    const amounts = calculateOrderAmounts(
      decimalToCents(expected.net),
      1,
      taxRateToBasisPoints('21.00'),
    )
    assert.equal(amounts.taxAmountCents, expected.tax)
    assert.equal(amounts.totalAmountCents, expected.total)
  }
})

test('multiplica plazas antes de redondear el IVA', () => {
  const amounts = calculateOrderAmounts(14_900, 7, 2_100)
  assert.deepEqual(amounts, {
    unitNetCents: 14_900,
    subtotalNetCents: 104_300,
    taxAmountCents: 21_903,
    totalAmountCents: 126_203,
    taxRateBasisPoints: 2_100,
  })
})

test('rechaza un importe manipulado enviado por el navegador', () => {
  const result = checkoutRequestSchema.safeParse({
    courseVersionId: 'cb8db9a1-3891-4df6-bb63-66c39f58f0f5',
    checkoutRequestId: '11111111-1111-4111-8111-111111111111',
    kind: 'individual',
    quantity: 1,
    billing: validBilling,
    amount: 1,
  })
  assert.equal(result.success, false)
})

test('valida DNI y rechaza identificadores españoles con control incorrecto', () => {
  assert.equal(isValidSpanishTaxIdentifier('12345678Z'), true)
  assert.equal(isValidSpanishTaxIdentifier('12345678A'), false)
})
