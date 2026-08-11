import { createFileRoute, Link } from '@tanstack/react-router'
import { CheckCircle2, FileSignature, LockKeyhole } from 'lucide-react'
import { useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/campus/$enrollmentId/confidencialidad')({
  component: ConfidentialityPage,
})

type Agreement = {
  id: string
  title: string
  body: string
}

type Signature = {
  signed_full_name: string
  signed_document_id: string
  signed_at: string
}

function ConfidentialityPage() {
  const { enrollmentId } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => <Confidentiality user={user} enrollmentId={enrollmentId} />}
    </ProtectedGate>
  )
}

function Confidentiality({
  user,
  enrollmentId,
}: {
  user: SessionUser
  enrollmentId: string
}) {
  const [agreement, setAgreement] = useState<Agreement | null>(null)
  const [signature, setSignature] = useState<Signature | null>(null)
  const [courseCompleted, setCourseCompleted] = useState(false)
  const [fullName, setFullName] = useState('')
  const [documentId, setDocumentId] = useState('')
  const [accepted, setAccepted] = useState(false)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    let active = true

    async function load() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) {
        setLoading(false)
        return
      }

      const { data: enrollment } = await supabase
        .from('enrollments')
        .select('id, status, course_version_id')
        .eq('id', enrollmentId)
        .eq('user_id', user.id)
        .maybeSingle()

      if (!active) return
      if (!enrollment) {
        setLoading(false)
        return
      }

      const typed = enrollment as unknown as {
        status: string
        course_version_id: string
      }
      setCourseCompleted(
        ['completed', 'theory_passed', 'practice_completed'].includes(
          typed.status,
        ),
      )

      const [{ data: agreementRow }, { data: signatureRow }] = await Promise.all(
        [
          supabase
            .from('confidentiality_agreements')
            .select('id, title, body')
            .eq('course_version_id', typed.course_version_id)
            .eq('active', true)
            .order('version_number', { ascending: false })
            .limit(1)
            .maybeSingle(),
          supabase
            .from('confidentiality_signatures')
            .select('signed_full_name, signed_document_id, signed_at')
            .eq('enrollment_id', enrollmentId)
            .maybeSingle(),
        ],
      )

      if (!active) return
      setAgreement((agreementRow as Agreement | null) ?? null)
      setSignature((signatureRow as Signature | null) ?? null)
      setLoading(false)
    }

    void load()
    return () => {
      active = false
    }
  }, [enrollmentId, user.id])

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    setSaving(true)
    const { error: rpcError } = await supabase.rpc(
      'sign_confidentiality_agreement',
      {
        p_enrollment_id: enrollmentId,
        p_full_name: fullName,
        p_document_id: documentId,
        p_user_agent:
          typeof navigator === 'undefined' ? null : navigator.userAgent,
      },
    )
    setSaving(false)
    if (rpcError) {
      setError(
        rpcError.message ||
          'No hemos podido registrar la firma. Revisa los datos e inténtalo de nuevo.',
      )
      return
    }
    setSignature({
      signed_full_name: fullName,
      signed_document_id: documentId.toUpperCase(),
      signed_at: new Date().toISOString(),
    })
  }

  return (
    <AppShell user={user} title="Contrato de confidencialidad">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Último paso</span>
          <h1>Contrato de confidencialidad</h1>
          <p>
            Lee el documento completo y fírmalo para cerrar definitivamente la
            formación.
          </p>
        </div>
        <Link
          className="button button--outline"
          to="/campus/$enrollmentId"
          params={{ enrollmentId }}
        >
          Volver al curso
        </Link>
      </div>

      {loading ? (
        <section className="panel">
          <p className="muted">Cargando el documento…</p>
        </section>
      ) : !agreement ? (
        <section className="empty-state">
          <p>Este curso no tiene contrato de confidencialidad publicado.</p>
        </section>
      ) : (
        <div className="form-grid">
          <section className="panel">
            <div className="panel__header">
              <h2>{agreement.title}</h2>
              <FileSignature color="var(--orange)" size={28} />
            </div>
            <div className="legal-body">
              {agreement.body.split('\n\n').map((paragraph, index) => (
                <p key={index}>{paragraph}</p>
              ))}
            </div>
          </section>

          {signature ? (
            <section className="panel">
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Firmado</span>
                  <h2>Contrato firmado correctamente</h2>
                </div>
                <CheckCircle2 color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                Firmado por {signature.signed_full_name} (
                {signature.signed_document_id}) el{' '}
                {new Date(signature.signed_at).toLocaleString('es-ES')}.
              </p>
              <Link className="button button--outline" to="/mis-cursos">
                Ir a mis cursos
              </Link>
            </section>
          ) : !courseCompleted ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Firma bloqueada</h2>
                <LockKeyhole color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                Podrás firmar el contrato cuando hayas terminado la presentación
                y superado el test final.
              </p>
            </section>
          ) : (
            <section className="panel">
              <div className="panel__header">
                <h2>Firmar el contrato</h2>
              </div>
              <form className="form-grid" onSubmit={submit}>
                {error ? (
                  <div className="alert alert--error">{error}</div>
                ) : null}
                <div className="field">
                  <label htmlFor="signature-name">Nombre y apellidos</label>
                  <input
                    autoComplete="name"
                    id="signature-name"
                    onChange={(event) => setFullName(event.target.value)}
                    required
                    value={fullName}
                  />
                </div>
                <div className="field">
                  <label htmlFor="signature-document">
                    Documento de identidad (DNI/NIE)
                  </label>
                  <input
                    autoComplete="off"
                    id="signature-document"
                    onChange={(event) => setDocumentId(event.target.value)}
                    required
                    value={documentId}
                  />
                </div>
                <label className="checkbox-field">
                  <input
                    checked={accepted}
                    onChange={(event) => setAccepted(event.target.checked)}
                    type="checkbox"
                  />
                  <span>
                    He leído y acepto íntegramente el contrato de
                    confidencialidad.
                  </span>
                </label>
                <button
                  className="button button--primary"
                  disabled={saving || !accepted}
                  type="submit"
                >
                  {saving ? 'Registrando firma…' : 'Firmar el contrato'}
                </button>
              </form>
            </section>
          )}
        </div>
      )}
    </AppShell>
  )
}
