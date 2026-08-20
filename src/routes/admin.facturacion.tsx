import { createFileRoute } from '@tanstack/react-router'
import {
  Download,
  ExternalLink,
  RefreshCw,
  ReceiptText,
  Search,
  Send,
} from 'lucide-react'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { formatCents } from '../lib/billing'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

type BillingPurchase = {
  id: string
  order_number: string
  kind: string
  status: string
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
  refunded_amount_cents: number
  currency: string
  stripe_payment_intent_id: string | null
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
  purchase_items: Array<{
    course_title_snapshot: string
    course_version_snapshot: number
    modality_snapshot: string
    duration_hours_snapshot: number
    quantity: number
  }>
}

type Filters = {
  q: string
  status: string
  notification: string
  from: string
  to: string
}

const emptyFilters: Filters = {
  q: '',
  status: 'all',
  notification: 'all',
  from: '',
  to: '',
}

export const Route = createFileRoute('/admin/facturacion')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { pedido?: string } => ({
    pedido: typeof search.pedido === 'string' ? search.pedido : undefined,
  }),
  component: AdminBillingPage,
})

function AdminBillingPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminBilling user={user} />}
    </ProtectedGate>
  )
}

function AdminBilling({ user }: { user: SessionUser }) {
  const { pedido: requestedPurchaseId } = Route.useSearch()
  const [purchases, setPurchases] = useState<BillingPurchase[]>([])
  const [selectedId, setSelectedId] = useState<string | null>(
    requestedPurchaseId ?? null,
  )
  const [filters, setFilters] = useState<Filters>(emptyFilters)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [notice, setNotice] = useState('')
  const [invoiceStatus, setInvoiceStatus] = useState('pending_invoice')
  const [invoiceNumber, setInvoiceNumber] = useState('')
  const [adminNotes, setAdminNotes] = useState('')

  const load = useCallback(async () => {
    const token = await getAccessToken()
    if (!token) {
      setNotice('Tu sesión ha caducado.')
      setLoading(false)
      return
    }
    try {
      const params = new URLSearchParams()
      Object.entries(filters).forEach(([key, value]) => {
        if (value) params.set(key, value)
      })
      const response = await fetch(`/api/admin-billing?${params}`, {
        headers: { Authorization: `Bearer ${token}` },
      })
      const payload = (await response.json()) as {
        purchases?: BillingPurchase[]
        error?: string
      }
      if (!response.ok) {
        setNotice(payload.error ?? 'No se han podido cargar los pagos.')
        return
      }
      const rows = payload.purchases ?? []
      setPurchases(rows)
      setSelectedId((current) =>
        current && rows.some((purchase) => purchase.id === current)
          ? current
          : rows[0]?.id ?? null,
      )
    } catch {
      setNotice('No se ha podido conectar con la gestión de pagos.')
    } finally {
      setLoading(false)
    }
  }, [filters])

  useEffect(() => {
    const timeout = setTimeout(() => void load(), 250)
    return () => clearTimeout(timeout)
  }, [load])

  const selected = useMemo(
    () => purchases.find((purchase) => purchase.id === selectedId) ?? null,
    [purchases, selectedId],
  )

  useEffect(() => {
    if (!selected) return
    setInvoiceStatus(selected.invoice_status)
    setInvoiceNumber(selected.invoice_number ?? '')
    setAdminNotes(selected.admin_notes ?? '')
  }, [selected])

  async function postAction(body: Record<string, unknown>) {
    const token = await getAccessToken()
    if (!token) {
      setNotice('Tu sesión ha caducado.')
      return false
    }
    setSaving(true)
    try {
      const response = await fetch('/api/admin-billing', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      })
      const payload = (await response.json()) as {
        message?: string
        error?: string
      }
      setNotice(
        response.ok
          ? payload.message ?? 'Cambios guardados.'
          : payload.error ?? 'No se ha podido completar la acción.',
      )
      if (response.ok) await load()
      return response.ok
    } catch {
      setNotice('No se ha podido conectar con la gestión de pagos.')
      return false
    } finally {
      setSaving(false)
    }
  }

  async function saveInvoice() {
    if (!selected) return
    await postAction({
      action: 'update_invoice',
      purchaseId: selected.id,
      invoiceStatus,
      invoiceNumber,
      adminNotes,
    })
  }

  async function retryNotification() {
    if (!selected) return
    await postAction({
      action: 'retry_notification',
      purchaseId: selected.id,
    })
  }

  async function retryInvoiceJob(jobType: string) {
    if (!selected?.invoices[0]) return
    const token = await getAccessToken()
    if (!token) return
    setSaving(true)
    try {
      const response = await fetch(
        `/api/admin/billing/retry/${encodeURIComponent(selected.invoices[0].id)}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ jobType }),
        },
      )
      const payload = (await response.json()) as {
        message?: string
        error?: string
      }
      setNotice(
        response.ok
          ? payload.message ?? 'Reintento programado.'
          : payload.error ?? 'No se ha podido programar el reintento.',
      )
      if (response.ok) await load()
    } catch {
      setNotice('No se ha podido conectar para programar el reintento.')
    } finally {
      setSaving(false)
    }
  }

  async function downloadInvoice() {
    const invoice = selected?.invoices[0]
    if (!invoice?.pdf_storage_path || !invoice.official_invoice_number) return
    const token = await getAccessToken()
    if (!token) return
    try {
      const response = await fetch(
        `/api/invoices/${encodeURIComponent(invoice.id)}/download`,
        { headers: { Authorization: `Bearer ${token}` } },
      )
      const payload = (await response.json()) as { url?: string; error?: string }
      if (response.ok && payload.url) {
        window.open(payload.url, '_blank', 'noopener')
      } else {
        setNotice(payload.error ?? 'No se ha podido descargar la factura.')
      }
    } catch {
      setNotice('No se ha podido conectar para descargar la factura.')
    }
  }

  async function downloadCsv() {
    const token = await getAccessToken()
    if (!token) return
    const params = new URLSearchParams({ ...filters, format: 'csv' })
    const response = await fetch(`/api/admin-billing?${params}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
    if (!response.ok) {
      setNotice('No se ha podido generar el CSV.')
      return
    }
    const blob = await response.blob()
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `inminer-facturacion-${new Date().toISOString().slice(0, 10)}.csv`
    link.click()
    URL.revokeObjectURL(url)
  }

  return (
    <AppShell user={user} mode="admin" title="Pagos y facturación">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Administración económica</span>
          <h1>Pagos y facturación.</h1>
          <p>
            Consulta cada pago confirmado, prepara su factura y controla los
            avisos a Administración.
          </p>
        </div>
        <div className="content-editor__actions">
          <button
            className="button button--outline"
            onClick={() => void load()}
            type="button"
          >
            <RefreshCw size={17} /> Actualizar
          </button>
          <button
            className="button button--primary"
            onClick={() => void downloadCsv()}
            type="button"
          >
            <Download size={17} /> Exportar CSV
          </button>
        </div>
      </div>

      {notice ? <div className="alert alert--info">{notice}</div> : null}

      <section className="panel billing-filters">
        <div className="field field--search">
          <label htmlFor="billing-search">Buscar</label>
          <div className="field__with-icon">
            <Search size={18} />
            <input
              id="billing-search"
              placeholder="Pedido, cliente, NIF, correo o curso"
              value={filters.q}
              onChange={(event) =>
                setFilters((current) => ({ ...current, q: event.target.value }))
              }
            />
          </div>
        </div>
        <div className="field">
          <label htmlFor="invoice-filter">Factura</label>
          <select
            id="invoice-filter"
            value={filters.status}
            onChange={(event) =>
              setFilters((current) => ({
                ...current,
                status: event.target.value,
              }))
            }
          >
            <option value="all">Todas</option>
            <option value="pending_invoice">Pendientes</option>
            <option value="invoiced">Emitidas</option>
            <option value="invoice_sent">Enviadas</option>
            <option value="refunded">Reembolsadas</option>
          </select>
        </div>
        <div className="field">
          <label htmlFor="notification-filter">Aviso</label>
          <select
            id="notification-filter"
            value={filters.notification}
            onChange={(event) =>
              setFilters((current) => ({
                ...current,
                notification: event.target.value,
              }))
            }
          >
            <option value="all">Todos</option>
            <option value="pending">Pendiente</option>
            <option value="sending">En proceso</option>
            <option value="sent">Enviado</option>
            <option value="failed">Fallido</option>
          </select>
        </div>
        <div className="field">
          <label htmlFor="billing-from">Desde</label>
          <input
            id="billing-from"
            type="date"
            value={filters.from}
            onChange={(event) =>
              setFilters((current) => ({
                ...current,
                from: event.target.value,
              }))
            }
          />
        </div>
        <div className="field">
          <label htmlFor="billing-to">Hasta</label>
          <input
            id="billing-to"
            type="date"
            value={filters.to}
            onChange={(event) =>
              setFilters((current) => ({ ...current, to: event.target.value }))
            }
          />
        </div>
      </section>

      <div className="admin-split billing-admin">
        <section className="panel">
          <div className="panel__header">
            <h2>Pagos confirmados</h2>
            <span className="status">{purchases.length} resultados</span>
          </div>
          {loading ? (
            <p className="muted">Cargando pagos…</p>
          ) : purchases.length ? (
            <div className="admin-list">
              {purchases.map((purchase) => {
                const item = purchase.purchase_items[0]
                return (
                  <button
                    className={
                      selectedId === purchase.id
                        ? 'admin-list__item is-active'
                        : 'admin-list__item'
                    }
                    key={purchase.id}
                    onClick={() => setSelectedId(purchase.id)}
                    type="button"
                  >
                    <span className="app-course__number">
                      <ReceiptText size={18} />
                    </span>
                    <span>
                      <strong>{purchase.order_number}</strong>
                      <small>
                        {purchase.billing_name} ·{' '}
                        {item?.course_title_snapshot ?? 'Curso'}
                      </small>
                    </span>
                    <span>
                      <strong>
                        {formatCents(
                          purchase.total_amount_cents,
                          purchase.currency,
                        )}
                      </strong>
                      <small>
                        {purchase.invoices[0]
                          ? automatedInvoiceLabel(purchase.invoices[0].status)
                          : invoiceLabel(purchase.invoice_status)}
                      </small>
                    </span>
                  </button>
                )
              })}
            </div>
          ) : (
            <div className="empty-state">
              <p>No hay pagos que coincidan con los filtros.</p>
            </div>
          )}
        </section>

        <section className="panel admin-detail">
          {selected ? (
            <BillingDetail
              adminNotes={adminNotes}
              invoiceNumber={invoiceNumber}
              invoiceStatus={invoiceStatus}
              purchase={selected}
              saving={saving}
              onAdminNotesChange={setAdminNotes}
              onInvoiceNumberChange={setInvoiceNumber}
              onInvoiceStatusChange={setInvoiceStatus}
              onRetryNotification={retryNotification}
              onRetryInvoiceJob={retryInvoiceJob}
              onDownloadInvoice={downloadInvoice}
              onSave={saveInvoice}
            />
          ) : (
            <div className="empty-state">
              <p>Selecciona un pago para consultar sus datos.</p>
            </div>
          )}
        </section>
      </div>
    </AppShell>
  )
}

function BillingDetail({
  purchase,
  invoiceStatus,
  invoiceNumber,
  adminNotes,
  saving,
  onInvoiceStatusChange,
  onInvoiceNumberChange,
  onAdminNotesChange,
  onRetryNotification,
  onRetryInvoiceJob,
  onDownloadInvoice,
  onSave,
}: {
  purchase: BillingPurchase
  invoiceStatus: string
  invoiceNumber: string
  adminNotes: string
  saving: boolean
  onInvoiceStatusChange: (value: string) => void
  onInvoiceNumberChange: (value: string) => void
  onAdminNotesChange: (value: string) => void
  onRetryNotification: () => void
  onRetryInvoiceJob: (jobType: string) => void
  onDownloadInvoice: () => void
  onSave: () => void
}) {
  const item = purchase.purchase_items[0]
  const automatedInvoice = purchase.invoices[0]
  const invoiceLocked = purchase.invoice_status === 'refunded'
  return (
    <>
      <div className="panel__header">
        <div>
          <span className="eyebrow">Detalle del pago</span>
          <h2>{purchase.order_number}</h2>
          <p className="muted">
            {purchase.paid_at
              ? new Date(purchase.paid_at).toLocaleString('es-ES')
              : 'Fecha pendiente'}
          </p>
        </div>
        <span className="status status--orange">
          {formatCents(purchase.total_amount_cents, purchase.currency)}
        </span>
      </div>

      <dl className="admin-detail__facts billing-detail__facts">
        <div>
          <dt>Curso</dt>
          <dd>
            {item?.course_title_snapshot ?? '—'} · versión{' '}
            {item?.course_version_snapshot ?? '—'}
          </dd>
        </div>
        <div>
          <dt>Formato</dt>
          <dd>
            {modalityLabel(item?.modality_snapshot)} ·{' '}
            {item?.duration_hours_snapshot ?? '—'} h ·{' '}
            {item?.quantity ?? '—'} plaza(s)
          </dd>
        </div>
        <div>
          <dt>Cliente fiscal</dt>
          <dd>
            {purchase.billing_name} · {purchase.billing_tax_id}
          </dd>
        </div>
        <div>
          <dt>Dirección fiscal</dt>
          <dd>
            {purchase.billing_address_line1},{' '}
            {purchase.billing_postal_code} {purchase.billing_city},{' '}
            {purchase.billing_province} ({purchase.billing_country_code})
          </dd>
        </div>
        <div>
          <dt>Contacto</dt>
          <dd>
            {purchase.billing_email} · {purchase.billing_phone || 'sin teléfono'}
          </dd>
        </div>
        <div>
          <dt>Enviar factura a</dt>
          <dd>{purchase.invoice_email}</dd>
        </div>
      </dl>

      <dl className="order-totals">
        <div>
          <dt>Base imponible</dt>
          <dd>
            {formatCents(purchase.subtotal_net_cents, purchase.currency)}
          </dd>
        </div>
        <div>
          <dt>IVA ({purchase.tax_rate_basis_points / 100} %)</dt>
          <dd>{formatCents(purchase.tax_amount_cents, purchase.currency)}</dd>
        </div>
        <div className="order-totals__total">
          <dt>Total</dt>
          <dd>{formatCents(purchase.total_amount_cents, purchase.currency)}</dd>
        </div>
        {purchase.refunded_amount_cents ? (
          <div>
            <dt>Reembolsado</dt>
            <dd>
              {formatCents(purchase.refunded_amount_cents, purchase.currency)}
            </dd>
          </div>
        ) : null}
      </dl>

      <div className="billing-detail__stripe">
        <span>
          Stripe:{' '}
          <code>{purchase.stripe_payment_intent_id || 'sin referencia'}</code>
        </span>
        {purchase.stripe_payment_intent_id ? (
          <a
            className="text-link"
            href={`https://dashboard.stripe.com/payments/${encodeURIComponent(purchase.stripe_payment_intent_id)}`}
            rel="noreferrer"
            target="_blank"
          >
            Abrir en Stripe <ExternalLink size={14} />
          </a>
        ) : null}
      </div>

      {automatedInvoice ? (
        <AutomatedInvoicePanel
          invoice={automatedInvoice}
          saving={saving}
          onDownload={onDownloadInvoice}
          onRetry={onRetryInvoiceJob}
        />
      ) : (
      <div className="form-grid billing-detail__editor">
        <div className="form-row">
          <div className="field">
            <label htmlFor="invoice-status">Estado de factura</label>
            <select
              disabled={invoiceLocked}
              id="invoice-status"
              value={invoiceStatus}
              onChange={(event) =>
                onInvoiceStatusChange(event.target.value)
              }
            >
              <option value="pending_invoice">Pendiente</option>
              <option value="invoiced">Emitida</option>
              <option value="invoice_sent">Enviada</option>
              <option value="refunded">Reembolsada</option>
            </select>
          </div>
          <div className="field">
            <label htmlFor="invoice-number">Número de factura</label>
            <input
              disabled={invoiceLocked}
              id="invoice-number"
              maxLength={120}
              placeholder="Ej. 2026-0042"
              value={invoiceNumber}
              onChange={(event) =>
                onInvoiceNumberChange(event.target.value)
              }
            />
          </div>
        </div>
        <div className="field">
          <label htmlFor="billing-admin-notes">Notas internas</label>
          <textarea
            disabled={invoiceLocked}
            id="billing-admin-notes"
            maxLength={5_000}
            value={adminNotes}
            onChange={(event) => onAdminNotesChange(event.target.value)}
          />
        </div>
        <button
          className="button button--primary"
          disabled={saving || invoiceLocked}
          onClick={onSave}
          type="button"
        >
          <ReceiptText size={17} />{' '}
          {invoiceLocked ? 'Factura reembolsada' : 'Guardar facturación'}
        </button>
      </div>
      )}

      <div
        className={
          purchase.admin_notification_status === 'failed'
            ? 'alert alert--error'
            : 'alert alert--info'
        }
      >
        <div>
          <strong>
            Aviso administrativo:{' '}
            {notificationLabel(purchase.admin_notification_status)}
          </strong>
          <p>
            {purchase.admin_notification_sent_at
              ? `Enviado ${new Date(purchase.admin_notification_sent_at).toLocaleString('es-ES')}.`
              : `${purchase.admin_notification_attempts} intento(s).`}
          </p>
          {purchase.admin_notification_error ? (
            <small>{purchase.admin_notification_error}</small>
          ) : null}
        </div>
        {purchase.admin_notification_status === 'failed' ? (
          <button
            className="button button--outline"
            disabled={saving}
            onClick={onRetryNotification}
            type="button"
          >
            <Send size={16} /> Reintentar aviso
          </button>
        ) : null}
      </div>
    </>
  )
}

function AutomatedInvoicePanel({
  invoice,
  saving,
  onRetry,
  onDownload,
}: {
  invoice: BillingPurchase['invoices'][number]
  saving: boolean
  onRetry: (jobType: string) => void
  onDownload: () => void
}) {
  const mnprogram = invoice.mnprogram_syncs[0]
  const job = (type: string) =>
    invoice.billing_jobs.find((candidate) => candidate.type === type)
  const available = Boolean(
    invoice.official_invoice_number && invoice.pdf_storage_path,
  )
  return (
    <section className="form-grid billing-detail__editor">
      <div className="panel__header">
        <div>
          <span className="eyebrow">Trazabilidad automática</span>
          <h3>
            {invoice.official_invoice_number ??
              invoice.internal_invoice_reference}
          </h3>
        </div>
        <span className="status status--orange">
          {automatedInvoiceLabel(invoice.status)}
        </span>
      </div>
      <dl className="admin-detail__facts billing-detail__facts">
        <div>
          <dt>Pago</dt>
          <dd>Pagado</dd>
        </div>
        <div>
          <dt>Factura</dt>
          <dd>{available ? 'Emitida' : 'Pendiente de MNprogram'}</dd>
        </div>
        <div>
          <dt>Email</dt>
          <dd>{invoice.email_sent_at ? 'Enviado' : job('invoice_email')?.status ?? 'Pendiente'}</dd>
        </div>
        <div>
          <dt>MNprogram</dt>
          <dd>{mnprogram?.status ?? job('mnprogram_sync')?.status ?? 'Pendiente'}</dd>
        </div>
        <div>
          <dt>Archivo local</dt>
          <dd>
            {job('local_archive')?.status ?? invoice.local_archive_status}
          </dd>
        </div>
      </dl>
      {invoice.refund_requires_credit_note ? (
        <div className="alert alert--error">
          Reembolso registrado: requiere factura rectificativa en MNprogram.
        </div>
      ) : null}
      {invoice.last_error || mnprogram?.last_error ? (
        <div className="alert alert--info">
          {invoice.last_error ?? mnprogram?.last_error}
        </div>
      ) : null}
      <div className="content-editor__actions">
        <button
          className="button button--outline"
          disabled={!available || saving}
          onClick={onDownload}
          type="button"
        >
          <Download size={16} /> Descargar
        </button>
        <button
          className="button button--outline"
          disabled={saving}
          onClick={() => onRetry('mnprogram_sync')}
          type="button"
        >
          <RefreshCw size={16} /> Reintentar MNprogram
        </button>
        <button
          className="button button--outline"
          disabled={saving}
          onClick={() => onRetry('invoice_issue')}
          type="button"
        >
          <RefreshCw size={16} /> Reintentar emisión
        </button>
        <button
          className="button button--outline"
          disabled={saving || !available}
          onClick={() => onRetry('invoice_email')}
          type="button"
        >
          <Send size={16} /> Reenviar factura
        </button>
        <button
          className="button button--outline"
          disabled={saving || !available}
          onClick={() => onRetry('local_archive')}
          type="button"
        >
          <RefreshCw size={16} /> Reintentar archivo
        </button>
      </div>
    </section>
  )
}

async function getAccessToken(): Promise<string | null> {
  const { data } =
    (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
  return data?.session?.access_token ?? null
}

function invoiceLabel(status: string): string {
  const labels: Record<string, string> = {
    pending_invoice: 'Pendiente',
    invoiced: 'Emitida',
    invoice_sent: 'Enviada',
    refunded: 'Reembolsada',
  }
  return labels[status] ?? status
}

function automatedInvoiceLabel(status: string): string {
  const labels: Record<string, string> = {
    pending: 'Pendiente',
    issuing: 'En emisión',
    issued: 'Emitida',
    email_pending: 'Email pendiente',
    emailed: 'Enviada',
    archive_pending: 'Archivo pendiente',
    archived: 'Archivada',
    error: 'Con incidencia',
    cancelled: 'Cancelada',
  }
  return labels[status] ?? status
}

function notificationLabel(status: string): string {
  const labels: Record<string, string> = {
    pending: 'pendiente',
    sending: 'en proceso',
    sent: 'enviado',
    failed: 'fallido',
    not_required: 'no requerido',
  }
  return labels[status] ?? status
}

function modalityLabel(modality?: string): string {
  const labels: Record<string, string> = {
    online: 'Online',
    in_person: 'Presencial',
    hybrid: 'Híbrida',
  }
  return modality ? labels[modality] ?? modality : '—'
}
