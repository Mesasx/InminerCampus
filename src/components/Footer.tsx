import { Link } from '@tanstack/react-router'
import { Logo } from './Logo'

export function Footer() {
  return (
    <footer className="footer">
      <div className="container">
        <div className="footer__grid">
          <div>
            <Logo inverse />
            <p style={{ maxWidth: 490, marginTop: 24, lineHeight: 1.65 }}>
              Formación técnica y preventiva con trazabilidad, evaluación y
              acompañamiento profesional.
            </p>
          </div>
          <div className="footer__links">
            <strong>Plataforma</strong>
            <Link to="/">Campus</Link>
            <Link to="/catalogo">Catálogo</Link>
            <Link to="/mis-cursos">Mis cursos</Link>
            <Link to="/sobre-nosotros">Sobre nosotros</Link>
            <Link to="/contacto">Contacto</Link>
          </div>
          <div className="footer__links">
            <strong>Categorías</strong>
            <Link to="/catalogo" search={{ categoria: 'vip' }}>VIP</Link>
            <Link to="/catalogo" search={{ categoria: 'mineria' }}>Minería</Link>
            <Link to="/catalogo" search={{ categoria: 'otros' }}>Otros</Link>
            <Link to="/formacion-preventiva-oficial">Formación Preventiva Oficial</Link>
            <Link to="/verificar-certificado">Verificar certificado</Link>
          </div>
          <div className="footer__links">
            <strong>Legal</strong>
            <Link to="/legal/$legalSlug" params={{ legalSlug: 'aviso' }}>
              Aviso legal
            </Link>
            <Link to="/legal/$legalSlug" params={{ legalSlug: 'privacidad' }}>
              Privacidad
            </Link>
            <Link to="/legal/$legalSlug" params={{ legalSlug: 'cookies' }}>
              Cookies
            </Link>
            <Link to="/legal/$legalSlug" params={{ legalSlug: 'contratacion' }}>
              Condiciones de contratación
            </Link>
          </div>
        </div>
        <div className="footer__legal">
          <span>
            © {new Date().getFullYear()} Inmíner Ingeniería, S.L.
          </span>
          <span>
            InmínerCampus es la plataforma de formación de Inmíner Ingeniería,
            S.L.
          </span>
          <span>Plataforma creada por Pedro Mesas de la Fuente.</span>
        </div>
      </div>
    </footer>
  )
}
