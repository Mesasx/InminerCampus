// Relaciona las guías normativas con los cursos publicados.
//
// Las guías no escriben slugs a mano: leen el catálogo publicado y emparejan
// cada curso con la norma que cita en su referencia (`accreditation_reference`
// o `specialty`). Así, publicar o retirar un curso actualiza solo los enlaces
// de las guías y nunca queda un enlace a una ficha que ya no existe.
import { ITC_02_0_02, TECHNICAL_SPECIFICATIONS } from './mining-regulation.ts'
import { isIndexableCourse } from './course-access.ts'
import type { PublicCourseDetail } from './public-courses.ts'

export type GuideCourse = {
  slug: string
  title: string
  references: string
  durations: Array<number>
  /** `true` si alguna versión publicada es de reciclaje (5 h o menos). */
  hasRefresher: boolean
  /** `true` si alguna versión publicada es de formación inicial (más de 5 h). */
  hasInitial: boolean
  modality: string
  practiceRequired: boolean
}

function referencesOf(course: PublicCourseDetail): string {
  return [
    course.specialty,
    ...course.versions.map((version) => version.accreditation_reference ?? ''),
  ]
    .join(' ')
    .replace(/\s+/g, ' ')
}

export function toGuideCourse(course: PublicCourseDetail): GuideCourse {
  const durations = [
    ...new Set(course.versions.map((version) => version.duration_hours)),
  ].sort((a, b) => a - b)
  return {
    slug: course.slug,
    title: course.title,
    references: referencesOf(course),
    durations,
    hasRefresher: durations.some((hours) => hours <= 5),
    hasInitial: durations.some((hours) => hours > 5),
    modality: course.versions[0]?.modality ?? 'online',
    practiceRequired: course.versions.some((version) => version.practice_required),
  }
}

/** Cursos comercializados y con ficha indexable. */
export function guideCatalog(
  courses: Array<PublicCourseDetail>,
): Array<GuideCourse> {
  return courses.filter(isIndexableCourse).map(toGuideCourse)
}

/** Cursos que citan una especificación técnica concreta. */
export function coursesForSpecification(
  catalog: Array<GuideCourse>,
  code: string,
): Array<GuideCourse> {
  return catalog.filter((course) => course.references.includes(code))
}

/** Cursos encuadrados en la ITC 02.1.02 (cualquier especificación). */
export function itc020102Courses(catalog: Array<GuideCourse>) {
  return catalog.filter((course) => /ITC\s*02\.?1\.?02/i.test(course.references))
}

/** Cursos encuadrados en la ITC 02.0.02. */
export function itc020002Courses(catalog: Array<GuideCourse>) {
  return catalog.filter(
    (course) =>
      course.references.includes(ITC_02_0_02.code) ||
      /TED\/723\/2021/.test(course.references),
  )
}

/** Especificaciones formativas (todas salvo la de documentación) con sus cursos. */
export function specificationsWithCourses(catalog: Array<GuideCourse>) {
  return TECHNICAL_SPECIFICATIONS.map((spec) => ({
    spec,
    courses: coursesForSpecification(catalog, spec.code),
  }))
}
