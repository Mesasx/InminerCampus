import { createFileRoute } from '@tanstack/react-router'
import { ReceiptText } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { formatCents } from '../lib/billing'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

type InvoiceRow = {
  id: string
  order_number: string
  paid_at: string
  invoice_status: string
  invoice_number: string | null
  invoiced_at: string | null
  invoice_sent_at: string | null
  total_amount_cents: number
  currency: string
  invoice_email: string
  purchase_items: Array<{
    course_title_snapshot: string
    quantity: number
  }>
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

  return (
    <AppShell user={user} title="Facturas">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Mi cuenta</span>
          <h1>Facturas.</h1>
          <p>
            Administración prepara las facturas en MNprogram y las envía por
            correo electrónico.
          </p>
        </div>
      </div>

      {message ? <div className="alert alert--info">{message}</div> : null}
      {loading ? (
        <section className="empty-state">
          <p>Cargando facturas…</p>
        </section>
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
                  <th>Entrega</th>
                </tr>
              </thead>
              <tbody>
                {invoices.map((invoice) => {
                  const item = invoice.purchase_items[0]
                  return (
                    <tr key={invoice.id}>
                      <td>{invoice.invoice_number ?? invoice.order_number}</td>
                      <td>{formatDate(invoice.invoiced_at ?? invoice.paid_at)}</td>
                      <td>{item?.course_title_snapshot ?? '—'}</td>
                      <td>
                        {formatCents(
                          invoice.total_amount_cents,
                          invoice.currency,
                        )}
                      </td>
                      <td>{invoiceStatusLabel(invoice.invoice_status)}</td>
                      <td>
                        {invoice.invoice_sent_at
                          ? `Enviada a ${invoice.invoice_email}`
                          : `Se enviará a ${invoice.invoice_email}`}
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
            <h2>Aún no hay compras facturables</h2>
            <p>Los pagos confirmados aparecerán aquí.</p>
          </div>
        </section>
      )}
    </AppShell>
  )
}

function invoiceStatusLabel(status: string): string {
  return (
    {
      pending_invoice: 'Pendiente de emisión',
      invoiced: 'Emitida en MNprogram',
      invoice_sent: 'Enviada por email',
      refunded: 'Reembolsada',
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
