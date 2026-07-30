import { Link, useLocation, useNavigate } from '@tanstack/react-router'
import {
  ArrowLeft,
  Award,
  BookOpen,
  CircleHelp,
  ClipboardCheck,
  KeyRound,
  LayoutDashboard,
  LogOut,
  ReceiptText,
  MessageSquareText,
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
] as const

const adminNav = [
  { href: '/admin', label: 'Resumen', icon: LayoutDashboard },
  { href: '/admin/cursos', label: 'Cursos', icon: BookOpen },
  { href: '/admin/usuarios', label: 'Usuarios', icon: UserRound },
  { href: '/admin/evaluaciones', label: 'Evaluaciones', icon: ShieldCheck },
  { href: '/admin/practicas', label: 'Prácticas', icon: ClipboardCheck },
  {
    href: '/admin/facturacion',
    label: 'Pagos y facturación',
    icon: ReceiptText,
  },
  { href: '/admin/mensajes', label: 'Mensajes', icon: MessageSquareText },
  { href: '/admin/configuracion', label: 'Configuración', icon: Settings },
] as const

const companyNav = [
  { href: '/empresa', label: 'Resumen', icon: LayoutDashboard },
  { href: '/empresa/formacion', label: 'Formación', icon: BookOpen },
  { href: '/empresa/trabajadores', label: 'Trabajadores', icon: UsersRound },
  { href: '/empresa/codigos', label: 'Códigos', icon: KeyRound },
  { href: '/empresa/facturacion', label: 'Facturación', icon: ReceiptText },
] as const

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
  const location = useLocation()
  const isInsideCourse = /^\/campus\/[^/]+/.test(location.pathname)
  const isAdministrator = user.roles.some((role) =>
    ['administrador', 'superadministrador'].includes(role),
  )
  const nav =
    mode === 'admin'
      ? [
          ...adminNav,
          { href: '/mis-cursos', label: 'Ir a mis cursos', icon: BookOpen },
        ]
      : mode === 'company'
        ? companyNav
        : isAdministrator
          ? [
              ...studentNav,
              {
                href: '/admin',
                label: 'Administración',
                icon: ShieldCheck,
              },
            ]
          : studentNav

  function confirmCourseExit() {
    return (
      !isInsideCourse ||
      window.confirm(
        'Vas a salir del curso. Tu progreso guardado se conservará. ¿Quieres salir?',
      )
    )
  }

  async function goBack() {
    const lessonMatch = location.pathname.match(
      /^\/campus\/([^/]+)\/leccion\/[^/]+/,
    )
    if (lessonMatch) {
      await navigate({
        to: '/campus/$enrollmentId',
        params: { enrollmentId: lessonMatch[1] },
      })
      return
    }
    if (isInsideCourse) {
      if (!confirmCourseExit()) return
      await navigate({ to: '/mis-cursos' })
      return
    }
    window.history.back()
  }

  async function signOut() {
    if (!confirmCourseExit()) return
    await getSupabaseBrowserClient()?.auth.signOut()
    await navigate({ to: '/', replace: true })
  }

  return (
    <div className="app-layout page-enter">
      <aside className="app-sidebar">
        <Logo
          onClick={(event) => {
            if (!confirmCourseExit()) event.preventDefault()
          }}
        />
        <nav className="app-nav" aria-label="Navegación del campus">
          {nav.map(({ href, label, icon: Icon }) => (
            <Link
              to={href}
              key={href}
              onClick={(event) => {
                if (!confirmCourseExit()) event.preventDefault()
              }}
            >
              <Icon size={18} />
              {label}
            </Link>
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
          <div className="app-topbar__context">
            <button
              aria-label="Volver atrás"
              className="app-topbar__back"
              onClick={goBack}
              type="button"
            >
              <ArrowLeft size={19} />
            </button>
            <span className="app-topbar__title">{title}</span>
          </div>
          <span className="muted">
            {user.firstName || user.email}
          </span>
        </header>
        <main className="app-content">{children}</main>
      </div>
    </div>
  )
}
