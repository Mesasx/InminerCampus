import { ArrowDown } from 'lucide-react'
import { Logo } from './Logo'

export function Hero({
  image,
  eyebrow,
  title,
  subtitle,
  ctaLabel,
  ctaTargetId,
}: {
  image: string
  eyebrow: string
  title: string
  subtitle: string
  ctaLabel: string
  ctaTargetId: string
}) {
  return (
    <section className="campus-hero">
      <span aria-hidden="true" className="campus-hero__scroll-sentinel" id="campus-hero-sentinel" />

      <div className="campus-hero__media" aria-hidden="true">
        <img
          alt=""
          className="campus-hero__image"
          decoding="async"
          fetchPriority="high"
          height="941"
          loading="eager"
          src={image}
          width="862"
        />
      </div>

      <div className="campus-hero__content">
        <div className="campus-hero__brand">
          <Logo />
        </div>
        <p className="campus-hero__eyebrow label-industrial">{eyebrow}</p>
        <p className="campus-hero__count">{title}</p>
        <p className="campus-hero__subtitle label-industrial">{subtitle}</p>
        <a
          className="campus-hero__cta"
          href={`#${ctaTargetId}`}
          onClick={(event) => {
            const target = document.getElementById(ctaTargetId)
            if (target) {
              event.preventDefault()
              target.scrollIntoView({ behavior: 'smooth', block: 'start' })
            }
          }}
        >
          {ctaLabel}
        </a>
      </div>

      <a className="campus-hero__scroll" href={`#${ctaTargetId}`}>
        <span>Descubrir</span>
        <ArrowDown aria-hidden="true" size={16} />
      </a>
    </section>
  )
}
