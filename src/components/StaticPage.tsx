import type { ReactNode } from 'react'
import { PublicLayout } from './PublicLayout'

export function StaticPage({
  eyebrow,
  title,
  description,
  children,
}: {
  eyebrow: string
  title: string
  description: string
  children: ReactNode
}) {
  return (
    <PublicLayout>
      <header className="page-hero">
        <div className="container">
          <span className="eyebrow">{eyebrow}</span>
          <h1>{title}</h1>
          <p>{description}</p>
        </div>
      </header>
      <section className="section">
        <div className="container">{children}</div>
      </section>
    </PublicLayout>
  )
}
