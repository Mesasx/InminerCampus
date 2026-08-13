import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const uploaderPath = new URL('../scripts/upload-course-decks.mjs', import.meta.url)
const migrationPath = new URL(
  '../supabase/migrations/20260813140000_reuse_course_four_slides_in_course_one.sql',
  import.meta.url,
)

test('el curso de arranque de 5 h reutiliza las 50 diapositivas nuevas', async () => {
  const [uploader, sql] = await Promise.all([
    readFile(uploaderPath, 'utf8'),
    readFile(migrationPath, 'utf8'),
  ])

  assert.match(
    uploader,
    /key: 'course-1-arranque-5h',[\s\S]*?durationHours: 5,[\s\S]*?slidesPerAudio: 1/,
  )
  assert.match(uploader, /course-slide-decks-course4-v3'[\s\S]*?'course-4'/)
  assert.match(sql, /course-1-arranque-5h-course4-v3/)
  assert.match(sql, /source_slide\.image_storage_path like source_version\.id::text/)
  assert.match(sql, /associated_slide_count <> 50/)
})

test('la sustitución visual conserva los audios propios del curso de 5 h', async () => {
  const sql = await readFile(migrationPath, 'utf8')

  assert.match(sql, /create temporary table course_one_audio_snapshot/)
  assert.doesNotMatch(sql, /update public\.lesson_audio_segments/)
  assert.match(sql, /audio_storage_path is distinct from snapshot\.audio_storage_path/)
  assert.match(sql, /audio_external_url is distinct from snapshot\.audio_external_url/)
  assert.match(sql, /duration_seconds is distinct from snapshot\.duration_seconds/)
  assert.match(sql, /changed_audio_count <> 0/)
})
