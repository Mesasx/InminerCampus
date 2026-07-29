import { createFileRoute, Link } from '@tanstack/react-router'
import {
  ArrowRight,
  BadgeCheck,
  Building2,
  ClipboardCheck,
  PlayCircle,
  ShieldCheck,
} from 'lucide-react'
import { PublicLayout } from '../components/PublicLayout'

export const Route = createFileRoute('/')({
  component: HomePage,
})

function HomePage() {
  return (
    <PublicLayout>
      <section className="hero">
        <div className="container hero__grid">
          <div>
            <span className="eyebrow">Formación técnica especializada</span>
            <h1>
              Conocimiento que se convierte en <span>seguridad.</span>
            </h1>
            <p className="hero__copy">
              Formación preventiva y técnica para profesionales y empresas, con
              contenidos estructurados, evaluación rigurosa y trazabilidad real.
            </p>
            <div className="hero__actions">
              <Link className="button button--primary" to="/catalogo">
                Explorar cursos <ArrowRight size={18} />
              </Link>
              <Link className="button button--outline" to="/empresas">
                Formación para empresas
              </Link>
            </div>
          </div>
          <div className="hero__panel" aria-label="Ejemplo de curso">
            <article className="hero-course">
              <span className="hero-course__tag">Programa técnico</span>
              <h2>Formación preventiva para entornos mineros e industriales</h2>
              <p>
                Teoría online trazable, evaluación y prácticas presenciales
                cuando el programa lo requiera.
              </p>
              <div className="hero-course__meta">
                <span>5 o 20 horas</span>
                <span>Modalidad híbrida</span>
              </div>
            </article>
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container">
          <div className="section-heading">
            <div>
              <span className="eyebrow">Una plataforma rigurosa</span>
              <h2>Formarse con claridad. Acreditarlo con confianza.</h2>
            </div>
            <p>
              Cada paso formativo queda organizado y registrado, desde el acceso
              al contenido hasta la evaluación y la validación práctica.
            </p>
          </div>
          <div className="feature-grid">
            <article className="feature-card">
              <span className="feature-card__icon">
                <PlayCircle size={23} />
              </span>
              <h3>Aprendizaje guiado</h3>
              <p>
                Lecciones secuenciales con vídeo, documentación técnica y
                controles de progreso.
              </p>
            </article>
            <article className="feature-card">
              <span className="feature-card__icon">
                <ClipboardCheck size={23} />
              </span>
              <h3>Evaluación exigente</h3>
              <p>
                Tests configurables con trazabilidad de intentos y criterios de
                superación definidos.
              </p>
            </article>
            <article className="feature-card">
              <span className="feature-card__icon">
                <ShieldCheck size={23} />
              </span>
              <h3>Evidencia verificable</h3>
              <p>
                Progreso, asistencia y certificados verificables cuando se
                cumplen todos los requisitos.
              </p>
            </article>
          </div>
        </div>
      </section>

      <section className="section section--soft">
        <div className="container">
          <div className="section-heading">
            <div>
              <span className="eyebrow">Dos formas de acceder</span>
              <h2>Para profesionales y para organizaciones.</h2>
            </div>
          </div>
          <div className="feature-grid" style={{ gridTemplateColumns: '1fr 1fr' }}>
            <article className="feature-card">
              <span className="feature-card__icon">
                <BadgeCheck size={23} />
              </span>
              <h3>Acceso individual</h3>
              <p>
                Consulta el catálogo, matricúlate y continúa tu formación desde
                cualquier dispositivo.
              </p>
              <Link className="text-link" to="/catalogo">
                Ver catálogo →
              </Link>
            </article>
            <article className="feature-card">
              <span className="feature-card__icon">
                <Building2 size={23} />
              </span>
              <h3>Formación para empresas</h3>
              <p>
                Compra plazas, asígnalas a trabajadores y consulta el avance
                autorizado de tu equipo.
              </p>
              <Link className="text-link" to="/empresas">
                Conocer la solución →
              </Link>
            </article>
          </div>
        </div>
      </section>
    </PublicLayout>
  )
}
