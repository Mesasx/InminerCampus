import { Turnstile } from '@marsidev/react-turnstile'
import { createFileRoute, Link } from '@tanstack/react-router'
import { useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { appConfig } from '../lib/config'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/recuperar-contrasena')({
  component: RecoverPasswordPage,
})

function RecoverPasswordPage() {
  const [email, setEmail] = useState('')
  const [captchaToken, setCaptchaToken] = useState('')
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')
    const supabase = getSupabaseBrowserClient()

    if (appConfig.turnstileSiteKey && !captchaToken) {
      setError('Completa la verificación de seguridad.')
      return
    }

    if (supabase) {
      setLoading(true)
      await supabase.auth.resetPasswordForEmail(email.trim().toLowerCase(), {
        redirectTo: `${appConfig.appUrl}/nueva-contrasena`,
        captchaToken: captchaToken || undefined,
      })
      setLoading(false)
      setCaptchaToken('')
    }

    setMessage(
      'Si existe una cuenta con ese correo, recibirás instrucciones para recuperar el acceso.',
    )
  }

  return (
    <AuthLayout
      title="Recupera el acceso"
      description="Te enviaremos un enlace seguro para establecer una nueva contraseña."
    >
      <form className="form-grid" onSubmit={handleSubmit}>
        {error ? <div className="alert alert--error">{error}</div> : null}
        {message ? <div className="alert alert--success">{message}</div> : null}
        <div className="field">
          <label htmlFor="recover-email">Correo electrónico</label>
          <input
            id="recover-email"
            type="email"
            autoComplete="email"
            required
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />
        </div>
        {appConfig.turnstileSiteKey ? (
          <Turnstile
            siteKey={appConfig.turnstileSiteKey}
            onSuccess={setCaptchaToken}
            onExpire={() => setCaptchaToken('')}
            options={{ language: 'es', theme: 'light' }}
          />
        ) : null}
        <button
          className="button button--primary button--wide"
          type="submit"
          disabled={loading}
        >
          {loading ? 'Enviando…' : 'Enviar instrucciones'}
        </button>
        <Link
          className="text-link"
          style={{ textAlign: 'center' }}
          to="/acceso"
        >
          Volver al acceso
        </Link>
      </form>
    </AuthLayout>
  )
}
