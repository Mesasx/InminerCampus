import { createFileRoute, Link } from '@tanstack/react-router'
import { Building2, ClipboardCheck, ShieldCheck, UsersRound } from 'lucide-react'
import { CourseInquiryButton } from '../components/CourseInquiryButton'
import { JsonLd } from '../components/JsonLd'
import { StaticPage } from '../components/StaticPage'
import {
  breadcrumbSchema,
  campusReference,
  type BreadcrumbItem,
} from '../lib/schema'
import { absoluteUrl, seoHead } from '../lib/seo'

const PATH = '/empresas'

const breadcrumbs: Array<BreadcrumbItem> = [
  { name: 'Inicio', path: '/' },
  { name: 'Formación para empresas', path: PATH },
]

export const Route = createFileRoute('/empresas')({
  head: () =>
    seoHead({
      title: 'Formación técnica para empresas | InmínerCampus',
      description:
        'Información para empresas vinculadas con Inmíner que necesitan coordinar formación técnica y preventiva para su personal.',
      path: PATH,
    }),
  component: CompaniesPage,
})

function CompaniesPage() {
  return (
    <StaticPage
      breadcrumbs={breadcrumbs}
      eyebrow="Empresas"
      title="Formación coordinada personalmente con cada empresa."
      description="Inmíner estudia la necesidad, comprueba el encaje técnico y organiza el acceso de cada participante dentro de una relación profesional previamente validada."
    >
      <JsonLd
        nodes={[
          {
            '@type': 'Service',
            '@id': `${absoluteUrl(PATH)}#service`,
            name: 'Coordinación de formación técnica para empresas',
            serviceType: 'Formación técnica y preventiva',
            url: absoluteUrl(PATH),
            provider: campusReference(),
            areaServed: { '@type': 'Country', name: 'España' },
            audience: {
              '@type': 'BusinessAudience',
              audienceType:
                'Empresas cliente, colaboradoras y organizaciones vinculadas con Inmíner',
            },
          },
          breadcrumbSchema(breadcrumbs),
        ]}
      />

      <div className="feature-grid">
        <article className="feature-card">
          <span className="feature-card__icon"><Building2 size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Análisis de la necesidad</h2>
          <p>
            Revisamos puestos, actividad, referencia técnica y personas
            destinatarias antes de concretar la acción formativa.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon"><ShieldCheck size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Acceso validado</h2>
          <p>
            Cada cuenta se identifica y aprueba manualmente. El registro por sí
            solo no habilita materiales ni evaluaciones.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon"><UsersRound size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Asignación individual</h2>
          <p>
            Inmíner confirma qué formación corresponde y asigna el acceso a las
            personas autorizadas de la organización.
          </p>
        </article>
        <article className="feature-card">
          <span className="feature-card__icon"><ClipboardCheck size={23} /></span>
          <h2 style={{ fontSize: '1.2rem' }}>Seguimiento trazable</h2>
          <p>
            El Campus conserva la evolución, las evaluaciones y las evidencias
            que correspondan a la acción formativa acordada.
          </p>
        </article>
      </div>

      <section className="panel" style={{ marginTop: 32 }}>
        <span className="eyebrow">Contacto previo</span>
        <h2>Cuéntanos qué necesita tu empresa.</h2>
        <p className="muted" style={{ lineHeight: 1.75 }}>
          El catálogo muestra únicamente una introducción de cada programa. El
          equipo de Inmíner confirmará personalmente el alcance, los requisitos
          y el procedimiento de acceso adecuado para vuestra organización.
        </p>
        <div className="guide-links">
          <CourseInquiryButton className="button button--primary" />
          <Link className="button button--outline" to="/catalogo">
            Consultar introducciones
          </Link>
        </div>
      </section>
    </StaticPage>
  )
}
