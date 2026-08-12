import { createFileRoute, useNavigate } from '@tanstack/react-router'
import { KeyRound } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/canjear-codigo')({
  component: RedeemCodePage,
})

function RedeemCodePage() {
  const navigate = useNavigate()
  const [code, setCode] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  return (
    <ProtectedGate>
      {(user) => (
        <AppShell user={user} title="Canjear código">
          <div className="dashboard-heading">
            <div>
              <span className="eyebrow">Acceso empresarial</span>
              <h1>Canjea una plaza.</h1>
              <p>El código se consumirá una sola vez al confirmar.</p>
            </div>
          </div>
          <section className="panel" style={{ maxWidth: 650 }}>
            <form
              className="form-grid"
              onSubmit={async (event: FormEvent<HTMLFormElement>) => {
                event.preventDefault()
                setError('')
                const supabase = getSupabaseBrowserClient()
                if (!supabase) return
                setLoading(true)
                const { error: redeemError } = await supabase.rpc(
                  'redeem_access_code',
                  { input_code: code.trim().toUpperCase() },
                )
                setLoading(false)
                if (redeemError) {
                  setError(
                    redeemError.message.includes('Demasiados intentos')
                      ? 'Demasiados intentos de canje. Espera unos minutos antes de volver a intentarlo.'
                      : 'El código no es válido, ha caducado o ya se ha utilizado.',
                  )
                  return
                }
                await navigate({ to: '/mis-cursos', replace: true })
              }}
            >
              {error ? <div className="alert alert--error">{error}</div> : null}
              <div className="empty-state__icon" style={{ margin: 0 }}>
                <KeyRound size={25} />
              </div>
              <div className="field">
                <label htmlFor="access-code">Código de acceso</label>
                <input
                  id="access-code"
                  autoComplete="off"
                  placeholder="INM-XXXX-XXXX"
                  required
                  value={code}
                  onChange={(event) => setCode(event.target.value)}
                />
              </div>
              <button
                className="button button--primary"
                disabled={loading}
                type="submit"
              >
                {loading ? 'Validando…' : 'Canjear código'}
              </button>
            </form>
          </section>
        </AppShell>
      )}
    </ProtectedGate>
  )
}
