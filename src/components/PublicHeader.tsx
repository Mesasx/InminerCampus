import { useEffect, useState } from 'react'
import { Link } from '@tanstack/react-router'
import { Menu } from 'lucide-react'
import { Logo } from './Logo'

const navItems = [
  { to: '/catalogo' as const, label: 'Cursos' },
  { to: '/formacion-preventiva-oficial' as const, label: 'Formación oficial' },
  { to: '/empresas' as const, label: 'Para empresas' },
  { to: '/como-funciona' as const, label: 'Cómo funciona' },
  { to: '/sobre-nosotros' as const, label: 'Sobre nosotros' },
]

const editorialNavItems = [
  { to: '/mis-cursos' as const, label: 'Mis cursos' },
  { to: '/catalogo' as const, label: 'Cursos' },
  { to: '/sobre-nosotros' as const, label: 'Sobre nosotros' },
  { to: '/perfil' as const, label: 'Mi cuenta' },
]

export function PublicHeader({ editorial = false }: { editorial?: boolean }) {
  const [isScrolled, setIsScrolled] = useState(false)
  const items = editorial ? editorialNavItems : navItems

  useEffect(() => {
    if (!editorial) return

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
  }, [editorial])

  return (
    <header
      className={`public-header${editorial ? ' public-header--editorial' : ''}${
        isScrolled ? ' public-header--scrolled' : ''
      }`}
    >
      <div className="container public-header__inner">
        <Logo inverse={editorial} />
        <nav
          className={`desktop-nav${
            editorial && !isScrolled ? ' desktop-nav--hidden' : ''
          }`}
          aria-label="Navegación principal"
          aria-hidden={editorial && !isScrolled}
        >
          {items.map((item) => (
            <Link key={item.to} to={item.to} activeProps={{ 'aria-current': 'page' }}>
              {item.label}
            </Link>
          ))}
        </nav>
        {!editorial ? (
          <div className="header-actions">
            <Link className="button button--ghost" to="/acceso">
              Acceder
            </Link>
            <Link className="button button--primary" to="/registro">
              Crear cuenta
            </Link>
          </div>
        ) : null}
        <details
          className={`mobile-menu${
            editorial && !isScrolled ? ' mobile-menu--hidden' : ''
          }`}
        >
          <summary aria-label="Abrir menú">
            <Menu size={20} />
          </summary>
        </details>
        <nav className="mobile-menu__panel" aria-label="Navegación móvil">
          {items.map((item) => (
            <Link key={item.to} to={item.to}>
              {item.label}
            </Link>
          ))}
          {!editorial ? <Link to="/acceso">Acceder</Link> : null}
          {!editorial ? <Link to="/registro">Crear cuenta</Link> : null}
        </nav>
      </div>
    </header>
  )
}
