import { createFileRoute, Link } from '@tanstack/react-router'
import { FileDown, PlayCircle, ShieldCheck } from 'lucide-react'
import { useEffect, useState } from 'react'
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
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    void Promise.all([
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
    ]).then(([{ data: lessonRow }, { data: progress }]) => {
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
      }
      setLoading(false)
    })
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
          {['video', 'mixed'].includes(lesson.kind) ? (
            <section
              className="panel"
              style={{
                display: 'grid',
                minHeight: 390,
                placeItems: 'center',
                background: '#292b27',
                color: 'white',
                textAlign: 'center',
              }}
            >
              <div>
                <PlayCircle size={48} color="#e97824" />
                <h2 style={{ marginTop: 18 }}>Vídeo pendiente de publicación</h2>
                <p style={{ color: 'rgba(255,255,255,.6)', maxWidth: 520 }}>
                  El reproductor trazable se activará cuando el administrador
                  publique el recurso audiovisual de esta lección.
                </p>
              </div>
            </section>
          ) : null}
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
          {lesson.quizId ? (
            <section className="panel">
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Evaluación</span>
                  <h2>Demuestra lo aprendido</h2>
                </div>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                La siguiente lección se desbloqueará al cumplir la racha perfecta
                configurada para este test.
              </p>
              <Link
                className="button button--primary"
                to="/evaluacion/$enrollmentId/$quizId"
                params={{ enrollmentId, quizId: lesson.quizId }}
              >
                Abrir evaluación
              </Link>
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
