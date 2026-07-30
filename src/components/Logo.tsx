import { Link } from '@tanstack/react-router'
import type { MouseEventHandler } from 'react'

const officialLogoUrl =
  'https://inminer.es/wp-content/uploads/2023/03/logo-inminer-2.png'

export function Logo({
  inverse = false,
  onClick,
}: {
  inverse?: boolean
  onClick?: MouseEventHandler<HTMLAnchorElement>
}) {
  return (
    <Link
      className="brand"
      to="/"
      aria-label="InmínerCampus, ir al inicio"
      onClick={onClick}
    >
      <img
        className="brand__image"
        src={officialLogoUrl}
        alt="Inmíner"
        width="112"
        height="34"
        style={inverse ? { filter: 'brightness(0) invert(1)' } : undefined}
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
