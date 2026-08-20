import { createHash } from 'node:crypto'
import type { SupabaseClient } from '@supabase/supabase-js'
import { getSupabaseAdmin } from '../supabase-admin'
import type { InvoiceProvider, IssuedInvoice } from './invoice-provider'
import { createInvoicePdf, type InvoicePdfData } from './invoice-pdf'
import { MnProgramInvoiceProvider } from '../integrations/mnprogram/invoice-provider'
import {
  syncSaleToMnProgram,
  type MnProgramSaleSnapshot,
} from '../integrations/mnprogram/sync'
import {
  MnProgramNotConfiguredError,
  MnProgramRequestError,
} from '../integrations/mnprogram/client'

const BILLING_BUCKET = 'billing-documents'

export type BillingJob = {
  id: string
  purchase_id: string
  invoice_id: string
  type: 'mnprogram_sync' | 'invoice_issue' | 'invoice_email' | 'local_archive'
  attempt_count: number
}

type InvoiceContext = {
  id: string
  invoice_number: string
  internal_invoice_reference: string
  official_invoice_number: string | null
  invoice_year: number
  status: string
  provider: string
  customer_name: string
  customer_tax_id: string
  customer_email: string
  customer_address: Record<string, unknown>
  subtotal_cents: number
  tax_cents: number
  total_cents: number
  currency: string
  issued_at: string | null
  pdf_storage_path: string | null
  pdf_sha256: string | null
  email_sent_at: string | null
  email_delivery_version: number
  local_archive_status: string
  purchase: {
    id: string
    order_number: string
    kind: string
    paid_at: string
    billing_email: string
    invoice_email: string
    stripe_checkout_session_id: string | null
    stripe_payment_intent_id: string | null
    stripe_customer_id: string | null
    purchase_items: Array<{
      course_title_snapshot: string
      course_code_snapshot: string | null
      course_version_snapshot: number
      modality_snapshot: string
      quantity: number
      unit_net_cents: number
      line_net_cents: number
      line_total_cents: number
      tax_rate_basis_points: number
      description_snapshot: string | null
    }>
  }
}

export class BillingJobError extends Error {
  constructor(
    message: string,
    readonly retryable: boolean,
  ) {
    super(message)
    this.name = 'BillingJobError'
  }
}

export async function processDueBillingJobs(limit = 10): Promise<{
  claimed: number
  completed: number
  failed: number
}> {
  const supabase = getSupabaseAdmin()
  const { data, error } = await supabase.rpc('claim_billing_jobs', {
    p_limit: limit,
  })
  if (error) throw new Error('Could not claim billing jobs')

  const jobs = (data ?? []) as BillingJob[]
  let completed = 0
  let failed = 0

  for (const job of jobs) {
    try {
      await processBillingJob(job, {
        supabase,
        invoiceProvider: new MnProgramInvoiceProvider(),
      })
      await completeJob(supabase, job.id, true, false, '')
      completed += 1
    } catch (jobError) {
      const normalized = normalizeJobError(jobError)
      if (job.type === 'mnprogram_sync') {
        await supabase
          .from('mnprogram_syncs')
          .update({
            status:
              jobError instanceof MnProgramNotConfiguredError
                ? 'not_configured'
                : 'error',
            last_error: normalized.message,
            last_attempt_at: new Date().toISOString(),
          })
          .eq('invoice_id', job.invoice_id)
      }
      await completeJob(
        supabase,
        job.id,
        false,
        normalized.retryable,
        normalized.message,
      )
      failed += 1
    }
  }

  return { claimed: jobs.length, completed, failed }
}

export async function processBillingJob(
  job: BillingJob,
  dependencies: {
    supabase: SupabaseClient
    invoiceProvider: InvoiceProvider
  },
): Promise<void> {
  if (job.type === 'local_archive') {
    throw new BillingJobError(
      'Local archive jobs are processed by the Windows archive agent',
      false,
    )
  }

  const context = await loadInvoiceContext(
    dependencies.supabase,
    job.invoice_id,
  )

  if (job.type === 'mnprogram_sync') {
    await syncMnProgramTrace(dependencies.supabase, context)
    return
  }
  if (job.type === 'invoice_issue') {
    await issueInvoice(
      dependencies.supabase,
      context,
      dependencies.invoiceProvider,
    )
    return
  }
  await sendInvoiceEmail(dependencies.supabase, context)
}

async function syncMnProgramTrace(
  supabase: SupabaseClient,
  context: InvoiceContext,
) {
  const now = new Date().toISOString()
  const { data: currentSync, error: loadSyncError } = await supabase
    .from('mnprogram_syncs')
    .select('attempt_count')
    .eq('invoice_id', context.id)
    .maybeSingle()
  if (loadSyncError || !currentSync) {
    throw new BillingJobError('Could not load MNprogram sync state', true)
  }
  const { error: markSyncingError } = await supabase
    .from('mnprogram_syncs')
    .update({
      status: 'syncing',
      attempt_count: currentSync.attempt_count + 1,
      last_attempt_at: now,
      last_error: null,
    })
    .eq('invoice_id', context.id)
  if (markSyncingError) {
    throw new BillingJobError('Could not mark MNprogram sync in progress', true)
  }

  const result = await syncSaleToMnProgram(toMnProgramSnapshot(context))
  const { error } = await supabase
    .from('mnprogram_syncs')
    .update({
      status: 'synced',
      synced_at: now,
      last_attempt_at: now,
      last_error: null,
      mnprogram_actuacion_ref: result.reference,
    })
    .eq('invoice_id', context.id)
  // MNprogram already confirmed the SOAP request. Retrying here could create a
  // duplicate actuacion, so leave this for an explicit operator reconciliation.
  if (error) throw new BillingJobError('Could not record MNprogram sync', false)

  await supabase
    .from('invoices')
    .update({ mnprogram_reference: result.reference })
    .eq('id', context.id)
}

async function issueInvoice(
  supabase: SupabaseClient,
  context: InvoiceContext,
  provider: InvoiceProvider,
) {
  if (context.official_invoice_number && context.pdf_storage_path) {
    await supabase.rpc('enqueue_invoice_delivery_jobs', {
      p_invoice_id: context.id,
    })
    return
  }

  // The fiscal number may already have been persisted before a later PDF or
  // storage failure. Resume from that durable point and never issue again.
  if (context.official_invoice_number && context.issued_at) {
    await finalizeIssuedInvoice(
      supabase,
      context,
      {
        officialInvoiceNumber: context.official_invoice_number,
        issuedAt: context.issued_at,
        providerReference:
          context.official_invoice_number,
      },
      provider,
    )
    return
  }

  const issueResult = await provider.issueInvoice(context.id)
  if (issueResult.status === 'not_configured') {
    await supabase
      .from('invoices')
      .update({
        status: 'pending',
        provider: 'internal_pending_mnprogram',
        last_error: issueResult.reason,
      })
      .eq('id', context.id)
    throw new BillingJobError(issueResult.reason, false)
  }

  await finalizeIssuedInvoice(supabase, context, issueResult.value, provider)
}

async function finalizeIssuedInvoice(
  supabase: SupabaseClient,
  context: InvoiceContext,
  issued: IssuedInvoice,
  provider: InvoiceProvider,
) {
  const { data: updated, error: updateError } = await supabase
    .from('invoices')
    .update({
      official_invoice_number: issued.officialInvoiceNumber,
      invoice_number: issued.officialInvoiceNumber,
      mnprogram_invoice_reference: issued.providerReference,
      provider: 'mnprogram',
      status: 'issued',
      issued_at: issued.issuedAt,
      last_error: null,
    })
    .eq('id', context.id)
    .is('official_invoice_number', null)
    .select('id')
    .maybeSingle()
  if (updateError) {
    throw new BillingJobError('Could not persist official invoice number', false)
  }
  if (!updated && !context.official_invoice_number) {
    throw new BillingJobError('Invoice was issued concurrently', true)
  }

  const refreshed = await loadInvoiceContext(supabase, context.id)
  if (!refreshed.official_invoice_number || !refreshed.issued_at) {
    throw new BillingJobError('Official invoice data is incomplete', false)
  }

  const providerPdf = await provider.getInvoicePdf(context.id)
  const pdfBytes =
    providerPdf.status === 'ok'
      ? providerPdf.value
      : await createInvoicePdf(
          toInvoicePdfData(refreshed),
          await loadBrandLogo().catch(() => undefined),
        )
  const hash = sha256(pdfBytes)
  const storagePath = `invoices/${refreshed.invoice_year}/${refreshed.id}/invoice.pdf`
  const bucket = supabase.storage.from(BILLING_BUCKET)
  const { error: uploadError } = await bucket.upload(storagePath, pdfBytes, {
    contentType: 'application/pdf',
    upsert: false,
  })
  if (uploadError) {
    const { data: existing } = await bucket.download(storagePath)
    if (!existing || sha256(new Uint8Array(await existing.arrayBuffer())) !== hash) {
      throw new BillingJobError(
        'Invoice PDF path already contains different content',
        false,
      )
    }
  }

  const { error: pdfUpdateError } = await supabase
    .from('invoices')
    .update({ pdf_storage_path: storagePath, pdf_sha256: hash, status: 'issued' })
    .eq('id', refreshed.id)
    .is('pdf_storage_path', null)
  if (pdfUpdateError) {
    throw new BillingJobError('Could not record invoice PDF', true)
  }

  const { error: deliveryError } = await supabase.rpc(
    'enqueue_invoice_delivery_jobs',
    { p_invoice_id: refreshed.id },
  )
  if (deliveryError) {
    throw new BillingJobError('Could not enqueue invoice delivery', true)
  }
}

async function sendInvoiceEmail(
  supabase: SupabaseClient,
  context: InvoiceContext,
) {
  if (context.email_sent_at) return
  if (!context.pdf_storage_path || !context.official_invoice_number) {
    throw new BillingJobError('Invoice PDF is not ready for email', true)
  }

  const apiKey = process.env.RESEND_API_KEY?.trim()
  const sender =
    process.env.INVOICE_EMAIL_FROM?.trim() ||
    process.env.ADMIN_NOTIFICATION_FROM?.trim() ||
    'InmínerCampus <campus@inminer.es>'
  if (!apiKey) {
    throw new BillingJobError('RESEND_API_KEY is not configured', false)
  }

  const { data: pdf, error: downloadError } = await supabase.storage
    .from(BILLING_BUCKET)
    .download(context.pdf_storage_path)
  if (downloadError || !pdf) {
    throw new BillingJobError('Could not load invoice PDF for email', true)
  }

  const bytes = new Uint8Array(await pdf.arrayBuffer())
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `invoice-email/${context.id}/${context.email_delivery_version}`,
    },
    body: JSON.stringify({
      from: sender,
      to: [context.customer_email],
      subject: `Factura ${context.official_invoice_number} · InmínerCampus`,
      text:
        `Adjuntamos la factura ${context.official_invoice_number} correspondiente ` +
        `al pedido ${context.purchase.order_number}. Gracias por confiar en INMÍNER.`,
      html:
        `<p>Adjuntamos la factura <strong>${escapeHtml(context.official_invoice_number)}</strong> ` +
        `correspondiente al pedido ${escapeHtml(context.purchase.order_number)}.</p>` +
        '<p>Gracias por confiar en INMÍNER.</p>',
      attachments: [
        {
          filename: `${safeFileName(context.official_invoice_number)}.pdf`,
          content: Buffer.from(bytes).toString('base64'),
        },
      ],
    }),
  })
  if (!response.ok) {
    throw new BillingJobError(`Resend returned HTTP ${response.status}`, response.status >= 500)
  }

  const { error: updateError } = await supabase
    .from('invoices')
    .update({
      email_sent_at: new Date().toISOString(),
      status:
        context.local_archive_status === 'archived'
          ? 'archived'
          : 'archive_pending',
      last_error: null,
    })
    .eq('id', context.id)
    .is('email_sent_at', null)
  if (updateError) {
    throw new BillingJobError('Could not record invoice email delivery', true)
  }
}

async function loadInvoiceContext(
  supabase: SupabaseClient,
  invoiceId: string,
): Promise<InvoiceContext> {
  const { data, error } = await supabase
    .from('invoices')
    .select(
      'id, invoice_number, internal_invoice_reference, official_invoice_number, invoice_year, status, provider, customer_name, customer_tax_id, customer_email, customer_address, subtotal_cents, tax_cents, total_cents, currency, issued_at, pdf_storage_path, pdf_sha256, email_sent_at, email_delivery_version, local_archive_status, purchases!inner(id, order_number, kind, paid_at, billing_email, invoice_email, stripe_checkout_session_id, stripe_payment_intent_id, stripe_customer_id, purchase_items(course_title_snapshot, course_code_snapshot, course_version_snapshot, modality_snapshot, quantity, unit_net_cents, line_net_cents, line_total_cents, tax_rate_basis_points, description_snapshot))',
    )
    .eq('id', invoiceId)
    .maybeSingle()
  if (error || !data) throw new BillingJobError('Invoice not found', false)

  const row = data as unknown as Omit<InvoiceContext, 'purchase'> & {
    purchases: InvoiceContext['purchase']
  }
  return { ...row, purchase: row.purchases }
}

function toMnProgramSnapshot(context: InvoiceContext): MnProgramSaleSnapshot {
  return {
    purchaseId: context.purchase.id,
    orderNumber: context.purchase.order_number,
    purchaseKind: context.purchase.kind,
    customerName: context.customer_name,
    customerTaxId: context.customer_tax_id,
    customerEmail: context.customer_email,
    totalAmountCents: context.total_cents,
    subtotalCents: context.subtotal_cents,
    taxCents: context.tax_cents,
    currency: context.currency,
    paidAt: context.purchase.paid_at,
    stripePaymentIntentId: context.purchase.stripe_payment_intent_id,
    stripeCheckoutSessionId: context.purchase.stripe_checkout_session_id,
    stripeCustomerId: context.purchase.stripe_customer_id,
    invoiceNumber: context.invoice_number,
    invoiceStatus: context.status,
    items: context.purchase.purchase_items.map((item) => ({
      courseTitle: item.course_title_snapshot,
      courseCode: item.course_code_snapshot,
      courseVersion: item.course_version_snapshot,
      modality: item.modality_snapshot,
      quantity: item.quantity,
    })),
  }
}

function toInvoicePdfData(context: InvoiceContext): InvoicePdfData {
  const address = context.customer_address
  return {
    invoiceNumber: context.official_invoice_number!,
    issuedAt: context.issued_at!,
    orderNumber: context.purchase.order_number,
    customerName: context.customer_name,
    customerTaxId: context.customer_tax_id,
    customerEmail: context.customer_email,
    addressLine1: String(address.line1 ?? ''),
    postalCode: String(address.postalCode ?? ''),
    city: String(address.city ?? ''),
    province: String(address.province ?? ''),
    countryCode: String(address.countryCode ?? ''),
    subtotalCents: context.subtotal_cents,
    taxCents: context.tax_cents,
    totalCents: context.total_cents,
    currency: context.currency,
    items: context.purchase.purchase_items.map((item) => ({
      description:
        item.description_snapshot ||
        `${item.course_title_snapshot} · Versión ${item.course_version_snapshot}`,
      quantity: item.quantity,
      unitNetCents: item.unit_net_cents,
      lineNetCents: item.line_net_cents,
      taxRateBasisPoints: item.tax_rate_basis_points,
      lineTotalCents: item.line_total_cents,
    })),
  }
}

async function loadBrandLogo(): Promise<Uint8Array | undefined> {
  const appUrl = process.env.VITE_APP_URL?.trim().replace(/\/+$/, '')
  if (!appUrl) return undefined
  const response = await fetch(`${appUrl}/brand/inminer-campus-logo.png`, {
    signal: AbortSignal.timeout(3_000),
  })
  return response.ok ? new Uint8Array(await response.arrayBuffer()) : undefined
}

async function completeJob(
  supabase: SupabaseClient,
  jobId: string,
  success: boolean,
  retryable: boolean,
  errorMessage: string,
) {
  const { error } = await supabase.rpc('complete_billing_job', {
    p_job_id: jobId,
    p_success: success,
    p_retryable: retryable,
    p_error: errorMessage,
  })
  if (error) throw new Error('Could not complete billing job')
}

function normalizeJobError(error: unknown): {
  message: string
  retryable: boolean
} {
  if (error instanceof BillingJobError || error instanceof MnProgramRequestError) {
    return { message: error.message, retryable: error.retryable }
  }
  if (error instanceof MnProgramNotConfiguredError) {
    return { message: error.message, retryable: false }
  }
  return { message: 'Unexpected billing integration error', retryable: true }
}

function sha256(bytes: Uint8Array): string {
  return createHash('sha256').update(bytes).digest('hex')
}

function safeFileName(value: string): string {
  return value.replace(/[^A-Za-z0-9._-]+/g, '-')
}

function escapeHtml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;')
}

export const billingInternals = {
  sha256,
  toInvoicePdfData,
  toMnProgramSnapshot,
}
