import { createFileRoute, Link } from '@tanstack/react-router'
import { FileDown, ShieldCheck } from 'lucide-react'
import { useEffect, useState } from 'react'
import {
  AudioLessonPlayer,
  type LessonAudioSegment,
} from '../components/AudioLessonPlayer'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute(
  '/campus/$enrollmentId/leccion/$lessonId',
)({
  component: LessonPage,
})

type Resource = {
  id: string
  kind: string
  title: string
  storage_path: string | null
  external_url: string | null
  downloadable: boolean
  resolvedUrl: string
}

type LessonData = {
  id: string
  title: string
  summary: string
  kind: string
  duration_minutes: number
  resources: Resource[]
  quiz: {
    id: string
    questionCount: number
    requiredPerfectRounds: number
    completionMode: 'consecutive_perfect' | 'cumulative_perfect'
  } | null
  progressStatus: string
}

function LessonPage() {
  const { enrollmentId, lessonId } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => (
        <Lesson
          user={user}
          enrollmentId={enrollmentId}
          lessonId={lessonId}
        />
      )}
    </ProtectedGate>
  )
}

function Lesson({
  user,
  enrollmentId,
  lessonId,
}: {
  user: SessionUser
  enrollmentId: string
  lessonId: string
}) {
  const [lesson, setLesson] = useState<LessonData | null>(null)
  const [segments, setSegments] = useState<LessonAudioSegment[]>([])
  const [audioCompleted, setAudioCompleted] = useState(false)
  const [loading, setLoading] = useState(true)
  const isAdministrator = user.roles.some((role) =>
    ['administrador', 'superadministrador'].includes(role),
  )

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    void (async () => {
      let segmentRequest = supabase
        .from('lesson_audio_segments')
        .select(
          'id, position, title, narration_text, audio_storage_path, audio_external_url, duration_seconds, lesson_segment_slides(id, position, title, body, image_storage_path, image_external_url, source_label, source_page, alt_text), lesson_segment_notes(summary, key_points, source_label, source_pages), lesson_audio_progress(max_position_seconds, completed_at)',
        )
        .eq('lesson_id', lessonId)
        .eq('lesson_audio_progress.enrollment_id', enrollmentId)
        .order('position', { ascending: true })

      if (!isAdministrator) {
        segmentRequest = segmentRequest.eq('published', true)
      }

      const [
        { data: lessonRow },
        { data: progress },
        { data: segmentRows },
      ] = await Promise.all([
        supabase
          .from('lessons')
          .select(
            'id, title, summary, kind, duration_minutes, lesson_resources(id, kind, title, storage_path, external_url, downloadable), quizzes(id, question_count, required_perfect_streak, completion_mode)',
          )
          .eq('id', lessonId)
          .maybeSingle(),
        supabase
          .from('lesson_progress')
          .select('status')
          .eq('enrollment_id', enrollmentId)
          .eq('lesson_id', lessonId)
          .maybeSingle(),
        segmentRequest,
      ])

      if (
        lessonRow &&
        (isAdministrator || (progress && progress.status !== 'locked'))
      ) {
        const row = lessonRow as unknown as {
          id: string
          title: string
          summary: string
          kind: string
          duration_minutes: number
          lesson_resources: Resource[]
          quizzes: Array<{
            id: string
            question_count: number
            required_perfect_streak: number
            completion_mode: 'consecutive_perfect' | 'cumulative_perfect'
          }>
        }
        const [resolvedResources, resolved] = await Promise.all([
          resolveResources(supabase, row.lesson_resources),
          resolveSegments(supabase, segmentRows ?? []),
        ])
        setLesson({
          id: row.id,
          title: row.title,
          summary: row.summary,
          kind: row.kind,
          duration_minutes: row.duration_minutes,
          resources: resolvedResources,
          quiz: row.quizzes[0]
            ? {
                id: row.quizzes[0].id,
                questionCount: row.quizzes[0].question_count,
                requiredPerfectRounds: row.quizzes[0].required_perfect_streak,
                completionMode: row.quizzes[0].completion_mode,
              }
            : null,
          progressStatus: progress?.status ?? 'available',
        })

        setSegments(
          isAdministrator
            ? resolved
            : resolved.filter((segment) => Boolean(segment.audioUrl)),
        )
        setAudioCompleted(
          resolved.length > 0
            ? resolved.every((segment) => segment.completed)
            : progress?.status === 'completed',
        )
      }
      setLoading(false)
    })()
  }, [enrollmentId, isAdministrator, lessonId])

  return (
    <AppShell user={user} title={lesson?.title || 'Lección'}>
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Lección</span>
          <h1>{lesson?.title || 'Contenido'}</h1>
          <p>{lesson?.summary}</p>
        </div>
        <Link
          className="button button--outline"
          to="/campus/$enrollmentId"
          params={{ enrollmentId }}
        >
          Volver al curso
        </Link>
      </div>
      {loading ? (
        <section className="panel">
          <p className="muted">Cargando la lección…</p>
        </section>
      ) : lesson ? (
        <div className="form-grid">
          <AudioLessonPlayer
            enrollmentId={enrollmentId}
            initialSegments={segments}
            onLessonProgress={() => setAudioCompleted(true)}
            previewMode={isAdministrator}
          />
          {lesson.resources.length ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Materiales y documentos del bloque</h2>
              </div>
              <div className="app-course-list">
                {lesson.resources.map((resource) => (
                  <article className="app-course" key={resource.id}>
                    <span className="app-course__number">
                      <FileDown size={20} />
                    </span>
                    <div>
                      <h3>{resource.title}</h3>
                      <p>{resource.kind}</p>
                    </div>
                    <span className="status">
                      {resource.downloadable ? 'Descargable' : 'Consulta'}
                    </span>
                    {resource.resolvedUrl ? (
                      <a
                        className="button button--outline"
                        download={resource.downloadable ? '' : undefined}
                        href={resource.resolvedUrl}
                        target="_blank"
                        rel="noreferrer"
                      >
                        Abrir
                      </a>
                    ) : (
                      <button className="button button--outline" disabled>
                        Protegido
                      </button>
                    )}
                  </article>
                ))}
              </div>
            </section>
          ) : null}
          {lesson.quiz && audioCompleted ? (
            <section className="panel">
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Evaluación</span>
                  <h2>Demuestra lo aprendido</h2>
                </div>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                Responde {lesson.quiz.questionCount} preguntas. Necesitas completar{' '}
                {lesson.quiz.requiredPerfectRounds} rondas perfectas
                {lesson.quiz.completionMode === 'cumulative_perfect'
                  ? '; si fallas, conservas las ya conseguidas.'
                  : ' consecutivas.'}
              </p>
              <Link
                className="button button--primary"
                to="/evaluacion/$enrollmentId/$quizId"
                params={{ enrollmentId, quizId: lesson.quiz.id }}
              >
                Abrir evaluación
              </Link>
            </section>
          ) : lesson.quiz ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Evaluación bloqueada</h2>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                Completa las diez partes de audio en orden para abrir la evaluación.
              </p>
            </section>
          ) : null}
        </div>
      ) : (
        <section className="empty-state">
          <p>Esta lección está bloqueada o no forma parte de tu matrícula.</p>
        </section>
      )}
    </AppShell>
  )
}

async function resolveSegments(
  supabase: NonNullable<ReturnType<typeof getSupabaseBrowserClient>>,
  rows: unknown[],
): Promise<LessonAudioSegment[]> {
  const segmentRows = rows as Array<{
    id: string
    position: number
    title: string
    narration_text: string
    audio_storage_path: string | null
    audio_external_url: string | null
    duration_seconds: number
    lesson_segment_slides: Array<{
      id: string
      position: number
      title: string
      body: string
      image_storage_path: string | null
      image_external_url: string | null
      source_label: string | null
      source_page: string | null
      alt_text: string | null
    }>
    lesson_segment_notes: Array<{
      summary: string
      key_points: string[]
      source_label: string
      source_pages: string
    }>
    lesson_audio_progress: Array<{
      max_position_seconds: number
      completed_at: string | null
    }>
  }>

  return Promise.all(
    segmentRows.map(async (segment) => {
      let audioUrl = segment.audio_external_url ?? ''
      if (segment.audio_storage_path) {
        const { data } = await supabase.storage
          .from('course-materials')
          .createSignedUrl(segment.audio_storage_path, 3600)
        audioUrl = data?.signedUrl ?? ''
      }
      const slides = await Promise.all(
        (segment.lesson_segment_slides ?? [])
          .sort((a, b) => a.position - b.position)
          .map(async (slide) => {
            let imageUrl = slide.image_external_url
            if (slide.image_storage_path) {
              const { data } = await supabase.storage
                .from('course-materials')
                .createSignedUrl(slide.image_storage_path, 3600)
              imageUrl = data?.signedUrl ?? null
            }
            return {
              id: slide.id,
              position: slide.position,
              title: slide.title,
              body: slide.body,
              imageUrl,
              sourceLabel: slide.source_label,
              sourcePage: slide.source_page,
              altText: slide.alt_text ?? slide.title,
            }
          }),
      )
      const segmentProgress = segment.lesson_audio_progress?.[0]
      return {
        id: segment.id,
        position: segment.position,
        title: segment.title,
        narrationText: segment.narration_text,
        audioUrl,
        durationSeconds: segment.duration_seconds,
        maxPositionSeconds: segmentProgress?.max_position_seconds ?? 0,
        completed: Boolean(segmentProgress?.completed_at),
        note: segment.lesson_segment_notes?.[0]
          ? {
              summary: segment.lesson_segment_notes[0].summary,
              keyPoints: segment.lesson_segment_notes[0].key_points,
              sourceLabel: segment.lesson_segment_notes[0].source_label,
              sourcePages: segment.lesson_segment_notes[0].source_pages,
            }
          : null,
        slides,
      }
    }),
  )
}

async function resolveResources(
  supabase: NonNullable<ReturnType<typeof getSupabaseBrowserClient>>,
  resources: Resource[],
): Promise<Resource[]> {
  return Promise.all(
    resources.map(async (resource) => {
      if (resource.external_url) {
        return { ...resource, resolvedUrl: resource.external_url }
      }
      if (!resource.storage_path) return { ...resource, resolvedUrl: '' }
      const { data } = await supabase.storage
        .from('course-materials')
        .createSignedUrl(resource.storage_path, 3600)
      return { ...resource, resolvedUrl: data?.signedUrl ?? '' }
    }),
  )
}
