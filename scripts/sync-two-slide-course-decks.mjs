import { spawnSync } from 'node:child_process'
import { mkdtemp, readFile, readdir, rm } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const root = resolve('Contenido Cursos', 'Diapositivas y documentos')
const decks = [
  {
    key: 'establecimientos-5h',
    slug: 'operadores-establecimientos-beneficio',
    durationHours: 5,
    pdf: resolve(
      root,
      'Diapositivas cursos',
      'Curso_3_Establecimiento_Beneficio_InminerCampus_5h.pdf',
    ),
    release: 'establecimientos-5h-2026',
    sourceLabel: 'Establecimientos de beneficio · presentación 5 h Inmíner Campus',
  },
]

const selectedKeys = new Set(
  (process.env.COURSE_TWO_SLIDE_DECKS ?? decks.map(({ key }) => key).join(','))
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
const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

function run(command, args) {
  const result = spawnSync(command, args, { encoding: 'utf8' })
  if (result.status !== 0) {
    throw new Error(`${command} falló: ${result.stderr || result.stdout || 'sin detalle'}`)
  }
  return result.stdout
}

for (const deck of selected) {
  const pages = Number(run('pdfinfo', [deck.pdf]).match(/^Pages:\s+(\d+)$/m)?.[1])
  if (pages !== 100) {
    throw new Error(`${deck.key}: se esperaban 100 páginas y se encontraron ${pages}.`)
  }
}

if (dryRun) {
  console.table(
    selected.map(({ key, slug, durationHours, pdf }) => ({
      presentación: key,
      curso: slug,
      horas: durationHours,
      diapositivas: 100,
      pdf,
    })),
  )
  process.exit(0)
}

if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL/VITE_SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY.')
}
const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

async function getVersionAndUnits(deck) {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', deck.slug)
    .single()
  if (courseError) throw courseError
  const { data: version, error: versionError } = await supabase
    .from('course_versions')
    .select('id')
    .eq('course_id', course.id)
    .eq('duration_hours', deck.durationHours)
    .single()
  if (versionError) throw versionError

  const { data: modules, error: moduleError } = await supabase
    .from('course_modules')
    .select('id, position')
    .eq('course_version_id', version.id)
    .gte('position', 1)
    .lte('position', 5)
  if (moduleError) throw moduleError
  const moduleById = new Map(modules.map(({ id, position }) => [id, position]))

  const { data: lessons, error: lessonError } = await supabase
    .from('lessons')
    .select('id, module_id')
    .in('module_id', modules.map(({ id }) => id))
  if (lessonError) throw lessonError
  const lessonById = new Map(lessons.map((lesson) => [lesson.id, lesson]))

  const { data: segments, error: segmentError } = await supabase
    .from('lesson_audio_segments')
    .select('id, lesson_id, position, lesson_code, title')
    .in('lesson_id', lessons.map(({ id }) => id))
    .gte('position', 1)
    .lte('position', 10)
  if (segmentError) throw segmentError
  const units = segments
    .map((segment) => {
      const modulePosition = moduleById.get(lessonById.get(segment.lesson_id).module_id)
      const expectedCode = `${modulePosition}.${segment.position}`
      if (segment.lesson_code !== expectedCode) {
        throw new Error(`${deck.key}: código ${segment.lesson_code}; esperado ${expectedCode}.`)
      }
      return { ...segment, expectedCode, modulePosition }
    })
    .sort((a, b) => a.modulePosition - b.modulePosition || a.position - b.position)
  if (units.length !== 50) {
    throw new Error(`${deck.key}: se encontraron ${units.length} unidades.`)
  }
  return { version, units }
}

async function uploadInBatches(items, workerCount, task) {
  let cursor = 0
  await Promise.all(
    Array.from({ length: workerCount }, async () => {
      while (cursor < items.length) {
        const index = cursor
        cursor += 1
        await task(items[index], index)
      }
    }),
  )
}

for (const deck of selected) {
  const renderRoot = await mkdtemp(join(tmpdir(), `inminer-${deck.key}-`))
  try {
    run('pdftoppm', ['-png', '-r', '120', deck.pdf, join(renderRoot, 'slide')])
    const rendered = (await readdir(renderRoot))
      .filter((name) => /^slide-\d+\.png$/.test(name))
      .sort((a, b) => Number(a.match(/\d+/)[0]) - Number(b.match(/\d+/)[0]))
    if (rendered.length !== 100) {
      throw new Error(`${deck.key}: se renderizaron ${rendered.length} diapositivas.`)
    }

    const { version, units } = await getVersionAndUnits(deck)
    const rows = []
    await uploadInBatches(rendered, 6, async (name, index) => {
      const unit = units[Math.floor(index / 2)]
      const position = (index % 2) + 1
      const storagePath = `${version.id}/slides/${deck.release}/${unit.expectedCode}/slide-${String(position).padStart(2, '0')}.png`
      const { error } = await supabase.storage
        .from('course-materials')
        .upload(storagePath, await readFile(join(renderRoot, name)), {
          contentType: 'image/png',
          cacheControl: '31536000',
          upsert: true,
        })
      if (error) throw error
      rows[index] = {
        segment_id: unit.id,
        position,
        title: position === 1 ? unit.title : `Aplicación segura · ${unit.title}`,
        body: '',
        image_storage_path: storagePath,
        image_external_url: null,
        source_label: deck.sourceLabel,
        source_page: `Diapositiva ${index + 1}`,
        alt_text: `Diapositiva ${index + 1} de la unidad ${unit.expectedCode}`,
      }
    })

    const { error: deleteError } = await supabase
      .from('lesson_segment_slides')
      .delete()
      .in('segment_id', units.map(({ id }) => id))
    if (deleteError) throw deleteError
    const { error: insertError } = await supabase
      .from('lesson_segment_slides')
      .insert(rows)
    if (insertError) throw insertError
    console.log(`${deck.key}: 100 diapositivas cargadas y vinculadas.`)
  } finally {
    await rm(renderRoot, { recursive: true, force: true })
  }
}
