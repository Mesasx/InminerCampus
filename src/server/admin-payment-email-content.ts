import { formatCents } from '../lib/billing.ts'

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
  stripe_checkout_session_id: string | null
  stripe_payment_intent_id: string | null
  purchase_items: Array<{
    course_title_snapshot: string
    course_code_snapshot: string
    course_version_snapshot: number
    modality_snapshot: string
    duration_hours_snapshot: number
    description_snapshot: string
    quantity: number
    unit_net_cents: number | null
    line_net_cents: number | null
    line_tax_cents: number | null
    line_total_cents: number | null
  }>
}

export function buildPaymentEmailText(
  purchase: PurchaseForNotification,
  adminUrl: string,
): string {
  const item = purchase.purchase_items[0]
  const lines = [
    'Nuevo pago confirmado en InmínerCampus',
    'Acción requerida: generar y enviar la factura manualmente desde MNprogram.',
    '',
    `Pedido: ${purchase.order_number}`,
    `Purchase ID: ${purchase.id}`,
    `Tipo de compra: ${formatPurchaseKind(purchase.kind)}`,
    `Fecha de pago: ${formatDate(purchase.paid_at)}`,
    `Curso: ${item?.course_title_snapshot ?? '—'}`,
    `Código del curso: ${item?.course_code_snapshot ?? '—'}`,
    `Descripción para factura: ${item?.description_snapshot ?? '—'}`,
    `Versión: ${item?.course_version_snapshot ?? '—'}`,
    `Modalidad: ${formatModality(item?.modality_snapshot)}`,
    `Duración: ${item?.duration_hours_snapshot ?? '—'} horas`,
    `Plazas: ${item?.quantity ?? '—'}`,
    `Precio unitario sin IVA: ${formatOptionalCents(item?.unit_net_cents, purchase.currency)}`,
    `Base de la línea: ${formatOptionalCents(item?.line_net_cents, purchase.currency)}`,
    `IVA de la línea: ${formatOptionalCents(item?.line_tax_cents, purchase.currency)}`,
    `Total de la línea: ${formatOptionalCents(item?.line_total_cents, purchase.currency)}`,
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
    `Stripe Checkout: ${purchase.stripe_checkout_session_id || '—'}`,
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
    ['Purchase ID', purchase.id],
    ['Tipo de compra', formatPurchaseKind(purchase.kind)],
    ['Fecha de pago', formatDate(purchase.paid_at)],
    ['Curso', item?.course_title_snapshot ?? '—'],
    ['Código del curso', item?.course_code_snapshot ?? '—'],
    ['Descripción para factura', item?.description_snapshot ?? '—'],
    ['Versión', String(item?.course_version_snapshot ?? '—')],
    ['Modalidad', formatModality(item?.modality_snapshot)],
    ['Duración', `${item?.duration_hours_snapshot ?? '—'} horas`],
    ['Plazas', String(item?.quantity ?? '—')],
    ['Precio unitario sin IVA', formatOptionalCents(item?.unit_net_cents, purchase.currency)],
    ['Base de la línea', formatOptionalCents(item?.line_net_cents, purchase.currency)],
    ['IVA de la línea', formatOptionalCents(item?.line_tax_cents, purchase.currency)],
    ['Total de la línea', formatOptionalCents(item?.line_total_cents, purchase.currency)],
    ['Cliente', purchase.billing_name],
    ['NIF/CIF', purchase.billing_tax_id],
    ['Dirección', formatAddress(purchase)],
    ['Correo de facturación', purchase.billing_email],
    ['Correo de factura', purchase.invoice_email],
    ['Teléfono', purchase.billing_phone || '—'],
    ['Base imponible', formatCents(purchase.subtotal_net_cents, purchase.currency)],
    [`IVA (${purchase.tax_rate_basis_points / 100}%)`, formatCents(purchase.tax_amount_cents, purchase.currency)],
    ['Total', formatCents(purchase.total_amount_cents, purchase.currency)],
    ['Stripe Checkout', purchase.stripe_checkout_session_id || '—'],
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

  return `<!doctype html><html lang="es"><body style="font-family:Arial,sans-serif;color:#292524;background:#fafaf9;padding:24px"><main style="max-width:720px;margin:auto;background:#fff;border:1px solid #e7e5e4;border-radius:12px;padding:24px"><p style="color:#e96f1d;font-weight:700;text-transform:uppercase;letter-spacing:.08em">InmínerCampus</p><h1>Nuevo pago confirmado</h1><p>El webhook firmado de Stripe ha confirmado el pago y el pedido ya está registrado.</p><p><strong>Acción requerida:</strong> generar la factura manualmente en MNprogram y enviarla a la dirección indicada.</p><table style="width:100%;border-collapse:collapse">${tableRows}</table>${action}</main></body></html>`
}

function formatOptionalCents(
  value: number | null | undefined,
  currency: string,
): string {
  return value == null ? '—' : formatCents(value, currency)
}

function formatPurchaseKind(value: string): string {
  return value === 'company' ? 'Empresa' : 'Particular'
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
