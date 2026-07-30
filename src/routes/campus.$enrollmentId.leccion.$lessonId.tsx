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
}

type LessonData = {
  id: string
  title: string
  summary: string
  kind: string
  duration_minutes: number
  resources: Resource[]
  quizId: string | null
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

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    void (async () => {
      const [
        { data: lessonRow },
        { data: progress },
        { data: segmentRows },
      ] = await Promise.all([
        supabase
          .from('lessons')
          .select(
            'id, title, summary, kind, duration_minutes, lesson_resources(id, kind, title, storage_path, external_url, downloadable), quizzes(id)',
          )
          .eq('id', lessonId)
          .maybeSingle(),
        supabase
          .from('lesson_progress')
          .select('status')
          .eq('enrollment_id', enrollmentId)
          .eq('lesson_id', lessonId)
          .maybeSingle(),
        supabase
          .from('lesson_audio_segments')
          .select(
            'id, position, title, narration_text, audio_storage_path, audio_external_url, duration_seconds, lesson_segment_slides(id, position, title, body, image_storage_path, image_external_url), lesson_audio_progress(max_position_seconds, completed_at)',
          )
          .eq('lesson_id', lessonId)
          .eq('published', true)
          .eq('lesson_audio_progress.enrollment_id', enrollmentId)
          .order('position', { ascending: true }),
      ])

      if (lessonRow && progress && progress.status !== 'locked') {
        const row = lessonRow as unknown as {
          id: string
          title: string
          summary: string
          kind: string
          duration_minutes: number
          lesson_resources: Resource[]
          quizzes: Array<{ id: string }>
        }
        setLesson({
          id: row.id,
          title: row.title,
          summary: row.summary,
          kind: row.kind,
          duration_minutes: row.duration_minutes,
          resources: row.lesson_resources,
          quizId: row.quizzes[0]?.id ?? null,
          progressStatus: progress.status,
        })

        const resolved = await resolveSegments(
          supabase,
          segmentRows ?? [],
        )
        setSegments(resolved.filter((segment) => Boolean(segment.audioUrl)))
        setAudioCompleted(
          resolved.length > 0
            ? resolved.every((segment) => segment.completed)
            : progress.status === 'completed',
        )
      }
      setLoading(false)
    })()
  }, [enrollmentId, lessonId])

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
          />
          {lesson.resources.length ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Materiales</h2>
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
                    {resource.external_url ? (
                      <a
                        className="button button--outline"
                        href={resource.external_url}
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
          {lesson.quizId && audioCompleted ? (
            <section className="panel">
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Evaluación</span>
                  <h2>Demuestra lo aprendido</h2>
                </div>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                La siguiente lección se desbloqueará al cumplir la racha
                perfecta configurada para este test.
              </p>
              <Link
                className="button button--primary"
                to="/evaluacion/$enrollmentId/$quizId"
                params={{ enrollmentId, quizId: lesson.quizId }}
              >
                Abrir evaluación
              </Link>
            </section>
          ) : lesson.quizId ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Evaluación bloqueada</h2>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                Completa los cinco audios en orden para abrir la evaluación.
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
        slides,
      }
    }),
  )
}
