import { ArrowDown } from 'lucide-react'
import type { ReactNode } from 'react'

export function Hero({
  image,
  imageAlt,
  eyebrow,
  title,
  subtitle,
  actions,
  scrollTargetId,
  compact = false,
}: {
  image: string
  imageAlt: string
  eyebrow: string
  title: ReactNode
  subtitle?: string
  actions?: ReactNode
  scrollTargetId?: string
  compact?: boolean
}) {
  return (
    <section className={`campus-hero texture-noise${compact ? ' campus-hero--compact' : ''}`}>
      <img
        alt={imageAlt}
        className="campus-hero__image"
        decoding="async"
        fetchPriority="high"
        height="900"
        loading="eager"
        src={image}
        width="1600"
      />
      <div className="campus-hero__shade" aria-hidden="true" />

      <div className="campus-hero__content">
        <p className="campus-hero__eyebrow label-industrial">{eyebrow}</p>
        <h1>{title}</h1>
        {subtitle ? <p className="campus-hero__copy">{subtitle}</p> : null}
        {actions ? <div className="campus-hero__actions">{actions}</div> : null}
      </div>

      {scrollTargetId ? (
        <a className="campus-hero__scroll" href={`#${scrollTargetId}`}>
          <span>Descubrir formación</span>
          <ArrowDown aria-hidden="true" size={16} />
        </a>
      ) : null}

      <span aria-hidden="true" id="campus-hero-sentinel" />
    </section>
  )
}
