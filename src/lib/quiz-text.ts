// Limpieza del texto de las preguntas antes de mostrarlo al alumno.
//
// Los bancos de preguntas se importan de libros de trabajo editoriales en los
// que algunos enunciados y opciones arrastran su procedencia: «(Diapositiva 8)»,
// «Tema 2 ·», «Fuente: slide 14», «según la diapositiva»… Esa referencia sirve
// al equipo para mantener y trazar el banco, pero durante el examen le dice al
// alumno dónde está la respuesta. Por eso no se borra de Supabase: se deja de
// mostrar.
//
// La RPC `start_quiz_attempt` sólo entrega al navegador el enunciado y el texto
// de las opciones (nunca `explanation`), y la RLS impide leer `questions`
// directamente, así que estos dos campos son los únicos que hay que limpiar.
//
// Las reglas sólo actúan sobre marcas inequívocas de procedencia: una palabra
// de referencia (diapositiva, slide, lámina, tema, unidad…) acompañada de su
// número, o la mención explícita a «la diapositiva». «Según el manual» no se
// toca: en estas preguntas suele aludir al manual del fabricante de la
// máquina, que forma parte del contenido evaluado.

// Palabra de referencia + número o código («8», «1.3», «41–42»).
const NUMBER = String.raw`\d+(?:[.,]\d+)*(?:\s*[-–—/y]\s*\d+(?:[.,]\d+)*)*`
const SLIDE_WORD = String.raw`(?:diapositivas?|diap\.?|slides?|l[áa]minas?|transparencias?)`
// Sin número sólo se consideran referencia las palabras que no tienen otro
// sentido en minería: «lámina» o «transparencia» pueden ser contenido real.
const SLIDE_BARE = String.raw`(?:diapositivas?|diap\.|slides?)`
const SECTION_WORD = String.raw`(?:temas?|unidad(?:es)?|bloques?|apartados?|secci[óo]n(?:es)?|cap[íi]tulos?|m[óo]dulos?|p[áa]g(?:ina)?s?\.?)`
const REFERENCE = String.raw`(?:${SLIDE_WORD}\s*(?:n\.?[ºo°]\s*)?${NUMBER}|${SECTION_WORD}\s*(?:n\.?[ºo°]\s*)?${NUMBER})`
const LABELED_SOURCE = String.raw`(?:fuente|origen|ref(?:erencia)?\.?|source)\s*:`

const PATTERNS: Array<[RegExp, string]> = [
  // «(Diapositiva 8)», «[Tema 2, slide 5]», «(Fuente: diapositiva 8)», «(D8)».
  [
    new RegExp(
      String.raw`\s*[([](?:\s*(?:${LABELED_SOURCE}\s*)?(?:${REFERENCE}|${SLIDE_BARE}|D\d{1,3})\b[^)\]]*)[)\]]`,
      'gi',
    ),
    '',
  ],
  // «Fuente: …» hasta el final del texto o de la frase.
  [new RegExp(String.raw`\s*[-–—·|]?\s*${LABELED_SOURCE}[^?¿\n]*$`, 'gi'), ''],
  // Etiqueta inicial: «Diapositiva 8:», «Tema 2 · », «Slide 14 -», «D8 - ».
  [
    new RegExp(
      String.raw`^\s*(?:(?:${REFERENCE}|D\d{1,3})\s*(?:[,;]\s*)?)+\s*[:·|\-–—.)]\s*`,
      'i',
    ),
    '',
  ],
  // Referencia final suelta tras un separador: «… correcta? — Diapositiva 8».
  [
    new RegExp(String.raw`\s*[-–—·|]\s*(?:${REFERENCE}\s*(?:[,;]\s*)?)+\.?\s*$`, 'i'),
    '',
  ],
  // Menciones dentro de la frase: «según la diapositiva (8)», «que aparece en
  // la slide 14», «de acuerdo con el tema 3».
  [
    new RegExp(
      String.raw`,?\s*(?:(?:que\s+(?:aparece|se\s+(?:muestra|indica|recoge|ve))\s+)?(?:seg[úu]n|en|de\s+acuerdo\s+con|conforme\s+a|como\s+(?:indica|muestra|recoge))\s+(?:la|el|lo\s+que\s+(?:indica|muestra)\s+la)\s+)(?:${REFERENCE}|${SLIDE_BARE})`,
      'gi',
    ),
    '',
  ],
]

/**
 * Devuelve el texto sin referencias a su procedencia (diapositiva, tema,
 * unidad, fuente…). Si la limpieza dejase el texto vacío, se conserva el
 * original: es preferible una referencia visible a una pregunta en blanco.
 */
export function stripSourceReferences(text: string): string {
  let result = text
  for (const [pattern, replacement] of PATTERNS) {
    result = result.replace(pattern, replacement)
  }
  // Un texto sin referencias se devuelve intacto: la normalización de abajo
  // sólo repara los huecos que deja un inciso retirado.
  if (result === text) return text
  result = result
    // Espacios que quedan antes de la puntuación al retirar un inciso.
    .replace(/\s+([?!.,;:)\]])/g, '$1')
    .replace(/([¿¡([])\s+/g, '$1')
    .replace(/,([?!.])/g, '$1')
    .replace(/\s{2,}/g, ' ')
    // Un inciso retirado al principio deja una coma o dos puntos huérfanos.
    .replace(/^[\s,;:·|\-–—]+/, '')
    .trim()
  if (!result) return text.trim()
  // Si el texto original empezaba en mayúscula, el limpio también.
  return /^[¿¡]?\p{Lu}/u.test(text.trim())
    ? result.replace(/^([¿¡]?)(\p{Ll})/u, (_, mark: string, letter: string) => mark + letter.toLocaleUpperCase('es'))
    : result
}
