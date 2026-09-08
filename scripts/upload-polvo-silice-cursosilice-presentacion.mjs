#!/usr/bin/env node

// Sube CursoSilice.pdf (presentación definitiva, 50 páginas: 5 bloques x 10
// diapositivas) al bucket privado "course-materials" bajo el prefijo de la
// versión superviviente del curso Polvo y Sílice (cd155d2b), sustituyendo el
// recurso "Presentación completa" que apuntaba por error al PDF antiguo de
// la modalidad de 20 horas ya retirada. Solo escribe en Storage; la
// actualización de lesson_resources se hace por separado en SQL.
//
// Requiere en el entorno: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY.
// Uso: node scripts/upload-polvo-silice-cursosilice-presentacion.mjs

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
const versionId = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' // polvo-silice-cristalina-respirable · versión superviviente
const localPath =
  'Contenido Cursos/Diapositivas y documentos/CursoSilice.pdf'
const remotePath = `${versionId}/resources/formacion-polvo-silice-presentacion-completa.pdf`

async function main() {
  const body = await readFile(localPath)
  console.log(`Subiendo ${body.length} bytes a ${remotePath}...`)
  const { error } = await supabase.storage.from(bucket).upload(remotePath, body, {
    contentType: 'application/pdf',
    cacheControl: '31536000',
    upsert: true,
  })
  if (error) throw new Error(`Fallo al subir: ${error.message}`)

  const { data: signed, error: signedError } = await supabase.storage
    .from(bucket)
    .createSignedUrl(remotePath, 60)
  if (signedError) throw signedError

  const response = await fetch(signed.signedUrl, { headers: { Range: 'bytes=0-63' } })
  if (!response.ok) {
    throw new Error(`Verificación HTTP devolvió ${response.status}.`)
  }
  const buf = Buffer.from(await response.arrayBuffer())
  const header = buf.subarray(0, 5).toString('utf8')
  if (header !== '%PDF-') {
    throw new Error(`Cabecera inesperada tras la subida: ${header}`)
  }

  console.log(`OK. Ruta remota: ${remotePath}`)
  console.log(`Verificación de cabecera PDF: correcta ("${header}").`)
}

await main()
