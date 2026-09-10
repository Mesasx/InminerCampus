import { readFile, readdir } from 'node:fs/promises'
import { basename, join, resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

// Sube las locuciones de «Operadores en establecimientos de beneficio». El
// curso entrega dos juegos distintos bajo la misma carpeta, uno por modalidad:
// las grabaciones de 5 h y las de 20 h llevan el mismo nombre de fichero pero
// no son el mismo audio, así que cada modalidad se sube a su propia versión y
// nunca se cruzan.
//
// `import-course-audio.mjs` sube por un endpoint HTTP con su propio token; aquí
// se escribe directamente en el bucket para poder verificar unidad a unidad y
// dejar constancia de las pistas que todavía no ha entregado el estudio.

const SLUG = 'operadores-establecimientos-beneficio'
const BUCKET = 'course-materials'
const SOURCE_DIR = resolve(
  'Contenido Cursos',
  'Pistas de Audio',
  'Curso 9 Establecimiento de beneficio',
)
const MODALITIES = [
  { folder: '5 horas', durationHours: 5 },
  { folder: '20 horas', durationHours: 20 },
]

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

// Los ficheros vienen como «parte-1.10-plantas-de-construccion….mp3».
function parseName(name) {
  const match = basename(name, '.mp3').match(/^parte-([1-5])\.(10|[1-9])-/)
  if (!match) return null
  return { block: Number(match[1]), position: Number(match[2]) }
}

// Duración leída de la primera cabecera de trama, para no depender de ffprobe.
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

async function collectTracks(folder) {
  const root = join(SOURCE_DIR, folder)
  const tracks = new Map()
  for (const entry of await readdir(root, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue
    const folderBlock = Number(entry.name.match(/bloque[-_ ]*(\d+)/i)?.[1])
    for (const file of await readdir(join(root, entry.name))) {
      if (!/\.mp3$/i.test(file)) continue
      const parsed = parseName(file)
      if (!parsed) throw new Error(`Nombre no interpretable: ${folder}/${entry.name}/${file}`)
      if (parsed.block !== folderBlock) {
        throw new Error(`${file} está en «${entry.name}» y declara el bloque ${parsed.block}.`)
      }
      const code = `${parsed.block}.${parsed.position}`
      if (tracks.has(code)) throw new Error(`Unidad ${code} duplicada en ${folder}.`)
      tracks.set(code, { ...parsed, code, path: join(root, entry.name, file) })
    }
  }
  return tracks
}

async function getSegments(durationHours) {
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
    .eq('duration_hours', durationHours)
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
    .select('id, lesson_id, position')
    .in('lesson_id', lessons.map((lesson) => lesson.id))
  if (segmentError) throw segmentError

  const byCode = new Map()
  for (const segment of segments) {
    byCode.set(`${blockByLesson.get(segment.lesson_id)}.${segment.position}`, segment)
  }
  return { versionId: version.id, byCode }
}

const expected = []
for (let block = 1; block <= 5; block += 1) {
  for (let unit = 1; unit <= 10; unit += 1) expected.push(`${block}.${unit}`)
}

// El mismo nombre de fichero en las dos carpetas debe corresponder a dos
// grabaciones distintas. Si alguna coincidiera byte a byte sería una copia
// pegada por error y no una locución propia de la modalidad.
const digests = new Map()

for (const modality of MODALITIES) {
  const tracks = await collectTracks(modality.folder)
  const { versionId, byCode } = await getSegments(modality.durationHours)
  const missing = expected.filter((code) => !tracks.has(code))
  const orphan = [...tracks.keys()].filter((code) => !byCode.has(code))
  if (orphan.length) {
    throw new Error(`Sin segmento en la base (${modality.folder}): ${orphan.join(', ')}`)
  }

  if (missing.length) {
    console.warn(
      `Modalidad de ${modality.durationHours} h: faltan ${missing.length} locuciones (${missing.join(', ')}).`,
    )
  }

  let uploaded = 0
  for (const code of expected) {
    const track = tracks.get(code)
    if (!track) continue
    const buffer = await readFile(track.path)
    const digest = `${buffer.length}:${buffer.subarray(0, 4096).toString('base64')}`
    const seen = digests.get(`${code}:${digest}`)
    if (seen) {
      throw new Error(
        `La unidad ${code} es el mismo audio en ${seen} y en ${modality.folder}.`,
      )
    }
    digests.set(`${code}:${digest}`, modality.folder)

    if (dryRun) {
      uploaded += 1
      continue
    }
    const storagePath = `${versionId}/block-${track.block}/audio/part-${track.block}-${String(track.position).padStart(2, '0')}.mp3`
    const { error: uploadError } = await supabase.storage
      .from(BUCKET)
      .upload(storagePath, buffer, {
        contentType: 'audio/mpeg',
        cacheControl: '3600',
        upsert: true,
      })
    if (uploadError) throw uploadError

    // Ni el título ni la transcripción se tocan aquí: los fija el manual.
    const { error: updateError } = await supabase
      .from('lesson_audio_segments')
      .update({
        audio_storage_path: storagePath,
        audio_external_url: null,
        duration_seconds: estimateSeconds(buffer),
      })
      .eq('id', byCode.get(code).id)
    if (updateError) throw updateError
    uploaded += 1
  }

  console.log(
    `Establecimientos de beneficio ${modality.durationHours} h: ${uploaded} de 50 locuciones ${dryRun ? 'verificadas' : 'subidas y vinculadas'}.`,
  )
}
