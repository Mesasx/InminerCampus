import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260813123633_course_four_block_one_detailed_explanations.sql',
  import.meta.url,
)
const playerUrl = new URL(
  '../src/components/AudioLessonPlayer.tsx',
  import.meta.url,
)

test('el Curso 4 recibe las diez explicaciones completas del PDF aportado', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const detailRows = sql.match(/^  \(\d{1,2}, '[^']+', \$detail\$/gm) ?? []

  assert.equal(detailRows.length, 10)
  assert.match(sql, /version\.duration_hours = 20/)
  assert.match(sql, /module\.position = 1/)
  assert.match(sql, /La experiencia práctica ayuda, pero no sustituye/)
  assert.match(sql, /La operación más productiva es la que mantiene/)
  assert.match(sql, /detailed_slides <> 10 or detailed_notes <> 10/)
})

test('cada explicación conserva objetivo, aplicación, riesgos e idea clave', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.equal((sql.match(/^Objetivo$/gm) ?? []).length, 10)
  assert.equal((sql.match(/^Explicación detallada$/gm) ?? []).length, 10)
  assert.equal((sql.match(/^Aplicación práctica$/gm) ?? []).length, 10)
  assert.equal((sql.match(/^Riesgos y errores que deben evitarse$/gm) ?? []).length, 10)
  assert.equal((sql.match(/^Idea clave$/gm) ?? []).length, 10)
})

test('el reproductor presenta el contenido detallado con estructura legible', async () => {
  const player = await readFile(playerUrl, 'utf8')

  assert.match(player, /function DetailedSpecificInformation/)
  assert.match(player, /lesson-notes__content/)
  assert.match(player, /Riesgos y errores que deben evitarse/)
  assert.match(player, /lesson-notes__key/)
})
