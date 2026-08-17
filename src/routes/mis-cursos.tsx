import { createFileRoute, Link } from '@tanstack/react-router'
import { BookOpenCheck, Clock3, GraduationCap } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProgressBar } from '../components/ProgressBar'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { CourseModality, EnrollmentCard, SessionUser } from '../lib/types'

const statusLabels: Record<string, string> = {
  active: 'En curso',
  completed: 'Finalizado',
  expired: 'Caducado',
  failed: 'No superado',
}

export const Route = createFileRoute('/mis-cursos')({
  component: MyCoursesPage,
})

type EnrollmentRow = {
  id: string
  status: string
  progress_percent: number | string
  enrolled_at: string
  course_versions: {
    duration_hours: number
    modality: CourseModality
    courses: {
      slug: string
      title: string
    }
  }
}

function MyCoursesPage() {
  return (
    <ProtectedGate>
      {(user) => <MyCoursesDashboard user={user} />}
    </ProtectedGate>
  )
}

function MyCoursesDashboard({ user }: { user: SessionUser }) {
  const [enrollments, setEnrollments] = useState<EnrollmentCard[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true

    async function load() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) return

      const { data } = await supabase
        .from('enrollments')
        .select(
          'id, status, progress_percent, enrolled_at, course_versions!inner(duration_hours, modality, courses!inner(slug, title))',
        )
        .eq('user_id', user.id)
        .order('enrolled_at', { ascending: false })

      if (!active) return
      setEnrollments(
        ((data ?? []) as unknown as EnrollmentRow[]).map((row) => ({
          id: row.id,
          status: row.status,
          progress_percent: Number(row.progress_percent),
          enrolled_at: row.enrolled_at,
          course: {
            ...row.course_versions.courses,
            duration_hours: row.course_versions.duration_hours,
            modality: row.course_versions.modality,
          },
        })),
      )
      setLoading(false)
    }

    void load()
    return () => {
      active = false
    }
  }, [user.id])

  const activeCourses = enrollments.filter(
    (item) => !['completed', 'expired', 'failed'].includes(item.status),
  )
  const completedCourses = enrollments.filter(
    (item) => item.status === 'completed',
  )
  const averageProgress = activeCourses.length
    ? Math.round(
        activeCourses.reduce((sum, item) => sum + item.progress_percent, 0) /
          activeCourses.length,
      )
    : 0

  return (
    <AppShell user={user} title="Mis cursos">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Área del alumno</span>
          <h1>Hola{user.firstName ? `, ${user.firstName}` : ''}.</h1>
          <p>Continúa tu formación desde el último punto registrado.</p>
        </div>
        <Link className="button button--primary" to="/catalogo">
          Explorar cursos
        </Link>
      </div>

      {activeCourses[0] ? (
        <section className="continue-course">
          <div>
            <span className="label-industrial">Continuar formación</span>
            <h2>{activeCourses[0].course.title}</h2>
            <ProgressBar percent={activeCourses[0].progress_percent} />
          </div>
          <Link
            className="button button--primary button--continue"
            to="/campus/$enrollmentId"
            params={{ enrollmentId: activeCourses[0].id }}
          >
            Continuar curso
          </Link>
        </section>
      ) : null}

      <section className="stats-grid" aria-label="Resumen de formación">
        <article className="stat-card">
          <span className="stat-card__label">Cursos activos</span>
          <span className="stat-card__value">{activeCourses.length}</span>
        </article>
        <article className="stat-card">
          <span className="stat-card__label">Progreso medio</span>
          <span className="stat-card__value">{averageProgress}%</span>
        </article>
        <article className="stat-card">
          <span className="stat-card__label">Completados</span>
          <span className="stat-card__value">{completedCourses.length}</span>
        </article>
        <article className="stat-card">
          <span className="stat-card__label">Total matriculado</span>
          <span className="stat-card__value">{enrollments.length}</span>
        </article>
      </section>

      <section className="panel">
        <div className="panel__header">
          <h2>Tu formación</h2>
          <span className="status">
            <Clock3 size={14} /> Datos actualizados
          </span>
        </div>
        {loading ? (
          <p className="muted">Cargando tus matrículas…</p>
        ) : enrollments.length ? (
          <div className="app-course-list">
            {enrollments.map((enrollment, index) => (
              <article className="app-course" key={enrollment.id}>
                <span className="app-course__number">
                  {String(index + 1).padStart(2, '0')}
                </span>
                <div>
                  <h3>{enrollment.course.title}</h3>
                  <p>
                    {enrollment.course.duration_hours} h ·{' '}
                    {statusLabels[enrollment.status] ?? enrollment.status}
                  </p>
                </div>
                <ProgressBar percent={enrollment.progress_percent} />
                <Link
                  className="button button--outline"
                  to="/campus/$enrollmentId"
                  params={{ enrollmentId: enrollment.id }}
                >
                  Continuar
                </Link>
              </article>
            ))}
          </div>
        ) : (
          <div className="empty-state">
            <div>
              <div className="empty-state__icon">
                <GraduationCap size={25} />
              </div>
              <h2>Aún no tienes cursos asignados</h2>
              <p>
                Puedes matricularte desde el catálogo o canjear el código que te
                haya facilitado tu empresa.
              </p>
              <div className="empty-state__actions">
                <Link className="button button--primary" to="/catalogo">
                  <BookOpenCheck size={18} /> Ver catálogo
                </Link>
                <Link className="button button--outline" to="/canjear-codigo">
                  Canjear código
                </Link>
              </div>
            </div>
          </div>
        )}
      </section>
    </AppShell>
  )
}
