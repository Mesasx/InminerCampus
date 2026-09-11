// Carga los tests del curso «Operador de perforadora / perforista» desde el
// libro de preguntas aportado y validado.
//
// El libro trae 15 preguntas por bloque para la formación inicial de 20 h y 10
// por bloque para el reciclaje de 5 h, en los cinco bloques de cada modalidad.
// Igual que en el libro de Establecimientos de beneficio, cada pregunta declara
// ya su unidad («1.1», «3.7»…), así que no hay que deducirla del número de
// diapositiva.
//
// El enunciado, las cuatro opciones, la respuesta marcada y la justificación se
// vuelcan tal cual vienen en el libro. No se reescribe ni se reordena nada. Las
// columnas de procedencia documental del libro no se cargan: son referencias
// editoriales y no deben llegar al alumno.
//
// Las dos modalidades están publicadas con sus cincuenta unidades, de modo que
// todas las preguntas encuentran su unidad y la primera de cada una queda
// enlazada para alimentar la lista de partes a repasar tras un fallo.
//
// Es aditivo e idempotente: un bloque que ya tenga evaluación se deja intacto.
// No borra preguntas, bancos, matrículas ni intentos.
//
// Uso:
//   node scripts/import-perforadora-quizzes.mjs [--dry-run]
import process from 'node:process'
import { pathToFileURL } from 'node:url'
import { createClient } from '@supabase/supabase-js'
import { readWorkbook } from './import-administracion-quizzes.mjs'

const COURSE_SLUG = 'operadores-perforacion-corte-exterior'
export const WORKBOOK =
  'Contenido Cursos/Preguntas_Perforadora_5h_20h_VALIDADO.xlsx'
const BLOCKS = 5
const EXPECTED_PER_BLOCK = { 5: 10, 20: 15 }
const SHEETS = { '20 horas': 20, '5 horas': 5 }
const COLUMNS = { A: 'I', B: 'J', C: 'K', D: 'L' }

const dryRun = process.argv.includes('--dry-run')
const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !serviceRoleKey) {
  console.error('Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE_KEY en el entorno.')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

function fail(message) {
  console.error(`\n✖ ${message}`)
  process.exit(1)
}

export function collectQuestions(sheets) {
  const questions = []
  const seen = new Set()

  for (const [sheetName, duration] of Object.entries(SHEETS)) {
    const rows = sheets.get(sheetName)
    if (!rows) fail(`El libro no tiene la hoja «${sheetName}»`)

    for (const row of rows.slice(1)) {
      if (!row.A) continue
      const block = Number(row.C)
      const letter = row.M
      const code = (row.E ?? '').trim()
      const options = ['A', 'B', 'C', 'D'].map((key) => row[COLUMNS[key]] ?? '')

      if (seen.has(row.A)) fail(`ID repetido: ${row.A}`)
      seen.add(row.A)
      if (!COLUMNS[letter]) fail(`${row.A}: letra correcta «${letter}»`)
      if (row[COLUMNS[letter]] !== row.N) {
        fail(`${row.A}: la respuesta marcada no coincide con la opción ${letter}`)
      }
      if (options.some((option) => !option)) fail(`${row.A}: opción vacía`)
      if (new Set(options).size !== 4) fail(`${row.A}: opciones repetidas`)
      if (!row.H) fail(`${row.A}: enunciado vacío`)
      if (!row.O) fail(`${row.A}: sin justificación`)
      if (!/^\d+\.\d+$/.test(code)) fail(`${row.A}: unidad «${code}» mal formada`)
      if (!code.startsWith(`${block}.`)) {
        fail(`${row.A}: la unidad ${code} no pertenece al bloque ${block}`)
      }

      questions.push({
        externalId: row.A,
        duration,
        block,
        order: Number(row.D),
        code,
        prompt: row.H,
        options,
        correctIndex: ['A', 'B', 'C', 'D'].indexOf(letter),
        explanation: row.O,
      })
    }
  }

  for (const [duration, expected] of Object.entries(EXPECTED_PER_BLOCK)) {
    for (let block = 1; block <= BLOCKS; block += 1) {
      const count = questions.filter(
        (item) => item.duration === Number(duration) && item.block === block,
      ).length
      if (count !== expected) {
        fail(
          `${duration} h bloque ${block}: ${count} preguntas, se esperaban ${expected}`,
        )
      }
    }
  }

  return questions
}

async function main() {
  const questions = collectQuestions(await readWorkbook(WORKBOOK))
  console.log(`Libro leído: ${questions.length} preguntas validadas.`)

  const { data: versions, error: versionError } = await supabase
    .from('course_versions')
    .select('id, duration_hours, status, courses!inner(slug)')
    .eq('courses.slug', COURSE_SLUG)
  if (versionError) fail(versionError.message)

  const summary = []

  for (const version of versions) {
    const duration = version.duration_hours

    const { data: modules, error: moduleError } = await supabase
      .from('course_modules')
      .select('id, position, lessons(id, active)')
      .eq('course_version_id', version.id)
      .order('position')
    if (moduleError) fail(moduleError.message)

    const lessonIds = modules.flatMap((module) =>
      (module.lessons ?? []).map((lesson) => lesson.id),
    )
    const { data: segments, error: segmentError } = await supabase
      .from('lesson_audio_segments')
      .select('id, lesson_code')
      .eq('published', true)
      .in('lesson_id', lessonIds)
    if (segmentError) fail(segmentError.message)
    const segmentByCode = new Map(
      segments.map((segment) => [segment.lesson_code, segment.id]),
    )

    for (const module of modules) {
      const block = module.position
      const lesson = (module.lessons ?? []).find((item) => item.active)
      if (!lesson) fail(`Falta la lección del bloque ${block} (${duration} h)`)

      const { data: existing, error: quizError } = await supabase
        .from('quizzes')
        .select('id')
        .eq('lesson_id', lesson.id)
      if (quizError) fail(quizError.message)
      if (existing.length) {
        summary.push({
          modalidad: `${duration} h`,
          bloque: block,
          estado: 'ya tenía test, intacto',
          preguntas: 0,
          'enlazadas a unidad': 0,
        })
        continue
      }

      const blockQuestions = questions
        .filter((item) => item.duration === duration && item.block === block)
        .sort((a, b) => a.order - b.order)

      // El esquema admite una sola pregunta enlazada por unidad dentro de cada
      // banco, que es como está cargado el resto del campus: se enlaza la
      // primera pregunta de cada unidad y las demás quedan sin enlazar.
      const linked = new Set()
      const rows = blockQuestions.map((question) => {
        const segmentId = segmentByCode.get(question.code)
        if (!segmentId) {
          fail(`No se encuentra la unidad ${question.code} (${duration} h)`)
        }
        const first = !linked.has(question.code)
        if (first) linked.add(question.code)
        return {
          question_bank_id: null,
          prompt: question.prompt,
          type: 'single_choice',
          explanation: question.explanation,
          points: 1,
          active: true,
          lesson_audio_segment_id: first ? segmentId : null,
        }
      })

      if (dryRun) {
        summary.push({
          modalidad: `${duration} h`,
          bloque: block,
          estado: 'simulado',
          preguntas: blockQuestions.length,
          'enlazadas a unidad': linked.size,
        })
        continue
      }

      const { data: bank, error: bankError } = await supabase
        .from('question_banks')
        .insert({
          course_version_id: version.id,
          title: `Evaluación aportada · Perforadora ${duration} h · Bloque ${block} · 2026-09-11`,
        })
        .select('id')
        .single()
      if (bankError) fail(bankError.message)

      const { data: inserted, error: insertError } = await supabase
        .from('questions')
        .insert(rows.map((row) => ({ ...row, question_bank_id: bank.id })))
        .select('id, prompt')
      if (insertError) fail(insertError.message)

      const byPrompt = new Map(inserted.map((row) => [row.prompt, row.id]))
      const { error: optionError } = await supabase
        .from('question_options')
        .insert(
          blockQuestions.flatMap((question) =>
            question.options.map((text, index) => ({
              question_id: byPrompt.get(question.prompt),
              option_text: text,
              is_correct: index === question.correctIndex,
              position: index + 1,
            })),
          ),
        )
      if (optionError) fail(optionError.message)

      const { error: createQuizError } = await supabase.from('quizzes').insert({
        lesson_id: lesson.id,
        question_bank_id: bank.id,
        title: `Test del bloque ${block} · ${blockQuestions.length} preguntas`,
        question_count: blockQuestions.length,
        passing_percent: 100,
        required_perfect_streak: 3,
        randomize_questions: true,
        randomize_options: true,
        minimum_retry_seconds: 0,
        active: true,
        completion_mode: 'cumulative_perfect',
      })
      if (createQuizError) fail(createQuizError.message)

      summary.push({
        modalidad: `${duration} h`,
        bloque: block,
        estado: 'creado',
        preguntas: blockQuestions.length,
        'enlazadas a unidad': linked.size,
      })
    }
  }

  console.table(
    summary.sort(
      (a, b) => a.modalidad.localeCompare(b.modalidad) || a.bloque - b.bloque,
    ),
  )
  console.log(dryRun ? '\nSimulación: no se ha escrito nada.' : '\nCarga terminada.')
}

if (pathToFileURL(process.argv[1] ?? '').href === import.meta.url) {
  await main()
}
