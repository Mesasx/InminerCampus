import assert from 'node:assert/strict'
import { readFile, readdir } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260812170000_integrate_course_decks_2_4_5_6.sql',
  import.meta.url,
)
const course2ReplacementUrl = new URL(
  '../supabase/migrations/20260813061815_replace_course_2_official_deck.sql',
  import.meta.url,
)
const uploaderUrl = new URL('../scripts/upload-course-decks.mjs', import.meta.url)
const exporterUrl = new URL('../scripts/export-course-decks.ps1', import.meta.url)
const migrationsDirectoryUrl = new URL('../supabase/migrations/', import.meta.url)

test('la migración enlaza dos diapositivas privadas a los 50 audios de cada curso válido', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(
    sql,
    /\(2, 'operador-maquinaria-transporte-camion-volquete', 5, 'png'\)/,
  )
  assert.match(
    sql,
    /\(4, 'operador-maquinaria-arranque-carga-viales', 20, 'jpg'\)/,
  )
  assert.match(
    sql,
    /\(5, 'operador-maquinaria-transporte-camion-volquete', 20, 'jpg'\)/,
  )
  assert.match(
    sql,
    /\(6, 'prevencion-polvo-silice-cristalina-respirable', 20, 'jpg'\)/,
  )
  assert.match(sql, /segment_count <> 50/)
  assert.match(sql, /object_count <> 100/)
  assert.match(sql, /cross join generate_series\(1, 2\) as slide_position/)
  assert.match(sql, /\/slides\/course-deck-20260812\/block-/)
  assert.match(sql, /audio_count <> 50/)
})

test('el cargador usa el PowerPoint oficial del curso 2 y verifica el acceso privado firmado', async () => {
  const uploader = await readFile(uploaderUrl, 'utf8')

  assert.match(uploader, /key: 'course-2',[\s\S]*?extension: 'jpg'/)
  assert.match(uploader, /'\.work',[\s\S]*?'course-slide-decks'/)
  assert.match(uploader, /course-deck-20260813-v2/)
  assert.match(uploader, /for \(const deck of selectedDecks\)/)
  assert.match(uploader, /for \(let block = 1; block <= 5/)
  assert.match(uploader, /for \(let part = 1; part <= 10/)
  assert.match(uploader, /for \(let slide = 1; slide <= deck\.slidesPerAudio/)
  assert.match(uploader, /createSignedUrls\(samplePaths, 60\)/)
  assert.match(uploader, /contentType\.startsWith\('image\/'\)/)
  assert.match(uploader, /totalUploaded/)
})

test('la última actualización del curso 4 usa sus 50 diapositivas, una por audio', async () => {
  const [uploader, exporter, migrationNames] = await Promise.all([
    readFile(uploaderUrl, 'utf8'),
    readFile(exporterUrl, 'utf8'),
    readdir(migrationsDirectoryUrl),
  ])
  const updateNames = migrationNames
    .filter((name) => name.includes('_update_course_four_block_'))
    .sort()
  const sql = (await Promise.all(
    updateNames.map((name) => readFile(new URL(name, migrationsDirectoryUrl), 'utf8')),
  )).join('\n')

  assert.match(
    exporter,
    /Curso_4_Maquinaria_Arranque_20h_INMINER_50_diapositivas\.pptx/,
  )
  assert.match(exporter, /Key = 'course-4'[\s\S]*?ExpectedSlides = 50/)
  assert.match(uploader, /key: 'course-4',[\s\S]*?slidesPerAudio: 1/)
  assert.equal(updateNames.length, 5)
  assert.equal((sql.match(/^  \(/gm) ?? []).length, 50)
  assert.match(sql, /course-4-20260813-v3/)
  assert.equal((sql.match(/updated_segments <> 10 or updated_slides <> 10 or updated_notes <> 10/g) ?? []).length, 5)
})

test('la sustitución del curso 2 exige 100 imágenes y actualiza las 100 asociaciones', async () => {
  const sql = await readFile(course2ReplacementUrl, 'utf8')

  assert.match(sql, /duration_hours = 5/)
  assert.match(sql, /course-deck-20260813-v2/)
  assert.match(sql, /object_count <> 100/)
  assert.match(sql, /updated_count <> 100/)
  assert.match(sql, /slide\.position between 1 and 2/)
})
