import { createFileRoute, Link } from '@tanstack/react-router'
import { useEffect, useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { getSupabaseBrowserClient } from '../lib/supabase'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/nueva-contrasena')({
  head: () =>
    seoHead({
      title: 'Nueva contraseña',
      description: 'Define una contraseña nueva para tu cuenta.',
      path: '/nueva-contrasena',
      noindex: true,
    }),
  component: NewPasswordPage,
})

function NewPasswordPage() {
  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [recoveryState, setRecoveryState] = useState<
    'checking' | 'ready' | 'invalid' | 'saved'
  >('checking')

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setError('La conexión segura no está configurada.')
      setRecoveryState('invalid')
      return
    }

    const query = new URLSearchParams(window.location.search)
    const hash = new URLSearchParams(window.location.hash.slice(1))
    const linkError =
      query.get('error_description') ||
      query.get('error') ||
      hash.get('error_description') ||
      hash.get('error')

    if (linkError) {
      setError(
        'El enlace ha caducado o ya se ha utilizado. Solicita uno nuevo.',
      )
      setRecoveryState('invalid')
      return
    }

    let active = true
    const { data: authListener } = supabase.auth.onAuthStateChange(
      (event, session) => {
        if (!active || !session) return
        if (
          event === 'PASSWORD_RECOVERY' ||
          event === 'SIGNED_IN' ||
          event === 'INITIAL_SESSION'
        ) {
          setError('')
          setRecoveryState('ready')
        }
      },
    )

    void supabase.auth.getSession().then(({ data, error: sessionError }) => {
      if (!active) return
      if (sessionError || !data.session) {
        setError(
          'No hay una solicitud válida de cambio de contraseña. Abre el enlace recibido por correo o solicita uno nuevo.',
        )
        setRecoveryState('invalid')
        return
      }
      setRecoveryState('ready')
    })

    return () => {
      active = false
      authListener.subscription.unsubscribe()
    }
  }, [])

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')

    if (password.length < 10) {
      setError('La contraseña debe tener al menos 10 caracteres.')
      return
    }
    if (password !== passwordConfirmation) {
      setError('Las dos contraseñas no coinciden.')
      return
    }
    if (recoveryState !== 'ready') {
      setError('El enlace de recuperación no está listo o ya no es válido.')
      return
    }

    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setError('La conexión segura no está configurada.')
      return
    }

    setLoading(true)
    const { error: updateError } = await supabase.auth.updateUser({ password })
    setLoading(false)

    if (updateError) {
      setError('El enlace ha caducado o no es válido. Solicita uno nuevo.')
      setRecoveryState('invalid')
      return
    }

    setPassword('')
    setPasswordConfirmation('')
    setRecoveryState('saved')
  }

  return (
    <AuthLayout
      title="Nueva contraseña"
      description="Elige una contraseña única que no utilices en otros servicios."
    >
      <form className="form-grid" onSubmit={handleSubmit}>
        {recoveryState === 'checking' ? (
          <div className="alert alert--info" aria-live="polite">
            Comprobando el enlace seguro…
          </div>
        ) : null}
        {error ? (
          <div className="alert alert--error" role="alert">
            {error}
          </div>
        ) : null}
        {recoveryState === 'saved' ? (
          <div className="alert alert--success" aria-live="polite">
            Tu contraseña se ha actualizado correctamente. Ya puedes continuar
            en el campus.
          </div>
        ) : null}
        <div className="field">
          <label htmlFor="new-password">Nueva contraseña</label>
          <input
            id="new-password"
            type="password"
            autoComplete="new-password"
            minLength={10}
            required
            disabled={recoveryState !== 'ready' || loading}
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
          <small>
            Utiliza al menos 10 caracteres y no reutilices una clave anterior.
          </small>
        </div>
        <div className="field">
          <label htmlFor="confirm-password">Repite la nueva contraseña</label>
          <input
            id="confirm-password"
            type="password"
            autoComplete="new-password"
            minLength={10}
            required
            disabled={recoveryState !== 'ready' || loading}
            value={passwordConfirmation}
            onChange={(event) => setPasswordConfirmation(event.target.value)}
          />
        </div>
        {recoveryState === 'saved' ? (
          <Link
            className="button button--primary button--wide"
            to="/mis-cursos"
          >
            Ir a mis cursos
          </Link>
        ) : (
          <button
            className="button button--primary button--wide"
            type="submit"
            disabled={loading || recoveryState !== 'ready'}
          >
            {loading ? 'Guardando…' : 'Guardar contraseña'}
          </button>
        )}
        {recoveryState === 'invalid' ? (
          <Link
            className="text-link"
            style={{ textAlign: 'center' }}
            to="/recuperar-contrasena"
          >
            Solicitar un enlace nuevo
          </Link>
        ) : null}
      </form>
    </AuthLayout>
  )
}
