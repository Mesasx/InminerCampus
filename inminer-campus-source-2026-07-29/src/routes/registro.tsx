import { Turnstile } from '@marsidev/react-turnstile'
import { createFileRoute, Link } from '@tanstack/react-router'
import { useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { appConfig } from '../lib/config'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/registro')({
  component: RegisterPage,
})

const legalVersion = '2026-07-29'

function RegisterPage() {
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [acceptedLegal, setAcceptedLegal] = useState(false)
  const [captchaToken, setCaptchaToken] = useState('')
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (password.length < 10) {
      setError('La contraseña debe tener al menos 10 caracteres.')
      return
    }
    if (!acceptedLegal) {
      setError('Debes aceptar la privacidad y las condiciones de uso.')
      return
    }
    if (appConfig.turnstileSiteKey && !captchaToken) {
      setError('Completa la verificación de seguridad.')
      return
    }

    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setError(
        'La conexión segura todavía no está configurada en este entorno.',
      )
      return
    }

    setLoading(true)
    const { data, error: authError } = await supabase.auth.signUp({
      email: email.trim().toLowerCase(),
      password,
      options: {
        emailRedirectTo: `${appConfig.appUrl}/mis-cursos`,
        captchaToken: captchaToken || undefined,
        data: {
          first_name: firstName.trim(),
          last_name: lastName.trim(),
          accepted_legal: true,
          legal_version: legalVersion,
        },
      },
    })
    setLoading(false)

    if (authError) {
      setCaptchaToken('')
      setError(
        authError.message.includes('already registered')
          ? 'Ya existe una cuenta con ese correo.'
          : 'No hemos podido crear la cuenta. Revisa los datos e inténtalo de nuevo.',
      )
      return
    }

    setSuccess(
      data.session
        ? 'Tu cuenta está creada. Ya puedes acceder al campus.'
        : 'Revisa tu correo y confirma la cuenta para poder acceder.',
    )
  }

  return (
    <AuthLayout
      title="Crea tu cuenta"
      description="Tus datos se utilizarán para gestionar la formación y sus evidencias."
    >
      <form className="form-grid" onSubmit={handleSubmit}>
        {error ? <div className="alert alert--error">{error}</div> : null}
        {success ? <div className="alert alert--success">{success}</div> : null}
        <div className="form-row">
          <div className="field">
            <label htmlFor="register-first-name">Nombre</label>
            <input
              id="register-first-name"
              autoComplete="given-name"
              required
              value={firstName}
              onChange={(event) => setFirstName(event.target.value)}
            />
          </div>
          <div className="field">
            <label htmlFor="register-last-name">Apellidos</label>
            <input
              id="register-last-name"
              autoComplete="family-name"
              required
              value={lastName}
              onChange={(event) => setLastName(event.target.value)}
            />
          </div>
        </div>
        <div className="field">
          <label htmlFor="register-email">Correo electrónico</label>
          <input
            id="register-email"
            type="email"
            autoComplete="email"
            required
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />
        </div>
        <div className="field">
          <label htmlFor="register-password">Contraseña</label>
          <input
            id="register-password"
            type="password"
            autoComplete="new-password"
            minLength={10}
            required
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
          <small className="muted">Mínimo 10 caracteres.</small>
        </div>
        <label className="checkbox">
          <input
            type="checkbox"
            checked={acceptedLegal}
            onChange={(event) => setAcceptedLegal(event.target.checked)}
          />
          <span>
            He leído y acepto la{' '}
            <Link
              className="text-link"
              to="/legal/$legalSlug"
              params={{ legalSlug: 'privacidad' }}
            >
              política de privacidad
            </Link>{' '}
            y las{' '}
            <Link
              className="text-link"
              to="/legal/$legalSlug"
              params={{ legalSlug: 'contratacion' }}
            >
              condiciones de uso
            </Link>
            .
          </span>
        </label>
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
          {loading ? 'Creando cuenta…' : 'Crear cuenta'}
        </button>
        <p className="muted" style={{ textAlign: 'center', fontSize: '.9rem' }}>
          ¿Ya tienes cuenta?{' '}
          <Link className="text-link" to="/acceso">
            Acceder
          </Link>
        </p>
      </form>
    </AuthLayout>
  )
}
