#!/usr/bin/env node

// Sube al bucket privado "course-materials" el material definitivo del curso
// Polvo y sílice cristalina respirable · 20 horas: las 50 diapositivas nuevas
// (una por parte) y la presentación completa combinada (recurso descargable).
// Solo afecta a course_version_id de la modalidad de 20 horas de este curso;
// no toca ningún otro curso ni la versión de 5 horas.
//
// Requiere en el entorno: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY.
// Uso: node scripts/upload-polvo-silice-20h-definitive-content.mjs

import { createClient } from '@supabase/supabase-js'
import { readFile } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'

const supabaseUrl = process.env.SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !serviceRoleKey) {
  console.error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY en el entorno.')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

const bucket = 'course-materials'
const versionId = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24' // prevencion-polvo-silice-cristalina-respirable · 20h
const release = 'course-deck-20260819-definitiva'

const slidesDir = process.env.POLVO_SILICE_SLIDES_DIR
const resourcePdfPath = process.env.POLVO_SILICE_RESOURCE_PDF

if (!slidesDir || !resourcePdfPath) {
  console.error(
    'Faltan POLVO_SILICE_SLIDES_DIR (carpeta con slide-01.jpg..slide-50.jpg) y/o POLVO_SILICE_RESOURCE_PDF (ruta al PDF combinado).',
  )
  process.exit(1)
}

function buildSlideFiles() {
  const files = []
  for (let block = 1; block <= 5; block += 1) {
    for (let part = 1; part <= 10; part += 1) {
      const page = (block - 1) * 10 + part
      const localPath = path.join(
        slidesDir,
        `slide-${String(page).padStart(2, '0')}.jpg`,
      )
      const remotePath = [
        versionId,
        'slides',
        release,
        `block-${block}`,
        `audio-${block}-${String(part).padStart(2, '0')}`,
        'slide-01.jpg',
      ].join('/')
      files.push({ localPath, remotePath, contentType: 'image/jpeg' })
    }
  }
  files.push({
    localPath: resourcePdfPath,
    remotePath: `${versionId}/resources/formacion-polvo-silice-20h-presentacion-completa.pdf`,
    contentType: 'application/pdf',
  })
  return files
}

async function uploadAll() {
  const files = buildSlideFiles()
  let uploaded = 0
  for (const file of files) {
    const body = await readFile(file.localPath)
    const { error } = await supabase.storage.from(bucket).upload(file.remotePath, body, {
      contentType: file.contentType,
      cacheControl: '31536000',
      upsert: true,
    })
    if (error) throw new Error(`${file.remotePath}: ${error.message}`)
    uploaded += 1
    if (uploaded % 10 === 0 || uploaded === files.length) {
      console.log(`${uploaded}/${files.length}`)
    }
  }

  const samplePaths = [files[0].remotePath, files.at(-1).remotePath]
  const { data: signedFiles, error: signedError } = await supabase.storage
    .from(bucket)
    .createSignedUrls(samplePaths, 60)
  if (signedError) throw signedError
  for (const signedFile of signedFiles) {
    if (signedFile.error || !signedFile.signedUrl) {
      throw new Error(`No se pudo firmar ${signedFile.path}: ${signedFile.error ?? 'URL ausente'}`)
    }
    const response = await fetch(signedFile.signedUrl, { headers: { Range: 'bytes=0-63' } })
    if (!response.ok) {
      throw new Error(`Verificación HTTP de ${signedFile.path} devolvió ${response.status}.`)
    }
  }

  console.log(`Carga completa: ${uploaded} archivos subidos a ${release}. Verificación de muestra OK.`)
}

await uploadAll()
