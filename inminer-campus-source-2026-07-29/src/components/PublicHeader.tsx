import { Link } from '@tanstack/react-router'
import { Menu } from 'lucide-react'
import { Logo } from './Logo'

const navItems = [
  { to: '/catalogo' as const, label: 'Cursos' },
  { to: '/empresas' as const, label: 'Para empresas' },
  { to: '/como-funciona' as const, label: 'Cómo funciona' },
  { to: '/sobre-nosotros' as const, label: 'Sobre nosotros' },
]

export function PublicHeader() {
  return (
    <header className="public-header">
      <div className="container public-header__inner">
        <Logo />
        <nav className="desktop-nav" aria-label="Navegación principal">
          {navItems.map((item) => (
            <Link key={item.to} to={item.to} activeProps={{ 'aria-current': 'page' }}>
              {item.label}
            </Link>
          ))}
        </nav>
        <div className="header-actions">
          <Link className="button button--ghost" to="/acceso">
            Acceder
          </Link>
          <Link className="button button--primary" to="/registro">
            Crear cuenta
          </Link>
        </div>
        <details className="mobile-menu">
          <summary aria-label="Abrir menú">
            <Menu size={20} />
          </summary>
          <nav className="mobile-menu__panel" aria-label="Navegación móvil">
            {navItems.map((item) => (
              <Link key={item.to} to={item.to}>
                {item.label}
              </Link>
            ))}
            <Link to="/acceso">Acceder</Link>
            <Link to="/registro">Crear cuenta</Link>
          </nav>
        </details>
      </div>
    </header>
  )
}
