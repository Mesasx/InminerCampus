import { Turnstile } from '@marsidev/react-turnstile'
import { createFileRoute, Link, useNavigate } from '@tanstack/react-router'
import { useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { appConfig } from '../lib/config'
import { DNI_ERROR_MESSAGE, isValidDni, normalizeDni } from '../lib/dni'
import { getSupabaseBrowserClient } from '../lib/supabase'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/registro')({
  validateSearch: (search: Record<string, unknown>): { returnTo?: string } => ({
    returnTo: safeReturnTo(search.returnTo),
  }),
  head: () => seoHead({
    title: 'Crear cuenta',
    description:
      'Alta de nueva cuenta en el Campus de Inmíner.',
    path: '/registro',
    noindex: true,
  }),
  component: RegisterPage,
})

const legalVersion = '2026-08-24'

function RegisterPage() {
  const navigate = useNavigate()
  const { returnTo } = Route.useSearch()
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [dni, setDni] = useState('')
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

    // El DNI es obligatorio: sin él no se puede emitir el certificado ni el
    // aviso interno de finalización, que lo exige para identificar al alumno.
    if (!isValidDni(dni)) {
      setError(DNI_ERROR_MESSAGE)
      return
    }
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
        emailRedirectTo: `${appConfig.appUrl}${returnTo ?? '/mis-cursos'}`,
        captchaToken: captchaToken || undefined,
        data: {
          first_name: firstName.trim(),
          last_name: lastName.trim(),
          dni: normalizeDni(dni),
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
    if (data.session) {
      await navigate({ to: returnTo ?? '/mis-cursos', replace: true })
    }
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
          <label htmlFor="register-dni">DNI / NIE</label>
          <input
            id="register-dni"
            placeholder="12345678Z"
            autoComplete="off"
            required
            value={dni}
            onChange={(event) => setDni(event.target.value)}
          />
          <span className="muted">
            Necesario para emitir certificados con tus datos personales. No
            podrás cambiarlo una vez lo guardes.
          </span>
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
          <Link className="text-link" to="/acceso" search={{ returnTo }}>
            Acceder
          </Link>
        </p>
      </form>
    </AuthLayout>
  )
}

function safeReturnTo(value: unknown): string | undefined {
  if (typeof value !== 'string' || !value.startsWith('/') || value.startsWith('//')) {
    return undefined
  }
  return value.slice(0, 500)
}
