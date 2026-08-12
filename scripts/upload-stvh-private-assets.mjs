#!/usr/bin/env node
// Sube al bucket privado `course-materials` las diapositivas y los
// materiales de origen de «Formación STVH», guardados en
// supabase/storage-seed/stvh (ya no se sirven como ficheros públicos desde
// public/course-slides/stvh ni public/course-materials/stvh).
//
// Ejecuta este script ANTES de aplicar la migración
// supabase/migrations/202608120001_stvh_private_storage.sql: esa migración
// apunta lesson_segment_slides.image_storage_path y
// lesson_resources.storage_path a estas mismas rutas, así que si se aplica
// primero la migración, los alumnos ya matriculados se quedan sin
// diapositivas ni PDF hasta que termine la subida.
//
// Requiere las variables de servidor SUPABASE_URL y
// SUPABASE_SERVICE_ROLE_KEY (nunca las VITE_*, y nunca las imprimas ni las
// commitees). No se ejecuta como parte de `npm test`/`npm run check`.
//
// Uso:
//   SUPABASE_URL=https://xxxx.supabase.co \
//   SUPABASE_SERVICE_ROLE_KEY=xxxx \
//   node scripts/upload-stvh-private-assets.mjs

import { createClient } from '@supabase/supabase-js'
import { readdir, readFile } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'

const supabaseUrl = process.env.SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !serviceRoleKey) {
  console.error(
    'Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY en el entorno.',
  )
  process.exit(1)
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

const root = process.cwd()
const BUCKET = 'course-materials'

async function findCourseVersionId() {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', 'formacion-stvh')
    .maybeSingle()
  if (courseError) throw courseError
  if (!course) {
    throw new Error(
      'No existe el curso formacion-stvh. Aplica primero 202608110002.',
    )
  }

  const { data: version, error: versionError } = await supabase
    .from('course_versions')
    .select('id')
    .eq('course_id', course.id)
    .eq('version_number', 1)
    .maybeSingle()
  if (versionError) throw versionError
  if (!version) throw new Error('No existe la versión 1 de formacion-stvh.')
  return version.id
}

async function uploadDirectory(localDir, remotePrefix, contentType) {
  let entries
  try {
    entries = await readdir(localDir)
  } catch {
    console.warn(`(omitido) no existe ${localDir}`)
    return { uploaded: 0, failed: 0 }
  }

  let uploaded = 0
  let failed = 0
  for (const name of entries.sort()) {
    const localPath = path.join(localDir, name)
    const remotePath = `${remotePrefix}/${name}`
    const body = await readFile(localPath)
    const { error } = await supabase.storage
      .from(BUCKET)
      .upload(remotePath, body, { contentType, upsert: true })
    if (error) {
      console.error(`  x ${remotePath}: ${error.message}`)
      failed += 1
      continue
    }
    console.log(`  ok ${remotePath}`)
    uploaded += 1
  }
  return { uploaded, failed }
}

const versionId = await findCourseVersionId()
console.log(`Curso formacion-stvh -> course_version_id ${versionId}\n`)

console.log('Subiendo diapositivas...')
const slides = await uploadDirectory(
  path.join(root, 'supabase', 'storage-seed', 'stvh', 'slides'),
  `${versionId}/slides`,
  'image/jpeg',
)

console.log('Subiendo materiales...')
const materials = await uploadDirectory(
  path.join(root, 'supabase', 'storage-seed', 'stvh', 'materials'),
  `${versionId}/materials`,
  'application/pdf',
)

console.log(
  `\nDiapositivas: ${slides.uploaded} subidas, ${slides.failed} con error.`,
)
console.log(
  `Materiales: ${materials.uploaded} subidos, ${materials.failed} con error.`,
)

if (slides.failed || materials.failed) {
  console.error(
    '\nHubo errores. No apliques 202608120001_stvh_private_storage.sql hasta resolverlos.',
  )
  process.exit(1)
}

console.log(
  '\nListo. Ahora puedes aplicar supabase/migrations/202608120001_stvh_private_storage.sql en este mismo entorno.',
)
