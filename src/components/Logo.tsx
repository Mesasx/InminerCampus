import { Link } from '@tanstack/react-router'
import type { MouseEventHandler } from 'react'

const officialLogoUrl = '/brand/inminer-logo-transparent.png'

export function Logo({
  inverse = false,
  onClick,
}: {
  inverse?: boolean
  onClick?: MouseEventHandler<HTMLAnchorElement>
}) {
  return (
    <Link
      className={inverse ? 'brand brand--inverse' : 'brand'}
      to="/"
      aria-label="InmínerCampus, ir al inicio"
      onClick={onClick}
    >
      <img
        className="brand__image"
        src={officialLogoUrl}
        alt="Inmíner Ingeniería"
        width="144"
        height="52"
      />
      <span className="brand__divider" aria-hidden="true" />
      <span
        className="brand__campus"
        style={inverse ? { color: 'rgba(255,255,255,.72)' } : undefined}
      >
        Campus
      </span>
    </Link>
  )
}
