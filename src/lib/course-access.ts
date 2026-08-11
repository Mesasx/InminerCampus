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

export function isCourseVisibleInCatalog(
  course: CatalogCourseVisibility,
): boolean {
  return course.slug === 'formacion-stvh' || course.listed !== false
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
