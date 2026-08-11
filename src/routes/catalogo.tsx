import { createFileRoute, Link } from '@tanstack/react-router'
import { BookOpen, SlidersHorizontal } from 'lucide-react'
import { useEffect, useState } from 'react'
import { PublicLayout } from '../components/PublicLayout'
import {
  isCourseVisibleInCatalog,
  isMissingCourseAccessColumnsError,
} from '../lib/course-access'
import { formatCurrency, modalityLabel } from '../lib/format'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { CourseModality, PublicCourse } from '../lib/types'

export const Route = createFileRoute('/catalogo')({
  component: CatalogPage,
})

type VersionRow = {
  id: string
  version_number: number
  duration_hours: number
  modality: CourseModality
  price_net: number | string | null
  currency: string
  courses: {
    id: string
    slug: string
    title: string
    short_description: string | null
    cover_storage_path: string | null
    access_mode?: 'purchase' | 'access_code'
    listed?: boolean
  }
}

function CatalogPage() {
  const [courses, setCourses] = useState<PublicCourse[]>([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(false)
  const [duration, setDuration] = useState<'all' | '5' | '20'>('all')
  const [query, setQuery] = useState('')

  useEffect(() => {
    let active = true

    async function loadCourses() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) {
        setLoading(false)
        return
      }

      const currentSchemaResult = await supabase
        .from('course_versions')
        .select(
          'id, version_number, duration_hours, modality, price_net, currency, courses!inner(id, slug, title, short_description, cover_storage_path, access_mode, listed)',
        )
        .eq('status', 'published')
        .eq('courses.status', 'published')
        .order('duration_hours')

      let data: unknown = currentSchemaResult.data
      let error = currentSchemaResult.error

      if (isMissingCourseAccessColumnsError(error)) {
        const legacySchemaResult = await supabase
          .from('course_versions')
          .select(
            'id, version_number, duration_hours, modality, price_net, currency, courses!inner(id, slug, title, short_description, cover_storage_path)',
          )
          .eq('status', 'published')
          .eq('courses.status', 'published')
          .order('duration_hours')

        data = legacySchemaResult.data
        error = legacySchemaResult.error
      }

      if (!active) return
      if (error) {
        console.error('No se ha podido cargar el catálogo de cursos.', error)
        setLoadError(true)
        setLoading(false)
        return
      }
      const mapped = ((data ?? []) as unknown as VersionRow[])
        .filter((row) => isCourseVisibleInCatalog(row.courses))
        .map((row) => ({
          ...row.courses,
          access_mode: row.courses.access_mode ?? 'purchase',
          versionId: row.id,
          versionNumber: row.version_number,
          duration_hours: row.duration_hours,
          modality: row.modality,
          price_net:
            row.price_net === null
              ? null
              : Number.parseFloat(String(row.price_net)),
          currency: row.currency,
        }))
      setCourses(mapped)
      setLoadError(false)
      setLoading(false)
    }

    void loadCourses()
    return () => {
      active = false
    }
  }, [])

  const filtered = courses.filter((course) => {
    const matchesDuration =
      duration === 'all' || String(course.duration_hours) === duration
    const normalizedQuery = query.trim().toLocaleLowerCase('es')
    const matchesQuery =
      !normalizedQuery ||
      course.title.toLocaleLowerCase('es').includes(normalizedQuery) ||
      course.short_description
        ?.toLocaleLowerCase('es')
        .includes(normalizedQuery)
    return matchesDuration && matchesQuery
  })

  return (
    <PublicLayout>
      <header className="page-hero">
        <div className="container">
          <span className="eyebrow">Catálogo formativo</span>
          <h1>Formación técnica para avanzar con seguridad.</h1>
          <p>
            Consulta los programas disponibles. Cada ficha identifica la ITC,
            la especificación técnica, la modalidad y las prácticas aplicables.
          </p>
        </div>
      </header>
      <section className="section">
        <div className="container">
          <div
            className="panel"
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr minmax(180px, 240px)',
              gap: 16,
              marginBottom: 28,
            }}
          >
            <div className="field">
              <label htmlFor="catalog-search">Buscar curso</label>
              <input
                id="catalog-search"
                type="search"
                placeholder="Nombre o especialidad"
                value={query}
                onChange={(event) => setQuery(event.target.value)}
              />
            </div>
            <div className="field">
              <label htmlFor="duration-filter">
                <SlidersHorizontal size={14} /> Duración
              </label>
              <select
                id="duration-filter"
                value={duration}
                onChange={(event) =>
                  setDuration(event.target.value as 'all' | '5' | '20')
                }
              >
                <option value="all">Todas</option>
                <option value="5">5 horas</option>
                <option value="20">20 horas</option>
              </select>
            </div>
          </div>

          {loading ? (
            <div className="empty-state" aria-live="polite">
              <div>
                <div className="empty-state__icon">
                  <BookOpen size={25} />
                </div>
                <h2>Cargando catálogo</h2>
                <p>Estamos consultando la oferta formativa disponible.</p>
              </div>
            </div>
          ) : loadError ? (
            <div className="empty-state" role="alert">
              <div>
                <div className="empty-state__icon">
                  <BookOpen size={25} />
                </div>
                <h2>No se ha podido cargar el catálogo</h2>
                <p>Actualiza la página o inténtalo de nuevo en unos minutos.</p>
              </div>
            </div>
          ) : filtered.length ? (
            <div className="course-grid">
              {filtered.map((course) => (
                <article className="course-card" key={course.versionId}>
                  <div
                    className="course-card__visual"
                    style={
                      course.cover_storage_path?.startsWith('/')
                        ? {
                            backgroundImage: `url(${course.cover_storage_path})`,
                            backgroundSize: 'cover',
                            backgroundPosition: 'center',
                          }
                        : undefined
                    }
                  >
                    <span className="course-card__hours">
                      {course.duration_hours} h
                    </span>
                    <span>{modalityLabel(course.modality)}</span>
                  </div>
                  <div className="course-card__body">
                    <h3>{course.title}</h3>
                    <p>{course.short_description}</p>
                    <div className="course-card__footer">
                      <span>
                        {course.access_mode === 'access_code'
                          ? 'Solo con invitación'
                          : formatCurrency(course.price_net, course.currency)}
                      </span>
                      <Link
                        className="text-link"
                        to="/cursos/$courseSlug"
                        params={{ courseSlug: course.slug }}
                        search={{ version: course.versionId }}
                      >
                        Ver curso →
                      </Link>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          ) : (
            <div className="empty-state">
              <div>
                <div className="empty-state__icon">
                  <BookOpen size={25} />
                </div>
                <h2>No hay cursos que coincidan</h2>
                <p>
                  Prueba con otros filtros. Si el catálogo aún no está publicado,
                  puedes solicitar información a nuestro equipo.
                </p>
                <Link className="button button--outline" to="/contacto">
                  Solicitar información
                </Link>
              </div>
            </div>
          )}
        </div>
      </section>
    </PublicLayout>
  )
}
