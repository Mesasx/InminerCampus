import { Link } from '@tanstack/react-router'
import type { ReactNode } from 'react'
import { appConfig } from '../lib/config'
import type { AppRole, SessionUser } from '../lib/types'
import { useCurrentUser } from '../hooks/useCurrentUser'

export function ProtectedGate({
  children,
  roles,
}: {
  children: (user: SessionUser) => ReactNode
  roles?: AppRole[]
}) {
  const { user, loading } = useCurrentUser()

  if (loading) {
    return (
      <main className="auth-main page-enter">
        <div className="empty-state">
          <p>Comprobando tu sesión de forma segura…</p>
        </div>
      </main>
    )
  }

  if (!appConfig.isSupabaseConfigured) {
    return (
      <main className="auth-main page-enter">
        <div className="auth-card">
          <div className="alert alert--info">
            Este entorno todavía necesita las variables públicas de Supabase para
            activar el acceso real.
          </div>
          <Link
            className="button button--outline button--wide"
            style={{ marginTop: 16 }}
            to="/"
          >
            Volver al inicio
          </Link>
        </div>
      </main>
    )
  }

  if (!user) {
    return (
      <main className="auth-main page-enter">
        <div className="auth-card">
          <h1>Necesitas iniciar sesión</h1>
          <p className="auth-card__intro">
            Accede con tu cuenta para consultar esta sección.
          </p>
          <Link className="button button--primary button--wide" to="/acceso">
            Ir al acceso
          </Link>
        </div>
      </main>
    )
  }

  if (roles?.length && !roles.some((role) => user.roles.includes(role))) {
    return (
      <main className="auth-main page-enter">
        <div className="auth-card">
          <h1>Acceso restringido</h1>
          <p className="auth-card__intro">
            Tu cuenta no tiene permisos para abrir esta sección.
          </p>
          <Link className="button button--outline button--wide" to="/mis-cursos">
            Volver a mis cursos
          </Link>
        </div>
      </main>
    )
  }

  return children(user)
}
