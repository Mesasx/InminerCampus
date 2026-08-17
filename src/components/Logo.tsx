import { Link } from '@tanstack/react-router'
import type { MouseEventHandler } from 'react'

const logoUrl = '/brand/inminer-campus-logo.png'

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
      aria-label="Inmíner Campus, ir al inicio"
      onClick={onClick}
    >
      <img
        className="brand__image"
        src={logoUrl}
        alt="Inmíner Campus"
        width="1338"
        height="527"
      />
    </Link>
  )
}
