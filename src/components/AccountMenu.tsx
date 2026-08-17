import { Link, useNavigate } from '@tanstack/react-router'
import { Award, BookOpen, LogOut, UserRound } from 'lucide-react'
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
        aria-label="Mi cuenta"
        onClick={() => setOpen((value) => !value)}
      >
        {initials}
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
          <Link role="menuitem" to="/certificados" onClick={() => setOpen(false)}>
            <Award size={16} /> Certificados
          </Link>
          <button role="menuitem" type="button" onClick={signOut}>
            <LogOut size={16} /> Salir
          </button>
        </nav>
      ) : null}
    </div>
  )
}
