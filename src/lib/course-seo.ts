// Metadatos y preguntas frecuentes derivados de los datos reales del curso.
//
// Regla de precisión legal que se aplica en todo el archivo: ningún texto
// generado aquí afirma que una formación sea «oficial», «homologada» o
// «habilitante». Los enunciados normativos se limitan a (a) reproducir el
// campo `accreditation_reference` guardado en Supabase y (b) citar de forma
// literal y atribuida el BOE. Todo lo demás sale de los datos de la versión
// publicada (horas, modalidad, práctica, periodicidad de renovación).
import { modalityLabel } from './format.ts'
import type { PublicCourseDetail, PublicCourseVersion } from './public-courses.ts'
import type { FaqItem } from './schema.ts'
import { clampDescription } from './seo.ts'

/**
 * Referencia literal del BOE. La ITC 02.1.02 fue modificada por la Orden
 * ITC/2699/2011, de 4 de octubre, que añadió que la formación regulada en ella
 * «tendrá únicamente carácter presencial». Es el dato que impide describir
 * estos cursos como formación online y el que se explica al usuario.
 */
export const ITC_02_1_02_PRESENCIAL = {
  quote:
    'La formación regulada en la presente instrucción técnica complementaria tendrá únicamente carácter presencial.',
  source: 'Orden ITC/2699/2011, de 4 de octubre (BOE-A-2011-15940)',
  url: 'https://www.boe.es/diario_boe/txt.php?id=BOE-A-2011-15940',
} as const

/** `true` si la ficha cita la ITC 02.1.02 en su referencia normativa. */
export function isItc020102(course: PublicCourseDetail): boolean {
  return course.versions.some((version) =>
    /itc\s*02\.?1\.?02/i.test(version.accreditation_reference ?? ''),
  )
}

/** Referencia normativa mostrada en la ficha, si las versiones la comparten. */
export function normativeReference(
  course: PublicCourseDetail,
): string | null {
  const references = new Set(
    course.versions
      .map((version) => version.accreditation_reference)
      .filter((reference): reference is string => Boolean(reference)),
  )
  return references.size === 1 ? [...references][0] : null
}

/** Duraciones publicadas, ordenadas y sin repetir: p. ej. `[5, 20]`. */
export function durations(course: PublicCourseDetail): Array<number> {
  return [
    ...new Set(course.versions.map((version) => version.duration_hours)),
  ].sort((a, b) => a - b)
}

function durationsLabel(course: PublicCourseDetail): string {
  const hours = durations(course)
  if (!hours.length) return ''
  if (hours.length === 1) return `${hours[0]} horas`
  return `${hours.slice(0, -1).join(', ')} y ${hours[hours.length - 1]} horas`
}

/**
 * Título de la ficha. Se antepone «Curso» porque es como se formula la
 * búsqueda real, y el nombre del puesto se mantiene literal para no separarse
 * de la denominación de la especificación técnica.
 */
export function courseMetaTitle(course: PublicCourseDetail): string {
  return `Curso ${course.title}`
}

/**
 * Descripción de la ficha: qué es, cuántas horas y bajo qué norma. Se
 * construye a partir de los campos publicados y se recorta a la longitud que
 * Google muestra sin truncar.
 */
export function courseMetaDescription(course: PublicCourseDetail): string {
  const parts = [course.short_description.replace(/\s+$/, '')]

  const hours = durationsLabel(course)
  if (hours) parts.push(`${hours}.`)

  const reference = normativeReference(course)
  if (reference) parts.push(`${reference}.`)

  const base = parts.filter(Boolean).join(' ')

  // La firma de marca sólo se añade si cabe entera: recortarla a mitad de
  // palabra deja la descripción peor de lo que estaba sin ella.
  const signed = `${base} Formación de Inmíner Ingeniería.`
  return clampDescription(signed.length <= 158 ? signed : base)
}

/** Etiqueta de la versión cuando el curso publica inicial y reciclaje. */
export function versionLabel(
  course: PublicCourseDetail,
  version: PublicCourseVersion,
): string | null {
  if (durations(course).length < 2) return null
  // El reciclaje es la versión corta: la ITC 02.1.02 fija para los cursos de
  // reciclaje o actualización un mínimo de cinco horas lectivas.
  return version.duration_hours <= 5 ? 'Reciclaje periódico' : 'Formación inicial'
}

/**
 * Preguntas frecuentes de la ficha.
 *
 * Se emiten como texto visible y, a partir de esa misma lista, como
 * `FAQPage`; nunca se genera una pregunta cuyo dato no exista.
 */
export function courseFaqs(course: PublicCourseDetail): Array<FaqItem> {
  const faqs: Array<FaqItem> = []
  const hours = durationsLabel(course)
  const reference = normativeReference(course)
  const requiresPractice = course.versions.some(
    (version) => version.practice_required,
  )

  if (hours) {
    const hoursList = durations(course)
    faqs.push({
      question: '¿Cuántas horas tiene esta formación?',
      answer:
        hoursList.length > 1
          ? `Se publican ${hours}: la versión larga corresponde a la formación inicial y la corta al reciclaje o actualización de conocimientos.`
          : `La formación es de ${hours}.`,
    })
  }

  if (isItc020102(course)) {
    faqs.push({
      question: '¿Esta formación se puede realizar íntegramente online?',
      answer:
        `No. ${ITC_02_1_02_PRESENCIAL.source} establece que «${ITC_02_1_02_PRESENCIAL.quote}» ` +
        'Por eso esta formación figura con modalidad híbrida: el Campus se utiliza como soporte teórico, ' +
        'de material y de seguimiento del itinerario, y la parte presencial se realiza con Inmíner Ingeniería. ' +
        'Desconfía de cualquier oferta que presente esta formación como un curso íntegramente online.',
    })
  } else {
    const modalities = [
      ...new Set(course.versions.map((version) => version.modality)),
    ]
    if (modalities.length === 1) {
      faqs.push({
        question: '¿En qué modalidad se imparte?',
        answer: `Modalidad ${modalityLabel(modalities[0]).toLocaleLowerCase('es')}.${
          reference ? ` Esta formación se encuadra en ${reference}.` : ''
        }${
          requiresPractice
            ? ' Incluye la práctica presencial indicada en el programa.'
            : ''
        }`,
      })
    }
  }

  if (reference) {
    faqs.push({
      question: '¿Qué normativa regula esta formación?',
      answer: `La referencia normativa de esta formación es ${reference}, dentro del Reglamento General de Normas Básicas de Seguridad Minera.`,
    })
  }

  const renewal = course.versions.find(
    (version) => version.renewal_interval_months,
  )?.renewal_interval_months
  if (renewal) {
    const years = renewal % 12 === 0 ? renewal / 12 : null
    faqs.push({
      question: '¿Cada cuánto hay que renovar la formación?',
      answer: `El intervalo máximo de renovación previsto para esta formación es de ${renewal} meses${
        years ? ` (${years} ${years === 1 ? 'año' : 'años'})` : ''
      }.`,
    })
  }

  if (course.access_mode === 'purchase') {
    faqs.push({
      question: '¿Se puede contratar para varios trabajadores de una empresa?',
      answer:
        'Sí. La contratación para empresa permite adquirir varias licencias y repartirlas entre los trabajadores mediante códigos de acceso, con la facturación a nombre de la empresa.',
    })
  }

  return faqs
}
