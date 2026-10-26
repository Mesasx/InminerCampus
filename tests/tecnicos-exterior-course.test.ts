import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const manifest = JSON.parse(
  await readFile('content/tecnicos-exterior-20h/course-manifest.json', 'utf8'),
)

test('el curso de técnicos de exterior conserva toda la estructura', () => {
  assert.equal(manifest.course.slug, 'tecnicos-titulados-actividades-extractivas-exterior')
  assert.equal(manifest.version.status, 'draft')
  assert.equal(manifest.modules.length, 7)
  assert.equal(manifest.lessons.length, 10)
  assert.equal(manifest.units.length, 92)
  assert.equal(manifest.assets.length, 186)
  assert.equal(
    manifest.lessons.reduce(
      (minutes: number, lesson: { duration_minutes: number }) =>
        minutes + lesson.duration_minutes,
      0,
    ),
    1_200,
  )
})

test('cada unidad enlaza una diapositiva, un audio y una explicación', () => {
  const versionPrefix = `${manifest.version.id}/`
  for (const [index, unit] of manifest.units.entries()) {
    assert.equal(unit.slide_number, index + 1)
    assert.match(unit.image_storage_path, /\/slides\/slide-\d{3}\.jpg$/)
    assert.match(unit.audio_storage_path, /\/audio\/slide-\d{3}\.mp3$/)
    assert.ok(unit.image_storage_path.startsWith(versionPrefix))
    assert.ok(unit.audio_storage_path.startsWith(versionPrefix))
    assert.ok(unit.duration_seconds >= 60 && unit.duration_seconds <= 240)
    assert.ok(unit.narration_text.length > 500)
    assert.ok(unit.explanation.length >= 500 && unit.explanation.length <= 20_000)
    assert.ok(unit.segment_position >= 1 && unit.segment_position <= 10)
  }
})

test('la migración mantiene curso y versión en borrador', async () => {
  const sql = await readFile(
    'supabase/migrations/20261026120000_tecnicos_exterior_20h_draft.sql',
    'utf8',
  )
  assert.match(sql, /'draft'/)
  assert.doesNotMatch(sql, /status\s*=\s*'published'/)
  assert.match(sql, /modules_count <> 7/)
  assert.match(sql, /lessons_count <> 10/)
  assert.match(sql, /segments_count <> 92/)
})
