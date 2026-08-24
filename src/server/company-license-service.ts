import { randomBytes } from 'node:crypto'
import { decryptAccessCode, encryptAccessCode } from './company-license-crypto'
import { getSupabaseAdmin } from './supabase-admin'

const CODE_ALPHABET = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ'

type RecipientRow = {
  id: string
  given_name: string
  family_name: string
  email: string
  access_code_id: string | null
  organization_id: string
  purchases: {
    id: string
    status: string
    organization_id: string
    billing_name: string
  }
  purchase_items: {
    course_title_snapshot: string
  }
}

export function generateCompanyAccessCode(): string {
  const bytes = randomBytes(12)
  const characters = Array.from(bytes, (byte) => CODE_ALPHABET[byte & 31]).join('')
  return `INM-${characters.slice(0, 4)}-${characters.slice(4, 8)}-${characters.slice(8)}`
}

export async function provisionAndSendCompanyLicenses(
  purchaseId: string,
): Promise<{ created: number; sent: number; failed: number }> {
  const supabase = getSupabaseAdmin()
  const { data: recipients, error } = await supabase
    .from('company_license_recipients')
    .select('id, access_code_id')
    .eq('purchase_id', purchaseId)
  if (error) throw new Error('Could not load company recipients')

  const missing = (recipients ?? []).filter(({ access_code_id }) => !access_code_id)
  if (missing.length) {
    const licenses = missing.map(({ id }) => {
      const plaintextCode = generateCompanyAccessCode()
      return {
        recipient_id: id,
        plaintext_code: plaintextCode,
        ...encryptAccessCode(plaintextCode),
      }
    })
    const { data: created, error: provisionError } = await supabase.rpc(
      'provision_company_licenses',
      { p_purchase_id: purchaseId, p_licenses: licenses },
    )
    if (provisionError) throw new Error('Could not provision company licenses')
    const delivery = await deliverPurchaseLicenseEmails(purchaseId)
    return { created: Number(created ?? 0), ...delivery }
  }

  return { created: 0, ...(await deliverPurchaseLicenseEmails(purchaseId)) }
}

export async function deliverPurchaseLicenseEmails(
  purchaseId: string,
  limit = 100,
): Promise<{ sent: number; failed: number }> {
  const supabase = getSupabaseAdmin()
  const { data, error } = await supabase
    .from('company_license_recipients')
    .select('id')
    .eq('purchase_id', purchaseId)
    .in('delivery_status', ['pending', 'failed', 'sending'])
    .limit(Math.max(1, Math.min(limit, 100)))
  if (error) throw new Error('Could not load license email queue')
  return runBounded(data ?? [], 5, async ({ id }) => sendCompanyLicenseEmail(id))
}

export async function processDueCompanyLicenseEmails(limit = 100) {
  const supabase = getSupabaseAdmin()
  const { data, error } = await supabase
    .from('company_license_recipients')
    .select('id')
    .in('delivery_status', ['pending', 'failed', 'sending'])
    .lte('next_attempt_at', new Date().toISOString())
    .order('next_attempt_at')
    .limit(Math.max(1, Math.min(limit, 100)))
  if (error) throw new Error('Could not load due license emails')
  return runBounded(data ?? [], 5, async ({ id }) => sendCompanyLicenseEmail(id))
}

export async function sendCompanyLicenseEmail(
  recipientId: string,
): Promise<'sent' | 'skipped'> {
  const supabase = getSupabaseAdmin()
  const { data: claimed, error: claimError } = await supabase.rpc(
    'claim_company_license_email',
    { p_recipient_id: recipientId },
  )
  if (claimError) throw new Error('Could not claim company license email')
  if (!claimed) return 'skipped'

  try {
    const recipient = await loadRecipient(recipientId)
    const code = await revealRecipientCode(recipientId)
    const appUrl = (process.env.VITE_APP_URL?.trim() || '').replace(/\/+$/, '')
    const activationUrl = `${appUrl}/canjear-codigo?code=${encodeURIComponent(code)}`
    const messageId = await sendWithResend({ recipient, code, activationUrl })
    await completeDelivery(recipientId, true, messageId, '')
    return 'sent'
  } catch (error) {
    await completeDelivery(
      recipientId,
      false,
      '',
      error instanceof Error ? error.message : 'Unknown license email error',
    )
    throw error
  }
}

export async function revealRecipientCode(recipientId: string): Promise<string> {
  const supabase = getSupabaseAdmin()
  const { data: recipient, error: recipientError } = await supabase
    .from('company_license_recipients')
    .select('access_code_id')
    .eq('id', recipientId)
    .single()
  if (recipientError || !recipient?.access_code_id) {
    throw new Error('License has no access code')
  }
  const { data: secret, error } = await supabase
    .from('company_access_code_secrets')
    .select('encryption_version, ciphertext, iv, auth_tag')
    .eq('access_code_id', recipient.access_code_id)
    .single()
  if (error || !secret) throw new Error('Access-code secret is unavailable')
  return decryptAccessCode(secret)
}

async function loadRecipient(recipientId: string): Promise<RecipientRow> {
  const { data, error } = await getSupabaseAdmin()
    .from('company_license_recipients')
    .select(
      'id, given_name, family_name, email, access_code_id, organization_id, purchases!inner(id, status, organization_id, billing_name), purchase_items!inner(course_title_snapshot)',
    )
    .eq('id', recipientId)
    .eq('purchases.status', 'paid')
    .single()
  if (error || !data) throw new Error('Paid company recipient is unavailable')
  return data as unknown as RecipientRow
}

async function sendWithResend({
  recipient,
  code,
  activationUrl,
}: {
  recipient: RecipientRow
  code: string
  activationUrl: string
}): Promise<string> {
  const apiKey = process.env.RESEND_API_KEY?.trim()
  const sender =
    process.env.COMPANY_LICENSE_EMAIL_FROM?.trim() ||
    process.env.ADMIN_NOTIFICATION_FROM?.trim() ||
    'InmínerCampus <campus@inminer.es>'
  if (!apiKey) throw new Error('Resend configuration is missing')
  const course = recipient.purchase_items.course_title_snapshot
  const company = recipient.purchases.billing_name
  const greeting = escapeHtml(recipient.given_name)
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `company-license/${recipient.id}`,
    },
    body: JSON.stringify({
      from: sender,
      to: [recipient.email],
      subject: `Tu acceso a ${course} · InmínerCampus`,
      text: `Hola ${recipient.given_name},\n\n${company} te ha asignado una plaza para ${course}.\n\nCódigo: ${code}\n\nActiva tu plaza: ${activationUrl}\n\nCrea o accede a tu cuenta y canjea este código. No recibirás ninguna contraseña por correo.`,
      html: `<!doctype html><html lang="es"><body style="font-family:Arial,sans-serif;color:#102a43;background:#f7f5f0;padding:24px"><main style="max-width:640px;margin:auto;background:white;border:1px solid #e7e2d8;border-radius:14px;padding:32px"><p style="color:#e96f1d;font-weight:800;letter-spacing:.08em">INMÍNERCAMPUS</p><h1>Tu plaza está preparada</h1><p>Hola ${greeting},</p><p><strong>${escapeHtml(company)}</strong> te ha asignado una plaza para:</p><h2>${escapeHtml(course)}</h2><p>Tu código individual:</p><p style="font:700 20px monospace;background:#f7f5f0;padding:16px;border-radius:8px">${escapeHtml(code)}</p><p><a href="${escapeHtml(activationUrl)}" style="display:inline-block;background:#e96f1d;color:white;text-decoration:none;padding:13px 20px;border-radius:8px;font-weight:700">Activar mi plaza</a></p><p style="color:#52606d;font-size:14px">Accede o crea tu propia cuenta y canjea el código. Nunca enviamos contraseñas por correo.</p></main></body></html>`,
    }),
  })
  const payload = (await response.json().catch(() => ({}))) as {
    id?: string
    message?: string
  }
  if (!response.ok || !payload.id) {
    throw new Error(payload.message || 'Resend rejected the license email')
  }
  return payload.id
}

async function completeDelivery(
  recipientId: string,
  success: boolean,
  messageId: string,
  error: string,
) {
  const { error: completeError } = await getSupabaseAdmin().rpc(
    'complete_company_license_email',
    {
      p_recipient_id: recipientId,
      p_success: success,
      p_message_id: messageId,
      p_error: error,
    },
  )
  if (completeError) throw new Error('Could not record license email delivery')
}

async function runBounded<T>(
  rows: Array<T>,
  concurrency: number,
  task: (row: T) => Promise<'sent' | 'skipped'>,
) {
  let index = 0
  let sent = 0
  let failed = 0
  async function worker() {
    while (index < rows.length) {
      const row = rows[index++]
      try {
        if ((await task(row)) === 'sent') sent += 1
      } catch {
        failed += 1
      }
    }
  }
  await Promise.all(
    Array.from({ length: Math.min(concurrency, rows.length) }, () => worker()),
  )
  return { sent, failed }
}

function escapeHtml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;')
}
