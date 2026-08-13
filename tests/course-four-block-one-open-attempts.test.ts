import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260813122208_refresh_course_four_block_one_open_attempts.sql',
  import.meta.url,
)

test('los intentos abiertos del Curso 4, Bloque 1 reciben el banco vigente', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /duration_hours = 20/)
  assert.match(sql, /module\.position = 1/)
  assert.match(sql, /attempt\.status = 'in_progress'/)
  assert.match(sql, /question\.question_bank_id <> current_quiz\.question_bank_id/)
  assert.match(sql, /delete from public\.quiz_attempt_questions/)
  assert.match(sql, /insert into public\.quiz_attempt_questions/)
})

test('la reconstrucción conserva el intento y valida sus quince preguntas actuales', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.doesNotMatch(sql, /delete from public\.quiz_attempts/)
  assert.match(sql, /limit current_quiz\.question_count/)
  assert.match(sql, /count\(snapshot\.question_id\) <> current_quiz\.question_count/)
  assert.match(sql, /question\.question_bank_id = current_quiz\.question_bank_id/)
})
