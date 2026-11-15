import type { ReactNode } from 'react'
import { InminerLink } from './InminerLink'
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
          <span className="label-industrial auth-side__eyebrow">
            Entorno profesional
          </span>
          <h1>Acceso privado y supervisado.</h1>
          <p>
            Cada cuenta se identifica y revisa antes de habilitar cualquier
            formación asignada por Inmíner.
          </p>
        </div>
        <small className="auth-side__credit">
          <InminerLink className="auth-side__credit-link" suffix=", S.L." />
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
