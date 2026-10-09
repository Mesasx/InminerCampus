import { Link } from '@tanstack/react-router'
import { ORGANIZATION } from '../lib/seo'
import { InminerLink } from './InminerLink'
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
            <Link to="/catalogo" search={{ categoria: 'mineria' }}>Minería</Link>
            <Link to="/catalogo" search={{ categoria: 'otros' }}>Otros</Link>
            <Link to="/formacion-minera">Formación minera</Link>
            <Link to="/itc-02-1-02">ITC 02.1.02</Link>
            <Link to="/itc-02-0-02">ITC 02.0.02 · polvo y sílice</Link>
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
            InmínerCampus es la plataforma de formación de{' '}
            <InminerLink suffix=", S.L." />
          </span>
          {/* Datos de la empresa titular, idénticos a los del aviso legal y a
              los datos estructurados: identifican sin ambigüedad a la entidad
              española frente a otras con nombres parecidos. */}
          <span>
            {ORGANIZATION.legalName} · CIF {ORGANIZATION.taxID} ·{' '}
            {ORGANIZATION.streetAddress}, {ORGANIZATION.postalCode}{' '}
            {ORGANIZATION.addressLocality} (España)
          </span>
          <span>
            Plataforma creada por{' '}
            <a
              className="text-link"
              href="https://mesasx.com"
              rel="noopener noreferrer"
              target="_blank"
            >
              Pedro Mesas de la Fuente
            </a>
            .
          </span>
        </div>
      </div>
    </footer>
  )
}
