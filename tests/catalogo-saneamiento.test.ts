import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import { categoryOf } from '../src/lib/course-category.ts'

const normativaMigration = new URL(
  '../supabase/migrations/20260910162000_referencia_normativa_perforadora_y_beneficio.sql',
  import.meta.url,
)
const beneficioMigration = new URL(
  '../supabase/migrations/20260910163000_retirar_beneficio_20h_hasta_completar_locuciones.sql',
  import.meta.url,
)
const catalogPath = new URL('../src/routes/catalogo.tsx', import.meta.url)
const perforadoraSyncPath = new URL(
  '../scripts/sync-perforadora-transcripts.mjs',
  import.meta.url,
)

test('los cursos ITC 02.1.02 se clasifican en minería por su referencia', () => {
  for (const specialty of [
    'ITC 02.1.02 · ET 2000-1-08',
    'ITC 02.1.02 · ET 2001-1-08',
    'ITC 02.1.02 · ET 2003-1-10',
    'ITC 02.1.02 · ET 2004-1-10',
    'ITC 02.0.02 · Orden TED/723/2021',
  ]) {
    assert.equal(categoryOf({ specialty, title: 'Curso' }), 'mineria', specialty)
  }

  // Los rótulos descriptivos que tenían perforadora y beneficio caían en «Otros»
  // pese a ser formación minera: es lo que corrige la migración.
  assert.equal(
    categoryOf({ specialty: 'Formación preventiva del puesto', title: 'Curso' }),
    'otros',
  )
})

test('la migración da a perforadora y beneficio su referencia normativa real', async () => {
  const sql = await readFile(normativaMigration, 'utf8')

  assert.match(sql, /operadores-perforacion-corte-exterior/)
  assert.match(sql, /'ITC 02\.1\.02 · ET 2003-1-10'/)
  assert.match(sql, /operadores-establecimientos-beneficio/)
  assert.match(sql, /'ITC 02\.1\.02 · ET 2004-1-10'/)
  // Sólo rellena la referencia que faltaba; no pisa las que ya existen.
  assert.match(sql, /accreditation_reference is null/)
})

test('beneficio de 20 h se retira sin borrar contenido ni matrículas', async () => {
  const sql = await readFile(beneficioMigration, 'utf8')

  assert.match(sql, /set status = 'draft'/)
  assert.match(sql, /cv\.duration_hours = 20/)
  // El reciclaje de 5 h no se toca y no se borra nada.
  assert.doesNotMatch(sql, /delete from/i)
  assert.doesNotMatch(sql, /duration_hours = 5/)
  // Sólo se retira mientras el contenido siga incompleto.
  assert.match(sql, /s\.published[\s\S]*?\)\s*<\s*50/)
})

test('el catálogo no ofrece ni indexa una categoría sin cursos', async () => {
  const source = await readFile(catalogPath, 'utf8')

  assert.match(source, /const categoryFilters = allCategories\.filter\(/)
  assert.match(source, /item === categoria \|\| courses\.some\(/)
  assert.match(source, /noindex: Boolean\(/)
})

test('la transcripción de perforadora se ancla al audio publicado de cada modalidad', async () => {
  const source = await readFile(perforadoraSyncPath, 'utf8')

  // Antes de escribir, el fichero local y el objeto del bucket deben coincidir.
  assert.match(source, /createHash\('sha256'\)/)
  assert.match(source, /digest\(local\) !== digest\(remote\)/)
  // Y las dos modalidades no pueden compartir texto.
  assert.match(source, /Transcripción idéntica en las dos modalidades/)
  assert.match(source, /narration_text:/)
})
