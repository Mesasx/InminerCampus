import { createFileRoute } from '@tanstack/react-router'
import { Plus } from 'lucide-react'
import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/cursos')({
  component: AdminCoursesPage,
})

type AdminCourse = {
  id: string
  title: string
  slug: string
  specialty: string
  status: string
  updated_at: string
}

function AdminCoursesPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminCourses user={user} />}
    </ProtectedGate>
  )
}

function AdminCourses({ user }: { user: SessionUser }) {
  const [courses, setCourses] = useState<AdminCourse[]>([])
  const [title, setTitle] = useState('')
  const [slug, setSlug] = useState('')
  const [specialty, setSpecialty] = useState('')
  const [message, setMessage] = useState('')

  const load = useCallback(async () => {
    const { data } =
      (await getSupabaseBrowserClient()
        ?.from('courses')
        .select('id, title, slug, specialty, status, updated_at')
        .order('updated_at', { ascending: false })) ?? {}
    setCourses((data ?? []) as AdminCourse[])
  }, [])

  useEffect(() => {
    void load()
  }, [load])

  async function createCourse(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setMessage('')
    const normalizedSlug = (slug || title)
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '')

    const { error } =
      (await getSupabaseBrowserClient()?.from('courses').insert({
        title: title.trim(),
        slug: normalizedSlug,
        specialty: specialty.trim(),
        short_description: '',
        description: '',
        status: 'draft',
        created_by: user.id,
      })) ?? {}

    if (error) {
      setMessage('No se ha podido crear el curso. Comprueba el identificador.')
      return
    }
    setTitle('')
    setSlug('')
    setSpecialty('')
    setMessage('Curso creado como borrador.')
    await load()
  }

  return (
    <AppShell user={user} mode="admin" title="Cursos">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Gestión de contenidos</span>
          <h1>Cursos.</h1>
          <p>Crea el contenedor y completa después sus versiones y lecciones.</p>
        </div>
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'minmax(0,1fr) minmax(320px,.65fr)',
          gap: 24,
          alignItems: 'start',
        }}
      >
        <section className="panel">
          <div className="panel__header">
            <h2>Listado</h2>
            <span className="status">{courses.length} cursos</span>
          </div>
          <div className="app-course-list">
            {courses.map((course, index) => (
              <article className="app-course" key={course.id}>
                <span className="app-course__number">
                  {String(index + 1).padStart(2, '0')}
                </span>
                <div>
                  <h3>{course.title}</h3>
                  <p>{course.specialty}</p>
                </div>
                <span className="status">{course.status}</span>
                <a
                  className="button button--outline"
                  href={`/admin/cursos/${course.id}`}
                >
                  Editar
                </a>
              </article>
            ))}
          </div>
        </section>
        <section className="panel">
          <div className="panel__header">
            <h2>Nuevo curso</h2>
            <Plus color="var(--orange)" />
          </div>
          <form className="form-grid" onSubmit={createCourse}>
            {message ? <div className="alert alert--info">{message}</div> : null}
            <div className="field">
              <label htmlFor="course-title">Nombre</label>
              <input
                id="course-title"
                minLength={3}
                required
                value={title}
                onChange={(event) => setTitle(event.target.value)}
              />
            </div>
            <div className="field">
              <label htmlFor="course-slug">Identificador URL</label>
              <input
                id="course-slug"
                placeholder="Se genera desde el nombre"
                value={slug}
                onChange={(event) => setSlug(event.target.value)}
              />
            </div>
            <div className="field">
              <label htmlFor="course-specialty">Especialidad</label>
              <input
                id="course-specialty"
                minLength={2}
                required
                value={specialty}
                onChange={(event) => setSpecialty(event.target.value)}
              />
            </div>
            <button className="button button--primary" type="submit">
              Crear borrador
            </button>
          </form>
        </section>
      </div>
    </AppShell>
  )
}
