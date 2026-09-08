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

// El código de la unidad se lee de la cabecera de la diapositiva. Unas
// plantillas lo rotulan como «BLOQUE n · PARTE/UNIDAD x.y» y otras lo abren
// como título de la propia página; en ambos casos se ancla a una posición fija
// para que una cifra suelta del cuerpo no pueda hacerse pasar por código.
const headingCodePatterns = {
  rotulo: /\b(?:PARTE|UNIDAD)\s+([1-5]\.(?:10|[1-9]))\b/i,
  titulo: /^[ \t]*([1-5]\.(?:10|[1-9]))\s*[^\w\s]/m,
}

// Presentaciones con una diapositiva por unidad. Cada curso publica un único
// PDF que sirve por igual al reciclaje y a la formación inicial, y del que se
// extraen las 50 unidades de 1.1 a 5.10.
const decks = [
  {
    key: 'arranque',
    slug: 'operador-maquinaria-arranque-carga-viales',
    release: 'arranque-2026',
    sourceLabel:
      'Operador de Maquinaria de Arranque, Carga y Viales · presentación 2026',
    pdf: resolve(
      'Contenido Cursos',
      'Diapositivas y documentos',
      'Curso 1 Operador de Maquinaria de Arranque, Cargas y viales',
      'Operador-de-Maquinaria-de-Arranque-Carga-y-Viales.pdf',
    ),
    totalPages: 51,
    // Una portada y, a continuación, las cincuenta unidades seguidas.
    pageForUnit: (index) => index + 2,
    headingCode: headingCodePatterns.rotulo,
  },
  {
    key: 'transporte',
    slug: 'operador-maquinaria-transporte-camion-volquete',
    release: 'transporte-2026',
    sourceLabel:
      'El transporte en el movimiento de tierras y los tipos de vehículos · presentación 2026',
    pdf: resolve(
      'Contenido Cursos',
      'Diapositivas y documentos',
      'Curso Transporte',
      'El-transporte-en-el-movimiento-de-tierras-y-los-tipos-de-vehiculos.pdf',
    ),
    totalPages: 55,
    // Cada bloque abre con una página divisoria antes de sus diez unidades.
    pageForUnit: (index) => index + 2 + Math.floor(index / 10),
    headingCode: headingCodePatterns.rotulo,
  },
  {
    key: 'perforadora',
    slug: 'operadores-perforacion-corte-exterior',
    release: 'perforadora-2026',
    sourceLabel:
      'Formación preventiva para el desempeño del puesto de trabajo · operador de perforadora / perforista · presentación 2026',
    pdf: resolve(
      'Contenido Cursos',
      'Formacion-Preventiva-para-el-Desempeno-del-Puesto-de-Trabajo.pdf',
    ),
    totalPages: 51,
    pageForUnit: (index) => index + 2,
    // Su plantilla no rotula la cabecera: cada unidad abre con su propio código.
    headingCode: headingCodePatterns.titulo,
  },
]

const selectedKeys = new Set(
  (process.env.COURSE_UNIT_DECKS ?? decks.map(({ key }) => key).join(','))
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean),
)
const selected = decks.filter(({ key }) => selectedKeys.has(key))
const unknown = [...selectedKeys].filter(
  (key) => !decks.some((deck) => deck.key === key),
)
if (unknown.length) throw new Error(`Presentaciones desconocidas: ${unknown.join(', ')}`)

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

function validatePdfMap(deck) {
  const info = run('pdfinfo', [deck.pdf])
  const pages = Number(info.match(/^Pages:\s+(\d+)/m)?.[1])
  if (pages !== deck.totalPages) {
    throw new Error(
      `${deck.key}: la presentación debe tener ${deck.totalPages} páginas y tiene ${pages}.`,
    )
  }

  for (let index = 0; index < 50; index += 1) {
    const page = deck.pageForUnit(index)
    const expectedCode = codeForIndex(index)
    const text = run('pdftotext', [
      '-f',
      String(page),
      '-l',
      String(page),
      '-layout',
      deck.pdf,
      '-',
    ])
    const headingCode = text.match(deck.headingCode)?.[1]
    if (headingCode !== expectedCode) {
      throw new Error(
        `${deck.key}, página ${page}: se esperaba ${expectedCode} y se encontró ${headingCode ?? 'ningún código'}.`,
      )
    }
  }
}

for (const deck of selected) {
  validatePdfMap(deck)
}
if (dryRun) {
  for (const deck of selected) {
    console.log(
      `Validación correcta: ${basename(deck.pdf)} (${deck.totalPages} páginas) contiene las 50 unidades ordenadas de 1.1 a 5.10.`,
    )
  }
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

async function getVersions(deck) {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', deck.slug)
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

async function registerSlide(deck, unit, storagePath, page) {
  const slides = [...(unit.lesson_segment_slides ?? [])].sort(
    (a, b) => a.position - b.position,
  )
  const payload = {
    position: 1,
    title: unit.title,
    image_storage_path: storagePath,
    image_external_url: null,
    source_label: deck.sourceLabel,
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

for (const deck of selected) {
  const renderRoot = await mkdtemp(join(tmpdir(), `inminer-${deck.key}-`))
  try {
    await mkdir(renderRoot, { recursive: true })
    run('pdftoppm', ['-png', '-r', '120', deck.pdf, join(renderRoot, 'slide')])
    // Se renderiza el PDF entero y cada unidad toma su página, porque las
    // divisorias de bloque rompen la correspondencia uno a uno con el orden.
    const rendered = new Map(
      (await readdir(renderRoot))
        .filter((name) => /^slide-0*\d+\.png$/.test(name))
        .map((name) => [Number(name.match(/\d+/)?.[0]), name]),
    )
    if (rendered.size !== deck.totalPages) {
      throw new Error(
        `${deck.key}: se renderizaron ${rendered.size} páginas; se esperaban ${deck.totalPages}.`,
      )
    }

    const versions = await getVersions(deck)
    for (const version of versions) {
      const units = await getUnits(version.id)
      const pendingRegistrations = []
      for (let index = 0; index < units.length; index += 1) {
        const unit = units[index]
        const page = deck.pageForUnit(index)
        const name = rendered.get(page)
        if (!name) throw new Error(`${deck.key}: falta la página ${page} renderizada.`)
        const body = await readFile(join(renderRoot, name))
        const storagePath = `${version.id}/slides/${deck.release}/${unit.expectedCode}/slide-01.png`
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
          deck,
          registration.unit,
          registration.storagePath,
          registration.page,
        )
      }
      console.log(
        `${deck.key} ${version.duration_hours} h: 50 diapositivas cargadas y vinculadas.`,
      )
    }
  } finally {
    await rm(renderRoot, { recursive: true, force: true })
  }
}

console.log(
  `Presentaciones integradas correctamente: ${selected.map(({ key }) => key).join(', ')}.`,
)
