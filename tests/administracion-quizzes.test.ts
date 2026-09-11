import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

// Los tests de Administración se cargaron desde el libro de preguntas aportado.
// El libro vive fuera del repositorio (la carpeta de contenido está ignorada),
// así que la migración es el registro versionado de las 150 preguntas y el
// importador es lo que se ejecutó contra la base de datos. Ambos deben decir lo
// mismo.

const migrationUrl = new URL(
  '../supabase/migrations/20260911120000_tests_administracion_personal_servicios.sql',
  import.meta.url,
)
const importerUrl = new URL(
  '../scripts/import-administracion-quizzes.mjs',
  import.meta.url,
)

const migration = await readFile(migrationUrl, 'utf8')
const importer = await readFile(importerUrl, 'utf8')

test('la migración trae las 150 preguntas repartidas como exige el libro', () => {
  const rows = [...migration.matchAll(/^ {2}\('ADM-(\d+)H-B(\d)-Q(\d+)'/gm)].map(
    ([, duration, block]) => ({
      duration: Number(duration),
      block: Number(block),
    }),
  )

  assert.equal(rows.length, 150)
  for (const [duration, expected] of [
    [20, 15],
    [5, 10],
  ] as const) {
    for (let block = 1; block <= 6; block += 1) {
      const count = rows.filter(
        (row) => row.duration === duration && row.block === block,
      ).length
      assert.equal(count, expected, `${duration} h bloque ${block}`)
    }
  }
})

test('cada pregunta declara cuatro opciones y una sola respuesta', () => {
  // Las filas llevan: id, duración, bloque, orden, código, enunciado, cuatro
  // opciones, letra correcta y justificación.
  const letters = [...migration.matchAll(/, '([ABCD])', '[^']/g)]
  assert.ok(letters.length >= 150)

  assert.match(
    migration,
    /\(v_pregunta, v_fila\.opcion_a, v_fila\.correcta = 'A', 1\)/,
  )
  assert.match(
    migration,
    /\(v_pregunta, v_fila\.opcion_d, v_fila\.correcta = 'D', 4\)/,
  )
  assert.match(migration, /'single_choice'/)
})

test('la evaluación se configura como el resto del campus', () => {
  assert.match(migration, /passing_percent[\s\S]*?100/)
  assert.match(migration, /required_perfect_streak/)
  assert.match(migration, /'cumulative_perfect'/)
  assert.match(migration, /randomize_questions/)
  assert.match(migration, /randomize_options/)
  // El título del test no fija un número escrito a mano: sale del recuento.
  assert.match(
    migration,
    /format\('Test del bloque %s · %s preguntas', v_bloque, v_total\)/,
  )
})

test('la carga es aditiva y no destruye nada', () => {
  for (const source of [migration, importer]) {
    assert.doesNotMatch(source, /delete from/i)
    assert.doesNotMatch(source, /drop table/i)
    assert.doesNotMatch(source, /truncate/i)
  }
  // Un bloque que ya tenga evaluación se respeta.
  assert.match(
    migration,
    /if exists \(select 1 from public\.quizzes q where q\.lesson_id = v_leccion\) then\s+continue;/,
  )
  assert.match(importer, /if \(existing\.length\) \{/)
  assert.match(importer, /'ya tenía test, intacto'/)
})

test('el importador valida el libro antes de escribir', () => {
  assert.match(importer, /la respuesta marcada no coincide con la opción/)
  assert.match(importer, /opción vacía/)
  assert.match(importer, /opciones repetidas/)
  assert.match(importer, /sin justificación/)
  assert.match(importer, /no pertenece al bloque/)
  assert.match(importer, /preguntas, se esperaban/)
  // Y admite una simulación que no escribe nada.
  assert.match(importer, /const dryRun = process\.argv\.includes\('--dry-run'\)/)
  assert.match(importer, /Simulación: no se ha escrito nada/)
})

test('sólo se enlaza una pregunta por unidad, que es lo que admite el esquema', () => {
  // El índice único de la base de datos permite una pregunta enlazada por
  // unidad dentro de cada banco; las demás quedan sin enlazar.
  assert.match(importer, /const linkedCodes = new Set\(\)/)
  assert.match(importer, /first\s*\?\s*segmentByCode\.get\(question\.code\)\s*:\s*null/)
  assert.match(migration, /if v_fila\.codigo = any\(v_codigos\) then\s+v_unidad := null;/)
})

test('cada pregunta apunta a una unidad real de su propio bloque', () => {
  // 9, 10, 9, 6, 9 y 7 unidades: es lo que convierte el número de diapositiva
  // del libro en el código de unidad del curso.
  const sizes = [9, 10, 9, 6, 9, 7]
  assert.match(importer, /const BLOCK_SIZES = \[9, 10, 9, 6, 9, 7\]/)

  const rows = [
    ...migration.matchAll(
      /^ {2}\('ADM-\d+H-B(\d)-Q\d+', \d+, (\d), \d+, '(\d+)\.(\d+)'/gm,
    ),
  ]
  assert.equal(rows.length, 150)

  for (const [, idBlock, block, codeBlock, position] of rows) {
    // El bloque del identificador, el de la columna y el del código coinciden.
    assert.equal(block, idBlock)
    assert.equal(codeBlock, block)
    // Y la unidad existe dentro de ese bloque.
    const unit = Number(position)
    assert.ok(unit >= 1 && unit <= sizes[Number(block) - 1], `unidad ${codeBlock}.${position}`)
  }
})
