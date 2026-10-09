import { createFileRoute, Link } from '@tanstack/react-router'
import {
  GuideReviewNote,
  GuideSection,
  OfficialSources,
} from '../components/GuideBlocks'
import { JsonLd } from '../components/JsonLd'
import { StaticPage } from '../components/StaticPage'
import {
  guideCatalog,
  itc020102Courses,
  specificationsWithCourses,
  type GuideCourse,
} from '../lib/guide-courses'
import {
  ITC_02_1_02,
  ITC_02_1_02_AMENDMENT,
  MITECO_SPECIFICATIONS_INDEX,
  REFRESHER_RULES,
  REGULATION_REVIEWED_AT,
  RGNBSM,
  TECHNICAL_SPECIFICATIONS,
} from '../lib/mining-regulation'
import { modalityLabel } from '../lib/format'
import { fetchPublicCourses } from '../lib/public-courses'
import { GUIDE_PATHS } from '../lib/public-routes'
import {
  articleSchema,
  breadcrumbSchema,
  faqSchema,
  itemListSchema,
  type BreadcrumbItem,
  type FaqItem,
} from '../lib/schema'
import { seoHead } from '../lib/seo'

const PATH = GUIDE_PATHS.itc020102
const TITLE = 'ITC 02.1.02: formación preventiva por puesto en minería'
const DESCRIPTION =
  'Qué es la ITC 02.1.02, a quién se aplica, especificaciones técnicas por puesto, formación inicial, reciclaje de 5 horas, presencialidad y cartilla.'

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación minera', path: GUIDE_PATHS.hub },
  { name: 'ITC 02.1.02', path: PATH },
]

const faqs: Array<FaqItem> = [
  {
    question: '¿Qué es la ITC 02.1.02?',
    answer: `Es la instrucción técnica complementaria 02.1.02 «${ITC_02_1_02.title}» del ${RGNBSM.title}, aprobada por la ${ITC_02_1_02.instrument}. Regula la formación mínima en seguridad y salud que deben tener los trabajadores que desempeñan su trabajo habitual en centros adscritos a actividades mineras.`,
  },
  {
    question: '¿Es lo mismo la ITC 02.1.02 que la «ITC 02.01.02»?',
    answer:
      'Sí. La denominación oficial es ITC 02.1.02, pero es frecuente encontrarla escrita como ITC 02.01.02 o «ITC minera». Todas se refieren a la misma instrucción.',
  },
  {
    question: '¿Se puede hacer la formación ITC 02.1.02 online?',
    answer: `No íntegramente. La ${ITC_02_1_02_AMENDMENT.instrument} añadió a la instrucción que «${ITC_02_1_02_AMENDMENT.presencialQuote}» Una plataforma en línea puede servir de apoyo teórico y de seguimiento, pero no sustituir la formación presencial.`,
  },
  {
    question: '¿Cuántas horas tiene el reciclaje de la ITC 02.1.02?',
    answer: `Como mínimo ${REFRESHER_RULES.minimumHours} horas lectivas: «${ITC_02_1_02_AMENDMENT.refresherQuote}»`,
  },
  {
    question: '¿Cada cuánto hay que hacer el reciclaje?',
    answer: `La periodicidad no puede superar ${REFRESHER_RULES.generalMaxYears} años. Algunas especificaciones técnicas fijan un plazo menor para su puesto: dos años en la ET 2000-1-08 (camión y volquete) y en la ET 2001-1-08 (arranque, carga y viales).`,
  },
  {
    question: '¿Qué es una especificación técnica de la ITC 02.1.02?',
    answer:
      'Es la resolución que desarrolla la instrucción para unos puestos concretos: fija el contenido mínimo del itinerario formativo, su duración y, en su caso, la periodicidad del reciclaje. Por eso cada curso de la ITC 02.1.02 debe indicar a qué especificación técnica corresponde.',
  },
]

export const Route = createFileRoute('/itc-02-1-02/')({
  loader: async () => {
    try {
      return { catalog: guideCatalog(await fetchPublicCourses()) }
    } catch (error) {
      console.error('No se ha podido cargar el catálogo para la guía.', error)
      return { catalog: [] as Array<GuideCourse> }
    }
  },
  head: () =>
    seoHead({ title: TITLE, description: DESCRIPTION, path: PATH, type: 'article' }),
  component: Itc020102Guide,
})

function Itc020102Guide() {
  const { catalog } = Route.useLoaderData()
  const rows = specificationsWithCourses(catalog)
  const courses = itc020102Courses(catalog)

  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Guía normativa · ITC 02.1.02"
      title="ITC 02.1.02: formación preventiva para el desempeño del puesto de trabajo"
      description="Qué regula la instrucción técnica complementaria 02.1.02 del Reglamento General de Normas Básicas de Seguridad Minera, a quién se aplica y cómo se concreta para cada puesto."
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
          ...(courses.length
            ? [
                itemListSchema(
                  'Cursos de la ITC 02.1.02 en InmínerCampus',
                  courses.map((course) => ({
                    name: course.title,
                    path: `/cursos/${course.slug}`,
                  })),
                ),
              ]
            : []),
        ]}
      />

      <div className="guide-answer">
        <p>
          <strong>Qué es:</strong> la ITC 02.1.02 es la instrucción técnica
          complementaria del Reglamento General de Normas Básicas de Seguridad
          Minera que regula la formación profesional mínima en seguridad y
          salud de los trabajadores que desempeñan su trabajo habitual en
          centros adscritos a actividades mineras. Se aprobó por la{' '}
          <a href={ITC_02_1_02.url} rel="noopener noreferrer" target="_blank">
            {ITC_02_1_02.instrument}
          </a>{' '}
          y se concreta para cada puesto mediante especificaciones técnicas.
        </p>
      </div>

      <GuideSection id="que-regula" title="Qué regula y de dónde viene">
        <p>
          El{' '}
          <a href={RGNBSM.url} rel="noopener noreferrer" target="_blank">
            {RGNBSM.instrument}
          </a>{' '}
          aprobó el {RGNBSM.title} (RGNBSM), que se desarrolla mediante
          instrucciones técnicas complementarias (ITC). La ITC 02.1.02,
          «{ITC_02_1_02.title}», fija qué formación preventiva mínima debe
          tener cada trabajador para el puesto que desempeña.
        </p>
        <p>
          En 2011, la{' '}
          <a href={ITC_02_1_02_AMENDMENT.url} rel="noopener noreferrer" target="_blank">
            {ITC_02_1_02_AMENDMENT.instrument}
          </a>{' '}
          la modificó para precisar dos cuestiones que siguen vigentes: la
          formación tiene carácter únicamente presencial y los cursos de
          reciclaje duran al menos {REFRESHER_RULES.minimumHours} horas lectivas.
        </p>
      </GuideSection>

      <GuideSection id="a-quien" title="A quién se aplica">
        <p>
          A los trabajadores que desempeñan su trabajo habitual en centros de
          trabajo de las actividades a las que se aplica el RGNBSM:
          explotaciones mineras y canteras, establecimientos de beneficio y el
          resto de actividades que recoge el artículo 1 del reglamento. La
          obligación de que cada trabajador reciba la formación de su puesto
          corresponde a la empresa.
        </p>
        <p>
          La formación es específica del puesto: un operador de pala
          cargadora, un conductor de camión volquete, un perforista, un
          operador de planta o el personal de administración del centro tienen
          itinerarios distintos.
        </p>
      </GuideSection>

      <GuideSection id="especificaciones" title="Especificaciones técnicas: el itinerario de cada puesto">
        <p>
          Las especificaciones técnicas (ET) desarrollan la ITC 02.1.02 para
          grupos de puestos. Estas son las publicadas en el BOE y la formación
          disponible en InmínerCampus para cada una:
        </p>
        <div className="table-scroll">
          <table className="data-table data-table--wrap">
            <thead>
              <tr>
                <th scope="col">Especificación</th>
                <th scope="col">Qué cubre</th>
                <th scope="col">Curso</th>
              </tr>
            </thead>
            <tbody>
              {rows.map(({ spec, courses: specCourses }) => (
                <tr key={spec.code}>
                  <th className="nowrap" scope="row">
                    <a href={spec.url} rel="noopener noreferrer" target="_blank">
                      {spec.code}
                    </a>
                  </th>
                  <td>
                    {spec.title}.{' '}
                    <span className="muted">{spec.instrument}.</span>
                  </td>
                  <td>
                    {specCourses.length ? (
                      specCourses.map((course, index) => (
                        <span key={course.slug}>
                          {index ? ' · ' : null}
                          <Link
                            className="text-link"
                            params={{ courseSlug: course.slug }}
                            to="/cursos/$courseSlug"
                          >
                            {course.title}
                          </Link>
                        </span>
                      ))
                    ) : spec.code === 'ET 2005-1-11' ? (
                      <a className="text-link" href="#cartilla">Ver más abajo</a>
                    ) : (
                      <span className="muted">Sin curso publicado</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p className="legal-note">
          El Ministerio publica la{' '}
          <a href={MITECO_SPECIFICATIONS_INDEX.url} rel="noopener noreferrer" target="_blank">
            recopilación de especificaciones técnicas del RGNBSM
          </a>
          . Si tu puesto no aparece en el catálogo,{' '}
          <Link className="text-link" to="/contacto">consúltanos</Link>.
        </p>
      </GuideSection>

      <GuideSection id="inicial-y-reciclaje" title="Formación inicial y reciclaje">
        <h3>Formación inicial</h3>
        <p>
          Es el itinerario completo que la especificación técnica fija para el
          puesto. En los cursos de InmínerCampus encuadrados en la ITC 02.1.02,
          la formación inicial es de 20 horas.
        </p>
        <h3>Reciclaje o actualización</h3>
        <blockquote className="guide-quote">
          «{ITC_02_1_02_AMENDMENT.refresherQuote}»
          <cite>{ITC_02_1_02_AMENDMENT.instrument}</cite>
        </blockquote>
        <p>
          Su periodicidad no puede superar {REFRESHER_RULES.generalMaxYears}{' '}
          años, y algunas especificaciones la acortan: en la ET 2000-1-08 y en
          la ET 2001-1-08 es de dos años.
        </p>
        <Link className="text-link" to={GUIDE_PATHS.initialAndRefresher}>
          Formación inicial y reciclaje: diferencias, horas y plazos →
        </Link>
      </GuideSection>

      <GuideSection id="presencial" title="Carácter presencial">
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
          Desconfía de cualquier oferta que presente esta formación como un
          curso íntegramente en línea. En InmínerCampus, los cursos de la ITC
          02.1.02 son híbridos: la teoría, el material y el seguimiento se
          apoyan en el Campus, y la parte presencial se realiza con Inmíner
          Ingeniería.
        </p>
      </GuideSection>

      <GuideSection id="cartilla" title="Cartilla de formación y libro de registro de cursos">
        <p>
          La{' '}
          <a
            href={TECHNICAL_SPECIFICATIONS.find((spec) => spec.code === 'ET 2005-1-11')?.url}
            rel="noopener noreferrer"
            target="_blank"
          >
            ET 2005-1-11
          </a>{' '}
          regula cómo se documenta la formación recibida:
        </p>
        <ul>
          <li>
            <strong>Cartilla de formación personal del trabajador:</strong>{' '}
            pertenece al trabajador, se la entrega el empresario y recoge la
            formación preventiva que recibe a lo largo de su vida laboral.
          </li>
          <li>
            <strong>Libro de registro de cursos recibidos:</strong> lo mantiene
            la empresa y deja constancia de la formación de cada trabajador.
          </li>
        </ul>
        <p>
          Al completar un itinerario, InmínerCampus emite un certificado de
          formación con código de verificación, que puede comprobarse en{' '}
          <Link className="text-link" to="/verificar-certificado">
            Verificar certificado
          </Link>
          .
        </p>
      </GuideSection>

      {courses.length ? (
        <GuideSection id="cursos" title="Cursos de la ITC 02.1.02 en InmínerCampus">
          <div className="table-scroll">
            <table className="data-table data-table--wrap">
              <thead>
                <tr>
                  <th scope="col">Curso</th>
                  <th scope="col">Referencia</th>
                  <th scope="col">Duraciones</th>
                  <th scope="col">Modalidad</th>
                </tr>
              </thead>
              <tbody>
                {courses.map((course) => (
                  <tr key={course.slug}>
                    <th scope="row">
                      <Link
                        className="text-link"
                        params={{ courseSlug: course.slug }}
                        to="/cursos/$courseSlug"
                      >
                        {course.title}
                      </Link>
                    </th>
                    <td>
                      {TECHNICAL_SPECIFICATIONS.filter((spec) =>
                        course.references.includes(spec.code),
                      )
                        .map((spec) => spec.code)
                        .join(', ') || 'ITC 02.1.02'}
                    </td>
                    <td>
                      {course.durations
                        .map((hours) =>
                          hours <= 5 ? `${hours} h (reciclaje)` : `${hours} h (inicial)`,
                        )
                        .join(' · ')}
                    </td>
                    <td>{modalityLabel(course.modality)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </GuideSection>
      ) : null}

      <GuideSection id="preguntas-frecuentes" title="Preguntas frecuentes sobre la ITC 02.1.02">
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
          { label: `${ITC_02_1_02.instrument}, por la que se aprueba la ${ITC_02_1_02.code}`, detail: ITC_02_1_02.boeId, url: ITC_02_1_02.url },
          { label: `${ITC_02_1_02_AMENDMENT.instrument}, que modifica la ITC 02.1.02`, detail: ITC_02_1_02_AMENDMENT.boeId, url: ITC_02_1_02_AMENDMENT.url },
          ...TECHNICAL_SPECIFICATIONS.map((spec) => ({
            label: `${spec.code}: ${spec.title}`,
            detail: spec.boeId,
            url: spec.url,
          })),
          { label: `${RGNBSM.instrument}: ${RGNBSM.title}`, url: RGNBSM.url },
          { label: MITECO_SPECIFICATIONS_INDEX.title, url: MITECO_SPECIFICATIONS_INDEX.url },
        ]}
      />

      <GuideReviewNote reviewedAt={REGULATION_REVIEWED_AT} />
    </StaticPage>
  )
}
