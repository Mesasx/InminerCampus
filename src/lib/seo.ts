// Fuente única de verdad para los metadatos SEO del sitio público.
//
// El dominio canónico es fijo a propósito: los despliegues de vista previa de
// Vercel y el desarrollo local deben seguir declarando la URL de producción en
// `<link rel="canonical">`, que es lo que Google debe indexar. Usar aquí
// `VITE_APP_URL` haría que un preview publicase canonicals hacia sí mismo.
export const SITE_URL = 'https://inminercampus.com'

export const SITE_NAME = 'InmínerCampus'

/** Imagen por defecto para Open Graph. Debe existir en `public/`. */
export const DEFAULT_OG_IMAGE = '/brand/inminer-campus-logo.png'

/**
 * Datos de la empresa titular. Coinciden literalmente con el aviso legal
 * (`src/routes/legal.$legalSlug.tsx`) para mantener el NAP consistente entre
 * la página legal, los datos estructurados y las fichas externas.
 */
export const ORGANIZATION = {
  legalName: 'INMINER INGENIERÍA, S.L.',
  name: 'Inmíner Ingeniería',
  brand: SITE_NAME,
  vatID: 'ESB13476148',
  taxID: 'B13476148',
  streetAddress: 'Calle La Solana, 60',
  postalCode: '13005',
  addressLocality: 'Ciudad Real',
  addressRegion: 'Castilla-La Mancha',
  addressCountry: 'ES',
  telephone: '+34926219417',
  email: 'administracion@inminer.es',
  corporateSite: 'https://inminer.es',
} as const

export function absoluteUrl(path: string): string {
  if (/^https?:\/\//i.test(path)) return path
  return `${SITE_URL}${path.startsWith('/') ? path : `/${path}`}`
}

/**
 * Normaliza una ruta a su forma canónica: sin fragmento y sin barra final
 * (salvo la home).
 *
 * La query se conserva porque cada ruta declara explícitamente su canónica: el
 * catálogo filtrado por categoría es una URL propia (`?categoria=mineria`),
 * mientras que la ficha de curso pasa siempre `/cursos/<slug>` sin parámetros,
 * de modo que todas las variantes `?version=` apuntan a la URL limpia.
 */
export function canonicalPath(path: string): string {
  const [withoutHash] = path.split('#')
  const [pathname, query] = withoutHash.split('?')
  if (!pathname || pathname === '/') return query ? `/?${query}` : '/'
  const trimmed = pathname.endsWith('/') ? pathname.slice(0, -1) : pathname
  return query ? `${trimmed}?${query}` : trimmed
}

export type SeoInput = {
  /** Título propio de la página, sin el sufijo de marca. */
  title: string
  description: string
  /** Ruta del sitio, p. ej. `/cursos/mi-curso`. */
  path: string
  image?: string
  /** `true` para páginas privadas o sin valor de búsqueda. */
  noindex?: boolean
  /** `website` para páginas de sitio, `article` para contenido editorial. */
  type?: 'website' | 'article'
}

type HeadTag = Record<string, string>

/**
 * Construye el bloque `head` de una ruta: título, descripción, canonical,
 * Open Graph, Twitter y directivas de indexación.
 */
export function seoHead(input: SeoInput): {
  meta: Array<HeadTag>
  links: Array<HeadTag>
} {
  const canonical = absoluteUrl(canonicalPath(input.path))
  const fullTitle = buildTitle(input.title)
  const image = absoluteUrl(input.image ?? DEFAULT_OG_IMAGE)

  const meta: Array<HeadTag> = [
    { title: fullTitle },
    { name: 'description', content: input.description },
    {
      name: 'robots',
      content: input.noindex
        ? 'noindex, nofollow'
        : 'index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1',
    },
    { property: 'og:title', content: fullTitle },
    { property: 'og:description', content: input.description },
    { property: 'og:url', content: canonical },
    { property: 'og:type', content: input.type ?? 'website' },
    { property: 'og:site_name', content: SITE_NAME },
    { property: 'og:locale', content: 'es_ES' },
    { property: 'og:image', content: image },
    { name: 'twitter:card', content: 'summary_large_image' },
    { name: 'twitter:title', content: fullTitle },
    { name: 'twitter:description', content: input.description },
    { name: 'twitter:image', content: image },
  ]

  const links: Array<HeadTag> = []
  // Una página `noindex` no debe declarar canonical: son señales
  // contradictorias y Google puede acabar ignorando el `noindex`.
  if (!input.noindex) {
    links.push({ rel: 'canonical', href: canonical })
  }

  return { meta, links }
}

/** Añade el sufijo de marca salvo que el título ya lo incluya. */
export function buildTitle(title: string): string {
  const trimmed = title.trim()
  if (!trimmed) return SITE_NAME
  if (trimmed.toLowerCase().includes(SITE_NAME.toLowerCase())) return trimmed
  return `${trimmed} | ${SITE_NAME}`
}

/**
 * Recorta una descripción al rango que Google suele mostrar sin truncar,
 * cortando por palabra completa.
 */
export function clampDescription(text: string, max = 158): string {
  const normalized = text.replace(/\s+/g, ' ').trim()
  if (normalized.length <= max) return normalized
  const cut = normalized.slice(0, max)
  const lastSpace = cut.lastIndexOf(' ')
  return `${(lastSpace > max * 0.6 ? cut.slice(0, lastSpace) : cut).replace(/[,;:.\s]+$/, '')}…`
}
