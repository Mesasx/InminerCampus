import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const source = await readFile(
  'src/components/CourseContentValidationReport.tsx',
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
