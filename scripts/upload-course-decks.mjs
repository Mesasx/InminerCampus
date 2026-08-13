#!/usr/bin/env node

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

const repositoryRoot = process.cwd()
const bucket = 'course-materials'
const release = 'course-deck-20260812'

const decks = [
  {
    key: 'course-2',
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durationHours: 5,
    extension: 'png',
    contentType: 'image/png',
    localFile(block, part, slide, _page) {
      return path.join(
        repositoryRoot,
        'Contenido Cursos',
        'Diapositivas y documentos',
        'Curso 2',
        'slides',
        `block-${block}`,
        `audio-${block}-${String(part).padStart(2, '0')}`,
        `audio-${block}-${String(part).padStart(2, '0')}-slide-${String(slide).padStart(2, '0')}.png`,
      )
    },
  },
  {
    key: 'course-4',
    slug: 'operador-maquinaria-arranque-carga-viales',
    durationHours: 20,
    extension: 'jpg',
    contentType: 'image/jpeg',
  },
  {
    key: 'course-5',
    slug: 'operador-maquinaria-transporte-camion-volquete',
    durationHours: 20,
    extension: 'jpg',
    contentType: 'image/jpeg',
  },
  {
    key: 'course-6',
    slug: 'prevencion-polvo-silice-cristalina-respirable',
    durationHours: 20,
    extension: 'jpg',
    contentType: 'image/jpeg',
  },
]

async function findCourseVersionId(deck) {
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id')
    .eq('slug', deck.slug)
    .maybeSingle()
  if (courseError) throw courseError
  if (!course) throw new Error(`No existe el curso ${deck.slug}.`)

  const { data: version, error: versionError } = await supabase
    .from('course_versions')
    .select('id')
    .eq('course_id', course.id)
    .eq('duration_hours', deck.durationHours)
    .maybeSingle()
  if (versionError) throw versionError
  if (!version) {
    throw new Error(`No existe ${deck.slug} de ${deck.durationHours} horas.`)
  }
  return version.id
}

function buildFiles(deck, versionId) {
  const files = []
  for (let block = 1; block <= 5; block += 1) {
    for (let part = 1; part <= 10; part += 1) {
      for (let slide = 1; slide <= 2; slide += 1) {
        const page = ((block - 1) * 10 + (part - 1)) * 2 + slide
        const localPath = deck.localFile
          ? deck.localFile(block, part, slide, page)
          : path.join(
              repositoryRoot,
              '.work',
              'course-slide-decks',
              deck.key,
              `slide-${String(page).padStart(3, '0')}.jpg`,
            )
        const remotePath = [
          versionId,
          'slides',
          release,
          `block-${block}`,
          `audio-${block}-${String(part).padStart(2, '0')}`,
          `slide-${String(slide).padStart(2, '0')}.${deck.extension}`,
        ].join('/')
        files.push({ localPath, remotePath })
      }
    }
  }
  return files
}

async function uploadDeck(deck) {
  const versionId = await findCourseVersionId(deck)
  const files = buildFiles(deck, versionId)
  let nextIndex = 0
  let uploaded = 0

  async function worker() {
    while (nextIndex < files.length) {
      const index = nextIndex
      nextIndex += 1
      const file = files[index]
      const body = await readFile(file.localPath)
      const { error } = await supabase.storage.from(bucket).upload(file.remotePath, body, {
        contentType: deck.contentType,
        cacheControl: '31536000',
        upsert: true,
      })
      if (error) throw new Error(`${file.remotePath}: ${error.message}`)
      uploaded += 1
      if (uploaded % 20 === 0 || uploaded === files.length) {
        console.log(`${deck.key}: ${uploaded}/${files.length}`)
      }
    }
  }

  await Promise.all(Array.from({ length: 6 }, () => worker()))

  const samplePaths = [files[0].remotePath, files.at(-1).remotePath]
  const { data: signedFiles, error: signedFilesError } = await supabase.storage
    .from(bucket)
    .createSignedUrls(samplePaths, 60)
  if (signedFilesError) throw signedFilesError

  for (const signedFile of signedFiles) {
    if (signedFile.error || !signedFile.signedUrl) {
      throw new Error(
        `${deck.key}: no se pudo firmar ${signedFile.path}: ${signedFile.error ?? 'URL ausente'}`,
      )
    }
    const response = await fetch(signedFile.signedUrl, {
      headers: { Range: 'bytes=0-63' },
    })
    if (!response.ok) {
      throw new Error(
        `${deck.key}: la verificación HTTP de ${signedFile.path} devolvió ${response.status}.`,
      )
    }
    const contentType = response.headers.get('content-type') ?? ''
    if (!contentType.startsWith('image/')) {
      throw new Error(
        `${deck.key}: ${signedFile.path} devolvió ${contentType || 'un tipo vacío'}.`,
      )
    }
  }

  console.log(`${deck.key}: extremos verificados mediante URL privada firmada.`)
  return { deck: deck.key, versionId, uploaded }
}

for (const deck of decks) {
  const result = await uploadDeck(deck)
  console.log(`${result.deck}: 100 diapositivas subidas en ${result.versionId}.`)
}

console.log('Carga completa: 400 diapositivas privadas subidas.')
