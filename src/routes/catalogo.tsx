import { createFileRoute, Link, useNavigate } from '@tanstack/react-router'
import { BookOpen, SlidersHorizontal } from 'lucide-react'
import { useState } from 'react'
import { CourseCard } from '../components/CourseCard'
import { PublicLayout } from '../components/PublicLayout'
import { categoryLabels, categoryOf, type CourseCategory } from '../lib/course-category'
import { usePublicCourses } from '../hooks/usePublicCourses'

export const Route = createFileRoute('/catalogo')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { categoria?: CourseCategory } => ({
    categoria:
      search.categoria === 'mineria' || search.categoria === 'otros'
        ? search.categoria
        : undefined,
  }),
  component: CatalogPage,
})

const categoryFilters: Array<CourseCategory> = ['mineria', 'otros']

function CatalogPage() {
  const { categoria } = Route.useSearch()
  const navigate = useNavigate({ from: Route.fullPath })
  const { courses, loading, loadError } = usePublicCourses()
  const [duration, setDuration] = useState<'all' | '5' | '20'>('all')
  const [query, setQuery] = useState('')

  const filtered = courses.filter((course) => {
    const matchesCategory = !categoria || categoryOf(course) === categoria
    const matchesDuration =
      duration === 'all' || String(course.duration_hours) === duration
    const normalizedQuery = query.trim().toLocaleLowerCase('es')
    const matchesQuery =
      !normalizedQuery ||
      course.title.toLocaleLowerCase('es').includes(normalizedQuery) ||
      course.short_description
        ?.toLocaleLowerCase('es')
        .includes(normalizedQuery)
    return matchesCategory && matchesDuration && matchesQuery
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
          <div className="category-filters" role="group" aria-label="Filtrar por categoría">
            <button
              className={`category-filter${!categoria ? ' category-filter--active' : ''}`}
              onClick={() => navigate({ search: {} })}
              type="button"
            >
              Todos
            </button>
            {categoryFilters.map((item) => (
              <button
                key={item}
                className={`category-filter category-filter--${item}${
                  categoria === item ? ' category-filter--active' : ''
                }`}
                onClick={() => navigate({ search: { categoria: item } })}
                type="button"
              >
                {categoryLabels[item]}
              </button>
            ))}
          </div>

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
                <CourseCard course={course} key={course.versionId} />
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
