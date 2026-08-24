import { getSupabaseAdmin } from './supabase-admin'
import {
  buildPaymentEmailHtml,
  buildPaymentEmailText,
  type PurchaseForNotification,
} from './admin-payment-email-content'
import {
  runPaymentNotification,
  type PaymentNotificationResult,
} from './payment-notification-orchestrator'

export {
  buildPaymentEmailHtml,
  buildPaymentEmailText,
  type PurchaseForNotification,
} from './admin-payment-email-content'

export async function sendPaymentAdminNotification(
  purchaseId: string,
): Promise<PaymentNotificationResult> {
  const supabase = getSupabaseAdmin()
  return runPaymentNotification(purchaseId, {
    claim: async () => {
      const { data, error } = await supabase.rpc(
        'claim_admin_payment_notification',
        { p_purchase_id: purchaseId },
      )
      if (error) throw new Error('Could not claim payment notification')
      return Boolean(data)
    },
    load: async () => {
      const { data, error } = await supabase
        .from('purchases')
        .select(
          'id, order_number, kind, paid_at, billing_name, billing_tax_id, billing_address_line1, billing_postal_code, billing_city, billing_province, billing_country_code, billing_email, billing_phone, invoice_email, subtotal_net_cents, tax_amount_cents, total_amount_cents, tax_rate_basis_points, currency, stripe_checkout_session_id, stripe_payment_intent_id, purchase_items(course_title_snapshot, course_code_snapshot, course_version_snapshot, modality_snapshot, duration_hours_snapshot, description_snapshot, quantity, unit_net_cents, line_net_cents, line_tax_cents, line_total_cents)',
        )
        .eq('id', purchaseId)
        .single()
      if (error || !data) throw new Error('Could not load paid purchase')
      return data as unknown as PurchaseForNotification
    },
    send: sendWithResend,
    complete: async ({ success, messageId, error }) => {
      const { error: completeError } = await supabase.rpc(
        'complete_admin_payment_notification',
        {
          p_purchase_id: purchaseId,
          p_success: success,
          p_message_id: messageId,
          p_error: error,
        },
      )
      if (completeError) {
        throw new Error('Could not record notification delivery')
      }
    },
  })
}

async function sendWithResend(
  purchase: PurchaseForNotification,
): Promise<string> {
  const apiKey = process.env.RESEND_API_KEY?.trim()
  const recipient =
    process.env.ADMIN_NOTIFICATION_EMAIL?.trim() || 'administracion@inminer.es'
  const sender =
    process.env.ADMIN_NOTIFICATION_FROM?.trim() ||
    'InmínerCampus <campus@inminer.es>'
  const adminUrl = (
    process.env.ADMIN_APP_URL?.trim() ||
    process.env.VITE_APP_URL?.trim() ||
    ''
  ).replace(/\/+$/, '')
  if (!apiKey) throw new Error('Resend configuration is missing')

  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `purchase-paid/${purchase.id}`,
    },
    body: JSON.stringify({
      from: sender,
      to: [recipient],
      subject: `Pago confirmado ${purchase.order_number} · factura pendiente`,
      text: buildPaymentEmailText(purchase, adminUrl),
      html: buildPaymentEmailHtml(purchase, adminUrl),
    }),
  })
  const payload = (await response.json().catch(() => ({}))) as {
    id?: string
    message?: string
  }
  if (!response.ok || !payload.id) {
    throw new Error(
      payload.message
        ? `Resend rejected the notification: ${payload.message}`
        : 'Resend rejected the notification',
    )
  }
  return payload.id
}
