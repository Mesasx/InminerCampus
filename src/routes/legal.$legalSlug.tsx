import { createFileRoute } from '@tanstack/react-router'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/legal/$legalSlug')({
  component: LegalPage,
})

const legalPages: Record<
  string,
  { title: string; description: string; sections: Array<[string, string]> }
> = {
  aviso: {
    title: 'Aviso legal',
    description:
      'Información general sobre la titularidad y el uso de InmínerCampus.',
    sections: [
      [
        'Titular',
        'InmínerCampus es una plataforma de Inmíner Ingeniería, S.L. Los datos registrales completos y el dominio definitivo deberán incorporarse antes de la publicación.',
      ],
      [
        'Uso de la plataforma',
        'El acceso y uso deben respetar la legislación aplicable, los derechos de terceros y las condiciones contratadas.',
      ],
    ],
  },
  privacidad: {
    title: 'Política de privacidad',
    description:
      'Principios aplicables al tratamiento de datos personales en la plataforma.',
    sections: [
      [
        'Finalidades',
        'Gestionar cuentas, matrículas, progreso, evaluaciones, prácticas, soporte, certificados, compras y obligaciones administrativas relacionadas con la formación.',
      ],
      [
        'Derechos',
        'Las personas usuarias podrán solicitar acceso, rectificación, supresión, limitación, portabilidad u oposición cuando proceda.',
      ],
      [
        'Minimización',
        'La plataforma está diseñada para recoger solo los datos necesarios y restringir el acceso mediante permisos y seguridad por filas.',
      ],
    ],
  },
  cookies: {
    title: 'Política de cookies',
    description:
      'Información sobre almacenamiento local y tecnologías equivalentes.',
    sections: [
      [
        'Cookies necesarias',
        'Las cookies técnicas necesarias para la sesión, la seguridad y las preferencias básicas estarán activas para prestar el servicio.',
      ],
      [
        'Cookies no esenciales',
        'La analítica o cualquier tecnología no esencial permanecerá desactivada hasta que exista consentimiento válido.',
      ],
    ],
  },
  contratacion: {
    title: 'Condiciones de contratación',
    description:
      'Condiciones generales aplicables a la compra de formación individual y empresarial.',
    sections: [
      [
        'Pedido y pago',
        'El acceso no se activa por la simple redirección del navegador. La matrícula o las plazas se habilitan después de la confirmación segura del pago.',
      ],
      [
        'Modalidad',
        'Cada ficha indicará si la formación es online, presencial o híbrida y si existen prácticas obligatorias.',
      ],
      [
        'Desistimiento y ejecución',
        'Las condiciones concretas de desistimiento, inicio anticipado y prestación digital deben validarse jurídicamente antes de la venta.',
      ],
    ],
  },
}

function LegalPage() {
  const { legalSlug } = Route.useParams()
  const page = legalPages[legalSlug] ?? legalPages.aviso

  return (
    <StaticPage
      eyebrow="Información legal"
      title={page.title}
      description={page.description}
    >
      <div className="alert alert--info" style={{ marginBottom: 28 }}>
        Texto provisional pendiente de revisión jurídica y de completar con los
        datos registrales y contractuales definitivos.
      </div>
      <div className="form-grid">
        {page.sections.map(([title, content]) => (
          <article className="panel" key={title}>
            <h2>{title}</h2>
            <p className="muted" style={{ lineHeight: 1.75, marginBottom: 0 }}>
              {content}
            </p>
          </article>
        ))}
      </div>
    </StaticPage>
  )
}
