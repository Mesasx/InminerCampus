import { createFileRoute, Link } from '@tanstack/react-router'
import { CheckCircle2, LoaderCircle, XCircle } from 'lucide-react'
import { useEffect, useState } from 'react'
import { ProtectedGate } from '../components/ProtectedGate'
import { PublicLayout } from '../components/PublicLayout'
import { formatCents } from '../lib/billing'
import { getSupabaseBrowserClient } from '../lib/supabase'

type PaymentStatus = {
  status: 'pending' | 'confirmed' | 'failed'
  orderNumber: string
  courseTitle: string | null
  modality: string | null
  durationHours: number | null
  quantity: number | null
  totalAmountCents: number
  currency: string
  invoiceEmail: string
}

export const Route = createFileRoute('/pago/confirmado')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { session_id?: string } => ({
    session_id:
      typeof search.session_id === 'string' && search.session_id.trim()
        ? search.session_id
        : undefined,
  }),
  component: PaymentConfirmedPage,
})

function PaymentConfirmedPage() {
  const { session_id: sessionId } = Route.useSearch()
  return (
    <ProtectedGate>
      {() => <PaymentConfirmation sessionId={sessionId} />}
    </ProtectedGate>
  )
}

function PaymentConfirmation({ sessionId }: { sessionId?: string }) {
  const [payment, setPayment] = useState<PaymentStatus | null>(null)
  const [error, setError] = useState('')

  useEffect(() => {
    if (!sessionId) {
      setError('La referencia del pago no es válida.')
      return
    }

    const controller = new AbortController()
    let timeout: ReturnType<typeof setTimeout> | undefined

    async function refresh() {
      const supabase = getSupabaseBrowserClient()
      const { data } = (await supabase?.auth.getSession()) ?? { data: null }
      const token = data?.session?.access_token
      if (!token) {
        setError('Tu sesión ha caducado. Vuelve a iniciar sesión.')
        return
      }

      try {
        const response = await fetch(
          `/api/payment-status?session_id=${encodeURIComponent(sessionId!)}`,
          {
            headers: { Authorization: `Bearer ${token}` },
            signal: controller.signal,
          },
        )
        const payload = (await response.json()) as
          | PaymentStatus
          | { error?: string }
        if (!response.ok || !('status' in payload)) {
          setError(
            ('error' in payload ? payload.error : undefined) ??
              'No se ha podido verificar el pago.',
          )
          return
        }
        setPayment(payload)
        setError('')
        if (payload.status === 'pending') {
          timeout = setTimeout(refresh, 2_000)
        }
      } catch (requestError) {
        if (requestError instanceof DOMException && requestError.name === 'AbortError') {
          return
        }
        setError('No se ha podido verificar el pago. Reintentando…')
        timeout = setTimeout(refresh, 3_000)
      }
    }

    void refresh()
    return () => {
      controller.abort()
      if (timeout) clearTimeout(timeout)
    }
  }, [sessionId])

  const confirmed = payment?.status === 'confirmed'
  const failed = payment?.status === 'failed'

  return (
    <PublicLayout>
      <section className="section">
        <div className="container" style={{ maxWidth: 760 }}>
          <div className="empty-state payment-result">
            <div>
              <div
                className={`empty-state__icon${failed ? ' empty-state__icon--error' : ''}`}
              >
                {confirmed ? (
                  <CheckCircle2 size={27} />
                ) : failed ? (
                  <XCircle size={27} />
                ) : (
                  <LoaderCircle className="spin" size={27} />
                )}
              </div>
              <h1>
                {confirmed
                  ? 'Pago confirmado'
                  : failed
                    ? 'El pago no se ha completado'
                    : 'Confirmando el pago…'}
              </h1>
              <p>
                {confirmed
                  ? 'Stripe ha confirmado la operación en el servidor. Tu compra ya está registrada.'
                  : failed
                    ? 'No se ha activado ningún acceso. Puedes volver al catálogo e intentarlo de nuevo.'
                    : 'Estamos esperando la confirmación segura de Stripe. No cierres esta página.'}
              </p>

              {payment ? (
                <dl className="payment-summary">
                  <div>
                    <dt>Pedido</dt>
                    <dd>{payment.orderNumber}</dd>
                  </div>
                  <div>
                    <dt>Curso</dt>
                    <dd>{payment.courseTitle ?? '—'}</dd>
                  </div>
                  <div>
                    <dt>Total</dt>
                    <dd>
                      {formatCents(
                        payment.totalAmountCents,
                        payment.currency,
                      )}
                    </dd>
                  </div>
                  {confirmed ? (
                    <div>
                      <dt>Factura</dt>
                      <dd>
                        Administración la gestionará para{' '}
                        {payment.invoiceEmail}.
                      </dd>
                    </div>
                  ) : null}
                </dl>
              ) : null}

              {error ? <div className="alert alert--error">{error}</div> : null}
              {confirmed ? (
                <Link className="button button--primary" to="/mis-cursos">
                  Ir a mis cursos
                </Link>
              ) : failed ? (
                <Link className="button button--outline" to="/catalogo">
                  Volver al catálogo
                </Link>
              ) : null}
            </div>
          </div>
        </div>
      </section>
    </PublicLayout>
  )
}
