import { createFileRoute } from '@tanstack/react-router'
import { Compass, HardHat, Leaf, ShieldCheck } from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/sobre-nosotros')({
  component: AboutPage,
})

function AboutPage() {
  return (
    <StaticPage
      eyebrow="Sobre InmínerCampus"
      title="Formación respaldada por experiencia técnica."
      description="InmínerCampus es la plataforma de formación de Inmíner Ingeniería, S.L., empresa privada de ingeniería multidisciplinar."
    >
      <div className="feature-grid">
        <article className="feature-card">
          <span className="feature-card__icon">
            <HardHat size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Experiencia aplicada</h2>
          <p>
            Contenidos vinculados a situaciones y responsabilidades reales de los
            entornos mineros e industriales.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon">
            <ShieldCheck size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Seguridad</h2>
          <p>
            La prevención y la trazabilidad forman parte del diseño del producto,
            no son elementos decorativos.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon">
            <Leaf size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Responsabilidad</h2>
          <p>
            Tecnología y conocimiento al servicio de una actividad profesional
            rigurosa y sostenible.
          </p>
        </article>
      </div>
      <div className="panel" style={{ marginTop: 28 }}>
        <span className="eyebrow">Nuestro enfoque</span>
        <h2>Lo digital acompaña al aprendizaje, no sustituye los requisitos.</h2>
        <p className="muted" style={{ maxWidth: 780, lineHeight: 1.75 }}>
          Cuando una formación exige prácticas, asistencia o validación por un
          profesional, la plataforma lo refleja y no presenta el curso como
          íntegramente online. Cualquier mención de homologación se publicará solo
          con la documentación correspondiente.
        </p>
        <a
          className="button button--outline"
          href="https://inminer.es/"
          target="_blank"
          rel="noreferrer"
        >
          <Compass size={18} /> Conocer Inmíner
        </a>
      </div>
    </StaticPage>
  )
}
