import { formatCents } from '../lib/billing'
import { getSupabaseAdmin } from './supabase-admin'
import {
  runPaymentNotification,
  type PaymentNotificationResult,
} from './payment-notification-orchestrator'

export type PurchaseForNotification = {
  id: string
  order_number: string
  kind: string
  paid_at: string | null
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
  stripe_payment_intent_id: string | null
  purchase_items: Array<{
    course_title_snapshot: string
    course_version_snapshot: number
    modality_snapshot: string
    duration_hours_snapshot: number
    quantity: number
  }>
}

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
          'id, order_number, kind, paid_at, billing_name, billing_tax_id, billing_address_line1, billing_postal_code, billing_city, billing_province, billing_country_code, billing_email, billing_phone, invoice_email, subtotal_net_cents, tax_amount_cents, total_amount_cents, tax_rate_basis_points, currency, stripe_payment_intent_id, purchase_items(course_title_snapshot, course_version_snapshot, modality_snapshot, duration_hours_snapshot, quantity)',
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

  const subject = `Pago confirmado ${purchase.order_number}`
  const text = buildPaymentEmailText(purchase, adminUrl)
  const html = buildPaymentEmailHtml(purchase, adminUrl)
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
      subject,
      text,
      html,
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

export function buildPaymentEmailText(
  purchase: PurchaseForNotification,
  adminUrl: string,
): string {
  const item = purchase.purchase_items[0]
  const lines = [
    'Nuevo pago confirmado en InmínerCampus',
    '',
    `Pedido: ${purchase.order_number}`,
    `Fecha de pago: ${formatDate(purchase.paid_at)}`,
    `Curso: ${item?.course_title_snapshot ?? '—'}`,
    `Versión: ${item?.course_version_snapshot ?? '—'}`,
    `Modalidad: ${formatModality(item?.modality_snapshot)}`,
    `Duración: ${item?.duration_hours_snapshot ?? '—'} horas`,
    `Plazas: ${item?.quantity ?? '—'}`,
    '',
    `Cliente: ${purchase.billing_name}`,
    `NIF/CIF: ${purchase.billing_tax_id}`,
    `Dirección: ${formatAddress(purchase)}`,
    `Correo de facturación: ${purchase.billing_email}`,
    `Correo de factura: ${purchase.invoice_email}`,
    `Teléfono: ${purchase.billing_phone || '—'}`,
    '',
    `Base imponible: ${formatCents(purchase.subtotal_net_cents, purchase.currency)}`,
    `IVA (${purchase.tax_rate_basis_points / 100}%): ${formatCents(purchase.tax_amount_cents, purchase.currency)}`,
    `Total: ${formatCents(purchase.total_amount_cents, purchase.currency)}`,
    `PaymentIntent: ${purchase.stripe_payment_intent_id || '—'}`,
  ]
  if (adminUrl) {
    lines.push('', `Gestionar: ${adminUrl}/admin/facturacion?pedido=${purchase.id}`)
  }
  return lines.join('\n')
}

export function buildPaymentEmailHtml(
  purchase: PurchaseForNotification,
  adminUrl: string,
): string {
  const item = purchase.purchase_items[0]
  const rows: Array<[string, string]> = [
    ['Pedido', purchase.order_number],
    ['Fecha de pago', formatDate(purchase.paid_at)],
    ['Curso', item?.course_title_snapshot ?? '—'],
    ['Versión', String(item?.course_version_snapshot ?? '—')],
    ['Modalidad', formatModality(item?.modality_snapshot)],
    ['Duración', `${item?.duration_hours_snapshot ?? '—'} horas`],
    ['Plazas', String(item?.quantity ?? '—')],
    ['Cliente', purchase.billing_name],
    ['NIF/CIF', purchase.billing_tax_id],
    ['Dirección', formatAddress(purchase)],
    ['Correo de facturación', purchase.billing_email],
    ['Correo de factura', purchase.invoice_email],
    ['Teléfono', purchase.billing_phone || '—'],
    [
      'Base imponible',
      formatCents(purchase.subtotal_net_cents, purchase.currency),
    ],
    [
      `IVA (${purchase.tax_rate_basis_points / 100}%)`,
      formatCents(purchase.tax_amount_cents, purchase.currency),
    ],
    ['Total', formatCents(purchase.total_amount_cents, purchase.currency)],
    ['PaymentIntent', purchase.stripe_payment_intent_id || '—'],
  ]
  const tableRows = rows
    .map(
      ([label, value]) =>
        `<tr><th style="padding:8px 12px;text-align:left;border-bottom:1px solid #e7e5e4">${escapeHtml(label)}</th><td style="padding:8px 12px;border-bottom:1px solid #e7e5e4">${escapeHtml(value)}</td></tr>`,
    )
    .join('')
  const action = adminUrl
    ? `<p style="margin-top:24px"><a href="${escapeHtml(`${adminUrl}/admin/facturacion?pedido=${purchase.id}`)}" style="display:inline-block;background:#e96f1d;color:#fff;text-decoration:none;padding:12px 18px;border-radius:8px">Abrir Pagos y facturación</a></p>`
    : ''

  return `<!doctype html><html lang="es"><body style="font-family:Arial,sans-serif;color:#292524;background:#fafaf9;padding:24px"><main style="max-width:720px;margin:auto;background:#fff;border:1px solid #e7e5e4;border-radius:12px;padding:24px"><p style="color:#e96f1d;font-weight:700;text-transform:uppercase;letter-spacing:.08em">InmínerCampus</p><h1>Nuevo pago confirmado</h1><p>El webhook de Stripe ha confirmado el pago. El acceso correspondiente ya puede activarse según el tipo de compra.</p><table style="width:100%;border-collapse:collapse">${tableRows}</table>${action}</main></body></html>`
}

function formatAddress(purchase: PurchaseForNotification): string {
  return [
    purchase.billing_address_line1,
    `${purchase.billing_postal_code} ${purchase.billing_city}`,
    purchase.billing_province,
    purchase.billing_country_code,
  ].join(', ')
}

function formatModality(value: string | undefined): string {
  const labels: Record<string, string> = {
    online: 'Online',
    in_person: 'Presencial',
    hybrid: 'Híbrida',
  }
  return value ? labels[value] ?? value : '—'
}

function formatDate(value: string | null): string {
  if (!value) return '—'
  return new Intl.DateTimeFormat('es-ES', {
    dateStyle: 'medium',
    timeStyle: 'short',
    timeZone: 'Europe/Madrid',
  }).format(new Date(value))
}

function escapeHtml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;')
}
