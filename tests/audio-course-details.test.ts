import assert from 'node:assert/strict'
import { readFile, readdir } from 'node:fs/promises'
import test from 'node:test'

const playerPath = new URL('../src/components/AudioLessonPlayer.tsx', import.meta.url)
const migrationsDirectory = new URL('../supabase/migrations/', import.meta.url)
const courseFourDurationsPath = new URL(
  '../supabase/migrations/20260813123000_fix_course_four_audio_durations.sql',
  import.meta.url,
)

test('el curso 4 usa las 50 duraciones reales y finaliza con el tiempo del MP3', async () => {
  const [player, sql] = await Promise.all([
    readFile(playerPath, 'utf8'),
    readFile(courseFourDurationsPath, 'utf8'),
  ])
  const durationRows = sql.match(/\(\d, \d{1,2}, \d{2}\)/g) ?? []

  assert.equal(durationRows.length, 50)
  assert.doesNotMatch(sql, /\(\d, \d{1,2}, 120\)/)
  assert.match(sql, /exact_duration_count <> 50/)
  assert.match(
    player,
    /reportProgress\(event\.currentTarget\.duration, true\)/,
  )
})

test('el alumno puede ver el detalle de la parte y recibe un error útil si falla el audio', async () => {
  const player = await readFile(playerPath, 'utf8')

  assert.match(player, /\{activeSegment\.narration_text \? \(/)
  assert.doesNotMatch(player, /previewMode && activeSegment\.narration_text/)
  assert.match(player, /Transcripción del audio/)
  assert.match(player, /Información específica de esta parte/)
  assert.match(player, /onError=\{\(\) => \{/)
  assert.match(player, /No se ha podido reproducir el audio/)
})

test('la migración publica y documenta las 200 partes de los cursos con audio', async () => {
  const migrationNames = (await readdir(migrationsDirectory))
    .filter((name) => name.includes('_publish_audio_and_course_details_'))
    .sort()
  const sql = (await Promise.all(
    migrationNames.map((name) => readFile(new URL(name, migrationsDirectory), 'utf8')),
  )).join('\n')
  const detailRows = sql.match(/^  \('/gm) ?? []

  assert.equal(migrationNames.length, 20)
  assert.equal(detailRows.length, 200)
  assert.match(sql, /published = true/)
  assert.match(sql, /insert into public\.lesson_segment_notes/)
  assert.match(sql, /on conflict \(segment_id\) do update/)
  assert.equal((sql.match(/detailed_segments <> 10 or detailed_slides <> 20 or detailed_notes <> 10/g) ?? []).length, 20)
})
