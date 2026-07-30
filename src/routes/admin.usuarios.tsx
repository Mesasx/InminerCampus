import { createFileRoute } from '@tanstack/react-router'
import {
  BookOpenCheck,
  Search,
  ShieldCheck,
  UserRound,
} from 'lucide-react'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/usuarios')({
  component: AdminUsersPage,
})

type Profile = {
  id: string
  email: string | null
  first_name: string
  last_name: string
  status: string
  created_at: string
  user_roles: Array<{ role: string }>
}

type Enrollment = {
  id: string
  user_id: string
  status: string
  progress_percent: number
  enrolled_at: string
  course_versions: {
    version_number: number
    courses: { title: string }
  }
}

function AdminUsersPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminUsers user={user} />}
    </ProtectedGate>
  )
}

function AdminUsers({ user }: { user: SessionUser }) {
  const [profiles, setProfiles] = useState<Profile[]>([])
  const [enrollments, setEnrollments] = useState<Enrollment[]>([])
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [search, setSearch] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(true)

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [{ data: profileRows, error }, { data: enrollmentRows }] =
      await Promise.all([
        supabase
          .from('profiles')
          .select(
            'id, email, first_name, last_name, status, created_at, user_roles(role)',
          )
          .order('created_at', { ascending: false }),
        supabase
          .from('enrollments')
          .select(
            'id, user_id, status, progress_percent, enrolled_at, course_versions(version_number, courses(title))',
          )
          .order('enrolled_at', { ascending: false }),
      ])
    if (error) setMessage('No se ha podido cargar el listado de usuarios.')
    const nextProfiles = (profileRows ?? []) as unknown as Profile[]
    setProfiles(nextProfiles)
    setEnrollments((enrollmentRows ?? []) as unknown as Enrollment[])
    setSelectedId((current) => current ?? nextProfiles[0]?.id ?? null)
    setLoading(false)
  }, [])

  useEffect(() => {
    void load()
  }, [load])

  const filtered = useMemo(() => {
    const term = search.trim().toLowerCase()
    if (!term) return profiles
    return profiles.filter((profile) =>
      [
        profile.email,
        profile.first_name,
        profile.last_name,
        ...profile.user_roles.map((role) => role.role),
      ]
        .filter(Boolean)
        .join(' ')
        .toLowerCase()
        .includes(term),
    )
  }, [profiles, search])

  const selected = profiles.find((profile) => profile.id === selectedId)
  const selectedEnrollments = enrollments.filter(
    (enrollment) => enrollment.user_id === selectedId,
  )

  async function updateStatus(status: string) {
    if (!selected) return
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
          <p>Consulta cada cuenta y el progreso real de sus matrículas.</p>
        </div>
      </div>
      {message ? <div className="alert alert--info">{message}</div> : null}
      <div className="admin-split">
        <section className="panel">
          <div className="panel__header">
            <h2>Directorio</h2>
            <span className="status">{profiles.length} cuentas</span>
          </div>
          <div className="field field--search">
            <label htmlFor="user-search">Buscar</label>
            <div className="field__with-icon">
              <Search size={18} />
              <input
                id="user-search"
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder="Nombre, correo o rol"
              />
            </div>
          </div>
          {loading ? (
            <p className="muted">Cargando usuarios…</p>
          ) : (
            <div className="admin-list">
              {filtered.map((profile) => (
                <button
                  className={
                    selectedId === profile.id
                      ? 'admin-list__item is-active'
                      : 'admin-list__item'
                  }
                  key={profile.id}
                  onClick={() => setSelectedId(profile.id)}
                  type="button"
                >
                  <span className="app-course__number">
                    <UserRound size={18} />
                  </span>
                  <span>
                    <strong>
                      {[profile.first_name, profile.last_name]
                        .filter(Boolean)
                        .join(' ') || 'Usuario sin nombre'}
                    </strong>
                    <small>{profile.email ?? 'Correo no disponible'}</small>
                  </span>
                  <span className="status">{profile.status}</span>
                </button>
              ))}
            </div>
          )}
        </section>

        <section className="panel admin-detail">
          {selected ? (
            <>
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Ficha del usuario</span>
                  <h2>
                    {[selected.first_name, selected.last_name]
                      .filter(Boolean)
                      .join(' ') || 'Usuario sin nombre'}
                  </h2>
                </div>
                <ShieldCheck color="var(--orange)" />
              </div>
              <dl className="admin-detail__facts">
                <div>
                  <dt>Correo</dt>
                  <dd>{selected.email ?? 'No disponible'}</dd>
                </div>
                <div>
                  <dt>Roles</dt>
                  <dd>
                    {selected.user_roles.map((role) => role.role).join(', ') ||
                      'Sin rol'}
                  </dd>
                </div>
                <div>
                  <dt>Alta</dt>
                  <dd>
                    {new Date(selected.created_at).toLocaleDateString('es-ES')}
                  </dd>
                </div>
                <div>
                  <dt>Estado</dt>
                  <dd>
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
                  </dd>
                </div>
              </dl>
              <div className="panel__header">
                <h3>Progreso formativo</h3>
                <span className="status">
                  {selectedEnrollments.length} matrículas
                </span>
              </div>
              {selectedEnrollments.length ? (
                <div className="user-progress-list">
                  {selectedEnrollments.map((enrollment) => (
                    <article
                      className="user-progress-card"
                      key={enrollment.id}
                    >
                      <BookOpenCheck color="var(--orange)" size={22} />
                      <div>
                        <strong>
                          {enrollment.course_versions.courses.title}
                        </strong>
                        <small>
                          Versión {enrollment.course_versions.version_number} ·{' '}
                          {enrollment.status}
                        </small>
                        <div className="progress">
                          <span
                            style={{
                              width: `${enrollment.progress_percent}%`,
                            }}
                          />
                        </div>
                      </div>
                      <strong>{enrollment.progress_percent}%</strong>
                    </article>
                  ))}
                </div>
              ) : (
                <div className="empty-state">
                  <p>Este usuario todavía no está matriculado.</p>
                </div>
              )}
            </>
          ) : (
            <div className="empty-state">
              <p>Selecciona un usuario para consultar su progreso.</p>
            </div>
          )}
        </section>
      </div>
    </AppShell>
  )
}
