import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import {
  isCourseVisibleInCatalog,
  isMissingCourseAccessColumnsError,
} from '../src/lib/course-access.ts'

const hideMigrationUrl = new URL(
  '../supabase/migrations/20260910161000_hide_formacion_stvh_from_catalog.sql',
  import.meta.url,
)

test('reconoce el esquema anterior para mantener visibles los cursos existentes', () => {
  assert.equal(
    isMissingCourseAccessColumnsError({
      code: '42703',
      message: 'column courses_1.access_mode does not exist',
    }),
    true,
  )
  assert.equal(
    isMissingCourseAccessColumnsError({
      code: 'PGRST204',
      message: "Could not find the 'listed' column of 'courses' in the schema cache",
    }),
    true,
  )
  assert.equal(
    isMissingCourseAccessColumnsError({
      code: '42501',
      message: 'permission denied for table courses',
    }),
    false,
  )
})

test('ningún slug tiene ya una excepción que lo muestre pese a estar oculto', () => {
  assert.equal(
    isCourseVisibleInCatalog({ slug: 'formacion-stvh', listed: false }),
    false,
  )
  assert.equal(isCourseVisibleInCatalog({ slug: 'curso-publicado' }), true)
  assert.equal(
    isCourseVisibleInCatalog({ slug: 'curso-oculto', listed: false }),
    false,
  )
})

test('STVH queda oculta sin despublicarse ni perder las matrículas', async () => {
  const sql = await readFile(hideMigrationUrl, 'utf8')

  // Oculta, no eliminada: sólo cambia `listed`.
  assert.match(sql, /update public\.courses\s+set listed = false/)
  assert.match(sql, /where slug = 'formacion-stvh'/)
  assert.doesNotMatch(sql, /delete from public\.(courses|enrollments|access_codes)/i)
  assert.doesNotMatch(sql, /set\s+status\s*=\s*'(draft|archived)'/i)

  // El alumno matriculado conserva la lectura del curso aunque deje de estar
  // listado, que es lo que sostiene «Mis cursos» y la pantalla de lección.
  assert.match(sql, /create policy courses_enrolled_select/)
  assert.match(sql, /current_user_is_enrolled/)
})
