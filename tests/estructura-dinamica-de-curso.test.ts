import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

// La plataforma no puede presuponer cuántos bloques, diapositivas o preguntas
// tiene un curso: Administración tiene seis bloques, el resto cinco, y cada
// bloque un número distinto de unidades.

const campusIndexUrl = new URL(
  '../src/routes/campus.$enrollmentId.index.tsx',
  import.meta.url,
)
const lessonRouteUrl = new URL(
  '../src/routes/campus.$enrollmentId.leccion.$lessonId.tsx',
  import.meta.url,
)
const playerUrl = new URL(
  '../src/components/AudioLessonPlayer.tsx',
  import.meta.url,
)
const quizRouteUrl = new URL(
  '../src/routes/evaluacion.$enrollmentId.$quizId.tsx',
  import.meta.url,
)

const sources = await Promise.all(
  [campusIndexUrl, lessonRouteUrl, playerUrl, quizRouteUrl].map((url) =>
    readFile(url, 'utf8'),
  ),
)
const [campusIndex, lessonRoute, player, quizRoute] = sources

test('ninguna pantalla del campus fija un número de bloques o diapositivas', () => {
  const forbidden = [
    // Recorridos de longitud fija.
    /for\s*\(\s*(?:let|var)\s+\w+\s*=\s*0;\s*\w+\s*<\s*\d+;/,
    // Denominadores de progreso escritos a mano.
    /\/\s*50\b/,
    /\/\s*10\b/,
    // Rótulos con cantidades fijas.
    /\b(?:5|6)\s+bloques\b/,
    /\b50\s+diapositivas\b/,
    /\b1[05]\s+preguntas\b/,
  ]

  for (const [index, source] of sources.entries()) {
    for (const pattern of forbidden) {
      assert.doesNotMatch(source, pattern, `fuente ${index}: ${pattern}`)
    }
  }
})

test('el progreso se calcula sobre los elementos reales del curso', () => {
  // Lecciones completadas entre las lecciones que el curso tenga.
  assert.match(
    campusIndex,
    /const lessons = modules\.flatMap\(\(module\) => module\.lessons\)/,
  )
  assert.match(campusIndex, /Math\.round\(\(completed \/ lessons\.length\) \* 100\)/)
  // Y los totales se suman recorriendo los datos, sin constantes.
  assert.match(campusIndex, /totals\.audioParts \+= segments\.length/)
  assert.match(campusIndex, /\{modules\.length\} bloques/)

  // Dentro de la lección, el porcentaje es partes escuchadas entre partes.
  assert.match(
    player,
    /Math\.round\(\(completedParts \/ segments\.length\) \* 100\)/,
  )
  assert.match(player, /Unidad \{activeIndex \+ 1\} de\{' '\}\s*\{segments\.length\}/)
})

test('la navegación se deriva del número real de unidades', () => {
  assert.match(player, /const isLastSegment = activeIndex >= segments\.length - 1/)
  assert.match(player, /disabled=\{activeIndex === 0\}/)
  // Y el salto directo enumera las unidades que existen.
  assert.match(player, /\{segments\.map\(\(segment, index\) => \{/)
})

test('cada bloque conserva su nombre propio junto a su número', () => {
  // El índice y la cabecera de bloque usan el título del módulo, no una
  // etiqueta genérica construida con el número.
  assert.match(campusIndex, /<span>\{module\.position\}<\/span> \{module\.title\}/)
  assert.match(campusIndex, /Bloque \{module\.position\}/)
  assert.match(campusIndex, /<h2 style=\{\{ marginTop: 12 \}\}>\{module\.title\}<\/h2>/)
})

test('la referencia normativa la declara el curso, no una tabla de slugs', () => {
  assert.match(lessonRoute, /accreditation_reference: string \| null/)
  assert.match(
    lessonRoute,
    /const declared = accreditationReference\?\.trim\(\) \|\| specialty\?\.trim\(\)/,
  )
  // La correspondencia por slug sobrevive sólo como último recurso.
  assert.match(lessonRoute, /function getRegulationLabelFromSlug/)
})

test('el número de preguntas sale del test y no de un caso especial', () => {
  assert.doesNotMatch(quizRoute, /questionCount === \d+/)
  assert.match(quizRoute, /questionCount: attempt\.questions\.length/)
  assert.match(lessonRoute, /questionCount: lesson\.quiz\.questionCount/)
  // Y el bloque de una parte a repasar no se inventa como «1.x».
  assert.doesNotMatch(quizRoute, /Parte 1\.\{part\.position\}/)
})
