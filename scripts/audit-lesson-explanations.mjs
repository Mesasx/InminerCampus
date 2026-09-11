// Audita, curso por curso, la explicación detallada que verá el alumno.
//
// Toma el texto tal cual está guardado, lo pasa por el intérprete común y
// comprueba tres cosas en cada unidad publicada:
//
//   1. que la explicación existe y tiene contenido suficiente;
//   2. que queda estructurada en apartados y no como un bloque plano;
//   3. que no se cuela ninguna referencia editorial (páginas, ficheros,
//      bibliografía de procedencia).
//
// Uso: node --experimental-strip-types scripts/audit-lesson-explanations.mjs
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'
import {
  buildExplanation,
  isEditorialLine,
} from '../src/lib/lesson-explanation.ts'

const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !serviceRoleKey) {
  console.error(
    'Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE_KEY en el entorno.',
  )
  process.exit(1)
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

// Rastros que nunca deben llegar al alumno dentro de la explicación.
const FORBIDDEN = [
  /Referencias o fuentes del capítulo/i,
  /Abrir norma oficial/i,
  /Abrir criterio técnico/i,
  /\.pdf\b/i,
  /Parte \d+\.\d+ del bloque/i,
  /PDF de explicaciones/i,
  /\bp[áa]gina \d+ de \d+/i,
]

// PostgREST devuelve la relación como objeto cuando es de uno a uno y como
// lista cuando es de uno a varios; la aplicación normaliza igual.
function asArray(relation) {
  if (!relation) return []
  return Array.isArray(relation) ? relation : [relation]
}

function flatten(document) {
  return document.sections
    .flatMap((section) => [
      section.heading ?? '',
      ...section.blocks.flatMap((block) =>
        block.type === 'list' ? block.items : [block.text],
      ),
    ])
    .join('\n')
}

const { data: versions, error } = await supabase
  .from('course_versions')
  .select(
    'id, duration_hours, status, courses!inner(slug, title), course_modules(position, title, lessons(title, active, lesson_audio_segments(id, position, lesson_code, published, title, lesson_segment_slides(body), lesson_segment_notes(summary, key_points, stop_criterion))))',
  )
  .order('duration_hours')

if (error) {
  console.error('No se pudo leer el contenido:', error.message)
  process.exit(1)
}

const problems = []
const rows = []

for (const version of versions ?? []) {
  const course = asArray(version.courses)[0] ?? version.courses
  let total = 0
  let structured = 0
  let plain = 0
  let empty = 0
  let shortest = Infinity
  const blocks = new Set()

  for (const module of asArray(version.course_modules)) {
    for (const lesson of asArray(module.lessons)) {
      if (!lesson.active) continue
      for (const segment of asArray(lesson.lesson_audio_segments)) {
        if (!segment.published) continue
        blocks.add(module.position)
        total += 1

        const note = asArray(segment.lesson_segment_notes)[0]
        const slide = asArray(segment.lesson_segment_slides)[0]
        const document = buildExplanation({
          slideBody: slide?.body ?? '',
          noteSummary: note?.summary ?? '',
          noteKeyPoints: note?.key_points ?? [],
          noteStopCriterion: note?.stop_criterion ?? '',
        })

        const text = flatten(document)
        const where = `${course.slug} ${version.duration_hours} h · ${segment.lesson_code ?? segment.position}`

        if (!document.sections.length) {
          empty += 1
          continue
        }

        const titled = document.sections.filter((s) => s.heading).length
        if (titled > 0) structured += 1
        else plain += 1

        shortest = Math.min(shortest, text.length)

        for (const pattern of FORBIDDEN) {
          if (pattern.test(text)) {
            problems.push(`${where}: arrastra ${pattern}`)
          }
        }
        for (const line of text.split('\n')) {
          if (isEditorialLine(line)) {
            problems.push(`${where}: línea editorial «${line.slice(0, 60)}»`)
          }
        }
      }
    }
  }

  if (!total) continue
  rows.push({
    curso: course.title.slice(0, 34),
    h: version.duration_hours,
    estado: version.status,
    bloques: blocks.size,
    unidades: total,
    estructuradas: structured,
    planas: plain,
    'sin texto': empty,
    'más corta': shortest === Infinity ? 0 : shortest,
  })
}

console.table(rows)

if (problems.length) {
  console.error(`\n${problems.length} incidencias:`)
  for (const problem of problems.slice(0, 40)) console.error(' ·', problem)
  process.exit(1)
}

console.log('\nSin referencias editoriales en ninguna explicación publicada.')
