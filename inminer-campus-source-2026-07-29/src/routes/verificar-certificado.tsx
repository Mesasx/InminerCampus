import { createFileRoute } from '@tanstack/react-router'
import { BadgeCheck, SearchCheck } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { StaticPage } from '../components/StaticPage'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/verificar-certificado')({
  component: VerifyCertificatePage,
})

type CertificateResult = {
  certificate_code: string
  certificate_status: string
  holder_name: string
  course_title: string
  duration_hours: number
  modality: string
  completion_date: string
  issued_at: string
}

function VerifyCertificatePage() {
  const [code, setCode] = useState('')
  const [result, setResult] = useState<CertificateResult | null>(null)
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setResult(null)
    setMessage('')
    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setMessage('La verificación todavía no está configurada en este entorno.')
      return
    }

    setLoading(true)
    const { data, error } = await supabase.rpc('verify_certificate', {
      p_code: code.trim().toUpperCase(),
    })
    setLoading(false)

    const first = Array.isArray(data) ? data[0] : data
    if (error || !first) {
      setMessage('No hemos encontrado un certificado con ese código.')
      return
    }
    setResult(first as CertificateResult)
  }

  return (
    <StaticPage
      eyebrow="Verificación pública"
      title="Comprueba la validez de un certificado."
      description="Introduce el código que aparece en el documento. Solo se mostrarán los datos imprescindibles para verificarlo."
    >
      <div className="panel" style={{ maxWidth: 760, marginInline: 'auto' }}>
        <form className="form-grid" onSubmit={handleSubmit}>
          <div className="field">
            <label htmlFor="certificate-code">Código de certificado</label>
            <input
              id="certificate-code"
              autoComplete="off"
              placeholder="INM-XXXX-XXXX"
              required
              value={code}
              onChange={(event) => setCode(event.target.value)}
            />
          </div>
          <button className="button button--primary" disabled={loading}>
            <SearchCheck size={18} />
            {loading ? 'Verificando…' : 'Verificar'}
          </button>
          {message ? <div className="alert alert--info">{message}</div> : null}
        </form>
        {result ? (
          <div className="alert alert--success" style={{ marginTop: 24 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <BadgeCheck size={24} />
              <strong>Certificado {result.certificate_status}</strong>
            </div>
            <dl
              style={{
                display: 'grid',
                gridTemplateColumns: '160px 1fr',
                gap: 10,
                marginBottom: 0,
              }}
            >
              <dt>Persona</dt>
              <dd>{result.holder_name}</dd>
              <dt>Curso</dt>
              <dd>{result.course_title}</dd>
              <dt>Duración</dt>
              <dd>{result.duration_hours} horas</dd>
              <dt>Fecha</dt>
              <dd>{result.completion_date}</dd>
            </dl>
          </div>
        ) : null}
      </div>
    </StaticPage>
  )
}
