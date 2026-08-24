import { createFileRoute } from '@tanstack/react-router'
import type Stripe from 'stripe'
import {
  BILLING_LEGAL_VERSION,
  calculateOrderAmounts,
  centsToDecimalString,
  checkoutRequestSchema,
  decimalToCents,
  invoiceDeliveryEmail,
  normalizeTaxIdentifier,
  taxRateToBasisPoints,
} from '../lib/billing'

export const Route = createFileRoute('/api/checkout')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        const [{ default: StripeClient }, { getBearerToken, getSupabaseAdmin }] =
          await Promise.all([
            import('stripe'),
            import('../server/supabase-admin'),
          ])

        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const parsedBody = checkoutRequestSchema.safeParse(
          await request.json().catch(() => null),
        )
        if (!parsedBody.success) {
          return Response.json(
            {
              error:
                parsedBody.error.issues[0]?.message ?? 'Solicitud no válida.',
            },
            { status: 400 },
          )
        }
        const body = parsedBody.data

        const stripeSecret = process.env.STRIPE_SECRET_KEY?.trim()
        const appUrl = process.env.VITE_APP_URL?.trim().replace(/\/+$/, '')
        if (!stripeSecret || !appUrl) {
          return Response.json(
            { error: 'Stripe todavía no está configurado.' },
            { status: 503 },
          )
        }

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser(token)
        if (userError || !user?.email) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        if (body.kind === 'company') {
          const [{ data: membership }, { data: superadmin }] = await Promise.all([
            supabase
              .from('organization_members')
              .select('user_id')
              .eq('organization_id', body.organizationId!)
              .eq('user_id', user.id)
              .eq('role', 'responsable_empresa')
              .eq('status', 'active')
              .maybeSingle(),
            supabase
              .from('user_roles')
              .select('user_id')
              .eq('user_id', user.id)
              .eq('role', 'superadministrador')
              .maybeSingle(),
          ])
          if (!membership && !superadmin) {
            return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
          }
        }

        const { data: version, error: versionError } = await supabase
          .from('course_versions')
          .select(
            'id, version_number, duration_hours, modality, price_net, tax_rate, currency, status, courses!inner(title, slug, status)',
          )
          .eq('id', body.courseVersionId)
          .eq('status', 'published')
          .eq('courses.status', 'published')
          .maybeSingle()

        if (
          versionError ||
          !version ||
          version.price_net === null ||
          version.tax_rate === null
        ) {
          return Response.json(
            { error: 'El curso no está disponible para compra.' },
            { status: 404 },
          )
        }

        const course = version.courses as unknown as {
          title: string
          slug: string
        }
        const unitNetCents = decimalToCents(version.price_net)
        const taxRateBasisPoints = taxRateToBasisPoints(version.tax_rate)
        const amounts = calculateOrderAmounts(
          unitNetCents,
          body.quantity,
          taxRateBasisPoints,
        )
        const currency = version.currency.toUpperCase()
        const idempotencyKey = `checkout:${user.id}:${body.checkoutRequestId}`
        const stripe = new StripeClient(stripeSecret)
        const stripeInvoiceCreationEnabled =
          process.env.STRIPE_INVOICE_CREATION_ENABLED?.trim().toLowerCase() ===
          'true'

        const existingResult = await findExistingCheckout({
          appUrl,
          idempotencyKey,
          stripe,
          supabase,
        })
        if (existingResult) return existingResult

        const orderNumber = `INM-${Date.now().toString(36).toUpperCase()}-${crypto
          .randomUUID()
          .slice(0, 8)
          .toUpperCase()}`
        const invoiceEmail = invoiceDeliveryEmail(body.billing)
        const acceptedAt = new Date().toISOString()
        const decimalSubtotal = centsToDecimalString(amounts.subtotalNetCents)
        const decimalTax = centsToDecimalString(amounts.taxAmountCents)
        const decimalTotal = centsToDecimalString(amounts.totalAmountCents)

        const { data: purchase, error: purchaseError } = await supabase
          .from('purchases')
          .insert({
            order_number: orderNumber,
            kind: body.kind,
            buyer_user_id: user.id,
            organization_id:
              body.kind === 'company' ? body.organizationId : null,
            status: 'draft',
            subtotal_net: decimalSubtotal,
            tax_amount: decimalTax,
            total_amount: decimalTotal,
            currency,
            billing_details: body.billing,
            idempotency_key: idempotencyKey,
            billing_snapshot_version: 1,
            billing_buyer_type: body.billing.buyerType,
            billing_name: body.billing.fiscalName,
            billing_tax_id: normalizeTaxIdentifier(body.billing.taxId),
            billing_address_line1: body.billing.addressLine1,
            billing_postal_code: body.billing.postalCode,
            billing_city: body.billing.city,
            billing_province: body.billing.province,
            billing_country_code: body.billing.countryCode,
            billing_email: body.billing.billingEmail,
            billing_phone: body.billing.phone || null,
            invoice_email: invoiceEmail,
            contract_terms_accepted_at: acceptedAt,
            contract_terms_version: BILLING_LEGAL_VERSION,
            privacy_policy_version: BILLING_LEGAL_VERSION,
            subtotal_net_cents: amounts.subtotalNetCents,
            tax_amount_cents: amounts.taxAmountCents,
            total_amount_cents: amounts.totalAmountCents,
            tax_rate_basis_points: amounts.taxRateBasisPoints,
            invoice_status: 'pending_invoice',
            admin_notification_status: 'pending',
          })
          .select('id')
          .single()

        if (purchaseError || !purchase) {
          const duplicateResult = await findExistingCheckout({
            appUrl,
            idempotencyKey,
            stripe,
            supabase,
          })
          if (duplicateResult) return duplicateResult
          return Response.json(
            { error: 'No se ha podido crear el pedido.' },
            { status: 500 },
          )
        }

        const { error: itemError } = await supabase.from('purchase_items').insert({
          purchase_id: purchase.id,
          course_version_id: version.id,
          quantity: body.quantity,
          unit_net: centsToDecimalString(amounts.unitNetCents),
          tax_rate: centsToDecimalString(amounts.taxRateBasisPoints),
          line_net: decimalSubtotal,
          line_tax: decimalTax,
          line_total: decimalTotal,
          currency,
          snapshot_version: 1,
          course_title_snapshot: course.title,
          course_code_snapshot: course.slug,
          course_version_snapshot: version.version_number,
          modality_snapshot: version.modality,
          duration_hours_snapshot: version.duration_hours,
          description_snapshot: `${course.title} · Versión ${version.version_number} · ${version.duration_hours} horas`,
          unit_net_cents: amounts.unitNetCents,
          line_net_cents: amounts.subtotalNetCents,
          line_tax_cents: amounts.taxAmountCents,
          line_total_cents: amounts.totalAmountCents,
          tax_rate_basis_points: amounts.taxRateBasisPoints,
        })

        if (itemError) {
          await supabase
            .from('purchases')
            .update({ status: 'cancelled' })
            .eq('id', purchase.id)
          return Response.json(
            { error: 'No se ha podido preparar el pedido.' },
            { status: 500 },
          )
        }

        try {
          const [customer, taxRate] = await Promise.all([
            getOrCreateStripeCustomer({
              billing: body.billing,
              buyerUserId: user.id,
              idempotencyKey,
              stripe,
              supabase,
            }),
            getOrCreateStripeTaxRate({
              countryCode: body.billing.countryCode,
              stripe,
              taxRateBasisPoints,
            }),
          ])

          const session = await stripe.checkout.sessions.create(
            {
              mode: 'payment',
              integration_identifier: `inminercampus_${integrationSuffix(body.checkoutRequestId)}`,
              customer: customer.id,
              client_reference_id: purchase.id,
              billing_address_collection: 'required',
              customer_update: {
                address: 'auto',
                name: 'auto',
              },
              line_items: [
                {
                  quantity: body.quantity,
                  price_data: {
                    currency: currency.toLowerCase(),
                    unit_amount: amounts.unitNetCents,
                    tax_behavior: 'exclusive',
                    product_data: {
                      name: course.title,
                      metadata: {
                        course_version_id: version.id,
                      },
                    },
                  },
                  tax_rates: [taxRate.id],
                },
              ],
              ...(stripeInvoiceCreationEnabled
                ? {
                    invoice_creation: {
                      enabled: true,
                      invoice_data: {
                        custom_fields: [
                          {
                            name: 'DNI/NIF/NIE/CIF',
                            value: normalizeTaxIdentifier(body.billing.taxId),
                          },
                          {
                            name: 'Pedido',
                            value: orderNumber,
                          },
                        ],
                        metadata: {
                          purchase_id: purchase.id,
                        },
                      },
                    },
                  }
                : {}),
              payment_intent_data: {
                metadata: {
                  purchase_id: purchase.id,
                  buyer_user_id: user.id,
                },
              },
              success_url: `${appUrl}/pago/confirmado?session_id={CHECKOUT_SESSION_ID}`,
              cancel_url: `${appUrl}/${
                body.kind === 'company' ? 'comprar-empresa' : 'comprar'
              }/${course.slug}?version=${encodeURIComponent(version.id)}`,
              metadata: {
                purchase_id: purchase.id,
                buyer_user_id: user.id,
                course_version_id: version.id,
                purchase_kind: body.kind,
                organization_id: body.organizationId ?? '',
              },
            },
            { idempotencyKey },
          )

          if (!session.url) throw new Error('Stripe returned no Checkout URL')

          const { error: updateError } = await supabase
            .from('purchases')
            .update({
              status: 'checkout_created',
              stripe_checkout_session_id: session.id,
              stripe_customer_id: customer.id,
            })
            .eq('id', purchase.id)
          if (updateError) throw updateError

          return Response.json({ url: session.url })
        } catch {
          await supabase
            .from('purchases')
            .update({ status: 'cancelled' })
            .eq('id', purchase.id)
          return Response.json(
            { error: 'No se ha podido abrir el pago seguro.' },
            { status: 502 },
          )
        }
      },
    },
  },
})

async function findExistingCheckout({
  appUrl,
  idempotencyKey,
  stripe,
  supabase,
}: {
  appUrl: string
  idempotencyKey: string
  stripe: Stripe
  supabase: ReturnType<
    typeof import('../server/supabase-admin').getSupabaseAdmin
  >
}): Promise<Response | null> {
  const { data: existing } = await supabase
    .from('purchases')
    .select('id, status, stripe_checkout_session_id')
    .eq('idempotency_key', idempotencyKey)
    .maybeSingle()
  if (!existing) return null

  if (!existing.stripe_checkout_session_id) {
    return Response.json(
      {
        error:
          existing.status === 'cancelled'
            ? 'Este intento no pudo completarse. Recarga la página para volver a intentarlo.'
            : 'El pedido ya se está preparando. Inténtalo de nuevo en unos segundos.',
      },
      { status: 409 },
    )
  }

  const session = await stripe.checkout.sessions
    .retrieve(existing.stripe_checkout_session_id)
    .catch(() => null)
  if (session?.status === 'complete') {
    return Response.json({
      url: `${appUrl}/pago/confirmado?session_id=${encodeURIComponent(session.id)}`,
    })
  }
  if (session?.status === 'open' && session.url) {
    return Response.json({ url: session.url })
  }
  return Response.json(
    { error: 'La sesión de pago ha caducado. Recarga la página para crear otra.' },
    { status: 409 },
  )
}

function integrationSuffix(value: string): string {
  const alphabet = 'abcdefghijklmnopqrstuvwxyz'
  let state = 2_166_136_261
  for (const character of value) {
    state ^= character.charCodeAt(0)
    state = Math.imul(state, 16_777_619) >>> 0
  }
  let suffix = ''
  for (let index = 0; index < 8; index += 1) {
    state = Math.imul(state ^ (state >>> 13), 1_597_334_677) >>> 0
    suffix += alphabet[state % alphabet.length]
  }
  return suffix
}

async function getOrCreateStripeCustomer({
  billing,
  buyerUserId,
  idempotencyKey,
  stripe,
  supabase,
}: {
  billing: ReturnType<typeof checkoutRequestSchema.parse>['billing']
  buyerUserId: string
  idempotencyKey: string
  stripe: Stripe
  supabase: ReturnType<
    typeof import('../server/supabase-admin').getSupabaseAdmin
  >
}): Promise<Stripe.Customer> {
  const { data: priorPurchase } = await supabase
    .from('purchases')
    .select('stripe_customer_id')
    .eq('buyer_user_id', buyerUserId)
    .not('stripe_customer_id', 'is', null)
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  const customerData: Stripe.CustomerUpdateParams = {
    email: billing.billingEmail,
    name: billing.fiscalName,
    phone: billing.phone || undefined,
    address: {
      line1: billing.addressLine1,
      postal_code: billing.postalCode,
      city: billing.city,
      state: billing.province,
      country: billing.countryCode,
    },
    metadata: { buyer_user_id: buyerUserId },
  }

  if (priorPurchase?.stripe_customer_id) {
    const existing = await stripe.customers
      .retrieve(priorPurchase.stripe_customer_id)
      .catch(() => null)
    if (existing && !existing.deleted) {
      return stripe.customers.update(existing.id, customerData)
    }
  }

  return stripe.customers.create(
    customerData as Stripe.CustomerCreateParams,
    { idempotencyKey: `${idempotencyKey}:customer` },
  )
}

async function getOrCreateStripeTaxRate({
  countryCode,
  stripe,
  taxRateBasisPoints,
}: {
  countryCode: string
  stripe: Stripe
  taxRateBasisPoints: number
}): Promise<Stripe.TaxRate> {
  const marker = String(taxRateBasisPoints)
  const country = countryCode.toUpperCase()
  const existingRates = await stripe.taxRates.list({ active: true, limit: 100 })
  const existing = existingRates.data.find(
    (taxRate) =>
      !taxRate.inclusive &&
      taxRate.country === country &&
      taxRate.metadata?.inminer_tax_rate_basis_points === marker,
  )
  if (existing) return existing

  return stripe.taxRates.create(
    {
      display_name: country === 'ES' ? 'IVA' : 'Impuesto',
      description: `${taxRateBasisPoints / 100}%`,
      inclusive: false,
      percentage: taxRateBasisPoints / 100,
      country,
      metadata: {
        inminer_tax_rate_basis_points: marker,
      },
    },
    { idempotencyKey: `inminer-tax-rate:${country}:${marker}` },
  )
}
