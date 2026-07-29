import { createFileRoute } from '@tanstack/react-router'
import {
  BadgeCheck,
  Building2,
  Compass,
  GraduationCap,
  HardHat,
  ShieldCheck,
} from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/sobre-nosotros')({
  component: AboutPage,
})

function AboutPage() {
  return (
    <StaticPage
      eyebrow="Sobre InmínerCampus"
      title="Ingeniería minera que también forma."
      description="InmínerCampus es la plataforma de formación de Inmíner Ingeniería, S.L., empresa privada de ingeniería con sede en Ciudad Real y más de 18 años de experiencia en el sector minero."
    >
      <div className="feature-grid">
        <article className="feature-card">
          <span className="feature-card__icon"><HardHat size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Experiencia minera real</h2>
          <p>
            Ingeniería minera, permitting, dirección facultativa, seguridad,
            medio ambiente e inspección técnica aplicados a proyectos extractivos.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon"><Building2 size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Conocimiento de empresa</h2>
          <p>
            La formación nace del trabajo cotidiano con explotaciones, equipos,
            trabajadores, contratas y administraciones mineras.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon"><ShieldCheck size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Prevención verificable</h2>
          <p>
            Contenidos reglados, seguimiento, evaluación, registro y práctica
            presencial cuando resulte exigible.
          </p>
        </article>
      </div>

      <section className="instructor">
        <div className="instructor__portrait">
          <img
            src="https://inminer.es/wp-content/uploads/2025/10/pedro.jpg"
            alt="Pedro Mesas Riballo, director de Ingeniería de Inmíner Ingeniería"
            width="1200"
            height="1200"
          />
        </div>
        <div>
          <span className="eyebrow">Formador principal</span>
          <h2>Pedro Mesas Riballo</h2>
          <p className="instructor__role">
            Director de Ingeniería de Inmíner Ingeniería, S.L.
          </p>
          <p className="muted" style={{ lineHeight: 1.75 }}>
            Pedro Mesas Riballo coordina y asume mayoritariamente la impartición
            de la formación. Es Ingeniero de Minas e Ingeniero Industrial y
            cuenta con formación superior en prevención de riesgos laborales,
            además de experiencia técnica y directiva en el sector minero.
          </p>
          <div className="credential-list">
            <span><GraduationCap size={18} /> Ingeniería de Minas e Ingeniería Industrial</span>
            <span><BadgeCheck size={18} /> Nivel superior en prevención de riesgos laborales</span>
            <span><HardHat size={18} /> Dirección facultativa y experiencia en explotaciones mineras</span>
          </div>
          <p className="legal-note">
            El equipo docente de cada edición se identifica antes de su inicio.
            Podrán intervenir otros profesionales cualificados de Inmíner cuando
            el contenido o la práctica lo requieran.
          </p>
        </div>
      </section>

      <div className="panel" style={{ marginTop: 34 }}>
        <span className="eyebrow">Transparencia normativa</span>
        <h2>No vendemos “carnés” ni cursos genéricamente homologados.</h2>
        <p className="muted" style={{ maxWidth: 880, lineHeight: 1.75 }}>
          Impartimos Formación Preventiva Oficial vinculada al Reglamento General
          de Normas Básicas de Seguridad Minera. Cada ficha identifica la ITC y
          la especificación técnica aplicables. La ITC 02.1.02 regula la formación
          preventiva por puesto de trabajo; la formación sobre polvo y sílice se
          encuadra en la ITC 02.0.02. Cuando sean necesarias prácticas, asistencia
          o adaptación al centro de trabajo, la superación de la teoría online no
          equivale por sí sola a completar la formación.
        </p>
        <a className="button button--outline" href="https://inminer.es/" target="_blank" rel="noreferrer">
          <Compass size={18} /> Conocer Inmíner
        </a>
      </div>
    </StaticPage>
  )
}
