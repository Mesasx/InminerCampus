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
        <div className="hero__stage">
          <img
            alt="Maquinaria de perforación minera sobre planos técnicos"
            className="hero__engineering-visual"
            src="/images/inminer-campus-hero-engineering.png"
          />
          <div className="container hero__grid">
            <div className="hero__content">
              <span className="eyebrow">
                Formación Preventiva Oficial en seguridad minera
              </span>
              <h1 aria-label="Conocimiento que se convierte en seguridad.">
                <span className="hero__line">Conocimiento </span>
                <span className="hero__line">que se convierte </span>
                <span className="hero__line">
                  en{' '}
                  <strong>seguridad.</strong>
                </span>
              </h1>
              <p className="hero__copy">
                Formación por puesto de trabajo conforme a la ITC 02.1.02 y
                formación específica frente al polvo y la sílice conforme a la
                ITC 02.0.02, con evaluación, trazabilidad y práctica cuando
                proceda.
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
          </div>
        </div>
        <div className="container home-journey" aria-label="Proceso formativo">
          <article>
            <span>01</span>
            <div>
              <h2>Elige tu formación</h2>
              <p>Cursos oficiales y específicos adaptados a tu puesto.</p>
            </div>
          </article>
          <article>
            <span>02</span>
            <div>
              <h2>Aprende con rigor</h2>
              <p>Contenidos claros, actualizados y orientados a la práctica.</p>
            </div>
          </article>
          <article>
            <span>03</span>
            <div>
              <h2>Evalúa y acredita</h2>
              <p>Evaluación conforme a normativa y criterios oficiales.</p>
            </div>
          </article>
          <article>
            <span>04</span>
            <div>
              <h2>Aplica con seguridad</h2>
              <p>
                Conocimiento que se traduce en decisiones seguras en el trabajo.
              </p>
            </div>
          </article>
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
