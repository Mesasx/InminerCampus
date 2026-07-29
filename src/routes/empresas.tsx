import { createFileRoute } from '@tanstack/react-router'
import {
  BarChart3,
  Building2,
  KeyRound,
  ReceiptText,
  UsersRound,
} from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/empresas')({
  component: CompaniesPage,
})

function CompaniesPage() {
  return (
    <StaticPage
      eyebrow="Formación para empresas"
      title="Gestiona la formación de tu equipo sin perder el control."
      description="Compra plazas, distribuye accesos individuales y consulta el estado autorizado de la formación desde un único espacio."
    >
      <div className="feature-grid">
        <article className="feature-card">
          <span className="feature-card__icon">
            <UsersRound size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Plazas por volumen</h2>
          <p>
            Selecciona el curso y el número de personas que necesitan la
            formación.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon">
            <KeyRound size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Códigos de un solo uso</h2>
          <p>
            Cada plaza genera un acceso único que se consume de forma atómica al
            asignarlo.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon">
            <BarChart3 size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Seguimiento autorizado</h2>
          <p>
            Consulta el avance necesario para gestionar la formación respetando
            la privacidad.
          </p>
        </article>
      </div>
      <div
        className="panel"
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: 42,
          marginTop: 28,
          alignItems: 'center',
        }}
      >
        <div>
          <span className="eyebrow">Compra empresarial</span>
          <h2>Presupuesto y facturación con datos reales</h2>
          <p className="muted" style={{ lineHeight: 1.7 }}>
            El pedido identifica la empresa, el número de plazas, los impuestos
            y la factura. El acceso solo se activa cuando Stripe confirma el
            pago mediante webhook.
          </p>
        </div>
        <div className="form-grid">
          <div style={{ display: 'flex', gap: 12 }}>
            <Building2 color="var(--orange)" />
            <span>Datos fiscales de la organización</span>
          </div>
          <div style={{ display: 'flex', gap: 12 }}>
            <ReceiptText color="var(--orange)" />
            <span>Pedido, impuestos y factura registrados</span>
          </div>
          <a
            className="button button--primary"
            href="mailto:administracion@inminer.es?subject=Formación%20para%20empresa%20-%20InmínerCampus"
          >
            Solicitar propuesta
          </a>
        </div>
      </div>
    </StaticPage>
  )
}
