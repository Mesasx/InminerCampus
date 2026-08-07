import assert from 'node:assert/strict'
import { access, readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202608070002_all_course_slides.sql',
  import.meta.url,
)
const sourcesRoot = new URL('../public/course-slides/sources/', import.meta.url)

const expectedSlides = {
  arranque: [
    4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 20, 27, 34, 41, 48, 55, 62,
    69, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
    91, 92, 93, 94,
  ],
  transporte: [
    4, 5, 6, 7, 8, 9, 10, 12, 13, 16, 18, 24, 30, 36, 42, 48, 54,
    60, 66, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86,
    87, 88, 89, 90, 91, 92, 93, 94, 95,
  ],
  silice: [
    4, 5, 6, 8, 14, 15, 21, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 40, 41, 43, 46, 50, 54, 57, 60, 63, 64, 65,
    66, 67, 68, 69, 70, 71, 74, 76,
  ],
}

test('mapea diez partes de cada bloque a su presentación original', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const mappingRows = sql.match(/^\('[^']+', \d, '[^']+',\r?\n\s+array\[[^\]]+\]/gm) ?? []

  assert.equal(mappingRows.length, 15)
  for (const row of mappingRows) {
    const values = row.match(/array\[([^\]]+)\]/)?.[1].split(',') ?? []
    assert.equal(values.length, 10)
  }
  assert.match(sql, /and cv\.duration_hours = 5[\s\S]*and cm\.position = 1/)
  assert.match(sql, /operadores-perforacion-corte-exterior/)
  assert.match(sql, /on conflict \(segment_id, position\)/)
})

test('todas las imágenes originales referenciadas están exportadas', async () => {
  await Promise.all(
    Object.entries(expectedSlides).flatMap(([deck, slides]) =>
      slides.map((slide) =>
        access(
          new URL(
            `${deck}/source-slide-${String(slide).padStart(3, '0')}.jpg`,
            sourcesRoot,
          ),
        ),
      ),
    ),
  )
})

test('la migración conserva las diapositivas detalladas ya publicadas', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(
    sql,
    /not \([\s\S]*operador-maquinaria-arranque-carga-viales[\s\S]*duration_hours = 5[\s\S]*position = 1/,
  )
  assert.doesNotMatch(sql, /delete from public\.lesson_segment_slides/i)
})
