// Sube los 186 objetos privados del curso de técnicos titulados de exterior.
// La migración de base de datos se aplica por separado y deja el curso en draft.
//
// Uso:
//   node scripts/upload-tecnicos-exterior-course.mjs --dry-run
//   node scripts/upload-tecnicos-exterior-course.mjs --asset-root tmp/tecnicos-exterior-20h
import { createHash } from 'node:crypto'
import { readFile } from 'node:fs/promises'
import { resolve } from 'node:path'
import process from 'node:process'

const manifest = JSON.parse(
  await readFile('content/tecnicos-exterior-20h/course-manifest.json', 'utf8'),
)
const dryRun = process.argv.includes('--dry-run')
const replace = process.argv.includes('--replace')
const rootIndex = process.argv.indexOf('--asset-root')
const assetRoot = resolve(rootIndex >= 0 ? process.argv[rootIndex + 1] : 'tmp/tecnicos-exterior-20h')

if (manifest.version?.status !== 'draft') {
  throw new Error('El importador solo admite una versión en borrador.')
}
if (manifest.units?.length !== 92 || manifest.assets?.length !== 186) {
  throw new Error('El manifiesto debe contener 92 unidades y 186 objetos.')
}

const prepared = []
for (const asset of manifest.assets) {
  const path = resolve(assetRoot, asset.local_path)
  const body = await readFile(path)
  const digest = createHash('sha256').update(body).digest('hex')
  if (body.length !== asset.size_bytes || digest !== asset.sha256) {
    throw new Error(`Integridad incorrecta: ${asset.local_path}`)
  }
  prepared.push({ ...asset, path, body })
}

const totalBytes = prepared.reduce((sum, asset) => sum + asset.body.length, 0)
if (dryRun) {
  console.log(
    JSON.stringify(
      {
        bucket: manifest.bucket,
        versionId: manifest.version.id,
        objects: prepared.length,
        bytes: totalBytes,
        replace,
      },
      null,
      2,
    ),
  )
  process.exit(0)
}

const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}
const { createClient } = await import('@supabase/supabase-js')
const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

let nextIndex = 0
let uploaded = 0
async function worker() {
  while (nextIndex < prepared.length) {
    const asset = prepared[nextIndex]
    nextIndex += 1
    const { error } = await supabase.storage
      .from(manifest.bucket)
      .upload(asset.storage_path, asset.body, {
        cacheControl: '31536000',
        contentType: asset.mime_type,
        upsert: replace,
      })
    if (error) {
      throw new Error(`${asset.storage_path}: ${error.message}`)
    }
    uploaded += 1
    if (uploaded % 10 === 0 || uploaded === prepared.length) {
      console.log(`${uploaded}/${prepared.length}`)
    }
  }
}

await Promise.all(Array.from({ length: 4 }, () => worker()))
console.log(`Carga completada: ${uploaded} objetos (${totalBytes} bytes).`)
