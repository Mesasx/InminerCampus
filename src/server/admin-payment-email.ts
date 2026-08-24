import { formatCents } from '../lib/billing'
import {
  createCustomerAdministrativeData,
  type PurchaseForAdministrativeNotification,
} from './customer-administrative-data'
import { getSupabaseAdmin } from './supabase-admin'
import {
  runPaymentNotification,
  type PaymentNotificationResult,
} from './payment-notification-orchestrator'

export type PurchaseForNotification = PurchaseForAdministrativeNotification

const PURCHASE_SELECT =
  'id, order_number, kind, status, paid_at, billing_buyer_type, billing_name, billing_tax_id, billing_address_line1, billing_postal_code, billing_city, billing_province, billing_country_code, billing_email, billing_phone, invoice_email, subtotal_net_cents, tax_amount_cents, total_amount_cents, tax_rate_basis_points, currency, stripe_event_id, stripe_payment_intent_id, stripe_checkout_session_id, invoice_status, gross_subtotal_cents, discount_basis_points, discount_amount_cents, buyer_given_name, buyer_family_name, buyer_contact_email, buyer_contact_phone, purchase_items(course_title_snapshot, course_code_snapshot, course_version_snapshot, modality_snapshot, duration_hours_snapshot, quantity, unit_net_cents, line_net_cents, line_tax_cents, line_total_cents, description_snapshot), company_license_recipients(given_name, family_name, email)'

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
        .select(PURCHASE_SELECT)
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
    process.env.ADMIN_SALES_EMAIL?.trim() ||
    process.env.ADMIN_NOTIFICATION_EMAIL?.trim() ||
    'administracion@inminer.es'
  const sender =
    process.env.ADMIN_NOTIFICATION_FROM?.trim() ||
    'InmínerCampus <campus@inminer.es>'
  const appUrl = publicAppUrl()
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
      subject: buildPaymentEmailSubject(purchase),
      text: buildPaymentEmailText(purchase, appUrl),
      html: buildPaymentEmailHtml(purchase, appUrl),
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

export function buildPaymentEmailSubject(
  purchase: PurchaseForNotification,
): string {
  const data = createCustomerAdministrativeData(purchase)
  const course = cleanSubjectPart(
    data.purchase.courseCode || data.purchase.courseName,
  )
  return `InmínerCampus · Nueva compra · ${cleanSubjectPart(data.displayName)} · ${course}`
}

export function buildPaymentEmailText(
  purchase: PurchaseForNotification,
  appUrl: string,
): string {
  const data = createCustomerAdministrativeData(purchase)
  const { customer, contact, purchase: payment } = data
  const clientLines =
    data.customerType === 'Particular'
      ? [
          `Nombre: ${customer.givenName || '—'}`,
          `Apellidos: ${customer.familyName || '—'}`,
          `DNI/NIF: ${customer.taxId}`,
        ]
      : [
          `Razón social: ${customer.fiscalName}`,
          `CIF/NIF: ${customer.taxId}`,
        ]
  const lines = [
    'INMÍNERCAMPUS · NUEVA COMPRA CONFIRMADA',
    'Información administrativa generada automáticamente por InmínerCampus.',
    '',
    `Tipo de cliente: ${data.customerType}`,
    ...clientLines,
    `Email: ${customer.email}`,
    `Teléfono: ${customer.phone || '—'}`,
    `Dirección: ${customer.address}`,
    `Código postal: ${customer.postalCode}`,
    `Población: ${customer.city}`,
    `Provincia: ${customer.province}`,
    `País: ${customer.country}`,
  ]

  if (contact) {
    lines.push(
      '',
      'PERSONA DE CONTACTO',
      `Nombre y apellidos: ${contact.fullName}`,
      `Email: ${contact.email}`,
      `Teléfono: ${contact.phone || '—'}`,
    )
  }

  lines.push(
    '',
    'DATOS DE LA COMPRA',
    `Curso: ${payment.courseName}`,
    `ITC/código: ${payment.courseCode || '—'}`,
    `Versión: ${payment.courseVersion ?? '—'}`,
    `Modalidad: ${formatModality(payment.modality)}`,
    `Duración: ${payment.durationHours ?? '—'} horas`,
    `Plazas/licencias: ${payment.quantity}`,
    `Importe pagado: ${formatCents(payment.totalAmountCents, payment.currency)}`,
    `Moneda: ${payment.currency}`,
    `Fecha y hora: ${formatDate(payment.paidAt)}`,
    `Pedido: ${payment.orderNumber}`,
    `ID interno: ${payment.purchaseId}`,
    `Stripe Event: ${payment.stripeEventId || '—'}`,
    `Checkout Session: ${payment.stripeCheckoutSessionId || '—'}`,
    `Payment Intent: ${payment.stripePaymentIntentId || '—'}`,
    `Método: ${payment.paymentMethod}`,
    `Estado: ${payment.paymentStatus}`,
    '',
    'DATOS PREPARADOS PARA MN PROGRAM',
    `Tipo de cliente: ${data.customerType}`,
    `Nombre / Razón social: ${customer.fiscalName}`,
    `NIF/CIF: ${customer.taxId}`,
    `Teléfono: ${customer.phone || '—'}`,
    `Email: ${customer.email}`,
    `Dirección: ${customer.address}`,
    `Código postal: ${customer.postalCode}`,
    `Población: ${customer.city}`,
    `Provincia: ${customer.province}`,
    `País: ${customer.country}`,
  )

  if (contact) {
    lines.push(
      `Persona de contacto: ${contact.fullName}`,
      `Email de contacto: ${contact.email}`,
      `Teléfono de contacto: ${contact.phone || '—'}`,
    )
  }
  if (data.participants.length) {
    lines.push('', 'PARTICIPANTES / LICENCIAS')
    for (const participant of data.participants) {
      lines.push(`- ${participant.fullName} <${participant.email}>`)
    }
  }
  if (appUrl) {
    lines.push(
      '',
      `Gestionar pedido: ${appUrl}/admin/facturacion?pedido=${payment.purchaseId}`,
    )
  }
  return lines.join('\n')
}

export function buildPaymentEmailHtml(
  purchase: PurchaseForNotification,
  appUrl: string,
): string {
  const data = createCustomerAdministrativeData(purchase)
  const { customer, contact, purchase: payment } = data
  const logoUrl = `${appUrl}/brand/inminer-campus-logo.png`
  const manageUrl = `${appUrl}/admin/facturacion?pedido=${payment.purchaseId}`

  const customerRows =
    data.customerType === 'Particular'
      ? [
          ['Nombre', customer.givenName || '—'],
          ['Apellidos', customer.familyName || '—'],
          ['DNI/NIF', customer.taxId],
          ['Email', customer.email],
          ['Teléfono', customer.phone || '—'],
          ['Dirección', customer.address],
          ['Código postal', customer.postalCode],
          ['Población', customer.city],
          ['Provincia', customer.province],
          ['País', customer.country],
        ]
      : [
          ['Razón social', customer.fiscalName],
          ['CIF/NIF', customer.taxId],
          ['Dirección fiscal', customer.address],
          ['Código postal', customer.postalCode],
          ['Población', customer.city],
          ['Provincia', customer.province],
          ['País', customer.country],
          ['Teléfono de empresa', customer.phone || '—'],
          ['Email de empresa/facturación', customer.email],
        ]

  const contactSection = contact
    ? card(
        'Persona de contacto',
        dataTable([
          ['Nombre y apellidos', contact.fullName],
          ['Email', contact.email],
          ['Teléfono', contact.phone || '—'],
        ]),
      )
    : ''

  const purchaseRows = [
    ['Nombre del curso', payment.courseName],
    ['ITC / código', payment.courseCode || '—'],
    ['Versión', String(payment.courseVersion ?? '—')],
    ['Modalidad', formatModality(payment.modality)],
    ['Duración', `${payment.durationHours ?? '—'} horas`],
    ['Plazas / licencias', String(payment.quantity)],
    [
      'Precio unitario neto',
      formatCents(payment.unitNetCents, payment.currency),
    ],
    [
      'Subtotal antes de descuento',
      formatCents(payment.grossSubtotalCents, payment.currency),
    ],
    [
      `Descuento (${payment.discountBasisPoints / 100} %)`,
      formatCents(payment.discountAmountCents, payment.currency),
    ],
    [
      'Base imponible',
      formatCents(payment.subtotalNetCents, payment.currency),
    ],
    [
      `IVA (${purchase.tax_rate_basis_points / 100} %)`,
      formatCents(payment.taxAmountCents, payment.currency),
    ],
    [
      'Precio pagado',
      formatCents(payment.totalAmountCents, payment.currency),
    ],
    ['Moneda', payment.currency],
    ['Fecha y hora de compra', formatDate(payment.paidAt)],
    ['Pedido', payment.orderNumber],
    ['Identificador interno', payment.purchaseId],
    ['Stripe Event ID', payment.stripeEventId || '—'],
    ['Stripe Checkout Session ID', payment.stripeCheckoutSessionId || '—'],
    ['Stripe Payment Intent ID', payment.stripePaymentIntentId || '—'],
    ['Método de pago', payment.paymentMethod],
    ['Estado del pago', payment.paymentStatus],
  ]

  const mnRows = [
    ['Tipo de cliente', data.customerType],
    ['Nombre / Razón social', customer.fiscalName],
    ['NIF/CIF', customer.taxId],
    ['Teléfono', customer.phone || '—'],
    ['Email', customer.email],
    ['Dirección', customer.address],
    ['Código postal', customer.postalCode],
    ['Población', customer.city],
    ['Provincia', customer.province],
    ['País', customer.country],
    ...(contact
      ? [
          ['Persona de contacto', contact.fullName],
          ['Email de contacto', contact.email],
          ['Teléfono de contacto', contact.phone || '—'],
        ]
      : []),
  ]

  const participants = data.participants.length
    ? card(
        'Participantes / licencias',
        `<p style="margin:0 0 14px;color:#665f57;font-size:14px;line-height:1.6">${data.participants.length} licencias. Los códigos de acceso no se incluyen en este correo administrativo.</p>${dataTable(
          data.participants.map((participant, index) => [
            `Persona ${index + 1}`,
            `${participant.fullName} · ${participant.email}`,
          ]),
        )}`,
      )
    : ''

  return `<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Nueva compra confirmada</title>
    <style>@media only screen and (max-width:620px){.email-shell{padding:14px!important}.email-card{padding:20px!important}.summary-cell{display:block!important;width:auto!important;border-right:0!important;border-bottom:1px solid #eadfce!important}.summary-cell:last-child{border-bottom:0!important}.data-label,.data-value{display:block!important;width:auto!important;text-align:left!important}.data-label{padding-bottom:2px!important}.data-value{padding-top:2px!important}.brand-logo{width:165px!important}}</style>
  </head>
  <body style="margin:0;background:#f7f3ec;color:#172f41;font-family:Arial,Helvetica,sans-serif">
    <div style="display:none;max-height:0;overflow:hidden;opacity:0">Compra confirmada de ${escapeHtml(data.displayName)} · ${escapeHtml(payment.courseName)}</div>
    <div class="email-shell" style="padding:32px 16px">
      <main class="email-card" style="max-width:720px;margin:0 auto;background:#fff;border:1px solid #eadfce;border-radius:18px;overflow:hidden;box-shadow:0 12px 35px rgba(64,44,20,.08)">
        <header style="padding:34px 34px 28px;text-align:center;border-top:5px solid #f17419">
          <img class="brand-logo" src="${escapeHtml(logoUrl)}" width="190" alt="InmínerCampus" style="display:block;width:190px;max-width:70%;height:auto;margin:0 auto 24px">
          <p style="margin:0 0 8px;color:#d85f12;font-size:12px;font-weight:700;letter-spacing:.16em;text-transform:uppercase">Pago verificado por Stripe</p>
          <h1 style="margin:0;color:#153950;font-size:30px;line-height:1.2">Nueva compra confirmada</h1>
          <p style="margin:12px auto 0;max-width:520px;color:#766d63;font-size:14px;line-height:1.6">Información administrativa generada automáticamente por InmínerCampus.</p>
        </header>

        <section style="margin:0 28px 26px;border:1px solid #f0dfc4;border-radius:14px;background:#fffaf2;overflow:hidden">
          <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="border-collapse:collapse">
            <tr>
              ${summaryCell('Cliente', data.displayName)}
              ${summaryCell('Curso', payment.courseCode || payment.courseName)}
              ${summaryCell('Importe', formatCents(payment.totalAmountCents, payment.currency))}
              ${summaryCell('Fecha', formatDate(payment.paidAt))}
            </tr>
          </table>
        </section>

        <div style="padding:0 28px 30px">
          ${card(`Datos del ${data.customerType === 'Particular' ? 'particular' : 'cliente / empresa'}`, dataTable(customerRows))}
          ${contactSection}
          ${card('Datos de la compra', dataTable(purchaseRows))}
          ${participants}
          ${card('Datos preparados para MN Program', `<p style="margin:0 0 16px;color:#766d63;font-size:14px;line-height:1.6">Campos normalizados para copiar o importar. Esta notificación no realiza ningún alta automática en MN Program.</p>${dataTable(mnRows)}`, true)}
          <p style="margin:26px 0 8px;text-align:center"><a href="${escapeHtml(manageUrl)}" style="display:inline-block;padding:13px 22px;border-radius:9px;background:#e86d17;color:#fff;font-size:14px;font-weight:700;text-decoration:none">Abrir pedido en Administración</a></p>
        </div>

        <footer style="padding:22px 28px;background:#153950;color:#fff;text-align:center">
          <p style="margin:0;font-size:13px;font-weight:700">InmínerCampus · Inmíner Ingeniería</p>
          <p style="margin:7px 0 0;color:#d8e2e8;font-size:12px;line-height:1.5">Notificación interna. No contiene datos de tarjeta, CVC, contraseñas ni secretos.</p>
        </footer>
      </main>
    </div>
  </body>
</html>`
}

function publicAppUrl(): string {
  const configured =
    process.env.ADMIN_APP_URL?.trim() ||
    process.env.VITE_APP_URL?.trim() ||
    process.env.VERCEL_PROJECT_PRODUCTION_URL?.trim() ||
    'https://inminercampus.com'
  const withProtocol = /^https?:\/\//i.test(configured)
    ? configured
    : `https://${configured}`
  return withProtocol.replace(/\/+$/, '')
}

function summaryCell(label: string, value: string): string {
  return `<td class="summary-cell" width="25%" valign="top" style="padding:17px 13px;border-right:1px solid #f0dfc4"><span style="display:block;margin-bottom:6px;color:#b85b18;font-size:10px;font-weight:700;letter-spacing:.11em;text-transform:uppercase">${escapeHtml(label)}</span><strong style="display:block;color:#153950;font-size:13px;line-height:1.4">${escapeHtml(value)}</strong></td>`
}

function card(title: string, content: string, highlighted = false): string {
  const background = highlighted ? '#fffaf2' : '#ffffff'
  const border = highlighted ? '#efc891' : '#e9e3da'
  return `<section style="margin:0 0 22px;padding:22px;border:1px solid ${border};border-radius:14px;background:${background}"><h2 style="margin:0 0 16px;color:#153950;font-size:18px;line-height:1.3">${escapeHtml(title)}</h2>${content}</section>`
}

function dataTable(rows: string[][]): string {
  return `<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="border-collapse:collapse">${rows
    .map(
      ([label, value], index) =>
        `<tr><td class="data-label" width="38%" valign="top" style="padding:${index ? '11px' : '0'} 12px 11px 0;border-bottom:1px solid #eee9e1;color:#766d63;font-size:13px;font-weight:700;line-height:1.45">${escapeHtml(label)}</td><td class="data-value" valign="top" style="padding:${index ? '11px' : '0'} 0 11px 12px;border-bottom:1px solid #eee9e1;color:#202f38;font-size:14px;line-height:1.5;word-break:break-word">${escapeHtml(value)}</td></tr>`,
    )
    .join('')}</table>`
}

function formatModality(value: string | null): string {
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

function cleanSubjectPart(value: string): string {
  return value.replace(/\s+/g, ' ').trim()
}
