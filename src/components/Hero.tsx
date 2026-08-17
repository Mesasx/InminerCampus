import { ArrowDown } from 'lucide-react'
import type { ReactNode } from 'react'

export function Hero({
  image,
  imageAlt,
  actions,
  scrollTargetId,
}: {
  image: string
  imageAlt: string
  actions?: ReactNode
  scrollTargetId?: string
}) {
  return (
    <section className="campus-hero">
      <div className="campus-hero__frame">
        <img
          alt={imageAlt}
          className="campus-hero__image"
          decoding="async"
          fetchPriority="high"
          height="941"
          loading="eager"
          src={image}
          width="1672"
        />
        <span aria-hidden="true" id="campus-hero-sentinel" />
      </div>
      {actions || scrollTargetId ? (
        <div className="campus-hero__actions">
          {actions}
          {scrollTargetId ? (
            <a className="campus-hero__scroll" href={`#${scrollTargetId}`}>
              <span>Descubrir formación</span>
              <ArrowDown aria-hidden="true" size={16} />
            </a>
          ) : null}
        </div>
      ) : null}
    </section>
  )
}
