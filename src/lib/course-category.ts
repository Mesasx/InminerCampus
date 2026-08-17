import type { PublicCourse } from './types'

export type CourseCategory = 'mineria' | 'otros'

export const categoryLabels: Record<CourseCategory, string> = {
  mineria: 'Minería',
  otros: 'Otros',
}

/**
 * Heurística de presentación: no existe todavía un campo de categoría en
 * `courses`, así que se aproxima por la referencia normativa (los cursos
 * mineros de Inmíner Campus citan una ITC 02.x.02) y, en su defecto, por
 * palabras clave del título/especialidad. A revisar cuando el catálogo
 * tenga categorías reales en Supabase.
 */
export function categoryOf(
  course: Pick<PublicCourse, 'specialty' | 'title'>,
): CourseCategory {
  const haystack = `${course.specialty ?? ''} ${course.title}`.toLocaleLowerCase(
    'es',
  )

  if (/\bitc\s*02\b/.test(haystack)) return 'mineria'

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
    'sílice',
    'silice',
  ]
  if (miningKeywords.some((keyword) => haystack.includes(keyword))) {
    return 'mineria'
  }

  return 'otros'
}
