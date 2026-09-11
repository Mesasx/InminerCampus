type SupabaseErrorLike = {
  code?: unknown
  message?: unknown
  details?: unknown
  hint?: unknown
}

type CatalogCourseVisibility = {
  slug: string
  listed?: boolean
}

/**
 * `listed = false` retira el curso de todas las superficies públicas: catálogo,
 * home, buscador, cursos relacionados, sitemap y ficha.
 *
 * Formación STVH tuvo aquí una excepción que la mostraba siempre. Se ha
 * retirado: es una formación privada que sólo se obtiene canjeando un código,
 * así que no debe aparecer en el catálogo ni responder por su URL a quien no
 * tenga acceso. Ocultarla no toca las matrículas existentes, que se leen desde
 * `enrollments` y siguen apareciendo en «Mis cursos».
 */
export function isCourseVisibleInCatalog(
  course: CatalogCourseVisibility,
): boolean {
  return course.listed !== false
}

export function isMissingCourseAccessColumnsError(error: unknown): boolean {
  if (!error || typeof error !== 'object') return false

  const { code, message, details, hint } = error as SupabaseErrorLike
  const errorCode = typeof code === 'string' ? code : ''
  const errorText = [message, details, hint]
    .filter((value): value is string => typeof value === 'string')
    .join(' ')

  return (
    (errorCode === '42703' || errorCode === 'PGRST204') &&
    /\b(access_mode|listed)\b/i.test(errorText)
  )
}
