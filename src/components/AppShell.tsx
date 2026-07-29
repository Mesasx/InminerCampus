import { Link, useNavigate } from '@tanstack/react-router'
import {
  Award,
  BookOpen,
  CircleHelp,
  KeyRound,
  LayoutDashboard,
  LogOut,
  ReceiptText,
  Settings,
  ShieldCheck,
  UsersRound,
  UserRound,
} from 'lucide-react'
import type { ReactNode } from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'
import { Logo } from './Logo'

type ShellMode = 'student' | 'company' | 'admin'

const studentNav = [
  { href: '/mis-cursos', label: 'Mis cursos', icon: LayoutDashboard },
  { href: '/catalogo', label: 'Catálogo', icon: BookOpen },
  { href: '/canjear-codigo', label: 'Canjear código', icon: KeyRound },
  { href: '/certificados', label: 'Certificados', icon: Award },
  { href: '/dudas', label: 'Dudas', icon: CircleHelp },
  { href: '/perfil', label: 'Perfil', icon: UserRound },
]

const adminNav = [
  { href: '/admin', label: 'Resumen', icon: LayoutDashboard },
  { href: '/admin/cursos', label: 'Cursos', icon: BookOpen },
  { href: '/admin/usuarios', label: 'Usuarios', icon: UserRound },
  { href: '/admin/evaluaciones', label: 'Evaluaciones', icon: ShieldCheck },
  { href: '/admin/configuracion', label: 'Configuración', icon: Settings },
]

const companyNav = [
  { href: '/empresa', label: 'Resumen', icon: LayoutDashboard },
  { href: '/empresa/formacion', label: 'Formación', icon: BookOpen },
  { href: '/empresa/trabajadores', label: 'Trabajadores', icon: UsersRound },
  { href: '/empresa/codigos', label: 'Códigos', icon: KeyRound },
  { href: '/empresa/facturacion', label: 'Facturación', icon: ReceiptText },
]

export function AppShell({
  user,
  mode = 'student',
  title,
  children,
}: {
  user: SessionUser
  mode?: ShellMode
  title: string
  children: ReactNode
}) {
  const navigate = useNavigate()
  const nav =
    mode === 'admin' ? adminNav : mode === 'company' ? companyNav : studentNav

  async function signOut() {
    await getSupabaseBrowserClient()?.auth.signOut()
    await navigate({ to: '/', replace: true })
  }

  return (
    <div className="app-layout page-enter">
      <aside className="app-sidebar">
        <Logo />
        <nav className="app-nav" aria-label="Navegación del campus">
          {nav.map(({ href, label, icon: Icon }) => (
            <a href={href} key={href}>
              <Icon size={18} />
              {label}
            </a>
          ))}
        </nav>
        <div className="app-sidebar__bottom">
          <button className="button button--ghost" type="button" onClick={signOut}>
            <LogOut size={18} /> Salir
          </button>
        </div>
      </aside>
      <div className="app-main">
        <header className="app-topbar">
          <span className="app-topbar__title">{title}</span>
          <span className="muted">
            {user.firstName || user.email}
          </span>
        </header>
        <main className="app-content">{children}</main>
      </div>
    </div>
  )
}
