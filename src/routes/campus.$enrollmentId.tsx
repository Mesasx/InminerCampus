import { createFileRoute, Link } from '@tanstack/react-router'
import {
  CheckCircle2,
  Circle,
  FileText,
  LockKeyhole,
  PlayCircle,
} from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/campus/$enrollmentId')({
  component: CampusCoursePage,
})

type Lesson = {
  id: string
  title: string
  summary: string
  position: number
  duration_minutes: number
  kind: string
  progress?: {
    status: string
    max_video_position_seconds: number
  }
}

type Module = {
  id: string
  title: string
  description: string
  position: number
  lessons: Lesson[]
}

function CampusCoursePage() {
  const { enrollmentId } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => <CourseContent user={user} enrollmentId={enrollmentId} />}
    </ProtectedGate>
  )
}

function CourseContent({
  user,
  enrollmentId,
}: {
  user: SessionUser
  enrollmentId: string
}) {
  const [courseTitle, setCourseTitle] = useState('')
  const [modules, setModules] = useState<Module[]>([])
  const [loading, setLoading] = useState(true)
  const [notFound, setNotFound] = useState(false)

  useEffect(() => {
    let active = true

    async function load() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) return

      const { data: enrollment } = await supabase
        .from('enrollments')
        .select(
          'id, course_version_id, course_versions!inner(courses!inner(title))',
        )
        .eq('id', enrollmentId)
        .eq('user_id', user.id)
        .maybeSingle()

      if (!active) return
      if (!enrollment) {
        setNotFound(true)
        setLoading(false)
        return
      }

      const typedEnrollment = enrollment as unknown as {
        course_version_id: string
        course_versions: { courses: { title: string } }
      }
      const [{ data: moduleRows }, { data: progressRows }] = await Promise.all([
        supabase
          .from('course_modules')
          .select(
            'id, title, description, position, lessons(id, title, summary, position, duration_minutes, kind, active)',
          )
          .eq('course_version_id', typedEnrollment.course_version_id)
          .eq('lessons.active', true)
          .order('position')
          .order('position', { referencedTable: 'lessons' }),
        supabase
          .from('lesson_progress')
          .select('lesson_id, status, max_video_position_seconds')
          .eq('enrollment_id', enrollmentId),
      ])

      if (!active) return
      const progressMap = new Map(
        (progressRows ?? []).map((row) => [row.lesson_id, row]),
      )
      setCourseTitle(typedEnrollment.course_versions.courses.title)
      setModules(
        ((moduleRows ?? []) as unknown as Module[]).map((module) => ({
          ...module,
          lessons: module.lessons.map((lesson) => ({
            ...lesson,
            progress: progressMap.get(lesson.id),
          })),
        })),
      )
      setLoading(false)
    }

    void load()
    return () => {
      active = false
    }
  }, [enrollmentId, user.id])

  return (
    <AppShell user={user} title={courseTitle || 'Curso'}>
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Contenido del curso</span>
          <h1>{courseTitle || 'Tu formación'}</h1>
          <p>Las lecciones se desbloquean en el orden definido.</p>
        </div>
      </div>
      {loading ? (
        <section className="panel">
          <p className="muted">Cargando contenido…</p>
        </section>
      ) : notFound ? (
        <section className="empty-state">
          <div>
            <h2>No tienes acceso a esta matrícula</h2>
            <Link className="button button--outline" to="/mis-cursos">
              Volver a mis cursos
            </Link>
          </div>
        </section>
      ) : modules.length ? (
        <div className="form-grid">
          {modules.map((module) => (
            <section className="panel" key={module.id}>
              <div className="panel__header">
                <div>
                  <span className="status status--orange">
                    Módulo {module.position}
                  </span>
                  <h2 style={{ marginTop: 12 }}>{module.title}</h2>
                </div>
              </div>
              <div className="app-course-list">
                {module.lessons.map((lesson) => {
                  const status = lesson.progress?.status ?? 'locked'
                  const StatusIcon =
                    status === 'completed'
                      ? CheckCircle2
                      : status === 'locked'
                        ? LockKeyhole
                        : Circle
                  const LessonIcon =
                    lesson.kind === 'document' ? FileText : PlayCircle

                  return (
                    <article className="app-course" key={lesson.id}>
                      <span className="app-course__number">
                        <LessonIcon size={20} />
                      </span>
                      <div>
                        <h3>{lesson.title}</h3>
                        <p>
                          {lesson.duration_minutes} min ·{' '}
                          <StatusIcon size={13} style={{ display: 'inline' }} />{' '}
                          {status}
                        </p>
                      </div>
                      <div className="progress">
                        <div
                          className="progress__bar"
                          style={{
                            width: status === 'completed' ? '100%' : '0%',
                          }}
                        />
                      </div>
                      {status === 'locked' ? (
                        <button className="button button--outline" disabled>
                          Bloqueada
                        </button>
                      ) : (
                        <Link
                          className="button button--outline"
                          to="/campus/$enrollmentId/leccion/$lessonId"
                          params={{ enrollmentId, lessonId: lesson.id }}
                        >
                          Abrir
                        </Link>
                      )}
                    </article>
                  )
                })}
              </div>
            </section>
          ))}
        </div>
      ) : (
        <section className="empty-state">
          <p>El contenido todavía no está publicado.</p>
        </section>
      )}
    </AppShell>
  )
}
