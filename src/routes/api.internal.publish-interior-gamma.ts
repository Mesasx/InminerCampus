import { createFileRoute } from '@tanstack/react-router'
import { getBearerToken, getSupabaseAdmin } from '../server/supabase-admin'

const TOKEN = 'inminer-publish-interior-gamma-02EFA878-7BBC-47C0-8D7B-55698638ECC0'
const COURSE_ID = 'b6586fbf-c8eb-515a-b82c-2c54cd9f4a5b'
const VERSION_ID = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'
const PRESENTATION_ID = 'fa73e06b-97c3-5ef9-8e7b-2d5beb5113b4'
const BASE_PATH = `${VERSION_ID}/operadores-interior-arranque-carga-perforacion-voladura/v1.1-2026-11`
const PRESENTATION_PATH = `${BASE_PATH}/materials/presentacion-operadores-interior-20h-et-2002-1-08-gamma-v1.1.pdf`
const SLIDE_PREFIX = `${BASE_PATH}/slides-gamma`

type NestedRow = {
  id: string
  position?: number
  lessons?: NestedRow[] | NestedRow | null
  lesson_audio_segments?: NestedRow[] | NestedRow | null
  lesson_segment_slides?: NestedRow[] | NestedRow | null
  quizzes?: NestedRow[] | NestedRow | null
  published?: boolean
  audio_storage_path?: string | null
  image_storage_path?: string | null
  required_perfect_streak?: number
  active?: boolean
}

function rows<T>(value: T[] | T | null | undefined): T[] {
  if (!value) return []
  return Array.isArray(value) ? value : [value]
}

function unauthorized() {
  return new Response('Unauthorized', {
    status: 401,
    headers: { 'Cache-Control': 'no-store' },
  })
}

function json(value: unknown, status = 200) {
  return Response.json(value, {
    status,
    headers: { 'Cache-Control': 'no-store' },
  })
}

async function loadStructure(supabase: ReturnType<typeof getSupabaseAdmin>) {
  const { data, error } = await supabase
    .from('course_modules')
    .select(
      'id,position,lessons(id,position,quizzes(id,required_perfect_streak,active),lesson_audio_segments(id,position,published,audio_storage_path,lesson_segment_slides(id,position,image_storage_path)))',
    )
    .eq('course_version_id', VERSION_ID)

  if (error) throw new Error(error.message)

  const modules = rows((data || []) as NestedRow[]).sort(
    (left, right) => (left.position ?? 0) - (right.position ?? 0),
  )
  const lessons = modules.flatMap((module) =>
    rows(module.lessons).sort(
      (left, right) => (left.position ?? 0) - (right.position ?? 0),
    ),
  )
  const segments = lessons.flatMap((lesson) =>
    rows(lesson.lesson_audio_segments).sort(
      (left, right) => (left.position ?? 0) - (right.position ?? 0),
    ),
  )
  const slides = segments.map((segment) => {
    const slide = rows(segment.lesson_segment_slides).sort(
      (left, right) => (left.position ?? 0) - (right.position ?? 0),
    )[0]
    if (!slide) throw new Error(`Segment ${segment.id} has no slide`)
    return { ...slide, segmentId: segment.id }
  })
  const quizzes = lessons.flatMap((lesson) => rows(lesson.quizzes))

  return { modules, lessons, segments, slides, quizzes }
}

function expectedSlidePath(index: number) {
  return `${SLIDE_PREFIX}/slide-${String(index + 1).padStart(3, '0')}.png`
}

function isAllowedUploadPath(path: string) {
  if (path === PRESENTATION_PATH) return true
  const match = path.match(
    new RegExp(`^${SLIDE_PREFIX.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}/slide-(\\d{3})\\.png$`),
  )
  if (!match) return false
  const number = Number(match[1])
  return number >= 1 && number <= 80
}

export const Route = createFileRoute('/api/internal/publish-interior-gamma')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        if (getBearerToken(request) !== TOKEN) return unauthorized()

        const url = new URL(request.url)
        const operation = url.searchParams.get('operation')
        const supabase = getSupabaseAdmin()

        try {
          if (operation === 'upload') {
            const path = url.searchParams.get('path') || ''
            if (!isAllowedUploadPath(path)) {
              return json({ error: 'Invalid upload path' }, 400)
            }

            const bytes = await request.arrayBuffer()
            const maxSize = path.endsWith('.pdf') ? 5_000_000 : 2_000_000
            if (!bytes.byteLength || bytes.byteLength > maxSize) {
              return json({ error: 'Invalid file size' }, 400)
            }

            const { error } = await supabase.storage
              .from('course-materials')
              .upload(path, bytes, {
                upsert: true,
                cacheControl: '31536000',
                contentType: path.endsWith('.pdf')
                  ? 'application/pdf'
                  : 'image/png',
              })
            if (error) return json({ error: error.message }, 500)
            return json({ ok: true, path, size: bytes.byteLength })
          }

          if (operation === 'structure') {
            const structure = await loadStructure(supabase)
            return json({
              counts: {
                modules: structure.modules.length,
                lessons: structure.lessons.length,
                segments: structure.segments.length,
                slides: structure.slides.length,
                quizzes: structure.quizzes.length,
              },
              slideIds: structure.slides.map((slide) => slide.id),
            })
          }

          if (operation === 'finalize-slides') {
            const start = Number(url.searchParams.get('start'))
            const count = Number(url.searchParams.get('count') || '10')
            if (!Number.isInteger(start) || start < 0 || start >= 80) {
              return json({ error: 'Invalid start' }, 400)
            }
            if (!Number.isInteger(count) || count < 1 || count > 10) {
              return json({ error: 'Invalid count' }, 400)
            }

            const structure = await loadStructure(supabase)
            if (structure.slides.length !== 80) {
              return json({ error: 'Expected exactly 80 slides' }, 409)
            }

            const selected = structure.slides.slice(start, start + count)
            const updates = await Promise.all(
              selected.map((slide, offset) => {
                const index = start + offset
                return supabase
                  .from('lesson_segment_slides')
                  .update({
                    image_storage_path: expectedSlidePath(index),
                    image_external_url: null,
                    source_label:
                      'Presentación Gamma · InmínerCampus · Operadores de interior · ET 2002-1-08',
                    source_page: String(index + 1),
                    alt_text: `Diapositiva ${index + 1} del curso de operadores de interior`,
                  })
                  .eq('id', slide.id)
                  .select('id')
                  .single()
              }),
            )
            const errors = updates
              .map((result) => result.error?.message)
              .filter(Boolean)
            if (errors.length) return json({ errors }, 500)
            return json({ ok: true, start, updated: selected.length })
          }

          if (operation === 'finalize-course') {
            const structure = await loadStructure(supabase)
            if (
              structure.modules.length !== 6 ||
              structure.segments.length !== 80 ||
              structure.slides.length !== 80 ||
              structure.quizzes.length !== 6
            ) {
              return json({ error: 'Course structure is incomplete' }, 409)
            }

            const [course, version, material, segments, quizzes] =
              await Promise.all([
                supabase
                  .from('courses')
                  .update({ status: 'published' })
                  .eq('id', COURSE_ID),
                supabase
                  .from('course_versions')
                  .update({ status: 'published' })
                  .eq('id', VERSION_ID),
                supabase
                  .from('course_materials')
                  .update({
                    title:
                      'Presentación Gamma · Operadores de arranque/carga y perforación/voladura en interior',
                    storage_path: PRESENTATION_PATH,
                    external_url: null,
                    file_name:
                      'presentacion-operadores-interior-20h-et-2002-1-08-gamma-v1.1.pdf',
                    mime_type: 'application/pdf',
                    file_size: 1640813,
                    page_count: 80,
                    is_published: true,
                    downloadable: false,
                  })
                  .eq('id', PRESENTATION_ID),
                supabase
                  .from('lesson_audio_segments')
                  .update({ published: true })
                  .in(
                    'id',
                    structure.segments.map((segment) => segment.id),
                  ),
                supabase
                  .from('quizzes')
                  .update({ required_perfect_streak: 2, active: true })
                  .in(
                    'id',
                    structure.quizzes.map((quiz) => quiz.id),
                  ),
              ])
            const errors = [course, version, material, segments, quizzes]
              .map((result) => result.error?.message)
              .filter(Boolean)
            if (errors.length) return json({ errors }, 500)
            return json({ ok: true })
          }

          if (operation === 'verify') {
            const structure = await loadStructure(supabase)
            const [course, version, materials] = await Promise.all([
              supabase
                .from('courses')
                .select('id,slug,title,status')
                .eq('id', COURSE_ID)
                .single(),
              supabase
                .from('course_versions')
                .select(
                  'id,status,duration_hours,modality,accreditation_label,accreditation_reference',
                )
                .eq('id', VERSION_ID)
                .single(),
              supabase
                .from('course_materials')
                .select(
                  'id,kind,title,storage_path,is_published,page_count,file_size',
                )
                .eq('course_version_id', VERSION_ID),
            ])
            const errors = [course, version, materials]
              .map((result) => result.error?.message)
              .filter(Boolean)
            if (errors.length) return json({ errors }, 500)

            const slidePaths = structure.slides.map(
              (slide) => slide.image_storage_path,
            )
            return json({
              course: course.data,
              version: version.data,
              counts: {
                modules: structure.modules.length,
                lessons: structure.lessons.length,
                segments: structure.segments.length,
                publishedSegments: structure.segments.filter(
                  (segment) => segment.published,
                ).length,
                segmentsWithAudio: structure.segments.filter(
                  (segment) => segment.audio_storage_path,
                ).length,
                slides: structure.slides.length,
                gammaSlides: slidePaths.filter((path, index) =>
                  path === expectedSlidePath(index),
                ).length,
                quizzes: structure.quizzes.length,
                quizzesWithTwoPerfectRounds: structure.quizzes.filter(
                  (quiz) => quiz.active && quiz.required_perfect_streak === 2,
                ).length,
              },
              materials: materials.data,
            })
          }

          return json({ error: 'Invalid operation' }, 400)
        } catch (error) {
          return json(
            { error: error instanceof Error ? error.message : 'Unknown error' },
            500,
          )
        }
      },
    },
  },
})
