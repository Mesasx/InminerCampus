import { createFileRoute } from '@tanstack/react-router'
import {
  BookOpenCheck,
  CheckCircle2,
  Clock3,
  Search,
  ShieldCheck,
  UserRound,
  UsersRound,
} from 'lucide-react'
import { useCallback, useEffect, useMemo, useState } from 'react'
import type { ReactNode } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/usuarios')({
  component: AdminUsersPage,
})

type AdminEnrollment = {
  id: string
  status: string
  progress_percent: number
  enrolled_at: string
  started_at: string | null
  theory_completed_at: string | null
  completed_at: string | null
  active_seconds: number
  course: {
    title: string
    slug: string
    version_number: number
    duration_hours: number
    modality: string
  }
}

type AdminUser = {
  id: string
  email: string | null
  phone: string | null
  first_name: string
  last_name: string
  dni: string | null
  status: string
  profile_exists: boolean
  registered_at: string
  email_confirmed_at: string | null
  last_sign_in_at: string | null
  first_access_at: string | null
  last_access_at: string | null
  roles: string[]
  enrollments: AdminEnrollment[]
}

function AdminUsersPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminUsers user={user} />}
    </ProtectedGate>
  )
}

function AdminUsers({ user }: { user: SessionUser }) {
  const [users, setUsers] = useState<AdminUser[]>([])
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [search, setSearch] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(true)

  const load = useCallback(async () => {
    setLoading(true)
    const token = await getAccessToken()
    if (!token) {
      setMessage('Tu sesión ha caducado. Vuelve a iniciar sesión.')
      setLoading(false)
      return
    }

    try {
      const response = await fetch('/api/admin-users', {
        headers: { Authorization: `Bearer ${token}` },
      })
      const payload = (await response.json()) as {
        users?: AdminUser[]
        error?: string
      }
      if (!response.ok || !payload.users) {
        throw new Error(payload.error ?? 'No se han podido cargar los usuarios.')
      }

      setUsers(payload.users)
      setSelectedId((current) =>
        payload.users?.some((entry) => entry.id === current)
          ? current
          : (payload.users?.[0]?.id ?? null),
      )
      setMessage('')
    } catch (error) {
      setMessage(
        error instanceof Error
          ? error.message
          : 'No se ha podido cargar el listado de usuarios.',
      )
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    void load()
  }, [load])

  const filtered = useMemo(() => {
    const term = search.trim().toLocaleLowerCase('es')
    if (!term) return users
    return users.filter((entry) =>
      [
        entry.email,
        entry.phone,
        entry.dni,
        entry.first_name,
        entry.last_name,
        accountStatusLabel(entry.status),
        ...entry.roles,
        ...entry.enrollments.flatMap((enrollment) => [
          enrollment.course.title,
          enrollmentStatusLabel(enrollment.status),
        ]),
      ]
        .filter(Boolean)
        .join(' ')
        .toLocaleLowerCase('es')
        .includes(term),
    )
  }, [search, users])

  const selected = users.find((entry) => entry.id === selectedId)
  const totalEnrollments = users.reduce(
    (total, entry) => total + entry.enrollments.length,
    0,
  )
  const completedEnrollments = users.reduce(
    (total, entry) =>
      total +
      entry.enrollments.filter(
        (enrollment) => enrollment.status === 'completed',
      ).length,
    0,
  )

  async function updateStatus(status: string) {
    if (!selected?.profile_exists) return
    const { error } =
      (await getSupabaseBrowserClient()?.rpc('admin_update_profile_status', {
        p_profile_id: selected.id,
        p_status: status,
      })) ?? {}
    setMessage(
      error
        ? 'No se ha podido cambiar el estado de la cuenta.'
        : 'Estado de la cuenta actualizado.',
    )
    if (!error) await load()
  }

  return (
    <AppShell user={user} mode="admin" title="Usuarios">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Personas y acceso</span>
          <h1>Usuarios registrados.</h1>
          <p>
            Consulta todas las cuentas del campus, sus datos personales, cursos,
            estado y tiempos de realización.
          </p>
        </div>
      </div>

      <section className="admin-user-summary" aria-label="Resumen de usuarios">
        <SummaryCard
          icon={<UsersRound size={22} />}
          label="Usuarios registrados"
          value={users.length}
        />
        <SummaryCard
          icon={<BookOpenCheck size={22} />}
          label="Matrículas"
          value={totalEnrollments}
        />
        <SummaryCard
          icon={<CheckCircle2 size={22} />}
          label="Cursos finalizados"
          value={completedEnrollments}
        />
      </section>

      {message ? <div className="alert alert--info">{message}</div> : null}
      <div className="admin-split">
        <section className="panel">
          <div className="panel__header">
            <h2>Directorio</h2>
            <span className="status">
              {filtered.length} de {users.length}
            </span>
          </div>
          <div className="field field--search">
            <label htmlFor="user-search">Buscar</label>
            <div className="field__with-icon">
              <Search size={18} />
              <input
                id="user-search"
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder="Nombre, correo, DNI, curso o estado"
              />
            </div>
          </div>
          {loading ? (
            <p className="muted">Cargando todos los usuarios…</p>
          ) : filtered.length ? (
            <div className="admin-list">
              {filtered.map((entry) => (
                <button
                  className={
                    selectedId === entry.id
                      ? 'admin-list__item is-active'
                      : 'admin-list__item'
                  }
                  key={entry.id}
                  onClick={() => setSelectedId(entry.id)}
                  type="button"
                >
                  <span className="app-course__number">
                    <UserRound size={18} />
                  </span>
                  <span className="admin-list__identity">
                    <strong>{displayName(entry)}</strong>
                    <small>{entry.email ?? 'Correo no disponible'}</small>
                    <small>
                      {entry.enrollments.length}{' '}
                      {entry.enrollments.length === 1 ? 'curso' : 'cursos'}
                    </small>
                  </span>
                  <span className="status">{accountStatusLabel(entry.status)}</span>
                </button>
              ))}
            </div>
          ) : (
            <div className="empty-state">
              <p>No hay usuarios que coincidan con la búsqueda.</p>
            </div>
          )}
        </section>

        <section className="panel admin-detail">
          {selected ? (
            <>
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Ficha del usuario</span>
                  <h2>{displayName(selected)}</h2>
                </div>
                <ShieldCheck color="var(--orange)" />
              </div>

              {!selected.profile_exists ? (
                <div className="alert alert--info">
                  Esta cuenta existe en el acceso del campus, pero todavía no
                  tiene una ficha de perfil asociada.
                </div>
              ) : null}

              <dl className="admin-detail__facts">
                <Fact label="Correo" value={selected.email ?? 'No disponible'} />
                <Fact label="Teléfono" value={selected.phone ?? 'No informado'} />
                <Fact label="DNI / NIE" value={selected.dni ?? 'No informado'} />
                <Fact
                  label="Roles"
                  value={
                    selected.roles.map(roleLabel).join(', ') || 'Sin rol asignado'
                  }
                />
                <Fact
                  label="Registro"
                  value={formatDateTime(selected.registered_at)}
                />
                <Fact
                  label="Correo confirmado"
                  value={formatDateTime(selected.email_confirmed_at)}
                />
                <Fact
                  label="Primer acceso"
                  value={formatDateTime(selected.first_access_at)}
                />
                <Fact
                  label="Último acceso"
                  value={formatDateTime(
                    selected.last_access_at ?? selected.last_sign_in_at,
                  )}
                />
                <div>
                  <dt>Estado de la cuenta</dt>
                  <dd>
                    {selected.profile_exists ? (
                      <select
                        aria-label="Estado de la cuenta"
                        value={selected.status}
                        onChange={(event) => updateStatus(event.target.value)}
                      >
                        <option value="pending">Pendiente</option>
                        <option value="active">Activa</option>
                        <option value="suspended">Suspendida</option>
                        <option value="archived">Archivada</option>
                      </select>
                    ) : (
                      'Sin perfil'
                    )}
                  </dd>
                </div>
              </dl>

              <div className="panel__header">
                <h3>Cursos y progreso</h3>
                <span className="status">
                  {selected.enrollments.length}{' '}
                  {selected.enrollments.length === 1 ? 'matrícula' : 'matrículas'}
                </span>
              </div>
              {selected.enrollments.length ? (
                <div className="user-progress-list">
                  {selected.enrollments.map((enrollment) => (
                    <article className="user-progress-card" key={enrollment.id}>
                      <BookOpenCheck color="var(--orange)" size={22} />
                      <div className="user-progress-card__content">
                        <div className="user-progress-card__heading">
                          <strong>{enrollment.course.title}</strong>
                          <span className="status">
                            {enrollmentStatusLabel(enrollment.status)}
                          </span>
                        </div>
                        <small>
                          Versión {enrollment.course.version_number} ·{' '}
                          {enrollment.course.duration_hours} h ·{' '}
                          {modalityLabel(enrollment.course.modality)}
                        </small>
                        <div
                          className="progress"
                          aria-label={`Progreso: ${formatPercent(enrollment.progress_percent)}`}
                        >
                          <span
                            style={{
                              width: `${clampPercent(enrollment.progress_percent)}%`,
                            }}
                          />
                        </div>
                        <div className="user-progress-card__times">
                          <span>
                            <Clock3 size={15} />
                            <span>
                              <small>Tiempo activo</small>
                              <strong>
                                {formatActiveTime(enrollment.active_seconds)}
                              </strong>
                            </span>
                          </span>
                          <span>
                            <Clock3 size={15} />
                            <span>
                              <small>Tiempo transcurrido</small>
                              <strong>{formatElapsedTime(enrollment)}</strong>
                            </span>
                          </span>
                        </div>
                        <dl className="user-progress-card__dates">
                          <Fact
                            label="Matriculación"
                            value={formatDateTime(enrollment.enrolled_at)}
                          />
                          <Fact
                            label="Inicio"
                            value={formatDateTime(enrollment.started_at)}
                          />
                          <Fact
                            label="Finalización"
                            value={formatDateTime(enrollment.completed_at)}
                          />
                        </dl>
                      </div>
                      <strong className="user-progress-card__percent">
                        {formatPercent(enrollment.progress_percent)}
                      </strong>
                    </article>
                  ))}
                </div>
              ) : (
                <div className="empty-state">
                  <p>Este usuario todavía no está matriculado en ningún curso.</p>
                </div>
              )}
            </>
          ) : (
            <div className="empty-state">
              <p>Selecciona un usuario para consultar su ficha completa.</p>
            </div>
          )}
        </section>
      </div>
    </AppShell>
  )
}

function SummaryCard({
  icon,
  label,
  value,
}: {
  icon: ReactNode
  label: string
  value: number
}) {
  return (
    <article>
      <span>{icon}</span>
      <div>
        <strong>{value}</strong>
        <small>{label}</small>
      </div>
    </article>
  )
}

function Fact({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt>{label}</dt>
      <dd>{value}</dd>
    </div>
  )
}

function displayName(user: AdminUser): string {
  return (
    [user.first_name, user.last_name].filter(Boolean).join(' ') ||
    'Usuario sin nombre'
  )
}

function accountStatusLabel(status: string): string {
  const labels: Record<string, string> = {
    pending: 'Pendiente',
    active: 'Activa',
    suspended: 'Suspendida',
    archived: 'Archivada',
    profile_missing: 'Sin perfil',
  }
  return labels[status] ?? status
}

function enrollmentStatusLabel(status: string): string {
  const labels: Record<string, string> = {
    not_started: 'No iniciado',
    in_progress: 'En curso',
    theory_completed: 'Teoría completada',
    practice_pending: 'Práctica pendiente',
    practice_completed: 'Práctica completada',
    completed: 'Finalizado',
    failed: 'No superado',
    expired: 'Caducado',
  }
  return labels[status] ?? status
}

function roleLabel(role: string): string {
  const labels: Record<string, string> = {
    alumno: 'Alumno',
    responsable_empresa: 'Responsable de empresa',
    tutor: 'Tutor',
    administrador: 'Administrador',
    superadministrador: 'Superadministrador',
  }
  return labels[role] ?? role
}

function modalityLabel(modality: string): string {
  const labels: Record<string, string> = {
    online: 'Online',
    in_person: 'Presencial',
    hybrid: 'Híbrida',
  }
  return labels[modality] ?? modality
}

function formatDateTime(value: string | null): string {
  if (!value) return 'Sin registro'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'Sin registro'
  return new Intl.DateTimeFormat('es-ES', {
    dateStyle: 'medium',
    timeStyle: 'short',
    timeZone: 'Europe/Madrid',
  }).format(date)
}

function formatActiveTime(value: number): string {
  if (!Number.isFinite(value) || value <= 0) return 'Sin tiempo registrado'
  return formatSeconds(value)
}

function formatElapsedTime(enrollment: AdminEnrollment): string {
  if (!enrollment.started_at) return 'No iniciado'
  const startedAt = Date.parse(enrollment.started_at)
  // Mientras la matrícula no se cierra no hay `completed_at`, así que el fin de
  // la teoría es la mejor referencia del tiempo que tardó el alumno. Sin
  // ninguno de los dos sigue en curso y medimos contra ahora.
  const finishedAt = enrollment.completed_at ?? enrollment.theory_completed_at
  const endedAt = finishedAt ? Date.parse(finishedAt) : Date.now()
  if (!Number.isFinite(startedAt) || !Number.isFinite(endedAt)) {
    return 'Sin datos suficientes'
  }
  const elapsed = formatSeconds(
    Math.max(0, Math.round((endedAt - startedAt) / 1_000)),
  )
  return finishedAt ? elapsed : `${elapsed} (en curso)`
}

function formatSeconds(value: number): string {
  const totalMinutes = Math.max(0, Math.floor(value / 60))
  const days = Math.floor(totalMinutes / 1_440)
  const hours = Math.floor((totalMinutes % 1_440) / 60)
  const minutes = totalMinutes % 60
  const parts = []
  if (days) parts.push(`${days} d`)
  if (hours || days) parts.push(`${hours} h`)
  parts.push(`${minutes} min`)
  return parts.join(' ')
}

function clampPercent(value: number): number {
  return Math.max(0, Math.min(100, Number.isFinite(value) ? value : 0))
}

function formatPercent(value: number): string {
  return `${Math.round(clampPercent(value))}%`
}

async function getAccessToken(): Promise<string | null> {
  const { data } =
    (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
  return data?.session?.access_token ?? null
}
