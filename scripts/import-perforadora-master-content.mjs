import { execFileSync } from 'node:child_process'
import { existsSync, readFileSync } from 'node:fs'
import { basename, extname, resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const COURSE_SLUG = 'operadores-perforacion-corte-exterior'
const MANUAL_NAME = 'Manual_Operador_Perforadora_Inminer_Campus.pdf'
const SOURCE_LABEL = MANUAL_NAME
const manualPath = resolve(
  'Contenido Cursos',
  'Diapositivas y documentos',
  MANUAL_NAME,
)
const dryRun = process.argv.includes('--dry-run')
const skipUpload = process.argv.includes('--skip-upload')
const exportJson = process.argv.includes('--export-json')
const exportJsonAscii = process.argv.includes('--export-json-ascii')

if (!existsSync(manualPath)) {
  throw new Error(`No se encuentra el manual: ${manualPath}`)
}

const supabaseUrl = process.env.SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!exportJson && !exportJsonAscii && (!supabaseUrl || !serviceRoleKey)) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}

const supabase =
  exportJson || exportJsonAscii
    ? null
    : createClient(supabaseUrl, serviceRoleKey, {
        auth: { persistSession: false },
      })

const manualText = execFileSync(
  'pdftotext',
  ['-raw', '-enc', 'UTF-8', manualPath, '-'],
  { encoding: 'utf8', maxBuffer: 20 * 1024 * 1024 },
)

const headings = [
  'Definición y alcance',
  'Fundamento técnico ampliado',
  'Riesgo que debe comprenderse',
  'Criterio de actuación',
  'Caso razonado',
]

function cleanExtractedText(text) {
  return text
    .replace(/\f/g, '\n')
    .replace(/^MANUAL MAESTRO · OPERADOR DE PERFORADORA\s*$/gm, '')
    .replace(/^INMÍNER CAMPUS · ET 2003-1-10\s+PÁGINA\s+\d+\s*$/gm, '')
    .replace(/[ \t]+$/gm, '')
    .replace(/\n{3,}/g, '\n\n')
    .trim()
}

function chapterSource(code) {
  const block = Number(code.split('.')[0])
  const startMarker = `BLOQUE ${block} · CAPÍTULO ${code}`
  const start = manualText.indexOf(startMarker)
  if (start < 0) throw new Error(`No se encuentra ${startMarker}.`)
  const nextCodeNumber = Number(code.split('.')[1]) + 1
  const nextMarker =
    nextCodeNumber <= 10
      ? `BLOQUE ${block} · CAPÍTULO ${block}.${nextCodeNumber}`
      : block < 5
        ? `BLOQUE ${block + 1} · CAPÍTULO ${block + 1}.1`
        : 'ANEXO 1'
  const next = manualText.indexOf(nextMarker, start + startMarker.length)
  return cleanExtractedText(
    manualText.slice(start, next < 0 ? undefined : next),
  )
}

function extractExplanation(code, expectedTitle) {
  const source = chapterSource(code)
  const traceIndex = source.indexOf('Trazabilidad con las locuciones aportadas')
  const detailed = source.slice(0, traceIndex < 0 ? undefined : traceIndex)
  const titleIndex = detailed.indexOf(expectedTitle)
  let content =
    titleIndex >= 0
      ? detailed.slice(titleIndex + expectedTitle.length)
      : detailed.replace(/^BLOQUE[^\n]+\n/, '').replace(/^[^\n]+\n/, '')

  content = content
    .replace(
      /CAPÍTULO\s+\d+\.\d+\s+·\s+APLICACIÓN OPERATIVA/g,
      'Aplicación operativa',
    )
    .replace(/IDEA CENTRAL\s+/g, '\nIdea central\n')

  for (const heading of ['Aplicación operativa', ...headings]) {
    content = content.replaceAll(heading, `\n${heading}\n`)
  }

  const recognized = new Set([
    'Idea central',
    'Aplicación operativa',
    ...headings,
  ])
  const sections = []
  let currentHeading = null
  let currentLines = []
  function flush() {
    const paragraph = currentLines.join(' ').replace(/\s+/g, ' ').trim()
    if (paragraph) {
      sections.push(
        currentHeading ? `${currentHeading}\n${paragraph}` : paragraph,
      )
    }
    currentLines = []
  }

  for (const rawLine of cleanExtractedText(content).split('\n')) {
    const line = rawLine.trim()
    if (!line) continue
    if (recognized.has(line)) {
      flush()
      currentHeading = line
    } else {
      currentLines.push(line)
    }
  }
  flush()
  return sections.join('\n\n')
}

function extractChapterTitle(code) {
  const source = chapterSource(code)
  const markerEnd = source.indexOf('\n')
  const ideaStart = source.indexOf('\nIDEA CENTRAL')
  if (markerEnd < 0 || ideaStart < 0)
    throw new Error(`No se puede extraer el título ${code}.`)
  return source
    .slice(markerEnd + 1, ideaStart)
    .replace(/\s+/g, ' ')
    .trim()
}

function extractSection(explanation, heading) {
  const start = explanation.indexOf(`${heading}\n`)
  if (start < 0) return ''
  const rest = explanation.slice(start + heading.length + 1)
  const next = rest.search(
    /\n\n(?:Idea central|Aplicación operativa|Definición y alcance|Fundamento técnico ampliado|Riesgo que debe comprenderse|Criterio de actuación|Caso razonado)\n/,
  )
  return (next < 0 ? rest : rest.slice(0, next)).trim()
}

async function loadCourseStructure() {
  if (!supabase) throw new Error('Supabase no está configurado.')
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id, course_versions(id, duration_hours)')
    .eq('slug', COURSE_SLUG)
    .single()
  if (courseError) throw courseError

  const versions = course.course_versions ?? []
  const versionIds = versions.map((version) => version.id)
  const { data: modules, error } = await supabase
    .from('course_modules')
    .select(
      'id, position, course_version_id, lessons(id, lesson_audio_segments(id, position, lesson_code, title, lesson_segment_slides(source_page)))',
    )
    .in('course_version_id', versionIds)
    .order('position')
  if (error) throw error
  return { versions, modules: modules ?? [] }
}

async function uploadManual(version) {
  if (!supabase) throw new Error('Supabase no está configurado.')
  if (skipUpload) return
  const extension = extname(manualPath).slice(1).toLowerCase()
  const storagePath = `${version.id}/materials/${MANUAL_NAME}`
  const file = readFileSync(manualPath)
  const { error: uploadError } = await supabase.storage
    .from('course-materials')
    .upload(storagePath, file, {
      contentType: 'application/pdf',
      upsert: true,
    })
  if (uploadError) throw uploadError

  const { data: existing, error: selectError } = await supabase
    .from('course_materials')
    .select('id')
    .eq('course_version_id', version.id)
    .eq('storage_path', storagePath)
    .maybeSingle()
  if (selectError) throw selectError

  const payload = {
    course_version_id: version.id,
    kind: 'manual',
    title: 'Manual maestro · Operador de perforadora / perforista',
    description: `Documento matriz de las 50 unidades · versión ${version.duration_hours} h`,
    storage_path: storagePath,
    external_url: null,
    mime_type: 'application/pdf',
    size_bytes: file.byteLength,
    downloadable: true,
    position: 1,
  }
  const query = existing
    ? supabase.from('course_materials').update(payload).eq('id', existing.id)
    : supabase.from('course_materials').insert(payload)
  const { error } = await query
  if (error) throw error
  console.log(
    `Manual asociado a la versión ${version.duration_hours} h (${extension}).`,
  )
}

async function main() {
  if (exportJson || exportJsonAscii) {
    const exported = []
    for (let block = 1; block <= 5; block += 1) {
      for (let position = 1; position <= 10; position += 1) {
        const code = `${block}.${position}`
        const title = extractChapterTitle(code)
        const explanation = extractExplanation(code, title)
        exported.push({
          code,
          title,
          summary: explanation,
          keyPoints: [extractSection(explanation, 'Idea central')].filter(
            Boolean,
          ),
          stopCriterion: extractSection(explanation, 'Criterio de actuación'),
        })
      }
    }
    const json = JSON.stringify(exported)
    process.stdout.write(
      exportJsonAscii
        ? Array.from(json, (character) => {
            const codePoint = character.codePointAt(0)
            return codePoint < 128
              ? character
              : `\\u${codePoint.toString(16).padStart(4, '0')}`
          }).join('')
        : json,
    )
    return
  }

  if (!supabase) throw new Error('Supabase no está configurado.')
  const { versions, modules } = await loadCourseStructure()
  const units = modules.flatMap((module) =>
    (module.lessons ?? []).flatMap((lesson) =>
      (lesson.lesson_audio_segments ?? []).map((segment) => ({
        ...segment,
        blockPosition: module.position,
      })),
    ),
  )
  const codes = new Set(units.map((unit) => unit.lesson_code))
  if (versions.length !== 2 || units.length !== 100 || codes.size !== 50) {
    throw new Error(
      `Estructura inesperada: ${versions.length} versiones, ${units.length} unidades y ${codes.size} códigos.`,
    )
  }

  const notes = units.map((unit) => {
    const code = unit.lesson_code
    const title = extractChapterTitle(code)
    const explanation = extractExplanation(code, title)
    const sourcePages = unit.lesson_segment_slides?.[0]?.source_page ?? ''
    return {
      title,
      code,
      segment_id: unit.id,
      summary: explanation,
      key_points: [extractSection(explanation, 'Idea central')].filter(Boolean),
      stop_criterion: extractSection(explanation, 'Criterio de actuación'),
      source_label: SOURCE_LABEL,
      source_pages: sourcePages,
      approved: true,
    }
  })

  const invalid = notes.filter(
    (note) =>
      note.summary.length < 10 ||
      note.summary.length > 20000 ||
      !note.source_pages,
  )
  if (invalid.length)
    throw new Error(`${invalid.length} explicaciones no superan la validación.`)

  console.log(
    `Validación: ${notes.length} explicaciones para ${codes.size} códigos.`,
  )
  if (dryRun) return

  for (let index = 0; index < notes.length; index += 20) {
    const updates = notes.slice(index, index + 20).map((note) =>
      supabase
        .from('lesson_audio_segments')
        .update({
          title: note.title,
          manual_chapter: `Capítulo ${note.code}`,
        })
        .eq('id', note.segment_id),
    )
    const results = await Promise.all(updates)
    const failed = results.find((result) => result.error)
    if (failed?.error) throw failed.error
  }

  for (let index = 0; index < notes.length; index += 20) {
    const noteRows = notes.slice(index, index + 20).map(
      ({ title: _title, code: _code, ...note }) => note,
    )
    const { error } = await supabase
      .from('lesson_segment_notes')
      .upsert(noteRows, { onConflict: 'segment_id' })
    if (error) throw error
  }
  for (const version of versions) await uploadManual(version)
  console.log('Importación del manual de perforadora completada.')
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error)
  process.exitCode = 1
})
