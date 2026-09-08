import { execFileSync } from 'node:child_process'
import { existsSync } from 'node:fs'
import { resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const COURSE_SLUG = 'operadores-establecimientos-beneficio'
const MANUAL_NAME = 'Manual_Establecimientos_Beneficio_Inminer_Campus (2).pdf'
const manualPath = resolve(
  'Contenido Cursos',
  'Diapositivas y documentos',
  MANUAL_NAME,
)
const dryRun = process.argv.includes('--dry-run')
const exportJson = process.argv.includes('--export-json')

if (!existsSync(manualPath)) {
  throw new Error(`No se encuentra el manual: ${manualPath}`)
}

const manualText = execFileSync(
  'pdftotext',
  ['-layout', '-enc', 'UTF-8', manualPath, '-'],
  { encoding: 'utf8', maxBuffer: 24 * 1024 * 1024 },
)

function cleanLines(lines) {
  return lines
    .filter(
      (line) =>
        !/^MANUAL MAESTRO · ESTABLECIMIENTOS DE BENEFICIO\s*$/.test(
          line.trim(),
        ) &&
        !/^INMÍNER CAMPUS · FORMACIÓN PREVENTIVA ITC 02\.1\.02\s+PÁGINA \d+\s*$/.test(
          line.trim(),
        ),
    )
    .map((line) => line.replace(/[ \t]+$/g, ''))
}

function paragraphs(lines) {
  const result = []
  let current = []
  const flush = () => {
    const text = current
      .map((line) => line.trim())
      .join(' ')
      .replace(/\s+/g, ' ')
      .trim()
    if (text) result.push(text)
    current = []
  }
  for (const line of cleanLines(lines)) {
    if (!line.trim()) flush()
    else current.push(line)
  }
  flush()
  return result.join('\n\n')
}

function chapterSlice(code) {
  const block = Number(code.split('.')[0])
  const marker = `BLOQUE ${block} · UNIDAD ${code}`
  const start = manualText.indexOf(marker)
  if (start < 0) throw new Error(`No se encuentra ${marker}.`)
  const unit = Number(code.split('.')[1])
  const nextMarker =
    unit < 10
      ? `BLOQUE ${block} · UNIDAD ${block}.${unit + 1}`
      : block < 5
        ? `BLOQUE ${block + 1} · UNIDAD ${block + 1}.1`
        : 'Glosario operativo'
  const end = manualText.indexOf(nextMarker, start + marker.length)
  return manualText.slice(start, end < 0 ? undefined : end)
}

function extractNarration(lines, marker, mode) {
  const markerIndex = lines.findIndex((line) => line.trim() === marker)
  if (markerIndex < 0) throw new Error(`Falta ${marker}.`)
  const narration = []
  for (const line of lines.slice(markerIndex + 1)) {
    const trimmed = line.trim()
    if (!trimmed) continue
    if (mode === 'long' && !line.startsWith('  ')) break
    if (mode === 'short' && trimmed === 'CRITERIO PREVENTIVO ESENCIAL') break
    narration.push(trimmed)
  }
  return narration.join(' ').replace(/\s+/g, ' ').trim()
}

function parseChapter(code) {
  const source = chapterSlice(code)
  const lines = source.replace(/\f/g, '\n').split(/\r?\n/)
  const titleIndex = lines.findIndex((line) =>
    line.trim().startsWith(`${code} `),
  )
  const metadataIndex = lines.findIndex(
    (line, index) => index > titleIndex && line.trim().startsWith('DIAPOSITIVA '),
  )
  if (titleIndex < 0 || metadataIndex < 0) {
    throw new Error(`No se puede extraer el título ${code}.`)
  }
  const title = lines
    .slice(titleIndex, metadataIndex)
    .map((line) => line.trim())
    .join(' ')
    .replace(new RegExp(`^${code.replace('.', '\\.')}\\s+`), '')
    .replace(/\s+/g, ' ')
    .trim()
  const longMarker = 'LOCUCIÓN PRINCIPAL · FORMACIÓN INICIAL 20 H'
  const shortMarker = 'LOCUCIÓN ALTERNATIVA · RECICLAJE 5 H'
  const longIndex = lines.findIndex((line) => line.trim() === longMarker)
  const shortIndex = lines.findIndex((line) => line.trim() === shortMarker)
  const criterionIndex = lines.findIndex(
    (line, index) =>
      index > shortIndex && line.trim() === 'CRITERIO PREVENTIVO ESENCIAL',
  )
  const sourcesIndex = lines.findIndex(
    (line, index) =>
      index > criterionIndex && line.trim() === 'FUENTES ESPECÍFICAS DEL CAPÍTULO',
  )
  if ([longIndex, shortIndex, criterionIndex, sourcesIndex].some((i) => i < 0)) {
    throw new Error(`Estructura editorial incompleta en ${code}.`)
  }

  let bodyStart = longIndex + 1
  while (bodyStart < shortIndex) {
    const line = lines[bodyStart]
    if (line.trim() && !line.startsWith('  ')) break
    bodyStart += 1
  }
  const body = paragraphs(lines.slice(bodyStart, shortIndex))
  const criterion = paragraphs(lines.slice(criterionIndex + 1, sourcesIndex))
  const sources = paragraphs(lines.slice(sourcesIndex + 1))
  const pageNumbers = [
    ...source.matchAll(/PÁGINA\s+(\d+)/g),
  ].map((match) => Number(match[1]))
  const pages = [...new Set(pageNumbers)].sort((a, b) => a - b)

  return {
    code,
    title,
    transcript20h: extractNarration(lines, longMarker, 'long'),
    transcript5h: extractNarration(lines, shortMarker, 'short'),
    explanation: [
      body,
      `Criterio de actuación\n${criterion}`,
      `Referencias o fuentes del capítulo\n${sources}`,
    ]
      .filter(Boolean)
      .join('\n\n'),
    criterion,
    sourcePages: pages.length ? pages.join('–') : `Capítulo ${code}`,
  }
}

const chapters = []
for (let block = 1; block <= 5; block += 1) {
  for (let unit = 1; unit <= 10; unit += 1) {
    chapters.push(parseChapter(`${block}.${unit}`))
  }
}

if (exportJson) {
  process.stdout.write(JSON.stringify(chapters))
  process.exit(0)
}

if (dryRun) {
  console.table(
    chapters.map((chapter) => ({
      code: chapter.code,
      title: chapter.title,
      transcript5h: chapter.transcript5h.length,
      transcript20h: chapter.transcript20h.length,
      explanation: chapter.explanation.length,
      pages: chapter.sourcePages,
    })),
  )
  process.exit(0)
}

const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}
const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

const { data: course, error: courseError } = await supabase
  .from('courses')
  .select(
    'id, course_versions(id, duration_hours, course_modules(id, position, lessons(id, lesson_audio_segments(id, position, lesson_code, title))))',
  )
  .eq('slug', COURSE_SLUG)
  .single()
if (courseError) throw courseError

const versions = course.course_versions ?? []
const units = versions.flatMap((version) =>
  (version.course_modules ?? []).flatMap((module) =>
    (module.lessons ?? []).flatMap((lesson) =>
      (lesson.lesson_audio_segments ?? []).map((segment) => ({
        ...segment,
        durationHours: version.duration_hours,
        expectedCode: `${module.position}.${segment.position}`,
      })),
    ),
  ),
)
if (versions.length !== 2 || units.length !== 100) {
  throw new Error(
    `Estructura inesperada: ${versions.length} versiones y ${units.length} unidades.`,
  )
}

for (const unit of units) {
  if (unit.lesson_code !== unit.expectedCode) {
    throw new Error(
      `Código inesperado en ${unit.id}: ${unit.lesson_code} (esperado ${unit.expectedCode}).`,
    )
  }
  const chapter = chapters.find((item) => item.code === unit.lesson_code)
  if (!chapter) throw new Error(`Falta el capítulo ${unit.lesson_code}.`)
  const { error: segmentError } = await supabase
    .from('lesson_audio_segments')
    .update({
      title: chapter.title,
      narration_text:
        unit.durationHours === 20
          ? chapter.transcript20h
          : chapter.transcript5h,
      manual_chapter: `Capítulo ${chapter.code}`,
    })
    .eq('id', unit.id)
  if (segmentError) throw segmentError

  const { error: noteError } = await supabase.from('lesson_segment_notes').upsert(
    {
      segment_id: unit.id,
      summary: chapter.explanation,
      key_points: chapter.criterion ? [chapter.criterion] : [],
      stop_criterion: chapter.criterion,
      source_label: MANUAL_NAME,
      source_pages: chapter.sourcePages,
      approved: true,
    },
    { onConflict: 'segment_id' },
  )
  if (noteError) throw noteError
}

console.log('Contenido maestro de establecimientos de beneficio importado.')
