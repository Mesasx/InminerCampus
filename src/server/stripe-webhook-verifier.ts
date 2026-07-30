import type Stripe from 'stripe'

export function verifyStripeWebhookPayload(
  stripe: Stripe,
  payload: string,
  signature: string,
  secret: string,
): Stripe.Event {
  return stripe.webhooks.constructEvent(payload, signature, secret)
}
