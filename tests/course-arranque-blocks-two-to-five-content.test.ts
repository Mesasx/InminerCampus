import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'

const migration = readFileSync(
  new URL(
    '../supabase/migrations/20260814071523_course_arranque_blocks_two_to_five_content_and_tests.sql',
    import.meta.url,
  ),
  'utf8',
)
const player = readFileSync(
  new URL('../src/components/AudioLessonPlayer.tsx', import.meta.url),
  'utf8',
)
const explanationLib = readFileSync(
  new URL('../src/lib/lesson-explanation.ts', import.meta.url),
  'utf8',
)
const evaluation = readFileSync(
  new URL(
    '../src/routes/evaluacion.$enrollmentId.$quizId.tsx',
    import.meta.url,
  ),
  'utf8',
)
const lesson = readFileSync(
  new URL(
    '../src/routes/campus.$enrollmentId.leccion.$lessonId.tsx',
    import.meta.url,
  ),
  'utf8',
)

test('instala las 40 explicaciones en los cursos de 5 y 20 horas', () => {
  const detailSection = migration.slice(
    migration.indexOf('insert into _arranque_detailed_explanations'),
    migration.indexOf('-- Alinea los títulos'),
  )

  assert.equal((detailSection.match(/\$db\$/g) ?? []).length, 80)
  assert.match(migration, /version\.duration_hours in \(5, 20\)/)
  assert.match(migration, /detail\.block_position = module\.position/)
  assert.match(migration, /detailed_note_count <> 80/)
  assert.match(migration, /PDF p\. ' \|\| detail\.pdf_page \|\| ' de 52/)
  assert.match(migration, /En esta edición de reciclaje, la duración es de cinco horas/)
})

test('instala 15 preguntas por bloque y la evaluación final en ambos cursos', () => {
  const questionSection = migration.slice(
    migration.indexOf('insert into _arranque_supplied_questions'),
    migration.indexOf("do $$\nbegin\n  if (select count(*) from _arranque_supplied_questions"),
  )

  assert.equal((questionSection.match(/\$qp\$/g) ?? []).length, 140)
  assert.match(migration, /60 preguntas de bloque y 10 finales/)
  assert.match(migration, /question_count <> 140/)
  assert.match(migration, /option_count <> 560/)
  assert.match(migration, /correct_option_count <> 140/)
  assert.match(migration, /completion_mode <> 'cumulative_perfect'/)
  assert.match(migration, /required_perfect_streak <> 3/)
  assert.match(migration, /Alguna pregunta no tiene cuatro opciones y una única respuesta correcta/)
})

test('crea la evaluación final que faltaba en el curso de 5 horas', () => {
  assert.match(
    migration,
    /where target\.duration_hours = 5\r?\non conflict \(course_version_id, position\)/,
  )
  assert.match(migration, /'Evaluación final integradora'/)
  assert.match(migration, /Se esperaban cinco evaluaciones en cada uno de los dos cursos/)
  assert.match(migration, /insert into public\.lesson_progress/)
})

test('muestra las explicaciones detalladas y el criterio formal del test', () => {
  for (const heading of [
    'Explicación de base',
    'Profundización técnica y criterio preventivo',
    'Secuencia operativa recomendada',
    'Caso práctico razonado',
    'Errores críticos que deben evitarse',
    'Comprobación antes de continuar',
  ]) {
    assert.match(explanationLib, new RegExp(heading))
  }

  // El texto de la evaluación ya no se escribe a mano para un número concreto
  // de preguntas: sale del mismo redactor común con las cifras del test.
  assert.doesNotMatch(evaluation, /consta de 15 preguntas/)
  assert.doesNotMatch(lesson, /consta de 15 preguntas/)
  assert.match(evaluation, /quizIntroCopy\(/)
  assert.match(lesson, /quizIntroCopy\(/)
  assert.doesNotMatch(evaluation, /cada parte del Bloque 1/)
})
