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
  itc020002Courses,
  type GuideCourse,
} from '../lib/guide-courses'
import { modalityLabel } from '../lib/format'
import {
  ITC_02_0_02,
  ITC_02_1_02,
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

const PATH = GUIDE_PATHS.itc020002
const TITLE = 'ITC 02.0.02: formación frente al polvo y la sílice en minería'
const DESCRIPTION =
  'Qué exige la ITC 02.0.02 (Orden TED/723/2021) frente al polvo y la sílice cristalina respirable: valores límite, formación anual y curso disponible.'

// Normas citadas sólo en esta guía. Enlaces ELI del BOE (formato estable).
const RD_665_1997 = {
  label:
    'Real Decreto 665/1997, de 12 de mayo, sobre la protección de los trabajadores contra los riesgos relacionados con la exposición a agentes cancerígenos durante el trabajo',
  url: 'https://www.boe.es/eli/es/rd/1997/05/12/665/con',
}
const RD_1154_2020 = {
  label:
    'Real Decreto 1154/2020, de 22 de diciembre, que modifica el Real Decreto 665/1997',
  url: 'https://www.boe.es/eli/es/rd/2020/12/22/1154',
}

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación minera', path: GUIDE_PATHS.hub },
  { name: 'ITC 02.0.02', path: PATH },
]

const faqs: Array<FaqItem> = [
  {
    question: '¿Qué es la ITC 02.0.02?',
    answer: `Es la instrucción técnica complementaria 02.0.02 «${ITC_02_0_02.title}» del ${RGNBSM.title}, aprobada por la ${ITC_02_0_02.instrument}. Reúne en un único texto las medidas de protección frente al polvo y la sílice cristalina respirable en las actividades mineras.`,
  },
  {
    question: '¿Cada cuánto hay que repetir la formación sobre polvo y sílice?',
    answer:
      'Al menos una vez al año, y también cuando cambian de forma relevante las funciones, el puesto, el lugar de trabajo, los equipos o el conocimiento sobre el riesgo.',
  },
  {
    question: '¿Cuál es el valor límite de la sílice cristalina respirable?',
    answer:
      '0,05 mg/m³ para la fracción respirable de sílice cristalina y 3 mg/m³ para el polvo respirable, referidos a una jornada de ocho horas. Se comparan por separado: una concentración baja de polvo puede incumplir el límite de sílice si la proporción de sílice es alta.',
  },
  {
    question: '¿La formación de la ITC 02.0.02 es la misma que la de la ITC 02.1.02?',
    answer: `No. La ${ITC_02_1_02.code} regula la formación preventiva del puesto de trabajo y la ${ITC_02_0_02.code} la protección frente a un riesgo concreto. Son obligaciones distintas y complementarias: un operador expuesto a polvo necesita las dos.`,
  },
]

export const Route = createFileRoute('/itc-02-0-02')({
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
  component: Itc020002Guide,
})

function Itc020002Guide() {
  const { catalog } = Route.useLoaderData()
  const courses = itc020002Courses(catalog)

  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Guía normativa · ITC 02.0.02"
      title="ITC 02.0.02: protección frente al polvo y la sílice cristalina respirable"
      description="Qué exige la normativa minera frente al polvo y la sílice cristalina respirable, qué formación deben recibir los trabajadores expuestos y cada cuánto."
    >
      <JsonLd
        nodes={[
          articleSchema({
            path: PATH,
            headline: TITLE,
            description: DESCRIPTION,
            dateModified: REGULATION_REVIEWED_AT,
            image: '/images/curso-silice-portada.png',
          }),
          breadcrumbSchema(breadcrumbs),
          faqSchema(faqs),
        ]}
      />

      <div className="guide-answer">
        <p>
          <strong>Qué es:</strong> la ITC 02.0.02 del Reglamento General de
          Normas Básicas de Seguridad Minera regula la protección de los
          trabajadores contra el riesgo por inhalación de polvo y sílice
          cristalina respirables. Se aprobó por la{' '}
          <a href={ITC_02_0_02.url} rel="noopener noreferrer" target="_blank">
            {ITC_02_0_02.instrument}
          </a>{' '}
          y obliga a la empresa a formar a los trabajadores expuestos, como
          mínimo, una vez al año.
        </p>
      </div>

      <GuideSection id="por-que" title="Por qué existe una instrucción específica">
        <p>
          El{' '}
          <a href={RD_1154_2020.url} rel="noopener noreferrer" target="_blank">
            Real Decreto 1154/2020
          </a>{' '}
          incorporó los trabajos que exponen al polvo respirable de sílice
          cristalina generado en un proceso de trabajo al régimen de agentes
          cancerígenos del{' '}
          <a href={RD_665_1997.url} rel="noopener noreferrer" target="_blank">
            Real Decreto 665/1997
          </a>
          . La ITC 02.0.02 traslada esa protección a las particularidades de la
          minería: perforación, voladura, carga, trituración, cribado,
          transporte y limpieza son operaciones que generan polvo respirable.
        </p>
        <p>
          La instrucción no desplaza a esos reales decretos: la evaluación de
          riesgos debe aplicar la norma más rigurosa en cada caso.
        </p>
      </GuideSection>

      <GuideSection id="valores-limite" title="Valores límite y mediciones">
        <div className="table-scroll">
          <table className="data-table data-table--wrap">
            <thead>
              <tr>
                <th scope="col">Agente</th>
                <th scope="col">Valor límite (8 horas)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th scope="row">Sílice cristalina, fracción respirable</th>
                <td>0,05 mg/m³</td>
              </tr>
              <tr>
                <th scope="row">Polvo, fracción respirable</th>
                <td>3 mg/m³</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Los dos valores se comparan por separado. La concentración se
          determina mediante mediciones personales, con el muestreador en la
          zona de respiración del trabajador.
        </p>
      </GuideSection>

      <GuideSection id="formacion" title="Qué formación deben recibir los trabajadores">
        <ul>
          <li>
            Información y formación, teórica y práctica, suficiente y adecuada
            sobre la prevención frente al polvo y la sílice cristalina
            respirables.
          </li>
          <li>
            Repetición <strong>al menos una vez al año</strong>, y siempre que
            cambien de forma relevante las funciones, el puesto, el lugar de
            trabajo, la tecnología, los equipos o el conocimiento sobre el
            riesgo.
          </li>
          <li>
            Uso correcto de los equipos de protección respiratoria, que puede
            incluir el ensayo de ajuste de la mascarilla.
          </li>
        </ul>
      </GuideSection>

      <GuideSection id="diferencias" title="Diferencias con la ITC 02.1.02">
        <p>
          La <Link className="text-link" to={GUIDE_PATHS.itc020102}>ITC 02.1.02</Link>{' '}
          regula la formación preventiva de cada puesto de trabajo y exige que
          sea únicamente presencial. La ITC 02.0.02 es una instrucción distinta,
          centrada en un riesgo concreto: no sustituye a la formación del
          puesto ni ésta a aquélla.
        </p>
      </GuideSection>

      {courses.length ? (
        <GuideSection id="curso" title="Curso de polvo y sílice cristalina respirable">
          <ul>
            {courses.map((course) => (
              <li key={course.slug}>
                <Link
                  className="text-link"
                  params={{ courseSlug: course.slug }}
                  to="/cursos/$courseSlug"
                >
                  {course.title}
                </Link>{' '}
                · {course.durations.map((hours) => `${hours} horas`).join(' / ')} ·{' '}
                {modalityLabel(course.modality).toLocaleLowerCase('es')}
              </li>
            ))}
          </ul>
          <p className="legal-note">
            Completar el curso no elimina la obligación de repetir la formación
            cada año ni la parte práctica que organice la empresa en su centro.
          </p>
        </GuideSection>
      ) : null}

      <GuideSection id="preguntas-frecuentes" title="Preguntas frecuentes sobre la ITC 02.0.02">
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
          { label: `${ITC_02_0_02.instrument}, por la que se aprueba la ${ITC_02_0_02.code}`, detail: ITC_02_0_02.boeId, url: ITC_02_0_02.url },
          { label: RD_1154_2020.label, url: RD_1154_2020.url },
          { label: RD_665_1997.label, url: RD_665_1997.url },
          { label: `${RGNBSM.instrument}: ${RGNBSM.title}`, url: RGNBSM.url },
        ]}
      />

      <GuideReviewNote reviewedAt={REGULATION_REVIEWED_AT} />
    </StaticPage>
  )
}
