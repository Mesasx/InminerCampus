import { createFileRoute, Link, notFound } from '@tanstack/react-router'
import {
  BadgeCheck,
  CalendarClock,
  ShieldCheck,
} from 'lucide-react'
import { Breadcrumbs } from '../components/Breadcrumbs'
import { CourseCard } from '../components/CourseCard'
import { CourseInquiryButton } from '../components/CourseInquiryButton'
import { JsonLd } from '../components/JsonLd'
import { PublicLayout } from '../components/PublicLayout'
import { categoryLabels, categoryOf } from '../lib/course-category'
import { courseSocialImage } from '../lib/course-image'
import {
  courseMetaDescription,
  courseMetaTitle,
  normativeReference,
  versionLabel,
} from '../lib/course-seo'
import { refresherRuleFor, specificationsIn } from '../lib/mining-regulation'
import {
  fetchPublicCourse,
  fetchPublicCourses,
  isIndexableCourse,
  type PublicCourseDetail,
} from '../lib/public-courses'
import {
  breadcrumbSchema,
  courseSchema,
  type BreadcrumbItem,
} from '../lib/schema'
import { GUIDE_PATHS } from '../lib/public-routes'
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
      image: courseSocialImage({ slug: course.slug, cover_storage_path: null }),
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
            versions: course.versions.map((item) => ({
              durationHours: item.duration_hours,
            })),
            image: courseSocialImage({ slug: course.slug, cover_storage_path: null }),
            normativeReference: reference,
          }),
          breadcrumbSchema(breadcrumbs),
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
            <div className="modality-scope" style={{ marginTop: 36 }}>
              <h2>Acceso y alcance</h2>
              <p>
                Esta ficha es una introducción pública. El programa completo,
                los materiales, las evaluaciones y las condiciones concretas de
                la acción formativa sólo están disponibles para personas cuya
                cuenta haya sido validada por Inmíner y que cuenten con la
                autorización correspondiente.
              </p>
              {version.accreditation_reference ? (
                <p>{version.accreditation_reference}</p>
              ) : null}
              <CourseInquiryButton
                className="button button--primary"
                durationHours={version.duration_hours}
                reference={version.accreditation_reference}
                title={course.title}
              />
            </div>
            <CourseRegulationSection
              reference={reference ?? course.specialty}
            />
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
                        // La versión por defecto se enlaza con la URL limpia
                        // (canónica); sólo las demás añaden `?version=`.
                        search={
                          option.id === course.versions[0].id
                            ? { version: undefined }
                            : { version: option.id }
                        }
                        // Comparación exacta de la búsqueda: sin ella, el
                        // enlace limpio contaría como activo también en
                        // `?version=…` y se marcarían las dos opciones.
                        activeOptions={{ exact: true, explicitUndefined: true }}
                        to="/cursos/$courseSlug"
                      >
                        <span>
                          {option.duration_hours} horas
                          {versionLabel(course, option)
                            ? ` · ${option.duration_hours <= 5 ? 'Reciclaje' : 'Formación inicial'}`
                            : ''}
                        </span>
                        <strong>Consultar</strong>
                      </Link>
                    ))}
                  </div>
                </div>
              ) : null}
              <span className="status status--orange">
                {label || 'Programa formativo'}
              </span>
              <div style={{ display: 'flex', gap: 11 }}>
                <CalendarClock size={20} color="var(--orange)" />
                <span>{version.duration_hours} horas</span>
              </div>
              <div style={{ display: 'flex', gap: 11 }}>
                <ShieldCheck size={20} color="var(--orange)" />
                <span>Acceso privado con validación administrativa</span>
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
              <strong style={{ fontSize: '1.25rem' }}>
                Información y acceso personal
              </strong>
              <p className="muted">
                Inmíner revisa cada solicitud y confirma de forma individual
                el alcance y los requisitos antes de habilitar una cuenta.
              </p>
              <CourseInquiryButton
                className="button button--primary button--wide"
                durationHours={version.duration_hours}
                reference={version.accreditation_reference}
                title={course.title}
              />
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
    accreditation_reference: version.accreditation_reference,
    cover_storage_path: null,
    access_mode: course.access_mode,
    versionId: version.id,
    versionNumber: version.version_number,
    isDefaultVersion: true,
    duration_hours: version.duration_hours,
    modality: version.modality,
    price_net: version.price_net,
    currency: version.currency,
  }
}

/**
 * Marco normativo del puesto: qué especificación técnica aplica, qué puestos
 * y máquinas cubre y cada cuánto hay que actualizar la formación. Todo sale de
 * `mining-regulation.ts`, de modo que cada ficha tiene contenido propio y
 * verificable sin escribir nada a mano en Supabase.
 */
function CourseRegulationSection({ reference }: { reference: string | null }) {
  const specs = specificationsIn(reference).filter(
    (spec) => spec.code !== 'ET 2005-1-11',
  )
  const rule = refresherRuleFor(reference)
  if (!specs.length && !rule) return null

  return (
    <div style={{ marginTop: 42 }}>
      <h2>Marco normativo del puesto</h2>
      {specs.map((spec) => (
        <div key={spec.code} style={{ marginBottom: 14 }}>
          <h3 style={{ fontSize: '1.05rem', marginBottom: 6 }}>
            <a href={spec.url} rel="noopener noreferrer" target="_blank">
              {spec.code}
            </a>{' '}
            · {spec.title}
          </h3>
          <p className="muted" style={{ lineHeight: 1.8 }}>
            Cubre: {spec.scope.replace(/^[A-ZÁÉÍÓÚ]/, (letter) => letter.toLocaleLowerCase('es'))}{' '}
            Aprobada por {spec.instrument.replace(/^R/, 'r')}.
          </p>
        </div>
      ))}
      {rule ? (
        <p className="muted" style={{ lineHeight: 1.8 }}>
          {rule.basis === 'silica'
            ? `La ${rule.source} obliga a repetir esta formación al menos una vez al año.`
            : rule.basis === 'specification'
              ? `Actualización o reciclaje: como máximo cada ${rule.years} años, según la ${rule.source}.`
              : `Actualización o reciclaje: con la periodicidad que fije la especificación técnica del puesto, nunca superior a ${rule.years} años (${rule.source}).`}{' '}
          <Link className="text-link" to={GUIDE_PATHS.refresherCalculator}>
            Calcula cuándo vence tu formación
          </Link>
          .
        </p>
      ) : null}
    </div>
  )
}
