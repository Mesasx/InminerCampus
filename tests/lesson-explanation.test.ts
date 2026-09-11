import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import {
  buildExplanation,
  complementaryNote,
  isEditorialLine,
} from '../src/lib/lesson-explanation.ts'

// El intérprete común de explicaciones se prueba con texto tal cual está
// guardado en cada curso, no con ejemplos inventados.

test('estructura el texto de un manual con apartados reconocidos', () => {
  const { sections } = buildExplanation({
    slideBody: [
      'Objetivo',
      'Comprender el alcance del puesto.',
      '',
      'Explicación detallada',
      'El operador integra cuatro fuentes de instrucciones.',
      'La experiencia práctica no sustituye al conocimiento preventivo.',
      '',
      'Errores críticos que deben evitarse',
      '• Trabajar sin conocer el procedimiento.',
      '• Improvisar una maniobra no prevista.',
      '',
      'Idea clave',
      'La formación prepara para reconocer el peligro.',
    ].join('\n'),
  })

  assert.deepEqual(
    sections.map((section) => section.heading),
    [
      'Objetivo',
      'Explicación detallada',
      'Errores críticos que deben evitarse',
      'Idea clave',
    ],
  )
  // Cada apartado recibe el tono que le corresponde, que es lo que decide su
  // pintado: aviso, procedimiento o idea destacada.
  assert.deepEqual(
    sections.map((section) => section.tone),
    ['plain', 'plain', 'warning', 'key'],
  )
  // El párrafo se mantiene como párrafo y la viñeta como lista.
  const detalle = sections[1]
  assert.equal(detalle.blocks.length, 2)
  assert.ok(detalle.blocks.every((block) => block.type === 'paragraph'))
  const errores = sections[2]
  assert.equal(errores.blocks.length, 1)
  assert.deepEqual(
    errores.blocks[0].type === 'list' ? errores.blocks[0].items : [],
    ['Trabajar sin conocer el procedimiento.', 'Improvisar una maniobra no prevista.'],
  )
})

test('reconoce el apartado aunque el manual lo escriba en mayúsculas', () => {
  const { sections } = buildExplanation({
    slideBody: 'OBJETIVO\n\nReforzar el criterio operativo.',
  })
  assert.equal(sections[0].heading, 'Objetivo')
})

test('retira la bibliografía del capítulo sin tocar la materia', () => {
  const { sections } = buildExplanation({
    noteSummary: [
      'Explicación detallada',
      'La Ley 31/1995 establece el derecho a una formación preventiva suficiente.',
      'Consulte el manual del fabricante antes de intervenir.',
      '',
      'Referencias o fuentes del capítulo',
      'ET 2004-1-10. Ámbito, programa inicial de 20 horas. Abrir norma oficial',
      'RD 171/2004. Coordinación entre empresas concurrentes. Abrir norma oficial',
    ].join('\n'),
  })

  assert.equal(sections.length, 1)
  assert.equal(sections[0].heading, 'Explicación detallada')
  const texto = sections[0].blocks
    .map((block) => (block.type === 'list' ? block.items.join(' ') : block.text))
    .join(' ')
  // La legislación que forma parte de la explicación se conserva…
  assert.match(texto, /Ley 31\/1995/)
  assert.match(texto, /manual del fabricante/)
  // …y la lista de procedencia desaparece.
  assert.doesNotMatch(texto, /Abrir norma oficial/)
  assert.doesNotMatch(texto, /ET 2004-1-10\. Ámbito/)
})

test('descarta el identificador de mapeo y usa la explicación real del manual', () => {
  // Perforadora guarda en el cuerpo de la diapositiva una línea de situación,
  // y el desarrollo del manual en la nota.
  const { sections } = buildExplanation({
    slideBody:
      'Parte 1.1 del bloque "Alcance del puesto y límites de la formación". Escucha el audio completo y aplica las indicaciones preventivas del procedimiento de trabajo de la explotacion.',
    noteSummary: [
      'Idea central',
      'El perforista convierte un diseño de perforación en barrenos reales.',
      '',
      'Definición y alcance',
      'Ejecuta perforaciones destinadas al arranque de roca.',
    ].join('\n'),
  })

  assert.deepEqual(
    sections.map((section) => section.heading),
    ['Idea central', 'Definición y alcance'],
  )
  const texto = JSON.stringify(sections)
  assert.doesNotMatch(texto, /Parte 1\.1 del bloque/)
})

test('un texto plano sigue siendo legible en el contenedor nuevo', () => {
  const { sections } = buildExplanation({
    slideBody:
      'El operador comprueba el estado del terreno antes de posicionar la máquina.',
  })

  assert.equal(sections.length, 1)
  assert.equal(sections[0].heading, null)
  assert.equal(sections[0].blocks[0].type, 'paragraph')
})

test('compone la explicación cuando el manual sólo dejó puntos y criterio', () => {
  const { sections } = buildExplanation({
    noteKeyPoints: ['Reconocer el terreno significa buscar condiciones cambiantes.'],
    noteStopCriterion: 'Si el terreno no ofrece condiciones seguras, se detiene.',
  })

  assert.deepEqual(
    sections.map((section) => section.heading),
    ['Explicación detallada', 'Criterio de actuación'],
  )
  assert.equal(sections[1].tone, 'procedure')
})

test('no repite los puntos de la nota que ya están en la explicación', () => {
  const source = {
    slideBody: 'Explicación detallada\n\nEl repostaje se realiza en zona habilitada.',
    noteKeyPoints: [
      'El repostaje se realiza en zona habilitada.',
      'Se controla el derrame.',
    ],
    noteStopCriterion: '',
  }
  const extra = complementaryNote(buildExplanation(source), source)

  assert.deepEqual(extra.keyPoints, ['Se controla el derrame.'])
  assert.equal(extra.stopCriterion, '')
})

test('distingue una referencia editorial de la materia que la menciona', () => {
  for (const editorial of [
    'Fuente: página 22 del manual',
    'Referencia: ET 2004-1-10',
    'Manual: Curso_4_Bloque_1_Explicaciones_Detalladas_INMINER.pdf',
    'Página 3 de 14',
    'Diapositiva 27',
    'Manual_Operador_Perforadora_Inminer_Campus.pdf',
    'Según el documento de partida',
  ]) {
    assert.equal(isEditorialLine(editorial), true, editorial)
  }

  // Usos legítimos que comparten vocabulario y deben sobrevivir.
  for (const materia of [
    'Mantener fuentes de ignición activas en el entorno del repostaje.',
    'Los topes son referencias de aviso para no seguir retrocediendo.',
    'Consulte el manual del fabricante antes de intervenir.',
    'La Ley 31/1995 establece las obligaciones del empresario.',
    'Trabajar hasta activar el limitador, tomándolo como referencia de trabajo.',
  ]) {
    assert.equal(isEditorialLine(materia), false, materia)
  }
})

test('el reproductor no pinta ninguna procedencia editorial', async () => {
  const player = await readFile(
    new URL('../src/components/AudioLessonPlayer.tsx', import.meta.url),
    'utf8',
  )

  // Los campos siguen existiendo en los datos, pero no se renderizan.
  for (const trace of [
    'source_label ||',
    'activeSourcePages',
    'lesson-notes__source',
    'lesson-reading__meta',
    'Ver PDF',
  ]) {
    assert.ok(!player.includes(trace), `el visor todavía pinta «${trace}»`)
  }
})
