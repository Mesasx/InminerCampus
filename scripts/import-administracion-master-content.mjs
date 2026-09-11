// Carga el contenido del curso «Administración y personal de servicios
// distintos a los de mantenimiento» (ITC 02.1.02 · ET 2004-1-10 · Grupo 5.5.d).
//
// Para cada una de las cincuenta unidades y en cada una de las dos modalidades:
//   · sube la diapositiva renderizada de la presentación oficial;
//   · sube la locución de esa modalidad y la vincula a la unidad;
//   · guarda la transcripción del audio en `narration_text`;
//   · guarda la explicación detallada del manual en `lesson_segment_notes`.
//
// Las dos modalidades comparten diapositiva, pero no fichero: el bucket
// `course-materials` autoriza la lectura por el prefijo de `course_version_id`
// (política `course_materials_enrolled_read`), así que cada versión necesita su
// propia copia bajo su prefijo. Es lo mismo que hacen el resto de cursos con
// dos modalidades y evita tener que abrir una excepción en la política.
//
// Entradas:
//   content/administracion-units.json      · scripts/extract-administracion-master-manual.py
//   content/administracion-transcripts.json · transcripción de las cien locuciones
//
// Uso: node scripts/import-administracion-master-content.mjs [--dry-run]
import { execFileSync } from 'node:child_process'
import { mkdtemp, readFile, readdir, rm } from 'node:fs/promises'
import { existsSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { basename, join, resolve } from 'node:path'
import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const COURSE_SLUG = 'administracion-personal-servicios-no-mantenimiento'
const BUCKET = 'course-materials'
const DECK_RELEASE = 'administracion-2026'
const SLIDES_PDF = resolve(
  'Contenido Cursos',
  'Diapositivas y documentos',
  'Curso Administracion',
  'Presntacion',
  '1-Introduccion-a-la-formacion-preventiva-minera.pdf',
)
const MANUAL_PDF = resolve(
  'Contenido Cursos',
  'Diapositivas y documentos',
  'Curso Administracion',
  'Manual y explicaciones detalladas',
  'test_new_manual.pdf',
)
const SOURCE_LABEL =
  'Administración y personal de servicios distintos a los de mantenimiento · presentación 2026'
const MANUAL_LABEL =
  'Manual formativo ITC 02.1.02 · ET 2004-1-10 · Grupo 5.5.d'

const dryRun = process.argv.includes('--dry-run')

const units = JSON.parse(
  await readFile('content/administracion-units.json', 'utf8'),
).units
const transcripts = JSON.parse(
  await readFile('content/administracion-transcripts.json', 'utf8'),
)

if (units.length !== 50) {
  throw new Error(`Se esperaban 50 unidades y hay ${units.length}.`)
}
for (const unit of units) {
  for (const hours of [5, 20]) {
    if (!transcripts[`${hours}h/${unit.code}`]?.text) {
      throw new Error(`Falta la transcripción de ${hours} h de la unidad ${unit.code}.`)
    }
  }
}
for (const pdf of [SLIDES_PDF, MANUAL_PDF]) {
  if (!existsSync(pdf)) throw new Error(`No se encuentra ${pdf}.`)
}

if (dryRun) {
  console.table(
    units.map((unit) => ({
      code: unit.code,
      titulo: unit.title,
      diapositiva: unit.slidePage,
      manual: unit.manualPage,
      explicacion: unit.explanation.length,
      transcripcion5h: transcripts[`5h/${unit.code}`].text.length,
      transcripcion20h: transcripts[`20h/${unit.code}`].text.length,
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

// Duración leída de la primera cabecera de trama, para no depender de ffprobe.
// Misma implementación que `sync-beneficio-audio.mjs`.
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

async function upload(path, body, contentType) {
  const { error } = await supabase.storage.from(BUCKET).upload(path, body, {
    contentType,
    cacheControl: '3600',
    upsert: true,
  })
  if (error) throw error
}

const { data: course, error: courseError } = await supabase
  .from('courses')
  .select(
    'id, course_versions(id, duration_hours, course_modules(id, position, lessons(id, lesson_audio_segments(id, position, lesson_code))))',
  )
  .eq('slug', COURSE_SLUG)
  .single()
if (courseError) throw courseError

const versions = (course.course_versions ?? []).sort(
  (left, right) => left.duration_hours - right.duration_hours,
)
if (versions.length !== 2) {
  throw new Error(`Se esperaban dos modalidades y hay ${versions.length}.`)
}

function unitsOf(version) {
  const byCode = new Map()
  for (const module of version.course_modules ?? []) {
    for (const lesson of module.lessons ?? []) {
      for (const segment of lesson.lesson_audio_segments ?? []) {
        const expected = `${module.position}.${segment.position}`
        if (segment.lesson_code !== expected) {
          throw new Error(
            `La unidad ${segment.id} usa ${segment.lesson_code ?? 'ningún código'} y se esperaba ${expected}.`,
          )
        }
        byCode.set(expected, segment)
      }
    }
  }
  if (byCode.size !== 50) {
    throw new Error(
      `La modalidad de ${version.duration_hours} h tiene ${byCode.size} unidades; se esperaban 50.`,
    )
  }
  return byCode
}

// Las cincuenta páginas se renderizan una sola vez y se suben bajo el prefijo
// de cada modalidad.
const renderRoot = await mkdtemp(join(tmpdir(), 'inminer-administracion-'))
try {
  execFileSync('pdftoppm', ['-png', '-r', '120', SLIDES_PDF, join(renderRoot, 'slide')])
  const rendered = new Map(
    (await readdir(renderRoot))
      .filter((name) => /^slide-0*\d+\.png$/.test(name))
      .map((name) => [Number(name.match(/\d+/)?.[0]), name]),
  )
  if (rendered.size !== 50) {
    throw new Error(`Se renderizaron ${rendered.size} páginas; se esperaban 50.`)
  }

  const manualBuffer = await readFile(MANUAL_PDF)
  const slidesBuffer = await readFile(SLIDES_PDF)

  for (const version of versions) {
    const hours = version.duration_hours
    const byCode = unitsOf(version)

    // Material descargable de la versión: manual y presentación completos.
    const manualPath = `${version.id}/materials/administracion-manual-${basename(MANUAL_PDF)}`
    const slidesPath = `${version.id}/materials/administracion-slides-${basename(SLIDES_PDF)}`
    await upload(manualPath, manualBuffer, 'application/pdf')
    await upload(slidesPath, slidesBuffer, 'application/pdf')
    // `course_materials` no tiene clave única por versión y tipo, así que se
    // busca la fila por su ruta de almacenamiento, igual que hace
    // `upload-course-master-materials.mjs`.
    for (const material of [
      {
        course_version_id: version.id,
        kind: 'manual',
        title: 'Libro de texto del curso',
        description:
          'Manual formativo de las 50 unidades del Grupo 5.5.d, con el desarrollo detallado de cada diapositiva, los anexos y las fuentes normativas.',
        storage_path: manualPath,
        external_url: null,
        mime_type: 'application/pdf',
        file_name: basename(MANUAL_PDF),
        size_bytes: manualBuffer.length,
        page_count: 63,
        is_published: true,
        downloadable: true,
        position: 1,
      },
      {
        course_version_id: version.id,
        kind: 'presentation',
        title: 'Presentación del curso',
        description: 'Las 50 diapositivas utilizadas durante la formación.',
        storage_path: slidesPath,
        external_url: null,
        mime_type: 'application/pdf',
        file_name: basename(SLIDES_PDF),
        size_bytes: slidesBuffer.length,
        page_count: 50,
        is_published: true,
        downloadable: true,
        position: 2,
      },
    ]) {
      const { data: existing, error: lookupError } = await supabase
        .from('course_materials')
        .select('id')
        .eq('course_version_id', version.id)
        .eq('storage_path', material.storage_path)
        .maybeSingle()
      if (lookupError) throw lookupError
      const { error: materialError } = existing
        ? await supabase
            .from('course_materials')
            .update(material)
            .eq('id', existing.id)
        : await supabase.from('course_materials').insert(material)
      if (materialError) throw materialError
    }

    let done = 0
    for (const unit of units) {
      const segment = byCode.get(unit.code)
      if (!segment) throw new Error(`Falta la unidad ${unit.code} de ${hours} h.`)

      const slideName = rendered.get(unit.slidePage)
      const slidePath = `${version.id}/slides/${DECK_RELEASE}/${unit.code}/slide-01.png`
      await upload(slidePath, await readFile(join(renderRoot, slideName)), 'image/png')

      const audioBuffer = await readFile(unit.audio[String(hours)])
      const audioPath = `${version.id}/block-${unit.block}/audio/part-${unit.block}-${String(unit.position).padStart(2, '0')}.mp3`
      await upload(audioPath, audioBuffer, 'audio/mpeg')

      const { error: segmentError } = await supabase
        .from('lesson_audio_segments')
        .update({
          title: unit.title,
          manual_chapter: `Unidad ${unit.code}`,
          narration_text: transcripts[`${hours}h/${unit.code}`].text,
          audio_storage_path: audioPath,
          audio_external_url: null,
          duration_seconds: estimateSeconds(audioBuffer),
          published: true,
        })
        .eq('id', segment.id)
      if (segmentError) throw segmentError

      // La explicación detallada vive en la nota; el cuerpo de la diapositiva se
      // deja vacío para no duplicar el mismo texto en dos filas.
      const { error: noteError } = await supabase
        .from('lesson_segment_notes')
        .upsert(
          {
            segment_id: segment.id,
            summary: unit.explanation,
            key_points: [],
            stop_criterion: '',
            source_label: MANUAL_LABEL,
            source_pages: `Manual, página ${unit.manualPage} · apartado ${unit.ordinal}`,
            approved: true,
          },
          { onConflict: 'segment_id' },
        )
      if (noteError) throw noteError

      const { error: obsoleteError } = await supabase
        .from('lesson_segment_slides')
        .delete()
        .eq('segment_id', segment.id)
        .gt('position', 1)
      if (obsoleteError) throw obsoleteError

      const { error: slideError } = await supabase
        .from('lesson_segment_slides')
        .upsert(
          {
            segment_id: segment.id,
            position: 1,
            title: unit.title,
            body: '',
            image_storage_path: slidePath,
            image_external_url: null,
            source_label: SOURCE_LABEL,
            source_page: String(unit.slidePage),
            alt_text: `Diapositiva ${unit.slidePage}: ${unit.title}`,
          },
          { onConflict: 'segment_id,position' },
        )
      if (slideError) throw slideError

      done += 1
      if (done % 10 === 0) {
        console.log(`Administración ${hours} h: ${done}/50 unidades.`)
      }
    }

    console.log(`Administración ${hours} h: 50 unidades publicadas.`)
  }
} finally {
  await rm(renderRoot, { recursive: true, force: true })
}

console.log('Contenido de Administración importado.')
