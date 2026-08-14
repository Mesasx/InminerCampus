import { useEffect, useRef, useState } from 'react'
import { createFileRoute, Link } from '@tanstack/react-router'
import { ArrowDown, ArrowRight } from 'lucide-react'
import { PublicLayout } from '../components/PublicLayout'
import { usePublicCourses } from '../hooks/usePublicCourses'
import { modalityLabel } from '../lib/format'
import type { PublicCourse } from '../lib/types'

const heroImage = '/images/hero-inminer-campus.jpg'

export const Route = createFileRoute('/')({
  head: () => ({
    links: [{ rel: 'preload', as: 'image', href: heroImage }],
  }),
  component: HomePage,
})

const editorialImagesBySlug: Record<string, string> = {
  'operador-maquinaria-arranque-carga-viales':
    '/images/campus-carousel-operacion.jpg',
  'operador-maquinaria-transporte-camion-volquete':
    '/images/campus-carousel-inspeccion.jpg',
  'prevencion-polvo-silice-cristalina-respirable':
    '/images/campus-carousel-silice.jpg',
  'formacion-stvh': '/images/curso-stvh-portada.jpg',
}

function courseImage(course: PublicCourse) {
  if (course.cover_storage_path?.startsWith('/')) {
    return course.cover_storage_path
  }

  return editorialImagesBySlug[course.slug] ?? '/images/inminer-campus-hero-engineering.png'
}

function CourseEditorialSlide({
  course,
  index,
  total,
}: {
  course: PublicCourse
  index: number
  total: number
}) {
  const sectionRef = useRef<HTMLElement>(null)
  const [isVisible, setIsVisible] = useState(false)

  useEffect(() => {
    const section = sectionRef.current
    if (!section) return

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true)
          observer.disconnect()
        }
      },
      { threshold: 0.24 },
    )

    observer.observe(section)
    return () => observer.disconnect()
  }, [])

  const position = String(index + 1).padStart(2, '0')
  const count = String(total).padStart(2, '0')

  return (
    <section
      className={`course-editorial${isVisible ? ' is-visible' : ''}`}
      data-tone={index % 2 === 0 ? 'dark' : 'warm'}
      ref={sectionRef}
    >
      <img
        alt={`Imagen del curso ${course.title}`}
        className="course-editorial__image"
        decoding="async"
        loading="lazy"
        src={courseImage(course)}
      />
      <div className="course-editorial__shade" aria-hidden="true" />

      <div className="course-editorial__meta">
        <span aria-label={`Curso ${index + 1} de ${total}`}>
          {position} <i>/</i> {count}
        </span>
        <Link to="/catalogo">Ver todos</Link>
      </div>

      <div className="course-editorial__content">
        <p className="course-editorial__eyebrow">
          {course.specialty ?? 'Formación técnica especializada'}
        </p>
        <p className="course-editorial__details">
          {course.duration_hours} horas · {modalityLabel(course.modality)}
        </p>
        <h2>{course.title}</h2>
        <p className="course-editorial__copy">
          {course.short_description ??
            'Formación especializada para aplicar el conocimiento técnico con seguridad y criterio profesional.'}
        </p>
        <Link
          className="editorial-cta editorial-cta--solid"
          params={{ courseSlug: course.slug }}
          search={{ version: course.versionId }}
          to="/cursos/$courseSlug"
        >
          Ver curso <ArrowRight aria-hidden="true" size={17} />
        </Link>
      </div>
    </section>
  )
}

function HomePage() {
  const { courses, loading, loadError } = usePublicCourses()

  return (
    <PublicLayout editorial>
      <section className="campus-hero">
        <img
          alt="Operario de Inmíner trabajando sobre una explotación minera con maquinaria"
          className="campus-hero__image"
          decoding="async"
          fetchPriority="high"
          height="941"
          loading="eager"
          src={heroImage}
          width="1672"
        />
        <div className="campus-hero__shade" aria-hidden="true" />

        <div className="campus-hero__content">
          <p className="campus-hero__eyebrow">
            Formación Preventiva Oficial · ITC 02.1.02
          </p>
          <h1 aria-label="Formación que mueve la obra.">
            <span>Formación</span>
            <span>que mueve</span>
            <span>la obra.</span>
          </h1>
          <p className="campus-hero__copy">
            Maquinaria, minería, seguridad y formación preventiva especializada.
          </p>
          <div className="campus-hero__actions">
            <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
              Explorar cursos <ArrowRight aria-hidden="true" size={17} />
            </Link>
            <Link className="editorial-cta editorial-cta--quiet" to="/mis-cursos">
              Mis cursos <ArrowRight aria-hidden="true" size={17} />
            </Link>
          </div>
        </div>

        <a className="campus-hero__scroll" href="#feed-cursos">
          <span>Descubrir formación</span>
          <ArrowDown aria-hidden="true" size={16} />
        </a>
      </section>

      <div className="course-feed" id="feed-cursos">
        {loading ? (
          <section className="course-feed__status" aria-live="polite">
            <p>Catálogo Inmíner</p>
            <h2>Preparando la formación disponible.</h2>
          </section>
        ) : loadError ? (
          <section className="course-feed__status" role="alert">
            <p>Catálogo Inmíner</p>
            <h2>No hemos podido cargar los cursos.</h2>
            <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
              Abrir catálogo <ArrowRight aria-hidden="true" size={17} />
            </Link>
          </section>
        ) : courses.length ? (
          courses.map((course, index) => (
            <CourseEditorialSlide
              course={course}
              index={index}
              key={course.versionId}
              total={courses.length}
            />
          ))
        ) : (
          <section className="course-feed__status">
            <p>Catálogo Inmíner</p>
            <h2>Explora la formación técnica disponible.</h2>
            <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
              Ver todos los cursos <ArrowRight aria-hidden="true" size={17} />
            </Link>
          </section>
        )}
      </div>
    </PublicLayout>
  )
}
