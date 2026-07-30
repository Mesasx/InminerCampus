import assert from 'node:assert/strict'
import test from 'node:test'
import Stripe from 'stripe'
import { verifyStripeWebhookPayload } from '../src/server/stripe-webhook-verifier.ts'

const payload = JSON.stringify({
  id: 'evt_test',
  object: 'event',
  api_version: '2026-06-30.basil',
  created: 1_700_000_000,
  data: { object: {} },
  livemode: false,
  pending_webhooks: 1,
  request: null,
  type: 'checkout.session.completed',
})

test('acepta una firma Stripe válida y rechaza una inválida', () => {
  const secret = 'whsec_test_secret'
  const signature = Stripe.webhooks.generateTestHeaderString({
    payload,
    secret,
  })
  const stripe = new Stripe('sk_test_placeholder')

  assert.equal(
    verifyStripeWebhookPayload(stripe, payload, signature, secret).id,
    'evt_test',
  )
  assert.throws(
    () => verifyStripeWebhookPayload(stripe, payload, signature, 'wrong'),
    /signature/i,
  )
})
