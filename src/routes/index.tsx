import { createFileRoute, Link } from '@tanstack/react-router'
import {
  ArrowRight,
  Award,
  KeyRound,
  LogIn,
  MessageCircle,
  ShieldCheck,
  UserPlus,
} from 'lucide-react'
import { CourseSlider } from '../components/CourseSlider'
import { Hero } from '../components/Hero'
import { InminerLink } from '../components/InminerLink'
import { JsonLd } from '../components/JsonLd'
import { PublicLayout } from '../components/PublicLayout'
import { useSectionReveal } from '../hooks/useSectionReveal'
import { fetchPublicCourses, toCourseCards } from '../lib/public-courses'
import { categoryOf } from '../lib/course-category'
import { GUIDE_PATHS } from '../lib/public-routes'
import {
  inminerIngenieriaSchema,
  organizationSchema,
  webSiteSchema,
} from '../lib/schema'
import { seoHead } from '../lib/seo'
import type { PublicCourse } from '../lib/types'

const heroMachineImage = '/assets/hero/loader-dirt.webp'

export const Route = createFileRoute('/')({
  // El carrusel de cursos se resolvía en cliente, así que el HTML inicial no
  // contenía ningún enlace a las fichas. Con el loader, la home ya enlaza a
  // `/cursos/...` desde el primer byte.
  loader: async () => ({ courses: toCourseCards(await fetchPublicCourses()) }),
  head: () => {
    const seo = seoHead({
      title: 'Cursos de minería y formación preventiva | InmínerCampus',
      description:
        'Cursos de formación preventiva minera de INMINER INGENIERÍA, S.L. (España): ITC 02.1.02 por puesto de trabajo e ITC 02.0.02 frente a polvo y sílice.',
      path: '/',
    })
    return {
      ...seo,
      links: [
        ...seo.links,
        { rel: 'preload', as: 'image', href: heroMachineImage },
      ],
    }
  },
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
    title: 'Consulta la formación',
    text: 'Revisa las introducciones del catálogo y solicita información al equipo de Inmíner.',
  },
  {
    number: '02',
    title: 'Valida tu acceso',
    text: 'Cada cuenta se revisa antes de habilitar el área privada y asignar cualquier formación.',
  },
  {
    number: '03',
    title: 'Recibe tu asignación',
    text: 'Inmíner habilita únicamente la formación que corresponda a la persona y a la acción acordada.',
  },
  {
    number: '04',
    title: 'Completa los requisitos',
    text: 'La documentación y el seguimiento se gestionan dentro del entorno privado según cada caso.',
  },
]

const campusGuideSteps = [
  {
    number: '01',
    title: 'Solicita una cuenta',
    text: 'Completa tus datos personales y profesionales, indica tu empresa y explica tu relación con Inmíner. El registro inicia una solicitud, pero todavía no habilita el contenido privado.',
  },
  {
    number: '02',
    title: 'Confirma tu correo',
    text: 'Valida la dirección de correo electrónico. Esta comprobación no sustituye la revisión administrativa de la solicitud.',
  },
  {
    number: '03',
    title: 'Localiza tu formación',
    text: 'Después de la aprobación, en «Mis cursos» verás únicamente las formaciones que Inmíner haya asignado o autorizado para tu cuenta.',
  },
  {
    number: '04',
    title: 'Espera la validación humana',
    text: 'Un administrador comprueba la empresa, la relación profesional y el motivo indicado antes de activar la cuenta.',
  },
  {
    number: '05',
    title: 'Solicita información',
    text: 'Desde cualquier ficha puedes abrir una conversación con el equipo de Inmíner para confirmar el alcance, los requisitos y el procedimiento de acceso.',
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
    text: 'Cada acción se organiza con criterios técnicos, trazabilidad y control de acceso.',
  },
]

const faqs = [
  {
    question: '¿Cómo accedo a mis cursos?',
    answer:
      'Desde "Mis cursos" en el menú superior, una vez has iniciado sesión con tu cuenta.',
  },
  {
    question: '¿Qué puedo consultar sin una cuenta aprobada?',
    answer:
      'Puedes consultar las introducciones del catálogo y pedir información. El resto del contenido requiere validación administrativa y una asignación expresa.',
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
          Inmíner Campus es la plataforma de formación de{' '}
          <InminerLink>INMINER INGENIERÍA</InminerLink>, una ingeniería
          multidisciplinar con sede en Ciudad Real. Reunimos
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
          No ofrecemos un catálogo genérico de maquinaria. Cada acción se
          relaciona con el puesto, el centro de trabajo y la normativa técnica
          aplicable. La introducción es pública; el alcance completo sólo se
          facilita después de validar la relación profesional y la asignación.
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
            El objetivo de la formación es reducir el riesgo real del puesto.
            Por eso cada acción se conecta con lo que se exige en el trabajo
            diario.
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
          <p className="campus-section__copy" style={{ marginTop: 22 }}>
            ¿Qué formación exige la norma para tu puesto? Lo explicamos en la{' '}
            <Link className="text-link" to={GUIDE_PATHS.hub}>
              guía de formación minera
            </Link>
            , con la{' '}
            <Link className="text-link" to={GUIDE_PATHS.itc020102}>
              ITC 02.1.02
            </Link>{' '}
            por puesto de trabajo y la{' '}
            <Link className="text-link" to={GUIDE_PATHS.itc020002}>
              ITC 02.0.02
            </Link>{' '}
            de polvo y sílice.
          </p>
        </div>
      </div>
    </section>
  )
}

function CategoriesTeaser({ hasOtherCourses }: { hasOtherCourses: boolean }) {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()
  const allCategories = [
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
      image: '/images/campus-carousel-topografia.webp',
    },
  ]
  // «Otros» no tiene hoy cursos publicados: su tarjeta llevaba a un listado
  // vacío. Mientras siga así, el hueco lo ocupa la formación para empresas,
  // con el mismo diseño.
  const categories = hasOtherCourses
    ? allCategories
    : allCategories.filter((category) => category.categoria !== 'otros')

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
          {!hasOtherCourses ? (
            <Link className="category-teaser" to="/empresas">
              <div className="category-teaser__visual">
                <img alt="" loading="lazy" src="/images/campus-carousel-topografia.webp" />
                <span className="category-badge category-badge--otros">Empresas</span>
              </div>
              <div className="category-teaser__body">
                <h3>Formación para empresas</h3>
                <p>
                  Plazas para toda la plantilla, una licencia por trabajador y
                  descuento por volumen desde 6 plazas.
                </p>
                <span className="text-link">
                  Ver formación para empresas <ArrowRight aria-hidden="true" size={16} />
                </span>
              </div>
            </Link>
          ) : null}
        </div>
      </div>
    </section>
  )
}

function CampusGuide() {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      aria-labelledby="campus-guide-title"
      className={`campus-section campus-section--guide${isVisible ? ' is-visible' : ''}`}
      id="guia-campus"
      ref={ref}
    >
      <div className="campus-section__inner">
        <div className="campus-guide__intro">
          <div>
            <span className="campus-section__eyebrow">Guía de acceso</span>
            <h2 className="campus-section__heading" id="campus-guide-title">
              Empieza en Inmíner Campus, paso a paso.
            </h2>
          </div>
          <p className="campus-section__copy">
            Conoce el proceso de solicitud, revisión administrativa y acceso a
            las formaciones que Inmíner te haya autorizado.
          </p>
        </div>

        <div className="campus-guide__media">
          <div className="campus-guide__video-shell campus-guide__access-control">
            <ShieldCheck aria-hidden="true" size={42} />
            <span className="eyebrow">Control de acceso</span>
            <h3>Una cuenta no se activa automáticamente.</h3>
            <p>
              La confirmación del correo verifica la dirección. La entrada al
              contenido privado requiere además la aprobación de un
              administrador de Inmíner.
            </p>
          </div>

          <aside className="campus-guide__shortcuts" aria-label="Accesos rápidos">
            <span className="campus-guide__shortcuts-label">Accesos rápidos</span>
            <Link to="/registro">
              <UserPlus aria-hidden="true" size={19} />
              <span>Solicitar una cuenta</span>
              <ArrowRight aria-hidden="true" size={16} />
            </Link>
            <Link to="/acceso">
              <LogIn aria-hidden="true" size={19} />
              <span>Iniciar sesión</span>
              <ArrowRight aria-hidden="true" size={16} />
            </Link>
            <Link to="/canjear-codigo">
              <KeyRound aria-hidden="true" size={19} />
              <span>Canjear un código</span>
              <ArrowRight aria-hidden="true" size={16} />
            </Link>
            <Link to="/contacto">
              <MessageCircle aria-hidden="true" size={19} />
              <span>Pedir información</span>
              <ArrowRight aria-hidden="true" size={16} />
            </Link>
            <Link to="/certificados">
              <Award aria-hidden="true" size={19} />
              <span>Mis certificados</span>
              <ArrowRight aria-hidden="true" size={16} />
            </Link>
          </aside>
        </div>

        <div className="campus-guide__written">
          <div className="campus-guide__written-head">
            <span>Guía escrita</span>
            <h3>Todo el proceso, sin saltarte ningún paso.</h3>
          </div>
          <ol className="campus-guide__steps">
            {campusGuideSteps.map((step) => (
              <li className="campus-guide__step" key={step.number}>
                <span className="campus-guide__step-number" aria-hidden="true">
                  {step.number}
                </span>
                <div>
                  <h4>{step.title}</h4>
                  <p>{step.text}</p>
                </div>
              </li>
            ))}
          </ol>
        </div>
      </div>
    </section>
  )
}

function FormationSection({ courses }: { courses: Array<PublicCourse> }) {
  const { ref, isVisible } = useSectionReveal<HTMLElement>()

  return (
    <section
      className={`campus-section campus-section--formation${isVisible ? ' is-visible' : ''}`}
      id="campus-formacion"
      ref={ref}
    >
      <CourseSlider courses={courses} />
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
            <strong>{courseCount}</strong> formaciones técnicas con
            introducción disponible en el catálogo y acceso gestionado de
            forma individual.
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
            Solicitar acceso <ArrowRight aria-hidden="true" size={17} />
          </Link>
        </div>
      </div>
    </section>
  )
}

function HomePage() {
  const { courses } = Route.useLoaderData()

  return (
    <PublicLayout heroFull>
      {/* La identidad de la empresa se declara una sola vez, en la home; el
          resto de páginas la referencian por `@id` desde sus propios nodos. */}
      <JsonLd
        nodes={[organizationSchema(), inminerIngenieriaSchema(), webSiteSchema()]}
      />
      <Hero
        ctaLabel="Explorar cursos"
        ctaTargetId="campus-formacion"
        eyebrow="Inmíner Campus · Cursos de minería y formación preventiva"
        guideLabel="Ver cómo se controla el acceso"
        guideTargetId="guia-campus"
        machineImage={heroMachineImage}
        subtitle="Cursos para minería e industria"
        title={
          <>
            <span className="campus-hero__title-line campus-hero__title-line--ink">
              CONOCIMIENTO
            </span>
            <span className="campus-hero__title-line">QUE SE CONVIERTE</span>
            <span className="campus-hero__title-line">
              EN <span className="campus-hero__title-line--ink">SEGURIDAD.</span>
            </span>
          </>
        }
      />

      <CampusIntro />
      <WhatIsCampus />
      <SafetySection />
      <MiningSection />
      <CategoriesTeaser
        hasOtherCourses={courses.some((course) => categoryOf(course) === 'otros')}
      />
      <CampusGuide />
      <FormationSection courses={courses} />
      <HowItWorks />
      <AboutInminer />
      <WhyCampus courseCount={courses.length} />
      <FaqSection />
      <FinalCta />
    </PublicLayout>
  )
}
