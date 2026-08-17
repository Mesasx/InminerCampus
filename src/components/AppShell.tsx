import { Link, useLocation, useNavigate } from '@tanstack/react-router'
import {
  ArrowLeft,
  BookOpen,
  ClipboardCheck,
  KeyRound,
  LayoutDashboard,
  LogOut,
  Menu,
  MessageSquareText,
  ReceiptText,
  Settings,
  ShieldCheck,
  UsersRound,
  UserRound,
  X,
} from 'lucide-react'
import { useEffect, useState, type ReactNode } from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'
import { Footer } from './Footer'
import { Logo } from './Logo'
import { PublicHeader } from './PublicHeader'

type ShellMode = 'student' | 'company' | 'admin'

const adminNav = [
  { href: '/admin', label: 'Resumen', icon: LayoutDashboard },
  { href: '/admin/cursos', label: 'Cursos', icon: BookOpen },
  { href: '/admin/usuarios', label: 'Usuarios', icon: UserRound },
  { href: '/admin/evaluaciones', label: 'Evaluaciones', icon: ShieldCheck },
  { href: '/admin/codigos', label: 'Códigos de acceso', icon: KeyRound },
  { href: '/admin/practicas', label: 'Prácticas', icon: ClipboardCheck },
  {
    href: '/admin/facturacion',
    label: 'Pagos y facturación',
    icon: ReceiptText,
  },
  { href: '/admin/mensajes', label: 'Mensajes', icon: MessageSquareText },
] as const

const companyNav = [
  { href: '/empresa', label: 'Resumen', icon: LayoutDashboard },
  { href: '/empresa/codigos', label: 'Códigos', icon: KeyRound },
] as const

const companyDynamicNav = [
  { section: 'formacion', label: 'Formación', icon: BookOpen },
  { section: 'trabajadores', label: 'Trabajadores', icon: UsersRound },
  { section: 'facturacion', label: 'Facturación', icon: ReceiptText },
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
  const [navigationOpen, setNavigationOpen] = useState(false)
  const isInsideCourse = /^\/campus\/[^/]+/.test(location.pathname)

  useEffect(() => {
    setNavigationOpen(false)
  }, [location.pathname])

  useEffect(() => {
    if (!navigationOpen) return

    const previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'

    function closeOnEscape(event: KeyboardEvent) {
      if (event.key === 'Escape') setNavigationOpen(false)
    }

    window.addEventListener('keydown', closeOnEscape)
    return () => {
      document.body.style.overflow = previousOverflow
      window.removeEventListener('keydown', closeOnEscape)
    }
  }, [navigationOpen])

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

  if (mode === 'student') {
    return (
      <>
        <PublicHeader />
        <main className="public-main page-enter">
          <div className="app-shell-context">
            <button
              aria-label="Volver atrás"
              className="app-topbar__back"
              onClick={goBack}
              type="button"
            >
              <ArrowLeft size={19} />
            </button>
            <span className="app-shell-context__title">{title}</span>
          </div>
          <div className="app-content">{children}</div>
        </main>
        <Footer />
      </>
    )
  }

  const nav = mode === 'admin' ? adminNav : companyNav

  return (
    <div className="app-layout page-enter">
      <aside
        className={
          navigationOpen ? 'app-sidebar app-sidebar--open' : 'app-sidebar'
        }
        id="campus-navigation"
      >
        <div className="app-sidebar__header">
          <Logo
            onClick={(event) => {
              if (!confirmCourseExit()) event.preventDefault()
              else setNavigationOpen(false)
            }}
          />
          <button
            aria-label="Cerrar menú"
            className="app-sidebar__close"
            onClick={() => setNavigationOpen(false)}
            type="button"
          >
            <X size={21} />
          </button>
        </div>
        <nav className="app-nav" aria-label="Navegación del campus">
          {nav.map(({ href, label, icon: Icon }) => (
            <Link
              to={href}
              key={href}
              onClick={(event) => {
                if (!confirmCourseExit()) event.preventDefault()
                else setNavigationOpen(false)
              }}
            >
              <Icon size={18} />
              {label}
            </Link>
          ))}
          {mode === 'admin' ? (
            <Link
              to="/admin/$adminSection"
              params={{ adminSection: 'configuracion' }}
              onClick={(event) => {
                if (!confirmCourseExit()) event.preventDefault()
                else setNavigationOpen(false)
              }}
            >
              <Settings size={18} />
              Configuración
            </Link>
          ) : null}
          {mode === 'company'
            ? companyDynamicNav.map(({ section, label, icon: Icon }) => (
                <Link
                  to="/empresa/$companySection"
                  params={{ companySection: section }}
                  key={section}
                  onClick={(event) => {
                    if (!confirmCourseExit()) event.preventDefault()
                    else setNavigationOpen(false)
                  }}
                >
                  <Icon size={18} />
                  {label}
                </Link>
              ))
            : null}
          <Link
            to="/mis-cursos"
            onClick={(event) => {
              if (!confirmCourseExit()) event.preventDefault()
              else setNavigationOpen(false)
            }}
          >
            <BookOpen size={18} />
            Ir a mis cursos
          </Link>
        </nav>
        <div className="app-sidebar__bottom">
          <span className="app-sidebar__user">
            {user.firstName || user.email}
          </span>
          <button className="button button--ghost" type="button" onClick={signOut}>
            <LogOut size={18} /> Salir
          </button>
        </div>
      </aside>
      <button
        aria-label="Cerrar menú"
        className={
          navigationOpen
            ? 'app-sidebar__overlay app-sidebar__overlay--visible'
            : 'app-sidebar__overlay'
        }
        onClick={() => setNavigationOpen(false)}
        tabIndex={navigationOpen ? 0 : -1}
        type="button"
      />
      <div className="app-main">
        <header className="app-topbar">
          <div className="app-topbar__context">
            <button
              aria-controls="campus-navigation"
              aria-expanded={navigationOpen}
              aria-label="Abrir menú"
              className="app-topbar__menu"
              onClick={() => setNavigationOpen(true)}
              type="button"
            >
              <Menu size={21} />
            </button>
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
          <span className="muted">{user.firstName || user.email}</span>
        </header>
        <main className="app-content">{children}</main>
        <footer className="app-credit">
          Plataforma creada por Pedro Mesas de la Fuente.
        </footer>
      </div>
    </div>
  )
}
