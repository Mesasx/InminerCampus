import { createFileRoute } from '@tanstack/react-router'
import {
  BadgeCheck,
  Building2,
  CheckCircle2,
  Compass,
  Factory,
  GraduationCap,
  HardHat,
  Landmark,
  Lightbulb,
  Mountain,
  ShieldCheck,
  Waves,
} from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/sobre-nosotros')({
  component: AboutPage,
})

const projectHighlights = [
  {
    year: '2008—hoy',
    title: 'Dirección de Ingeniería de INMÍNER',
    text: 'Más de 18 años coordinando disciplinas, equipos y proyectos mineros e industriales desde Ciudad Real.',
    icon: Building2,
  },
  {
    year: '2014',
    title: 'Ingeniería a medida para Repsol Química',
    text: 'Diseño de la máquina Flushing y de sus sistemas eléctrico y de control para industria de proceso.',
    icon: Factory,
  },
  {
    year: '2015—2018',
    title: 'Demoliciones técnicas singulares',
    text: 'Participación técnica y preventiva en voladuras controladas de torres de refrigeración en Puertollano, incluida la torre de 122 metros de ELCOGAS.',
    icon: Landmark,
  },
  {
    year: '2020—hoy',
    title: 'Proyecto minero El Moto',
    text: 'Dirección facultativa desde INMÍNER y diseño de infraestructuras de agua para el proyecto de wolframio de Abenójar.',
    icon: Mountain,
  },
]

function AboutPage() {
  return (
    <StaticPage
      eyebrow="Sobre InmínerCampus"
      title="Ingeniería que enseña desde la experiencia."
      description="InmínerCampus es la plataforma de formación de INMINER INGENIERÍA, S.L., una firma multidisciplinar de Ciudad Real con más de 18 años de trayectoria en minería, industria, seguridad y medio ambiente."
    >
      <div className="feature-grid">
        <article className="feature-card">
          <span className="feature-card__icon">
            <HardHat size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Experiencia de campo</h2>
          <p>
            La formación parte de proyectos, equipos, explotaciones y
            decisiones técnicas reales, no sólo de contenidos teóricos.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon">
            <Building2 size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Visión multidisciplinar</h2>
          <p>
            Minería, industria, seguridad, agua, medio ambiente, obra y
            tramitación administrativa conectados en una misma metodología.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon">
            <ShieldCheck size={23} />
          </span>
          <h2 style={{ fontSize: '1.2rem' }}>Prevención trazable</h2>
          <p>
            Itinerarios identificados, seguimiento, evaluación y prácticas
            cuando resulten exigibles para la formación.
          </p>
        </article>
      </div>

      <section className="instructor">
        <div className="instructor__portrait">
          <img
            alt="Pedro Mesas Riballo, director de Ingeniería de INMÍNER"
            height="1254"
            src="/images/pedro-mesas-riballo.jpg"
            width="1254"
          />
          <span className="instructor__portrait-caption">
            Director de Ingeniería · INMÍNER
          </span>
        </div>
        <div>
          <span className="eyebrow">Dirección técnica y docente</span>
          <h2>Pedro Mesas Riballo</h2>
          <p className="instructor__role">
            Ingeniero-directivo especializado en proyectos mineros e
            industriales complejos.
          </p>
          <p className="muted instructor__summary">
            Desde marzo de 2008 dirige el área de Ingeniería de INMÍNER. Su
            trayectoria combina diseño y cálculo, dirección facultativa,
            seguridad, permisos, medio ambiente, agua y relación con
            administraciones. Esa perspectiva integral se traslada a una
            formación práctica, rigurosa y conectada con el trabajo real.
          </p>

          <div className="professional-stats">
            <div>
              <strong>18+</strong>
              <span>años en dirección de Ingeniería</span>
            </div>
            <div>
              <strong>2</strong>
              <span>ramas técnicas complementarias</span>
            </div>
            <div>
              <strong>15+</strong>
              <span>años de proyectos documentados</span>
            </div>
          </div>

          <div className="credential-list">
            <span>
              <GraduationCap size={18} /> Ingeniería Técnica Industrial e
              Ingeniería Técnica de Minas por la UCLM
            </span>
            <span>
              <BadgeCheck size={18} /> Autoría y responsabilidad técnica
              acreditadas en expedientes públicos
            </span>
            <span>
              <HardHat size={18} /> Dirección facultativa, seguridad y
              experiencia en explotaciones mineras
            </span>
          </div>
        </div>
      </section>

      <section className="profile-section">
        <div className="section-heading">
          <div>
            <span className="eyebrow">Una mirada completa</span>
            <h2>Del diseño a la puesta en marcha y el seguimiento.</h2>
          </div>
          <p>
            Su valor diferencial está en conectar especialidades y convertir
            condicionantes técnicos, preventivos y administrativos en
            soluciones ejecutables.
          </p>
        </div>
        <div className="expertise-grid">
          <article>
            <Mountain size={23} />
            <h3>Ingeniería minera</h3>
            <p>
              Explotación, restauración, dirección facultativa, seguridad y
              tramitación.
            </p>
          </article>
          <article>
            <Factory size={23} />
            <h3>Ingeniería industrial</h3>
            <p>
              Instalaciones, maquinaria, prototipos, automatización, energía y
              legalización.
            </p>
          </article>
          <article>
            <ShieldCheck size={23} />
            <h3>Riesgos complejos</h3>
            <p>
              Demoliciones técnicas, ATEX, amianto y coordinación de seguridad.
            </p>
          </article>
          <article>
            <Waves size={23} />
            <h3>Medio ambiente y agua</h3>
            <p>
              Restauración, evaluación ambiental, balsas, tratamiento y
              reutilización.
            </p>
          </article>
          <article>
            <Lightbulb size={23} />
            <h3>Soluciones a medida</h3>
            <p>
              Diseño funcional, integración de disciplinas, prototipado y
              puesta en marcha.
            </p>
          </article>
          <article>
            <Compass size={23} />
            <h3>Interlocución técnica</h3>
            <p>
              Coordinación de equipos, clientes, contratistas y organismos
              públicos.
            </p>
          </article>
        </div>
      </section>

      <section className="profile-section profile-section--soft">
        <div className="section-heading">
          <div>
            <span className="eyebrow">Trayectoria seleccionada</span>
            <h2>Proyectos que hablan de experiencia real.</h2>
          </div>
          <p>
            Una selección representativa del informe profesional aportado,
            basada en fuentes públicas e institucionales.
          </p>
        </div>
        <div className="project-timeline">
          {projectHighlights.map(({ icon: Icon, year, title, text }) => (
            <article key={title}>
              <span className="project-timeline__icon">
                <Icon size={22} />
              </span>
              <span className="project-timeline__year">{year}</span>
              <h3>{title}</h3>
              <p>{text}</p>
            </article>
          ))}
        </div>
      </section>

      <div className="recognition-panel">
        <div>
          <span className="eyebrow">Rigor y transparencia</span>
          <h2>Reconocimientos del proyecto, mérito del trabajo técnico.</h2>
          <p>
            El proyecto minero El Moto fue reconocido en 2025 como Proyecto
            Estratégico de materias primas críticas de la Unión Europea y su
            iniciativa de gestión sostenible del agua fue seleccionada en
            Communities for Climate. Son reconocimientos institucionales del
            proyecto, no premios personales. La relevancia para Pedro reside en
            las responsabilidades técnicas documentadas que desempeña desde
            INMÍNER.
          </p>
        </div>
        <ul>
          <li>
            <CheckCircle2 size={18} /> Dirección facultativa del proyecto
            minero
          </li>
          <li>
            <CheckCircle2 size={18} /> Diseño de balsas e infraestructuras de
            agua
          </li>
          <li>
            <CheckCircle2 size={18} /> Seguimiento técnico con la administración
          </li>
        </ul>
      </div>

      <div className="panel trust-panel">
        <span className="eyebrow">Transparencia formativa</span>
        <h2>Formación con alcance y requisitos claramente identificados.</h2>
        <p className="muted">
          Cada ficha indica la ITC y la especificación técnica aplicables, la
          duración, el precio de esa versión y si necesita prácticas,
          asistencia o adaptación al centro. Superar la teoría online no
          equivale por sí sola a completar una formación con requisitos
          presenciales.
        </p>
        <a
          className="button button--outline"
          href="https://inminer.es/quienes-somos/"
          rel="noreferrer"
          target="_blank"
        >
          <Compass size={18} /> Conocer al equipo de INMÍNER
        </a>
      </div>
    </StaticPage>
  )
}
