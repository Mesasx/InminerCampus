import { createFileRoute } from '@tanstack/react-router'
import { Download, ReceiptText } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { formatCents } from '../lib/billing'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

type InvoiceRow = {
  id: string
  invoice_number: string
  internal_invoice_reference: string
  official_invoice_number: string | null
  status: string
  issued_at: string | null
  total_cents: number
  currency: string
  pdf_storage_path: string | null
  refund_requires_credit_note: boolean
  purchases: {
    order_number: string
    paid_at: string
    purchase_items: Array<{
      course_title_snapshot: string
      quantity: number
    }>
  }
}

export const Route = createFileRoute('/facturas')({
  component: InvoicesPage,
})

function InvoicesPage() {
  return (
    <ProtectedGate>
      {(user) => <Invoices user={user} />}
    </ProtectedGate>
  )
}

function Invoices({ user }: { user: SessionUser }) {
  const [invoices, setInvoices] = useState<InvoiceRow[]>([])
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState('')

  useEffect(() => {
    void loadInvoices()
  }, [])

  async function loadInvoices() {
    const supabase = getSupabaseBrowserClient()
    const { data } = (await supabase?.auth.getSession()) ?? { data: null }
    const token = data?.session?.access_token
    if (!token) {
      setMessage('Tu sesión ha caducado.')
      setLoading(false)
      return
    }
    try {
      const response = await fetch('/api/invoices', {
        headers: { Authorization: `Bearer ${token}` },
      })
      const payload = (await response.json()) as {
        invoices?: InvoiceRow[]
        error?: string
      }
      if (!response.ok) throw new Error(payload.error)
      setInvoices(payload.invoices ?? [])
    } catch {
      setMessage('No se han podido cargar tus facturas.')
    } finally {
      setLoading(false)
    }
  }

  async function download(invoice: InvoiceRow) {
    const supabase = getSupabaseBrowserClient()
    const { data } = (await supabase?.auth.getSession()) ?? { data: null }
    const token = data?.session?.access_token
    if (!token) return
    try {
      const response = await fetch(
        `/api/invoices/${encodeURIComponent(invoice.id)}/download`,
        { headers: { Authorization: `Bearer ${token}` } },
      )
      const payload = (await response.json()) as { url?: string; error?: string }
      if (response.ok && payload.url) window.location.href = payload.url
      else setMessage(payload.error ?? 'No se ha podido preparar la descarga.')
    } catch {
      setMessage('No se ha podido conectar para descargar la factura.')
    }
  }

  return (
    <AppShell user={user} title="Facturas">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Mi cuenta</span>
          <h1>Facturas.</h1>
          <p>Consulta el estado y descarga los documentos ya emitidos.</p>
        </div>
      </div>

      {message ? <div className="alert alert--info">{message}</div> : null}
      {loading ? (
        <section className="empty-state"><p>Cargando facturas…</p></section>
      ) : invoices.length ? (
        <section className="panel">
          <div className="table-scroll">
            <table>
              <thead>
                <tr>
                  <th>Número</th>
                  <th>Fecha</th>
                  <th>Curso</th>
                  <th>Total</th>
                  <th>Estado</th>
                  <th>Documento</th>
                </tr>
              </thead>
              <tbody>
                {invoices.map((invoice) => {
                  const item = invoice.purchases.purchase_items[0]
                  const available = Boolean(
                    invoice.official_invoice_number && invoice.pdf_storage_path,
                  )
                  return (
                    <tr key={invoice.id}>
                      <td>
                        {invoice.official_invoice_number ??
                          invoice.internal_invoice_reference}
                      </td>
                      <td>{formatDate(invoice.issued_at ?? invoice.purchases.paid_at)}</td>
                      <td>{item?.course_title_snapshot ?? '—'}</td>
                      <td>{formatCents(invoice.total_cents, invoice.currency)}</td>
                      <td>
                        {invoice.refund_requires_credit_note
                          ? 'Rectificativa pendiente'
                          : invoiceStatusLabel(invoice.status)}
                      </td>
                      <td>
                        <button
                          className="button button--outline"
                          disabled={!available}
                          onClick={() => void download(invoice)}
                          type="button"
                        >
                          <Download size={15} /> Descargar
                        </button>
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        </section>
      ) : (
        <section className="empty-state">
          <ReceiptText size={28} />
          <div>
            <h2>Aún no hay facturas</h2>
            <p>Las facturas de tus compras aparecerán aquí.</p>
          </div>
        </section>
      )}
    </AppShell>
  )
}

function invoiceStatusLabel(status: string): string {
  return (
    {
      pending: 'Pendiente de emisión',
      issuing: 'En emisión',
      issued: 'Emitida',
      email_pending: 'Envío pendiente',
      emailed: 'Enviada',
      archive_pending: 'Archivo pendiente',
      archived: 'Archivada',
      error: 'Revisión necesaria',
      cancelled: 'Cancelada',
    }[status] ?? status
  )
}

function formatDate(value: string | null): string {
  return value
    ? new Intl.DateTimeFormat('es-ES', { dateStyle: 'medium' }).format(
        new Date(value),
      )
    : '—'
}
