import assert from 'node:assert/strict'
import { access, readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202608070001_course_one_block_one_visual_slides.sql',
  import.meta.url,
)
const stylesUrl = new URL('../src/styles/app.css', import.meta.url)
const slidesRoot = new URL('../public/course-slides/course-1/block-1/', import.meta.url)

test('cada audio del bloque 1 tiene contenido visual detallado', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const valuesSection = sql.split('with target_segments as')[0]
  const audioRows = valuesSection.match(/^\(\d+,/gm) ?? []

  assert.equal(audioRows.length, 10)
  assert.match(sql, /source_slide_two/)
  assert.match(sql, /segment_id,\r?\n\s+3::smallint/)
  assert.match(sql, /Presentación de Cursos Pedro en Google Drive/)
})

test('cada asociación de audio respeta las nueve columnas de la tabla temporal', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const valuesSection = sql
    .split('insert into course_one_block_one_slides values')[1]
    .split('with target_segments as')[0]

  const rowValueCounts: number[] = []
  let inString = false
  let depth = 0
  let valueCount = 0

  for (let index = 0; index < valuesSection.length; index += 1) {
    const character = valuesSection[index]
    const nextCharacter = valuesSection[index + 1]

    if (character === "'" && inString && nextCharacter === "'") {
      index += 1
      continue
    }

    if (character === "'") {
      inString = !inString
      continue
    }

    if (inString) continue

    if (character === '(') {
      depth += 1
      if (depth === 1) valueCount = 1
      continue
    }

    if (character === ',' && depth === 1) {
      valueCount += 1
      continue
    }

    if (character === ')' && depth === 1) {
      rowValueCounts.push(valueCount)
      depth -= 1
    }
  }

  assert.equal(rowValueCounts.length, 10)
  assert.deepEqual(rowValueCounts, Array(10).fill(9))
})

test('las diapositivas originales 4 a 10 están disponibles en alta resolución', async () => {
  await Promise.all(
    [4, 5, 6, 7, 8, 9, 10].map((slide) =>
      access(new URL(`source-slide-${String(slide).padStart(2, '0')}.png`, slidesRoot)),
    ),
  )
})

test('el visor muestra una diapositiva completa cada vez', async () => {
  const css = await readFile(stylesUrl, 'utf8')

  assert.match(css, /\.lesson-slide__canvas\s*\{[^}]*aspect-ratio:\s*16 \/ 9/s)
  assert.match(css, /\.lesson-slide__canvas img\s*\{[^}]*object-fit:\s*contain/s)
  assert.doesNotMatch(css, /\.lesson-slides__grid\s*\{/)
})
