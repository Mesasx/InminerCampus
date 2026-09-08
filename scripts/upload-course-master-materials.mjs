import { execFile } from 'node:child_process'
import { readFile, stat } from 'node:fs/promises'
import { resolve } from 'node:path'
import process from 'node:process'
import { promisify } from 'node:util'
import { createClient } from '@supabase/supabase-js'

const execFileAsync = promisify(execFile)

const dryRun = process.argv.includes('--dry-run')
const selectedKeys = new Set(
  (
    process.env.COURSE_MATERIAL_KEYS ??
    [
      'perforadora-manual',
      'arranque-manual',
      'arranque-slides',
      'transporte-5h-manual',
      'transporte-20h-manual',
      'transporte-slides',
      'silice-manual',
      'silice-3h-slides',
      'establecimientos-manual',
      'establecimientos-5h-slides',
    ].join(',')
  )
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean),
)

const root = resolve('Contenido Cursos', 'Diapositivas y documentos')
const materials = [
  {
    key: 'perforadora-manual',
    slug: 'operadores-perforacion-corte-exterior',
    durations: [5, 20],
    kind: 'manual',
    title: 'Libro de texto del curso',
    description:
      'Manual completo del operador de perforadora y perforista. Incluye los cinco bloques formativos, las 50 unidades desarrolladas, fundamentos técnicos, criterios de actuación, casos razonados, riesgos, medidas preventivas y fuentes normativas.',
    pageCount: 75,
    file: resolve(root, 'Manual_Operador_Perforadora_Inminer_Campus.pdf'),
    contentType: 'application/pdf',
  },
  {
    key: 'arranque-manual',
    slug: 'operador-maquinaria-arranque-carga-viales',
    durations: [5, 20],
    kind: 'manual',
    title: 'Libro de texto del curso',
    description:
      'Manual completo del operador de maquinaria de arranque, carga y viales para estudio y consulta en Inmíner Campus.',
    pageCount: 113,
    file: resolve(root, 'Manual_Maquinaria_Arranque_Inminer_Campus .pdf'),
    contentType: 'application/pdf',
  },
  {
    // La presentación cubre las dos modalidades: portada más las 50 unidades
    // de 1.1 a 5.10, válidas tanto para el reciclaje de 5 h como para la
    // formación inicial de 20 h.
    key: 'arranque-slides',
    slug: 'operador-maquinaria-arranque-carga-viales',
    durations: [5, 20],
    kind: 'presentation',
    title: 'Presentación del curso',
    description:
      'Diapositivas utilizadas durante el desarrollo de la formación.',
    pageCount: 51,
    file: resolve(
      root,
      'Curso 1 Operador de Maquinaria de Arranque, Cargas y viales',
      'Operador-de-Maquinaria-de-Arranque-Carga-y-Viales.pdf',
    ),
    contentType: 'application/pdf',
  },
  {
    key: 'transporte-5h-manual',
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durations: [5],
    kind: 'manual',
    title: 'Libro de texto del curso',
    description:
      'Explicaciones detalladas de las 50 unidades del curso de reciclaje para operador de maquinaria de transporte, camión y volquete.',
    pageCount: 65,
    file: resolve(
      root,
      'Curso Transporte',
      '5 horas',
      'Curso_2_Transporte_5h_Explicaciones_Detalladas_Reciclaje_INMINER (2).pdf',
    ),
    contentType: 'application/pdf',
  },
  {
    key: 'transporte-20h-manual',
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durations: [20],
    kind: 'manual',
    title: 'Libro de texto del curso',
    description:
      'Manual maestro del operador de maquinaria de transporte, camión y volquete para la formación inicial de 20 horas.',
    pageCount: 116,
    file: resolve(root, 'Manual_Maquinaria_Transporte_Inminer_Campus.pdf'),
    contentType: 'application/pdf',
  },
  {
    // Igual que en arranque, una sola presentación sirve al reciclaje y a la
    // formación inicial: cinco divisorias de bloque más las 50 unidades.
    key: 'transporte-slides',
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durations: [5, 20],
    kind: 'presentation',
    title: 'Presentación del curso',
    description:
      'Diapositivas utilizadas durante el desarrollo de la formación.',
    pageCount: 55,
    file: resolve(
      root,
      'Curso Transporte',
      'El-transporte-en-el-movimiento-de-tierras-y-los-tipos-de-vehiculos.pdf',
    ),
    contentType: 'application/pdf',
  },
  {
    key: 'silice-manual',
    slug: 'prevencion-polvo-silice-cristalina-respirable',
    durations: [3],
    kind: 'manual',
    title: 'Libro de texto del curso',
    description:
      'Manual maestro de las 50 unidades sobre prevención del polvo y la sílice cristalina respirables en la industria extractiva.',
    pageCount: 62,
    file: resolve(root, 'Manual_Polvo_Silice_Inminer_Campus.pdf'),
    contentType: 'application/pdf',
  },
  {
    key: 'silice-3h-slides',
    slug: 'prevencion-polvo-silice-cristalina-respirable',
    durations: [3],
    kind: 'presentation',
    title: 'Presentación del curso',
    description:
      'Presentación de las 50 unidades de prevención del polvo y la sílice cristalina respirables.',
    pageCount: 50,
    file: resolve(root, 'CursoSilice.pdf'),
    contentType: 'application/pdf',
  },
  {
    key: 'establecimientos-manual',
    slug: 'operadores-establecimientos-beneficio',
    durations: [5, 20],
    kind: 'manual',
    title: 'Libro de texto del curso',
    description:
      'Manual maestro de las 50 unidades para operadores en establecimientos de beneficio, con locuciones diferenciadas para formación inicial y reciclaje.',
    pageCount: 115,
    file: resolve(root, 'Manual_Establecimientos_Beneficio_Inminer_Campus (2).pdf'),
    contentType: 'application/pdf',
  },
  {
    key: 'establecimientos-5h-slides',
    slug: 'operadores-establecimientos-beneficio',
    durations: [5],
    kind: 'presentation',
    title: 'Presentación del curso',
    description:
      'Presentación completa de las 50 unidades del curso de reciclaje de 5 horas.',
    pageCount: 100,
    file: resolve(
      root,
      'Diapositivas cursos',
      'Curso_3_Establecimiento_Beneficio_InminerCampus_5h.pdf',
    ),
    contentType: 'application/pdf',
  },
]

const selected = materials.filter((material) => selectedKeys.has(material.key))
const unknown = [...selectedKeys].filter(
  (key) => !materials.some((material) => material.key === key),
)
if (unknown.length)
  throw new Error(`Materiales desconocidos: ${unknown.join(', ')}`)

const validated = []
for (const material of selected) {
  const fileStat = await stat(material.file)
  if (fileStat.size > 50 * 1024 * 1024) {
    throw new Error(`${material.file} supera el límite de 50 MB.`)
  }
  if (material.contentType === 'application/pdf') {
    const { stdout } = await execFileAsync('pdfinfo', [material.file])
    const actualPageCount = Number(stdout.match(/^Pages:\s+(\d+)$/m)?.[1])
    if (actualPageCount !== material.pageCount) {
      throw new Error(
        `${material.file}: el PDF contiene ${actualPageCount} paginas; se declararon ${material.pageCount}.`,
      )
    }
  }
  validated.push({ ...material, size: fileStat.size })
}

if (dryRun) {
  console.table(
    validated.map(({ key, slug, durations, size, file }) => ({
      key,
      slug,
      versions: durations.join(' h, ') + ' h',
      megabytes: (size / 1024 / 1024).toFixed(1),
      file,
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

async function findVersions(material) {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', material.slug)
    .single()
  if (courseError) throw courseError
  const { data: versions, error } = await supabase
    .from('course_versions')
    .select('id, duration_hours')
    .eq('course_id', course.id)
    .in('duration_hours', material.durations)
  if (error) throw error
  if (versions.length !== material.durations.length) {
    throw new Error(
      `${material.slug}: faltan versiones ${material.durations.join('/')} h.`,
    )
  }
  return versions
}

async function register(material, version, storagePath) {
  const safeName = material.file.split(/[\\/]/).at(-1)
  const { data: existing, error: selectError } = await supabase
    .from('course_materials')
    .select('id')
    .eq('course_version_id', version.id)
    .eq('storage_path', storagePath)
    .maybeSingle()
  if (selectError) throw selectError
  const payload = {
    course_version_id: version.id,
    kind: material.kind,
    title: material.title,
    description: material.description,
    storage_path: storagePath,
    external_url: null,
    mime_type: material.contentType,
    file_name: safeName,
    size_bytes: material.size,
    page_count: material.pageCount,
    downloadable: true,
    is_published: true,
    position: material.kind === 'manual' ? 1 : 2,
  }
  const request = existing
    ? supabase.from('course_materials').update(payload).eq('id', existing.id)
    : supabase.from('course_materials').insert(payload)
  const { error } = await request
  if (error) throw error
}

for (const material of validated) {
  const body = await readFile(material.file)
  const versions = await findVersions(material)
  for (const version of versions) {
    const safeName = material.file.split(/[\\/]/).at(-1)
    const storagePath = `${version.id}/materials/${material.key}-${safeName}`
    const { error } = await supabase.storage
      .from('course-materials')
      .upload(storagePath, body, {
        contentType: material.contentType,
        cacheControl: '3600',
        upsert: true,
      })
    if (error) throw error
    await register(material, version, storagePath)
    console.log(`${material.key}: versión ${version.duration_hours} h cargada.`)
  }
}

console.log('Materiales maestros cargados y registrados correctamente.')
