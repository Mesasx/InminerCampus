import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

// Replica las cincuenta diapositivas de establecimientos de beneficio bajo la
// carpeta de la modalidad de 20 h.
//
// La presentación es la misma en las dos modalidades, pero no se puede
// compartir la ruta: la política de lectura del bucket exige que la primera
// carpeta del objeto sea el identificador de la versión en la que el alumno
// está matriculado, así que un alumno de 20 h recibiría un 403 al pedir una
// imagen guardada bajo la versión de 5 h. Se copian, no se mueven: la
// modalidad de 5 h sigue usando las suyas.

const V5 = '4945d77b-d931-4054-a534-8a7466ce6a0b'
const V20 = 'f5a7da9c-a3f2-4163-bb65-90395827f146'
const BUCKET = 'course-materials'
const SOURCE_PREFIX = `${V5}/slides/establecimientos-beneficio-5h-2026-v2`
const TARGET_PREFIX = `${V20}/slides/establecimientos-beneficio-20h-2026-v2`

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

const codes = []
for (let block = 1; block <= 5; block += 1) {
  for (let unit = 1; unit <= 10; unit += 1) codes.push(`${block}.${unit}`)
}

let copied = 0
const missing = []

for (const code of codes) {
  for (const slide of [1]) {
    const from = `${SOURCE_PREFIX}/${code}/slide-0${slide}.png`
    const to = `${TARGET_PREFIX}/${code}/slide-0${slide}.png`

    const { data, error } = await supabase.storage.from(BUCKET).download(from)
    if (error || !data) {
      missing.push(from)
      continue
    }
    if (dryRun) {
      copied += 1
      continue
    }
    const buffer = Buffer.from(await data.arrayBuffer())
    const { error: uploadError } = await supabase.storage
      .from(BUCKET)
      .upload(to, buffer, {
        contentType: 'image/png',
        cacheControl: '3600',
        upsert: true,
      })
    if (uploadError) throw uploadError
    copied += 1
  }
}

if (missing.length) {
  throw new Error(
    `No se han encontrado ${missing.length} diapositivas de origen:\n${missing.join('\n')}`,
  )
}
if (copied !== 50) {
  throw new Error(`Se esperaban 50 diapositivas y se han tratado ${copied}.`)
}

console.log(
  `Establecimientos de beneficio 20 h: 50 diapositivas ${dryRun ? 'localizadas en origen' : 'copiadas a su propia carpeta'}.`,
)
