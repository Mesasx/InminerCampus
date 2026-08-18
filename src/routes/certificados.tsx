import { createFileRoute, Link } from '@tanstack/react-router'
import { Award, Download, ExternalLink } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/certificados')({
  component: CertificatesPage,
})

type Certificate = {
  id: string
  certificate_code: string
  status: string
  holder_name: string
  course_title: string
  duration_hours: number
  modality: string
  completion_date: string
  issued_at: string
  pdf_storage_path: string | null
  validated_by: string | null
}

function CertificatesPage() {
  return (
    <ProtectedGate>
      {(user) => <Certificates user={user} />}
    </ProtectedGate>
  )
}

function Certificates({ user }: { user: SessionUser }) {
  const [certificates, setCertificates] = useState<Certificate[]>([])
  const [loading, setLoading] = useState(true)
  const [downloadingId, setDownloadingId] = useState<string | null>(null)
  const [downloadError, setDownloadError] = useState('')

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void supabase
      .from('certificates')
      .select(
        'id, certificate_code, status, holder_name, course_title, duration_hours, modality, completion_date, issued_at, pdf_storage_path, validated_by',
      )
      .eq('user_id', user.id)
      .order('issued_at', { ascending: false })
      .then(({ data }) => {
        setCertificates((data ?? []) as Certificate[])
        setLoading(false)
      })
  }, [user.id])

  async function downloadCertificate(certificate: Certificate) {
    if (certificate.status !== 'valid') return
    setDownloadError('')
    setDownloadingId(certificate.id)

    try {
      if (certificate.validated_by) {
        // Certificados STVH: PDF personalizado a partir de la plantilla
        // base, generado y cacheado una única vez en Supabase Storage.
        const supabase = getSupabaseBrowserClient()
        if (!supabase) throw new Error('Supabase no está configurado.')
        const { data: sessionData } = await supabase.auth.getSession()
        const accessToken = sessionData.session?.access_token
        if (!accessToken) throw new Error('Sesión no válida.')

        const response = await fetch(
          `/api/certificado-stvh?certificateId=${encodeURIComponent(certificate.id)}`,
          { headers: { Authorization: `Bearer ${accessToken}` } },
        )
        const body = (await response.json().catch(() => null)) as {
          url?: string
          error?: string
        } | null
        if (!response.ok || !body?.url) {
          throw new Error(body?.error ?? 'No se ha podido preparar el certificado.')
        }
        window.location.assign(body.url)
        return
      }

      const pdfData = {
        certificateCode: certificate.certificate_code,
        holderName: certificate.holder_name,
        courseTitle: certificate.course_title,
        durationHours: certificate.duration_hours,
        modality: certificate.modality,
        completionDate: certificate.completion_date,
        issuedAt: certificate.issued_at,
      }
      const { certificateFileName, downloadCertificatePdf } = await import(
        '../lib/certificate-pdf'
      )

      if (certificate.pdf_storage_path) {
        const supabase = getSupabaseBrowserClient()
        if (!supabase) throw new Error('Supabase no está configurado.')
        const { data, error } = await supabase.storage
          .from('certificates')
          .createSignedUrl(certificate.pdf_storage_path, 60, {
            download: certificateFileName(pdfData),
          })
        if (error) throw error
        window.location.assign(data.signedUrl)
      } else {
        downloadCertificatePdf(pdfData)
      }
    } catch {
      setDownloadError(
        'No hemos podido preparar el certificado. Inténtalo de nuevo.',
      )
    } finally {
      setDownloadingId(null)
    }
  }

  return (
    <AppShell user={user} title="Certificados">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Acreditaciones</span>
          <h1>Tus certificados.</h1>
          <p>Solo se emiten cuando se cumplen todos los requisitos del curso.</p>
        </div>
      </div>
      <section className="panel">
        {downloadError ? (
          <div className="alert alert--error">{downloadError}</div>
        ) : null}
        {loading ? (
          <p className="muted">Cargando certificados…</p>
        ) : certificates.length ? (
          <div className="app-course-list">
            {certificates.map((certificate) => (
              <article
                className="app-course certificate-card"
                key={certificate.id}
              >
                <span className="app-course__number">
                  <Award size={21} />
                </span>
                <div>
                  <h3>{certificate.course_title}</h3>
                  <p>
                    {certificate.duration_hours} h ·{' '}
                    {certificate.completion_date}
                  </p>
                </div>
                <span className="status">{certificate.status}</span>
                <Link
                  className="button button--outline"
                  to="/verificar-certificado"
                >
                  <ExternalLink size={17} /> Verificar
                </Link>
                <button
                  className="button button--primary"
                  disabled={
                    certificate.status !== 'valid' ||
                    downloadingId === certificate.id
                  }
                  onClick={() => void downloadCertificate(certificate)}
                  type="button"
                >
                  <Download size={17} />{' '}
                  {downloadingId === certificate.id
                    ? 'Preparando…'
                    : 'Descargar PDF'}
                </button>
              </article>
            ))}
          </div>
        ) : (
          <div className="empty-state">
            <div>
              <div className="empty-state__icon">
                <Award size={25} />
              </div>
              <h2>Aún no tienes certificados</h2>
              <p>
                Aparecerán aquí cuando completes la teoría, evaluaciones y
                prácticas exigidas.
              </p>
            </div>
          </div>
        )}
      </section>
    </AppShell>
  )
}
