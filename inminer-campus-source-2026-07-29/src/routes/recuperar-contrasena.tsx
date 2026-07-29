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
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const supabase = getSupabaseBrowserClient()

    if (supabase) {
      setLoading(true)
      await supabase.auth.resetPasswordForEmail(email.trim().toLowerCase(), {
        redirectTo: `${appConfig.appUrl}/nueva-contrasena`,
      })
      setLoading(false)
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
