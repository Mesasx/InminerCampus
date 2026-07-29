import { createFileRoute, Link } from '@tanstack/react-router'
import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/cursos/$courseId')({
  component: CourseEditorPage,
})

type Course = {
  id: string
  title: string
  short_description: string
  description: string
  specialty: string
  status: string
}

type Version = {
  id: string
  version_number: number
  duration_hours: number
  modality: string
  status: string
  price_net: number | null
}

function CourseEditorPage() {
  const { courseId } = Route.useParams()
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <CourseEditor user={user} courseId={courseId} />}
    </ProtectedGate>
  )
}

function CourseEditor({
  user,
  courseId,
}: {
  user: SessionUser
  courseId: string
}) {
  const [course, setCourse] = useState<Course | null>(null)
  const [versions, setVersions] = useState<Version[]>([])
  const [duration, setDuration] = useState<'5' | '20'>('5')
  const [modality, setModality] = useState('hybrid')
  const [price, setPrice] = useState('')
  const [message, setMessage] = useState('')

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [{ data: courseRow }, { data: versionRows }] = await Promise.all([
      supabase
        .from('courses')
        .select(
          'id, title, short_description, description, specialty, status',
        )
        .eq('id', courseId)
        .maybeSingle(),
      supabase
        .from('course_versions')
        .select(
          'id, version_number, duration_hours, modality, status, price_net',
        )
        .eq('course_id', courseId)
        .order('version_number', { ascending: false }),
    ])
    setCourse(courseRow as Course | null)
    setVersions((versionRows ?? []) as Version[])
  }, [courseId])

  useEffect(() => {
    void load()
  }, [load])

  async function saveCourse(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!course) return
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('courses')
        .update({
          title: course.title.trim(),
          short_description: course.short_description.trim(),
          description: course.description.trim(),
          specialty: course.specialty.trim(),
        })
        .eq('id', course.id)) ?? {}
    setMessage(error ? 'No se ha podido guardar.' : 'Curso actualizado.')
    if (!error) await load()
  }

  async function createVersion(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const nextNumber = Math.max(0, ...versions.map((item) => item.version_number)) + 1
    const { error } =
      (await getSupabaseBrowserClient()?.from('course_versions').insert({
        course_id: courseId,
        version_number: nextNumber,
        duration_hours: Number(duration),
        modality,
        price_net: price ? Number(price) : null,
        status: 'draft',
        created_by: user.id,
      })) ?? {}
    setMessage(error ? 'No se ha podido crear la versión.' : 'Versión creada.')
    if (!error) {
      setPrice('')
      await load()
    }
  }

  return (
    <AppShell user={user} mode="admin" title="Editor de curso">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Editor</span>
          <h1>{course?.title || 'Curso'}.</h1>
        </div>
        <Link className="button button--outline" to="/admin/cursos">
          Volver
        </Link>
      </div>
      {message ? (
        <div className="alert alert--info" style={{ marginBottom: 20 }}>
          {message}
        </div>
      ) : null}
      {course ? (
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'minmax(0,1fr) minmax(330px,.65fr)',
            gap: 24,
            alignItems: 'start',
          }}
        >
          <section className="panel">
            <div className="panel__header">
              <h2>Información general</h2>
              <span className="status">{course.status}</span>
            </div>
            <form className="form-grid" onSubmit={saveCourse}>
              <div className="field">
                <label htmlFor="edit-title">Nombre</label>
                <input
                  id="edit-title"
                  required
                  value={course.title}
                  onChange={(event) =>
                    setCourse({ ...course, title: event.target.value })
                  }
                />
              </div>
              <div className="field">
                <label htmlFor="edit-specialty">Especialidad</label>
                <input
                  id="edit-specialty"
                  required
                  value={course.specialty}
                  onChange={(event) =>
                    setCourse({ ...course, specialty: event.target.value })
                  }
                />
              </div>
              <div className="field">
                <label htmlFor="edit-short">Resumen</label>
                <textarea
                  id="edit-short"
                  value={course.short_description}
                  onChange={(event) =>
                    setCourse({
                      ...course,
                      short_description: event.target.value,
                    })
                  }
                />
              </div>
              <div className="field">
                <label htmlFor="edit-description">Descripción</label>
                <textarea
                  id="edit-description"
                  value={course.description}
                  onChange={(event) =>
                    setCourse({ ...course, description: event.target.value })
                  }
                />
              </div>
              <button className="button button--primary" type="submit">
                Guardar curso
              </button>
            </form>
          </section>
          <div className="form-grid">
            <section className="panel">
              <div className="panel__header">
                <h2>Versiones</h2>
              </div>
              <div className="form-grid">
                {versions.map((version) => (
                  <article className="stat-card" key={version.id}>
                    <strong>Versión {version.version_number}</strong>
                    <p className="muted" style={{ margin: '7px 0 0' }}>
                      {version.duration_hours} h · {version.modality} ·{' '}
                      {version.status}
                    </p>
                  </article>
                ))}
              </div>
            </section>
            <section className="panel">
              <div className="panel__header">
                <h2>Nueva versión</h2>
              </div>
              <form className="form-grid" onSubmit={createVersion}>
                <div className="field">
                  <label htmlFor="version-duration">Duración</label>
                  <select
                    id="version-duration"
                    value={duration}
                    onChange={(event) =>
                      setDuration(event.target.value as '5' | '20')
                    }
                  >
                    <option value="5">5 horas</option>
                    <option value="20">20 horas</option>
                  </select>
                </div>
                <div className="field">
                  <label htmlFor="version-modality">Modalidad</label>
                  <select
                    id="version-modality"
                    value={modality}
                    onChange={(event) => setModality(event.target.value)}
                  >
                    <option value="online">Online</option>
                    <option value="hybrid">Híbrida</option>
                    <option value="in_person">Presencial</option>
                  </select>
                </div>
                <div className="field">
                  <label htmlFor="version-price">Precio neto (opcional)</label>
                  <input
                    id="version-price"
                    inputMode="decimal"
                    min="0"
                    step="0.01"
                    type="number"
                    value={price}
                    onChange={(event) => setPrice(event.target.value)}
                  />
                </div>
                <button className="button button--primary" type="submit">
                  Crear versión
                </button>
              </form>
            </section>
          </div>
        </div>
      ) : (
        <section className="empty-state">
          <p>Curso no encontrado o sin permisos.</p>
        </section>
      )}
    </AppShell>
  )
}
