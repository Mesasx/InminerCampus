import { createFileRoute, Link } from '@tanstack/react-router'
import {
  BarChart3,
  Building2,
  KeyRound,
  ReceiptText,
  UsersRound,
} from 'lucide-react'
import { GuideSection } from '../components/GuideBlocks'
import { JsonLd } from '../components/JsonLd'
import { StaticPage } from '../components/StaticPage'
import { getCompanyVolumeDiscountBasisPoints } from '../lib/billing'
import { isIndexableCourse } from '../lib/course-access'
import { formatCurrency } from '../lib/format'
import { ITC_02_1_02_AMENDMENT } from '../lib/mining-regulation'
import {
  fetchPublicCourses,
  type PublicCourseDetail,
} from '../lib/public-courses'
import { GUIDE_PATHS } from '../lib/public-routes'
import {
  breadcrumbSchema,
  campusReference,
  faqSchema,
  itemListSchema,
  type BreadcrumbItem,
  type FaqItem,
} from '../lib/schema'
import { absoluteUrl, seoHead } from '../lib/seo'

const PATH = '/empresas'
const PROPOSAL_MAILTO =
  'mailto:administracion@inminer.es?subject=Formación%20para%20empresa%20-%20InmínerCampus'

/** Máximo de plazas por pedido que admite la compra para empresa. */
const MAX_SEATS = 500

// Tramos de descuento calculados con la misma función que aplica el checkout:
// si cambian allí, esta tabla cambia sola.
const discountTiers = [
  { label: '1 a 5 plazas', basisPoints: getCompanyVolumeDiscountBasisPoints(1) },
  { label: '6 a 7 plazas', basisPoints: getCompanyVolumeDiscountBasisPoints(6) },
  { label: `8 a ${MAX_SEATS} plazas`, basisPoints: getCompanyVolumeDiscountBasisPoints(8) },
]

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación para empresas', path: PATH },
]

const faqs: Array<FaqItem> = [
  {
    question: '¿Cómo se reparten las plazas entre los trabajadores?',
    answer:
      'En el pedido indicas el nombre y el correo de cada trabajador. Al confirmarse el pago, cada uno recibe por correo su licencia personal, un código de un solo uso que canjea con su propia cuenta para quedar matriculado.',
  },
  {
    question: '¿Hay descuento por comprar varias plazas?',
    answer: `Sí, se aplica solo en el pedido: ${discountTiers[1].basisPoints / 100} % de 6 a 7 plazas y ${discountTiers[2].basisPoints / 100} % desde 8 plazas, hasta ${MAX_SEATS} plazas por pedido.`,
  },
  {
    question: '¿La factura sale a nombre de la empresa?',
    answer:
      'Sí. El pedido recoge los datos fiscales de la organización, el número de plazas, el descuento y el IVA, y la factura se emite a nombre de la empresa.',
  },
  {
    question: '¿Puede la empresa seguir el progreso de sus trabajadores?',
    answer:
      'Sí, de forma agregada: el panel de empresa muestra las plazas compradas, las licencias sin canjear y cuántos trabajadores están en formación o la han completado, sin exponer los datos personales de cada uno.',
  },
  {
    question: '¿La formación de la ITC 02.1.02 se puede hacer íntegramente online?',
    answer: `No. La ${ITC_02_1_02_AMENDMENT.instrument} establece que «${ITC_02_1_02_AMENDMENT.presencialQuote}» El Campus sirve de soporte teórico y de seguimiento, y la parte presencial se organiza con Inmíner Ingeniería.`,
  },
]

export const Route = createFileRoute('/empresas')({
  loader: async () => {
    // La landing tiene valor sin el catálogo: si Supabase falla, se sirve sin
    // la tabla de precios en vez de devolver un error.
    try {
      return { courses: (await fetchPublicCourses()).filter(isIndexableCourse) }
    } catch (error) {
      console.error('No se ha podido cargar el catálogo para empresas.', error)
      return { courses: [] as Array<PublicCourseDetail> }
    }
  },
  head: () =>
    seoHead({
      title: 'Formación minera para empresas: ITC 02.1.02 para tu plantilla',
      description:
        'Forma a tu plantilla en ITC 02.1.02 e ITC 02.0.02: licencias por trabajador, seguimiento, factura a nombre de la empresa y descuento desde 6 plazas.',
      path: PATH,
    }),
  component: CompaniesPage,
})

function priceSummary(course: PublicCourseDetail) {
  return [...course.versions]
    .sort((a, b) => a.duration_hours - b.duration_hours)
    .map((version) => `${version.duration_hours} h: ${formatCurrency(version.price_net, version.currency)}`)
    .join(' · ')
}

function CompaniesPage() {
  const { courses } = Route.useLoaderData()

  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Formación para empresas"
      title="Formación minera para empresas: forma a tu plantilla sin perder el control."
      description="Compra plazas para tus trabajadores, cada uno recibe su licencia personal y sigues el progreso de la formación desde un único panel, con factura a nombre de la empresa."
    >
      <JsonLd
        nodes={[
          {
            '@type': 'Service',
            '@id': `${absoluteUrl(PATH)}#service`,
            name: 'Formación preventiva minera para empresas',
            serviceType: 'Formación preventiva en seguridad minera',
            url: absoluteUrl(PATH),
            provider: campusReference(),
            areaServed: { '@type': 'Country', name: 'España' },
            audience: {
              '@type': 'BusinessAudience',
              audienceType:
                'Explotaciones mineras, canteras, establecimientos de beneficio y empresas contratistas',
            },
          },
          breadcrumbSchema(breadcrumbs),
          faqSchema(faqs),
          ...(courses.length
            ? [
                itemListSchema(
                  'Cursos disponibles para empresas',
                  courses.map((course) => ({ name: course.title, path: `/cursos/${course.slug}` })),
                ),
              ]
            : []),
        ]}
      />

      <div className="guide-answer">
        <p>
          <strong>Para quién:</strong> explotaciones mineras y canteras,
          plantas de áridos y establecimientos de beneficio, y empresas
          contratistas que trabajan en centros mineros y necesitan formar a
          varios trabajadores en la ITC 02.1.02 (formación preventiva del
          puesto) o en la ITC 02.0.02 (polvo y sílice).
        </p>
      </div>

      <GuideSection id="como-funciona" title="Cómo funciona la compra para empresa">
        <div className="feature-grid">
          <article className="feature-card">
            <span className="feature-card__icon">
              <UsersRound size={23} />
            </span>
            <h3>1. Elige curso y plazas</h3>
            <p>
              Selecciona la formación, la duración (inicial o reciclaje) y el
              número de trabajadores.
            </p>
          </article>
          <article className="feature-card">
            <span className="feature-card__icon">
              <KeyRound size={23} />
            </span>
            <h3>2. Cada trabajador recibe su licencia</h3>
            <p>
              Indica nombre y correo de cada persona: al confirmarse el pago,
              cada una recibe un código de un solo uso.
            </p>
          </article>
          <article className="feature-card">
            <span className="feature-card__icon">
              <BarChart3 size={23} />
            </span>
            <h3>3. Sigue el progreso</h3>
            <p>
              El panel de empresa muestra cuántos trabajadores están en
              formación y cuántos la han completado.
            </p>
          </article>
        </div>
      </GuideSection>

      {courses.length ? (
        <GuideSection id="cursos" title="Cursos disponibles y precio por plaza">
          <div className="table-scroll">
            <table className="data-table data-table--wrap">
              <thead>
                <tr>
                  <th scope="col">Curso</th>
                  <th scope="col">Norma</th>
                  <th scope="col">Precio por plaza (sin IVA)</th>
                </tr>
              </thead>
              <tbody>
                {courses.map((course) => (
                  <tr key={course.slug}>
                    <th scope="row">
                      <Link
                        className="text-link"
                        params={{ courseSlug: course.slug }}
                        to="/cursos/$courseSlug"
                      >
                        {course.title}
                      </Link>
                    </th>
                    <td>{course.versions[0]?.accreditation_reference ?? course.specialty}</td>
                    <td>{priceSummary(course)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="legal-note">
            Precios netos por trabajador antes del descuento por volumen. En
            cada ficha puedes iniciar la compra para empresa con la duración
            elegida.
          </p>
        </GuideSection>
      ) : null}

      <GuideSection id="descuentos" title="Descuento por volumen">
        <div className="table-scroll">
          <table className="data-table data-table--wrap">
            <thead>
              <tr>
                <th scope="col">Plazas por pedido</th>
                <th scope="col">Descuento</th>
              </tr>
            </thead>
            <tbody>
              {discountTiers.map((tier) => (
                <tr key={tier.label}>
                  <th scope="row">{tier.label}</th>
                  <td>{tier.basisPoints ? `${tier.basisPoints / 100} %` : 'Precio estándar'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>El descuento se calcula y se aplica automáticamente en el pedido.</p>
      </GuideSection>

      <GuideSection id="documentacion" title="Documentación y facturación">
        <div className="panel" style={{ marginTop: 0 }}>
          <div className="form-grid">
            <div style={{ display: 'flex', gap: 12 }}>
              <Building2 color="var(--orange)" />
              <span>Pedido con los datos fiscales de la organización y factura a nombre de la empresa.</span>
            </div>
            <div style={{ display: 'flex', gap: 12 }}>
              <ReceiptText color="var(--orange)" />
              <span>
                Certificado de formación por trabajador, con código que puede
                comprobarse en{' '}
                <Link className="text-link" to="/verificar-certificado">
                  Verificar certificado
                </Link>
                , para anotarlo en su cartilla y en el libro de registro de la
                empresa.
              </span>
            </div>
          </div>
        </div>
        <p>
          La formación de la ITC 02.1.02 tiene carácter únicamente presencial:
          el Campus sirve de soporte teórico, de material y de seguimiento, y la
          parte presencial se organiza con Inmíner Ingeniería. Más detalle en la{' '}
          <Link className="text-link" to={GUIDE_PATHS.itc020102}>
            guía de la ITC 02.1.02
          </Link>
          .
        </p>
      </GuideSection>

      <GuideSection id="vencimientos" title="Controla los vencimientos de tu plantilla">
        <p>
          Cada puesto tiene su plazo de reciclaje. Con la{' '}
          <Link className="text-link" to={GUIDE_PATHS.refresherCalculator}>
            calculadora de reciclaje
          </Link>{' '}
          sabrás cuándo vence la formación de cada trabajador y podrás
          planificar las actualizaciones con antelación.
        </p>
      </GuideSection>

      <GuideSection id="preguntas-frecuentes" title="Preguntas frecuentes de empresas">
        <dl className="course-faq">
          {faqs.map((faq) => (
            <div className="course-faq__item" key={faq.question}>
              <dt>{faq.question}</dt>
              <dd className="muted">{faq.answer}</dd>
            </div>
          ))}
        </dl>
      </GuideSection>

      <div className="guide-links" style={{ marginTop: 40 }}>
        <a className="button button--primary" href={PROPOSAL_MAILTO}>
          Solicitar propuesta
        </a>
        <Link className="button button--outline" search={{ categoria: 'mineria' }} to="/catalogo">
          Ver cursos de minería
        </Link>
      </div>
    </StaticPage>
  )
}
