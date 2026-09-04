// Clasificación de indexación de todas las rutas públicas del sitio.
//
// Es la fuente única que consumen el sitemap y los tests de SEO, para que no
// se pueda añadir una ruta al sitemap sin declarar antes si debe indexarse.
export type StaticRoute = {
  path: string
  /** Prioridad relativa dentro del sitio (no es una señal de ranking). */
  priority: number
  changefreq: 'daily' | 'weekly' | 'monthly' | 'yearly'
}

/** Páginas públicas con contenido propio que deben entrar en el índice. */
export const INDEXABLE_STATIC_ROUTES: Array<StaticRoute> = [
  { path: '/', priority: 1.0, changefreq: 'weekly' },
  { path: '/catalogo', priority: 0.9, changefreq: 'weekly' },
  { path: '/catalogo?categoria=mineria', priority: 0.9, changefreq: 'weekly' },
  { path: '/formacion-preventiva-oficial', priority: 0.9, changefreq: 'monthly' },
  { path: '/sobre-nosotros', priority: 0.7, changefreq: 'monthly' },
  { path: '/empresas', priority: 0.7, changefreq: 'monthly' },
  { path: '/como-funciona', priority: 0.6, changefreq: 'monthly' },
  { path: '/contacto', priority: 0.6, changefreq: 'yearly' },
  { path: '/verificar-certificado', priority: 0.4, changefreq: 'yearly' },
  { path: '/legal/aviso', priority: 0.2, changefreq: 'yearly' },
  { path: '/legal/privacidad', priority: 0.2, changefreq: 'yearly' },
  { path: '/legal/cookies', priority: 0.2, changefreq: 'yearly' },
  { path: '/legal/contratacion', priority: 0.2, changefreq: 'yearly' },
]

/**
 * Rutas que nunca deben indexarse.
 *
 * Son de tres tipos: (a) zonas privadas tras autenticación, (b) pasos
 * intermedios de compra y (c) formularios de acceso sin valor de búsqueda.
 * `robots.txt` sólo evita el rastreo; la protección real de (a) es la
 * autenticación, que no se toca aquí.
 */
export const NOINDEX_ROUTE_PREFIXES = [
  '/acceso',
  '/registro',
  '/recuperar-contrasena',
  '/nueva-contrasena',
  '/canjear-codigo',
  '/perfil',
  '/mis-cursos',
  '/certificados',
  '/facturas',
  '/dudas',
  '/campus',
  '/evaluacion',
  '/comprar',
  '/comprar-empresa',
  '/pago',
  '/empresa',
  '/admin',
  '/api',
]

/** `true` si la ruta cae en una zona que no debe indexarse. */
export function isNoindexPath(path: string): boolean {
  const [pathname] = path.split(/[?#]/)
  return NOINDEX_ROUTE_PREFIXES.some(
    (prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`),
  )
}
