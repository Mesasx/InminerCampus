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
}

function CompanyPage() {
  return (
    <ProtectedGate roles={['responsable_empresa', 'superadministrador']}>
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
            .select('*', { count: 'exact', head: true })
            .eq(column, row.organization_id)

        const [purchases, codes, enrollments, items] = await Promise.all([
          count('purchases'),
          supabase
            .from('access_codes')
            .select('*', { count: 'exact', head: true })
            .eq('organization_id', row.organization_id)
            .eq('status', 'available'),
          count('enrollments'),
          supabase
            .from('purchase_items')
            .select(
              'quantity, purchases!inner(organization_id, status)',
            )
            .eq('purchases.organization_id', row.organization_id)
            .eq('purchases.status', 'paid'),
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
          enrollments: enrollments.count ?? 0,
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
              <span className="stat-card__label">Pedidos</span>
              <span className="stat-card__value">{company.purchases}</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">Plazas compradas</span>
              <span className="stat-card__value">{company.seats}</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">Códigos disponibles</span>
              <span className="stat-card__value">{company.availableCodes}</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">Matrículas</span>
              <span className="stat-card__value">{company.enrollments}</span>
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
              <h2 style={{ fontSize: '1.15rem' }}>Códigos de acceso</h2>
              <p>Distribuye códigos únicos y consulta su estado.</p>
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
        </>
      ) : (
        <section className="empty-state">
          <div>
            <UsersRound className="empty-state__icon" />
            <h2>No hay una organización asociada</h2>
            <p>
              Un administrador debe vincular tu cuenta como responsable de
              empresa.
            </p>
          </div>
        </section>
      )}
    </AppShell>
  )
}
