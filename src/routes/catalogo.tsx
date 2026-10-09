import { createFileRoute, Link, useNavigate } from '@tanstack/react-router'
import { BookOpen, Search, SlidersHorizontal, X } from 'lucide-react'
import { useState } from 'react'
import { Breadcrumbs } from '../components/Breadcrumbs'
import { CourseCard } from '../components/CourseCard'
import { JsonLd } from '../components/JsonLd'
import { PublicLayout } from '../components/PublicLayout'
import {
  categoryLabels,
  categoryOf,
  sameAsFullCatalog,
  type CourseCategory,
} from '../lib/course-category'
import { matchesQuery } from '../lib/course-search'
import { fetchPublicCourses, toCourseCards } from '../lib/public-courses'
import { GUIDE_PATHS } from '../lib/public-routes'
import {
  breadcrumbSchema,
  itemListSchema,
  type BreadcrumbItem,
} from '../lib/schema'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/catalogo')({
  validateSearch: (
    search: Record<string, unknown>,
  ): { categoria?: CourseCategory } => ({
    categoria:
      search.categoria === 'mineria' || search.categoria === 'otros'
        ? search.categoria
        : undefined,
  }),
  // El catálogo se resuelve en el servidor: hasta ahora el HTML inicial no
  // contenía ni un solo enlace a `/cursos/...`, así que las fichas quedaban
  // huérfanas para cualquier rastreador que no ejecutase JavaScript.
  loader: async () => ({ courses: toCourseCards(await fetchPublicCourses()) }),
  head: ({ loaderData, match }) => {
    const categoria = (match.search as { categoria?: CourseCategory })
      .categoria
    const meta = categoria ? categoryMeta[categoria] : catalogMeta
    return seoHead({
      title: meta.title,
      description: meta.description,
      // Los filtros son vistas del mismo catálogo: cada categoría declara su
      // propia canónica con el parámetro, y el resto de combinaciones
      // (búsqueda, duración) se resuelven en cliente sin cambiar la URL.
      // Si la categoría lista exactamente lo mismo que el catálogo completo
      // (hoy todos los cursos publicados son de minería), sería una copia:
      // entonces declara como canónica la URL del catálogo.
      path:
        categoria &&
        !(loaderData && sameAsFullCatalog(loaderData.courses, categoria))
          ? `/catalogo?categoria=${categoria}`
          : '/catalogo',
      // Una categoría sin cursos publicados es una página vacía: se sirve, pero
      // no se indexa. El catálogo cambia con el tiempo y una categoría puede
      // quedarse sin programas sin que eso deba dejar una URL pobre en Google.
      // Sin datos del loader no se decide nada: marcar `noindex` a ciegas
      // desindexaría una categoría que sí tiene cursos.
      noindex: Boolean(
        categoria &&
          loaderData &&
          !loaderData.courses.some((course) => categoryOf(course) === categoria),
      ),
    })
  },
  component: CatalogPage,
})

const catalogMeta = {
  title: 'Cursos de minería y formación preventiva ITC',
  description:
    'Cursos de formación preventiva minera en España: maquinaria, perforación, plantas de beneficio y personal de centros mineros. ITC 02.1.02 e ITC 02.0.02.',
}

const categoryMeta: Record<CourseCategory, { title: string; description: string }> = {
  mineria: {
    title: 'Cursos de formación preventiva para minería',
    description:
      'Formación preventiva para operadores de maquinaria y trabajadores de actividades extractivas: ITC 02.1.02 por puesto e ITC 02.0.02 de polvo y sílice.',
  },
  otros: {
    title: 'Otra formación técnica',
    description:
      'Programas de formación técnica de Inmíner Ingeniería que no se encuadran en la normativa de seguridad minera.',
  },
}

const allCategories: Array<CourseCategory> = ['mineria', 'otros']

// H1 propio por categoría: la vista filtrada es una URL indexable distinta y
// necesita un encabezado que describa exactamente lo que lista.
const categoryHeadings: Record<CourseCategory, string> = {
  mineria: 'Cursos de formación preventiva para minería y actividades extractivas.',
  otros: 'Otra formación técnica de Inmíner Ingeniería.',
}

function CatalogPage() {
  const { categoria } = Route.useSearch()
  const navigate = useNavigate({ from: Route.fullPath })
  const { courses } = Route.useLoaderData()
  const [duration, setDuration] = useState<'all' | '5' | '20'>('all')
  const [query, setQuery] = useState('')

  // Sólo se ofrecen las categorías que tienen algún programa publicado. Un
  // botón que siempre lleva a un listado vacío no ayuda a nadie, y el catálogo
  // se queda sin categorías a medida que los cursos se reclasifican. La
  // categoría pedida por URL se mantiene visible aunque esté vacía, para que el
  // filtro activo no desaparezca de debajo del usuario.
  const categoryFilters = allCategories.filter(
    (item) =>
      item === categoria || courses.some((course) => categoryOf(course) === item),
  )

  const breadcrumbs: Array<BreadcrumbItem> = [
    { name: 'Inicio', path: '/' },
    { name: 'Catálogo', path: '/catalogo' },
    ...(categoria
      ? [
          {
            name: categoryLabels[categoria],
            path: `/catalogo?categoria=${categoria}`,
          },
        ]
      : []),
  ]

  // Se busca sobre lo que el alumno tiene delante en la ficha: el nombre, la
  // descripción, la especialidad y la referencia normativa.
  const filtered = courses.filter((course) => {
    const matchesCategory = !categoria || categoryOf(course) === categoria
    const matchesDuration =
      duration === 'all' || String(course.duration_hours) === duration
    return matchesCategory && matchesDuration && matchesQuery(course, query)
  })

  const resultsLabel =
    filtered.length === 1 ? '1 curso disponible' : `${filtered.length} cursos disponibles`

  return (
    <PublicLayout>
      <JsonLd
        nodes={[
          breadcrumbSchema(breadcrumbs),
          // Una entrada por curso (no por versión), con la URL canónica de la
          // ficha: es la lista que puede alimentar el carrusel de cursos.
          itemListSchema(
            'Cursos de InmínerCampus',
            [...new Map(
              courses
                .filter((course) => !categoria || categoryOf(course) === categoria)
                .filter((course) => course.access_mode !== 'access_code')
                .map((course) => [course.slug, course]),
            ).values()].map((course) => ({
              name: course.title,
              path: `/cursos/${course.slug}`,
            })),
          ),
        ]}
      />
      <header className="page-hero">
        <div className="container">
          <Breadcrumbs items={breadcrumbs} />
          <span className="eyebrow">Catálogo formativo</span>
          <h1>{categoria ? categoryHeadings[categoria] : 'Cursos de minería y formación preventiva.'}</h1>
          <p>
            Consulta los programas disponibles. Cada ficha identifica la ITC,
            la especificación técnica, la modalidad y las prácticas aplicables.
            ¿No sabes qué formación corresponde a tu puesto? Consulta la{' '}
            <Link className="text-link" to={GUIDE_PATHS.hub}>
              guía de formación minera
            </Link>
            .
          </p>
          <p className="muted">
            ¿Ya tienes un código de acceso de tu empresa?{' '}
            <Link className="text-link" to="/canjear-codigo">
              Canjéalo aquí
            </Link>
            .
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

          <div className="catalog-search">
            <div className="catalog-search__field">
              <Search
                aria-hidden="true"
                className="catalog-search__icon"
                size={18}
              />
              <input
                id="catalog-search"
                type="search"
                aria-label="Buscar curso por nombre, especialidad o normativa"
                autoComplete="off"
                placeholder="Buscar por nombre, especialidad o normativa"
                value={query}
                onChange={(event) => setQuery(event.target.value)}
              />
              {query ? (
                <button
                  className="catalog-search__clear"
                  type="button"
                  aria-label="Borrar la búsqueda"
                  onClick={() => setQuery('')}
                >
                  <X size={16} />
                </button>
              ) : null}
            </div>
            <div className="catalog-search__duration">
              <label htmlFor="duration-filter">
                <SlidersHorizontal aria-hidden="true" size={14} /> Duración
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

          {/* El recuento se anuncia para que quien navegue con lector de
              pantalla sepa que la lista ha cambiado al escribir. */}
          {/* Encabezado de la lista: las tarjetas usan H3 y necesitan un H2
              por encima para que la jerarquía no salte niveles. */}
          <h2 className="visually-hidden">Cursos disponibles</h2>
          <p className="catalog-search__count" role="status">
            {resultsLabel}
          </p>

          {filtered.length ? (
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
