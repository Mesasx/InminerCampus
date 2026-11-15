import { createFileRoute, Link } from '@tanstack/react-router'
import { BadgeCheck, BookOpenCheck, ClipboardList, UserRoundCheck } from 'lucide-react'
import { StaticPage } from '../components/StaticPage'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/como-funciona')({
  head: () => seoHead({
    title: 'Cómo funciona el Campus',
    description:
      'Cómo se solicita, revisa y autoriza el acceso privado a la formación gestionada por Inmíner.',
    path: '/como-funciona',
  }),
  component: HowItWorksPage,
})

function HowItWorksPage() {
  const steps = [
    {
      icon: UserRoundCheck,
      title: '1. Solicita una cuenta',
      text: 'Identifícate, indica tu empresa y explica tu relación con Inmíner.',
    },
    {
      icon: UserRoundCheck,
      title: '2. Validación humana',
      text: 'Un administrador comprueba la solicitud antes de habilitar el área privada.',
    },
    {
      icon: BookOpenCheck,
      title: '3. Acceso autorizado',
      text: 'La formación asignada aparece en tu cuenta cuando Inmíner confirma la autorización correspondiente.',
    },
    {
      icon: ClipboardList,
      title: '4. Gestión individual',
      text: 'Inmíner confirma de forma personal el alcance, los requisitos y el seguimiento aplicables a cada acción.',
    },
  ]

  return (
    <StaticPage
      eyebrow="Cómo funciona"
      title="Un acceso controlado, desde la solicitud hasta la formación asignada."
      description="La plataforma es un entorno privado para personas y empresas vinculadas con Inmíner. Cada alta se revisa antes de mostrar contenido formativo."
    >
      <div className="feature-grid" style={{ gridTemplateColumns: '1fr 1fr' }}>
        {steps.map(({ icon: Icon, title, text }) => (
          <article className="feature-card" key={title}>
            <span className="feature-card__icon">
              <Icon size={23} />
            </span>
            <h2 style={{ fontSize: '1.25rem' }}>{title}</h2>
            <p className="muted" style={{ lineHeight: 1.7, marginBottom: 0 }}>
              {text}
            </p>
          </article>
        ))}
      </div>
      <div className="panel" style={{ marginTop: 28 }}>
        <h2>¿Necesitas información sobre un curso?</h2>
        <p className="muted" style={{ lineHeight: 1.7 }}>
          Consulta la introducción pública y pulsa «Más información». El equipo
          de Inmíner confirmará personalmente el alcance, los requisitos y el
          procedimiento de acceso que corresponda.
        </p>
        <Link className="button button--primary" to="/catalogo">
          Consultar cursos
        </Link>
      </div>
    </StaticPage>
  )
}
