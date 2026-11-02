import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const source = await readFile(
  'src/components/CourseContentValidationReport.tsx',
  'utf8',
)
const editorSource = await readFile(
  'src/components/AdminCourseContentEditor.tsx',
  'utf8',
)
const notesMigration = await readFile(
  'supabase/migrations/20261102224500_admin_course_segment_notes.sql',
  'utf8',
)

test('el informe revisa todos los módulos y numera las lecciones globalmente', () => {
  assert.doesNotMatch(source, /module\.position\s*<=\s*5/)
  assert.doesNotMatch(source, /segment\.position\s*<=\s*10/)
  assert.match(source, /lessonOrdinal \+= 1/)
  assert.match(
    source,
    /expectedCode: `\$\{lessonOrdinal\}\.\$\{segment\.position\}`/,
  )
})

test('el informe reconoce la referencia bloque y diapositiva del manual nuevo', () => {
  assert.match(source, /bloque\\s\+\\d\+/)
  assert.match(source, /diapositiva\\s\+\\d\+/)
})

test('el panel obtiene las explicaciones mediante una función administrativa segura', () => {
  for (const component of [source, editorSource]) {
    assert.match(component, /admin_course_segment_notes/)
    assert.match(component, /notesBySegment/)
  }
  assert.match(
    notesMigration,
    /create or replace function public\.admin_course_segment_notes/,
  )
  assert.match(notesMigration, /security definer/)
  assert.match(notesMigration, /current_user_has_role/)
  assert.match(notesMigration, /grant execute[^;]+to authenticated/s)
})
