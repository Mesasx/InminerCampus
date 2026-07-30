import { createFileRoute, Link } from '@tanstack/react-router'
import { CreditCard, LockKeyhole } from 'lucide-react'
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

export const Route = createFileRoute('/comprar/$courseSlug')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { version?: string } => ({
    version:
      typeof search.version === 'string' && search.version.trim()
        ? search.version
        : undefined,
  }),
  component: CheckoutPage,
})

type CheckoutCourse = {
  versionId: string
  title: string
  duration: number
  price: number | string
  currency: string
  taxRate: number | string
}

function CheckoutPage() {
  const { courseSlug } = Route.useParams()
  const { version } = Route.useSearch()
  return (
    <ProtectedGate>
      {(user) => (
        <Checkout
          user={user}
          courseSlug={courseSlug}
          versionId={version}
        />
      )}
    </ProtectedGate>
  )
}

function Checkout({
  user,
  courseSlug,
  versionId,
}: {
  user: SessionUser
  courseSlug: string
  versionId?: string
}) {
  const [course, setCourse] = useState<CheckoutCourse | null>(null)
  const [loading, setLoading] = useState(true)
  const [paying, setPaying] = useState(false)
  const [error, setError] = useState('')
  const [checkoutRequestId] = useState(() => crypto.randomUUID())
  const [billing, setBilling] = useState(() => emptyBillingForm(user.email))

  const amounts = useMemo(() => {
    if (!course) return null
    return calculateOrderAmounts(
      decimalToCents(course.price),
      1,
      taxRateToBasisPoints(course.taxRate),
    )
  }, [course])

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setLoading(false)
      return
    }
    let query = supabase
      .from('course_versions')
      .select(
        'id, duration_hours, price_net, currency, tax_rate, courses!inner(title, slug)',
      )
      .eq('status', 'published')
      .eq('courses.slug', courseSlug)
      .eq('courses.status', 'published')
    if (versionId) {
      query = query.eq('id', versionId)
    }
    void Promise.all([
      query
        .order('version_number', { ascending: false })
        .limit(1)
        .maybeSingle(),
      supabase
        .from('profiles')
        .select('first_name, last_name, phone')
        .eq('id', user.id)
        .maybeSingle(),
    ]).then(([{ data }, { data: profile }]) => {
        if (data?.price_net !== null && data?.price_net !== undefined) {
          const row = data as unknown as {
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
        if (profile) {
          const fullName = [profile.first_name, profile.last_name]
            .filter(Boolean)
            .join(' ')
          setBilling((current) => ({
            ...current,
            fiscalName: current.fiscalName || fullName,
            phone: current.phone || profile.phone || '',
          }))
        }
        setLoading(false)
      })
  }, [courseSlug, user.id, versionId])

  async function beginCheckout(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!course || !amounts) return
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
    const supabase = getSupabaseBrowserClient()
    const { data } = (await supabase?.auth.getSession()) ?? { data: null }
    const accessToken = data?.session?.access_token
    if (!accessToken) {
      setError('Tu sesión ha caducado. Vuelve a iniciar sesión.')
      setPaying(false)
      return
    }

    try {
      const response = await fetch('/api/checkout', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          courseVersionId: course.versionId,
          kind: 'individual',
          quantity: 1,
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
          <span className="eyebrow">Revisar pedido</span>
          <h1 style={{ fontSize: 'clamp(2rem,4vw,3.4rem)' }}>
            Compra individual
          </h1>
          {loading ? (
            <div className="panel">
              <p className="muted">Cargando el pedido…</p>
            </div>
          ) : course ? (
            <form className="panel" onSubmit={beginCheckout}>
              {error ? (
                <div className="alert alert--error" style={{ marginBottom: 20 }}>
                  {error}
                </div>
              ) : null}
              <div className="panel__header">
                <div>
                  <span className="status status--orange">
                    {course.duration} horas
                  </span>
                  <h2 style={{ marginTop: 14 }}>{course.title}</h2>
                  <p className="muted">Matrícula para {user.email}</p>
                </div>
                <strong style={{ fontSize: '1.6rem' }}>
                  {amounts
                    ? formatCents(amounts.totalAmountCents, course.currency)
                    : '—'}
                </strong>
              </div>
              {amounts ? (
                <dl className="order-totals">
                  <div>
                    <dt>Base imponible</dt>
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
              <div className="alert alert--info" style={{ marginBottom: 22 }}>
                El importe se ha calculado con el precio y el IVA publicados
                para esta versión concreta. Stripe mostrará el mismo total
                antes de confirmar.
              </div>
              <BillingDetailsForm
                disabled={paying}
                onChange={setBilling}
                value={billing}
              />
              <button
                className="button button--primary button--wide"
                disabled={paying}
                type="submit"
              >
                <CreditCard size={18} />
                {paying ? 'Abriendo pago seguro…' : 'Continuar con Stripe'}
              </button>
              <p
                className="muted"
                style={{ textAlign: 'center', fontSize: '.82rem', marginTop: 14 }}
              >
                <LockKeyhole size={13} style={{ display: 'inline' }} /> El acceso
                se activa únicamente tras la confirmación segura del pago.
              </p>
            </form>
          ) : (
            <div className="empty-state">
              <div>
                <h2>Este curso no está disponible para compra</h2>
                <Link className="button button--outline" to="/catalogo">
                  Volver al catálogo
                </Link>
              </div>
            </div>
          )}
        </div>
      </section>
    </PublicLayout>
  )
}
