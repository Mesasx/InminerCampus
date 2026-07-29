import { createFileRoute } from '@tanstack/react-router'
import type Stripe from 'stripe'

export const Route = createFileRoute('/api/stripe-webhook')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        const [{ default: Stripe }, { getSupabaseAdmin }] = await Promise.all([
          import('stripe'),
          import('../server/supabase-admin'),
        ])
        const stripeSecret = process.env.STRIPE_SECRET_KEY?.trim()
        const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET?.trim()
        if (!stripeSecret || !webhookSecret) {
          return new Response('Webhook configuration missing', { status: 503 })
        }

        const signature = request.headers.get('stripe-signature')
        if (!signature) {
          return new Response('Missing signature', { status: 400 })
        }

        const stripe = new Stripe(stripeSecret)
        let event: Stripe.Event
        try {
          const payload = await request.text()
          event = stripe.webhooks.constructEvent(
            payload,
            signature,
            webhookSecret,
          )
        } catch {
          return new Response('Invalid signature', { status: 400 })
        }

        if (
          event.type !== 'checkout.session.completed' &&
          event.type !== 'checkout.session.async_payment_succeeded'
        ) {
          return Response.json({ received: true })
        }

        const session = event.data.object as Stripe.Checkout.Session
        const purchaseId = session.metadata?.purchase_id
        if (!purchaseId || session.payment_status !== 'paid') {
          return Response.json({ received: true })
        }

        const subtotal = (session.amount_subtotal ?? 0) / 100
        const total = (session.amount_total ?? session.amount_subtotal ?? 0) / 100
        const tax = (session.total_details?.amount_tax ?? 0) / 100
        const paymentIntentId =
          typeof session.payment_intent === 'string'
            ? session.payment_intent
            : (session.payment_intent?.id ?? '')
        const invoiceId =
          typeof session.invoice === 'string'
            ? session.invoice
            : (session.invoice?.id ?? '')
        const customerId =
          typeof session.customer === 'string'
            ? session.customer
            : (session.customer?.id ?? '')

        const supabase = getSupabaseAdmin()
        const { error } = await supabase.rpc('fulfill_stripe_checkout', {
          p_stripe_event_id: event.id,
          p_event_type: event.type,
          p_livemode: event.livemode,
          p_purchase_id: purchaseId,
          p_checkout_session_id: session.id,
          p_payment_intent_id: paymentIntentId,
          p_invoice_id: invoiceId,
          p_stripe_customer_id: customerId,
          p_subtotal_net: subtotal,
          p_tax_amount: tax,
          p_total_amount: total,
        })

        if (error) {
          return new Response('Fulfillment failed', { status: 500 })
        }

        return Response.json({ received: true })
      },
    },
  },
})
