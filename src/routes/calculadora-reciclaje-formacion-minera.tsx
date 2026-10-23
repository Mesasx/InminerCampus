import { createFileRoute, Link } from '@tanstack/react-router'
import { CalendarClock } from 'lucide-react'
import { useEffect, useMemo, useState } from 'react'
import {
  GuideReviewNote,
  GuideSection,
  OfficialSources,
} from '../components/GuideBlocks'
import { JsonLd } from '../components/JsonLd'
import { StaticPage } from '../components/StaticPage'
import { formatReviewDate } from '../lib/format-date'
import {
  coursesForSpecification,
  guideCatalog,
  itc020002Courses,
  type GuideCourse,
} from '../lib/guide-courses'
import {
  ITC_02_0_02,
  ITC_02_1_02,
  ITC_02_1_02_AMENDMENT,
  REFRESHER_RULES,
  REGULATION_REVIEWED_AT,
  refresherDueDate,
  refresherOptions,
  type RefresherOption,
} from '../lib/mining-regulation'
import { fetchPublicCourses } from '../lib/public-courses'
import { GUIDE_PATHS } from '../lib/public-routes'
import {
  breadcrumbSchema,
  faqSchema,
  type BreadcrumbItem,
  type FaqItem,
} from '../lib/schema'
import { SITE_NAME, absoluteUrl, seoHead } from '../lib/seo'

const PATH = GUIDE_PATHS.refresherCalculator
const TITLE = 'Calculadora de reciclaje de la formación minera'
const DESCRIPTION =
  'Calcula cuándo vence tu formación preventiva minera según la ITC 02.1.02 o la ITC 02.0.02: introduce la fecha del último curso y el puesto.'

/** Días antes del vencimiento a partir de los cuales se avisa de que está próximo. */
const SOON_DAYS = 90

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación minera', path: GUIDE_PATHS.hub },
  { name: 'Calculadora de reciclaje', path: PATH },
]

const faqs: Array<FaqItem> = [
  {
    question: '¿Cada cuánto hay que hacer el reciclaje de la formación minera?',
    answer: `Depende del puesto. La ${ITC_02_1_02.code} fija un máximo general de ${REFRESHER_RULES.generalMaxYears} años y algunas especificaciones técnicas lo reducen: dos años para camión y volquete (ET 2000-1-08) y para arranque, carga y viales (ET 2001-1-08). La formación frente al polvo y la sílice de la ${ITC_02_0_02.code} se repite al menos una vez al año.`,
  },
  {
    question: '¿Cuántas horas tiene el reciclaje?',
    answer: `En la ITC 02.1.02, como mínimo ${REFRESHER_RULES.minimumHours} horas lectivas: «${ITC_02_1_02_AMENDMENT.refresherQuote}»`,
  },
  {
    question: '¿Qué fecha tengo que introducir?',
    answer:
      'La de la última formación completada para ese puesto, inicial o de reciclaje. Figura en tu cartilla de formación y en el certificado del curso.',
  },
  {
    question: '¿El resultado tiene validez oficial?',
    answer:
      'No. Es una ayuda orientativa basada en los plazos máximos de la norma. La empresa puede exigir una actualización antes, por ejemplo si cambian el puesto, los equipos o las condiciones de trabajo.',
  },
]

export const Route = createFileRoute('/calculadora-reciclaje-formacion-minera')({
  loader: async () => {
    try {
      return { catalog: guideCatalog(await fetchPublicCourses()) }
    } catch (error) {
      console.error('No se ha podido cargar el catálogo para la calculadora.', error)
      return { catalog: [] as Array<GuideCourse> }
    }
  },
  head: () => seoHead({ title: TITLE, description: DESCRIPTION, path: PATH }),
  component: RefresherCalculatorPage,
})

function coursesForOption(catalog: Array<GuideCourse>, option: RefresherOption) {
  return option.rule.basis === 'silica'
    ? itc020002Courses(catalog)
    : coursesForSpecification(catalog, option.id)
}

function ruleText(option: RefresherOption) {
  switch (option.rule.basis) {
    case 'silica':
      return `Al menos una vez al año (${option.rule.source}).`
    case 'specification':
      return `Como máximo cada ${option.rule.years} años (${option.rule.source}).`
    default:
      return `Lo que fije la especificación técnica, nunca más de ${option.rule.years} años (${option.rule.source}).`
  }
}

/** Hoy en formato ISO, calculado en el navegador para no desajustar la hidratación. */
function useToday(): string | null {
  const [today, setToday] = useState<string | null>(null)
  useEffect(() => {
    const now = new Date()
    setToday(
      `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`,
    )
  }, [])
  return today
}

function daysBetween(fromIso: string, toIso: string) {
  const [a, b] = [fromIso, toIso].map((iso) => {
    const [y, m, d] = iso.split('-').map(Number)
    return Date.UTC(y, m - 1, d)
  })
  return Math.round((b - a) / 86_400_000)
}

function RefresherCalculatorPage() {
  const { catalog } = Route.useLoaderData()
  const options = useMemo(() => refresherOptions(), [])
  const [optionId, setOptionId] = useState(options[1]?.id ?? options[0].id)
  const [lastTraining, setLastTraining] = useState('')
  const today = useToday()

  const option = options.find((item) => item.id === optionId) ?? options[0]
  const due = lastTraining ? refresherDueDate(lastTraining, option.rule.years) : null
  const remaining = due && today ? daysBetween(today, due) : null
  const relatedCourses = coursesForOption(catalog, option)

  const status =
    remaining === null
      ? null
      : remaining < 0
        ? { tone: 'alert--error', text: `Tu formación venció hace ${Math.abs(remaining)} días.` }
        : remaining <= SOON_DAYS
          ? { tone: 'alert--info', text: `Vence en ${remaining} días: conviene planificar ya la actualización.` }
          : { tone: 'alert--success', text: `Está vigente: quedan ${remaining} días.` }

  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Herramienta gratuita"
      title="Calculadora de vencimiento de la formación minera"
      description="Introduce el puesto y la fecha de tu última formación para saber hasta cuándo es válida y cuándo te toca el reciclaje."
    >
      <JsonLd
        nodes={[
          {
            '@type': 'WebApplication',
            name: TITLE,
            url: absoluteUrl(PATH),
            description: DESCRIPTION,
            applicationCategory: 'EducationalApplication',
            operatingSystem: 'Cualquiera (navegador web)',
            inLanguage: 'es-ES',
            isAccessibleForFree: true,
            publisher: { '@type': 'EducationalOrganization', name: SITE_NAME, url: absoluteUrl('/') },
          },
          breadcrumbSchema(breadcrumbs),
          faqSchema(faqs),
        ]}
      />

      <section className="panel refresher-calculator" aria-labelledby="calculadora">
        <h2 id="calculadora">
          <CalendarClock aria-hidden="true" size={22} /> Calcula tu fecha límite
        </h2>
        <div className="form-grid refresher-calculator__fields">
          <div className="field">
            <label htmlFor="refresher-option">Puesto o riesgo</label>
            <select
              id="refresher-option"
              onChange={(event) => setOptionId(event.target.value)}
              value={optionId}
            >
              {options.map((item) => (
                <option key={item.id} value={item.id}>
                  {item.label}
                </option>
              ))}
            </select>
          </div>
          <div className="field">
            <label htmlFor="refresher-date">Fecha de la última formación</label>
            <input
              id="refresher-date"
              max={today ?? undefined}
              onChange={(event) => setLastTraining(event.target.value)}
              type="date"
              value={lastTraining}
            />
          </div>
        </div>

        <p className="muted">Plazo aplicable: {ruleText(option)}</p>

        <div aria-live="polite">
          {due ? (
            <>
              <p className="refresher-calculator__result">
                Fecha límite de la siguiente actualización:{' '}
                <strong>
                  <time dateTime={due}>{formatReviewDate(due)}</time>
                </strong>
              </p>
              {status ? <div className={`alert ${status.tone}`}>{status.text}</div> : null}
              {option.rule.basis === 'general' ? (
                <p className="legal-note">
                  Es el máximo general de la ITC 02.1.02. Comprueba en la{' '}
                  <a href={option.url} rel="noopener noreferrer" target="_blank">
                    {option.id}
                  </a>{' '}
                  si fija un plazo menor para tu puesto.
                </p>
              ) : null}
            </>
          ) : lastTraining ? (
            <div className="alert alert--error">La fecha no es válida.</div>
          ) : null}
        </div>

        {due ? (
          <div className="guide-links">
            {relatedCourses.length ? (
              relatedCourses.map((course) => (
                <Link
                  className="button button--primary"
                  key={course.slug}
                  params={{ courseSlug: course.slug }}
                  to="/cursos/$courseSlug"
                >
                  {course.hasRefresher && option.rule.basis !== 'silica'
                    ? `Hacer el reciclaje: ${course.title}`
                    : course.title}
                </Link>
              ))
            ) : (
              <Link className="button button--primary" to="/contacto">
                Consultar formación para este puesto
              </Link>
            )}
            <Link className="button button--outline" to="/empresas">
              Renovar la formación de una plantilla
            </Link>
          </div>
        ) : null}
        <p className="legal-note">
          El cálculo se hace en tu navegador: no guardamos la fecha ni el
          puesto que introduces.
        </p>
      </section>

      <GuideSection id="plazos" title="Plazos de actualización por puesto">
        <p>
          Estos son los plazos máximos que aplica la calculadora. Salen del
          texto publicado en el BOE de cada norma.
        </p>
        <div className="table-scroll">
          <table className="data-table data-table--wrap">
            <thead>
              <tr>
                <th scope="col">Puesto o riesgo</th>
                <th scope="col">Plazo máximo</th>
              </tr>
            </thead>
            <tbody>
              {options.map((item) => (
                <tr key={item.id}>
                  <th scope="row">
                    <a href={item.url} rel="noopener noreferrer" target="_blank">
                      {item.label}
                    </a>
                  </th>
                  <td>{ruleText(item)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          Para entender las diferencias entre la formación inicial y el
          reciclaje, consulta la guía de{' '}
          <Link className="text-link" to={GUIDE_PATHS.initialAndRefresher}>
            formación inicial y reciclaje
          </Link>
          .
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
          { label: `${ITC_02_1_02_AMENDMENT.instrument}, que modifica la ITC 02.1.02`, detail: ITC_02_1_02_AMENDMENT.boeId, url: ITC_02_1_02_AMENDMENT.url },
          { label: `${ITC_02_1_02.instrument} (${ITC_02_1_02.code})`, detail: ITC_02_1_02.boeId, url: ITC_02_1_02.url },
          { label: `${ITC_02_0_02.instrument} (${ITC_02_0_02.code})`, detail: ITC_02_0_02.boeId, url: ITC_02_0_02.url },
        ]}
      />

      <GuideReviewNote reviewedAt={REGULATION_REVIEWED_AT}>
        La calculadora es orientativa: la empresa puede exigir una actualización
        antes del plazo máximo si cambian el puesto, los equipos o las
        condiciones de trabajo.
      </GuideReviewNote>
    </StaticPage>
  )
}
