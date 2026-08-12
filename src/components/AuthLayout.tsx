import type { ReactNode } from 'react'
import { Logo } from './Logo'

export function AuthLayout({
  title,
  description,
  children,
}: {
  title: string
  description: string
  children: ReactNode
}) {
  return (
    <main className="auth-layout page-enter">
      <aside className="auth-side">
        <Logo inverse />
        <div className="auth-side__content">
          <span className="eyebrow" style={{ color: '#f3aa76' }}>
            Formación con rigor
          </span>
          <h1>Tu progreso, paso a paso.</h1>
          <p>
            Accede a tus cursos, continúa donde lo dejaste y mantén toda tu
            formación técnica organizada.
          </p>
        </div>
        <small style={{ color: 'rgba(255,255,255,.48)', position: 'relative' }}>
          Inmíner Ingeniería, S.L.
        </small>
      </aside>
      <section className="auth-main">
        <div className="auth-card">
          <div className="auth-mobile-brand">
            <Logo />
          </div>
          <h2>{title}</h2>
          <p className="auth-card__intro">{description}</p>
          {children}
        </div>
      </section>
    </main>
  )
}
