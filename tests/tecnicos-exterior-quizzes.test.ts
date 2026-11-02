import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const quizSpec = JSON.parse(
  await readFile('content/tecnicos-exterior-20h/quizzes.json', 'utf8'),
)

const migration = await readFile(
  'supabase/migrations/20261026133000_tecnicos_exterior_block_tests.sql',
  'utf8',
)

test('los seis bloques oficiales tienen un test propio', () => {
  assert.equal(quizSpec.blocks.length, 6)
  assert.deepEqual(
    quizSpec.blocks.map((block: { block: number }) => block.block),
    [1, 2, 3, 4, 5, 6],
  )
  assert.equal(
    quizSpec.blocks.reduce(
      (total: number, block: { questions: unknown[] }) =>
        total + block.questions.length,
      0,
    ),
    90,
  )
  for (const block of quizSpec.blocks) assert.equal(block.questions.length, 15)
})

test('cada pregunta tiene cuatro opciones y una sola respuesta', () => {
  const prompts = new Set<string>()
  for (const block of quizSpec.blocks) {
    for (const question of block.questions) {
      assert.equal(question.options.length, 4)
      assert.equal(new Set(question.options).size, 4)
      assert.ok(question.correct >= 0 && question.correct < 4)
      assert.ok(question.prompt.length >= 20)
      assert.ok(question.explanation.length >= 40)
      assert.ok(
        !prompts.has(question.prompt),
        `Pregunta duplicada: ${question.prompt}`,
      )
      prompts.add(question.prompt)
    }
  }
})

test('ningún test muestra referencias editoriales a diapositivas', () => {
  const sourceReference =
    /(?:según|aparece en|muestra en|recogida en)\s+(?:la\s+)?(?:diapositiva|slide)|(?:diapositiva|slide)\s+\d+/i
  for (const block of quizSpec.blocks) {
    for (const question of block.questions) {
      assert.doesNotMatch(question.prompt, sourceReference)
      for (const option of question.options) {
        assert.doesNotMatch(option, sourceReference)
      }
    }
  }
})

test('los test exigen dos rondas perfectas acumuladas', () => {
  assert.equal(quizSpec.passing_percent, 100)
  assert.equal(quizSpec.required_perfect_rounds, 2)
  assert.equal(quizSpec.completion_mode, 'cumulative_perfect')
  assert.match(migration, /required_perfect_streak = 2/)
  assert.match(migration, /'cumulative_perfect'/)
  assert.match(migration, /question_count = 15/)
})

test('la migración valida los 6 test, 90 preguntas y 360 opciones', () => {
  assert.match(migration, /v_banks <> 6/)
  assert.match(migration, /v_questions <> 90/)
  assert.match(migration, /v_options <> 360/)
  assert.match(migration, /v_quizzes <> 6/)
  assert.doesNotMatch(migration, /status\s*=\s*'published'/)
})

test('la migración correctiva sanea los bancos sin publicar el curso', async () => {
  const correction = await readFile(
    'supabase/migrations/20261102221912_harden_quizzes_recovery_and_notes.sql',
    'utf8',
  )
  assert.match(correction, /e7447d7f-e76e-4375-9e9e-7e7c0d79bb26/)
  assert.match(correction, /e1125f27-a04a-43d7-8862-e12ed0a3d9ea/)
  assert.match(correction, /9aba220d-39b0-5ba7-a21c-cdcc05ae4fa2/)
  assert.doesNotMatch(correction, /status\s*=\s*'published'/)
})
