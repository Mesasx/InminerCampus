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
            <Link to="/catalogo">Catálogo</Link>
            <Link to="/empresas">Formación para empresas</Link>
            <Link to="/verificar-certificado">Verificar certificado</Link>
            <Link to="/contacto">Contacto</Link>
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
        </div>
      </div>
    </footer>
  )
}
