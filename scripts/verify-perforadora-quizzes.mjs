// Comprueba que los tests cargados de Perforadora reproducen exactamente el
// libro de preguntas aportado: mismo enunciado, mismas cuatro opciones, misma
// respuesta correcta y misma justificación, bloque por bloque.
//
// Uso: node scripts/verify-perforadora-quizzes.mjs
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'
import { readWorkbook } from './import-administracion-quizzes.mjs'
import { WORKBOOK, collectQuestions } from './import-perforadora-quizzes.mjs'

const COURSE_SLUG = 'operadores-perforacion-corte-exterior'

const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!supabaseUrl || !serviceRoleKey) {
  console.error('Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE_KEY en el entorno.')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

const problems = []
const expected = collectQuestions(await readWorkbook(WORKBOOK))

const { data: quizzes, error } = await supabase
  .from('quizzes')
  .select(
    'id, title, question_count, required_perfect_streak, passing_percent, completion_mode, active, randomize_questions, randomize_options, question_bank_id, lessons!inner(course_modules!inner(position, course_versions!inner(duration_hours, courses!inner(slug))))',
  )
if (error) {
  console.error(error.message)
  process.exit(1)
}

const mine = quizzes.filter(
  (quiz) =>
    quiz.lessons.course_modules.course_versions.courses.slug === COURSE_SLUG,
)
if (mine.length !== 10) {
  problems.push(`Se esperaban 10 evaluaciones y hay ${mine.length}`)
}

let checked = 0

for (const quiz of mine) {
  const duration = quiz.lessons.course_modules.course_versions.duration_hours
  const block = quiz.lessons.course_modules.position
  const where = `${duration} h · bloque ${block}`

  if (Number(quiz.passing_percent) !== 100) {
    problems.push(`${where}: se supera con ${quiz.passing_percent} %`)
  }
  if (quiz.required_perfect_streak !== 3) {
    problems.push(`${where}: exige ${quiz.required_perfect_streak} rondas`)
  }
  if (quiz.completion_mode !== 'cumulative_perfect') {
    problems.push(`${where}: modo ${quiz.completion_mode}`)
  }
  if (!quiz.active || !quiz.randomize_questions || !quiz.randomize_options) {
    problems.push(`${where}: configuración de barajado o actividad inesperada`)
  }

  const { data: questions, error: questionError } = await supabase
    .from('questions')
    .select(
      'prompt, type, explanation, active, question_options(option_text, is_correct, position)',
    )
    .eq('question_bank_id', quiz.question_bank_id)
  if (questionError) {
    problems.push(`${where}: ${questionError.message}`)
    continue
  }

  const source = expected.filter(
    (item) => item.duration === duration && item.block === block,
  )
  if (questions.length !== source.length) {
    problems.push(
      `${where}: ${questions.length} preguntas cargadas frente a ${source.length} del libro`,
    )
  }
  if (quiz.question_count !== source.length) {
    problems.push(
      `${where}: el test anuncia ${quiz.question_count} y el libro trae ${source.length}`,
    )
  }

  const byPrompt = new Map(questions.map((row) => [row.prompt, row]))

  for (const item of source) {
    const loaded = byPrompt.get(item.prompt)
    if (!loaded) {
      problems.push(`${where}: falta «${item.prompt.slice(0, 60)}…»`)
      continue
    }
    checked += 1

    if (loaded.explanation !== item.explanation) {
      problems.push(`${where}: justificación distinta en «${item.prompt.slice(0, 45)}…»`)
    }
    if (loaded.type !== 'single_choice' || !loaded.active) {
      problems.push(`${where}: tipo o estado inesperado en «${item.prompt.slice(0, 45)}…»`)
    }

    const options = [...(loaded.question_options ?? [])].sort(
      (a, b) => a.position - b.position,
    )
    if (options.length !== 4) {
      problems.push(`${where}: «${item.prompt.slice(0, 45)}…» no tiene 4 opciones`)
      continue
    }
    for (const [index, option] of options.entries()) {
      if (option.option_text !== item.options[index]) {
        problems.push(
          `${where}: opción ${index + 1} distinta en «${item.prompt.slice(0, 45)}…»`,
        )
      }
    }
    const correct = options.filter((option) => option.is_correct)
    if (correct.length !== 1) {
      problems.push(
        `${where}: «${item.prompt.slice(0, 45)}…» tiene ${correct.length} respuestas correctas`,
      )
    } else if (correct[0].option_text !== item.options[item.correctIndex]) {
      problems.push(
        `${where}: la respuesta correcta no coincide en «${item.prompt.slice(0, 45)}…»`,
      )
    }
  }
}

console.log(`Evaluaciones revisadas: ${mine.length}`)
console.log(`Preguntas contrastadas con el libro: ${checked} de ${expected.length}`)

if (problems.length) {
  console.error(`\n${problems.length} incidencias:`)
  for (const problem of problems.slice(0, 30)) console.error(' ·', problem)
  process.exit(1)
}

console.log('\nLos tests cargados reproducen el libro exactamente.')
