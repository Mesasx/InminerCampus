import { mkdtemp, readFile, readdir, rm, writeFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import process from 'node:process'
import { spawnSync } from 'node:child_process'
import { createClient } from '@supabase/supabase-js'

// La modalidad de 20 h de transporte tiene su propia presentación, con dos
// páginas por unidad: la impar desarrolla el contenido técnico y la par es la
// aplicación visual. `upload-course-unit-decks.mjs` sólo conoce presentaciones
// de una página por unidad, y durante un tiempo aplicó a esta versión el deck
// de reciclaje de 5 h. Este script devuelve cada unidad a su propia página.

const SLUG = 'operador-maquinaria-transporte-camion-volquete'
const DURATION_HOURS = 20
const RELEASE = 'transporte-20h-2026'
const DECK_NAME = 'resources/transport-20h-presentacion-completa.pdf'
const SOURCE_LABEL = 'Presentación completa · Transporte · Formación inicial 20 h'
const TOTAL_PAGES = 100
const BUCKET = 'course-materials'

// La unidad n (1 a 50) ocupa las páginas 2n-1 y 2n; la diapositiva del curso es
// la de contenido técnico.
const pageForUnit = (index) => 2 * (index + 1) - 1

const dryRun = process.argv.includes('--dry-run')

const supabaseUrl = process.env.SUPABASE_URL
const serviceRoleKey =
  process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_UPLOAD_KEY
if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

function run(command, args) {
  const result = spawnSync(command, args, { encoding: 'utf8' })
  if (result.status !== 0) {
    throw new Error(
      `${command} falló: ${result.stderr || result.stdout || 'sin detalle'}`,
    )
  }
  return result.stdout
}

function codeForIndex(index) {
  return `${Math.floor(index / 10) + 1}.${(index % 10) + 1}`
}

async function getVersionId() {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', SLUG)
    .single()
  if (courseError) throw courseError
  const { data, error } = await supabase
    .from('course_versions')
    .select('id')
    .eq('course_id', course.id)
    .eq('duration_hours', DURATION_HOURS)
    .single()
  if (error) throw error
  return data.id
}

async function getUnits(versionId) {
  const { data: modules, error: moduleError } = await supabase
    .from('course_modules')
    .select('id, position')
    .eq('course_version_id', versionId)
    .gte('position', 1)
    .lte('position', 5)
  if (moduleError) throw moduleError
  const { data: lessons, error: lessonError } = await supabase
    .from('lessons')
    .select('id, module_id')
    .in(
      'module_id',
      modules.map((module) => module.id),
    )
  if (lessonError) throw lessonError
  const blockByLesson = new Map(
    lessons.map((lesson) => [
      lesson.id,
      modules.find((module) => module.id === lesson.module_id)?.position,
    ]),
  )
  const { data: segments, error: segmentError } = await supabase
    .from('lesson_audio_segments')
    .select('id, lesson_id, position, title, lesson_segment_slides(id, position)')
    .in(
      'lesson_id',
      lessons.map((lesson) => lesson.id),
    )
    .gte('position', 1)
    .lte('position', 10)
  if (segmentError) throw segmentError

  const units = segments
    .map((segment) => ({
      ...segment,
      code: `${blockByLesson.get(segment.lesson_id)}.${segment.position}`,
    }))
    .sort((left, right) => {
      const [leftBlock, leftUnit] = left.code.split('.').map(Number)
      const [rightBlock, rightUnit] = right.code.split('.').map(Number)
      return leftBlock - rightBlock || leftUnit - rightUnit
    })
  if (units.length !== 50) {
    throw new Error(`La modalidad de 20 h tiene ${units.length} unidades; se esperaban 50.`)
  }
  units.forEach((unit, index) => {
    if (unit.code !== codeForIndex(index)) {
      throw new Error(`Unidad ${index + 1}: se esperaba ${codeForIndex(index)} y es ${unit.code}.`)
    }
  })
  return units
}

async function downloadDeck(versionId, target) {
  const path = `${versionId}/${DECK_NAME}`
  const { data, error } = await supabase.storage.from(BUCKET).download(path)
  if (error) throw new Error(`No se pudo descargar ${path}: ${error.message}`)
  await writeFile(target, Buffer.from(await data.arrayBuffer()))
}

function validateDeck(pdfPath) {
  const pages = Number(run('pdfinfo', [pdfPath]).match(/^Pages:\s+(\d+)/m)?.[1])
  if (pages !== TOTAL_PAGES) {
    throw new Error(`La presentación debe tener ${TOTAL_PAGES} páginas y tiene ${pages}.`)
  }
  // El pie de cada página impar rotula «Parte x.y · Contenido técnico»: si el
  // deck cambiara de orden, la validación cae antes de subir nada.
  for (let index = 0; index < 50; index += 1) {
    const page = pageForUnit(index)
    // `-enc UTF-8` es imprescindible: por defecto pdftotext emite Latin-1 y el
    // punto medio del pie llega como carácter de reemplazo.
    const text = run('pdftotext', [
      '-enc',
      'UTF-8',
      '-f',
      String(page),
      '-l',
      String(page),
      '-layout',
      pdfPath,
      '-',
    ])
    const code = text.match(/Parte\s+([1-5]\.(?:10|[1-9]))\s*·\s*Contenido/i)?.[1]
    if (code !== codeForIndex(index)) {
      throw new Error(
        `Página ${page}: se esperaba la unidad ${codeForIndex(index)} y se encontró ${code ?? 'ninguna'}.`,
      )
    }
  }
}

const versionId = await getVersionId()
const workdir = await mkdtemp(join(tmpdir(), 'inminer-transporte-20h-'))
try {
  const pdfPath = join(workdir, 'presentacion.pdf')
  await downloadDeck(versionId, pdfPath)
  validateDeck(pdfPath)
  if (dryRun) {
    console.log(
      `Validación correcta: la presentación de 20 h tiene ${TOTAL_PAGES} páginas y sus 50 unidades están ordenadas de 1.1 a 5.10.`,
    )
    process.exit(0)
  }

  const units = await getUnits(versionId)
  run('pdftoppm', ['-png', '-r', '120', pdfPath, join(workdir, 'slide')])
  const rendered = new Map(
    (await readdir(workdir))
      .filter((name) => /^slide-0*\d+\.png$/.test(name))
      .map((name) => [Number(name.match(/\d+/)?.[0]), name]),
  )
  if (rendered.size !== TOTAL_PAGES) {
    throw new Error(`Se renderizaron ${rendered.size} páginas; se esperaban ${TOTAL_PAGES}.`)
  }

  for (let index = 0; index < units.length; index += 1) {
    const unit = units[index]
    const page = pageForUnit(index)
    const name = rendered.get(page)
    if (!name) throw new Error(`Falta la página ${page} renderizada.`)
    const storagePath = `${versionId}/slides/${RELEASE}/${unit.code}/slide-01.png`
    const { error: uploadError } = await supabase.storage
      .from(BUCKET)
      .upload(storagePath, await readFile(join(workdir, name)), {
        contentType: 'image/png',
        cacheControl: '3600',
        upsert: true,
      })
    if (uploadError) throw uploadError

    const slides = [...(unit.lesson_segment_slides ?? [])].sort(
      (left, right) => left.position - right.position,
    )
    if (!slides[0]) throw new Error(`La unidad ${unit.code} no tiene diapositiva registrada.`)
    const { error: updateError } = await supabase
      .from('lesson_segment_slides')
      .update({
        image_storage_path: storagePath,
        image_external_url: null,
        source_label: SOURCE_LABEL,
        source_page: String(page),
        alt_text: `Diapositiva ${unit.code}: ${unit.title}`,
      })
      .eq('id', slides[0].id)
    if (updateError) throw updateError
  }

  console.log('Transporte 20 h: 50 diapositivas renderizadas desde su propia presentación y vinculadas.')
} finally {
  await rm(workdir, { recursive: true, force: true })
}
