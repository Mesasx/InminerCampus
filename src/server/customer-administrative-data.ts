export type PurchaseForAdministrativeNotification = {
  id: string
  order_number: string
  kind: string
  status: string
  paid_at: string | null
  billing_buyer_type: string
  billing_name: string
  billing_tax_id: string
  billing_address_line1: string
  billing_postal_code: string
  billing_city: string
  billing_province: string
  billing_country_code: string
  billing_email: string
  billing_phone: string | null
  invoice_email: string
  subtotal_net_cents: number
  tax_amount_cents: number
  total_amount_cents: number
  tax_rate_basis_points: number
  currency: string
  stripe_event_id: string | null
  stripe_payment_intent_id: string | null
  stripe_checkout_session_id: string | null
  invoice_status: string
  gross_subtotal_cents: number | null
  discount_basis_points: number
  discount_amount_cents: number
  buyer_given_name: string | null
  buyer_family_name: string | null
  buyer_contact_email: string | null
  buyer_contact_phone: string | null
  purchase_items: Array<{
    course_title_snapshot: string
    course_code_snapshot: string | null
    course_version_snapshot: number
    modality_snapshot: string
    duration_hours_snapshot: number
    quantity: number
    unit_net_cents: number
    line_net_cents: number
    line_tax_cents: number
    line_total_cents: number
    description_snapshot: string | null
  }>
  company_license_recipients: Array<{
    given_name: string
    family_name: string
    email: string
  }>
}

export type CustomerAdministrativeData = {
  customerType: 'Particular' | 'Empresa'
  displayName: string
  customer: {
    givenName: string | null
    familyName: string | null
    fiscalName: string
    taxId: string
    phone: string | null
    email: string
    invoiceEmail: string
    address: string
    postalCode: string
    city: string
    province: string
    countryCode: string
    country: string
  }
  contact: {
    fullName: string
    email: string
    phone: string | null
  } | null
  purchase: {
    courseName: string
    courseCode: string | null
    courseVersion: number | null
    modality: string | null
    durationHours: number | null
    quantity: number
    unitNetCents: number
    subtotalNetCents: number
    taxAmountCents: number
    totalAmountCents: number
    grossSubtotalCents: number
    discountBasisPoints: number
    discountAmountCents: number
    currency: string
    paidAt: string | null
    orderNumber: string
    purchaseId: string
    stripeEventId: string | null
    stripeCheckoutSessionId: string | null
    stripePaymentIntentId: string | null
    paymentMethod: 'Stripe'
    paymentStatus: 'Pagado'
  }
  participants: Array<{
    fullName: string
    email: string
  }>
}

export function createCustomerAdministrativeData(
  purchase: PurchaseForAdministrativeNotification,
): CustomerAdministrativeData {
  const isBusiness =
    purchase.billing_buyer_type === 'business' || purchase.kind === 'company'
  const item = purchase.purchase_items[0]
  const contactName = [
    purchase.buyer_given_name,
    purchase.buyer_family_name,
  ]
    .filter(Boolean)
    .join(' ')
    .trim()
  const quantity = purchase.purchase_items.reduce(
    (total, purchaseItem) => total + purchaseItem.quantity,
    0,
  )

  return {
    customerType: isBusiness ? 'Empresa' : 'Particular',
    displayName: purchase.billing_name,
    customer: {
      givenName: isBusiness ? null : purchase.buyer_given_name,
      familyName: isBusiness ? null : purchase.buyer_family_name,
      fiscalName: purchase.billing_name,
      taxId: purchase.billing_tax_id,
      phone: purchase.billing_phone,
      email: purchase.billing_email,
      invoiceEmail: purchase.invoice_email,
      address: purchase.billing_address_line1,
      postalCode: purchase.billing_postal_code,
      city: purchase.billing_city,
      province: purchase.billing_province,
      countryCode: purchase.billing_country_code,
      country: countryName(purchase.billing_country_code),
    },
    contact:
      isBusiness && (contactName || purchase.buyer_contact_email)
        ? {
            fullName: contactName || '—',
            email: purchase.buyer_contact_email || '—',
            phone: purchase.buyer_contact_phone,
          }
        : null,
    purchase: {
      courseName: item?.course_title_snapshot ?? '—',
      courseCode: item?.course_code_snapshot ?? null,
      courseVersion: item?.course_version_snapshot ?? null,
      modality: item?.modality_snapshot ?? null,
      durationHours: item?.duration_hours_snapshot ?? null,
      quantity,
      unitNetCents: item?.unit_net_cents ?? 0,
      subtotalNetCents: purchase.subtotal_net_cents,
      taxAmountCents: purchase.tax_amount_cents,
      totalAmountCents: purchase.total_amount_cents,
      grossSubtotalCents:
        purchase.gross_subtotal_cents ?? purchase.subtotal_net_cents,
      discountBasisPoints: purchase.discount_basis_points,
      discountAmountCents: purchase.discount_amount_cents,
      currency: purchase.currency,
      paidAt: purchase.paid_at,
      orderNumber: purchase.order_number,
      purchaseId: purchase.id,
      stripeEventId: purchase.stripe_event_id,
      stripeCheckoutSessionId: purchase.stripe_checkout_session_id,
      stripePaymentIntentId: purchase.stripe_payment_intent_id,
      paymentMethod: 'Stripe',
      paymentStatus: 'Pagado',
    },
    participants: purchase.company_license_recipients.map((recipient) => ({
      fullName: `${recipient.given_name} ${recipient.family_name}`.trim(),
      email: recipient.email,
    })),
  }
}

function countryName(countryCode: string): string {
  const normalized = countryCode.trim().toUpperCase()
  const names: Record<string, string> = {
    DE: 'Alemania',
    ES: 'España',
    FR: 'Francia',
    IT: 'Italia',
    PT: 'Portugal',
  }
  return names[normalized] ?? normalized
}
