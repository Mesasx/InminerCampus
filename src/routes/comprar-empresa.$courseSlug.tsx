import { createFileRoute, Link } from '@tanstack/react-router'
import { Building2, CreditCard } from 'lucide-react'
import { useEffect, useMemo, useState } from 'react'
import { ProtectedGate } from '../components/ProtectedGate'
import { PublicLayout } from '../components/PublicLayout'
import { formatCurrency } from '../lib/format'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/comprar-empresa/$courseSlug')({
  component: CompanyCheckoutPage,
})

type CompanyCourse = {
  versionId: string
  title: string
  price: number
  currency: string
}

type Organization = {
  id: string
  legal_name: string
}

function CompanyCheckoutPage() {
  const { courseSlug } = Route.useParams()
  return (
    <ProtectedGate roles={['responsable_empresa', 'superadministrador']}>
      {(user) => <CompanyCheckout user={user} courseSlug={courseSlug} />}
    </ProtectedGate>
  )
}

function CompanyCheckout({
  user,
  courseSlug,
}: {
  user: SessionUser
  courseSlug: string
}) {
  const [course, setCourse] = useState<CompanyCourse | null>(null)
  const [organizations, setOrganizations] = useState<Organization[]>([])
  const [organizationId, setOrganizationId] = useState('')
  const [quantity, setQuantity] = useState(5)
  const [error, setError] = useState('')
  const [paying, setPaying] = useState(false)

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void Promise.all([
      supabase
        .from('course_versions')
        .select(
          'id, price_net, currency, courses!inner(title, slug, status)',
        )
        .eq('status', 'published')
        .eq('courses.slug', courseSlug)
        .eq('courses.status', 'published')
        .order('version_number', { ascending: false })
        .limit(1)
        .maybeSingle(),
      supabase
        .from('organization_members')
        .select('organizations!inner(id, legal_name)')
        .eq('user_id', user.id)
        .eq('role', 'responsable_empresa')
        .eq('status', 'active'),
    ]).then(([{ data: version }, { data: memberships }]) => {
      if (version?.price_net !== null && version?.price_net !== undefined) {
        const row = version as unknown as {
          id: string
          price_net: number | string
          currency: string
          courses: { title: string }
        }
        setCourse({
          versionId: row.id,
          title: row.courses.title,
          price: Number(row.price_net),
          currency: row.currency,
        })
      }
      const orgs = (memberships ?? []).map(
        (membership) =>
          (membership as unknown as { organizations: Organization }).organizations,
      )
      setOrganizations(orgs)
      setOrganizationId(orgs[0]?.id ?? '')
    })
  }, [courseSlug, user.id])

  const total = useMemo(
    () => (course ? course.price * quantity : 0),
    [course, quantity],
  )

  async function beginCheckout() {
    if (!course || !organizationId) return
    setPaying(true)
    setError('')
    const { data } =
      (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
    const token = data?.session?.access_token
    if (!token) {
      setError('Tu sesión ha caducado.')
      setPaying(false)
      return
    }
    const response = await fetch('/api/checkout', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        courseVersionId: course.versionId,
        kind: 'company',
        quantity,
        organizationId,
      }),
    })
    const payload = (await response.json()) as { url?: string; error?: string }
    if (!response.ok || !payload.url) {
      setError(payload.error ?? 'No se ha podido iniciar el pago.')
      setPaying(false)
      return
    }
    window.location.assign(payload.url)
  }

  return (
    <PublicLayout>
      <section className="section">
        <div className="container" style={{ maxWidth: 850 }}>
          <span className="eyebrow">Compra empresarial</span>
          <h1 style={{ fontSize: 'clamp(2rem,4vw,3.4rem)' }}>
            Plazas para tu equipo.
          </h1>
          {course && organizations.length ? (
            <section className="panel">
              {error ? (
                <div className="alert alert--error" style={{ marginBottom: 20 }}>
                  {error}
                </div>
              ) : null}
              <div className="panel__header">
                <div>
                  <span className="status status--orange">
                    <Building2 size={14} /> Pedido de empresa
                  </span>
                  <h2 style={{ marginTop: 14 }}>{course.title}</h2>
                </div>
                <strong style={{ fontSize: '1.6rem' }}>
                  {formatCurrency(total, course.currency)}
                </strong>
              </div>
              <div className="form-grid">
                <div className="field">
                  <label htmlFor="company-org">Organización</label>
                  <select
                    id="company-org"
                    value={organizationId}
                    onChange={(event) => setOrganizationId(event.target.value)}
                  >
                    {organizations.map((organization) => (
                      <option key={organization.id} value={organization.id}>
                        {organization.legal_name}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="field">
                  <label htmlFor="company-seats">Número de plazas</label>
                  <input
                    id="company-seats"
                    type="number"
                    min={1}
                    max={500}
                    value={quantity}
                    onChange={(event) =>
                      setQuantity(
                        Math.max(1, Math.min(500, Number(event.target.value))),
                      )
                    }
                  />
                </div>
                <div className="alert alert--info">
                  Precio neto. Stripe mostrará los impuestos y el total definitivo
                  antes de pagar.
                </div>
                <button
                  className="button button--primary button--wide"
                  disabled={paying}
                  onClick={beginCheckout}
                  type="button"
                >
                  <CreditCard size={18} />
                  {paying ? 'Abriendo Stripe…' : 'Continuar con Stripe'}
                </button>
              </div>
            </section>
          ) : (
            <div className="empty-state">
              <div>
                <h2>No hay una organización disponible</h2>
                <p>
                  Solicita que un administrador asocie tu cuenta como responsable
                  de empresa o pide una propuesta.
                </p>
                <Link className="button button--outline" to="/contacto">
                  Contactar
                </Link>
              </div>
            </div>
          )}
        </div>
      </section>
    </PublicLayout>
  )
}
