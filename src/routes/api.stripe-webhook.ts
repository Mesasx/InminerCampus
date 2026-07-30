import { createFileRoute } from '@tanstack/react-router'
import type Stripe from 'stripe'
import { centsToDecimalString } from '../lib/billing'
import { verifyStripeWebhookPayload } from '../server/stripe-webhook-verifier'

export const Route = createFileRoute('/api/stripe-webhook')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        const [
          { default: StripeClient },
          { getSupabaseAdmin },
          { sendPaymentAdminNotification },
        ] = await Promise.all([
          import('stripe'),
          import('../server/supabase-admin'),
          import('../server/admin-payment-email'),
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

        const stripe = new StripeClient(stripeSecret)
        let event: Stripe.Event
        try {
          event = verifyStripeWebhookPayload(
            stripe,
            await request.text(),
            signature,
            webhookSecret,
          )
        } catch {
          return new Response('Invalid signature', { status: 400 })
        }

        const supabase = getSupabaseAdmin()
        if (
          event.type === 'checkout.session.completed' ||
          event.type === 'checkout.session.async_payment_succeeded'
        ) {
          const session = event.data.object
          const purchaseId = session.metadata?.purchase_id
          if (!purchaseId || session.payment_status !== 'paid') {
            return Response.json({ received: true })
          }

          const paymentIntentId = objectId(session.payment_intent)
          const invoiceId = objectId(session.invoice)
          const customerId = objectId(session.customer)
          const subtotalCents = session.amount_subtotal ?? 0
          const totalCents = session.amount_total ?? subtotalCents
          const taxCents = session.total_details?.amount_tax ?? 0
          const { error } = await supabase.rpc(
            'fulfill_stripe_checkout_v2',
            {
              p_stripe_event_id: event.id,
              p_event_type: event.type,
              p_livemode: event.livemode,
              p_purchase_id: purchaseId,
              p_checkout_session_id: session.id,
              p_payment_intent_id: paymentIntentId,
              p_invoice_id: invoiceId,
              p_stripe_customer_id: customerId,
              p_subtotal_net: centsToDecimalString(subtotalCents),
              p_tax_amount: centsToDecimalString(taxCents),
              p_total_amount: centsToDecimalString(totalCents),
              p_paid_at: stripeTimestamp(event.created),
            },
          )

          if (error) {
            await recordWebhookFailure({
              event,
              purchaseId,
              safeError: 'Fulfillment RPC rejected the Stripe event',
              supabase,
            })
            return new Response('Fulfillment failed', { status: 500 })
          }

          try {
            await sendPaymentAdminNotification(purchaseId)
          } catch {
            // The payment and enrollment are already confirmed. The failed
            // notification remains visible and can be retried from Admin.
          }
          return Response.json({ received: true })
        }

        if (event.type === 'charge.refunded') {
          const charge = event.data.object
          const paymentIntentId = objectId(charge.payment_intent)
          if (!paymentIntentId) {
            return Response.json({ received: true })
          }
          const { error } = await supabase.rpc('record_stripe_refund', {
            p_stripe_event_id: event.id,
            p_event_type: event.type,
            p_livemode: event.livemode,
            p_payment_intent_id: paymentIntentId,
            p_refunded_amount_cents: charge.amount_refunded,
            p_refunded_at: stripeTimestamp(event.created),
          })
          if (error) {
            await recordWebhookFailure({
              event,
              purchaseId: null,
              safeError: 'Refund RPC rejected the Stripe event',
              supabase,
            })
            return new Response('Refund processing failed', { status: 500 })
          }
          return Response.json({ received: true })
        }

        return Response.json({ received: true })
      },
    },
  },
})

function objectId(
  value:
    | string
    | { id: string }
    | null
    | undefined,
): string {
  return typeof value === 'string' ? value : (value?.id ?? '')
}

function stripeTimestamp(seconds: number): string {
  return new Date(seconds * 1000).toISOString()
}

async function recordWebhookFailure({
  event,
  purchaseId,
  safeError,
  supabase,
}: {
  event: Stripe.Event
  purchaseId: string | null
  safeError: string
  supabase: ReturnType<
    typeof import('../server/supabase-admin').getSupabaseAdmin
  >
}) {
  const { data: previous } = await supabase
    .from('stripe_webhook_events')
    .select('attempt_count')
    .eq('stripe_event_id', event.id)
    .maybeSingle()
  await supabase.from('stripe_webhook_events').upsert({
    stripe_event_id: event.id,
    event_type: event.type,
    livemode: event.livemode,
    related_purchase_id: purchaseId,
    status: 'failed',
    attempt_count: (previous?.attempt_count ?? 0) + 1,
    last_error: safeError,
    updated_at: new Date().toISOString(),
  })
}
