import assert from 'node:assert/strict'
import test from 'node:test'
import {
  calculateOrderAmounts,
  checkoutRequestSchema,
  decimalToCents,
  getCompanyVolumeDiscountBasisPoints,
  isValidSpanishTaxIdentifier,
  taxRateToBasisPoints,
} from '../src/lib/billing.ts'

const validBilling = {
  buyerType: 'individual' as const,
  givenName: 'Ana',
  familyName: 'García López',
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
    grossSubtotalCents: 104_300,
    discountBasisPoints: 0,
    discountAmountCents: 0,
    subtotalNetCents: 104_300,
    taxAmountCents: 21_903,
    totalAmountCents: 126_203,
    taxRateBasisPoints: 2_100,
  })
})

test('rechaza importes y descuentos manipulados enviados por el navegador', () => {
  for (const manipulated of [
    { amount: 1 },
    { total: 1 },
    { unitPrice: 1 },
    { discount: 100 },
  ]) {
    const result = checkoutRequestSchema.safeParse({
      courseVersionId: 'cb8db9a1-3891-4df6-bb63-66c39f58f0f5',
      checkoutRequestId: '11111111-1111-4111-8111-111111111111',
      kind: 'individual',
      quantity: 1,
      billing: validBilling,
      ...manipulated,
    })
    assert.equal(result.success, false)
  }
})

test('valida DNI y rechaza identificadores españoles con control incorrecto', () => {
  assert.equal(isValidSpanishTaxIdentifier('12345678Z'), true)
  assert.equal(isValidSpanishTaxIdentifier('12345678A'), false)
})

test('acepta compra de empresa con varias plazas y organización', () => {
  const result = checkoutRequestSchema.safeParse({
    courseVersionId: 'cb8db9a1-3891-4df6-bb63-66c39f58f0f5',
    checkoutRequestId: '11111111-1111-4111-8111-111111111111',
    organizationId: '22222222-2222-4222-8222-222222222222',
    kind: 'company',
    quantity: 25,
    billing: {
      ...validBilling,
      buyerType: 'business',
      fiscalName: 'INMÍNER Ingeniería, S.L.',
      taxId: 'B13476148',
    },
    contact: {
      givenName: 'Ana',
      familyName: 'García',
      email: 'ana@example.com',
      phone: '',
    },
    recipients: Array.from({ length: 25 }, (_, index) => ({
      givenName: `Persona ${index + 1}`,
      familyName: 'Empresa',
      email: `persona${index + 1}@example.com`,
    })),
    participantPrivacyConfirmed: true,
  })
  assert.equal(result.success, true)
})

test('aplica los tramos empresariales sin acumular descuentos', () => {
  const cases = [
    [1, 0], [5, 0], [6, 500], [7, 500], [8, 1_000], [9, 1_000], [20, 1_000], [500, 1_000],
  ] as const
  for (const [quantity, expected] of cases) {
    assert.equal(getCompanyVolumeDiscountBasisPoints(quantity), expected)
  }
})

test('descuenta antes del IVA y redondea exclusivamente en céntimos', () => {
  const six = calculateOrderAmounts(14_900, 6, 2_100, 500)
  assert.deepEqual(six, {
    unitNetCents: 14_900,
    grossSubtotalCents: 89_400,
    discountBasisPoints: 500,
    discountAmountCents: 4_470,
    subtotalNetCents: 84_930,
    taxAmountCents: 17_835,
    totalAmountCents: 102_765,
    taxRateBasisPoints: 2_100,
  })
  const eight = calculateOrderAmounts(14_900, 8, 2_100, 1_000)
  assert.equal(eight.discountAmountCents, 11_920)
  assert.equal(eight.subtotalNetCents, 107_280)
  assert.equal(eight.taxAmountCents, 22_529)
  assert.equal(eight.totalAmountCents, 129_809)
})

test('reconstruye los casos empresariales de 5, 6, 7, 8 y 20 plazas', () => {
  const expected = [
    [5, 0, 74_500, 0, 74_500, 15_645, 90_145],
    [6, 500, 89_400, 4_470, 84_930, 17_835, 102_765],
    [7, 500, 104_300, 5_215, 99_085, 20_808, 119_893],
    [8, 1_000, 119_200, 11_920, 107_280, 22_529, 129_809],
    [20, 1_000, 298_000, 29_800, 268_200, 56_322, 324_522],
  ] as const

  for (const [quantity, basisPoints, gross, discount, net, tax, total] of expected) {
    const amounts = calculateOrderAmounts(14_900, quantity, 2_100, basisPoints)
    assert.equal(amounts.grossSubtotalCents, gross)
    assert.equal(amounts.discountAmountCents, discount)
    assert.equal(amounts.subtotalNetCents, net)
    assert.equal(amounts.taxAmountCents, tax)
    assert.equal(amounts.totalAmountCents, total)
  }
})

test('valida CIF y NIE españoles', () => {
  assert.equal(isValidSpanishTaxIdentifier('B13476148'), true)
  assert.equal(isValidSpanishTaxIdentifier('X1234567L'), true)
  assert.equal(isValidSpanishTaxIdentifier('X1234567A'), false)
})
