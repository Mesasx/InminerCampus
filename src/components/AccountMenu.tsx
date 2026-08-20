import { Link, useNavigate } from '@tanstack/react-router'
import { BookOpen, LayoutDashboard, LogOut, UserRound } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export function AccountMenu({ user }: { user: SessionUser }) {
  const [open, setOpen] = useState(false)
  const rootRef = useRef<HTMLDivElement>(null)
  const navigate = useNavigate()

  useEffect(() => {
    if (!open) return

    function onPointerDown(event: PointerEvent) {
      if (!rootRef.current?.contains(event.target as Node)) setOpen(false)
    }
    function onKeyDown(event: KeyboardEvent) {
      if (event.key === 'Escape') setOpen(false)
    }
    window.addEventListener('pointerdown', onPointerDown)
    window.addEventListener('keydown', onKeyDown)
    return () => {
      window.removeEventListener('pointerdown', onPointerDown)
      window.removeEventListener('keydown', onKeyDown)
    }
  }, [open])

  const initials = (user.firstName?.[0] || user.email[0] || '?').toUpperCase()
  const isAdmin = user.roles.some(
    (role) => role === 'administrador' || role === 'superadministrador',
  )

  async function signOut() {
    setOpen(false)
    await getSupabaseBrowserClient()?.auth.signOut()
    await navigate({ to: '/', replace: true })
  }

  return (
    <div className="account-menu" ref={rootRef}>
      <button
        type="button"
        className="account-menu__trigger"
        aria-haspopup="menu"
        aria-expanded={open}
        onClick={() => setOpen((value) => !value)}
      >
        <span className="account-menu__avatar" aria-hidden="true">
          {initials}
        </span>
        <span className="account-menu__label">
          {user.firstName || 'Mi cuenta'}
        </span>
      </button>
      {open ? (
        <nav className="account-menu__panel" role="menu" aria-label="Mi cuenta">
          <span className="account-menu__name">
            {user.firstName || user.email}
          </span>
          <Link role="menuitem" to="/perfil" onClick={() => setOpen(false)}>
            <UserRound size={16} /> Mi cuenta
          </Link>
          <Link role="menuitem" to="/mis-cursos" onClick={() => setOpen(false)}>
            <BookOpen size={16} /> Mis cursos
          </Link>
          {isAdmin ? (
            <Link role="menuitem" to="/admin" onClick={() => setOpen(false)}>
              <LayoutDashboard size={16} /> Panel de administración
            </Link>
          ) : null}
          <button role="menuitem" type="button" onClick={signOut}>
            <LogOut size={16} /> Cerrar sesión
          </button>
        </nav>
      ) : null}
    </div>
  )
}
