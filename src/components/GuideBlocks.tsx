import { ExternalLink } from 'lucide-react'
import type { ReactNode } from 'react'
import { formatReviewDate } from '../lib/format-date'

export type OfficialSource = { label: string; detail?: string; url: string }

/**
 * Bloque «Fuentes oficiales» de las guías. Los enlaces van al BOE o al
 * Ministerio, nunca a resúmenes de terceros.
 */
export function OfficialSources({ sources }: { sources: Array<OfficialSource> }) {
  return (
    <section className="guide-section guide-sources" aria-labelledby="fuentes-oficiales">
      <h2 id="fuentes-oficiales">Fuentes oficiales</h2>
      <ul>
        {sources.map((source) => (
          <li key={source.url}>
            <a href={source.url} rel="noopener noreferrer" target="_blank">
              {source.label}
              <ExternalLink aria-hidden="true" size={14} />
            </a>
            {source.detail ? <span className="muted"> · {source.detail}</span> : null}
          </li>
        ))}
      </ul>
    </section>
  )
}

/** Nota de autoría y revisión visible, coherente con `dateModified`. */
export function GuideReviewNote({
  reviewedAt,
  children,
}: {
  reviewedAt: string
  children?: ReactNode
}) {
  return (
    <p className="legal-note guide-review-note">
      Contenido elaborado por Inmíner Ingeniería a partir del texto publicado en
      el BOE. Última revisión: <time dateTime={reviewedAt}>{formatReviewDate(reviewedAt)}</time>.{' '}
      {children ??
        'Esta guía es informativa y no sustituye la lectura de la norma ni la evaluación de riesgos de cada centro de trabajo.'}
    </p>
  )
}

/** Sección con encabezado H2 anclable. */
export function GuideSection({
  id,
  title,
  children,
}: {
  id: string
  title: string
  children: ReactNode
}) {
  return (
    <section className="guide-section" aria-labelledby={id}>
      <h2 id={id}>{title}</h2>
      {children}
    </section>
  )
}
