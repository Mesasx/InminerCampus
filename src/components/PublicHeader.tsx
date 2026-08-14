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

    const updateHeader = () => setIsScrolled(window.scrollY > 28)
    updateHeader()
    window.addEventListener('scroll', updateHeader, { passive: true })
    return () => window.removeEventListener('scroll', updateHeader)
  }, [editorial])

  return (
    <header
      className={`public-header${editorial ? ' public-header--editorial' : ''}${
        isScrolled ? ' public-header--scrolled' : ''
      }`}
    >
      <div className="container public-header__inner">
        <Logo inverse={editorial} />
        <nav className="desktop-nav" aria-label="Navegación principal">
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
        <details className="mobile-menu">
          <summary aria-label="Abrir menú">
            <Menu size={20} />
          </summary>
          <nav className="mobile-menu__panel" aria-label="Navegación móvil">
            {items.map((item) => (
              <Link key={item.to} to={item.to}>
                {item.label}
              </Link>
            ))}
            {!editorial ? <Link to="/acceso">Acceder</Link> : null}
            {!editorial ? <Link to="/registro">Crear cuenta</Link> : null}
          </nav>
        </details>
      </div>
    </header>
  )
}
