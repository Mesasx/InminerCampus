import { createFileRoute, Link, notFound } from '@tanstack/react-router'
import {
  BadgeCheck,
  CalendarClock,
  CheckCircle2,
  MapPin,
} from 'lucide-react'
import { Breadcrumbs } from '../components/Breadcrumbs'
import { CourseCard } from '../components/CourseCard'
import { JsonLd } from '../components/JsonLd'
import { PublicLayout } from '../components/PublicLayout'
import { categoryLabels, categoryOf } from '../lib/course-category'
import { courseImage } from '../lib/course-image'
import {
  ITC_02_1_02_PRESENCIAL,
  courseFaqs,
  courseMetaDescription,
  courseMetaTitle,
  isItc020102,
  normativeReference,
  versionLabel,
} from '../lib/course-seo'
import { formatCurrency, modalityLabel } from '../lib/format'
import {
  fetchPublicCourse,
  fetchPublicCourses,
  isIndexableCourse,
  type PublicCourseDetail,
} from '../lib/public-courses'
import {
  breadcrumbSchema,
  courseSchema,
  faqSchema,
  type BreadcrumbItem,
} from '../lib/schema'
import { seoHead } from '../lib/seo'
import type { PublicCourse } from '../lib/types'

export const Route = createFileRoute('/cursos/$courseSlug')({
  validateSearch: (search: Record<string, unknown>): { version?: string } => ({
    version:
      typeof search.version === 'string' && search.version.trim()
        ? search.version
        : undefined,
  }),
  // El loader se ejecuta durante el SSR, de modo que el HTML inicial ya
  // contiene la ficha completa. Antes los datos se pedían en un `useEffect`,
  // así que el rastreador sólo recibía cabecera, «Cargando…» y pie.
  loader: async ({ params }) => {
    const [course, catalog] = await Promise.all([
      fetchPublicCourse(params.courseSlug),
      fetchPublicCourses(),
    ])
    if (!course) throw notFound()

    const category = categoryOf(course)
    const related = catalog
      .filter(
        (item) => item.slug !== course.slug && categoryOf(item) === category,
      )
      .slice(0, 3)

    return { course, related }
  },
  head: ({ loaderData }) => {
    if (!loaderData) return {}
    const { course } = loaderData
    return seoHead({
      title: courseMetaTitle(course),
      description: courseMetaDescription(course),
      // Canonical siempre a la URL limpia: `?version=` sólo cambia la pestaña
      // seleccionada, no el contenido, y no debe generar una URL indexable
      // distinta por cada versión publicada.
      path: `/cursos/${course.slug}`,
      // Cada curso tiene ya una imagen propia en el catálogo: se reutiliza
      // como tarjeta social en vez de repetir el logotipo en todas las fichas.
      image: courseImage({ slug: course.slug, cover_storage_path: null }),
      // Las fichas de acceso por invitación no se comercializan y no
      // responden a ninguna búsqueda: se sirven, pero no se indexan.
      noindex: !isIndexableCourse(course),
    })
  },
  component: CourseDetailPage,
})

function CourseDetailPage() {
  const { courseSlug } = Route.useParams()
  const { version: requestedVersionId } = Route.useSearch()
  const { course, related } = Route.useLoaderData()

  const version =
    course.versions.find((item) => item.id === requestedVersionId) ??
    course.versions[0]

  const label = versionLabel(course, version)
  const reference = normativeReference(course)
  const faqs = courseFaqs(course)
  const category = categoryOf(course)

  const breadcrumbs: Array<BreadcrumbItem> = [
    { name: 'Inicio', path: '/' },
    { name: 'Catálogo', path: '/catalogo' },
    { name: categoryLabels[category], path: `/catalogo?categoria=${category}` },
    { name: course.title, path: `/cursos/${course.slug}` },
  ]

  return (
    <PublicLayout>
      <JsonLd
        nodes={[
          courseSchema({
            slug: course.slug,
            title: course.title,
            description: course.short_description || course.description,
            purchasable: course.access_mode === 'purchase',
            versions: course.versions.map((item) => ({
              durationHours: item.duration_hours,
              modality: item.modality,
              priceNet: item.price_net,
              currency: item.currency,
            })),
          }),
          breadcrumbSchema(breadcrumbs),
          ...(faqs.length ? [faqSchema(faqs)] : []),
        ]}
      />
      <header className="page-hero">
        <div className="container">
          <Breadcrumbs items={breadcrumbs} />
          <span className="eyebrow">{course.specialty}</span>
          <h1>{course.title}</h1>
          <p>{course.short_description}</p>
        </div>
      </header>
      <section className="section">
        <div className="container course-detail-layout">
          <article>
            <h2>Sobre esta formación</h2>
            <p className="muted" style={{ lineHeight: 1.8 }}>
              {course.description}
            </p>
            {version.objectives.length ? (
              <>
                <h2 style={{ marginTop: 42 }}>Objetivos</h2>
                <div className="form-grid">
                  {version.objectives.map((objective) => (
                    <div key={objective} style={{ display: 'flex', gap: 11 }}>
                      <CheckCircle2
                        size={19}
                        color="var(--orange)"
                        style={{ flexShrink: 0, marginTop: 2 }}
                      />
                      <span>{objective}</span>
                    </div>
                  ))}
                </div>
              </>
            ) : null}
            {version.syllabus_summary ? (
              <>
                <h2 style={{ marginTop: 42 }}>Programa</h2>
                <p
                  className="muted"
                  style={{ whiteSpace: 'pre-line', lineHeight: 1.8 }}
                >
                  {version.syllabus_summary}
                </p>
              </>
            ) : null}
            {version.target_audience.length ? (
              <>
                <h2 style={{ marginTop: 42 }}>A quién va dirigido</h2>
                <ul
                  className="muted"
                  style={{ lineHeight: 1.8, paddingLeft: 20 }}
                >
                  {version.target_audience.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ul>
              </>
            ) : null}
            {version.requirements.length ? (
              <>
                <h2 style={{ marginTop: 42 }}>Requisitos</h2>
                <ul
                  className="muted"
                  style={{ lineHeight: 1.8, paddingLeft: 20 }}
                >
                  {version.requirements.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ul>
              </>
            ) : null}
            <h2 style={{ marginTop: 42 }}>Metodología</h2>
            <p className="muted" style={{ lineHeight: 1.8 }}>
              La formación se organiza en bloques dentro del Campus. Cada bloque
              combina audio explicado, diapositivas y documentación descargable
              cuando corresponde, y tu progreso se guarda automáticamente para
              retomarlo cuando quieras. Al completar los bloques se habilita la
              evaluación final del curso.
            </p>
            <div className="modality-scope" style={{ marginTop: 36 }}>
              <h2>Modalidad y alcance de la formación</h2>
              <p>
                {modalityLabel(version.modality)} · {version.duration_hours}{' '}
                horas.
                {version.practice_required
                  ? ' Esta versión exige la práctica presencial indicada en el programa.'
                  : ' La modalidad, los requisitos prácticos y las condiciones de certificación son los definidos para esta versión.'}
              </p>
              {version.accreditation_reference ? (
                <p>{version.accreditation_reference}</p>
              ) : null}
              {isItc020102(course) ? (
                <p>
                  La {ITC_02_1_02_PRESENCIAL.source} establece que «
                  {ITC_02_1_02_PRESENCIAL.quote}»{' '}
                  <a
                    className="text-link"
                    href={ITC_02_1_02_PRESENCIAL.url}
                    rel="noreferrer noopener"
                    target="_blank"
                  >
                    Consultar en el BOE
                  </a>
                </p>
              ) : null}
              <a
                className="text-link"
                href={`/contacto?curso=${encodeURIComponent(course.slug)}`}
              >
                ¿Necesitáis modalidad o apoyo presencial?
              </a>
            </div>
            {faqs.length ? (
              <div style={{ marginTop: 42 }}>
                <h2>Preguntas frecuentes</h2>
                <dl className="course-faq">
                  {faqs.map((faq) => (
                    <div className="course-faq__item" key={faq.question}>
                      <dt>{faq.question}</dt>
                      <dd className="muted">{faq.answer}</dd>
                    </div>
                  ))}
                </dl>
              </div>
            ) : null}
          </article>
          <aside className="panel course-detail-aside">
            <div className="form-grid">
              {course.versions.length > 1 ? (
                <div className="offering-selector">
                  <span className="offering-selector__label">
                    Elige la duración
                  </span>
                  <div className="offering-selector__options">
                    {course.versions.map((option) => (
                      <Link
                        aria-current={
                          option.id === version.id ? 'true' : undefined
                        }
                        className="offering-option"
                        key={option.id}
                        params={{ courseSlug }}
                        search={{ version: option.id }}
                        to="/cursos/$courseSlug"
                      >
                        <span>
                          {option.duration_hours} horas
                          {versionLabel(course, option)
                            ? ` · ${option.duration_hours <= 5 ? 'Reciclaje' : 'Formación inicial'}`
                            : ''}
                        </span>
                        <strong>
                          {formatCurrency(option.price_net, option.currency)}
                        </strong>
                      </Link>
                    ))}
                  </div>
                </div>
              ) : null}
              <span className="status status--orange">
                {label
                  ? `${label} · ${modalityLabel(version.modality)}`
                  : modalityLabel(version.modality)}
              </span>
              <div style={{ display: 'flex', gap: 11 }}>
                <CalendarClock size={20} color="var(--orange)" />
                <span>{version.duration_hours} horas</span>
              </div>
              <div style={{ display: 'flex', gap: 11 }}>
                <MapPin size={20} color="var(--orange)" />
                <span>
                  {version.practice_required
                    ? 'Incluye práctica presencial obligatoria'
                    : 'Consulta la modalidad en el programa'}
                </span>
              </div>
              <div style={{ display: 'flex', gap: 11 }}>
                <BadgeCheck size={20} color="var(--orange)" />
                <span>
                  {version.accreditation_reference ||
                    'Evaluación y trazabilidad del progreso'}
                </span>
              </div>
              {version.renewal_interval_months ? (
                <div style={{ display: 'flex', gap: 11 }}>
                  <CalendarClock size={20} color="var(--orange)" />
                  <span>
                    Renovación máxima cada {version.renewal_interval_months}{' '}
                    meses
                  </span>
                </div>
              ) : null}
              <hr
                style={{
                  width: '100%',
                  border: 0,
                  borderTop: '1px solid var(--line)',
                }}
              />
              {course.access_mode === 'access_code' ? (
                <>
                  <strong style={{ fontSize: '1.25rem' }}>
                    Acceso con invitación
                  </strong>
                  <p className="muted">
                    Esta formación no se comercializa. El acceso se obtiene
                    únicamente con la invitación personal que facilita
                    administración, identificada mediante un código de acceso.
                  </p>
                  <Link
                    className="button button--primary button--wide"
                    to="/canjear-codigo"
                  >
                    Canjear invitación
                  </Link>
                </>
              ) : (
                <>
                  <strong style={{ fontSize: '1.5rem' }}>
                    {formatCurrency(version.price_net, version.currency)}
                    {version.price_net !== null ? (
                      <small
                        className="muted"
                        style={{ fontSize: '.75rem', marginLeft: 6 }}
                      >
                        + IVA
                      </small>
                    ) : null}
                  </strong>
                  <Link
                    className="button button--primary button--wide"
                    to="/comprar/$courseSlug"
                    params={{ courseSlug }}
                    search={{ version: version.id }}
                  >
                    Comprar para mí
                  </Link>
                  <Link
                    className="button button--outline button--wide"
                    to="/comprar-empresa/$courseSlug"
                    params={{ courseSlug }}
                    search={{ version: version.id }}
                  >
                    Comprar para una empresa
                  </Link>
                </>
              )}
            </div>
          </aside>
        </div>
      </section>
      {related.length ? (
        <section className="section">
          <div className="container">
            <h2>Formación relacionada</h2>
            <p className="muted">
              Otros programas de {categoryLabels[category].toLocaleLowerCase('es')}{' '}
              {reference ? 'dentro del mismo marco normativo' : 'del catálogo'}.
            </p>
            <div className="course-grid">
              {related.map((item) => (
                <CourseCard course={toCardCourse(item)} key={item.slug} />
              ))}
            </div>
          </div>
        </section>
      ) : null}
    </PublicLayout>
  )
}

/** Adapta una ficha completa a la forma resumida que espera `CourseCard`. */
function toCardCourse(course: PublicCourseDetail): PublicCourse {
  const version = course.versions[0]
  return {
    id: course.id,
    slug: course.slug,
    title: course.title,
    short_description: course.short_description,
    specialty: course.specialty,
    cover_storage_path: null,
    access_mode: course.access_mode,
    versionId: version.id,
    versionNumber: version.version_number,
    duration_hours: version.duration_hours,
    modality: version.modality,
    price_net: version.price_net,
    currency: version.currency,
  }
}
