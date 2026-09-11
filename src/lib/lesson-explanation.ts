// Explicación detallada: un único intérprete para todos los cursos.
//
// Cada manual maestro se cargó en su momento con el vocabulario de apartados
// que usaba su propio PDF, y el reproductor los reconocía con una lista cerrada
// escrita dentro del componente. El resultado era desigual: los cursos cuyo
// texto encajaba con esa lista se leían como una página de manual y el resto
// caía a un bloque plano de texto.
//
// Este módulo separa la interpretación del contenido de su pintado. Recibe lo
// que hay guardado para una unidad (el cuerpo de la diapositiva y la nota del
// manual) y devuelve un documento con secciones tipadas que el componente
// pinta siempre igual, venga el texto del curso que venga.
//
// Reglas que se respetan aquí:
//   · No se inventa contenido ni se resume: sólo se estructura lo que existe.
//   · Las referencias editoriales (páginas, ficheros, bibliografía de origen)
//     no llegan al alumno, aunque sigan guardadas en la base de datos.
//   · La normativa que forma parte de la materia sí se conserva: se distingue
//     «Ley 31/1995 establece…», que es contenido, de «Fuente: página 22», que
//     es procedencia.

export type ExplanationBlock =
  | { type: 'paragraph'; text: string }
  | { type: 'subheading'; text: string }
  | { type: 'list'; ordered: boolean; items: string[] }

export type ExplanationTone =
  | 'plain'
  | 'key'
  | 'warning'
  | 'procedure'
  | 'example'

export type ExplanationSection = {
  heading: string | null
  tone: ExplanationTone
  blocks: ExplanationBlock[]
}

export type ExplanationDocument = {
  sections: ExplanationSection[]
}

export type ExplanationSource = {
  slideBody?: string | null
  noteSummary?: string | null
  noteKeyPoints?: string[] | null
  noteStopCriterion?: string | null
}

// Apartados que titulan los manuales maestros. La comparación se hace sin
// acentos ni mayúsculas, de modo que «OBJETIVO» y «Objetivo» son el mismo
// apartado y no hace falta duplicar entradas por cada manual.
const SECTION_HEADINGS: Array<[string, ExplanationTone]> = [
  ['Objetivo', 'plain'],
  ['Objetivo formativo', 'plain'],
  ['Definición y alcance', 'plain'],
  ['Explicación detallada', 'plain'],
  ['Explicación de base', 'plain'],
  ['Explicación vinculada al audio', 'plain'],
  ['Desarrollo detallado', 'plain'],
  ['Fundamento técnico ampliado', 'plain'],
  ['Profundización técnica', 'plain'],
  ['Profundización técnica y criterio preventivo', 'plain'],
  ['Riesgo que debe comprenderse', 'warning'],
  ['Riesgos y errores que deben evitarse', 'warning'],
  ['Errores críticos', 'warning'],
  ['Errores críticos que deben evitarse', 'warning'],
  ['Aplicación práctica', 'example'],
  ['Aplicación operativa', 'example'],
  ['Caso práctico razonado', 'example'],
  ['Caso razonado', 'example'],
  ['Criterio de actuación', 'procedure'],
  ['Secuencia operativa recomendada', 'procedure'],
  ['Secuencia de aplicación', 'procedure'],
  ['Comprobación antes de continuar', 'procedure'],
  ['Idea clave', 'key'],
  ['Idea central', 'key'],
]

// Apartados que sólo documentan de dónde salió el texto. Se reconocen para
// poder retirarlos: el alumno lee formación, no una ficha bibliográfica.
const EDITORIAL_HEADINGS = [
  'Referencias o fuentes del capítulo',
  'Referencias del capítulo',
  'Referencias',
  'Referencias bibliográficas',
  'Fuentes',
  'Fuentes del capítulo',
  'Fuente',
  'Bibliografía',
  'Procedencia',
]

// Los apartados que el manual escribe como secuencia se pintan numerados; los
// de riesgos, como lista de comprobación.
const ORDERED_TONES = new Set<ExplanationTone>(['procedure'])

function normalizeHeading(value: string) {
  return value
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[.:·]+$/, '')
    .trim()
    .toLowerCase()
}

const headingTones = new Map(
  SECTION_HEADINGS.map(([heading, tone]) => [
    normalizeHeading(heading),
    { heading, tone },
  ]),
)

const editorialHeadings = new Set(EDITORIAL_HEADINGS.map(normalizeHeading))

// Una línea es referencia editorial cuando sólo señala de dónde procede el
// texto. Se exige que la referencia abra la línea para no confundirla con el
// uso corriente de esas mismas palabras dentro de la materia («fuentes de
// ignición», «una referencia de aviso», «el manual del fabricante»).
const EDITORIAL_LINE_PATTERNS = [
  /^fuentes?\s*[:·—-]/i,
  /^referencias?\s*[:·—-]/i,
  /^origen(\s+del\s+contenido)?\s*[:·—-]/i,
  /^procedencia\s*[:·—-]/i,
  /^manual(\s+formativo)?\s*[:·]/i,
  /^documento\s*[:·]/i,
  /^p[áa]g(?:ina)?s?\.?\s*\d+/i,
  /^(?:diapositiva|slide)\s*\d+\s*$/i,
  /^(?:seg[úu]n|conforme\s+a|extra[íi]do\s+de|tomado\s+de)\s+(?:el\s+|la\s+)?documento\b/i,
  // Un nombre de archivo suelto, sin frase alrededor.
  /^[^\s]+\.(?:pdf|pptx?|docx?|xlsx?)$/i,
  // Rutas internas de almacenamiento.
  /^[\w-]+\/[\w/-]+\.[a-z0-9]{2,5}$/i,
]

// Identificador de mapeo que quedó como cuerpo de algunas diapositivas: sitúa
// la unidad dentro del bloque, pero no explica nada.
const MAPPING_PLACEHOLDER = /^parte\s+\d+(?:\.\d+)*\s+del\s+bloque\b/i

const BULLET = /^[•·*]\s*|^[-–—]\s+/
const NUMBERED = /^\d{1,2}[.)]\s+/

export function isEditorialLine(line: string) {
  const trimmed = line.trim()
  if (!trimmed) return false
  return EDITORIAL_LINE_PATTERNS.some((pattern) => pattern.test(trimmed))
}

function isEditorialHeading(line: string) {
  return editorialHeadings.has(normalizeHeading(line))
}

// Rótulo propio de una unidad concreta («Puestos comprendidos», «Riesgos
// vinculados a las interfaces»…). No caben en una lista cerrada porque cambian
// en cada unidad, así que se reconocen por forma: línea corta, sin puntuación
// final, seguida de más texto y que no es una viñeta.
function looksLikeSubheading(line: string, rest: string[]) {
  if (!rest.length) return false
  if (line.length < 3 || line.length > 94) return false
  if (BULLET.test(line) || NUMBERED.test(line)) return false
  return !/[.:;,]$/.test(line)
}

function cleanLines(block: string) {
  return block
    .split('\n')
    .map((line) => line.trim())
    .filter(Boolean)
    .filter((line) => !isEditorialLine(line))
}

function pushParagraphOrList(blocks: ExplanationBlock[], lines: string[]) {
  let pending: { ordered: boolean; items: string[] } | null = null

  const flush = () => {
    if (pending?.items.length) {
      blocks.push({
        type: 'list',
        ordered: pending.ordered,
        items: pending.items,
      })
    }
    pending = null
  }

  for (const line of lines) {
    const bullet = BULLET.test(line)
    const numbered = !bullet && NUMBERED.test(line)

    if (bullet || numbered) {
      const item = line.replace(BULLET, '').replace(NUMBERED, '').trim()
      if (!item) continue
      if (!pending || pending.ordered !== numbered) {
        flush()
        pending = { ordered: numbered, items: [] }
      }
      pending.items.push(item)
      continue
    }

    flush()
    blocks.push({ type: 'paragraph', text: line })
  }

  flush()
}

function parseText(text: string): ExplanationSection[] {
  const rawBlocks = text
    .split(/\n{2,}/)
    .map((block) => block.trim())
    .filter(Boolean)

  const sections: ExplanationSection[] = []
  // Una vez abierta la bibliografía, todo lo que sigue pertenece a ella hasta
  // que empiece otro apartado reconocido del manual.
  let inEditorialSection = false

  for (const rawBlock of rawBlocks) {
    const lines = cleanLines(rawBlock)
    if (!lines.length) continue

    const [first, ...rest] = lines
    const known = headingTones.get(normalizeHeading(first))

    if (known) {
      inEditorialSection = false
      const blocks: ExplanationBlock[] = []
      pushParagraphOrList(blocks, rest)
      sections.push({ heading: known.heading, tone: known.tone, blocks })
      continue
    }

    if (isEditorialHeading(first)) {
      inEditorialSection = true
      continue
    }
    if (inEditorialSection) continue

    if (MAPPING_PLACEHOLDER.test(first)) continue

    const active = sections.at(-1)

    if (active?.heading && looksLikeSubheading(first, rest)) {
      active.blocks.push({ type: 'subheading', text: first })
      pushParagraphOrList(active.blocks, rest)
      continue
    }

    if (active?.heading) {
      pushParagraphOrList(active.blocks, lines)
      continue
    }

    const blocks: ExplanationBlock[] = []
    pushParagraphOrList(blocks, lines)
    if (blocks.length) sections.push({ heading: null, tone: 'plain', blocks })
  }

  return sections.filter((section) => section.blocks.length > 0)
}

function sectionLength(sections: ExplanationSection[]) {
  return sections.reduce((total, section) => {
    return (
      total +
      section.blocks.reduce((count, block) => {
        if (block.type === 'list') {
          return count + block.items.join(' ').length
        }
        return count + block.text.length
      }, 0)
    )
  }, 0)
}

function hasHeadings(sections: ExplanationSection[]) {
  return sections.some((section) => section.heading)
}

/**
 * Construye la explicación que ve el alumno a partir de lo que hay guardado
 * para la unidad.
 *
 * El cuerpo de la diapositiva conserva la prioridad, que es como se ha mostrado
 * siempre. Se recurre a la nota del manual, que pertenece a esa misma unidad,
 * en dos casos: cuando el cuerpo no aporta ninguna explicación —porque es un
 * identificador de mapeo o una referencia editorial— y cuando el cuerpo es un
 * extracto sin apartados mientras que la nota sí conserva el desarrollo
 * completo del manual. En ninguno de los dos casos se cruza contenido entre
 * cursos ni entre unidades: ambas piezas son de la misma unidad.
 */
export function buildExplanation(
  source: ExplanationSource,
): ExplanationDocument {
  const fromSlide = parseText(source.slideBody ?? '')
  const fromNote = parseText(source.noteSummary ?? '')

  const slideIsUsable =
    sectionLength(fromSlide) > 0 &&
    (hasHeadings(fromSlide) || !hasHeadings(fromNote))

  let sections = slideIsUsable ? fromSlide : fromNote
  if (!sectionLength(sections)) sections = fromSlide

  if (!sections.length) {
    // Último recurso: cursos cuyo desarrollo se guardó troceado en la nota.
    const composed: ExplanationSection[] = []
    const keyPoints = (source.noteKeyPoints ?? [])
      .map((point) => point.trim())
      .filter(Boolean)

    if (keyPoints.length) {
      const blocks: ExplanationBlock[] = []
      pushParagraphOrList(blocks, keyPoints)
      composed.push({
        heading: 'Explicación detallada',
        tone: 'plain',
        blocks,
      })
    }

    const stopCriterion = source.noteStopCriterion?.trim()
    if (stopCriterion) {
      const blocks: ExplanationBlock[] = []
      pushParagraphOrList(blocks, cleanLines(stopCriterion))
      composed.push({
        heading: 'Criterio de actuación',
        tone: 'procedure',
        blocks,
      })
    }

    sections = composed
  }

  return { sections }
}

/**
 * Puntos y criterio de parada que la nota guarda aparte y que no están ya
 * dentro de la explicación elegida. Evita que el alumno lea dos veces la misma
 * frase cuando el manual repite la idea en los dos sitios.
 */
export function complementaryNote(
  document: ExplanationDocument,
  source: ExplanationSource,
) {
  const rendered = sectionLength(document.sections)
    ? document.sections
        .flatMap((section) =>
          section.blocks.flatMap((block) =>
            block.type === 'list' ? block.items : [block.text],
          ),
        )
        .join('\n')
    : ''

  const keyPoints = (source.noteKeyPoints ?? [])
    .map((point) => point.trim())
    .filter(Boolean)
    .filter((point) => !rendered.includes(point))

  const stopCriterionRaw = source.noteStopCriterion?.trim() ?? ''
  const stopCriterion =
    stopCriterionRaw && !rendered.includes(stopCriterionRaw)
      ? stopCriterionRaw
      : ''

  return { keyPoints, stopCriterion }
}

export function isOrderedTone(tone: ExplanationTone) {
  return ORDERED_TONES.has(tone)
}

export function explanationIsEmpty(document: ExplanationDocument) {
  return document.sections.length === 0
}
