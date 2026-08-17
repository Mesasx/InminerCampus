import { createFileRoute, Link } from '@tanstack/react-router'
import { ArrowRight } from 'lucide-react'
import { CourseSlider } from '../components/CourseSlider'
import { Hero } from '../components/Hero'
import { PublicLayout } from '../components/PublicLayout'
import { useSectionReveal } from '../hooks/useSectionReveal'
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

const categories = [
  {
    categoria: 'vip' as const,
    label: 'VIP',
    title: 'Formaciones destacadas',
    text: 'Programas premium seleccionados por su relevancia técnica y demanda del sector.',
    image: '/images/hero-inminer-campus.jpg',
  },
  {
    categoria: 'mineria' as const,
    label: 'Minería',
    title: 'Maquinaria y explotación',
    text: 'Operación, carga, transporte y seguridad en trabajos mineros y viales.',
    image: '/images/campus-carousel-operacion.jpg',
  },
  {
    categoria: 'otros' as const,
    label: 'Otros',
    title: 'Formación industrial',
    text: 'Programas complementarios para industria, obra y prevención general.',
    image: '/images/campus-carousel-topografia.png',
  },
]

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

function CategoriesTeaser() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--categories${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Explora por categoría</span>
        <h2 className="campus-section__heading">Encuentra tu formación.</h2>
        <div className="category-teaser-grid">
          {categories.map((category) => (
            <Link
              className="category-teaser"
              key={category.categoria}
              to="/catalogo"
              search={{ categoria: category.categoria }}
            >
              <div className="category-teaser__visual">
                <img alt="" loading="lazy" src={category.image} />
                <span className={`category-badge category-badge--${category.categoria}`}>
                  {category.label}
                </span>
              </div>
              <div className="category-teaser__body">
                <h3>{category.title}</h3>
                <p>{category.text}</p>
                <span className="text-link">
                  Ver cursos <ArrowRight aria-hidden="true" size={16} />
                </span>
              </div>
            </Link>
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
      className={`campus-section campus-section--formation${isVisible ? ' is-visible' : ''}`}
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
      className={`campus-section campus-section--cta${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">¿Listo para empezar?</span>
        <h2 className="campus-section__heading">Empieza tu formación.</h2>
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
    <PublicLayout heroFull>
      <Hero
        eyebrow="Formación Preventiva Oficial · ITC 02.1.02"
        image={heroImage}
        imageAlt="Cargadora amarilla volcando tierra en una explotación minera, con el logo de Inmíner Campus"
        scrollTargetId="campus-formacion"
        title={
          <>
            <span>La formación</span>
            <span>que mueve</span>
            <span>el mundo.</span>
          </>
        }
        subtitle="Maquinaria, minería, seguridad y formación preventiva especializada."
        actions={
          <>
            <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
              Explorar cursos <ArrowRight aria-hidden="true" size={17} />
            </Link>
            <Link className="editorial-cta editorial-cta--quiet" to="/mis-cursos">
              Mis cursos <ArrowRight aria-hidden="true" size={17} />
            </Link>
          </>
        }
      />

      <CampusIntro />
      <WhatWeDo />
      <CategoriesTeaser />
      <AboutInminer />
      <FormationSection courses={courses} loadError={loadError} loading={loading} />
      <FinalCta />
    </PublicLayout>
  )
}
