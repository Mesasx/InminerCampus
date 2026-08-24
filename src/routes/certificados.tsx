import { createFileRoute, Link } from '@tanstack/react-router'
import { Award, CheckCircle2 } from 'lucide-react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/certificados')({
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
  return (
    <AppShell user={user} title="Certificados">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Acreditaciones</span>
          <h1>Tus certificados.</h1>
          <p>
            INMÍNER incorpora aquí únicamente los certificados definitivos una
            vez tramitados.
          </p>
        </div>
      </div>
      <section className="panel completion-screen">
        <span className="completion-screen__icon" aria-hidden="true">
          <Award size={34} />
        </span>
        <div>
          <span className="eyebrow">Tramitación interna</span>
          <h2>INMÍNER está preparando tus certificados</h2>
          <p>
            Al completar una formación registramos internamente su finalización.
            El documento interno de trazabilidad no es un certificado y no está
            disponible para descarga.
          </p>
          <p>
            Cuando el certificado definitivo esté disponible, se incorporará a
            tu cuenta de InmínerCampus.
          </p>
        </div>
        <Link className="button button--primary" to="/mis-cursos">
          <CheckCircle2 size={18} /> Volver a Mis cursos
        </Link>
      </section>
    </AppShell>
  )
}
