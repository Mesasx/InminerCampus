import { createFileRoute, Link } from '@tanstack/react-router'
import { Building2, CreditCard } from 'lucide-react'
import { useEffect, useMemo, useState, type FormEvent } from 'react'
import { BillingDetailsForm } from '../components/BillingDetailsForm'
import { ProtectedGate } from '../components/ProtectedGate'
import { PublicLayout } from '../components/PublicLayout'
import {
  billingDetailsSchema,
  calculateOrderAmounts,
  decimalToCents,
  emptyBillingForm,
  formatCents,
  taxRateToBasisPoints,
} from '../lib/billing'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/comprar-empresa/$courseSlug')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { version?: string } => ({
    version:
      typeof search.version === 'string' && search.version.trim()
        ? search.version
        : undefined,
  }),
  component: CompanyCheckoutPage,
})

type CompanyCourse = {
  versionId: string
  title: string
  duration: number
  price: number | string
  currency: string
  taxRate: number | string
}

type Organization = {
  id: string
  legal_name: string
  tax_id: string
  billing_email: string | null
  billing_address: Record<string, unknown>
}

function CompanyCheckoutPage() {
  const { courseSlug } = Route.useParams()
  const { version } = Route.useSearch()
  return (
    <ProtectedGate roles={['responsable_empresa', 'superadministrador']}>
      {(user) => (
        <CompanyCheckout
          user={user}
          courseSlug={courseSlug}
          versionId={version}
        />
      )}
    </ProtectedGate>
  )
}

function CompanyCheckout({
  user,
  courseSlug,
  versionId,
}: {
  user: SessionUser
  courseSlug: string
  versionId?: string
}) {
  const [course, setCourse] = useState<CompanyCourse | null>(null)
  const [organizations, setOrganizations] = useState<Organization[]>([])
  const [organizationId, setOrganizationId] = useState('')
  const [quantity, setQuantity] = useState(5)
  const [error, setError] = useState('')
  const [paying, setPaying] = useState(false)
  const [checkoutRequestId] = useState(() => crypto.randomUUID())
  const [billing, setBilling] = useState(() =>
    emptyBillingForm(user.email, 'business'),
  )

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    let versionQuery = supabase
      .from('course_versions')
      .select(
        'id, duration_hours, price_net, currency, tax_rate, courses!inner(title, slug, status)',
      )
      .eq('status', 'published')
      .eq('courses.slug', courseSlug)
      .eq('courses.status', 'published')
    if (versionId) {
      versionQuery = versionQuery.eq('id', versionId)
    }

    const organizationQuery = user.roles.includes('superadministrador')
      ? supabase
          .from('organizations')
          .select('id, legal_name, tax_id, billing_email, billing_address')
          .eq('status', 'active')
      : supabase
          .from('organization_members')
          .select(
            'organizations!inner(id, legal_name, tax_id, billing_email, billing_address)',
          )
          .eq('user_id', user.id)
          .eq('role', 'responsable_empresa')
          .eq('status', 'active')

    void Promise.all([
      versionQuery
        .order('version_number', { ascending: false })
        .limit(1)
        .maybeSingle(),
      organizationQuery,
    ]).then(([{ data: version }, { data: organizationRows }]) => {
      if (version?.price_net !== null && version?.price_net !== undefined) {
        const row = version as unknown as {
          id: string
          duration_hours: number
          price_net: number | string
          currency: string
          tax_rate: number | string
          courses: { title: string }
        }
        setCourse({
          versionId: row.id,
          title: row.courses.title,
          duration: row.duration_hours,
          price: row.price_net,
          currency: row.currency,
          taxRate: row.tax_rate,
        })
      }

      const orgs = (organizationRows ?? []).map((row) =>
        user.roles.includes('superadministrador')
          ? (row as unknown as Organization)
          : (row as unknown as { organizations: Organization }).organizations,
      )
      const firstOrganization = orgs[0]
      setOrganizations(orgs)
      setOrganizationId(firstOrganization?.id ?? '')
      if (firstOrganization) {
        setBilling((current) =>
          billingForOrganization(firstOrganization, current),
        )
      }
    })
  }, [courseSlug, user.id, user.roles, versionId])

  const amounts = useMemo(() => {
    if (!course) return null
    return calculateOrderAmounts(
      decimalToCents(course.price),
      quantity,
      taxRateToBasisPoints(course.taxRate),
    )
  }, [course, quantity])

  function changeOrganization(nextOrganizationId: string) {
    setOrganizationId(nextOrganizationId)
    const organization = organizations.find(
      (candidate) => candidate.id === nextOrganizationId,
    )
    if (organization) {
      setBilling((current) => billingForOrganization(organization, current))
    }
  }

  async function beginCheckout(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!course || !organizationId || !amounts) return
    setError('')
    const billingResult = billingDetailsSchema.safeParse(billing)
    if (!billingResult.success) {
      setError(
        billingResult.error.issues[0]?.message ??
          'Revisa los datos fiscales antes de continuar.',
      )
      return
    }
    setPaying(true)
    const { data } =
      (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
    const token = data?.session?.access_token
    if (!token) {
      setError('Tu sesión ha caducado.')
      setPaying(false)
      return
    }

    try {
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
          checkoutRequestId,
          billing: billingResult.data,
        }),
      })
      const payload = (await response.json()) as { url?: string; error?: string }
      if (!response.ok || !payload.url) {
        setError(payload.error ?? 'No se ha podido iniciar el pago.')
        setPaying(false)
        return
      }
      window.location.assign(payload.url)
    } catch {
      setError('No se ha podido conectar con el pago seguro.')
      setPaying(false)
    }
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
            <form className="panel" onSubmit={beginCheckout}>
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
                  <p className="muted">{course.duration} horas por plaza</p>
                </div>
                <strong style={{ fontSize: '1.6rem' }}>
                  {amounts
                    ? formatCents(amounts.totalAmountCents, course.currency)
                    : '—'}
                </strong>
              </div>
              <div className="form-grid">
                <div className="field">
                  <label htmlFor="company-org">Organización</label>
                  <select
                    id="company-org"
                    value={organizationId}
                    onChange={(event) =>
                      changeOrganization(event.target.value)
                    }
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
              </div>
              {amounts ? (
                <dl className="order-totals">
                  <div>
                    <dt>
                      Base imponible ({quantity} ×{' '}
                      {formatCents(amounts.unitNetCents, course.currency)})
                    </dt>
                    <dd>
                      {formatCents(amounts.subtotalNetCents, course.currency)}
                    </dd>
                  </div>
                  <div>
                    <dt>IVA ({course.taxRate} %)</dt>
                    <dd>
                      {formatCents(amounts.taxAmountCents, course.currency)}
                    </dd>
                  </div>
                  <div className="order-totals__total">
                    <dt>Total</dt>
                    <dd>
                      {formatCents(amounts.totalAmountCents, course.currency)}
                    </dd>
                  </div>
                </dl>
              ) : null}
              <BillingDetailsForm
                disabled={paying}
                lockBuyerType
                onChange={setBilling}
                value={billing}
              />
              <button
                className="button button--primary button--wide"
                disabled={paying}
                type="submit"
              >
                <CreditCard size={18} />
                {paying ? 'Abriendo Stripe…' : 'Continuar con Stripe'}
              </button>
            </form>
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

function billingForOrganization(
  organization: Organization,
  current: ReturnType<typeof emptyBillingForm>,
) {
  const address = organization.billing_address ?? {}
  const text = (...keys: string[]) => {
    for (const key of keys) {
      const value = address[key]
      if (typeof value === 'string' && value.trim()) return value.trim()
    }
    return ''
  }
  const rawCountry =
    text('country_code', 'countryCode', 'country') || current.countryCode
  const countryAliases: Record<string, string> = {
    ALEMANIA: 'DE',
    DEUTSCHLAND: 'DE',
    ESPAÑA: 'ES',
    FRANCE: 'FR',
    FRANCIA: 'FR',
    ITALIA: 'IT',
    PORTUGAL: 'PT',
    SPAIN: 'ES',
  }
  const normalizedCountry =
    rawCountry.length === 2
      ? rawCountry.toUpperCase()
      : (countryAliases[rawCountry.trim().toUpperCase()] ?? 'ES')

  return {
    ...current,
    buyerType: 'business' as const,
    fiscalName: organization.legal_name,
    taxId: organization.tax_id,
    addressLine1:
      text('line1', 'address_line1', 'street', 'address') ||
      current.addressLine1,
    postalCode:
      text('postal_code', 'postalCode', 'zip') || current.postalCode,
    city: text('city', 'locality', 'town') || current.city,
    province:
      text('province', 'state', 'region') || current.province,
    countryCode: normalizedCountry,
    billingEmail: organization.billing_email || current.billingEmail,
  }
}
