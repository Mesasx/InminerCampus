import { readFile, readdir } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'

const root = path.resolve('Contenido Cursos', 'Pistas de Audio')
const dryRun = process.argv.includes('--dry-run')
const endpoint = process.env.AUDIO_IMPORT_ENDPOINT?.trim()
const token = process.env.AUDIO_IMPORT_TOKEN?.trim()
const concurrency = 6

const courseMappings = [
  {
    pattern: /^curso 1\b/i,
    slug: 'operador-maquinaria-arranque-carga-viales',
    durationHours: 5,
  },
  {
    pattern: /^curso 2\b/i,
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durationHours: 5,
  },
  {
    // La carpeta se llama «5 horas», pero tras consolidar el curso de sílice la
    // modalidad corta quedó registrada como de 3 horas.
    pattern: /^curso 3\b/i,
    slug: 'prevencion-polvo-silice-cristalina-respirable',
    durationHours: 3,
  },
  {
    pattern: /^curso 4\b/i,
    slug: 'operador-maquinaria-arranque-carga-viales',
    durationHours: 20,
  },
  {
    pattern: /^curso 5\b/i,
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durationHours: 20,
  },
  {
    // El curso de sílice conserva una única modalidad, la de 3 horas. La
    // versión de 20 horas está retirada, así que sus locuciones se ignoran en
    // vez de subirlas a una modalidad que ya nadie cursa.
    pattern: /^curso 6\b/i,
    skip: 'el curso de sílice solo mantiene la modalidad de 3 horas',
  },
  {
    pattern: /^curso 7\b/i,
    slug: 'operadores-perforacion-corte-exterior',
    durationHours: 5,
  },
  {
    pattern: /^curso 8\b/i,
    slug: 'operadores-perforacion-corte-exterior',
    durationHours: 20,
  },
  {
    // Establecimiento de beneficio entrega las dos modalidades bajo la misma
    // carpeta, con un subdirectorio «5 horas» y otro «20 horas», así que la
    // duración se lee de la ruta en vez de fijarla en el mapeo.
    pattern: /^curso 9\b/i,
    slug: 'operadores-establecimientos-beneficio',
    durationFromFolder: true,
  },
]

function normalized(value) {
  return value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase()
}

async function walk(directory) {
  const entries = await readdir(directory, { withFileTypes: true })
  const files = []
  for (const entry of entries) {
    const absolute = path.join(directory, entry.name)
    if (entry.isDirectory()) files.push(...(await walk(absolute)))
    else if (/\.(mp3|mp4)$/i.test(entry.name)) files.push(absolute)
  }
  return files
}

function titleFromFilename(filename) {
  const stem = path.basename(filename, path.extname(filename))
  const title = stem
    .replace(/^parte[-_ ]*\d+[._-]\d+[-_ ]*/i, '')
    .replace(/[-_]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
  return title ? title[0].toUpperCase() + title.slice(1) : stem
}

function estimateMp3Duration(buffer) {
  let offset = 0
  if (buffer.length >= 10 && buffer.toString('ascii', 0, 3) === 'ID3') {
    offset =
      10 +
      ((buffer[6] & 0x7f) << 21) +
      ((buffer[7] & 0x7f) << 14) +
      ((buffer[8] & 0x7f) << 7) +
      (buffer[9] & 0x7f)
  }

  const mpeg1Layer3 = [
    0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320,
  ]
  const mpeg2Layer3 = [
    0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160,
  ]

  for (let index = offset; index < Math.min(buffer.length - 4, offset + 65536); index += 1) {
    if (buffer[index] !== 0xff || (buffer[index + 1] & 0xe0) !== 0xe0) continue
    const versionBits = (buffer[index + 1] >> 3) & 0x03
    const layerBits = (buffer[index + 1] >> 1) & 0x03
    const bitrateIndex = (buffer[index + 2] >> 4) & 0x0f
    if (versionBits === 1 || layerBits !== 1 || bitrateIndex === 0 || bitrateIndex === 15) continue
    const bitrate =
      (versionBits === 3 ? mpeg1Layer3 : mpeg2Layer3)[bitrateIndex] * 1000
    if (!bitrate) continue
    return Math.max(1, Math.round(((buffer.length - offset) * 8) / bitrate))
  }
  return null
}

async function buildManifest() {
  const files = await walk(root)
  const manifest = []
  const errors = []
  const skipped = new Map()

  for (const absolutePath of files) {
    const relativePath = path.relative(root, absolutePath)
    const parts = relativePath.split(path.sep)
    const folder = parts[0]
    const mapping = courseMappings.find(({ pattern }) => pattern.test(normalized(folder)))
    if (mapping?.skip) {
      const entry = skipped.get(mapping.skip) ?? { folder, count: 0 }
      entry.count += 1
      skipped.set(mapping.skip, entry)
      continue
    }
    const blockMatch = parts.slice(1, -1).join('/').match(/bloque[-_ ]*(\d+)/i)
    const partMatch = parts.at(-1).match(/parte[-_ ]*(\d+)[._-](\d+)/i)
    if (!mapping || !blockMatch || !partMatch) {
      errors.push(`No se puede interpretar: ${relativePath}`)
      continue
    }

    const durationHours = mapping.durationFromFolder
      ? Number(parts[1]?.match(/(\d+)\s*horas?/i)?.[1])
      : mapping.durationHours
    if (!durationHours) {
      errors.push(`Duración no reconocida: ${relativePath}`)
      continue
    }

    const block = Number(blockMatch[1])
    const filenameBlock = Number(partMatch[1])
    const position = Number(partMatch[2])
    const courseOneBlockTwoCorrection =
      mapping.slug === 'operador-maquinaria-arranque-carga-viales' &&
      durationHours === 5 &&
      block === 2 &&
      filenameBlock === 1
    if (
      (!courseOneBlockTwoCorrection && block !== filenameBlock) ||
      block < 1 ||
      block > 5 ||
      position < 1 ||
      position > 10
    ) {
      errors.push(`Numeración no válida: ${relativePath}`)
      continue
    }

    const buffer = await readFile(absolutePath)
    manifest.push({
      ...mapping,
      durationHours,
      absolutePath,
      relativePath,
      block,
      position,
      title: titleFromFilename(parts.at(-1)),
      durationSeconds: /\.mp3$/i.test(absolutePath)
        ? estimateMp3Duration(buffer)
        : null,
      size: buffer.length,
    })
  }

  manifest.sort(
    (left, right) =>
      left.slug.localeCompare(right.slug) ||
      left.durationHours - right.durationHours ||
      left.block - right.block ||
      left.position - right.position,
  )

  const keys = new Set()
  for (const item of manifest) {
    const key = `${item.slug}:${item.durationHours}:${item.block}:${item.position}`
    if (keys.has(key)) errors.push(`Parte duplicada: ${key}`)
    keys.add(key)
  }
  if (errors.length) throw new Error(errors.join('\n'))
  return { manifest, skipped }
}

async function upload(item) {
  const buffer = await readFile(item.absolutePath)
  const form = new FormData()
  form.set('slug', item.slug)
  form.set('durationHours', String(item.durationHours))
  form.set('block', String(item.block))
  form.set('position', String(item.position))
  form.set('title', item.title)
  if (item.durationSeconds) form.set('durationSeconds', String(item.durationSeconds))
  form.set(
    'file',
    new Blob([buffer], {
      type: /\.mp3$/i.test(item.absolutePath) ? 'audio/mpeg' : 'audio/mp4',
    }),
    path.basename(item.absolutePath),
  )

  let lastError
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    try {
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'x-import-token': token },
        body: form,
      })
      const result = await response.json().catch(() => ({}))
      if (!response.ok) throw new Error(result.error || `HTTP ${response.status}`)
      return result
    } catch (error) {
      lastError = error
      if (attempt < 3) await new Promise((resolve) => setTimeout(resolve, attempt * 750))
    }
  }
  throw lastError
}

const { manifest, skipped } = await buildManifest()
const totals = Object.groupBy(
  manifest,
  ({ slug, durationHours }) => `${slug} (${durationHours} h)`,
)

console.log(`Archivos válidos: ${manifest.length}`)
for (const [course, items] of Object.entries(totals)) {
  console.log(`- ${course}: ${items.length}`)
}
for (const [reason, { folder, count }] of skipped) {
  console.log(`Omitidas ${count} pistas de «${folder}»: ${reason}.`)
}

if (dryRun) process.exit(0)
if (!endpoint || !token) {
  throw new Error('Faltan AUDIO_IMPORT_ENDPOINT o AUDIO_IMPORT_TOKEN.')
}

let cursor = 0
let completed = 0
const failures = []

async function worker() {
  while (cursor < manifest.length) {
    const index = cursor
    cursor += 1
    const item = manifest[index]
    try {
      await upload(item)
      completed += 1
      if (completed % 10 === 0 || completed === manifest.length) {
        console.log(`Subidos ${completed}/${manifest.length}`)
      }
    } catch (error) {
      failures.push(`${item.relativePath}: ${error.message}`)
    }
  }
}

await Promise.all(Array.from({ length: concurrency }, () => worker()))
if (failures.length) {
  console.error(failures.join('\n'))
  process.exit(1)
}
console.log(`Importación completada: ${completed} archivos.`)
