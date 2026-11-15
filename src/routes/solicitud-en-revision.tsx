import { createFileRoute, Link } from '@tanstack/react-router'
import { Clock3, LogOut, ShieldCheck } from 'lucide-react'
import { AuthLayout } from '../components/AuthLayout'
import { useCurrentUser } from '../hooks/useCurrentUser'
import { getSupabaseBrowserClient } from '../lib/supabase'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/solicitud-en-revision')({
  head: () =>
    seoHead({
      title: 'Solicitud de acceso en revisión',
      description: 'Estado de la solicitud de acceso a InmínerCampus.',
      path: '/solicitud-en-revision',
      noindex: true,
    }),
  component: PendingAccessPage,
})

function PendingAccessPage() {
  const { user, loading } = useCurrentUser()

  async function signOut() {
    await getSupabaseBrowserClient()?.auth.signOut()
    window.location.assign('/')
  }

  if (loading) {
    return (
      <AuthLayout title="Comprobando tu solicitud" description="Un momento…">
        <div className="empty-state"><p>Verificando el estado de la cuenta…</p></div>
      </AuthLayout>
    )
  }

  if (user?.status === 'active') {
    return (
      <AuthLayout
        title="Acceso aprobado"
        description="Tu cuenta ya está validada y puedes entrar en el área privada."
      >
        <Link className="button button--primary button--wide" to="/mis-cursos">
          Entrar en el Campus
        </Link>
      </AuthLayout>
    )
  }

  return (
    <AuthLayout
      title="Solicitud en revisión"
      description="El acceso al contenido formativo requiere una comprobación humana previa."
    >
      <div className="access-review-card">
        <span className="access-review-card__icon">
          <ShieldCheck size={28} />
        </span>
        <h2>No necesitas volver a registrarte</h2>
        <p>
          Hemos recibido tus datos. Un administrador comprobará tu relación con
          Inmíner y habilitará la cuenta si corresponde.
        </p>
        <p className="muted">
          <Clock3 size={16} /> Recibirás una comunicación cuando termine la
          revisión. Mientras tanto, el contenido privado permanece bloqueado.
        </p>
        <Link className="button button--outline button--wide" to="/contacto">
          Contactar con Inmíner
        </Link>
        <button className="button button--ghost button--wide" onClick={signOut} type="button">
          <LogOut size={17} /> Cerrar sesión
        </button>
      </div>
    </AuthLayout>
  )
}
