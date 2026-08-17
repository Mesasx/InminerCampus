import { useEffect, useState } from 'react'
import { Link, useNavigate } from '@tanstack/react-router'
import { LogOut, Menu } from 'lucide-react'
import { Logo } from './Logo'
import { AccountMenu } from './AccountMenu'
import { useCurrentUser } from '../hooks/useCurrentUser'
import { getSupabaseBrowserClient } from '../lib/supabase'

const categoryNavItems: Array<{
  label: string
  categoria: 'mineria' | 'otros'
}> = [
  { label: 'Minería', categoria: 'mineria' },
  { label: 'Otros', categoria: 'otros' },
]

export function PublicHeader({ heroFull = false }: { heroFull?: boolean }) {
  const [isScrolled, setIsScrolled] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)
  const { user, loading } = useCurrentUser()
  const navigate = useNavigate()

  useEffect(() => {
    if (!heroFull) return

    const sentinel = document.getElementById('campus-hero-sentinel')
    if (!sentinel) {
      setIsScrolled(window.scrollY > 28)
      return
    }

    const observer = new IntersectionObserver(
      ([entry]) => setIsScrolled(!entry.isIntersecting),
      { rootMargin: '-1px 0px 0px 0px', threshold: 0 },
    )
    observer.observe(sentinel)
    return () => observer.disconnect()
  }, [heroFull])

  async function signOutFromMobile() {
    setMobileOpen(false)
    await getSupabaseBrowserClient()?.auth.signOut()
    await navigate({ to: '/', replace: true })
  }

  const transparent = heroFull && !isScrolled

  return (
    <header
      className={`public-header${transparent ? ' public-header--transparent' : ' public-header--scrolled'}`}
    >
      <div className="container public-header__inner">
        {transparent ? null : <Logo />}
        <nav className="desktop-nav" aria-label="Navegación principal">
          <Link to="/" activeProps={{ 'aria-current': 'page' }}>
            Campus
          </Link>
          {user ? (
            <Link to="/mis-cursos" activeProps={{ 'aria-current': 'page' }}>
              Mis cursos
            </Link>
          ) : null}
          {categoryNavItems.map((item) => (
            <Link
              key={item.categoria}
              to="/catalogo"
              search={{ categoria: item.categoria }}
              activeProps={{ 'aria-current': 'page' }}
            >
              {item.label}
            </Link>
          ))}
          <Link to="/sobre-nosotros" activeProps={{ 'aria-current': 'page' }}>
            Sobre nosotros
          </Link>
        </nav>
        <div className="header-actions">
          {loading ? null : user ? (
            <AccountMenu user={user} />
          ) : (
            <>
              <Link className="button button--ghost" to="/acceso">
                Iniciar sesión
              </Link>
              <Link className="button button--primary" to="/registro">
                Crear cuenta
              </Link>
            </>
          )}
        </div>
        <details
          className="mobile-menu"
          open={mobileOpen}
          onToggle={(event) => setMobileOpen(event.currentTarget.open)}
        >
          <summary aria-label="Abrir menú">
            <Menu size={20} />
          </summary>
        </details>
        <nav className="mobile-menu__panel" aria-label="Navegación móvil">
          <Link to="/" onClick={() => setMobileOpen(false)}>
            Campus
          </Link>
          {user ? (
            <Link to="/mis-cursos" onClick={() => setMobileOpen(false)}>
              Mis cursos
            </Link>
          ) : null}
          {categoryNavItems.map((item) => (
            <Link
              key={item.categoria}
              to="/catalogo"
              search={{ categoria: item.categoria }}
              onClick={() => setMobileOpen(false)}
            >
              {item.label}
            </Link>
          ))}
          <Link to="/sobre-nosotros" onClick={() => setMobileOpen(false)}>
            Sobre nosotros
          </Link>
          {loading ? null : user ? (
            <>
              <Link to="/perfil" onClick={() => setMobileOpen(false)}>
                Mi cuenta
              </Link>
              <button type="button" onClick={signOutFromMobile}>
                <LogOut size={16} /> Cerrar sesión
              </button>
            </>
          ) : (
            <>
              <Link to="/acceso" onClick={() => setMobileOpen(false)}>
                Iniciar sesión
              </Link>
              <Link to="/registro" onClick={() => setMobileOpen(false)}>
                Crear cuenta
              </Link>
            </>
          )}
        </nav>
      </div>
    </header>
  )
}
