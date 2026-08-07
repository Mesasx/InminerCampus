import { createFileRoute, Link } from '@tanstack/react-router'
import {
  CheckCircle2,
  Circle,
  Headphones,
  LockKeyhole,
  Presentation,
  ShieldCheck,
} from 'lucide-react'
import { useEffect, useMemo, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import {
  hasAvailableLessonContent,
  hasAvailableModuleContent,
  isPublishedAudioSegment,
  relationArray,
  type Relation,
} from '../lib/course-content'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/campus/$enrollmentId/')({
  component: CampusCoursePage,
})

type SegmentSlide = {
  id: string
}

type LessonAudioSegment = {
  id: string
  position: number
  title: string
  published: boolean
  audio_storage_path: string | null
  audio_external_url: string | null
  duration_seconds: number
  lesson_segment_slides: SegmentSlide[]
}

type LessonQuiz = {
  id: string
  title: string
  question_count: number
  passing_percent: number
  required_perfect_streak: number
  completion_mode: 'consecutive_perfect' | 'cumulative_perfect'
  active: boolean
}

type Lesson = {
  id: string
  title: string
  position: number
  lesson_audio_segments: LessonAudioSegment[]
  quizzes: LessonQuiz[]
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

type LessonAudioSegmentRow = Omit<
  LessonAudioSegment,
  'lesson_segment_slides'
> & {
  lesson_segment_slides: Relation<SegmentSlide>
}

type LessonRow = Omit<Lesson, 'lesson_audio_segments' | 'quizzes'> & {
  lesson_audio_segments: Relation<LessonAudioSegmentRow>
  quizzes: Relation<LessonQuiz>
}

type ModuleRow = Omit<Module, 'lessons'> & {
  lessons: Relation<LessonRow>
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
  const isAdministrator = user.roles.some((role) =>
    ['administrador', 'superadministrador'].includes(role),
  )

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
            'id, title, description, position, lessons(id, title, position, active, lesson_audio_segments(id, position, title, published, audio_storage_path, audio_external_url, duration_seconds, lesson_segment_slides(id)), quizzes(id, title, question_count, passing_percent, required_perfect_streak, completion_mode, active))',
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
        ((moduleRows ?? []) as unknown as ModuleRow[])
          .map((module) => ({
            ...module,
            lessons: relationArray(module.lessons)
              .map((lesson) => ({
                ...lesson,
                lesson_audio_segments: relationArray(
                  lesson.lesson_audio_segments,
                )
                  .filter(isPublishedAudioSegment)
                  .map((segment) => ({
                    ...segment,
                    lesson_segment_slides: relationArray(
                      segment.lesson_segment_slides,
                    ),
                  })),
                quizzes: relationArray(lesson.quizzes).filter(
                  (quiz) => quiz.active,
                ),
                progress: progressMap.get(lesson.id),
              }))
              .filter(hasAvailableLessonContent),
          }))
          .filter(hasAvailableModuleContent),
      )
      setLoading(false)
    }

    void load()
    return () => {
      active = false
    }
  }, [enrollmentId, user.id])

  const courseTotals = useMemo(
    () =>
      modules.reduce(
        (totals, module) => {
          module.lessons.forEach((lesson) => {
            const segments = relationArray(lesson.lesson_audio_segments)
            const quizzes = relationArray(lesson.quizzes)
            totals.audioParts += segments.length
            totals.slides += segments.reduce(
              (count, segment) =>
                count + relationArray(segment.lesson_segment_slides).length,
              0,
            )
            totals.tests += quizzes.filter((quiz) => quiz.active).length
          })
          return totals
        },
        { audioParts: 0, slides: 0, tests: 0 },
      ),
    [modules],
  )

  const finalAssessment = useMemo(
    () =>
      modules
        .flatMap((module) => module.lessons)
        .flatMap((lesson) =>
          relationArray(lesson.quizzes)
            .filter((quiz) => quiz.active)
            .map((quiz) => ({ lesson, quiz })),
        )[0],
    [modules],
  )

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
          <section className="course-content-summary">
            <article>
              <Headphones size={21} />
              <strong>{courseTotals.audioParts}</strong>
              <span>partes de audio</span>
            </article>
            <article>
              <Presentation size={21} />
              <strong>{courseTotals.slides}</strong>
              <span>diapositivas</span>
            </article>
            <article>
              <ShieldCheck size={21} />
              <strong>{courseTotals.tests}</strong>
              <span>evaluaciones</span>
            </article>
          </section>

          {finalAssessment ? (
            <section className="panel course-assessment-card">
              <div>
                <span className="eyebrow">Evaluación incluida</span>
                <h2>{finalAssessment.quiz.title}</h2>
                <p>
                  Test de {finalAssessment.quiz.question_count} preguntas al 100%.
                  Necesitas {finalAssessment.quiz.required_perfect_streak} rondas
                  perfectas
                  {finalAssessment.quiz.completion_mode === 'cumulative_perfect'
                    ? ' acumulativas.'
                    : ' consecutivas.'}{' '}
                  Se habilita al completar los audios anteriores.
                </p>
              </div>
              {isAdministrator ? (
                <Link
                  className="button button--outline"
                  to="/admin/evaluaciones"
                >
                  Revisar preguntas
                </Link>
              ) : (
                <span className="status">
                  Bloqueado hasta completar los audios
                </span>
              )}
            </section>
          ) : null}

          {modules.map((module) => (
            <section className="panel" key={module.id}>
              <div className="panel__header">
                <div>
                  <span className="status status--orange">
                    Bloque {module.position}
                  </span>
                  <h2 style={{ marginTop: 12 }}>{module.title}</h2>
                  {module.description ? <p>{module.description}</p> : null}
                </div>
              </div>
              <div className="course-lesson-list">
                {module.lessons.map((lesson) => {
                  const status = lesson.progress?.status ?? 'locked'
                  const canOpen = isAdministrator || status !== 'locked'
                  const StatusIcon =
                    status === 'completed'
                      ? CheckCircle2
                      : status === 'locked'
                        ? LockKeyhole
                        : Circle
                  const segments = relationArray(
                    lesson.lesson_audio_segments,
                  )
                  const audioMinutes = Math.max(
                    1,
                    Math.ceil(
                      segments.reduce(
                        (seconds, segment) =>
                          seconds + segment.duration_seconds,
                        0,
                      ) / 60,
                    ),
                  )
                  const quizzes = relationArray(lesson.quizzes)
                  const slideCount = segments.reduce(
                    (count, segment) =>
                      count +
                      relationArray(segment.lesson_segment_slides).length,
                    0,
                  )
                  const statusLabel = isAdministrator
                    ? 'Vista previa administrativa'
                    : status === 'completed'
                      ? 'Completada'
                      : status === 'available'
                        ? 'Disponible'
                        : status === 'in_progress'
                          ? 'En curso'
                          : 'Bloqueada'

                  return (
                    <article className="course-lesson-card" key={lesson.id}>
                      <div className="course-lesson-card__main">
                        <span className="app-course__number">
                          <Headphones size={20} />
                        </span>
                        <div className="course-lesson-card__copy">
                          <h3>{lesson.title}</h3>
                          <p>
                            Contenido disponible en {segments.length} partes de
                            audio.
                          </p>
                          <div className="course-lesson-card__meta">
                            <span>{audioMinutes} min de audio</span>
                            <span>
                              <Headphones size={14} />{' '}
                              {segments.length} audios
                            </span>
                            <span>
                              <Presentation size={14} /> {slideCount}{' '}
                              diapositivas
                            </span>
                            {quizzes.length ? (
                              <span>
                                <ShieldCheck size={14} /> Tipo test
                              </span>
                            ) : null}
                          </div>
                          <span className="course-lesson-card__status">
                            <StatusIcon size={14} /> {statusLabel}
                          </span>
                        </div>
                        {canOpen ? (
                          <Link
                            className="button button--outline"
                            to="/campus/$enrollmentId/leccion/$lessonId"
                            params={{ enrollmentId, lessonId: lesson.id }}
                          >
                            Ver contenido
                          </Link>
                        ) : (
                          <button className="button button--outline" disabled>
                            Bloqueada
                          </button>
                        )}
                      </div>
                      {segments.length ? (
                        <div className="course-lesson-card__outline">
                          {[...segments]
                            .sort((a, b) => a.position - b.position)
                            .map((segment) => (
                              <span key={segment.id}>
                                {segment.position}. {segment.title}
                              </span>
                            ))}
                        </div>
                      ) : (
                        <p className="course-lesson-card__pending">
                          El contenido se mostrará cuando el administrador
                          publique las grabaciones.
                        </p>
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
