import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202608120002_enforce_course_listed_visibility.sql',
  import.meta.url,
)

test('las políticas públicas de catálogo dejan de mostrar cursos no listados', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  const policies = [
    'courses_public_published',
    'course_versions_visible',
    'course_modules_visible',
    'lessons_visible',
  ]
  for (const policy of policies) {
    const section = sql.split(`create policy ${policy}\n`)[1]
    assert.ok(section, `falta la política ${policy}`)
    assert.match(section.slice(0, 400), /listed/)
  }
})
