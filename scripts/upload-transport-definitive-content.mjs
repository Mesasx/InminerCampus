#!/usr/bin/env node

// Uploads the 100 definitive transport-course slides plus both complete PDFs to
// the private course-materials bucket. It never edits database rows. Run the SQL
// migration only after this script reports that every signed URL is readable.

import { createHash } from 'node:crypto'
import { readFile } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'
import { fileURLToPath } from 'node:url'

import { createClient } from '@supabase/supabase-js'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const assetsDir = path.resolve(
  process.env.TRANSPORT_ASSETS_DIR ?? path.join(root, 'tmp', 'transport-course-assets'),
)
const manifestPath = path.join(assetsDir, 'manifest.json')
const bucket = 'course-materials'
const courseSlug = 'operador-maquinaria-transporte-camion-volquete'
const release = 'transport-definitive-20260821'
const dryRun = process.argv.includes('--dry-run')

const supabaseUrl = process.env.SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

function sha256(buffer) {
  return createHash('sha256').update(buffer).digest('hex')
}

async function readAndVerify(localPath, expectedHash) {
  const body = await readFile(localPath)
  const actualHash = sha256(body)
  if (actualHash !== expectedHash) {
    throw new Error(`SHA-256 inesperado en ${localPath}: ${actualHash}`)
  }
  return body
}

async function buildLocalFiles(manifest) {
  const files = []
  for (const duration of [5, 20]) {
    const version = manifest.versions[String(duration)]
    if (!version || version.slides.length !== 50) {
      throw new Error(`Manifest inválido para ${duration} h.`)
    }
    for (const slide of version.slides) {
      files.push({
        duration,
        part: slide.part,
        localPath: path.join(assetsDir, ...slide.path.split('/')),
        expectedHash: slide.sha256,
        contentType: 'image/jpeg',
        kind: 'slide',
      })
    }
    files.push({
      duration,
      part: null,
      localPath: version.slides_pdf.path,
      expectedHash: version.slides_pdf.sha256,
      contentType: 'application/pdf',
      kind: 'resource',
      resourceKind: 'presentation',
    })
    files.push({
      duration,
      part: null,
      localPath: version.notes_pdf.path,
      expectedHash: version.notes_pdf.sha256,
      contentType: 'application/pdf',
      kind: 'resource',
      resourceKind: 'explanations',
    })
  }
  return files
}

async function getVersionIds(supabase) {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', courseSlug)
    .single()
  if (courseError) throw courseError

  const { data: versions, error: versionsError } = await supabase
    .from('course_versions')
    .select('id,duration_hours')
    .eq('course_id', course.id)
    .in('duration_hours', [5, 20])
  if (versionsError) throw versionsError
  if (versions.length !== 2) {
    throw new Error(`Se esperaban 2 versiones y se encontraron ${versions.length}.`)
  }
  return new Map(versions.map((version) => [Number(version.duration_hours), version.id]))
}

function remotePath(file, versionId) {
  if (file.kind === 'resource') {
    const suffix =
      file.resourceKind === 'presentation'
        ? 'presentacion-completa'
        : 'explicaciones-completas'
    return `${versionId}/resources/transport-${file.duration}h-${suffix}.pdf`
  }
  const [block, part] = file.part.split('.').map(Number)
  return `${versionId}/slides/${release}/block-${block}/part-${block}-${String(part).padStart(2, '0')}.jpg`
}

async function verifyRemoteFiles(supabase, paths) {
  const { data: signed, error } = await supabase.storage.from(bucket).createSignedUrls(paths, 300)
  if (error) throw error
  const failures = []
  let cursor = 0
  const workers = Array.from({ length: 8 }, async () => {
    while (cursor < signed.length) {
      const index = cursor
      cursor += 1
      const item = signed[index]
      if (item.error || !item.signedUrl) {
        failures.push(`${item.path}: ${item.error ?? 'URL firmada ausente'}`)
        continue
      }
      try {
        const response = await fetch(item.signedUrl, { headers: { Range: 'bytes=0-31' } })
        if (!response.ok) failures.push(`${item.path}: HTTP ${response.status}`)
      } catch (fetchError) {
        failures.push(`${item.path}: ${fetchError.message}`)
      }
    }
  })
  await Promise.all(workers)
  if (failures.length) {
    throw new Error(`Falló la lectura firmada de ${failures.length} archivos:\n${failures.join('\n')}`)
  }
}

async function main() {
  const manifest = JSON.parse(await readFile(manifestPath, 'utf8'))
  if (manifest.course_slug !== courseSlug || manifest.release !== release) {
    throw new Error('El manifest no corresponde a esta publicación de transporte.')
  }
  const files = await buildLocalFiles(manifest)
  for (const file of files) {
    file.body = await readAndVerify(file.localPath, file.expectedHash)
  }
  console.log(`Preflight local OK: ${files.length} archivos y todos sus SHA-256 coinciden.`)

  if (dryRun) {
    console.log('Dry-run completado: no se ha conectado a Supabase ni se ha subido nada.')
    return
  }
  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY en el entorno.')
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey, { auth: { persistSession: false } })
  const versionIds = await getVersionIds(supabase)
  const uploadedPaths = []
  for (let index = 0; index < files.length; index += 1) {
    const file = files[index]
    const destination = remotePath(file, versionIds.get(file.duration))
    const { error } = await supabase.storage.from(bucket).upload(destination, file.body, {
      contentType: file.contentType,
      cacheControl: '31536000',
      upsert: true,
    })
    if (error) throw new Error(`${destination}: ${error.message}`)
    uploadedPaths.push(destination)
    if ((index + 1) % 10 === 0 || index + 1 === files.length) {
      console.log(`${index + 1}/${files.length} archivos subidos`)
    }
  }

  await verifyRemoteFiles(supabase, uploadedPaths)
  console.log(`Carga completa: ${uploadedPaths.length} archivos privados; 104/104 URLs firmadas verificadas.`)
}

await main()
