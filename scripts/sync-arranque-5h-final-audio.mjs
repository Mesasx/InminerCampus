import { readFile, readdir } from 'node:fs/promises'
import { basename, join, resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

// Sube al reciclaje de 5 h de arranque su juego definitivo de locuciones. La
// carpeta anterior, «Curso 1 …», mezclaba dos temarios: su bloque 1 seguía otra
// secuencia y las partes 2.1 y 2.2 pertenecían al curso de transporte. El juego
// nuevo cubre las cincuenta unidades 1.1 a 5.10 del manual maestro.
//
// `import-course-audio.mjs` sube por un endpoint HTTP con su propio token; aquí
// se escribe directamente en el bucket porque es una sustitución puntual y
// completa, verificable contra los códigos de unidad.

const SLUG = 'operador-maquinaria-arranque-carga-viales'
const DURATION_HOURS = 5
const BUCKET = 'course-materials'
const SOURCE_DIR = resolve(
  'Contenido Cursos',
  'Pistas de Audio',
  'Operador maquinaria de Arranque cargas y viales 5 horas mod',
)

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

// Los ficheros vienen como «1.10_El_ciclo_de_trabajo_como_sistema_preventivo.mp3».
function parseName(name) {
  const match = basename(name, '.mp3').match(/^([1-5])\.(10|[1-9])_(.+)$/)
  if (!match) return null
  return { block: Number(match[1]), position: Number(match[2]) }
}

// Duración estimada leyendo la primera cabecera de trama, igual que hace
// `import-course-audio.mjs`, para no depender de ffprobe.
function estimateSeconds(buffer) {
  let offset = 0
  if (buffer.length >= 10 && buffer.toString('ascii', 0, 3) === 'ID3') {
    offset =
      10 +
      ((buffer[6] & 0x7f) << 21) +
      ((buffer[7] & 0x7f) << 14) +
      ((buffer[8] & 0x7f) << 7) +
      (buffer[9] & 0x7f)
  }
  const mpeg1Layer3 = [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320]
  const mpeg2Layer3 = [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160]
  for (let index = offset; index < Math.min(buffer.length - 4, offset + 65536); index += 1) {
    if (buffer[index] !== 0xff || (buffer[index + 1] & 0xe0) !== 0xe0) continue
    const version = (buffer[index + 1] >> 3) & 0x03
    const layer = (buffer[index + 1] >> 1) & 0x03
    const bitrateIndex = (buffer[index + 2] >> 4) & 0x0f
    if (version === 1 || layer !== 1 || bitrateIndex === 0 || bitrateIndex === 15) continue
    const bitrate = (version === 3 ? mpeg1Layer3 : mpeg2Layer3)[bitrateIndex] * 1000
    if (!bitrate) continue
    return Math.max(1, Math.round(((buffer.length - offset) * 8) / bitrate))
  }
  return null
}

async function collectTracks() {
  const tracks = new Map()
  for (const entry of await readdir(SOURCE_DIR, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue
    const folderBlock = Number(entry.name.match(/bloque[-_ ]*(\d+)/i)?.[1])
    for (const file of await readdir(join(SOURCE_DIR, entry.name))) {
      if (!/\.mp3$/i.test(file)) continue
      const parsed = parseName(file)
      if (!parsed) throw new Error(`Nombre no interpretable: ${entry.name}/${file}`)
      if (parsed.block !== folderBlock) {
        throw new Error(`${file} está en «${entry.name}» y declara el bloque ${parsed.block}.`)
      }
      const code = `${parsed.block}.${parsed.position}`
      if (tracks.has(code)) throw new Error(`Unidad ${code} duplicada.`)
      tracks.set(code, { ...parsed, code, path: join(SOURCE_DIR, entry.name, file) })
    }
  }
  const expected = []
  for (let block = 1; block <= 5; block += 1) {
    for (let unit = 1; unit <= 10; unit += 1) expected.push(`${block}.${unit}`)
  }
  const missing = expected.filter((code) => !tracks.has(code))
  if (missing.length) throw new Error(`Faltan locuciones: ${missing.join(', ')}`)
  if (tracks.size !== 50) throw new Error(`Se encontraron ${tracks.size} pistas; se esperaban 50.`)
  return expected.map((code) => tracks.get(code))
}

async function getSegments() {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', SLUG)
    .single()
  if (courseError) throw courseError
  const { data: version, error: versionError } = await supabase
    .from('course_versions')
    .select('id')
    .eq('course_id', course.id)
    .eq('duration_hours', DURATION_HOURS)
    .single()
  if (versionError) throw versionError

  const { data: modules, error: moduleError } = await supabase
    .from('course_modules')
    .select('id, position')
    .eq('course_version_id', version.id)
    .gte('position', 1)
    .lte('position', 5)
  if (moduleError) throw moduleError
  const { data: lessons, error: lessonError } = await supabase
    .from('lessons')
    .select('id, module_id')
    .in('module_id', modules.map((module) => module.id))
  if (lessonError) throw lessonError
  const blockByLesson = new Map(
    lessons.map((lesson) => [
      lesson.id,
      modules.find((module) => module.id === lesson.module_id)?.position,
    ]),
  )
  const { data: segments, error: segmentError } = await supabase
    .from('lesson_audio_segments')
    .select('id, lesson_id, position, lesson_code')
    .in('lesson_id', lessons.map((lesson) => lesson.id))
  if (segmentError) throw segmentError

  const byCode = new Map()
  for (const segment of segments) {
    const code = `${blockByLesson.get(segment.lesson_id)}.${segment.position}`
    if (segment.lesson_code && segment.lesson_code !== code) {
      throw new Error(`El segmento ${segment.id} declara ${segment.lesson_code} y ocupa ${code}.`)
    }
    byCode.set(code, segment)
  }
  return { versionId: version.id, byCode }
}

const tracks = await collectTracks()
const { versionId, byCode } = await getSegments()
const missing = tracks.filter((track) => !byCode.has(track.code))
if (missing.length) {
  throw new Error(`Sin segmento en la base: ${missing.map((track) => track.code).join(', ')}`)
}

if (dryRun) {
  console.log(`Validación correcta: 50 locuciones de 1.1 a 5.10 con segmento en la modalidad de ${DURATION_HOURS} h.`)
  process.exit(0)
}

let uploaded = 0
for (const track of tracks) {
  const buffer = await readFile(track.path)
  const storagePath = `${versionId}/block-${track.block}/audio/part-${track.block}-${String(track.position).padStart(2, '0')}.mp3`
  const { error: uploadError } = await supabase.storage
    .from(BUCKET)
    .upload(storagePath, buffer, {
      contentType: 'audio/mpeg',
      cacheControl: '3600',
      upsert: true,
    })
  if (uploadError) throw uploadError

  // El título no se toca aquí: lo fija la migración con la redacción del manual
  // maestro, que conserva la puntuación que el nombre de fichero pierde.
  const { error: updateError } = await supabase
    .from('lesson_audio_segments')
    .update({
      audio_storage_path: storagePath,
      audio_external_url: null,
      duration_seconds: estimateSeconds(buffer),
    })
    .eq('id', byCode.get(track.code).id)
  if (updateError) throw updateError
  uploaded += 1
}

console.log(`Arranque ${DURATION_HOURS} h: ${uploaded} locuciones definitivas subidas y vinculadas.`)
