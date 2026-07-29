import { createFileRoute, Link } from '@tanstack/react-router'
import { CheckCircle2 } from 'lucide-react'
import { PublicLayout } from '../components/PublicLayout'

export const Route = createFileRoute('/pago/confirmado')({
  component: PaymentConfirmedPage,
})

function PaymentConfirmedPage() {
  return (
    <PublicLayout>
      <section className="section">
        <div className="container" style={{ maxWidth: 760 }}>
          <div className="empty-state">
            <div>
              <div className="empty-state__icon">
                <CheckCircle2 size={27} />
              </div>
              <h1>Pago recibido</h1>
              <p>
                Stripe está confirmando la operación. Tu matrícula aparecerá en
                “Mis cursos” cuando el webhook seguro termine el proceso.
              </p>
              <Link className="button button--primary" to="/mis-cursos">
                Ir a mis cursos
              </Link>
            </div>
          </div>
        </div>
      </section>
    </PublicLayout>
  )
}
