#!/usr/bin/env node

// Borra del bucket `course-materials` los objetos que ya no referencia ninguna
// fila de la base de datos.
//
// Cada vez que se regenera un deck, las diapositivas nuevas se suben bajo una
// clave de publicación distinta (`slides/course-deck-20260812`,
// `slides/transport-definitive-20260821`…) y las filas de
// `lesson_segment_slides` pasan a apuntar a la nueva. Las anteriores se quedan
// en el bucket sin que nada las reclame. Lo mismo ocurre con los prefijos de
// versiones de curso retiradas y borradas.
//
// El borrado se hace por la API de almacenamiento, nunca con un `delete` sobre
// `storage.objects`: borrar la fila a mano dejaría el fichero real colgado en el
// backend de S3, fuera de todo inventario.
//
// Uso:
//   node scripts/prune-orphan-storage-objects.mjs            # simulacro
//   node scripts/prune-orphan-storage-objects.mjs --apply    # borra de verdad
//
// `KEEP_PATHS` es la lista de excepciones: objetos sin referencia que aun así
// se conservan porque son originales aportados por el cliente y no material
// generado. Añadir aquí cualquier fichero que deba sobrevivir a la poda.

import { createClient } from '@supabase/supabase-js'
import process from 'node:process'

const supabaseUrl = process.env.SUPABASE_URL
const serviceKey =
  process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_UPLOAD_KEY

if (!supabaseUrl || !serviceKey) {
  console.error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY en el entorno.')
  process.exit(1)
}

const apply = process.argv.includes('--apply')
const bucket = 'course-materials'

const KEEP_PATHS = new Set([
  // Manual original del curso de arranque (ET 2001-1-08). Su fila de
  // `lesson_resources` ya no existe, pero el PDF es material aportado, no un
  // derivado que se pueda volver a generar.
  'ce4a139a-877f-4da4-a77a-41a9c2309fd2/resources/manual-operador-maquinaria-arranque-ET-2001-1-08.pdf',
])

const supabase = createClient(supabaseUrl, serviceKey, {
  auth: { persistSession: false },
})

/** Todas las rutas del bucket que alguna fila de la base de datos reclama. */
async function fetchReferencedPaths() {
  const sources = [
    ['course_materials', 'storage_path'],
    ['lesson_resources', 'storage_path'],
    ['lesson_segment_slides', 'image_storage_path'],
    ['lesson_audio_segments', 'audio_storage_path'],
    ['lesson_videos', 'storage_path'],
    ['courses', 'cover_storage_path'],
  ]

  const referenced = new Set()
  for (const [table, column] of sources) {
    // Paginado explícito: PostgREST corta en 1.000 filas por defecto y las
    // diapositivas superan de sobra ese límite.
    for (let from = 0; ; from += 1000) {
      const { data, error } = await supabase
        .from(table)
        .select(column)
        .not(column, 'is', null)
        .range(from, from + 999)
      if (error) throw new Error(`${table}.${column}: ${error.message}`)
      for (const row of data) referenced.add(row[column])
      if (data.length < 1000) break
    }
  }
  return referenced
}

/** Recorre el bucket entero, que la API sólo lista un nivel cada vez. */
async function listAllObjects(prefix = '') {
  const objects = []
  for (let offset = 0; ; offset += 100) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .list(prefix, { limit: 100, offset })
    if (error) throw new Error(`list ${prefix}: ${error.message}`)

    for (const entry of data) {
      const path = prefix ? `${prefix}/${entry.name}` : entry.name
      // Las carpetas llegan sin `id`; los ficheros siempre lo traen.
      if (entry.id) objects.push({ path, size: entry.metadata?.size ?? 0 })
      else objects.push(...(await listAllObjects(path)))
    }

    if (data.length < 100) break
  }
  return objects
}

function formatMb(bytes) {
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`
}

const referenced = await fetchReferencedPaths()
const objects = await listAllObjects()
const orphans = objects.filter(
  (o) => !referenced.has(o.path) && !KEEP_PATHS.has(o.path),
)

// Agrupa por los tres primeros segmentos para que el informe quepa en pantalla
// y se lea qué generación de deck cae en cada caso.
const groups = new Map()
for (const orphan of orphans) {
  const key = orphan.path.split('/').slice(0, 3).join('/')
  const group = groups.get(key) ?? { files: 0, bytes: 0 }
  group.files += 1
  group.bytes += orphan.size
  groups.set(key, group)
}

console.log(`Objetos en el bucket: ${objects.length}`)
console.log(`Referenciados: ${referenced.size}`)
console.log(`Conservados por excepción: ${KEEP_PATHS.size}`)
console.log(`Huérfanos: ${orphans.length}\n`)

for (const [key, group] of [...groups].sort((a, b) => b[1].bytes - a[1].bytes)) {
  console.log(`  ${group.files.toString().padStart(4)}  ${formatMb(group.bytes).padStart(9)}  ${key}`)
}

const totalBytes = orphans.reduce((sum, o) => sum + o.size, 0)
console.log(`\nTotal a liberar: ${formatMb(totalBytes)}`)

if (!apply) {
  console.log('\nSimulacro. Repite con --apply para borrar.')
  process.exit(0)
}

// `remove` acepta como mucho un centenar de rutas por llamada sin degradarse.
let deleted = 0
for (let i = 0; i < orphans.length; i += 100) {
  const batch = orphans.slice(i, i + 100).map((o) => o.path)
  const { error } = await supabase.storage.from(bucket).remove(batch)
  if (error) throw new Error(`remove: ${error.message}`)
  deleted += batch.length
  console.log(`Borrados ${deleted}/${orphans.length}`)
}

console.log(`\nHecho. ${deleted} objetos borrados, ${formatMb(totalBytes)} liberados.`)
