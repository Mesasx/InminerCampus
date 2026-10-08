import { createFileRoute, Link } from '@tanstack/react-router'
import { AlertCircle, BookOpenCheck, CheckCircle2, Wind } from 'lucide-react'
import {
  GuideReviewNote,
  GuideSection,
  OfficialSources,
} from '../components/GuideBlocks'
import { JsonLd } from '../components/JsonLd'
import { StaticPage } from '../components/StaticPage'
import {
  guideCatalog,
  itc020002Courses,
  specificationsWithCourses,
  type GuideCourse,
} from '../lib/guide-courses'
import {
  ITC_02_0_02,
  ITC_02_1_02,
  ITC_02_1_02_AMENDMENT,
  MITECO_SPECIFICATIONS_INDEX,
  REFRESHER_RULES,
  REGULATION_REVIEWED_AT,
  RGNBSM,
} from '../lib/mining-regulation'
import { fetchPublicCourses } from '../lib/public-courses'
import { GUIDE_PATHS } from '../lib/public-routes'
import {
  articleSchema,
  breadcrumbSchema,
  faqSchema,
  type BreadcrumbItem,
  type FaqItem,
} from '../lib/schema'
import { seoHead } from '../lib/seo'

const PATH = GUIDE_PATHS.hub
const TITLE = 'Formación minera obligatoria: qué curso necesita cada puesto'
const DESCRIPTION =
  'Qué formación preventiva exige la minería en España: ITC 02.1.02 por puesto, ITC 02.0.02 de polvo y sílice, horas, reciclaje y curso para cada trabajador.'

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación minera', path: PATH },
]

const faqs: Array<FaqItem> = [
  {
    question: '¿Qué formación es obligatoria para trabajar en una mina o una cantera?',
    answer: `La formación preventiva específica del puesto de trabajo que regula la ${ITC_02_1_02.code} del Reglamento General de Normas Básicas de Seguridad Minera, con su actualización periódica. Si existe exposición a polvo o a sílice cristalina respirable, se suma la formación que exige la ${ITC_02_0_02.code}. Ninguna de las dos sustituye las demás obligaciones preventivas de la empresa.`,
  },
  {
    question: '¿Cómo sé qué curso corresponde a mi puesto?',
    answer:
      'Cada puesto tiene asignada una especificación técnica de la ITC 02.1.02 que fija su itinerario formativo. La tabla de esta página relaciona cada especificación con los puestos que cubre y con el curso disponible en InmínerCampus.',
  },
  {
    question: '¿La formación minera de la ITC 02.1.02 se puede hacer online?',
    answer: `No íntegramente. La ${ITC_02_1_02_AMENDMENT.instrument} establece que «${ITC_02_1_02_AMENDMENT.presencialQuote}» El Campus se usa como soporte teórico y de seguimiento, y la parte presencial se realiza con Inmíner Ingeniería.`,
  },
  {
    question: '¿Cada cuánto hay que renovar la formación minera?',
    answer: `En la ITC 02.1.02, el reciclaje dura como mínimo ${REFRESHER_RULES.minimumHours} horas lectivas y su periodicidad no puede superar ${REFRESHER_RULES.generalMaxYears} años, salvo que la especificación técnica del puesto fije un plazo menor (dos años para camión y volquete y para arranque, carga y viales). La formación frente al polvo y la sílice de la ITC 02.0.02 se repite al menos una vez al año.`,
  },
]

export const Route = createFileRoute('/formacion-minera')({
  loader: async () => {
    // La guía tiene valor sin el catálogo: si Supabase falla, se sirve sin la
    // columna de cursos en vez de devolver un error.
    try {
      return { catalog: guideCatalog(await fetchPublicCourses()) }
    } catch (error) {
      console.error('No se ha podido cargar el catálogo para la guía.', error)
      return { catalog: [] as Array<GuideCourse> }
    }
  },
  head: () =>
    seoHead({
      title: TITLE,
      description: DESCRIPTION,
      path: PATH,
      type: 'article',
    }),
  component: MiningTrainingGuide,
})

function CourseLinks({ courses }: { courses: Array<GuideCourse> }) {
  if (!courses.length) {
    return (
      <Link className="text-link" to="/contacto">
        Consultar formación a medida
      </Link>
    )
  }
  return (
    <>
      {courses.map((course, index) => (
        <span key={course.slug}>
          {index ? ' · ' : null}
          <Link
            className="text-link"
            params={{ courseSlug: course.slug }}
            to="/cursos/$courseSlug"
          >
            {course.title}
          </Link>{' '}
          <span className="muted">({course.durations.map((hours) => `${hours} h`).join(' / ')})</span>
        </span>
      ))}
    </>
  )
}

function MiningTrainingGuide() {
  const { catalog } = Route.useLoaderData()
  const rows = specificationsWithCourses(catalog).filter(
    ({ spec }) => spec.code !== 'ET 2005-1-11',
  )
  const silicaCourses = itc020002Courses(catalog)

  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Guía de formación minera"
      title="Formación preventiva en minería: qué formación necesita cada trabajador"
      description="Qué exige la normativa minera española en materia de formación preventiva, qué itinerario corresponde a cada puesto y cómo se organiza la formación inicial y el reciclaje."
    >
      <JsonLd
        nodes={[
          articleSchema({
            path: PATH,
            headline: TITLE,
            description: DESCRIPTION,
            dateModified: REGULATION_REVIEWED_AT,
          }),
          breadcrumbSchema(breadcrumbs),
          faqSchema(faqs),
        ]}
      />

      <div className="guide-answer">
        <p>
          <strong>En resumen:</strong> en España, quien trabaja habitualmente
          en explotaciones mineras, canteras, establecimientos de beneficio y
          demás actividades a las que se aplica el{' '}
          <a href={RGNBSM.url} rel="noopener noreferrer" target="_blank">
            {RGNBSM.title}
          </a>{' '}
          debe recibir la formación preventiva específica de su puesto que
          regula la <Link className="text-link" to={GUIDE_PATHS.itc020102}>ITC 02.1.02</Link>,
          y actualizarla periódicamente. Si en el puesto hay exposición a polvo
          o a sílice cristalina respirable, la{' '}
          <Link className="text-link" to={GUIDE_PATHS.itc020002}>ITC 02.0.02</Link>{' '}
          exige además formación específica sobre ese riesgo.
        </p>
      </div>

      <GuideSection id="instrucciones" title="Las dos instrucciones técnicas que regulan la formación">
        <div className="feature-grid">
          <article className="feature-card">
            <span className="feature-card__icon"><BookOpenCheck size={22} /></span>
            <h3>ITC 02.1.02 · formación por puesto de trabajo</h3>
            <p>
              {ITC_02_1_02.title}. Aprobada por la {ITC_02_1_02.instrument}, se
              concreta para cada puesto mediante especificaciones técnicas
              que fijan el itinerario, la duración y el reciclaje.
            </p>
            <Link className="text-link" to={GUIDE_PATHS.itc020102}>
              Guía de la ITC 02.1.02 →
            </Link>
          </article>
          <article className="feature-card">
            <span className="feature-card__icon"><Wind size={22} /></span>
            <h3>ITC 02.0.02 · polvo y sílice cristalina respirable</h3>
            <p>
              {ITC_02_0_02.title}. Aprobada por la {ITC_02_0_02.instrument},
              regula un riesgo concreto y obliga a formar a los trabajadores
              expuestos al menos una vez al año.
            </p>
            <Link className="text-link" to={GUIDE_PATHS.itc020002}>
              Guía de la ITC 02.0.02 →
            </Link>
          </article>
        </div>
      </GuideSection>

      <GuideSection id="puestos" title="Qué formación corresponde a cada puesto">
        <p>
          La ITC 02.1.02 se desarrolla mediante especificaciones técnicas (ET).
          Cada una cubre unos puestos concretos y define su itinerario
          formativo. Esta tabla relaciona cada especificación con la formación
          disponible en InmínerCampus.
        </p>
        <div className="table-scroll">
          <table className="data-table data-table--wrap">
            <thead>
              <tr>
                <th scope="col">Puestos que cubre</th>
                <th scope="col">Norma</th>
                <th scope="col">Formación en InmínerCampus</th>
              </tr>
            </thead>
            <tbody>
              {rows.map(({ spec, courses }) => (
                <tr key={spec.code}>
                  <td>
                    {spec.scope}
                    {spec.setting ? <span className="muted"> ({spec.setting.toLocaleLowerCase('es')})</span> : null}
                  </td>
                  <td className="nowrap">
                    <a href={spec.url} rel="noopener noreferrer" target="_blank">
                      {spec.code}
                    </a>
                  </td>
                  <td>
                    <CourseLinks courses={courses} />
                  </td>
                </tr>
              ))}
              <tr>
                <td>Trabajadores expuestos a polvo y sílice cristalina respirable.</td>
                <td className="nowrap">
                  <a href={ITC_02_0_02.url} rel="noopener noreferrer" target="_blank">
                    {ITC_02_0_02.code}
                  </a>
                </td>
                <td>
                  <CourseLinks courses={silicaCourses} />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p className="legal-note">
          La formación que se registra en la cartilla del trabajador y en el
          libro de la empresa se rige por la ET 2005-1-11, que no es un
          itinerario sino la forma de documentarlo. Se explica en la{' '}
          <Link className="text-link" hash="cartilla" to={GUIDE_PATHS.itc020102}>
            guía de la ITC 02.1.02
          </Link>
          .
        </p>
      </GuideSection>

      <GuideSection id="inicial-y-reciclaje" title="Formación inicial y reciclaje">
        <p>
          La formación inicial es el itinerario completo del puesto; en los
          cursos del catálogo, de 20 horas. El reciclaje la actualiza: dura
          como mínimo {REFRESHER_RULES.minimumHours} horas lectivas y se repite
          con la periodicidad que fija la norma, que nunca supera{' '}
          {REFRESHER_RULES.generalMaxYears} años y en algunos puestos es de dos.
        </p>
        <Link className="text-link" to={GUIDE_PATHS.initialAndRefresher}>
          Diferencias entre formación inicial y reciclaje →
        </Link>
      </GuideSection>

      <GuideSection id="modalidad" title="Modalidad: por qué no existe la ITC 02.1.02 «100 % online»">
        <blockquote className="guide-quote">
          «{ITC_02_1_02_AMENDMENT.presencialQuote}»
          <cite>
            {ITC_02_1_02_AMENDMENT.instrument} (
            <a href={ITC_02_1_02_AMENDMENT.url} rel="noopener noreferrer" target="_blank">
              {ITC_02_1_02_AMENDMENT.boeId}
            </a>
            )
          </cite>
        </blockquote>
        <p>
          Por eso los cursos de la ITC 02.1.02 de InmínerCampus figuran con
          modalidad híbrida: el Campus sirve de soporte teórico, de material y
          de seguimiento del itinerario, y la parte presencial se realiza con
          Inmíner Ingeniería. La formación frente al polvo y la sílice de la
          ITC 02.0.02 es una instrucción distinta y se imparte en línea.
        </p>
      </GuideSection>

      <GuideSection id="alcance" title="Qué acredita y qué no un curso de formación preventiva">
        <div className="panel legal-panel" style={{ marginTop: 0 }}>
          <div className="form-grid">
            <p><CheckCircle2 size={18} /> Un programa adaptado al puesto, con el itinerario que fija su especificación técnica.</p>
            <p><CheckCircle2 size={18} /> Evaluación, trazabilidad del progreso y certificado de formación al completar el itinerario.</p>
            <p><CheckCircle2 size={18} /> La parte práctica y presencial cuando la norma la exige.</p>
            <p><AlertCircle size={18} /> No sustituye permisos de conducción, autorizaciones internas de la empresa ni otras formaciones obligatorias.</p>
            <p><AlertCircle size={18} /> Completar la teoría o un test no basta si quedan prácticas o validaciones pendientes.</p>
          </div>
        </div>
        <p>
          Preferimos describir cada formación por su norma, su especificación
          técnica, su duración y su modalidad antes que con etiquetas como
          «homologado», que la ITC 02.1.02 no define.
        </p>
      </GuideSection>

      <GuideSection id="empresas" title="Formación para la plantilla de una empresa minera">
        <p>
          Una empresa puede contratar varias plazas, repartirlas entre sus
          trabajadores mediante códigos de acceso y seguir su progreso, con la
          facturación a nombre de la empresa.
        </p>
        <div className="guide-links">
          <Link className="button button--primary" to="/empresas">Formación para empresas</Link>
          <Link className="button button--outline" search={{ categoria: 'mineria' }} to="/catalogo">
            Ver cursos de minería
          </Link>
        </div>
      </GuideSection>

      <GuideSection id="quien" title="Quién imparte esta formación">
        <p>
          InmínerCampus es la plataforma de formación de INMINER INGENIERÍA,
          S.L., una ingeniería de Ciudad Real que trabaja en minería, industria,
          seguridad industrial y medio ambiente. Los contenidos parten de esa
          experiencia en explotaciones y proyectos reales.{' '}
          <Link className="text-link" to="/sobre-nosotros">Conoce al equipo</Link>.
        </p>
      </GuideSection>

      <GuideSection id="preguntas-frecuentes" title="Preguntas frecuentes">
        <dl className="course-faq">
          {faqs.map((faq) => (
            <div className="course-faq__item" key={faq.question}>
              <dt>{faq.question}</dt>
              <dd className="muted">{faq.answer}</dd>
            </div>
          ))}
        </dl>
      </GuideSection>

      <OfficialSources
        sources={[
          { label: `${RGNBSM.instrument}: ${RGNBSM.title}`, url: RGNBSM.url },
          { label: `${ITC_02_1_02.instrument} (${ITC_02_1_02.code})`, detail: ITC_02_1_02.boeId, url: ITC_02_1_02.url },
          { label: ITC_02_1_02_AMENDMENT.instrument, detail: ITC_02_1_02_AMENDMENT.boeId, url: ITC_02_1_02_AMENDMENT.url },
          { label: `${ITC_02_0_02.instrument} (${ITC_02_0_02.code})`, detail: ITC_02_0_02.boeId, url: ITC_02_0_02.url },
          { label: MITECO_SPECIFICATIONS_INDEX.title, url: MITECO_SPECIFICATIONS_INDEX.url },
        ]}
      />

      <GuideReviewNote reviewedAt={REGULATION_REVIEWED_AT} />
    </StaticPage>
  )
}
