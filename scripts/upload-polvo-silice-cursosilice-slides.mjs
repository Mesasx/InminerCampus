#!/usr/bin/env node

// Sube las 50 diapositivas renderizadas desde CursoSilice.pdf (el deck
// definitivo, sin ninguna referencia a "20 horas") al bucket privado
// "course-materials", bajo el prefijo propio de la versión superviviente
// del curso Polvo y Sílice (cd155d2b). Sustituye las diapositivas
// reutilizadas del deck antiguo de 20 horas, que llevaban ese rótulo
// grabado en el pie de página de la imagen.
//
// Requiere en el entorno: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY.
// Uso: node scripts/upload-polvo-silice-cursosilice-slides.mjs

import { createClient } from '@supabase/supabase-js'
import { readFile } from 'node:fs/promises'
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
const versionId = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315'
const release = 'course-deck-20260820-cursosilice'
const slidesDir =
  'C:/Users/Xmesa/AppData/Local/Temp/claude/c--Users-Xmesa-OneDrive-Escritorio-InminerCampus/d1109cf9-43a8-4efe-ac1f-dceb8b02e329/scratchpad/cursosilice-slides'
const mappingPath =
  'C:/Users/Xmesa/AppData/Local/Temp/claude/c--Users-Xmesa-OneDrive-Escritorio-InminerCampus/d1109cf9-43a8-4efe-ac1f-dceb8b02e329/scratchpad/slide-segment-mapping.json'

function buildFiles(mapping) {
  return mapping.map(({ segment_id: segmentId, mod_pos: block, seg_pos: part }) => {
    const page = (block - 1) * 10 + part
    const localPath = `${slidesDir}/slide-${String(page).padStart(2, '0')}.jpg`
    const remotePath = [
      versionId,
      'slides',
      release,
      `block-${block}`,
      `audio-${block}-${String(part).padStart(2, '0')}`,
      'slide-01.jpg',
    ].join('/')
    return { segmentId, localPath, remotePath }
  })
}

async function main() {
  const mapping = JSON.parse(await readFile(mappingPath, 'utf8'))
  const files = buildFiles(mapping)

  let uploaded = 0
  for (const file of files) {
    const body = await readFile(file.localPath)
    const { error } = await supabase.storage.from(bucket).upload(file.remotePath, body, {
      contentType: 'image/jpeg',
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

  // Vuelca el mapeo segment_id -> nueva ruta para el UPDATE en SQL.
  console.log('---SQL_VALUES_START---')
  for (const file of files) {
    console.log(`('${file.segmentId}', '${file.remotePath}')`)
  }
  console.log('---SQL_VALUES_END---')

  console.log(`Carga completa: ${uploaded} archivos subidos a ${release}. Verificación de muestra OK.`)
}

await main()
