import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260813120744_course_four_block_one_supplied_questions.sql',
  import.meta.url,
)

test('el test aportado sustituye únicamente el banco del Curso 4, Bloque 1', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const questionRows = sql.match(/^  \(\d{1,2}, (?:\d{1,2}|null),$/gm) ?? []

  assert.equal(questionRows.length, 15)
  assert.match(sql, /operador-maquinaria-arranque-carga-viales/)
  assert.match(sql, /cv\.duration_hours = 20/)
  assert.match(sql, /module\.position = 1/)
  assert.match(sql, /Un operador contratado por una empresa externa/)
  assert.match(sql, /ciclo de trabajo productivo y seguro/)
})

test('cada pregunta tiene cuatro opciones, una respuesta correcta y justificación', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /option_count <> 60/)
  assert.match(sql, /correct_option_count <> 15/)
  assert.match(sql, /active_question_count <> 15/)
  assert.match(sql, /spec\.explanation/)
})

test('el contenido enseña las respuestas nuevas antes del test y mantiene tres rondas perfectas', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /zona de articulación central/)
  assert.match(sql, /prueba controlada a baja altura/)
  assert.match(sql, /Las alarmas se interpretan conforme al manual/)
  assert.match(sql, /required_perfect_streak = 3/)
  assert.match(sql, /completion_mode = 'cumulative_perfect'/)
})
