import { createFileRoute, Link } from '@tanstack/react-router'
import { ArrowRight } from 'lucide-react'
import { CourseSlider } from '../components/CourseSlider'
import { Hero } from '../components/Hero'
import { PublicLayout } from '../components/PublicLayout'
import { useSectionReveal } from '../hooks/useSectionReveal'
import { usePublicCourses } from '../hooks/usePublicCourses'

const heroImage = '/images/hero-campus-cargadora.png'

export const Route = createFileRoute('/')({
  head: () => ({
    links: [{ rel: 'preload', as: 'image', href: heroImage }],
  }),
  component: HomePage,
})

const sectors = [
  'Industria',
  'Minería',
  'Medioambiente',
  'Seguridad industrial',
  'Energía',
  'Construcción industrial',
]

const safetyTopics = [
  {
    title: 'Identificación de riesgos',
    text: 'Reconocer antes de empezar los riesgos propios del puesto, de la máquina y del entorno de trabajo.',
  },
  {
    title: 'Conocimiento del equipo',
    text: 'Saber cómo funciona la máquina o el equipo que se va a operar, sus sistemas de seguridad y sus límites.',
  },
  {
    title: 'Procedimientos de trabajo',
    text: 'Aplicar la secuencia de trabajo establecida en cada tarea, sin improvisar sobre el terreno.',
  },
  {
    title: 'Comportamiento seguro',
    text: 'Adoptar hábitos que reduzcan el riesgo propio y el de las personas que trabajan alrededor.',
  },
  {
    title: 'Mantenimiento',
    text: 'Revisar el estado del equipo antes de usarlo y detectar señales de desgaste o avería.',
  },
  {
    title: 'Coordinación de actividades',
    text: 'Trabajar de forma segura cuando hay varias tareas o varios equipos operando a la vez en el mismo entorno.',
  },
]

const miningTopics = [
  'Circulación y maniobra de maquinaria pesada',
  'Arranque, carga y transporte de material',
  'Exposición a polvo y sílice cristalina respirable',
  'Estabilidad de taludes y control del entorno de trabajo',
  'Coordinación entre operaciones y vehículos simultáneos',
]

const howItWorks = [
  {
    number: '01',
    title: 'Elige tu formación',
    text: 'Consulta el catálogo por categoría o accede con el código que te haya facilitado tu empresa.',
  },
  {
    number: '02',
    title: 'Accede a los contenidos',
    text: 'Cada bloque combina audio explicado, diapositivas y documentación descargable cuando corresponde.',
  },
  {
    number: '03',
    title: 'Avanza por los bloques',
    text: 'Tu progreso se guarda automáticamente. Puedes retomar la formación exactamente donde la dejaste.',
  },
  {
    number: '04',
    title: 'Completa la evaluación',
    text: 'Cada curso incluye un test final. Al superarlo se emite el certificado de la formación.',
  },
]

const whyReasons = [
  {
    label: 'Ingeniería',
    text: 'Contenidos elaborados por técnicos que trabajan en proyectos reales, no solo en un aula.',
  },
  {
    label: 'Campo',
    text: 'Formación pensada para aplicarse directamente en obra, planta o explotación.',
  },
  {
    label: 'Prevención',
    text: 'La seguridad se trata como parte del trabajo, no como un trámite añadido al final.',
  },
  {
    label: 'Minería',
    text: 'Conocimiento específico del sector: maquinaria, arranque, carga, transporte y riesgos propios.',
  },
  {
    label: 'Contenidos',
    text: 'Cada curso se estructura en bloques con audio, diapositivas y evaluación.',
  },
]

const faqs = [
  {
    question: '¿Cómo accedo a mis cursos?',
    answer:
      'Desde "Mis cursos" en el menú superior, una vez has iniciado sesión con tu cuenta.',
  },
  {
    question: '¿Dónde puedo ver mi progreso?',
    answer:
      'En la cabecera de cada curso y en el resumen de "Mis cursos" verás el porcentaje completado.',
  },
  {
    question: '¿Puedo continuar un curso más tarde?',
    answer:
      'Sí. El progreso se guarda automáticamente por bloque, así que puedes retomarlo cuando quieras.',
  },
  {
    question: '¿Dónde aparecen las evaluaciones?',
    answer:
      'Al final del itinerario del curso, una vez completados los bloques de contenido correspondientes.',
  },
  {
    question: '¿Qué recursos incluye cada formación?',
    answer:
      'Depende del curso: audio explicado, diapositivas, documentación descargable y evaluación final.',
  },
  {
    question: '¿Cómo recupero mi contraseña?',
    answer:
      'Desde "Iniciar sesión", en el enlace para recuperar contraseña con tu correo electrónico.',
  },
  {
    question: '¿Cómo contacto con Inmíner?',
    answer:
      'Desde la página de contacto, o escribiendo a administracion@inminer.es.',
  },
]

function CampusIntro() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--intro${isVisible ? ' is-visible' : ''}`}
      id="campus-intro"
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Inmíner Campus</span>
        <h2 className="campus-section__heading">
          Formación técnica desde la ingeniería.
        </h2>
        <p className="campus-section__copy">
          Inmíner Campus es la plataforma de formación de INMINER INGENIERÍA,
          una ingeniería multidisciplinar con sede en Ciudad Real. Reunimos
          aquí la formación preventiva y técnica que antes solo llegaba a
          través de nuestros propios proyectos, para ponerla al alcance de
          operadores, técnicos y empresas del sector minero e industrial.
        </p>
        <div className="campus-section__tags">
          {sectors.map((sector) => (
            <span className="campus-tag" key={sector}>
              {sector}
            </span>
          ))}
        </div>
      </div>
    </section>
  )
}

function WhatIsCampus() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--what${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Qué es Inmíner Campus</span>
        <h2 className="campus-section__heading">
          Una plataforma, un mismo criterio técnico.
        </h2>
        <p className="campus-section__copy">
          Cada curso se estructura en bloques de contenido con audio
          explicado, diapositivas y documentación descargable cuando
          corresponde, seguidos de una evaluación final. No es un curso
          genérico de maquinaria: cada itinerario se adapta al puesto y al
          centro de trabajo, con la normativa técnica aplicable como
          referencia explícita.
        </p>
        <p className="campus-section__copy">
          El contenido no se redacta desde cero para la plataforma: parte de
          los manuales, presentaciones y procedimientos que Inmíner
          Ingeniería ya utiliza en sus propios proyectos de minería,
          industria y prevención.
        </p>
      </div>
    </section>
  )
}

function SafetySection() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--safety${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner campus-section__inner--split">
        <div className="campus-safety__intro">
          <span className="campus-section__eyebrow">Por qué formarse</span>
          <h2 className="campus-section__heading">
            Formarse para trabajar con seguridad.
          </h2>
          <p className="campus-section__copy">
            El objetivo de la formación no es superar un test: es reducir el
            riesgo real del puesto. Por eso cada curso insiste en lo mismo
            que se exige en el trabajo diario.
          </p>
        </div>
        <div className="campus-safety__grid">
          {safetyTopics.map((topic) => (
            <div className="campus-safety__item" key={topic.title}>
              <h3>{topic.title}</h3>
              <p>{topic.text}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

function MiningSection() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--mining${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner campus-section__inner--split campus-section__inner--reverse">
        <div className="campus-mining__visual" aria-hidden="true">
          <img alt="" loading="lazy" src="/images/campus-carousel-operacion.jpg" />
        </div>
        <div className="campus-mining__body">
          <span className="campus-section__eyebrow">Minería</span>
          <h2 className="campus-section__heading">Formación para minería.</h2>
          <p className="campus-section__copy">
            Una explotación minera no se parece a una obra convencional: hay
            maquinaria pesada en movimiento constante, circulación de
            vehículos, exposición a polvo y operaciones que se solapan en el
            mismo espacio. Esa combinación exige una formación específica.
          </p>
          <ul className="campus-mining__list">
            {miningTopics.map((topic) => (
              <li key={topic}>{topic}</li>
            ))}
          </ul>
          <Link
            className="editorial-cta editorial-cta--solid campus-section__cta"
            to="/catalogo"
            search={{ categoria: 'mineria' }}
          >
            Ver cursos de minería <ArrowRight aria-hidden="true" size={17} />
          </Link>
        </div>
      </div>
    </section>
  )
}

function CategoriesTeaser() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()
  const categories = [
    {
      categoria: 'mineria' as const,
      label: 'Minería',
      title: 'Maquinaria y explotación',
      text: 'Operación, arranque, carga, transporte y prevención en trabajos mineros y viales.',
      image: '/images/campus-carousel-operacion.jpg',
    },
    {
      categoria: 'otros' as const,
      label: 'Otros',
      title: 'Formación técnica complementaria',
      text: 'Programas técnicos que no se encuadran en minería, como formaciones internas por invitación.',
      image: '/images/campus-carousel-topografia.png',
    },
  ]

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

function HowItWorks() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--how${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Cómo funciona</span>
        <h2 className="campus-section__heading">De elegir el curso a certificarte.</h2>
        <div className="campus-list">
          {howItWorks.map((step) => (
            <div className="campus-list__item" key={step.number}>
              <span className="campus-list__number">{step.number}</span>
              <div>
                <h3 className="campus-list__title">{step.title}</h3>
                <p className="campus-list__text">{step.text}</p>
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
          INMINER INGENIERÍA, S.L. es una ingeniería multidisciplinar con
          sede en Ciudad Real que trabaja en minería, industria,
          medioambiente, seguridad industrial y energía. Los mismos equipos
          que redactan proyectos y evalúan riesgos en campo son los que
          definen el contenido técnico de Inmíner Campus.
        </p>
        <Link className="editorial-cta editorial-cta--quiet campus-section__cta" to="/sobre-nosotros">
          Conocer Inmíner <ArrowRight aria-hidden="true" size={17} />
        </Link>
      </div>
    </section>
  )
}

function WhyCampus({ courseCount }: { courseCount: number }) {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--why${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Por qué Inmíner Campus</span>
        <h2 className="campus-section__heading">
          Cinco ideas, un mismo punto de partida.
        </h2>
        <div className="campus-why__grid">
          {whyReasons.map((reason) => (
            <div className="campus-why__item" key={reason.label}>
              <span className="campus-why__label label-industrial">
                {reason.label}
              </span>
              <p>{reason.text}</p>
            </div>
          ))}
        </div>
        {courseCount > 0 ? (
          <p className="campus-why__stat">
            <strong>{courseCount}</strong> formaciones técnicas disponibles
            ahora mismo en el catálogo, estructuradas en bloques con audio,
            diapositivas y evaluación.
          </p>
        ) : null}
      </div>
    </section>
  )
}

function FaqSection() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--faq${isVisible ? ' is-visible' : ''}`}
      ref={ref}
    >
      <div className="campus-section__inner">
        <span className="campus-section__eyebrow">Preguntas frecuentes</span>
        <h2 className="campus-section__heading">¿Cómo funciona el Campus?</h2>
        <div className="campus-faq">
          {faqs.map((faq) => (
            <div className="campus-faq__item" key={faq.question}>
              <h3>{faq.question}</h3>
              <p>{faq.answer}</p>
            </div>
          ))}
        </div>
      </div>
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
        <h2 className="campus-section__heading">
          Formación técnica para quienes trabajan sobre el terreno.
        </h2>
        <p className="campus-section__copy">
          Consulta el catálogo completo o crea tu cuenta para empezar a
          formarte.
        </p>
        <div className="campus-cta__actions campus-section__cta">
          <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
            Explorar cursos <ArrowRight aria-hidden="true" size={17} />
          </Link>
          <Link className="editorial-cta editorial-cta--quiet" to="/registro">
            Crear cuenta <ArrowRight aria-hidden="true" size={17} />
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
        image={heroImage}
        imageAlt="Inmíner Campus · 20H · cursos oficiales para minería e industria: cargadora amarilla volcando tierra en una explotación"
        scrollTargetId="campus-intro"
        actions={
          <>
            <Link className="button button--primary" to="/catalogo">
              Explorar cursos
            </Link>
            <Link className="button button--outline" to="/mis-cursos">
              Mis cursos
            </Link>
          </>
        }
      />

      <CampusIntro />
      <WhatIsCampus />
      <SafetySection />
      <MiningSection />
      <CategoriesTeaser />
      <FormationSection courses={courses} loadError={loadError} loading={loading} />
      <HowItWorks />
      <AboutInminer />
      <WhyCampus courseCount={courses.length} />
      <FaqSection />
      <FinalCta />
    </PublicLayout>
  )
}
