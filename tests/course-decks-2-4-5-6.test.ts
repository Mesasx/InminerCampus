import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260812170000_integrate_course_decks_2_4_5_6.sql',
  import.meta.url,
)
const uploaderUrl = new URL('../scripts/upload-course-decks.mjs', import.meta.url)

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

test('el cargador publica 400 imágenes y verifica el acceso privado firmado', async () => {
  const uploader = await readFile(uploaderUrl, 'utf8')

  assert.match(uploader, /for \(const deck of decks\)/)
  assert.match(uploader, /for \(let block = 1; block <= 5/)
  assert.match(uploader, /for \(let part = 1; part <= 10/)
  assert.match(uploader, /for \(let slide = 1; slide <= 2/)
  assert.match(uploader, /createSignedUrls\(samplePaths, 60\)/)
  assert.match(uploader, /contentType\.startsWith\('image\/'\)/)
  assert.match(uploader, /Carga completa: 400 diapositivas privadas subidas/)
})
