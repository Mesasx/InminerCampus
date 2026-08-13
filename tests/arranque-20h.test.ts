import assert from 'node:assert/strict'
import { readdir, readFile, stat } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260811123809_publish_arranque_20h.sql',
  import.meta.url,
)
const slideDirectoryUrl = new URL(
  '../public/course-slides/arranque-20h/',
  import.meta.url,
)
const pdfUrl = new URL(
  '../public/course-materials/arranque-20h/formacion-inicial-arranque-20h.pdf',
  import.meta.url,
)
const currentPdfUrl = new URL(
  '../public/course-materials/arranque-20h/formacion-inicial-arranque-20h-actual.pdf',
  import.meta.url,
)
const currentDetailsMigrationUrl = new URL(
  '../supabase/migrations/20260813114324_current_slide_details_and_pdf.sql',
  import.meta.url,
)

test('includes all 100 slides and the complete 20-hour arranque PDF', async () => {
  const slideFiles = (await readdir(slideDirectoryUrl))
    .filter((file) => /^slide-\d{3}\.jpg$/.test(file))
    .sort()

  assert.equal(slideFiles.length, 100)
  assert.equal(slideFiles[0], 'slide-001.jpg')
  assert.equal(slideFiles.at(-1), 'slide-100.jpg')

  const pdf = await stat(pdfUrl)
  assert.ok(pdf.size > 16_000_000)
})

test('publishes the current 50-slide presentation as the downloadable PDF', async () => {
  const [pdf, header, sql] = await Promise.all([
    stat(currentPdfUrl),
    readFile(currentPdfUrl).then((content) => content.subarray(0, 4).toString()),
    readFile(currentDetailsMigrationUrl, 'utf8'),
  ])

  assert.equal(header, '%PDF')
  assert.equal(pdf.size, 7_538_898)
  assert.match(sql, /formacion-inicial-arranque-20h-actual\.pdf/)
  assert.match(sql, /Cursos Pedro \(Google Drive\)/)
  assert.match(sql, /detailed_slides <> 100/)
  assert.match(sql, /current_pdf_resources <> 11/)
})
test('publishes only the 20-hour offer with 50 chapters and keeps its assessment', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /operador-maquinaria-arranque-carga-viales/)
  assert.match(sql, /version\.duration_hours = 20/)
  assert.doesNotMatch(sql, /version\.duration_hours = 5/)
  assert.match(sql, /published_segment_count <> 50/)
  assert.match(sql, /slide_count <> 100/)
  assert.match(sql, /Keep the existing assessment for this version unchanged/)
  assert.match(sql, /formacion-inicial-arranque-20h\.pdf/)
})
