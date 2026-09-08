import { execFileSync } from 'node:child_process'
import { existsSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const scriptsDirectory = dirname(fileURLToPath(import.meta.url))
const readerPath = resolve(scriptsDirectory, 'read-transport-test.ps1')
const workbookPath = resolve(
  'Contenido Cursos',
  'Diapositivas y documentos',
  'Curso 2',
  'Test-Curso-2-Transporte.xlsx',
)
const dryRun = process.argv.includes('--dry-run')

if (!existsSync(workbookPath)) {
  throw new Error(`No se encuentra el test: ${workbookPath}`)
}

const questions = JSON.parse(
  execFileSync(
    'powershell',
    ['-NoProfile', '-File', readerPath, '-WorkbookPath', workbookPath],
    { encoding: 'utf8', maxBuffer: 8 * 1024 * 1024 },
  ),
)

if (questions.length !== 30) {
  throw new Error(`Se esperaban 30 preguntas y se extrajeron ${questions.length}.`)
}
for (const question of questions) {
  if (!/^[1-5]\.(?:10|[1-9])$/.test(question.lessonCode)) {
    throw new Error(`${question.sourceId}: código de unidad no válido.`)
  }
  if (question.options.length !== 4 || !/^[A-D]$/.test(question.correct)) {
    throw new Error(`${question.sourceId}: opciones o respuesta no válidas.`)
  }
  if (!question.active) {
    throw new Error(`${question.sourceId}: la hoja marca la pregunta como inactiva.`)
  }
}

if (dryRun) {
  console.table(
    questions.map((question) => ({
      id: question.sourceId,
      code: question.lessonCode,
      correct: question.correct,
      prompt: question.prompt,
    })),
  )
  process.exit(0)
}

const supabaseUrl = process.env.SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}
const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

const { data: course, error: courseError } = await supabase
  .from('courses')
  .select('id')
  .eq('slug', 'operador-maquinaria-transporte-camion-volquete')
  .single()
if (courseError) throw courseError

const { data: version, error: versionError } = await supabase
  .from('course_versions')
  .select(
    'id, course_modules(id, position, lessons(id, lesson_audio_segments(id, lesson_code)))',
  )
  .eq('course_id', course.id)
  .eq('duration_hours', 5)
  .single()
if (versionError) throw versionError

const units = (version.course_modules ?? []).flatMap((module) =>
  (module.lessons ?? []).flatMap((lesson) =>
    (lesson.lesson_audio_segments ?? []).map((segment) => ({
      ...segment,
      block: module.position,
    })),
  ),
)
const unitByCode = new Map(
  units.map((unit) => [`${unit.block}:${unit.lesson_code}`, unit]),
)
for (const question of questions) {
  if (!unitByCode.has(`${question.block}:${question.lessonCode}`)) {
    throw new Error(`${question.sourceId}: no existe la unidad ${question.lessonCode}.`)
  }
}

const bankTitle = 'Test aportado · Transporte · Reciclaje 5 h'
const { data: existingBank, error: bankSelectError } = await supabase
  .from('question_banks')
  .select('id')
  .eq('course_version_id', version.id)
  .eq('title', bankTitle)
  .maybeSingle()
if (bankSelectError) throw bankSelectError

let bankId = existingBank?.id
if (!bankId) {
  const { data: createdBank, error } = await supabase
    .from('question_banks')
    .insert({ course_version_id: version.id, title: bankTitle })
    .select('id')
    .single()
  if (error) throw error
  bankId = createdBank.id
}

const { data: existingQuestions, error: existingError } = await supabase
  .from('questions')
  .select('prompt')
  .eq('question_bank_id', bankId)
if (existingError) throw existingError
const existingPrompts = new Set(
  (existingQuestions ?? []).map((question) => question.prompt),
)

for (const question of questions) {
  if (existingPrompts.has(question.prompt)) continue
  const unit = unitByCode.get(`${question.block}:${question.lessonCode}`)
  const { data: insertedQuestion, error } = await supabase
    .from('questions')
    .insert({
      question_bank_id: bankId,
      prompt: question.prompt,
      type: 'single_choice',
      explanation: question.explanation,
      points: 1,
      active: true,
      lesson_audio_segment_id: unit.id,
    })
    .select('id')
    .single()
  if (error) throw error
  const correctPosition = question.correct.charCodeAt(0) - 64
  const { error: optionError } = await supabase.from('question_options').insert(
    question.options.map((optionText, index) => ({
      question_id: insertedQuestion.id,
      position: index + 1,
      option_text: optionText,
      is_correct: index + 1 === correctPosition,
    })),
  )
  if (optionError) throw optionError
}

const finalModule = (version.course_modules ?? []).find(
  (module) => module.position === 6,
)
const finalLessonId = finalModule?.lessons?.[0]?.id
if (!finalLessonId) throw new Error('No se encuentra la evaluación final de 5 h.')
const { error: quizError } = await supabase
  .from('quizzes')
  .update({ question_bank_id: bankId, question_count: 10 })
  .eq('lesson_id', finalLessonId)
if (quizError) throw quizError

console.log('Banco de 30 preguntas de transporte 5 h importado correctamente.')
