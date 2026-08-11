import { createFileRoute } from '@tanstack/react-router'
import { Ban, Copy, KeyRound, RefreshCw } from 'lucide-react'
import { useCallback, useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/codigos')({
  component: AdminAccessCodesPage,
})

type CourseOption = {
  versionId: string
  label: string
}

type CodeRow = {
  id: string
  course_version_id: string
  course_title: string
  code_last_four: string
  status: string
  note: string | null
  expires_at: string | null
  created_at: string
  used_at: string | null
  used_by_email: string | null
}

const statusLabels: Record<string, string> = {
  available: 'Disponible',
  reserved: 'Reservado',
  used: 'Canjeado',
  revoked: 'Anulado',
  expired: 'Caducado',
}

function AdminAccessCodesPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AccessCodes user={user} />}
    </ProtectedGate>
  )
}

function AccessCodes({ user }: { user: SessionUser }) {
  const [courses, setCourses] = useState<CourseOption[]>([])
  const [versionId, setVersionId] = useState('')
  const [note, setNote] = useState('')
  const [codes, setCodes] = useState<CodeRow[]>([])
  const [generated, setGenerated] = useState<string | null>(null)
  const [copied, setCopied] = useState(false)
  const [loading, setLoading] = useState(true)
  const [working, setWorking] = useState(false)
  const [error, setError] = useState('')

  const loadCodes = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const { data, error: listError } = await supabase.rpc(
      'admin_list_access_codes',
      { p_course_version_id: null },
    )
    if (listError) {
      setError('No se han podido cargar los códigos emitidos.')
      return
    }
    setCodes((data ?? []) as CodeRow[])
  }, [])

  useEffect(() => {
    let active = true

    async function load() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) {
        setLoading(false)
        return
      }

      const { data } = await supabase
        .from('course_versions')
        .select(
          'id, version_number, duration_hours, courses!inner(title, access_mode)',
        )
        .eq('status', 'published')
        .order('version_number', { ascending: false })

      if (!active) return
      const options = ((data ?? []) as unknown as Array<{
        id: string
        version_number: number
        duration_hours: number
        courses: { title: string; access_mode: string }
      }>).map((row) => ({
        versionId: row.id,
        label: `${row.courses.title} · v${row.version_number} (${row.duration_hours} h)${
          row.courses.access_mode === 'access_code' ? ' · solo código' : ''
        }`,
      }))
      setCourses(options)
      setVersionId((current) => current || options[0]?.versionId || '')
      await loadCodes()
      if (active) setLoading(false)
    }

    void load()
    return () => {
      active = false
    }
  }, [loadCodes])

  async function generate() {
    if (!versionId) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    setWorking(true)
    setError('')
    setCopied(false)
    const { data, error: rpcError } = await supabase.rpc(
      'admin_generate_access_code',
      {
        p_course_version_id: versionId,
        p_note: note.trim() || null,
        p_expires_at: null,
      },
    )
    setWorking(false)
    if (rpcError) {
      setError(rpcError.message || 'No se ha podido generar el código.')
      return
    }
    const payload = data as { code?: string } | null
    setGenerated(payload?.code ?? null)
    setNote('')
    await loadCodes()
  }

  async function revoke(id: string) {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    setWorking(true)
    const { error: rpcError } = await supabase.rpc('admin_revoke_access_code', {
      p_access_code_id: id,
    })
    setWorking(false)
    if (rpcError) {
      setError('No se ha podido anular el código.')
      return
    }
    await loadCodes()
  }

  return (
    <AppShell user={user} mode="admin" title="Códigos de acceso">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Administración</span>
          <h1>Códigos de acceso.</h1>
          <p>
            Genera un código nuevo cada vez que quieras dar acceso a un curso
            restringido. Cada código es aleatorio, personal y de un solo uso.
          </p>
        </div>
      </div>

      {error ? <div className="alert alert--error">{error}</div> : null}

      <section className="panel">
        <div className="panel__header">
          <h2>Generar un código</h2>
          <KeyRound color="var(--orange)" size={26} />
        </div>
        {loading ? (
          <p className="muted">Cargando cursos publicados…</p>
        ) : (
          <div className="form-grid">
            <div className="field">
              <label htmlFor="code-course">Curso</label>
              <select
                id="code-course"
                onChange={(event) => setVersionId(event.target.value)}
                value={versionId}
              >
                {courses.map((course) => (
                  <option key={course.versionId} value={course.versionId}>
                    {course.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="code-note">
                Referencia interna (opcional)
              </label>
              <input
                id="code-note"
                onChange={(event) => setNote(event.target.value)}
                placeholder="Persona o motivo de la entrega"
                value={note}
              />
            </div>
            <button
              className="button button--primary"
              disabled={working || !versionId}
              onClick={() => {
                void generate()
              }}
              type="button"
            >
              <RefreshCw size={16} />{' '}
              {working ? 'Generando…' : 'Generar código nuevo'}
            </button>

            {generated ? (
              <div className="panel access-code-result">
                <span className="eyebrow">Código generado</span>
                <strong className="access-code-result__value">
                  {generated}
                </strong>
                <p className="muted">
                  Cópialo ahora y entrégaselo a la persona: por seguridad no
                  volverá a mostrarse, en el sistema solo queda su huella.
                </p>
                <button
                  className="button button--outline"
                  onClick={() => {
                    void navigator.clipboard.writeText(generated)
                    setCopied(true)
                  }}
                  type="button"
                >
                  <Copy size={16} /> {copied ? 'Copiado' : 'Copiar código'}
                </button>
              </div>
            ) : null}
          </div>
        )}
      </section>

      <section className="panel">
        <div className="panel__header">
          <h2>Códigos emitidos</h2>
        </div>
        {codes.length ? (
          <div className="table-scroll">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Curso</th>
                  <th>Código</th>
                  <th>Estado</th>
                  <th>Referencia</th>
                  <th>Emitido</th>
                  <th>Canjeado por</th>
                  <th />
                </tr>
              </thead>
              <tbody>
                {codes.map((code) => (
                  <tr key={code.id}>
                    <td>{code.course_title}</td>
                    <td>INM-••••-••••-{code.code_last_four}</td>
                    <td>
                      <span className="status">
                        {statusLabels[code.status] ?? code.status}
                      </span>
                    </td>
                    <td>{code.note ?? '—'}</td>
                    <td>
                      {new Date(code.created_at).toLocaleDateString('es-ES')}
                    </td>
                    <td>{code.used_by_email ?? '—'}</td>
                    <td>
                      {code.status === 'available' ? (
                        <button
                          className="button button--outline"
                          disabled={working}
                          onClick={() => {
                            void revoke(code.id)
                          }}
                          type="button"
                        >
                          <Ban size={14} /> Anular
                        </button>
                      ) : null}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <p className="muted">Todavía no has emitido ningún código.</p>
        )}
      </section>
    </AppShell>
  )
}
