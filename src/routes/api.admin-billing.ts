import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'
import { createBillingCsv, type BillingCsvRow } from '../lib/billing-csv'

const filterSchema = z.object({
  q: z.string().trim().max(200).optional().default(''),
  status: z
    .enum(['all', 'pending_invoice', 'invoiced', 'invoice_sent', 'refunded'])
    .optional()
    .default('all'),
  notification: z
    .enum(['all', 'pending', 'sending', 'sent', 'failed', 'not_required'])
    .optional()
    .default('all'),
  from: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  to: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  format: z.enum(['json', 'csv']).optional().default('json'),
})

const actionSchema = z.discriminatedUnion('action', [
  z.object({
    action: z.literal('update_invoice'),
    purchaseId: z.uuid(),
    invoiceStatus: z.enum([
      'pending_invoice',
      'invoiced',
      'invoice_sent',
    ]),
    invoiceNumber: z.string().trim().max(120),
    adminNotes: z.string().trim().max(5_000),
  }),
  z.object({
    action: z.literal('retry_notification'),
    purchaseId: z.uuid(),
  }),
])

type BillingAdminRow = BillingCsvRow & {
  id: string
  kind: string
  status: string
  billing_address_line1: string
  billing_postal_code: string
  billing_city: string
  billing_province: string
  billing_country_code: string
  billing_phone: string | null
  tax_rate_basis_points: number
  refunded_amount_cents: number
  stripe_checkout_session_id: string | null
  invoice_status: string
  invoice_number: string | null
  invoiced_at: string | null
  invoice_sent_at: string | null
  admin_notes: string | null
  admin_notification_status: string
  admin_notification_attempts: number
  admin_notification_sent_at: string | null
  admin_notification_error: string | null
  invoices: Array<{
    id: string
    invoice_number: string
    internal_invoice_reference: string
    official_invoice_number: string | null
    status: string
    provider: string
    issued_at: string | null
    pdf_storage_path: string | null
    email_sent_at: string | null
    local_archive_status: string
    local_archive_path: string | null
    refund_requires_credit_note: boolean
    last_error: string | null
    billing_jobs: Array<{
      type: string
      status: string
      attempt_count: number
      next_attempt_at: string | null
      last_error: string | null
    }>
    mnprogram_syncs: Array<{
      status: string
      attempt_count: number
      last_error: string | null
      synced_at: string | null
    }>
  }>
}

export const Route = createFileRoute('/api/admin-billing')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const { requireAdministrator } = await import('../server/admin-auth')
        const administrator = await requireAdministrator(request)
        if (!administrator) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }

        const parsedFilters = filterSchema.safeParse(
          Object.fromEntries(new URL(request.url).searchParams),
        )
        if (!parsedFilters.success) {
          return Response.json({ error: 'Filtros no válidos.' }, { status: 400 })
        }
        const filters = parsedFilters.data
        const { data, error } = await administrator.supabase
          .from('purchases')
          .select(
            'id, order_number, kind, status, paid_at, billing_name, billing_tax_id, billing_address_line1, billing_postal_code, billing_city, billing_province, billing_country_code, billing_email, billing_phone, invoice_email, subtotal_net_cents, tax_amount_cents, total_amount_cents, tax_rate_basis_points, refunded_amount_cents, currency, stripe_checkout_session_id, stripe_payment_intent_id, invoice_status, invoice_number, invoiced_at, invoice_sent_at, admin_notes, admin_notification_status, admin_notification_attempts, admin_notification_sent_at, admin_notification_error, purchase_items(course_title_snapshot, course_version_snapshot, modality_snapshot, duration_hours_snapshot, quantity), invoices(id, invoice_number, internal_invoice_reference, official_invoice_number, status, provider, issued_at, pdf_storage_path, email_sent_at, local_archive_status, local_archive_path, refund_requires_credit_note, last_error, billing_jobs(type, status, attempt_count, next_attempt_at, last_error), mnprogram_syncs(status, attempt_count, last_error, synced_at))',
          )
          .in('status', ['paid', 'refunded', 'partially_refunded'])
          .order('paid_at', { ascending: false })
          .limit(2_000)
        if (error) {
          return Response.json(
            { error: 'No se han podido cargar los pagos.' },
            { status: 500 },
          )
        }

        const rows = filterRows(
          (data ?? []) as unknown as BillingAdminRow[],
          filters,
        )
        if (filters.format === 'csv') {
          const csv = createBillingCsv(rows.map(toBillingCsvRow))
          const date = new Date().toISOString().slice(0, 10)
          return new Response(csv, {
            headers: {
              'Content-Type': 'text/csv; charset=utf-8',
              'Content-Disposition': `attachment; filename="inminer-facturacion-${date}.csv"`,
              'Cache-Control': 'no-store',
            },
          })
        }
        return Response.json(
          { purchases: rows },
          { headers: { 'Cache-Control': 'no-store' } },
        )
      },

      POST: async ({ request }) => {
        const [
          { requireAdministrator },
          { sendPaymentAdminNotification },
        ] = await Promise.all([
          import('../server/admin-auth'),
          import('../server/admin-payment-email'),
        ])
        const administrator = await requireAdministrator(request)
        if (!administrator) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }
        const parsedAction = actionSchema.safeParse(
          await request.json().catch(() => null),
        )
        if (!parsedAction.success) {
          return Response.json(
            {
              error:
                parsedAction.error.issues[0]?.message ?? 'Acción no válida.',
            },
            { status: 400 },
          )
        }
        const action = parsedAction.data

        if (action.action === 'retry_notification') {
          try {
            const result = await sendPaymentAdminNotification(action.purchaseId)
            return Response.json({
              ok: true,
              message:
                result === 'sent'
                  ? 'Aviso enviado a Administración.'
                  : 'El aviso ya estaba enviado o se está procesando.',
            })
          } catch {
            return Response.json(
              { error: 'No se ha podido reenviar el aviso.' },
              { status: 502 },
            )
          }
        }

        if (
          action.invoiceStatus !== 'pending_invoice' &&
          !action.invoiceNumber
        ) {
          return Response.json(
            { error: 'Indica el número de factura.' },
            { status: 400 },
          )
        }
        const now = new Date().toISOString()
        const { data: currentPurchase } = await administrator.supabase
          .from('purchases')
          .select('id, invoice_status')
          .eq('id', action.purchaseId)
          .maybeSingle()
        if (!currentPurchase) {
          return Response.json(
            { error: 'No se ha encontrado el pago.' },
            { status: 404 },
          )
        }
        if (currentPurchase.invoice_status === 'refunded') {
          return Response.json(
            { error: 'Una factura reembolsada no puede modificarse.' },
            { status: 409 },
          )
        }
        const { data: automatedInvoice } = await administrator.supabase
          .from('invoices')
          .select('id')
          .eq('purchase_id', action.purchaseId)
          .maybeSingle()
        if (automatedInvoice) {
          return Response.json(
            {
              error:
                'Este pedido usa la facturación automática. Reintenta la integración correspondiente en lugar de crear otra factura.',
            },
            { status: 409 },
          )
        }
        const update = {
          invoice_status: action.invoiceStatus,
          invoice_number: action.invoiceNumber || null,
          admin_notes: action.adminNotes || null,
          invoiced_at:
            action.invoiceStatus === 'pending_invoice' ? null : now,
          invoice_sent_at:
            action.invoiceStatus === 'invoice_sent' ? now : null,
        }
        const { data: updatedPurchase, error } = await administrator.supabase
          .from('purchases')
          .update(update)
          .eq('id', action.purchaseId)
          .in('status', ['paid', 'refunded', 'partially_refunded'])
          .select('id')
          .maybeSingle()
        if (error || !updatedPurchase) {
          return Response.json(
            { error: 'No se ha podido actualizar la factura.' },
            { status: 500 },
          )
        }

        await administrator.supabase.from('audit_logs').insert({
          actor_user_id: administrator.user.id,
          action: 'purchase.invoice_updated',
          entity_type: 'purchase',
          entity_id: action.purchaseId,
          payload: {
            invoice_status: action.invoiceStatus,
            invoice_number: action.invoiceNumber || null,
          },
        })
        return Response.json({ ok: true, message: 'Factura actualizada.' })
      },
    },
  },
})

function filterRows(
  rows: BillingAdminRow[],
  filters: z.infer<typeof filterSchema>,
): BillingAdminRow[] {
  const search = filters.q.toLocaleLowerCase('es')
  return rows.filter((row) => {
    if (
      filters.status !== 'all' &&
      automatedFilterStatus(row) !== filters.status
    ) {
      return false
    }
    if (
      filters.notification !== 'all' &&
      row.admin_notification_status !== filters.notification
    ) {
      return false
    }
    const paidDate = row.paid_at?.slice(0, 10)
    if (filters.from && (!paidDate || paidDate < filters.from)) return false
    if (filters.to && (!paidDate || paidDate > filters.to)) return false
    if (!search) return true

    const item = row.purchase_items[0]
    return [
      row.order_number,
      row.invoice_number,
      row.invoices[0]?.official_invoice_number,
      row.invoices[0]?.internal_invoice_reference,
      row.billing_name,
      row.billing_tax_id,
      row.billing_email,
      row.invoice_email,
      row.stripe_payment_intent_id,
      item?.course_title_snapshot,
    ]
      .filter(Boolean)
      .join(' ')
      .toLocaleLowerCase('es')
      .includes(search)
  })
}

function automatedFilterStatus(row: BillingAdminRow): string {
  const invoice = row.invoices[0]
  if (!invoice) return row.invoice_status
  if (row.status === 'refunded') return 'refunded'
  if (invoice.email_sent_at) return 'invoice_sent'
  if (invoice.official_invoice_number) return 'invoiced'
  return 'pending_invoice'
}

function toBillingCsvRow(row: BillingAdminRow): BillingCsvRow {
  const invoice = row.invoices[0]
  if (!invoice) return row
  return {
    ...row,
    invoice_status: automatedFilterStatus(row),
    invoice_number:
      invoice.official_invoice_number ?? invoice.internal_invoice_reference,
  }
}
