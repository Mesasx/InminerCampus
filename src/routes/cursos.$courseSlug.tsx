import { createFileRoute, Link } from '@tanstack/react-router'
import {
  BadgeCheck,
  CalendarClock,
  CheckCircle2,
  MapPin,
} from 'lucide-react'
import { useEffect, useState } from 'react'
import { PublicLayout } from '../components/PublicLayout'
import { formatCurrency, modalityLabel } from '../lib/format'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/cursos/$courseSlug')({
  component: CourseDetailPage,
})

type CourseDetail = {
  id: string
  slug: string
  title: string
  short_description: string
  description: string
  specialty: string
  version: {
    id: string
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
}

function CourseDetailPage() {
  const { courseSlug } = Route.useParams()
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

      const { data } = await supabase
        .from('courses')
        .select(
          'id, slug, title, short_description, description, specialty, course_versions!inner(id, duration_hours, modality, objectives, target_audience, requirements, syllabus_summary, practice_required, price_net, tax_rate, currency, version_number)',
        )
        .eq('slug', courseSlug)
        .eq('status', 'published')
        .eq('course_versions.status', 'published')
        .order('version_number', {
          referencedTable: 'course_versions',
          ascending: false,
        })
        .limit(1, { referencedTable: 'course_versions' })
        .maybeSingle()

      if (!active) return
      if (data) {
        const raw = data as unknown as Omit<CourseDetail, 'version'> & {
          course_versions: CourseDetail['version'][]
        }
        setCourse({ ...raw, version: raw.course_versions[0] })
      }
      setLoading(false)
    }

    void loadCourse()
    return () => {
      active = false
    }
  }, [courseSlug])

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
          className="container"
          style={{
            display: 'grid',
            gridTemplateColumns: 'minmax(0,1fr) 350px',
            gap: 56,
            alignItems: 'start',
          }}
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
          <aside className="panel" style={{ position: 'sticky', top: 110 }}>
            <div className="form-grid">
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
              <strong style={{ fontSize: '1.5rem' }}>
                {formatCurrency(version.price_net, version.currency)}
                {version.price_net !== null ? (
                  <small className="muted" style={{ fontSize: '.75rem', marginLeft: 6 }}>
                    + IVA
                  </small>
                ) : null}
              </strong>
              <Link
                className="button button--primary button--wide"
                to="/comprar/$courseSlug"
                params={{ courseSlug }}
              >
                Matricularme
              </Link>
              <Link
                className="button button--outline button--wide"
                to="/comprar-empresa/$courseSlug"
                params={{ courseSlug }}
              >
                Comprar para empresa
              </Link>
            </div>
          </aside>
        </div>
      </section>
    </PublicLayout>
  )
}
