import { createFileRoute, Link } from '@tanstack/react-router'
import { Award, ExternalLink } from 'lucide-react'
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
  course_title: string
  duration_hours: number
  completion_date: string
  issued_at: string
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

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void supabase
      .from('certificates')
      .select(
        'id, certificate_code, status, course_title, duration_hours, completion_date, issued_at',
      )
      .eq('user_id', user.id)
      .order('issued_at', { ascending: false })
      .then(({ data }) => {
        setCertificates((data ?? []) as Certificate[])
        setLoading(false)
      })
  }, [user.id])

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
        {loading ? (
          <p className="muted">Cargando certificados…</p>
        ) : certificates.length ? (
          <div className="app-course-list">
            {certificates.map((certificate) => (
              <article className="app-course" key={certificate.id}>
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
