import type { PublicCourse } from './types'

export type CourseCategory = 'vip' | 'mineria' | 'otros'

export const categoryLabels: Record<CourseCategory, string> = {
  vip: 'VIP',
  mineria: 'Minería',
  otros: 'Otros',
}

const miningKeywords = [
  'miner',
  'mina',
  'maquinaria',
  'cantera',
  'árido',
  'arido',
  'voladura',
  'explotación',
  'explotacion',
  'cielo abierto',
  'vial',
]

/**
 * Heurística de presentación: no existe todavía un campo de categoría en
 * `courses`, así que se aproxima por especialidad/título/modo de acceso.
 * A revisar cuando el catálogo tenga categorías reales en Supabase.
 */
export function categoryOf(
  course: Pick<PublicCourse, 'specialty' | 'title' | 'access_mode'>,
): CourseCategory {
  if (course.access_mode === 'access_code') return 'vip'

  const haystack = `${course.specialty ?? ''} ${course.title}`.toLocaleLowerCase('es')
  if (miningKeywords.some((keyword) => haystack.includes(keyword))) return 'mineria'

  return 'otros'
}
