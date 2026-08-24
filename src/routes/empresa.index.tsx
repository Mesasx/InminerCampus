import { createFileRoute, Link } from '@tanstack/react-router'
import { BookOpen, KeyRound, ReceiptText, UsersRound } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/empresa/')({
  component: CompanyPage,
})

type CompanyState = {
  id: string
  name: string
  purchases: number
  seats: number
  availableCodes: number
  enrollments: number
  completed: number
  batches: Array<{
    id: string
    orderNumber: string
    courseTitle: string
    paidAt: string
    quantity: number
    discountBasisPoints: number
    totalAmountCents: number
    currency: string
    assigned: number
    redeemed: number
  }>
}

function CompanyPage() {
  return (
    <ProtectedGate>
      {(user) => <CompanyDashboard user={user} />}
    </ProtectedGate>
  )
}

function CompanyDashboard({ user }: { user: SessionUser }) {
  const [company, setCompany] = useState<CompanyState | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    void supabase
      .from('organization_members')
      .select('organization_id, organizations!inner(legal_name)')
      .eq('user_id', user.id)
      .eq('role', 'responsable_empresa')
      .eq('status', 'active')
      .limit(1)
      .maybeSingle()
      .then(async ({ data: membership }) => {
        if (!membership) {
          setLoading(false)
          return
        }
        const row = membership as unknown as {
          organization_id: string
          organizations: { legal_name: string }
        }
        const count = (table: string, column = 'organization_id') =>
          supabase
            .from(table)
            .select('id', { count: 'exact', head: true })
            .eq(column, row.organization_id)

        const [purchases, codes, enrollments, items, batches] = await Promise.all([
          count('purchases'),
          supabase
            .from('access_codes')
            .select('id', { count: 'exact', head: true })
            .eq('organization_id', row.organization_id)
            .in('status', ['available', 'reserved']),
          supabase
            .from('enrollments')
            .select('status')
            .eq('organization_id', row.organization_id),
          supabase
            .from('purchase_items')
            .select(
              'quantity, purchases!inner(organization_id, status)',
            )
            .eq('purchases.organization_id', row.organization_id)
            .eq('purchases.status', 'paid'),
          supabase
            .from('purchases')
            .select(
              'id, order_number, paid_at, total_amount_cents, currency, discount_basis_points, purchase_items(course_title_snapshot, quantity), company_license_recipients(id, redeemed_at)',
            )
            .eq('organization_id', row.organization_id)
            .eq('status', 'paid')
            .order('paid_at', { ascending: false }),
        ])

        setCompany({
          id: row.organization_id,
          name: row.organizations.legal_name,
          purchases: purchases.count ?? 0,
          seats: (items.data ?? []).reduce(
            (sum, item) => sum + Number(item.quantity),
            0,
          ),
          availableCodes: codes.count ?? 0,
          enrollments: (enrollments.data ?? []).filter(
            ({ status }) => status !== 'completed',
          ).length,
          completed: (enrollments.data ?? []).filter(
            ({ status }) => status === 'completed',
          ).length,
          batches: (batches.data ?? []).map((purchase) => {
            const purchaseItems = purchase.purchase_items as unknown as Array<{
              course_title_snapshot: string
              quantity: number
            }>
            const recipients = purchase.company_license_recipients as unknown as Array<{
              id: string
              redeemed_at: string | null
            }>
            return {
              id: purchase.id,
              orderNumber: purchase.order_number,
              courseTitle: purchaseItems[0]?.course_title_snapshot ?? 'Curso',
              paidAt: purchase.paid_at,
              quantity: purchaseItems.reduce(
                (total, item) => total + Number(item.quantity),
                0,
              ),
              discountBasisPoints: purchase.discount_basis_points,
              totalAmountCents: purchase.total_amount_cents,
              currency: purchase.currency,
              assigned: recipients.length,
              redeemed: recipients.filter(({ redeemed_at }) => redeemed_at).length,
            }
          }),
        })
        setLoading(false)
      })
  }, [user.id])

  return (
    <AppShell user={user} mode="company" title="Área de empresa">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Formación corporativa</span>
          <h1>{company?.name || 'Tu organización'}.</h1>
          <p>Gestiona plazas y accesos desde un único espacio.</p>
        </div>
      </div>
      {loading ? (
        <section className="panel">
          <p className="muted">Cargando organización…</p>
        </section>
      ) : company ? (
        <>
          <section className="stats-grid">
            <article className="stat-card">
              <span className="stat-card__label">Plazas compradas</span>
              <span className="stat-card__value">{company.seats}</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">Licencias sin canjear</span>
              <span className="stat-card__value">{company.availableCodes}</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">En formación</span>
              <span className="stat-card__value">{company.enrollments}</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">Completadas</span>
              <span className="stat-card__value">{company.completed}</span>
            </article>
          </section>
          <section className="feature-grid">
            <Link
              className="feature-card"
              to="/empresa/$companySection"
              params={{ companySection: 'formacion' }}
            >
              <span className="feature-card__icon">
                <BookOpen size={22} />
              </span>
              <h2 style={{ fontSize: '1.15rem' }}>Formación contratada</h2>
              <p>Consulta cursos, pedidos y número de plazas.</p>
            </Link>
            <Link className="feature-card" to="/empresa/codigos">
              <span className="feature-card__icon">
                <KeyRound size={22} />
              </span>
              <h2 style={{ fontSize: '1.15rem' }}>Licencias</h2>
              <p>Consulta personas, códigos, canjes y entrega de emails.</p>
            </Link>
            <Link
              className="feature-card"
              to="/empresa/$companySection"
              params={{ companySection: 'facturacion' }}
            >
              <span className="feature-card__icon">
                <ReceiptText size={22} />
              </span>
              <h2 style={{ fontSize: '1.15rem' }}>Facturación</h2>
              <p>Revisa pagos y enlaces de factura disponibles.</p>
            </Link>
          </section>
          <section className="panel company-purchases">
            <div className="panel__header">
              <div>
                <span className="eyebrow">Historial empresarial</span>
                <h2>Mis compras</h2>
              </div>
              <Link className="text-link" to="/empresa/codigos">
                Ver licencias
              </Link>
            </div>
            {company.batches.length ? (
              <div className="company-purchase-grid">
                {company.batches.map((batch) => (
                  <article className="company-purchase-card" key={batch.id}>
                    <div>
                      <small>{new Intl.DateTimeFormat('es-ES', { dateStyle: 'medium' }).format(new Date(batch.paidAt))}</small>
                      <h3>{batch.courseTitle}</h3>
                      <p>Pedido {batch.orderNumber}</p>
                    </div>
                    <dl>
                      <div><dt>Plazas</dt><dd>{batch.quantity}</dd></div>
                      <div><dt>Descuento</dt><dd>{batch.discountBasisPoints / 100} %</dd></div>
                      <div><dt>Asignadas</dt><dd>{batch.assigned}/{batch.quantity}</dd></div>
                      <div><dt>Canjeadas</dt><dd>{batch.redeemed}/{batch.quantity}</dd></div>
                    </dl>
                    <strong>{new Intl.NumberFormat('es-ES', { style: 'currency', currency: batch.currency }).format(batch.totalAmountCents / 100)}</strong>
                  </article>
                ))}
              </div>
            ) : (
              <p className="muted">Todavía no hay compras empresariales pagadas.</p>
            )}
          </section>
        </>
      ) : (
        <section className="empty-state">
          <div>
            <UsersRound className="empty-state__icon" />
            <h2>No hay una organización asociada</h2>
            <p>
              Puedes comprar para una empresa desde cualquier ficha de curso.
            </p>
          </div>
        </section>
      )}
    </AppShell>
  )
}
