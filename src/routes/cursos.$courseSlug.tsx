import { createFileRoute, Link } from '@tanstack/react-router'
import {
  BadgeCheck,
  CalendarClock,
  CheckCircle2,
  MapPin,
} from 'lucide-react'
import { useEffect, useState } from 'react'
import { PublicLayout } from '../components/PublicLayout'
import { isMissingCourseAccessColumnsError } from '../lib/course-access'
import { formatCurrency, modalityLabel } from '../lib/format'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/cursos/$courseSlug')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { version?: string } => ({
    version:
      typeof search.version === 'string' && search.version.trim()
        ? search.version
        : undefined,
  }),
  component: CourseDetailPage,
})

type CourseVersion = {
  id: string
  version_number: number
  duration_hours: number
  modality: string
  objectives: string[]
  target_audience: string[]
  requirements: string[]
  syllabus_summary: string
  practice_required: boolean
  price_net: number | null
  tax_rate: number
  currency: string
}

type CourseDetail = {
  id: string
  slug: string
  title: string
  short_description: string
  description: string
  specialty: string
  access_mode: 'purchase' | 'access_code'
  cover_storage_path: string | null
  versions: CourseVersion[]
  version: CourseVersion
}

function CourseDetailPage() {
  const { courseSlug } = Route.useParams()
  const { version: requestedVersionId } = Route.useSearch()
  const [course, setCourse] = useState<CourseDetail | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true

    async function loadCourse() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) {
        setLoading(false)
        return
      }

      const currentSchemaResult = await supabase
        .from('courses')
        .select(
          'id, slug, title, short_description, description, specialty, access_mode, cover_storage_path, course_versions!inner(id, duration_hours, modality, objectives, target_audience, requirements, syllabus_summary, practice_required, price_net, tax_rate, currency, version_number)',
        )
        .eq('slug', courseSlug)
        .eq('status', 'published')
        .eq('course_versions.status', 'published')
        .order('version_number', {
          referencedTable: 'course_versions',
          ascending: false,
        })
        .maybeSingle()

      let data: unknown = currentSchemaResult.data
      let error = currentSchemaResult.error

      if (isMissingCourseAccessColumnsError(error)) {
        const legacySchemaResult = await supabase
          .from('courses')
          .select(
            'id, slug, title, short_description, description, specialty, cover_storage_path, course_versions!inner(id, duration_hours, modality, objectives, target_audience, requirements, syllabus_summary, practice_required, price_net, tax_rate, currency, version_number)',
          )
          .eq('slug', courseSlug)
          .eq('status', 'published')
          .eq('course_versions.status', 'published')
          .order('version_number', {
            referencedTable: 'course_versions',
            ascending: false,
          })
          .maybeSingle()

        data = legacySchemaResult.data
        error = legacySchemaResult.error
      }

      if (!active) return
      if (error) {
        console.error('No se ha podido cargar el curso.', error)
      }
      if (data) {
        const raw = data as unknown as Omit<
          CourseDetail,
          'access_mode' | 'version' | 'versions'
        > & {
          access_mode?: CourseDetail['access_mode']
          course_versions: CourseVersion[]
        }
        const selectedVersion =
          raw.course_versions.find(
            (version) => version.id === requestedVersionId,
          ) ?? raw.course_versions[0]
        if (selectedVersion) {
          setCourse({
            ...raw,
            access_mode: raw.access_mode ?? 'purchase',
            versions: raw.course_versions,
            version: selectedVersion,
          })
        }
      }
      setLoading(false)
    }

    void loadCourse()
    return () => {
      active = false
    }
  }, [courseSlug, requestedVersionId])

  if (loading) {
    return (
      <PublicLayout>
        <section className="container section">
          <div className="empty-state">
            <p>Cargando la información del curso…</p>
          </div>
        </section>
      </PublicLayout>
    )
  }

  if (!course) {
    return (
      <PublicLayout>
        <section className="container section">
          <div className="empty-state">
            <div>
              <h1>Curso no disponible</h1>
              <p>
                El curso no existe o todavía no está publicado en el catálogo.
              </p>
              <Link className="button button--outline" to="/catalogo">
                Volver al catálogo
              </Link>
            </div>
          </div>
        </section>
      </PublicLayout>
    )
  }

  const version = course.version

  return (
    <PublicLayout>
      <header className="page-hero">
        <div className="container">
          <span className="eyebrow">{course.specialty}</span>
          <h1>{course.title}</h1>
          <p>{course.short_description}</p>
        </div>
      </header>
      <section className="section">
        <div
          className="container course-detail-layout"
        >
          <article>
            <h2>Sobre esta formación</h2>
            <p className="muted" style={{ lineHeight: 1.8 }}>
              {course.description}
            </p>
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
            {version.syllabus_summary ? (
              <>
                <h2 style={{ marginTop: 42 }}>Programa</h2>
                <p className="muted" style={{ whiteSpace: 'pre-line', lineHeight: 1.8 }}>
                  {version.syllabus_summary}
                </p>
              </>
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
                        <span>{option.duration_hours} horas</span>
                        <strong>
                          {formatCurrency(option.price_net, option.currency)}
                        </strong>
                      </Link>
                    ))}
                  </div>
                </div>
              ) : null}
              <span className="status status--orange">
                {modalityLabel(version.modality)}
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
                <span>Evaluación y trazabilidad del progreso</span>
              </div>
              <hr style={{ width: '100%', border: 0, borderTop: '1px solid var(--line)' }} />
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
                    Matricularme
                  </Link>
                  <Link
                    className="button button--outline button--wide"
                    to="/comprar-empresa/$courseSlug"
                    params={{ courseSlug }}
                    search={{ version: version.id }}
                  >
                    Comprar para empresa
                  </Link>
                </>
              )}
            </div>
          </aside>
        </div>
      </section>
    </PublicLayout>
  )
}
