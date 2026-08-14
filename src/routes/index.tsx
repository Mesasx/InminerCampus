import { useEffect, useRef, useState } from 'react'
import { createFileRoute, Link } from '@tanstack/react-router'
import { ArrowDown, ArrowRight } from 'lucide-react'
import { CourseSlider } from '../components/CourseSlider'
import { PublicLayout } from '../components/PublicLayout'
import { usePublicCourses } from '../hooks/usePublicCourses'

const heroImage = '/images/hero-inminer-mundo.jpg'

export const Route = createFileRoute('/')({
  head: () => ({
    links: [{ rel: 'preload', as: 'image', href: heroImage }],
  }),
  component: HomePage,
})

const whatWeDo = [
  {
    number: '01',
    title: 'Formación preventiva',
    text: 'Formación especializada vinculada al entorno industrial y minero.',
  },
  {
    number: '02',
    title: 'Maquinaria',
    text: 'Conocimiento técnico aplicado a operación, seguridad y utilización de maquinaria.',
  },
  {
    number: '03',
    title: 'Minería',
    text: 'Contenido desarrollado desde experiencia real en explotaciones y proyectos.',
  },
  {
    number: '04',
    title: 'Seguridad',
    text: 'Formación orientada al trabajo seguro y al cumplimiento preventivo.',
  },
]

function useSectionReveal<T extends HTMLElement>() {
  const ref = useRef<T>(null)
  const [isVisible, setIsVisible] = useState(false)

  useEffect(() => {
    const node = ref.current
    if (!node) return

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true)
          observer.disconnect()
        }
      },
      { threshold: 0.2 },
    )

    observer.observe(node)
    return () => observer.disconnect()
  }, [])

  return { ref, isVisible }
}

function CampusIntro() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--intro${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Inmíner Campus</span>
        <h2 className="campus-section__heading">Formación para la industria real.</h2>
        <p className="campus-section__copy">
          InmínerCampus nace de la experiencia de INMINER INGENIERÍA en minería,
          industria y seguridad: más de 18 años dirigiendo proyectos reales que
          ahora se trasladan a una formación técnica y práctica.
        </p>
        <div className="campus-section__stat">
          <div>
            <strong>18+</strong>
            <span>años de ingeniería aplicada a formación real</span>
          </div>
        </div>
      </div>
    </section>
  )
}

function WhatWeDo() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--what${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Qué hacemos</span>
        <h2 className="campus-section__heading">Cuatro áreas, un mismo criterio técnico.</h2>
        <div className="campus-list">
          {whatWeDo.map((item) => (
            <div className="campus-list__item" key={item.number}>
              <span className="campus-list__number">{item.number}</span>
              <div>
                <h3 className="campus-list__title">{item.title}</h3>
                <p className="campus-list__text">{item.text}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

function AboutInminer() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--about${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Sobre Inmíner</span>
        <h2 className="campus-section__heading">Ingeniería real detrás de cada curso.</h2>
        <p className="campus-section__copy">
          INMINER INGENIERÍA, S.L. es una firma multidisciplinar de Ciudad Real
          con más de 18 años de trayectoria en minería, industria, seguridad y
          medio ambiente. Esa experiencia de campo, no solo teórica, es la que
          se traslada a cada curso de InmínerCampus.
        </p>
        <Link className="editorial-cta editorial-cta--quiet campus-section__cta" to="/sobre-nosotros">
          Conocer Inmíner <ArrowRight aria-hidden="true" size={17} />
        </Link>
      </div>
    </section>
  )
}

function FormationSection({
  courses,
  loading,
  loadError,
}: {
  courses: ReturnType<typeof usePublicCourses>['courses']
  loading: boolean
  loadError: boolean
}) {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--formation campus-section--light${
        isVisible ? ' is-visible' : ''
      }`}
      id="campus-formacion"
      ref={ref}
    >
      <CourseSlider courses={courses} loadError={loadError} loading={loading} />
    </section>
  )
}

function FinalCta() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--cta campus-section--light${
        isVisible ? ' is-visible' : ''
      }`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">¿Listo para empezar?</span>
        <h2 className="campus-section__heading">Elige tu formación y empieza hoy.</h2>
        <p className="campus-section__copy">
          Consulta el catálogo completo o retoma la formación en la que ya estás
          inscrito.
        </p>
        <div className="campus-cta__actions campus-section__cta">
          <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
            Ver todos los cursos <ArrowRight aria-hidden="true" size={17} />
          </Link>
          <Link className="editorial-cta editorial-cta--quiet" to="/mis-cursos">
            Mis cursos <ArrowRight aria-hidden="true" size={17} />
          </Link>
        </div>
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
          alt="Ingeniero de Inmíner con casco corporativo inspeccionando una maqueta detallada de una explotación minera"
          className="campus-hero__image"
          decoding="async"
          fetchPriority="high"
          height="900"
          loading="eager"
          src={heroImage}
          width="1600"
        />
        <div className="campus-hero__shade" aria-hidden="true" />

        <div className="campus-hero__content">
          <p className="campus-hero__eyebrow">
            Formación Preventiva Oficial · ITC 02.1.02
          </p>
          <h1 aria-label="La formación que mueve el mundo.">
            <span>La formación</span>
            <span>que mueve</span>
            <span>el mundo.</span>
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

        <a className="campus-hero__scroll" href="#campus-formacion">
          <span>Descubrir formación</span>
          <ArrowDown aria-hidden="true" size={16} />
        </a>

        <span aria-hidden="true" id="campus-hero-sentinel" />
      </section>

      <CampusIntro />
      <WhatWeDo />
      <AboutInminer />
      <FormationSection courses={courses} loadError={loadError} loading={loading} />
      <FinalCta />
    </PublicLayout>
  )
}
