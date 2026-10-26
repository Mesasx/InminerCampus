// Da de alta la estructura y el contenido del curso sin publicarlo.
// Los objetos binarios se cargan con upload-tecnicos-exterior-course.mjs.
import { readFile } from 'node:fs/promises'
import process from 'node:process'

const manifest = JSON.parse(
  await readFile('content/tecnicos-exterior-20h/course-manifest.json', 'utf8'),
)
const dryRun = process.argv.includes('--dry-run')
if (manifest.version?.status !== 'draft') {
  throw new Error('El importador solo admite una versión en borrador.')
}

const course = {
  id: manifest.course.id,
  slug: manifest.course.slug,
  title: manifest.course.title,
  short_description:
    'Formación preventiva inicial para técnicos titulados en actividades extractivas de exterior.',
  description:
    'Curso estructurado para anticipar, supervisar y poder detener trabajos cuando no pueda demostrarse una condición segura. Integra 92 diapositivas, sus locuciones y la explicación detallada procedente del manual maestro.',
  specialty: 'ITC 02.1.02 · Grupo 5.2.a · ET 2003-1-10',
  status: 'draft',
  cover_storage_path: '/images/curso-tecnicos-exterior-portada.png',
}
const version = {
  id: manifest.version.id,
  course_id: manifest.course.id,
  version_number: 1,
  duration_hours: 20,
  modality: 'hybrid',
  objectives: [
    'Anticipar peligros y cambios antes de iniciar o reanudar',
    'Supervisar controles con criterios verificables',
    'Detener, aislar y escalar cuando no exista evidencia suficiente',
    'Coordinar equipos, contratas e interferencias',
  ],
  target_audience: [
    'Técnicos titulados que desempeñan funciones en actividades extractivas de exterior',
  ],
  requirements: [
    'Vinculación al puesto y asistencia a la impartición presencial exigida por la normativa aplicable',
  ],
  syllabus_summary:
    'Siete módulos: marco preventivo, definición de trabajos, técnicas preventivas, equipos y EPI, control del entorno, interferencias y normativa.',
  accreditation_label: 'Formación preventiva inicial de 20 horas',
  accreditation_reference: 'ITC 02.1.02 · Grupo 5.2.a · ET 2003-1-10',
  practice_required: true,
  required_perfect_streak: 3,
  video_completion_percent: 95,
  price_net: null,
  tax_rate: 21,
  currency: 'EUR',
  status: 'draft',
}

const modules = manifest.modules.map((module) => ({
  id: module.id,
  course_version_id: manifest.version.id,
  position: module.position,
  title: module.title,
  description: module.description,
}))
const lessons = manifest.lessons.map((lesson) => ({
  id: lesson.id,
  module_id: manifest.modules.find(
    (module) => module.position === lesson.module_position,
  ).id,
  position: lesson.position,
  title: lesson.title,
  summary:
    'Lección secuencial con una locución y una explicación detallada por diapositiva.',
  kind: 'mixed',
  duration_minutes: lesson.duration_minutes,
  sequential_required: true,
  active: true,
}))
const segments = manifest.units.map((unit) => ({
  id: unit.segment_id,
  lesson_id: manifest.lessons.find(
    (lesson) => lesson.ordinal === unit.lesson_ordinal,
  ).id,
  position: unit.segment_position,
  lesson_code: `${unit.lesson_ordinal}.${unit.segment_position}`,
  manual_chapter: `Bloque ${unit.block_number} · diapositiva ${String(unit.slide_number).padStart(2, '0')}`,
  title: unit.title,
  narration_text: unit.narration_text,
  audio_storage_path: unit.audio_storage_path,
  audio_external_url: null,
  duration_seconds: unit.duration_seconds,
  published: true,
}))
const slides = manifest.units.map((unit) => ({
  id: unit.slide_id,
  segment_id: unit.segment_id,
  position: 1,
  title: unit.title,
  body: `Objetivo: ${unit.key_points[0]}\n\nIdea clave: ${unit.stop_criterion}`,
  image_storage_path: unit.image_storage_path,
  image_external_url: null,
  source_label: 'Presentación InmínerCampus · Técnicos titulados de exterior',
  source_page: `Diapositiva ${unit.slide_number}`,
  alt_text: `Diapositiva ${unit.slide_number}: ${unit.title}`,
}))
const notes = manifest.units.map((unit) => ({
  id: unit.note_id,
  segment_id: unit.segment_id,
  summary: unit.explanation,
  key_points: unit.key_points,
  stop_criterion: unit.stop_criterion,
  source_label: 'Manual InmínerCampus · Técnicos titulados de exterior · edición 1.1',
  source_pages: unit.source_pages,
  approved: true,
}))
const materials = manifest.materials.map((material) => ({
  ...material,
  course_version_id: manifest.version.id,
  downloadable: true,
  is_published: false,
}))

if (dryRun) {
  console.log(
    JSON.stringify(
      {
        course: course.slug,
        status: course.status,
        versionStatus: version.status,
        modules: modules.length,
        lessons: lessons.length,
        segments: segments.length,
        slides: slides.length,
        notes: notes.length,
        materials: materials.length,
      },
      null,
      2,
    ),
  )
  process.exit(0)
}

const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}
const { createClient } = await import('@supabase/supabase-js')
const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

async function upsert(table, rows) {
  const { error } = await supabase.from(table).upsert(rows, { onConflict: 'id' })
  if (error) throw new Error(`${table}: ${error.message}`)
  console.log(`${table}: ${Array.isArray(rows) ? rows.length : 1}`)
}

await upsert('courses', course)
await upsert('course_versions', version)
await upsert('course_modules', modules)
await upsert('lessons', lessons)
await upsert('lesson_audio_segments', segments)
await upsert('lesson_segment_slides', slides)
await upsert('lesson_segment_notes', notes)
await upsert('course_materials', materials)

const { data, error } = await supabase
  .from('course_versions')
  .select(
    'id, status, course_modules(id, lessons(id, lesson_audio_segments(id, lesson_segment_slides(id), lesson_segment_notes(id))))',
  )
  .eq('id', manifest.version.id)
  .single()
if (error) throw error
const finalModules = data.course_modules ?? []
const finalLessons = finalModules.flatMap((module) => module.lessons ?? [])
const finalSegments = finalLessons.flatMap(
  (lesson) => lesson.lesson_audio_segments ?? [],
)
const finalSlides = finalSegments.flatMap(
  (segment) => segment.lesson_segment_slides ?? [],
)
const finalNotes = finalSegments.flatMap(
  (segment) => segment.lesson_segment_notes ?? [],
)
const result = {
  status: data.status,
  modules: finalModules.length,
  lessons: finalLessons.length,
  segments: finalSegments.length,
  slides: finalSlides.length,
  notes: finalNotes.length,
}
if (
  result.status !== 'draft' ||
  result.modules !== 7 ||
  result.lessons !== 10 ||
  result.segments !== 92 ||
  result.slides !== 92 ||
  result.notes !== 92
) {
  throw new Error(`Verificación incompleta: ${JSON.stringify(result)}`)
}
console.log(JSON.stringify(result, null, 2))
