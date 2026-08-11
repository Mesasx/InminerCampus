import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import {
  isCourseVisibleInCatalog,
  isMissingCourseAccessColumnsError,
} from '../src/lib/course-access.ts'

const seedMigrationUrl = new URL(
  '../supabase/migrations/202608110002_seed_course_formacion_stvh.sql',
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

test('muestra STVH por invitación aunque el seed anterior lo hubiera ocultado', () => {
  assert.equal(
    isCourseVisibleInCatalog({ slug: 'formacion-stvh', listed: false }),
    true,
  )
  assert.equal(isCourseVisibleInCatalog({ slug: 'curso-publicado' }), true)
  assert.equal(
    isCourseVisibleInCatalog({ slug: 'curso-oculto', listed: false }),
    false,
  )
})

test('publica Formación STVH en el catálogo pero conserva el acceso por invitación', async () => {
  const sql = await readFile(seedMigrationUrl, 'utf8')

  assert.match(
    sql,
    /'published',\s*'access_code',\s*true,\s*'\/images\/curso-stvh-portada\.jpg'/,
  )
})
