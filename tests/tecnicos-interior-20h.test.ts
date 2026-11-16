import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import path from 'node:path'
import test from 'node:test'

const root = process.cwd()
const migrationPath = path.join(
  root,
  'supabase/migrations/20261116125022_tecnicos_interior_20h.sql',
)
const presencialMigrationPath = path.join(
  root,
  'supabase/migrations/20261116175904_tecnicos_interior_presencial.sql',
)

async function migration() {
  return readFile(migrationPath, 'utf8')
}

function unitsFrom(sql: string) {
  const match = sql.match(
    /\$interior_units\$(\[.*\])\$interior_units\$::jsonb/s,
  )
  assert.ok(match, 'La migración debe contener el manifiesto JSON de unidades')
  return JSON.parse(match[1]) as Array<{
    slide_number: number
    block_number: number
    lesson_ordinal: number
    segment_position: number
    title: string
    narration_text: string
    duration_seconds: number
    audio_storage_path: string
    image_storage_path: string
    explanation: string
  }>
}

test('el curso interior conserva seis bloques y ochenta unidades', async () => {
  const sql = await migration()
  const units = unitsFrom(sql)

  assert.equal(units.length, 80)
  assert.deepEqual(
    units.map((unit) => unit.slide_number),
    Array.from({ length: 80 }, (_, index) => index + 1),
  )
  assert.deepEqual(
    units.reduce<Record<number, number>>((counts, unit) => {
      counts[unit.block_number] = (counts[unit.block_number] ?? 0) + 1
      return counts
    }, {}),
    { 1: 10, 2: 30, 3: 12, 4: 12, 5: 8, 6: 8 },
  )
  assert.equal(new Set(units.map((unit) => unit.lesson_ordinal)).size, 10)
  assert.ok(units.every((unit) => unit.segment_position >= 1))
  assert.ok(units.every((unit) => unit.segment_position <= 10))
})

test('cada diapositiva tiene guion, audio, imagen y explicación propios', async () => {
  const units = unitsFrom(await migration())
  const audioPaths = new Set<string>()
  const imagePaths = new Set<string>()

  for (const unit of units) {
    const words = unit.narration_text.trim().split(/\s+/).length
    assert.ok(words >= 260 && words <= 360, `Guion ${unit.slide_number}: ${words}`)
    assert.ok(
      unit.duration_seconds >= 120 && unit.duration_seconds <= 180,
      `Duración ${unit.slide_number}: ${unit.duration_seconds}`,
    )
    assert.match(unit.audio_storage_path, /audio\/slide-\d{3}\.mp3$/)
    assert.match(unit.image_storage_path, /slides\/slide-\d{3}\.png$/)
    assert.match(unit.explanation, /Explicación detallada/)
    assert.match(unit.explanation, /Idea clave/)
    assert.doesNotMatch(unit.explanation, /esta pregunta aparece|pregunta tipo test/i)
    audioPaths.add(unit.audio_storage_path)
    imagePaths.add(unit.image_storage_path)
  }

  assert.equal(audioPaths.size, 80)
  assert.equal(imagePaths.size, 80)
})

test('los seis tests son independientes y exigen dos rondas perfectas', async () => {
  const sql = await migration()

  assert.match(sql, /v_banks <> 6/)
  assert.match(sql, /v_questions <> 80/)
  assert.match(sql, /v_options <> 320/)
  assert.match(sql, /v_quizzes <> 6/)
  assert.match(sql, /required_perfect_streak = 2/)
  assert.match(sql, /passing_percent = 100/)
  assert.match(sql, /completion_mode = 'cumulative_perfect'/)
  assert.match(sql, /lesson_audio_segment_id = null/)
})

test('el curso se prepara en borrador hasta que existan los ochenta audios', async () => {
  const sql = await migration()

  assert.match(sql, /'draft'/)
  assert.match(sql, /u\.duration_seconds, false/)
  assert.doesNotMatch(sql, /set status = 'published'/i)
})

test('la modalidad reglamentaria queda registrada como presencial', async () => {
  const sql = await readFile(presencialMigrationPath, 'utf8')

  assert.match(sql, /modality = 'in_person'/)
  assert.match(sql, /formación reglamentaria.*presencial/is)
  assert.match(sql, /contenido digital.*complementario/is)
})
