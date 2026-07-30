import { createFileRoute } from '@tanstack/react-router'
import {
  CalendarPlus,
  CheckCircle2,
  MapPin,
  UserPlus,
  UsersRound,
} from 'lucide-react'
import {
  useCallback,
  useEffect,
  useState,
  type FormEvent,
} from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/practicas')({
  component: AdminPracticesPage,
})

type Version = {
  id: string
  version_number: number
  courses: { title: string }
}

type Session = {
  id: string
  course_version_id: string
  title: string
  venue_name: string
  starts_at: string
  ends_at: string
  status: string
}

type Attendance = {
  id: string
  practice_session_id: string
  enrollment_id: string
  result: string
  observations: string | null
}

type Enrollment = {
  id: string
  user_id: string
  course_version_id: string
}

type Profile = {
  id: string
  email: string | null
  first_name: string
  last_name: string
}

function AdminPracticesPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminPractices user={user} />}
    </ProtectedGate>
  )
}

function AdminPractices({ user }: { user: SessionUser }) {
  const [versions, setVersions] = useState<Version[]>([])
  const [sessions, setSessions] = useState<Session[]>([])
  const [attendances, setAttendances] = useState<Attendance[]>([])
  const [enrollments, setEnrollments] = useState<Enrollment[]>([])
  const [profiles, setProfiles] = useState<Profile[]>([])
  const [versionId, setVersionId] = useState('')
  const [selectedSessionId, setSelectedSessionId] = useState<string | null>(null)
  const [title, setTitle] = useState('')
  const [venue, setVenue] = useState('')
  const [address, setAddress] = useState('')
  const [startsAt, setStartsAt] = useState('')
  const [endsAt, setEndsAt] = useState('')
  const [notice, setNotice] = useState('')

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [
      { data: versionRows },
      { data: sessionRows },
      { data: attendanceRows },
      { data: enrollmentRows },
      { data: profileRows },
    ] = await Promise.all([
      supabase
        .from('course_versions')
        .select('id, version_number, courses(title)')
        .order('created_at', { ascending: false }),
      supabase
        .from('practice_sessions')
        .select(
          'id, course_version_id, title, venue_name, starts_at, ends_at, status',
        )
        .order('starts_at', { ascending: false }),
      supabase
        .from('practice_attendance')
        .select(
          'id, practice_session_id, enrollment_id, result, observations',
        ),
      supabase
        .from('enrollments')
        .select('id, user_id, course_version_id'),
      supabase
        .from('profiles')
        .select('id, email, first_name, last_name'),
    ])
    const nextVersions = (versionRows ?? []) as unknown as Version[]
    const nextSessions = (sessionRows ?? []) as Session[]
    setVersions(nextVersions)
    setSessions(nextSessions)
    setAttendances((attendanceRows ?? []) as Attendance[])
    setEnrollments((enrollmentRows ?? []) as Enrollment[])
    setProfiles((profileRows ?? []) as Profile[])
    setVersionId((current) => current || nextVersions[0]?.id || '')
    setSelectedSessionId((current) =>
      current && nextSessions.some((session) => session.id === current)
        ? current
        : nextSessions[0]?.id ?? null,
    )
  }, [])

  useEffect(() => {
    void load()
  }, [load])

  const selected = sessions.find((session) => session.id === selectedSessionId)
  const sessionAttendances = attendances.filter(
    (attendance) => attendance.practice_session_id === selectedSessionId,
  )

  async function createSession(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (new Date(endsAt) <= new Date(startsAt)) {
      setNotice('La hora de fin debe ser posterior a la de inicio.')
      return
    }
    const { data, error } =
      (await getSupabaseBrowserClient()
        ?.from('practice_sessions')
        .insert({
          course_version_id: versionId,
          title: title.trim(),
          venue_name: venue.trim(),
          venue_address: address.trim(),
          starts_at: new Date(startsAt).toISOString(),
          ends_at: new Date(endsAt).toISOString(),
          tutor_user_id: user.id,
          status: 'scheduled',
          created_by: user.id,
        })
        .select('id')
        .single()) ?? {}
    setNotice(
      error ? 'No se ha podido programar la práctica.' : 'Práctica programada.',
    )
    if (!error && data) {
      setTitle('')
      setVenue('')
      setAddress('')
      setStartsAt('')
      setEndsAt('')
      setSelectedSessionId(data.id)
      await load()
    }
  }

  async function addEnrolledStudents() {
    if (!selected) return
    const existing = new Set(
      sessionAttendances.map((attendance) => attendance.enrollment_id),
    )
    const rows = enrollments
      .filter(
        (enrollment) =>
          enrollment.course_version_id === selected.course_version_id &&
          !existing.has(enrollment.id),
      )
      .map((enrollment) => ({
        practice_session_id: selected.id,
        enrollment_id: enrollment.id,
        result: 'scheduled',
      }))
    if (!rows.length) {
      setNotice('No hay nuevas matrículas que añadir a esta sesión.')
      return
    }
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('practice_attendance')
        .insert(rows)) ?? {}
    setNotice(
      error
        ? 'No se han podido añadir los alumnos.'
        : `${rows.length} alumnos añadidos a la práctica.`,
    )
    if (!error) await load()
  }

  async function validate(attendance: Attendance, result: string) {
    const isFinal = ['passed', 'failed'].includes(result)
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('practice_attendance')
        .update({
          result,
          checked_in_at:
            ['present', 'passed', 'failed'].includes(result)
              ? new Date().toISOString()
              : null,
          validated_by: isFinal ? user.id : null,
          validated_at: isFinal ? new Date().toISOString() : null,
        })
        .eq('id', attendance.id)) ?? {}
    setNotice(
      error
        ? 'No se ha podido guardar la validación.'
        : 'Resultado de la práctica actualizado.',
    )
    if (!error) await load()
  }

  function learnerFor(attendance: Attendance) {
    const enrollment = enrollments.find(
      (item) => item.id === attendance.enrollment_id,
    )
    return profiles.find((profile) => profile.id === enrollment?.user_id)
  }

  return (
    <AppShell user={user} mode="admin" title="Prácticas">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Formación presencial</span>
          <h1>Prácticas y validaciones.</h1>
          <p>Programa sesiones, asigna alumnos y registra el resultado.</p>
        </div>
      </div>
      {notice ? <div className="alert alert--info">{notice}</div> : null}
      <div className="admin-split">
        <div className="form-grid">
          <section className="panel">
            <div className="panel__header">
              <h2>Sesiones</h2>
              <UsersRound color="var(--orange)" />
            </div>
            <div className="admin-list">
              {sessions.map((session) => (
                <button
                  className={
                    selectedSessionId === session.id
                      ? 'admin-list__item is-active'
                      : 'admin-list__item'
                  }
                  key={session.id}
                  onClick={() => setSelectedSessionId(session.id)}
                  type="button"
                >
                  <span className="app-course__number">
                    <MapPin size={18} />
                  </span>
                  <span>
                    <strong>{session.title}</strong>
                    <small>
                      {new Date(session.starts_at).toLocaleString('es-ES')} ·{' '}
                      {session.venue_name}
                    </small>
                  </span>
                  <span className="status">{session.status}</span>
                </button>
              ))}
            </div>
          </section>
          <section className="panel">
            <div className="panel__header">
              <h2>Nueva práctica</h2>
              <CalendarPlus color="var(--orange)" />
            </div>
            <form className="form-grid" onSubmit={createSession}>
              <div className="field">
                <label htmlFor="practice-version">Curso y versión</label>
                <select
                  id="practice-version"
                  required
                  value={versionId}
                  onChange={(event) => setVersionId(event.target.value)}
                >
                  {versions.map((version) => (
                    <option key={version.id} value={version.id}>
                      {version.courses.title} · versión {version.version_number}
                    </option>
                  ))}
                </select>
              </div>
              <div className="field">
                <label htmlFor="practice-title">Nombre</label>
                <input
                  id="practice-title"
                  minLength={2}
                  required
                  value={title}
                  onChange={(event) => setTitle(event.target.value)}
                />
              </div>
              <div className="field">
                <label htmlFor="practice-venue">Centro o instalación</label>
                <input
                  id="practice-venue"
                  required
                  value={venue}
                  onChange={(event) => setVenue(event.target.value)}
                />
              </div>
              <div className="field">
                <label htmlFor="practice-address">Dirección</label>
                <input
                  id="practice-address"
                  value={address}
                  onChange={(event) => setAddress(event.target.value)}
                />
              </div>
              <div className="content-editor__row">
                <div className="field">
                  <label htmlFor="practice-start">Inicio</label>
                  <input
                    id="practice-start"
                    required
                    type="datetime-local"
                    value={startsAt}
                    onChange={(event) => setStartsAt(event.target.value)}
                  />
                </div>
                <div className="field">
                  <label htmlFor="practice-end">Fin</label>
                  <input
                    id="practice-end"
                    required
                    type="datetime-local"
                    value={endsAt}
                    onChange={(event) => setEndsAt(event.target.value)}
                  />
                </div>
              </div>
              <button className="button button--primary" type="submit">
                Programar práctica
              </button>
            </form>
          </section>
        </div>

        <section className="panel admin-detail">
          {selected ? (
            <>
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Validación</span>
                  <h2>{selected.title}</h2>
                </div>
                <button
                  className="button button--outline"
                  onClick={addEnrolledStudents}
                  type="button"
                >
                  <UserPlus size={17} /> Añadir matriculados
                </button>
              </div>
              <p className="muted">
                {new Date(selected.starts_at).toLocaleString('es-ES')} ·{' '}
                {selected.venue_name}
              </p>
              {sessionAttendances.length ? (
                <div className="practice-roster">
                  {sessionAttendances.map((attendance) => {
                    const learner = learnerFor(attendance)
                    return (
                      <article
                        className="practice-roster__item"
                        key={attendance.id}
                      >
                        <div>
                          <strong>
                            {[learner?.first_name, learner?.last_name]
                              .filter(Boolean)
                              .join(' ') || 'Alumno'}
                          </strong>
                          <small>{learner?.email ?? 'Sin correo visible'}</small>
                        </div>
                        <select
                          aria-label={`Resultado de ${learner?.email ?? 'alumno'}`}
                          value={attendance.result}
                          onChange={(event) =>
                            validate(attendance, event.target.value)
                          }
                        >
                          <option value="scheduled">Programada</option>
                          <option value="present">Presente</option>
                          <option value="absent">Ausente</option>
                          <option value="pending_validation">
                            Pendiente de validar
                          </option>
                          <option value="passed">Apta</option>
                          <option value="failed">No apta</option>
                        </select>
                        {attendance.result === 'passed' ? (
                          <CheckCircle2 color="var(--orange)" />
                        ) : null}
                      </article>
                    )
                  })}
                </div>
              ) : (
                <div className="empty-state">
                  <p>
                    Añade las matrículas de este curso para pasar lista y
                    validar resultados.
                  </p>
                </div>
              )}
            </>
          ) : (
            <div className="empty-state">
              <p>Programa o selecciona una práctica.</p>
            </div>
          )}
        </section>
      </div>
    </AppShell>
  )
}
