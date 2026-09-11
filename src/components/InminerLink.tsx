import type { ReactNode } from 'react'
import { ORGANIZATION } from '../lib/seo'

/**
 * Menciones a la empresa titular en páginas públicas: siempre enlazadas a su
 * web corporativa. La dirección sale de `ORGANIZATION` para que no haya dos
 * fuentes de verdad si algún día cambia.
 *
 * Por convención se enlaza la primera mención de cada página; las siguientes se
 * dejan como texto, para no sembrar la página de enlaces al mismo destino.
 *
 * `children` permite usar la forma en que la página ya nombra a la empresa
 * («INMINER INGENIERÍA, S.L.», «INMÍNER») en lugar del nombre por defecto, y
 * `suffix` deja la forma societaria fuera del enlace cuando conviene.
 */
export function InminerLink({
  children,
  className = 'text-link',
  suffix,
}: {
  children?: ReactNode
  className?: string
  suffix?: string
}) {
  return (
    <>
      <a
        className={className}
        href={ORGANIZATION.corporateSite}
        rel="noopener noreferrer"
        target="_blank"
      >
        {children ?? ORGANIZATION.name}
      </a>
      {suffix}
    </>
  )
}
