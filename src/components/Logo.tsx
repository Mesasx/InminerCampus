import { Link } from '@tanstack/react-router'
import type { MouseEventHandler } from 'react'

const logoUrl = '/brand/inminer-campus-logo.png'
// Copia WebP de 420 px del mismo logotipo: se pinta a 46 px de alto, así que
// el PNG original (1338 px, ~400 KB) se descargaba en todas las páginas para
// nada. El PNG sigue siendo la referencia para correos, PDF y Open Graph.
const logoWebpUrl = '/brand/inminer-campus-logo.webp'

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
      <picture>
        <source srcSet={logoWebpUrl} type="image/webp" />
        <img
          className="brand__image"
          src={logoUrl}
          alt="Inmíner Campus"
          width="1338"
          height="527"
        />
      </picture>
    </Link>
  )
}
