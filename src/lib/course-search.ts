import type { PublicCourse } from './types'

/**
 * Búsqueda del catálogo. Se separa del componente para poder probarla y para
 * que la misma regla valga si mañana se busca desde otro sitio.
 */

/** Minúsculas y sin acentos, para que «perforacion» encuentre «perforación». */
export function normalizeForSearch(value: string) {
  return value
    .trim()
    .toLocaleLowerCase('es')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
}

type SearchableCourse = Pick<
  PublicCourse,
  'title' | 'short_description' | 'specialty' | 'accreditation_reference'
>

/** Todo lo que la ficha muestra y por lo que tiene sentido buscar. */
export function searchableText(course: SearchableCourse) {
  return normalizeForSearch(
    [
      course.title,
      course.short_description,
      course.specialty,
      course.accreditation_reference,
    ]
      .filter(Boolean)
      .join(' '),
  )
}

/**
 * Cada palabra escrita debe aparecer en algún campo de la ficha. Así
 * «perforadora 20» encuentra el curso aunque las dos palabras estén en
 * campos distintos, y el orden en que se escriban da igual.
 */
export function matchesQuery(course: SearchableCourse, query: string) {
  const terms = normalizeForSearch(query).split(/\s+/).filter(Boolean)
  if (!terms.length) return true
  const haystack = searchableText(course)
  return terms.every((term) => haystack.includes(term))
}
