import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202608040001_block_one_implementation.sql',
  import.meta.url,
)

test('el Bloque 1 contiene diez partes y una pregunta vinculada a cada parte', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /position between 1 and 10/i)
  assert.match(sql, /create temporary table block_one_parts/i)
  assert.match(sql, /create temporary table block_one_questions/i)
  assert.match(sql, /lesson_audio_segment_id uuid/i)
  assert.match(sql, /questions_bank_audio_segment_unique_idx/i)
  assert.match(sql, /question_count[\s\S]*?10,/i)
  assert.match(sql, /'cumulative_perfect'/i)

  const questionRows = sql.match(/^\(\d+, '¿/gm) ?? []
  assert.equal(questionRows.length, 10)
  for (let position = 1; position <= 10; position += 1) {
    assert.match(sql, new RegExp(`^\\(${position}, '¿`, 'm'))
  }
})

test('el progreso, las notas y la corrección permanecen protegidos en servidor', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /lesson_segment_notes enable row level security/i)
  assert.match(sql, /current_user_is_enrolled/i)
  assert.match(sql, /security definer[\s\S]*start_quiz_attempt/i)
  assert.match(sql, /security definer[\s\S]*submit_quiz_attempt/i)
  assert.match(sql, /count\(\*\) filter \(where is_perfect = true\)/i)
  assert.match(sql, /reviewParts/i)
  assert.match(
    sql,
    /revoke all on function public\.submit_quiz_attempt\(uuid, jsonb\)[\s\S]*from public, anon/i,
  )
})
