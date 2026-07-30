import { z } from 'zod'

export const BILLING_LEGAL_VERSION = '2026-07-29'

export type BillingBuyerType = 'individual' | 'business'

export type BillingFormValue = {
  buyerType: BillingBuyerType
  fiscalName: string
  taxId: string
  addressLine1: string
  postalCode: string
  city: string
  province: string
  countryCode: string
  billingEmail: string
  phone: string
  sendInvoiceToDifferentEmail: boolean
  invoiceEmail: string
  acceptLegal: boolean
}

export const emptyBillingForm = (
  email = '',
  buyerType: BillingBuyerType = 'individual',
): BillingFormValue => ({
  buyerType,
  fiscalName: '',
  taxId: '',
  addressLine1: '',
  postalCode: '',
  city: '',
  province: '',
  countryCode: 'ES',
  billingEmail: email,
  phone: '',
  sendInvoiceToDifferentEmail: false,
  invoiceEmail: '',
  acceptLegal: false,
})

const optionalPhoneSchema = z
  .string()
  .trim()
  .max(40, 'El teléfono es demasiado largo.')
  .refine(
    (value) => !value || /^[+()\d\s.-]{6,40}$/.test(value),
    'Introduce un teléfono válido.',
  )

export const billingDetailsSchema = z
  .object({
    buyerType: z.enum(['individual', 'business']),
    fiscalName: z
      .string()
      .trim()
      .min(2, 'Introduce el nombre fiscal o la razón social.')
      .max(200),
    taxId: z
      .string()
      .trim()
      .min(3, 'Introduce el DNI, NIE, NIF o CIF.')
      .max(40),
    addressLine1: z
      .string()
      .trim()
      .min(5, 'Introduce la dirección fiscal completa.')
      .max(240),
    postalCode: z
      .string()
      .trim()
      .min(3, 'Introduce el código postal.')
      .max(20),
    city: z.string().trim().min(2, 'Introduce la localidad.').max(120),
    province: z.string().trim().min(2, 'Introduce la provincia.').max(120),
    countryCode: z
      .string()
      .trim()
      .toUpperCase()
      .regex(/^[A-Z]{2}$/, 'Selecciona un país válido.'),
    billingEmail: z
      .string()
      .trim()
      .toLowerCase()
      .email('Introduce un correo de facturación válido.')
      .max(320),
    phone: optionalPhoneSchema,
    sendInvoiceToDifferentEmail: z.boolean(),
    invoiceEmail: z.string().trim().toLowerCase().max(320),
    acceptLegal: z.boolean().refine(Boolean, {
      message:
        'Debes aceptar las condiciones de contratación y la política de privacidad.',
    }),
  })
  .strict()
  .superRefine((value, context) => {
    if (
      value.sendInvoiceToDifferentEmail &&
      !z.string().email().safeParse(value.invoiceEmail).success
    ) {
      context.addIssue({
        code: 'custom',
        path: ['invoiceEmail'],
        message: 'Introduce el correo al que debe enviarse la factura.',
      })
    }
    if (
      value.countryCode === 'ES' &&
      !isValidSpanishTaxIdentifier(value.taxId)
    ) {
      context.addIssue({
        code: 'custom',
        path: ['taxId'],
        message: 'El DNI, NIE, NIF o CIF español no es válido.',
      })
    }
  })

export const checkoutRequestSchema = z
  .object({
    courseVersionId: z.uuid(),
    kind: z.enum(['individual', 'company']).default('individual'),
    quantity: z.number().int().min(1).max(500).default(1),
    organizationId: z.uuid().optional(),
    checkoutRequestId: z.uuid(),
    billing: billingDetailsSchema,
  })
  .strict()
  .superRefine((value, context) => {
    if (value.kind === 'individual' && value.quantity !== 1) {
      context.addIssue({
        code: 'custom',
        path: ['quantity'],
        message: 'Una compra individual contiene una única plaza.',
      })
    }
    if (value.kind === 'company' && !value.organizationId) {
      context.addIssue({
        code: 'custom',
        path: ['organizationId'],
        message: 'Selecciona la organización compradora.',
      })
    }
  })

export type CheckoutRequest = z.infer<typeof checkoutRequestSchema>

export function invoiceDeliveryEmail(billing: BillingFormValue): string {
  return billing.sendInvoiceToDifferentEmail
    ? billing.invoiceEmail.trim().toLowerCase()
    : billing.billingEmail.trim().toLowerCase()
}

export function normalizeTaxIdentifier(value: string): string {
  return value.toUpperCase().replace(/^ES/, '').replace(/[^A-Z0-9]/g, '')
}

export function isValidSpanishTaxIdentifier(value: string): boolean {
  const normalized = normalizeTaxIdentifier(value)
  return (
    isValidDni(normalized) ||
    isValidNie(normalized) ||
    isValidCif(normalized)
  )
}

function isValidDni(value: string): boolean {
  if (!/^\d{8}[A-Z]$/.test(value)) return false
  return validDniLetter(Number(value.slice(0, 8)), value.at(-1)!)
}

function isValidNie(value: string): boolean {
  if (!/^[XYZ]\d{7}[A-Z]$/.test(value)) return false
  const prefix = { X: '0', Y: '1', Z: '2' }[value[0] as 'X' | 'Y' | 'Z']
  return validDniLetter(
    Number(`${prefix}${value.slice(1, 8)}`),
    value.at(-1)!,
  )
}

function validDniLetter(number: number, letter: string): boolean {
  const letters = 'TRWAGMYFPDXBNJZSQVHLCKE'
  return letters[number % 23] === letter
}

function isValidCif(value: string): boolean {
  if (!/^[ABCDEFGHJNPQRSUVW]\d{7}[0-9A-J]$/.test(value)) return false

  const digits = value.slice(1, 8).split('').map(Number)
  const evenSum = digits[1] + digits[3] + digits[5]
  const oddSum = [digits[0], digits[2], digits[4], digits[6]].reduce(
    (sum, digit) => {
      const doubled = digit * 2
      return sum + Math.floor(doubled / 10) + (doubled % 10)
    },
    0,
  )
  const controlDigit = (10 - ((evenSum + oddSum) % 10)) % 10
  const controlLetter = 'JABCDEFGHI'[controlDigit]
  const suppliedControl = value.at(-1)!
  const firstLetter = value[0]

  if ('PQRSNW'.includes(firstLetter)) return suppliedControl === controlLetter
  if ('ABEH'.includes(firstLetter)) {
    return suppliedControl === String(controlDigit)
  }
  return (
    suppliedControl === String(controlDigit) ||
    suppliedControl === controlLetter
  )
}

export function decimalToScaledInteger(
  value: string | number,
  decimalPlaces: number,
): number {
  const normalized = String(value).trim().replace(',', '.')
  const match = normalized.match(/^(\d+)(?:\.(\d+))?$/)
  if (!match) throw new Error('Invalid decimal amount')

  const fractional = (match[2] ?? '').padEnd(decimalPlaces, '0')
  if (fractional.length > decimalPlaces) {
    const excess = fractional.slice(decimalPlaces)
    if (!/^0*$/.test(excess)) throw new Error('Too many decimal places')
  }

  const factor = 10 ** decimalPlaces
  const integer = Number(match[1]) * factor
  const decimals = Number(fractional.slice(0, decimalPlaces) || '0')
  const result = integer + decimals
  if (!Number.isSafeInteger(result)) throw new Error('Amount is too large')
  return result
}

export function decimalToCents(value: string | number): number {
  return decimalToScaledInteger(value, 2)
}

export function taxRateToBasisPoints(value: string | number): number {
  return decimalToScaledInteger(value, 2)
}

export type OrderAmounts = {
  unitNetCents: number
  subtotalNetCents: number
  taxAmountCents: number
  totalAmountCents: number
  taxRateBasisPoints: number
}

export function calculateOrderAmounts(
  unitNetCents: number,
  quantity: number,
  taxRateBasisPoints: number,
): OrderAmounts {
  if (
    !Number.isSafeInteger(unitNetCents) ||
    !Number.isSafeInteger(quantity) ||
    !Number.isSafeInteger(taxRateBasisPoints) ||
    unitNetCents < 0 ||
    quantity < 1 ||
    taxRateBasisPoints < 0
  ) {
    throw new Error('Invalid order amounts')
  }

  const subtotal = BigInt(unitNetCents) * BigInt(quantity)
  const tax =
    (subtotal * BigInt(taxRateBasisPoints) + 5_000n) / 10_000n
  const total = subtotal + tax
  if (
    subtotal > BigInt(Number.MAX_SAFE_INTEGER) ||
    tax > BigInt(Number.MAX_SAFE_INTEGER) ||
    total > BigInt(Number.MAX_SAFE_INTEGER)
  ) {
    throw new Error('Order amount is too large')
  }

  return {
    unitNetCents,
    subtotalNetCents: Number(subtotal),
    taxAmountCents: Number(tax),
    totalAmountCents: Number(total),
    taxRateBasisPoints,
  }
}

export function centsToDecimalString(cents: number): string {
  if (!Number.isSafeInteger(cents)) throw new Error('Invalid cents amount')
  const sign = cents < 0 ? '-' : ''
  const absolute = Math.abs(cents)
  return `${sign}${Math.floor(absolute / 100)}.${String(absolute % 100).padStart(2, '0')}`
}

export function formatCents(cents: number, currency = 'EUR'): string {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency,
  }).format(cents / 100)
}
