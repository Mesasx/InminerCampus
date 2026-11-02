import { Turnstile } from '@marsidev/react-turnstile'
import { createFileRoute, Link } from '@tanstack/react-router'
import { useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { appConfig } from '../lib/config'
import { getSupabaseBrowserClient } from '../lib/supabase'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/recuperar-contrasena')({
  head: () =>
    seoHead({
      title: 'Recuperar contraseña',
      description: 'Recupera el acceso a tu cuenta del Campus.',
      path: '/recuperar-contrasena',
      noindex: true,
    }),
  component: RecoverPasswordPage,
})

function RecoverPasswordPage() {
  const [email, setEmail] = useState('')
  const [captchaToken, setCaptchaToken] = useState('')
  const [captchaKey, setCaptchaKey] = useState(0)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')
    setMessage('')
    const supabase = getSupabaseBrowserClient()

    if (appConfig.turnstileSiteKey && !captchaToken) {
      setError('Completa la verificación de seguridad.')
      return
    }

    if (!supabase) {
      setError('La conexión segura no está configurada.')
      return
    }

    setLoading(true)
    const redirectOrigin =
      typeof window === 'undefined' ? appConfig.appUrl : window.location.origin
    const { error: resetError } = await supabase.auth.resetPasswordForEmail(
      email.trim().toLowerCase(),
      {
        redirectTo: `${redirectOrigin}/nueva-contrasena`,
        captchaToken: captchaToken || undefined,
      },
    )
    setLoading(false)
    setCaptchaToken('')
    setCaptchaKey((current) => current + 1)

    if (resetError) {
      const isRateLimited = /rate|l[ií]mite|too many/i.test(resetError.message)
      setError(
        isRateLimited
          ? 'Se han solicitado demasiados enlaces. Espera unos minutos e inténtalo de nuevo.'
          : 'No hemos podido enviar el enlace. Revisa la verificación de seguridad e inténtalo de nuevo.',
      )
      return
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
        {error ? (
          <div className="alert alert--error" role="alert">
            {error}
          </div>
        ) : null}
        {message ? (
          <div className="alert alert--success" aria-live="polite">
            {message}
          </div>
        ) : null}
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
            key={captchaKey}
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
