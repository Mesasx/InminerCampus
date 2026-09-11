// Carga los tests del curso «Administración y personal de servicios distintos a
// los de mantenimiento» desde el libro de preguntas aportado y validado.
//
// El libro trae 15 preguntas por bloque para la formación inicial de 20 h y 10
// por bloque para el reciclaje de 5 h, en los seis bloques de cada modalidad.
// Cada pregunta declara la diapositiva de la que procede, de modo que aquí se
// enlaza con la unidad correspondiente: es lo que permite que, tras un intento
// imperfecto, el alumno reciba las partes que conviene repasar.
//
// El enunciado, las cuatro opciones, la respuesta marcada y la justificación se
// vuelcan tal cual vienen en el libro. No se reescribe ni se reordena nada.
//
// Es aditivo e idempotente: un bloque que ya tenga evaluación se deja intacto.
// No borra preguntas, bancos, matrículas ni intentos.
//
// Uso:
//   node scripts/import-administracion-quizzes.mjs [--dry-run]
import { readFile } from 'node:fs/promises'
import process from 'node:process'
import { inflateRawSync } from 'node:zlib'
import { pathToFileURL } from 'node:url'
import { createClient } from '@supabase/supabase-js'

const COURSE_SLUG = 'administracion-personal-servicios-no-mantenimiento'
export const WORKBOOK =
  'Contenido Cursos/Preguntas_Administracion_5h_20h_VALIDADO_Diapositivas_Manual (1).xlsx'
// Unidades por bloque del curso (ET 2004-1-10).
const BLOCK_SIZES = [9, 10, 9, 6, 9, 7]
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

// --- Lectura del libro -----------------------------------------------------
// El entorno no trae openpyxl ni una librería de xlsx, y un .xlsx es un zip de
// XML: se lee con lo que ya hay en el proyecto.
export async function readWorkbook(path) {
  const buffer = await readFile(path)
  const entries = unzip(buffer)
  const shared = readSharedStrings(entries)
  const workbook = entries.get('xl/workbook.xml')
  const rels = entries.get('xl/_rels/workbook.xml.rels')
  const sheets = new Map()

  // El orden de los atributos varía según la herramienta que generó el libro,
  // así que se leen por nombre y no por posición.
  const relTargets = new Map()
  for (const [, attrs] of rels.matchAll(/<Relationship([^>]*)\/?>/g)) {
    const id = attrs.match(/\bId="([^"]+)"/)?.[1]
    const target = attrs.match(/\bTarget="([^"]+)"/)?.[1]
    if (id && target) relTargets.set(id, target)
  }

  for (const [, name, rid] of workbook.matchAll(
    /<(?:\w+:)?sheet[^>]*name="([^"]+)"[^>]*r:id="([^"]+)"/g,
  )) {
    let target = (relTargets.get(rid) ?? '').replace(/^\//, '')
    if (!target.startsWith('xl/')) target = `xl/${target}`
    sheets.set(decodeXml(name), parseSheet(entries.get(target), shared))
  }
  return sheets
}

function readSharedStrings(entries) {
  const xml = entries.get('xl/sharedStrings.xml')
  if (!xml) return []
  return [...xml.matchAll(/<(?:\w+:)?si[^>]*>([\s\S]*?)<\/(?:\w+:)?si>/g)].map(([, si]) =>
    decodeXml(
      [...si.matchAll(/<(?:\w+:)?t[^>]*>([\s\S]*?)<\/(?:\w+:)?t>/g)].map(([, t]) => t).join(''),
    ),
  )
}

function parseSheet(xml, shared) {
  const rows = []
  for (const [, rowXml] of xml.matchAll(/<(?:\w+:)?row[^>]*>([\s\S]*?)<\/(?:\w+:)?row>/g)) {
    const cells = {}
    for (const [, attrs, body] of rowXml.matchAll(
      /<(?:\w+:)?c([^>]*?)(?:\/>|>([\s\S]*?)<\/(?:\w+:)?c>)/g,
    )) {
      const ref = attrs.match(/r="([A-Z]+)\d+"/)?.[1]
      if (!ref) continue
      const type = attrs.match(/t="([^"]+)"/)?.[1]
      const raw = body ?? ''
      const value = raw.match(/<(?:\w+:)?v[^>]*>([\s\S]*?)<\/(?:\w+:)?v>/)?.[1]
      let text = ''
      if (type === 's' && value !== undefined) text = shared[Number(value)] ?? ''
      else if (type === 'inlineStr')
        text = [...raw.matchAll(/<(?:\w+:)?t[^>]*>([\s\S]*?)<\/(?:\w+:)?t>/g)]
          .map(([, t]) => t)
          .join('')
      else if (value !== undefined) text = value
      cells[ref] = decodeXml(text).trim()
    }
    if (Object.keys(cells).length) rows.push(cells)
  }
  return rows
}

function decodeXml(value) {
  return value
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&#(\d+);/g, (_, code) => String.fromCodePoint(Number(code)))
    .replace(/&amp;/g, '&')
}

// Descompresor mínimo: sólo necesita los ficheros XML del .xlsx, que van en
// deflate o almacenados sin comprimir.
function unzip(buffer) {
  const entries = new Map()
  const view = new DataView(
    buffer.buffer,
    buffer.byteOffset,
    buffer.byteLength,
  )
  let offset = buffer.length - 22
  while (offset >= 0 && view.getUint32(offset, true) !== 0x06054b50) offset -= 1
  if (offset < 0) throw new Error('El .xlsx no tiene fin de directorio central')
  const count = view.getUint16(offset + 10, true)
  let position = view.getUint32(offset + 16, true)

  for (let index = 0; index < count; index += 1) {
    if (view.getUint32(position, true) !== 0x02014b50) break
    const method = view.getUint16(position + 10, true)
    const compressedSize = view.getUint32(position + 20, true)
    const nameLength = view.getUint16(position + 28, true)
    const extraLength = view.getUint16(position + 30, true)
    const commentLength = view.getUint16(position + 32, true)
    const localOffset = view.getUint32(position + 42, true)
    const name = buffer
      .subarray(position + 46, position + 46 + nameLength)
      .toString('utf8')

    const localNameLength = view.getUint16(localOffset + 26, true)
    const localExtraLength = view.getUint16(localOffset + 28, true)
    const dataStart = localOffset + 30 + localNameLength + localExtraLength
    const raw = buffer.subarray(dataStart, dataStart + compressedSize)
    if (name.endsWith('.xml') || name.endsWith('.rels')) {
      entries.set(
        name,
        (method === 0 ? raw : inflateRawSync(raw)).toString('utf8'),
      )
    }
    position += 46 + nameLength + extraLength + commentLength
  }
  return entries
}

// --- Preparación de las preguntas -----------------------------------------
function slideToCode(slide) {
  let start = 1
  for (const [index, size] of BLOCK_SIZES.entries()) {
    if (slide >= start && slide < start + size) {
      return `${index + 1}.${slide - start + 1}`
    }
    start += size
  }
  throw new Error(`Diapositiva fuera del curso: ${slide}`)
}

export function collectQuestions(sheets) {
  const questions = []
  for (const [sheetName, duration] of Object.entries(SHEETS)) {
    const rows = sheets.get(sheetName)
    if (!rows) fail(`El libro no tiene la hoja «${sheetName}»`)
    for (const row of rows.slice(1)) {
      if (!row.A) continue
      const block = Number(row.C)
      const slide = Number(row.F)
      const letter = row.M
      const options = ['A', 'B', 'C', 'D'].map((key) => row[COLUMNS[key]] ?? '')

      if (!COLUMNS[letter]) fail(`${row.A}: letra correcta «${letter}»`)
      if (row[COLUMNS[letter]] !== row.N) {
        fail(`${row.A}: la respuesta marcada no coincide con la opción ${letter}`)
      }
      if (options.some((option) => !option)) fail(`${row.A}: opción vacía`)
      if (new Set(options).size !== 4) fail(`${row.A}: opciones repetidas`)
      if (!row.H) fail(`${row.A}: enunciado vacío`)
      if (!row.O) fail(`${row.A}: sin justificación`)

      const code = slideToCode(slide)
      if (!code.startsWith(`${block}.`)) {
        fail(`${row.A}: la diapositiva ${slide} no pertenece al bloque ${block}`)
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
    for (let block = 1; block <= BLOCK_SIZES.length; block += 1) {
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

  const ids = new Set()
  for (const question of questions) {
    if (ids.has(question.externalId)) fail(`ID repetido: ${question.externalId}`)
    ids.add(question.externalId)
  }

  return questions
}

// --- Carga -----------------------------------------------------------------
async function main() {
  const sheets = await readWorkbook(WORKBOOK)
  const questions = collectQuestions(sheets)
  console.log(`Libro leído: ${questions.length} preguntas validadas.`)

  const { data: versions, error: versionError } = await supabase
    .from('course_versions')
    .select('id, duration_hours, courses!inner(slug)')
    .eq('courses.slug', COURSE_SLUG)
  if (versionError) fail(versionError.message)

  const summary = []

  for (const version of versions) {
    const duration = version.duration_hours

    const { data: modules, error: moduleError } = await supabase
      .from('course_modules')
      .select('id, position, lessons(id, title, active)')
      .eq('course_version_id', version.id)
      .order('position')
    if (moduleError) fail(moduleError.message)

    const { data: segments, error: segmentError } = await supabase
      .from('lesson_audio_segments')
      .select('id, lesson_code, lessons!inner(module_id)')
      .eq('published', true)
      .in(
        'lesson_id',
        modules.flatMap((module) =>
          (module.lessons ?? []).map((lesson) => lesson.id),
        ),
      )
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
        })
        continue
      }

      const blockQuestions = questions
        .filter((item) => item.duration === duration && item.block === block)
        .sort((a, b) => a.order - b.order)

      for (const question of blockQuestions) {
        if (!segmentByCode.has(question.code)) {
          fail(`No se encuentra la unidad ${question.code} (${duration} h)`)
        }
      }

      if (dryRun) {
        summary.push({
          modalidad: `${duration} h`,
          bloque: block,
          estado: 'simulado',
          preguntas: blockQuestions.length,
        })
        continue
      }

      const { data: bank, error: bankError } = await supabase
        .from('question_banks')
        .insert({
          course_version_id: version.id,
          title: `Evaluación aportada · Administración ${duration} h · Bloque ${block} · 2026-09-11`,
        })
        .select('id')
        .single()
      if (bankError) fail(bankError.message)

      // El esquema admite una sola pregunta enlazada por unidad dentro de cada
      // banco, que es como están cargados el resto de cursos: se enlaza la
      // primera pregunta de cada unidad y las demás quedan sin enlazar. El
      // enlace sólo alimenta la lista de partes a repasar; la pregunta se
      // corrige igual esté enlazada o no.
      const linkedCodes = new Set()
      const { data: inserted, error: insertError } = await supabase
        .from('questions')
        .insert(
          blockQuestions.map((question) => {
            const first = !linkedCodes.has(question.code)
            linkedCodes.add(question.code)
            return {
              question_bank_id: bank.id,
              prompt: question.prompt,
              type: 'single_choice',
              explanation: question.explanation,
              points: 1,
              active: true,
              lesson_audio_segment_id: first
                ? segmentByCode.get(question.code)
                : null,
            }
          }),
        )
        .select('id, prompt')
      if (insertError) fail(insertError.message)

      const byPrompt = new Map(inserted.map((row) => [row.prompt, row.id]))
      const options = blockQuestions.flatMap((question) =>
        question.options.map((text, index) => ({
          question_id: byPrompt.get(question.prompt),
          option_text: text,
          is_correct: index === question.correctIndex,
          position: index + 1,
        })),
      )
      const { error: optionError } = await supabase
        .from('question_options')
        .insert(options)
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
      })
    }
  }

  console.table(
    summary.sort(
      (a, b) =>
        a.modalidad.localeCompare(b.modalidad) || a.bloque - b.bloque,
    ),
  )
  console.log(dryRun ? '\nSimulación: no se ha escrito nada.' : '\nCarga terminada.')
}

// Sólo actúa cuando se ejecuta directamente: así la verificación puede
// reutilizar la lectura y la validación del libro sin escribir nada.
if (pathToFileURL(process.argv[1] ?? '').href === import.meta.url) {
  await main()
}
