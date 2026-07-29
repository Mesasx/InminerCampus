import { Turnstile } from '@marsidev/react-turnstile'
import { createFileRoute, Link, useNavigate } from '@tanstack/react-router'
import { useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { appConfig } from '../lib/config'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/acceso')({
  component: LoginPage,
})

function LoginPage() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [captchaToken, setCaptchaToken] = useState('')
  const [requiresCaptcha, setRequiresCaptcha] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')

    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setError(
        'La conexión segura todavía no está configurada en este entorno.',
      )
      return
    }

    if (requiresCaptcha && appConfig.turnstileSiteKey && !captchaToken) {
      setError('Completa la verificación de seguridad.')
      return
    }

    setLoading(true)
    const { error: authError } = await supabase.auth.signInWithPassword({
      email: email.trim().toLowerCase(),
      password,
      options: captchaToken ? { captchaToken } : undefined,
    })
    setLoading(false)

    if (authError) {
      setRequiresCaptcha(true)
      setCaptchaToken('')
      setError(
        authError.message.includes('Invalid login')
          ? 'El correo o la contraseña no son correctos.'
          : 'No hemos podido iniciar sesión. Revisa los datos e inténtalo de nuevo.',
      )
      return
    }

    await navigate({ to: '/mis-cursos', replace: true })
  }

  return (
    <AuthLayout
      title="Accede a tu campus"
      description="Introduce tus datos para continuar con tu formación."
    >
      <form className="form-grid" onSubmit={handleSubmit}>
        {error ? <div className="alert alert--error">{error}</div> : null}
        <div className="field">
          <label htmlFor="login-email">Correo electrónico</label>
          <input
            id="login-email"
            name="email"
            type="email"
            autoComplete="email"
            required
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />
        </div>
        <div className="field">
          <label htmlFor="login-password">Contraseña</label>
          <input
            id="login-password"
            name="password"
            type="password"
            autoComplete="current-password"
            required
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
        </div>
        <div className="form-meta">
          <span>Acceso protegido</span>
          <Link className="text-link" to="/recuperar-contrasena">
            ¿Has olvidado la contraseña?
          </Link>
        </div>
        {requiresCaptcha && appConfig.turnstileSiteKey ? (
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
          {loading ? 'Accediendo…' : 'Acceder'}
        </button>
        <p className="muted" style={{ textAlign: 'center', fontSize: '.9rem' }}>
          ¿Todavía no tienes cuenta?{' '}
          <Link className="text-link" to="/registro">
            Crear cuenta
          </Link>
        </p>
      </form>
    </AuthLayout>
  )
}
