// Rellena la transcripción del audio de «Operador de perforadora / perforista».
//
// El curso tenía sus cien locuciones subidas y vinculadas, pero
// `narration_text` vacío en las dos modalidades, así que la pantalla de lección
// no ofrecía el apartado «Transcripción del audio · texto exacto».
//
// La transcripción se obtiene de los propios ficheros de audio con
// faster-whisper (véase el procedimiento usado en Administración) y se guarda
// en `content/perforadora-transcripts.json`. Este script sólo la vuelca en la
// base de datos, y antes de escribir comprueba que el fichero local del que
// salió la transcripción es byte a byte el objeto que hay en el bucket para esa
// unidad: es lo que impide colocar el texto de una modalidad en la otra.
//
// Uso: node scripts/sync-perforadora-transcripts.mjs [--dry-run]
import { createHash } from 'node:crypto'
import { readFile, readdir } from 'node:fs/promises'
import { basename, join, resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const COURSE_SLUG = 'operadores-perforacion-corte-exterior'
const BUCKET = 'course-materials'
const AUDIO_ROOT = resolve('Contenido Cursos', 'Pistas de Audio')
const MODALITIES = [
  {
    durationHours: 5,
    folder:
      'Curso 7 Operadores de perforación y corte en actividades extractivas de exterior — reciclaje de 5 horas',
  },
  {
    durationHours: 20,
    folder:
      'Curso 8 Operadores de perforación y corte en actividades extractivas de exterior — formación inicial de 20 horas',
  },
]

const dryRun = process.argv.includes('--dry-run')

const transcripts = JSON.parse(
  await readFile('content/perforadora-transcripts.json', 'utf8'),
)

const expected = []
for (let block = 1; block <= 5; block += 1) {
  for (let unit = 1; unit <= 10; unit += 1) expected.push(`${block}.${unit}`)
}

// Las cien locuciones del disco, indexadas por modalidad y código de unidad.
async function collectTracks(folder) {
  const root = join(AUDIO_ROOT, folder)
  const tracks = new Map()
  for (const entry of await readdir(root, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue
    const folderBlock = Number(entry.name.match(/bloque[-_ ]*(\d+)/i)?.[1])
    for (const file of await readdir(join(root, entry.name))) {
      if (!/\.mp3$/i.test(file)) continue
      const match = basename(file, '.mp3').match(/^parte-([1-5])\.(10|[1-9])-/)
      if (!match) throw new Error(`Nombre no interpretable: ${folder}/${file}`)
      const block = Number(match[1])
      if (block !== folderBlock) {
        throw new Error(`${file} está en «${entry.name}» y declara el bloque ${block}.`)
      }
      const code = `${block}.${Number(match[2])}`
      if (tracks.has(code)) throw new Error(`Unidad ${code} duplicada en ${folder}.`)
      tracks.set(code, join(root, entry.name, file))
    }
  }
  const missing = expected.filter((code) => !tracks.has(code))
  if (missing.length) {
    throw new Error(`Faltan locuciones en ${folder}: ${missing.join(', ')}`)
  }
  return tracks
}

for (const modality of MODALITIES) {
  const tracks = await collectTracks(modality.folder)
  const missing = expected.filter(
    (code) => !transcripts[`${modality.durationHours}h/${code}`]?.text,
  )
  if (missing.length) {
    throw new Error(
      `Faltan transcripciones de ${modality.durationHours} h: ${missing.join(', ')}`,
    )
  }
  modality.tracks = tracks
}

// Las dos modalidades tienen locución propia: si alguna unidad compartiera
// texto sería que se ha transcrito dos veces el mismo fichero.
const shared = expected.filter(
  (code) => transcripts[`5h/${code}`].text === transcripts[`20h/${code}`].text,
)
if (shared.length) {
  throw new Error(`Transcripción idéntica en las dos modalidades: ${shared.join(', ')}`)
}

if (dryRun) {
  console.table(
    expected.map((code) => ({
      code,
      reciclaje: transcripts[`5h/${code}`].text.length,
      inicial: transcripts[`20h/${code}`].text.length,
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
    'id, course_versions(id, duration_hours, course_modules(position, lessons(lesson_audio_segments(id, position, lesson_code, audio_storage_path))))',
  )
  .eq('slug', COURSE_SLUG)
  .single()
if (courseError) throw courseError

function digest(buffer) {
  return createHash('sha256').update(buffer).digest('hex')
}

for (const modality of MODALITIES) {
  const version = course.course_versions.find(
    (candidate) => candidate.duration_hours === modality.durationHours,
  )
  if (!version) throw new Error(`Falta la versión de ${modality.durationHours} h.`)

  const byCode = new Map()
  for (const module of version.course_modules) {
    for (const lesson of module.lessons) {
      for (const segment of lesson.lesson_audio_segments) {
        const code = `${module.position}.${segment.position}`
        if (segment.lesson_code !== code) {
          throw new Error(
            `La unidad ${segment.id} usa ${segment.lesson_code ?? 'ningún código'} y se esperaba ${code}.`,
          )
        }
        byCode.set(code, segment)
      }
    }
  }

  let written = 0
  for (const code of expected) {
    const segment = byCode.get(code)
    if (!segment) throw new Error(`Falta la unidad ${code} de ${modality.durationHours} h.`)

    const local = await readFile(modality.tracks.get(code))
    const { data: blob, error: downloadError } = await supabase.storage
      .from(BUCKET)
      .download(segment.audio_storage_path)
    if (downloadError) throw downloadError
    const remote = Buffer.from(await blob.arrayBuffer())
    if (digest(local) !== digest(remote)) {
      throw new Error(
        `La unidad ${code} de ${modality.durationHours} h no coincide con la locución publicada; no se escribe su transcripción.`,
      )
    }

    const { error: updateError } = await supabase
      .from('lesson_audio_segments')
      .update({
        narration_text: transcripts[`${modality.durationHours}h/${code}`].text,
      })
      .eq('id', segment.id)
    if (updateError) throw updateError
    written += 1
  }

  console.log(
    `Perforadora ${modality.durationHours} h: ${written} de 50 transcripciones escritas.`,
  )
}
