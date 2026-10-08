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
  type GuideCourse,
} from '../lib/guide-courses'
import {
  ITC_02_1_02,
  ITC_02_1_02_AMENDMENT,
  REFRESHER_RULES,
  REGULATION_REVIEWED_AT,
  TECHNICAL_SPECIFICATIONS,
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

const PATH = GUIDE_PATHS.initialAndRefresher
const TITLE = 'Formación inicial y reciclaje 5 horas: ITC 02.1.02'
const DESCRIPTION =
  'Formación inicial y reciclaje de la ITC 02.1.02: horas mínimas, renovación cada 2 o 4 años según el puesto, modalidad presencial y qué curso elegir.'

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación minera', path: GUIDE_PATHS.hub },
  { name: 'ITC 02.1.02', path: GUIDE_PATHS.itc020102 },
  { name: 'Formación inicial y reciclaje', path: PATH },
]

const specificShortened = Object.entries(REFRESHER_RULES.bySpecification)

const faqs: Array<FaqItem> = [
  {
    question: '¿Cuántas horas tiene el reciclaje de formación minera?',
    answer: `Como mínimo ${REFRESHER_RULES.minimumHours} horas lectivas. La ${ITC_02_1_02_AMENDMENT.instrument} establece que «${ITC_02_1_02_AMENDMENT.refresherQuote}»`,
  },
  {
    question: '¿Cada cuánto tiempo hay que renovar la formación de la ITC 02.1.02?',
    answer: `Con la periodicidad que fije la especificación técnica del puesto, que nunca puede superar ${REFRESHER_RULES.generalMaxYears} años. Para operadores de camión y volquete (ET 2000-1-08) y de arranque, carga y viales (ET 2001-1-08) el plazo máximo es de dos años.`,
  },
  {
    question: '¿El reciclaje de 5 horas se puede hacer online?',
    answer: `No íntegramente. La ${ITC_02_1_02_AMENDMENT.instrument} establece que «${ITC_02_1_02_AMENDMENT.presencialQuote}», y eso incluye el reciclaje. En InmínerCampus el reciclaje es híbrido: la teoría se apoya en el Campus y la parte presencial se realiza con Inmíner Ingeniería.`,
  },
  {
    question: '¿Qué curso necesito, el de 20 horas o el de 5 horas?',
    answer:
      'El de 20 horas es la formación inicial del puesto. El de 5 horas es la actualización periódica pensada para quien ya recibió esa formación inicial. Si tienes dudas sobre tu caso, revisa tu cartilla de formación o consúltanos antes de comprar.',
  },
]

export const Route = createFileRoute('/itc-02-1-02/formacion-inicial-y-reciclaje')({
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
  component: InitialAndRefresherGuide,
})

function InitialAndRefresherGuide() {
  const { catalog } = Route.useLoaderData()
  const courses = itc020102Courses(catalog)

  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Guía normativa · ITC 02.1.02"
      title="Formación inicial y reciclaje en minería: horas, plazos y diferencias"
      description="Qué diferencia la formación inicial de 20 horas del reciclaje de 5 horas, cada cuánto hay que renovarla y cuál corresponde a cada trabajador."
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
          <strong>En resumen:</strong> la formación inicial es el itinerario
          completo del puesto (20 horas en los cursos de InmínerCampus). El
          reciclaje lo actualiza: dura al menos {REFRESHER_RULES.minimumHours}{' '}
          horas lectivas y se repite con la periodicidad de la especificación
          técnica del puesto, que no puede superar{' '}
          {REFRESHER_RULES.generalMaxYears} años y es de dos para camión y
          volquete y para arranque, carga y viales. Las dos son presenciales.
        </p>
      </div>

      <GuideSection id="comparativa" title="Formación inicial y reciclaje, frente a frente">
        <div className="table-scroll">
          <table className="data-table data-table--wrap">
            <thead>
              <tr>
                <th scope="col"></th>
                <th scope="col">Formación inicial</th>
                <th scope="col">Reciclaje o actualización</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th scope="row">Qué es</th>
                <td>El itinerario completo que la especificación técnica fija para el puesto.</td>
                <td>La actualización periódica de esos conocimientos.</td>
              </tr>
              <tr>
                <th scope="row">Para quién</th>
                <td>Quien necesita la formación de su puesto.</td>
                <td>Quien ya recibió la formación inicial del puesto.</td>
              </tr>
              <tr>
                <th scope="row">Duración</th>
                <td>La que fija la especificación técnica; 20 horas en los cursos del catálogo.</td>
                <td>Mínimo {REFRESHER_RULES.minimumHours} horas lectivas ({ITC_02_1_02_AMENDMENT.code}).</td>
              </tr>
              <tr>
                <th scope="row">Periodicidad</th>
                <td>—</td>
                <td>
                  Como máximo cada {REFRESHER_RULES.generalMaxYears} años, o
                  el plazo menor que fije la especificación técnica.
                </td>
              </tr>
              <tr>
                <th scope="row">Modalidad</th>
                <td colSpan={2}>Únicamente presencial ({ITC_02_1_02_AMENDMENT.code}).</td>
              </tr>
            </tbody>
          </table>
        </div>
      </GuideSection>

      <GuideSection id="periodicidad" title="Cada cuánto hay que hacer el reciclaje">
        <p>
          La ITC 02.1.02 fija un máximo general de{' '}
          {REFRESHER_RULES.generalMaxYears} años. Las especificaciones técnicas
          pueden reducirlo para su puesto:
        </p>
        <ul>
          {specificShortened.map(([code, years]) => {
            const spec = TECHNICAL_SPECIFICATIONS.find((item) => item.code === code)
            return (
              <li key={code}>
                <a href={spec?.url} rel="noopener noreferrer" target="_blank">
                  {code}
                </a>
                {spec ? ` (${spec.scope.replace(/\.$/, '').toLocaleLowerCase('es')})` : ''}:{' '}
                <strong>{years} años</strong>.
              </li>
            )
          })}
        </ul>
        <p>
          Para el resto de puestos, consulta la especificación técnica
          correspondiente en la{' '}
          <Link className="text-link" hash="especificaciones" to={GUIDE_PATHS.itc020102}>
            guía de la ITC 02.1.02
          </Link>
          . La formación recibida se anota en la cartilla del trabajador y en
          el libro de registro de la empresa, que son la referencia para saber
          cuándo toca el siguiente reciclaje.
        </p>
      </GuideSection>

      {courses.length ? (
        <GuideSection id="cursos" title="Formación inicial y reciclaje disponibles">
          <div className="table-scroll">
            <table className="data-table data-table--wrap">
              <thead>
                <tr>
                  <th scope="col">Puesto</th>
                  <th scope="col">Formación inicial</th>
                  <th scope="col">Reciclaje</th>
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
                      {course.durations.filter((hours) => hours > 5).map((hours) => `${hours} h`).join(' · ') || '—'}
                    </td>
                    <td>
                      {course.durations.filter((hours) => hours <= 5).map((hours) => `${hours} h`).join(' · ') || '—'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="legal-note">
            En cada ficha puedes elegir la duración antes de comprar, para ti o
            para varios trabajadores de una empresa.
          </p>
        </GuideSection>
      ) : null}

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
          { label: `${ITC_02_1_02_AMENDMENT.instrument}, que modifica la ITC 02.1.02`, detail: ITC_02_1_02_AMENDMENT.boeId, url: ITC_02_1_02_AMENDMENT.url },
          { label: `${ITC_02_1_02.instrument} (${ITC_02_1_02.code})`, detail: ITC_02_1_02.boeId, url: ITC_02_1_02.url },
          ...TECHNICAL_SPECIFICATIONS.filter((spec) => spec.code in REFRESHER_RULES.bySpecification).map((spec) => ({
            label: `${spec.code}: ${spec.title}`,
            detail: spec.boeId,
            url: spec.url,
          })),
        ]}
      />

      <GuideReviewNote reviewedAt={REGULATION_REVIEWED_AT} />
    </StaticPage>
  )
}
