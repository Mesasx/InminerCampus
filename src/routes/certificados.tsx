import { createFileRoute, Link } from '@tanstack/react-router'
import { Award, Download, FileCheck2, UserRoundPen } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { seoHead } from '../lib/seo'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

type CertificateCourse = {
  enrollment_id: string
  course_title: string
  completed_at: string
  status: 'pending_identity' | 'pending_certificate' | 'available'
  documents: Array<{
    id: string
    name: string
    file_name: string
    issued_at: string
    download_kind: 'uploaded' | 'certificate' | 'stvh'
  }>
}

export const Route = createFileRoute('/certificados')({
  head: () => seoHead({
    title: 'Mis certificados',
    description:
      'Certificados obtenidos en el Campus.',
    path: '/certificados',
    noindex: true,
  }),
  component: CertificatesPage,
})

function CertificatesPage() {
  return (
    <ProtectedGate>
      {(user) => <Certificates user={user} />}
    </ProtectedGate>
  )
}

function Certificates({ user }: { user: SessionUser }) {
  const [courses, setCourses] = useState<CertificateCourse[]>([])
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState('')
  const [downloading, setDownloading] = useState<string | null>(null)

  useEffect(() => {
    void loadCertificates()
  }, [])

  async function loadCertificates() {
    try {
      const token = await accessToken()
      if (!token) throw new Error('session')
      const response = await fetch('/api/certificates', {
        headers: { Authorization: `Bearer ${token}` },
      })
      const payload = (await response.json()) as {
        courses?: CertificateCourse[]
        error?: string
      }
      if (!response.ok) throw new Error(payload.error)
      setCourses(payload.courses ?? [])
    } catch {
      setMessage('No se han podido cargar tus certificados.')
    } finally {
      setLoading(false)
    }
  }

  async function download(
    document: CertificateCourse['documents'][number],
  ) {
    setDownloading(document.id)
    setMessage('')
    try {
      const token = await accessToken()
      if (!token) throw new Error('Tu sesión ha caducado.')
      const endpoint =
        document.download_kind === 'stvh'
          ? `/api/certificado-stvh?certificateId=${encodeURIComponent(document.id)}`
          : `/api/certificates/${encodeURIComponent(document.id)}/download`
      const response = await fetch(endpoint, {
        headers: { Authorization: `Bearer ${token}` },
      })
      const payload = (await response.json()) as { url?: string; error?: string }
      if (!response.ok || !payload.url) {
        throw new Error(payload.error ?? 'No se ha podido preparar la descarga.')
      }
      window.location.href = payload.url
    } catch (error) {
      setMessage(
        error instanceof Error
          ? error.message
          : 'No se ha podido descargar el certificado.',
      )
    } finally {
      setDownloading(null)
    }
  }

  return (
    <AppShell user={user} title="Certificados">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Acreditaciones</span>
          <h1>Tus certificados.</h1>
          <p>Consulta el estado y descarga tus documentos definitivos.</p>
        </div>
      </div>

      {message ? <div className="alert alert--info" role="status">{message}</div> : null}

      {loading ? (
        <section className="empty-state"><p>Cargando certificados…</p></section>
      ) : courses.length ? (
        <div className="certificate-course-list">
          {courses.map((course) => (
            <section className="panel" key={course.enrollment_id}>
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Formación completada</span>
                  <h2>{course.course_title}</h2>
                  <p>Finalizada el {formatDate(course.completed_at)}</p>
                </div>
                <span className="status">{studentStatusLabel(course.status)}</span>
              </div>

              {course.status === 'pending_identity' ? (
                <div className="certificate-action-note">
                  <UserRoundPen size={24} />
                  <div>
                    <h3>Completa tu DNI/NIE</h3>
                    <p>Necesitamos este dato para tramitar el certificado.</p>
                  </div>
                  <Link className="button button--primary" to="/perfil">
                    Completar datos
                  </Link>
                </div>
              ) : course.status === 'pending_certificate' ? (
                <div className="certificate-action-note">
                  <Award size={24} />
                  <div>
                    <h3>Certificado en preparación</h3>
                    <p>INMÍNER está preparando el documento definitivo.</p>
                  </div>
                </div>
              ) : (
                <div className="certificate-document-list">
                  {course.documents.map((document) => (
                    <article key={document.id}>
                      <FileCheck2 size={22} />
                      <div>
                        <h3>{document.name}</h3>
                        <p>Emitido el {formatDate(document.issued_at)}</p>
                      </div>
                      <button
                        className="button button--outline"
                        disabled={downloading === document.id}
                        onClick={() => void download(document)}
                        type="button"
                      >
                        <Download size={16} />
                        {downloading === document.id ? 'Preparando…' : 'Descargar'}
                      </button>
                    </article>
                  ))}
                </div>
              )}
            </section>
          ))}
        </div>
      ) : (
        <section className="empty-state">
          <Award size={30} />
          <div>
            <h2>Aún no hay formaciones completadas</h2>
            <p>Cuando completes un curso, su estado aparecerá aquí.</p>
          </div>
          <Link className="button button--primary" to="/mis-cursos">
            Ver mis cursos
          </Link>
        </section>
      )}
    </AppShell>
  )
}

async function accessToken(): Promise<string | null> {
  const supabase = getSupabaseBrowserClient()
  const { data } = (await supabase?.auth.getSession()) ?? { data: null }
  return data?.session?.access_token ?? null
}

function studentStatusLabel(status: CertificateCourse['status']): string {
  return {
    pending_identity: 'Datos pendientes',
    pending_certificate: 'En preparación',
    available: 'Disponible',
  }[status]
}

function formatDate(value: string): string {
  return new Intl.DateTimeFormat('es-ES', { dateStyle: 'long' }).format(
    new Date(value),
  )
}
