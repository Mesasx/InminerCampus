import { readFile, stat } from 'node:fs/promises'
import { resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const root = resolve('Contenido Cursos', 'Diapositivas y documentos')
const packages = [
  {
    key: 'arranque-5h',
    directory: resolve(
      root,
      'Curso 1 Operador de Maquinaria de Arranque, Cargas y viales',
    ),
    manifest: 'course-1-complete.manifest.json',
    release: 'arranque-5h-2026',
    sourceLabel: 'Curso 1 · presentación actualizada Inmíner Campus',
  },
  {
    key: 'transporte-5h',
    directory: resolve(root, 'Curso 2'),
    manifest: 'course-2-complete.manifest.json',
    release: 'transporte-5h-2026',
    sourceLabel: 'Curso 2 · presentación actualizada Inmíner Campus',
  },
]

const selectedKeys = new Set(
  (process.env.COURSE_SLIDE_PACKAGES ?? packages.map(({ key }) => key).join(','))
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean),
)
const selected = packages.filter(({ key }) => selectedKeys.has(key))
const unknown = [...selectedKeys].filter(
  (key) => !packages.some((item) => item.key === key),
)
if (unknown.length) throw new Error(`Paquetes desconocidos: ${unknown.join(', ')}`)

const dryRun = process.argv.includes('--dry-run')
const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

function localSlidePath(packageConfig, entry, slide) {
  const unit = String(entry.position).padStart(2, '0')
  return resolve(
    packageConfig.directory,
    'slides',
    `block-${entry.block}`,
    `audio-${entry.block}-${unit}`,
    `audio-${entry.block}-${unit}-slide-${String(slide.position).padStart(2, '0')}.png`,
  )
}

async function loadPackage(packageConfig) {
  const manifest = JSON.parse(
    await readFile(resolve(packageConfig.directory, packageConfig.manifest), 'utf8'),
  )
  const slides = manifest.audios.flatMap((entry) =>
    entry.slides.map((slide) => ({
      entry,
      slide,
      localPath: localSlidePath(packageConfig, entry, slide),
    })),
  )
  if (
    manifest.durationHours !== 5 ||
    manifest.audios.length !== 50 ||
    slides.length !== 100
  ) {
    throw new Error(
      `${packageConfig.key}: se esperaban 50 unidades y 100 diapositivas para 5 h.`,
    )
  }
  for (const item of slides) {
    const file = await stat(item.localPath)
    if (!file.isFile() || file.size === 0) {
      throw new Error(`${packageConfig.key}: archivo inválido ${item.localPath}`)
    }
  }
  return { manifest, slides }
}

const loaded = []
for (const packageConfig of selected) {
  loaded.push({ packageConfig, ...(await loadPackage(packageConfig)) })
}

if (dryRun) {
  console.table(
    loaded.map(({ packageConfig, manifest, slides }) => ({
      paquete: packageConfig.key,
      curso: manifest.courseSlug,
      horas: manifest.durationHours,
      unidades: manifest.audios.length,
      diapositivas: slides.length,
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

async function getVersionAndUnits(manifest) {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', manifest.courseSlug)
    .single()
  if (courseError) throw courseError

  const { data: version, error: versionError } = await supabase
    .from('course_versions')
    .select('id')
    .eq('course_id', course.id)
    .eq('duration_hours', manifest.durationHours)
    .single()
  if (versionError) throw versionError

  const { data: modules, error: moduleError } = await supabase
    .from('course_modules')
    .select('id, position')
    .eq('course_version_id', version.id)
    .gte('position', 1)
    .lte('position', 5)
  if (moduleError) throw moduleError
  const moduleById = new Map(modules.map((module) => [module.id, module.position]))

  const { data: lessons, error: lessonError } = await supabase
    .from('lessons')
    .select('id, module_id')
    .in('module_id', modules.map(({ id }) => id))
  if (lessonError) throw lessonError
  const lessonById = new Map(lessons.map((lesson) => [lesson.id, lesson]))

  const { data: segments, error: segmentError } = await supabase
    .from('lesson_audio_segments')
    .select('id, lesson_id, position, lesson_code')
    .in('lesson_id', lessons.map(({ id }) => id))
    .gte('position', 1)
    .lte('position', 10)
  if (segmentError) throw segmentError

  const units = new Map(
    segments.map((segment) => {
      const lesson = lessonById.get(segment.lesson_id)
      const code = `${moduleById.get(lesson.module_id)}.${segment.position}`
      if (segment.lesson_code !== code) {
        throw new Error(
          `${manifest.courseSlug}: ${segment.lesson_code ?? 'sin código'}; esperado ${code}.`,
        )
      }
      return [code, segment]
    }),
  )
  if (units.size !== 50) {
    throw new Error(`${manifest.courseSlug}: se encontraron ${units.size} unidades.`)
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

// El manifiesto propone prefijos propios («course-1/5h/…», «course-2/5h/…»),
// pero la política de lectura del bucket solo abre el prefijo `<course_version_id>/`
// —salvo la excepción heredada de `course-1/5h`—. Guardamos las diapositivas bajo
// esa convención para que el alumno matriculado pueda leerlas sin tocar la RLS.
function storagePathFor(versionId, packageConfig, entry, slide) {
  return `${versionId}/slides/${packageConfig.release}/${entry.part}/slide-${String(
    slide.position,
  ).padStart(2, '0')}.png`
}

for (const { packageConfig, manifest, slides } of loaded) {
  const { version, units } = await getVersionAndUnits(manifest)

  await uploadInBatches(slides, 6, async ({ entry, slide, localPath }) => {
    const body = await readFile(localPath)
    const { error } = await supabase.storage
      .from('course-materials')
      .upload(storagePathFor(version.id, packageConfig, entry, slide), body, {
        contentType: 'image/png',
        cacheControl: '31536000',
        upsert: true,
      })
    if (error) throw error
  })

  const segmentIds = [...units.values()].map(({ id }) => id)
  const { error: deleteError } = await supabase
    .from('lesson_segment_slides')
    .delete()
    .in('segment_id', segmentIds)
  if (deleteError) throw deleteError

  const slideRows = slides.map(({ entry, slide }) => ({
    segment_id: units.get(entry.part).id,
    position: slide.position,
    title: slide.title,
    body: slide.body ?? '',
    image_storage_path: storagePathFor(version.id, packageConfig, entry, slide),
    image_external_url: null,
    source_label: slide.sourceLabel ?? packageConfig.sourceLabel,
    source_page: slide.sourcePage ?? `Diapositiva ${slide.deckSlide}`,
    alt_text: slide.altText ?? `Diapositiva ${entry.part}: ${entry.title}`,
  }))
  const { error: insertError } = await supabase
    .from('lesson_segment_slides')
    .insert(slideRows)
  if (insertError) throw insertError

  for (const entry of manifest.audios) {
    const segment = units.get(entry.part)
    const { error: segmentError } = await supabase
      .from('lesson_audio_segments')
      .update({ title: entry.title, narration_text: entry.narration })
      .eq('id', segment.id)
    if (segmentError) throw segmentError

    const { error: noteError } = await supabase.from('lesson_segment_notes').upsert(
      {
        segment_id: segment.id,
        summary: entry.explanation,
        key_points: entry.keyPoints ?? [],
        stop_criterion: entry.stopCriterion ?? null,
        source_label: entry.source ?? packageConfig.sourceLabel,
        source_pages: entry.pdfPages ?? entry.sourcePage ?? null,
        approved: true,
      },
      { onConflict: 'segment_id' },
    )
    if (noteError) throw noteError
  }

  console.log(
    `${packageConfig.key}: 50 explicaciones y 100 diapositivas cargadas y vinculadas.`,
  )
}
