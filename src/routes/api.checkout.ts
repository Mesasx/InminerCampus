import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const requestSchema = z.object({
  courseVersionId: z.uuid(),
  kind: z.enum(['individual', 'company']).default('individual'),
  quantity: z.number().int().min(1).max(500).default(1),
  organizationId: z.uuid().optional(),
}).superRefine((value, context) => {
  if (value.kind === 'individual' && value.quantity !== 1) {
    context.addIssue({
      code: 'custom',
      path: ['quantity'],
      message: 'Individual purchases contain one seat',
    })
  }
  if (value.kind === 'company' && !value.organizationId) {
    context.addIssue({
      code: 'custom',
      path: ['organizationId'],
      message: 'Organization is required',
    })
  }
})

export const Route = createFileRoute('/api/checkout')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        const [{ default: Stripe }, { getBearerToken, getSupabaseAdmin }] =
          await Promise.all([
            import('stripe'),
            import('../server/supabase-admin'),
          ])

        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        let body: z.infer<typeof requestSchema>
        try {
          body = requestSchema.parse(await request.json())
        } catch {
          return Response.json({ error: 'Solicitud no válida.' }, { status: 400 })
        }

        const stripeSecret = process.env.STRIPE_SECRET_KEY?.trim()
        const appUrl = process.env.VITE_APP_URL?.trim()
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
            'id, price_net, tax_rate, currency, stripe_price_id, status, courses!inner(title, slug, status)',
          )
          .eq('id', body.courseVersionId)
          .eq('status', 'published')
          .eq('courses.status', 'published')
          .maybeSingle()

        if (versionError || !version || version.price_net === null) {
          return Response.json(
            { error: 'El curso no está disponible para compra.' },
            { status: 404 },
          )
        }

        const course = version.courses as unknown as {
          title: string
          slug: string
        }
        const unitNet = Number(version.price_net)
        const lineNet = Number((unitNet * body.quantity).toFixed(2))
        const currency = version.currency.toUpperCase()
        const idempotencyKey = crypto.randomUUID()
        const orderNumber = `INM-${Date.now().toString(36).toUpperCase()}-${crypto
          .randomUUID()
          .slice(0, 8)
          .toUpperCase()}`

        const { data: purchase, error: purchaseError } = await supabase
          .from('purchases')
          .insert({
            order_number: orderNumber,
            kind: body.kind,
            buyer_user_id: user.id,
            organization_id:
              body.kind === 'company' ? body.organizationId : null,
            status: 'draft',
            subtotal_net: lineNet,
            tax_amount: 0,
            total_amount: lineNet,
            currency,
            idempotency_key: idempotencyKey,
          })
          .select('id')
          .single()

        if (purchaseError || !purchase) {
          return Response.json(
            { error: 'No se ha podido crear el pedido.' },
            { status: 500 },
          )
        }

        const { error: itemError } = await supabase.from('purchase_items').insert({
          purchase_id: purchase.id,
          course_version_id: version.id,
          quantity: body.quantity,
          unit_net: unitNet,
          tax_rate: Number(version.tax_rate),
          line_net: lineNet,
          line_tax: 0,
          line_total: lineNet,
          currency,
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

        const stripe = new Stripe(stripeSecret)
        try {
          const session = await stripe.checkout.sessions.create(
            {
              mode: 'payment',
              customer_email: user.email,
              client_reference_id: purchase.id,
              line_items: [
                {
                  quantity: body.quantity,
                  ...(version.stripe_price_id
                    ? { price: version.stripe_price_id }
                    : {
                        price_data: {
                          currency: currency.toLowerCase(),
                          unit_amount: Math.round(unitNet * 100),
                          tax_behavior: 'exclusive' as const,
                          product_data: {
                            name: course.title,
                            metadata: {
                              course_version_id: version.id,
                            },
                          },
                        },
                      }),
                },
              ],
              automatic_tax: { enabled: true },
              invoice_creation: { enabled: true },
              success_url: `${appUrl}/pago/confirmado?session_id={CHECKOUT_SESSION_ID}`,
              cancel_url: `${appUrl}/cursos/${course.slug}`,
              metadata: {
                purchase_id: purchase.id,
                buyer_user_id: user.id,
                purchase_kind: body.kind,
                organization_id: body.organizationId ?? '',
              },
            },
            { idempotencyKey },
          )

          await supabase
            .from('purchases')
            .update({
              status: 'checkout_created',
              stripe_checkout_session_id: session.id,
            })
            .eq('id', purchase.id)

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
