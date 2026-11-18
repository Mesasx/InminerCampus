import { createFileRoute } from '@tanstack/react-router'
import { getBearerToken, getSupabaseAdmin } from '../server/supabase-admin'

const TOKEN = 'inminer-fix-20261118-5d28c90a-f4e7-44d0-9b72-0c2d867cdad3'
const VERSION_ID = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'
const BASE_PATH = `${VERSION_ID}/tecnicos-titulados-actividades-extractivas-interior/v1-2026-11`

const uploadPaths = new Set([
  `${BASE_PATH}/audio-et-2002-1-08/slide-001.mp3`,
  `${BASE_PATH}/audio-et-2002-1-08/slide-002.mp3`,
  `${BASE_PATH}/audio-et-2002-1-08/slide-006.mp3`,
  `${BASE_PATH}/audio-et-2002-1-08/slide-009.mp3`,
  `${BASE_PATH}/audio-et-2002-1-08/slide-079.mp3`,
  `${BASE_PATH}/materials/manual-operadores-interior-20h-et-2002-1-08-v1.1.pdf`,
])

const allowedIds = {
  courses: new Set(['b6586fbf-c8eb-515a-b82c-2c54cd9f4a5b']),
  course_versions: new Set([VERSION_ID]),
  course_materials: new Set([
    '9a9528a2-261f-5a13-b640-5a74c179cb54',
    'fa73e06b-97c3-5ef9-8e7b-2d5beb5113b4',
  ]),
  lesson_audio_segments: new Set([
    'd03c6921-2fac-58c6-999f-2799e0c092a4',
    'd86aa9b6-a44f-5a01-9a0b-b0b6f4bd9a0b',
    '548a36a8-d8e0-5a49-8269-e5d36fe17738',
    '785abfe5-ce90-53a3-8564-5ed8eb9da223',
    '6a8ae087-a744-5845-8eaa-72161e335e94',
  ]),
  lesson_segment_slides: new Set([
    'fc99f059-d612-5ec7-be9a-f46e2f1dcb03',
    '5747dfaa-4de7-5326-9d18-a670d556a7c4',
    'e4ecec27-2ca5-52ac-bc54-1db1735fbe5f',
    'c0de7882-b212-5ecb-85a7-0edc7d7ce34e',
    'a0eec77c-e60f-5b80-b44b-55bef4e5c8c6',
  ]),
  lesson_segment_notes: new Set([
    '225efe0a-a6dc-51d1-8c86-8164b0e6525d',
    'da707c66-4458-504b-9992-3072c4210e16',
    '1dd50283-4f06-5b00-bb3f-ca4be06f8eb3',
    '58995a3e-61ab-5ca5-a5ea-2a522c95c301',
    '9463d6d1-300a-591d-9f4b-a9fb00be0d03',
  ]),
  questions: new Set([
    'c4a4668d-cf48-5dab-95ae-e36ed63d1bc1',
    '55a808e2-42aa-53ab-9929-fddfd8cf5a4c',
    '41642c33-67e7-5c1d-a89c-21e409de129f',
    '38651d3c-ce41-59e3-aea9-85994248cc6e',
    '90a08272-14f3-57bb-bce8-98f8525889e1',
  ]),
  question_options: new Set([
    '286ffa47-a738-557a-a69d-37765b913be3',
    '58b18993-e2b6-5507-825b-468160d68fe8',
    'c5f49b26-6260-5b83-b251-312b59704115',
    'f5d07f92-e1ac-5126-9f4d-821ec56dc44a',
    '7bb0962e-6ff6-5a68-b50d-a8260725d2c0',
  ]),
} as const

type AllowedTable = keyof typeof allowedIds

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

export const Route = createFileRoute('/api/internal/course-interior-correction')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        if (getBearerToken(request) !== TOKEN) return unauthorized()

        const url = new URL(request.url)
        const operation = url.searchParams.get('operation')
        const supabase = getSupabaseAdmin()

        if (operation === 'upload') {
          const path = url.searchParams.get('path') || ''
          if (!uploadPaths.has(path)) return json({ error: 'Invalid path' }, 400)

          const bytes = await request.arrayBuffer()
          if (!bytes.byteLength || bytes.byteLength > 3_000_000) {
            return json({ error: 'Invalid file size' }, 400)
          }

          const { error } = await supabase.storage
            .from('course-materials')
            .upload(path, bytes, {
              upsert: true,
              cacheControl: '31536000',
              contentType: path.endsWith('.pdf') ? 'application/pdf' : 'audio/mpeg',
            })
          if (error) return json({ error: error.message }, 500)
          return json({ ok: true, path, size: bytes.byteLength })
        }

        const body = (await request.json()) as Record<string, unknown>

        if (operation === 'update') {
          const table = body.table as AllowedTable
          const id = String(body.id || '')
          const values = body.values
          if (!allowedIds[table]?.has(id) || !values || typeof values !== 'object') {
            return json({ error: 'Invalid update target' }, 400)
          }

          const { data, error } = await supabase
            .from(table)
            .update(values)
            .eq('id', id)
            .select('id')
            .single()
          if (error) return json({ error: error.message, table, id }, 500)
          return json({ ok: true, table, id: data.id })
        }

        if (operation === 'labels') {
          const segmentIds = body.segmentIds
          if (
            !Array.isArray(segmentIds) ||
            segmentIds.length !== 80 ||
            new Set(segmentIds).size !== 80 ||
            segmentIds.some((id) => typeof id !== 'string')
          ) {
            return json({ error: 'Invalid segment list' }, 400)
          }

          const { error: slideError } = await supabase
            .from('lesson_segment_slides')
            .update({
              source_label: 'Presentación InmínerCampus · Operadores de interior',
            })
            .in('segment_id', segmentIds)
          if (slideError) return json({ error: slideError.message }, 500)

          const { error: noteError } = await supabase
            .from('lesson_segment_notes')
            .update({
              source_label: 'Manual InmínerCampus · Operadores de interior · ET 2002-1-08',
            })
            .in('segment_id', segmentIds)
          if (noteError) return json({ error: noteError.message }, 500)
          return json({ ok: true, segments: segmentIds.length })
        }

        if (operation === 'verify') {
          const segmentIds = Array.isArray(body.segmentIds) ? body.segmentIds : []
          const lessonIds = Array.isArray(body.lessonIds) ? body.lessonIds : []
          const [course, version, segments, slides, notes, quizzes, materials] =
            await Promise.all([
              supabase
                .from('courses')
                .select('id,slug,title,specialty,cover_storage_path')
                .eq('id', 'b6586fbf-c8eb-515a-b82c-2c54cd9f4a5b')
                .single(),
              supabase
                .from('course_versions')
                .select('id,modality,accreditation_label,accreditation_reference')
                .eq('id', VERSION_ID)
                .single(),
              supabase
                .from('lesson_audio_segments')
                .select('id,title,audio_storage_path,duration_seconds')
                .in('id', segmentIds),
              supabase
                .from('lesson_segment_slides')
                .select('id,title,image_storage_path,source_label')
                .in('segment_id', segmentIds),
              supabase
                .from('lesson_segment_notes')
                .select('id,source_label,approved')
                .in('segment_id', segmentIds),
              supabase
                .from('quizzes')
                .select('id,lesson_id,question_count,required_perfect_streak,active')
                .in('lesson_id', lessonIds),
              supabase
                .from('course_materials')
                .select('id,title,storage_path,is_published,page_count')
                .eq('course_version_id', VERSION_ID),
            ])

          const errors = [course, version, segments, slides, notes, quizzes, materials]
            .map((result) => result.error?.message)
            .filter(Boolean)
          if (errors.length) return json({ errors }, 500)

          return json({
            course: course.data,
            version: version.data,
            counts: {
              segments: segments.data?.length || 0,
              slides: slides.data?.length || 0,
              notes: notes.data?.length || 0,
              quizzes: quizzes.data?.length || 0,
            },
            targetSegments: (segments.data || []).filter((segment) =>
              allowedIds.lesson_audio_segments.has(segment.id),
            ),
            targetSlides: (slides.data || []).filter((slide) =>
              allowedIds.lesson_segment_slides.has(slide.id),
            ),
            quizzes: quizzes.data,
            materials: materials.data,
          })
        }

        return json({ error: 'Invalid operation' }, 400)
      },
    },
  },
})
