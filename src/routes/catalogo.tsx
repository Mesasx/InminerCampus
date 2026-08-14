import { createFileRoute, Link } from '@tanstack/react-router'
import { BookOpen, SlidersHorizontal } from 'lucide-react'
import { useState } from 'react'
import { PublicLayout } from '../components/PublicLayout'
import { usePublicCourses } from '../hooks/usePublicCourses'
import { formatCurrency, modalityLabel } from '../lib/format'

export const Route = createFileRoute('/catalogo')({
  component: CatalogPage,
})

function CatalogPage() {
  const { courses, loading, loadError } = usePublicCourses()
  const [duration, setDuration] = useState<'all' | '5' | '20'>('all')
  const [query, setQuery] = useState('')

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
