import {
  mkdtemp,
  mkdir,
  readFile,
  readdir,
  rm,
} from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { basename, join, resolve } from 'node:path'
import process from 'node:process'
import { spawnSync } from 'node:child_process'
import { createClient } from '@supabase/supabase-js'

const COURSE_SLUG = 'operador-maquinaria-arranque-carga-viales'
const SOURCE_LABEL =
  'Operador de Maquinaria de Arranque, Carga y Viales · presentación 2026'
const PDF_PATH = resolve(
  'Contenido Cursos',
  'Diapositivas y documentos',
  'Curso 1 Operador de Maquinaria de Arranque, Cargas y viales',
  'Operador-de-Maquinaria-de-Arranque-Carga-y-Viales.pdf',
)
const dryRun = process.argv.includes('--dry-run')

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
  const block = Math.floor(index / 10) + 1
  const unit = (index % 10) + 1
  return `${block}.${unit}`
}

function validatePdfMap() {
  const info = run('pdfinfo', [PDF_PATH])
  const pages = Number(info.match(/^Pages:\s+(\d+)/m)?.[1])
  if (pages !== 51) {
    throw new Error(`La presentación debe tener 51 páginas y tiene ${pages}.`)
  }

  for (let index = 0; index < 50; index += 1) {
    const page = index + 2
    const expectedCode = codeForIndex(index)
    const text = run('pdftotext', [
      '-f',
      String(page),
      '-l',
      String(page),
      '-layout',
      PDF_PATH,
      '-',
    ])
    // La plantilla separa el código del título con un glifo que pdftotext no
    // sabe mapear y devuelve como carácter de reemplazo, así que se acepta
    // junto al resto de separadores en vez de dar la página por inválida.
    const headingCode = text.match(
      /\b([1-5]\.(?:10|[1-9]))\s*[·•\-–—�]/,
    )?.[1]
    if (headingCode !== expectedCode) {
      throw new Error(
        `Página ${page}: se esperaba ${expectedCode} y se encontró ${headingCode ?? 'ningún código'}.`,
      )
    }
  }
}

validatePdfMap()
if (dryRun) {
  console.log(
    `Validación correcta: ${basename(PDF_PATH)} contiene portada y 50 unidades ordenadas de 1.1 a 5.10.`,
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

async function getVersions() {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', COURSE_SLUG)
    .single()
  if (courseError) throw courseError
  const { data, error } = await supabase
    .from('course_versions')
    .select('id, duration_hours')
    .eq('course_id', course.id)
    .in('duration_hours', [5, 20])
  if (error) throw error
  if (data.length !== 2) throw new Error('No se encontraron las versiones 5 h y 20 h.')
  return data
}

async function getUnits(versionId) {
  const { data: modules, error: moduleError } = await supabase
    .from('course_modules')
    .select('id, position')
    .eq('course_version_id', versionId)
    .gte('position', 1)
    .lte('position', 5)
  if (moduleError) throw moduleError
  const moduleIds = modules.map((module) => module.id)
  const { data: lessons, error: lessonError } = await supabase
    .from('lessons')
    .select('id, module_id')
    .in('module_id', moduleIds)
  if (lessonError) throw lessonError
  const lessonIds = lessons.map((lesson) => lesson.id)
  const { data: segments, error: segmentError } = await supabase
    .from('lesson_audio_segments')
    .select(
      'id, lesson_id, position, lesson_code, title, lesson_segment_slides(id, position, image_storage_path)',
    )
    .in('lesson_id', lessonIds)
    .gte('position', 1)
    .lte('position', 10)
  if (segmentError) throw segmentError

  const moduleByLesson = new Map(
    lessons.map((lesson) => [
      lesson.id,
      modules.find((module) => module.id === lesson.module_id)?.position,
    ]),
  )
  const units = segments
    .map((segment) => {
      const block = moduleByLesson.get(segment.lesson_id)
      return { ...segment, expectedCode: `${block}.${segment.position}` }
    })
    .sort((a, b) => {
      const [aBlock, aUnit] = a.expectedCode.split('.').map(Number)
      const [bBlock, bUnit] = b.expectedCode.split('.').map(Number)
      return aBlock - bBlock || aUnit - bUnit
    })
  if (units.length !== 50) {
    throw new Error(`La versión ${versionId} tiene ${units.length} unidades; se esperaban 50.`)
  }
  for (const unit of units) {
    if (unit.lesson_code !== unit.expectedCode) {
      throw new Error(
        `La unidad ${unit.id} usa ${unit.lesson_code ?? 'ningún código'}; se esperaba ${unit.expectedCode}.`,
      )
    }
  }
  return units
}

async function registerSlide(unit, storagePath, page) {
  const slides = [...(unit.lesson_segment_slides ?? [])].sort(
    (a, b) => a.position - b.position,
  )
  const payload = {
    position: 1,
    title: unit.title,
    image_storage_path: storagePath,
    image_external_url: null,
    source_label: SOURCE_LABEL,
    source_page: String(page),
    alt_text: `Diapositiva ${unit.expectedCode}: ${unit.title}`,
  }
  if (slides[0]) {
    const { error } = await supabase
      .from('lesson_segment_slides')
      .update(payload)
      .eq('id', slides[0].id)
    if (error) throw error
  } else {
    const { error } = await supabase.from('lesson_segment_slides').insert({
      segment_id: unit.id,
      body: '',
      ...payload,
    })
    if (error) throw error
  }

  const obsoleteIds = slides.slice(1).map((slide) => slide.id)
  if (obsoleteIds.length) {
    const { error } = await supabase
      .from('lesson_segment_slides')
      .delete()
      .in('id', obsoleteIds)
    if (error) throw error
  }
}

const renderRoot = await mkdtemp(join(tmpdir(), 'inminer-arranque-'))
try {
  await mkdir(renderRoot, { recursive: true })
  run('pdftoppm', [
    '-png',
    '-r',
    '120',
    '-f',
    '2',
    '-l',
    '51',
    PDF_PATH,
    join(renderRoot, 'slide'),
  ])
  const rendered = (await readdir(renderRoot))
    .filter((name) => /^slide-\d+\.png$/.test(name))
    .sort((a, b) => Number(a.match(/\d+/)?.[0]) - Number(b.match(/\d+/)?.[0]))
  if (rendered.length !== 50) {
    throw new Error(`Se renderizaron ${rendered.length} páginas; se esperaban 50.`)
  }

  const versions = await getVersions()
  for (const version of versions) {
    const units = await getUnits(version.id)
    const pendingRegistrations = []
    for (let index = 0; index < units.length; index += 1) {
      const unit = units[index]
      const page = index + 2
      const body = await readFile(join(renderRoot, rendered[index]))
      const storagePath = `${version.id}/slides/arranque-2026/${unit.expectedCode}/slide-01.png`
      const { error } = await supabase.storage
        .from('course-materials')
        .upload(storagePath, body, {
          contentType: 'image/png',
          cacheControl: '3600',
          upsert: true,
        })
      if (error) throw error
      pendingRegistrations.push({ unit, storagePath, page })
    }

    for (const registration of pendingRegistrations) {
      await registerSlide(
        registration.unit,
        registration.storagePath,
        registration.page,
      )
    }
    console.log(
      `Arranque ${version.duration_hours} h: 50 diapositivas cargadas y vinculadas.`,
    )
  }
} finally {
  await rm(renderRoot, { recursive: true, force: true })
}

console.log('Presentación actual de arranque integrada correctamente.')
