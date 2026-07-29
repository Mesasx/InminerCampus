import { createFileRoute, Link } from '@tanstack/react-router'
import { BadgeCheck, BookOpenCheck, ClipboardList, UserRoundCheck } from 'lucide-react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/como-funciona')({
  component: HowItWorksPage,
})

function HowItWorksPage() {
  const steps = [
    {
      icon: UserRoundCheck,
      title: '1. Crea tu cuenta',
      text: 'Confirma tu correo y accede a un entorno protegido con tus datos formativos.',
    },
    {
      icon: BookOpenCheck,
      title: '2. Accede al curso',
      text: 'Compra una matrícula individual o canjea el código que te facilite tu empresa.',
    },
    {
      icon: ClipboardList,
      title: '3. Completa la formación',
      text: 'Avanza por las lecciones, consulta los materiales y supera las evaluaciones configuradas.',
    },
    {
      icon: BadgeCheck,
      title: '4. Acredita el resultado',
      text: 'Cuando se cumplan todos los requisitos, incluido el bloque presencial si procede, se habilitará el certificado.',
    },
  ]

  return (
    <StaticPage
      eyebrow="Cómo funciona"
      title="Un recorrido claro, desde la matrícula hasta la acreditación."
      description="La plataforma organiza cada etapa de la formación y mantiene un registro coherente de las evidencias necesarias."
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
        <h2>La formación puede ser híbrida</h2>
        <p className="muted" style={{ lineHeight: 1.7 }}>
          Algunos programas requieren prácticas o sesiones presenciales. En esos
          casos, superar la teoría online no completa por sí sola el curso. La
          ficha de cada formación indicará los requisitos aplicables.
        </p>
        <Link className="button button--primary" to="/catalogo">
          Consultar cursos
        </Link>
      </div>
    </StaticPage>
  )
}
