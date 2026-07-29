import { createFileRoute, useNavigate } from '@tanstack/react-router'
import { useState, type FormEvent } from 'react'
import { AuthLayout } from '../components/AuthLayout'
import { getSupabaseBrowserClient } from '../lib/supabase'

export const Route = createFileRoute('/nueva-contrasena')({
  component: NewPasswordPage,
})

function NewPasswordPage() {
  const navigate = useNavigate()
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError('')

    if (password.length < 10) {
      setError('La contraseña debe tener al menos 10 caracteres.')
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
      return
    }

    await navigate({ to: '/mis-cursos', replace: true })
  }

  return (
    <AuthLayout
      title="Nueva contraseña"
      description="Elige una contraseña única que no utilices en otros servicios."
    >
      <form className="form-grid" onSubmit={handleSubmit}>
        {error ? <div className="alert alert--error">{error}</div> : null}
        <div className="field">
          <label htmlFor="new-password">Nueva contraseña</label>
          <input
            id="new-password"
            type="password"
            autoComplete="new-password"
            minLength={10}
            required
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
        </div>
        <button
          className="button button--primary button--wide"
          type="submit"
          disabled={loading}
        >
          {loading ? 'Guardando…' : 'Guardar contraseña'}
        </button>
      </form>
    </AuthLayout>
  )
}
