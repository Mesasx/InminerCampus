import { createFileRoute } from '@tanstack/react-router'
import { Mail, MapPin, Phone } from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/contacto')({
  component: ContactPage,
})

function ContactPage() {
  return (
    <StaticPage
      eyebrow="Contacto"
      title="Cuéntanos qué formación necesitas."
      description="Nuestro equipo puede ayudarte con cursos individuales, compras para empresas y dudas sobre el funcionamiento de la plataforma."
    >
      <div
        className="feature-grid"
        style={{ gridTemplateColumns: 'repeat(3, minmax(0,1fr))' }}
      >
        <a className="feature-card" href="mailto:administracion@inminer.es">
          <span className="feature-card__icon">
            <Mail size={23} />
          </span>
          <h2 style={{ fontSize: '1.12rem' }}>Correo</h2>
          <p>administracion@inminer.es</p>
        </a>
        <a className="feature-card" href="tel:+34926219417">
          <span className="feature-card__icon">
            <Phone size={23} />
          </span>
          <h2 style={{ fontSize: '1.12rem' }}>Teléfono</h2>
          <p>926 21 94 17</p>
        </a>
        <article className="feature-card">
          <span className="feature-card__icon">
            <MapPin size={23} />
          </span>
          <h2 style={{ fontSize: '1.12rem' }}>Sede</h2>
          <p>C/ La Solana, 60 · 13005 Ciudad Real</p>
        </article>
      </div>
      <div className="alert alert--info" style={{ marginTop: 28 }}>
        Horario de atención publicado por Inmíner: lunes a viernes, de 07:30 a
        15:30.
      </div>
    </StaticPage>
  )
}
