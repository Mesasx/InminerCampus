import { createFileRoute, Link } from '@tanstack/react-router'
import { CreditCard, LockKeyhole } from 'lucide-react'
import { useEffect, useState } from 'react'
import { ProtectedGate } from '../components/ProtectedGate'
import { PublicLayout } from '../components/PublicLayout'
import { formatCurrency } from '../lib/format'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/comprar/$courseSlug')({
  component: CheckoutPage,
})

type CheckoutCourse = {
  versionId: string
  title: string
  duration: number
  price: number
  currency: string
  taxRate: number
}

function CheckoutPage() {
  const { courseSlug } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => <Checkout user={user} courseSlug={courseSlug} />}
    </ProtectedGate>
  )
}

function Checkout({
  user,
  courseSlug,
}: {
  user: SessionUser
  courseSlug: string
}) {
  const [course, setCourse] = useState<CheckoutCourse | null>(null)
  const [loading, setLoading] = useState(true)
  const [paying, setPaying] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void supabase
      .from('course_versions')
      .select(
        'id, duration_hours, price_net, currency, tax_rate, courses!inner(title, slug)',
      )
      .eq('status', 'published')
      .eq('courses.slug', courseSlug)
      .eq('courses.status', 'published')
      .order('version_number', { ascending: false })
      .limit(1)
      .maybeSingle()
      .then(({ data }) => {
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
            price: Number(row.price_net),
            currency: row.currency,
            taxRate: Number(row.tax_rate),
          })
        }
        setLoading(false)
      })
  }, [courseSlug])

  async function beginCheckout() {
    if (!course) return
    setError('')
    setPaying(true)
    const supabase = getSupabaseBrowserClient()
    const { data } = (await supabase?.auth.getSession()) ?? { data: null }
    const accessToken = data?.session?.access_token
    if (!accessToken) {
      setError('Tu sesión ha caducado. Vuelve a iniciar sesión.')
      setPaying(false)
      return
    }

    const response = await fetch('/api/checkout', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({ courseVersionId: course.versionId }),
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
          <span className="eyebrow">Revisar pedido</span>
          <h1 style={{ fontSize: 'clamp(2rem,4vw,3.4rem)' }}>
            Compra individual
          </h1>
          {loading ? (
            <div className="panel">
              <p className="muted">Cargando el pedido…</p>
            </div>
          ) : course ? (
            <div className="panel">
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
                  {formatCurrency(course.price, course.currency)}
                </strong>
              </div>
              <div className="alert alert--info" style={{ marginBottom: 22 }}>
                El impuesto final se calculará y mostrará en Stripe antes de
                confirmar el pago.
              </div>
              <button
                className="button button--primary button--wide"
                disabled={paying}
                onClick={beginCheckout}
                type="button"
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
            </div>
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
