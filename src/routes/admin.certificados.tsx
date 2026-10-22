import { createFileRoute } from '@tanstack/react-router'
import { Award, FileUp, Search } from 'lucide-react'
import { useEffect, useMemo, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

const adminRoles = ['administrador', 'superadministrador'] as const

type WorkflowStatus =
  | 'pending_certificate'
  | 'available'
  | 'course_processing'

type CertificateAdminRow = {
  enrollment_id: string
  user_id: string
  learner: { name: string; email: string | null; dni: string | null }
  course: {
    title: string
    slug: string
    duration_hours: number
    modality: string
    practice_required: boolean
  }
  enrollment_status: string
  progress_percent: number
  theory_completed_at: string | null
  completed_at: string | null
  workflow_status: WorkflowStatus
  certificate: { id: string; certificate_code: string } | null
  documents: Array<{
    id: string
    display_name: string
    original_file_name: string
    issued_at: string
  }>
}

export const Route = createFileRoute('/admin/certificados')({
  component: AdminCertificatesPage,
})

function AdminCertificatesPage() {
  return (
    <ProtectedGate roles={[...adminRoles]}>
      {(user) => <AdminCertificates user={user} />}
    </ProtectedGate>
  )
}

function AdminCertificates({ user }: { user: SessionUser }) {
  const [rows, setRows] = useState<CertificateAdminRow[]>([])
  const [loading, setLoading] = useState(true)
  const [uploading, setUploading] = useState(false)
  const [message, setMessage] = useState('')
  const [query, setQuery] = useState('')
  const [status, setStatus] = useState<'all' | WorkflowStatus>('all')
  const [course, setCourse] = useState('all')
  const [enrollmentId, setEnrollmentId] = useState('')
  const [files, setFiles] = useState<File[]>([])

  useEffect(() => {
    const requestedEnrollment = new URLSearchParams(window.location.search).get(
      'enrollment',
    )
    if (requestedEnrollment) setEnrollmentId(requestedEnrollment)
    void loadRows()
  }, [])

  const courseOptions = useMemo(
    () => [...new Set(rows.map((row) => row.course.title))].sort(),
    [rows],
  )

  const filteredRows = useMemo(() => {
    const normalizedQuery = query.trim().toLocaleLowerCase('es')
    return rows.filter((row) => {
      const matchesQuery =
        !normalizedQuery ||
        [row.learner.name, row.learner.email, row.learner.dni, row.course.title]
          .filter(Boolean)
          .some((value) =>
            String(value).toLocaleLowerCase('es').includes(normalizedQuery),
          )
      return (
        matchesQuery &&
        (status === 'all' || row.workflow_status === status) &&
        (course === 'all' || row.course.title === course)
      )
    })
  }, [course, query, rows, status])

  const uploadableRows = rows.filter(
    (row) => row.enrollment_status === 'completed',
  )

  async function loadRows() {
    setLoading(true)
    try {
      const token = await accessToken()
      if (!token) throw new Error('session')
      const response = await fetch('/api/admin-certificates', {
        headers: { Authorization: `Bearer ${token}` },
      })
      const payload = (await response.json()) as {
        rows?: CertificateAdminRow[]
        error?: string
      }
      if (!response.ok) throw new Error(payload.error)
      setRows(payload.rows ?? [])
    } catch {
      setMessage('No se ha podido cargar la gestión de certificados.')
    } finally {
      setLoading(false)
    }
  }

  async function upload(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!enrollmentId || !files.length) {
      setMessage('Selecciona una matrícula y al menos un PDF.')
      return
    }
    setUploading(true)
    setMessage('')
    try {
      const token = await accessToken()
      if (!token) throw new Error('Tu sesión ha caducado.')
      const body = new FormData()
      body.set('enrollmentId', enrollmentId)
      files.forEach((file) => body.append('files', file))
      const response = await fetch('/api/admin-certificates', {
        method: 'POST',
        headers: { Authorization: `Bearer ${token}` },
        body,
      })
      const payload = (await response.json()) as {
        uploaded?: number
        error?: string
      }
      if (!response.ok) throw new Error(payload.error)
      setFiles([])
      setMessage(
        `${payload.uploaded ?? files.length} certificado(s) incorporado(s) correctamente.`,
      )
      await loadRows()
    } catch (error) {
      setMessage(
        error instanceof Error && error.message
          ? error.message
          : 'No se han podido subir los certificados.',
      )
    } finally {
      setUploading(false)
    }
  }

  return (
    <AppShell user={user} mode="admin" title="Certificados">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Emisión y entrega</span>
          <h1>Gestión de certificados.</h1>
          <p>Revisa las finalizaciones y entrega uno o varios PDF de forma privada.</p>
        </div>
      </div>

      {message ? <div className="alert alert--info" role="status">{message}</div> : null}

      <section className="panel">
        <div className="panel__header">
          <div>
            <span className="eyebrow">Nueva entrega</span>
            <h2>Subir certificados</h2>
          </div>
        </div>
        <form className="certificate-upload-form" onSubmit={upload}>
          <label className="field">
            <span>Alumno y formación completada</span>
            <select
              onChange={(event) => setEnrollmentId(event.target.value)}
              required
              value={enrollmentId}
            >
              <option value="">Selecciona una matrícula</option>
              {uploadableRows.map((row) => (
                <option key={row.enrollment_id} value={row.enrollment_id}>
                  {row.learner.name || row.learner.email || 'Alumno'} — {row.course.title}
                </option>
              ))}
            </select>
          </label>
          <label className="field">
            <span>PDF (máximo 10 archivos de 10 MB)</span>
            <input
              accept="application/pdf,.pdf"
              multiple
              onChange={(event) => setFiles(Array.from(event.target.files ?? []))}
              required
              type="file"
            />
          </label>
          <button className="button button--primary" disabled={uploading} type="submit">
            <FileUp size={17} /> {uploading ? 'Subiendo…' : 'Subir y publicar'}
          </button>
        </form>
      </section>

      <section className="panel">
        <div className="panel__header">
          <div>
            <span className="eyebrow">Seguimiento</span>
            <h2>Alumnos y certificados</h2>
          </div>
          <span className="status">{filteredRows.length} resultados</span>
        </div>
        <div className="certificate-filters">
          <label className="field field__with-icon">
            <Search size={17} aria-hidden="true" />
            <input
              aria-label="Buscar alumno, correo, DNI o curso"
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Buscar alumno, DNI o curso"
              type="search"
              value={query}
            />
          </label>
          <label className="field">
            <span>Estado</span>
            <select onChange={(event) => setStatus(event.target.value as typeof status)} value={status}>
              <option value="all">Todos</option>
              <option value="pending_certificate">Pendiente de certificado</option>
              <option value="available">Disponible</option>
              <option value="course_processing">Curso en tramitación</option>
            </select>
          </label>
          <label className="field">
            <span>Curso</span>
            <select onChange={(event) => setCourse(event.target.value)} value={course}>
              <option value="all">Todos</option>
              {courseOptions.map((title) => <option key={title} value={title}>{title}</option>)}
            </select>
          </label>
        </div>

        {loading ? (
          <p className="muted">Cargando certificados…</p>
        ) : filteredRows.length ? (
          <div className="table-scroll">
            <table>
              <thead>
                <tr>
                  <th>Alumno</th>
                  <th>Curso</th>
                  <th>Finalización</th>
                  <th>Estado</th>
                  <th>Documentos</th>
                </tr>
              </thead>
              <tbody>
                {filteredRows.map((row) => (
                  <tr key={row.enrollment_id}>
                    <td>
                      <strong>{row.learner.name || 'Sin nombre'}</strong><br />
                      <small>{row.learner.email ?? 'Sin correo'} · {row.learner.dni ?? 'DNI pendiente'}</small>
                    </td>
                    <td>{row.course.title}</td>
                    <td>{formatDate(row.completed_at ?? row.theory_completed_at)}</td>
                    <td><span className="status">{workflowLabel(row.workflow_status)}</span></td>
                    <td>{row.documents.length || (row.certificate ? 1 : 0)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="empty-state">
            <Award size={28} />
            <div><h3>No hay resultados</h3><p>Prueba con otros filtros.</p></div>
          </div>
        )}
      </section>
    </AppShell>
  )
}

async function accessToken(): Promise<string | null> {
  const supabase = getSupabaseBrowserClient()
  const { data } = (await supabase?.auth.getSession()) ?? { data: null }
  return data?.session?.access_token ?? null
}

function workflowLabel(status: WorkflowStatus): string {
  return {
    pending_certificate: 'Pendiente de certificado',
    available: 'Disponible',
    course_processing: 'Curso en tramitación',
  }[status]
}

function formatDate(value: string | null): string {
  return value
    ? new Intl.DateTimeFormat('es-ES', { dateStyle: 'medium' }).format(new Date(value))
    : '—'
}
