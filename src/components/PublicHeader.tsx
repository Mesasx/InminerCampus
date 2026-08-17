import { useEffect, useState } from 'react'
import { Link } from '@tanstack/react-router'
import { Menu } from 'lucide-react'
import { Logo } from './Logo'
import { AccountMenu } from './AccountMenu'
import { useCurrentUser } from '../hooks/useCurrentUser'

const primaryNavItems = [
  { to: '/' as const, label: 'Campus' },
  { to: '/mis-cursos' as const, label: 'Mis cursos' },
] satisfies Array<{ to: '/' | '/mis-cursos'; label: string }>

const categoryNavItems: Array<{
  label: string
  categoria: 'vip' | 'mineria' | 'otros'
}> = [
  { label: 'VIP', categoria: 'vip' },
  { label: 'Minería', categoria: 'mineria' },
  { label: 'Otros', categoria: 'otros' },
]

export function PublicHeader({ heroFull = false }: { heroFull?: boolean }) {
  const [isScrolled, setIsScrolled] = useState(false)
  const { user } = useCurrentUser()

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

  const transparent = heroFull && !isScrolled

  return (
    <header
      className={`public-header${transparent ? ' public-header--transparent' : ' public-header--scrolled'}`}
    >
      <div className="container public-header__inner">
        <Logo inverse={transparent} />
        <nav className="desktop-nav" aria-label="Navegación principal">
          {primaryNavItems.map((item) => (
            <Link key={item.to} to={item.to} activeProps={{ 'aria-current': 'page' }}>
              {item.label}
            </Link>
          ))}
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
          {user ? (
            <AccountMenu user={user} />
          ) : (
            <>
              <Link className="button button--ghost" to="/acceso">
                Acceder
              </Link>
              <Link className="button button--primary" to="/registro">
                Crear cuenta
              </Link>
            </>
          )}
        </div>
        <details className="mobile-menu">
          <summary aria-label="Abrir menú">
            <Menu size={20} />
          </summary>
        </details>
        <nav className="mobile-menu__panel" aria-label="Navegación móvil">
          {primaryNavItems.map((item) => (
            <Link key={item.to} to={item.to}>
              {item.label}
            </Link>
          ))}
          {categoryNavItems.map((item) => (
            <Link
              key={item.categoria}
              to="/catalogo"
              search={{ categoria: item.categoria }}
            >
              {item.label}
            </Link>
          ))}
          <Link to="/sobre-nosotros">Sobre nosotros</Link>
          {user ? (
            <>
              <Link to="/perfil">Mi cuenta</Link>
              <Link to="/certificados">Certificados</Link>
            </>
          ) : (
            <>
              <Link to="/acceso">Acceder</Link>
              <Link to="/registro">Crear cuenta</Link>
            </>
          )}
        </nav>
      </div>
    </header>
  )
}
