import { createFileRoute, Link } from '@tanstack/react-router'
import {
  Building2,
  CalendarDays,
  Cookie,
  ExternalLink,
  FileCheck2,
  FileText,
  ShieldCheck,
} from 'lucide-react'
import type { ComponentType } from 'react'
import { StaticPage } from '../components/StaticPage'

export const Route = createFileRoute('/legal/$legalSlug')({
  component: LegalPage,
})

type LegalSection = {
  title: string
  paragraphs: string[]
  bullets?: string[]
}

type LegalDocument = {
  title: string
  description: string
  icon: ComponentType<{ size?: number }>
  sourceHref?: string
  sourceLabel?: string
  sections: LegalSection[]
}

const companyIdentity =
  'INMINER INGENIERÍA, S.L., CIF B13476148, con domicilio en Calle La Solana, 60, 13005 Ciudad Real (España). Inscrita en el Registro Mercantil de Ciudad Real, Tomo 476, Folio 92, Hoja CR-18841, Inscripción 1.ª.'

const legalPages: Record<string, LegalDocument> = {
  aviso: {
    title: 'Aviso legal',
    description:
      'Identificación del titular, reglas de acceso y marco de uso de InmínerCampus.',
    icon: FileText,
    sourceHref: 'https://inminer.es/pdf/avisos-legales-inminer.pdf',
    sourceLabel: 'Aviso legal corporativo de INMÍNER',
    sections: [
      {
        title: 'Titular de la plataforma',
        paragraphs: [
          companyIdentity,
          'Contacto: 926 21 94 17 · administracion@inminer.es · inminer.es.',
        ],
      },
      {
        title: 'Objeto y acceso',
        paragraphs: [
          'InmínerCampus es la plataforma de formación de INMINER INGENIERÍA, S.L. y facilita información, contratación, acceso a contenidos, seguimiento, evaluación, soporte y certificación de acciones formativas.',
          'El acceso a la información pública es libre. Las áreas de aprendizaje, empresa y administración requieren una cuenta y los permisos correspondientes.',
        ],
      },
      {
        title: 'Uso responsable',
        paragraphs: [
          'La persona usuaria se compromete a utilizar la plataforma de forma lícita, diligente y respetuosa con los derechos de terceros.',
        ],
        bullets: [
          'No compartir credenciales ni suplantar identidades.',
          'No interferir en la seguridad, disponibilidad o integridad del servicio.',
          'No copiar, redistribuir o explotar materiales fuera de los usos autorizados.',
          'Comunicar cualquier incidencia de seguridad o acceso indebido.',
        ],
      },
      {
        title: 'Propiedad intelectual e industrial',
        paragraphs: [
          'Los textos, recursos docentes, marcas, logotipos, imágenes, software y demás contenidos están protegidos por la normativa aplicable y pertenecen a INMINER INGENIERÍA, S.L. o a sus legítimos titulares.',
          'La matrícula concede un derecho personal y limitado de acceso para realizar la formación; no implica la cesión de derechos de explotación.',
        ],
      },
      {
        title: 'Disponibilidad y enlaces',
        paragraphs: [
          'INMÍNER trabaja para mantener la calidad y disponibilidad del servicio, aunque puede realizar tareas de mantenimiento, corregir contenidos o actualizar las condiciones de acceso.',
          'Los enlaces a servicios externos se ofrecen para completar funciones concretas. Cada tercero responde de sus propios contenidos y condiciones.',
        ],
      },
      {
        title: 'Legislación y jurisdicción',
        paragraphs: [
          'Las relaciones derivadas del uso de la plataforma se rigen por la legislación española. En relaciones con consumidores se respetará el fuero y la protección que establezca la normativa aplicable.',
        ],
      },
    ],
  },
  privacidad: {
    title: 'Política de privacidad',
    description:
      'Cómo tratamos los datos necesarios para prestar, acreditar y mejorar la formación.',
    icon: ShieldCheck,
    sourceHref: 'https://inminer.es/pdf/politica-privacidad.pdf',
    sourceLabel: 'Política de privacidad corporativa de INMÍNER',
    sections: [
      {
        title: 'Responsable del tratamiento',
        paragraphs: [
          companyIdentity,
          'Puedes plantear consultas o ejercer tus derechos por correo postal o escribiendo a administracion@inminer.es.',
        ],
      },
      {
        title: 'Datos y finalidades',
        paragraphs: [
          'Tratamos los datos que facilitas, los generados durante el uso de la plataforma y los necesarios para gestionar la relación formativa y contractual.',
        ],
        bullets: [
          'Crear y proteger la cuenta, autenticar sesiones y gestionar perfiles y roles.',
          'Gestionar matrículas, compras, plazas de empresa, progreso, evaluaciones y prácticas.',
          'Emitir, custodiar y permitir la verificación de certificados.',
          'Atender soporte, consultas, incidencias y obligaciones administrativas.',
          'Prevenir fraude, mantener la seguridad y cumplir obligaciones legales.',
        ],
      },
      {
        title: 'Bases jurídicas',
        paragraphs: [
          'El tratamiento se apoya, según cada finalidad, en la ejecución de la relación contractual o precontractual, el cumplimiento de obligaciones legales, el consentimiento cuando sea necesario y el interés legítimo en proteger y mejorar el servicio sin perjudicar los derechos de las personas.',
        ],
      },
      {
        title: 'Destinatarios y proveedores',
        paragraphs: [
          'No se prevén comunicaciones ajenas a la prestación del servicio, salvo obligación legal. Determinados proveedores tecnológicos pueden tratar datos por cuenta de INMÍNER para prestar alojamiento, autenticación, pagos, comunicaciones o seguridad.',
          'Los pagos se procesan mediante Stripe. La plataforma utiliza Supabase para funciones de base de datos y autenticación. Cada proveedor actúa conforme a sus condiciones y garantías de protección de datos.',
        ],
      },
      {
        title: 'Conservación y seguridad',
        paragraphs: [
          'Los datos se conservan durante el tiempo necesario para prestar la formación, acreditar sus resultados, atender responsabilidades y cumplir los plazos legales. Después se suprimen o bloquean de forma segura.',
          'Aplicamos control de acceso por roles, trazabilidad, validación de sesión y restricciones por fila para reducir accesos no autorizados.',
        ],
      },
      {
        title: 'Tus derechos',
        paragraphs: [
          'Puedes solicitar acceso, rectificación, supresión, limitación, portabilidad u oposición cuando proceda, así como retirar un consentimiento sin afectar a los tratamientos anteriores.',
          'Si consideras que tus derechos no han sido atendidos, puedes reclamar ante la Agencia Española de Protección de Datos (aepd.es).',
        ],
      },
    ],
  },
  cookies: {
    title: 'Política de cookies',
    description:
      'Tecnologías necesarias para la sesión, la seguridad y las preferencias de la plataforma.',
    icon: Cookie,
    sourceHref: 'https://inminer.es/pdf/politica-cookies-inminer.pdf',
    sourceLabel: 'Política de cookies corporativa de INMÍNER',
    sections: [
      {
        title: 'Qué son',
        paragraphs: [
          'Las cookies y tecnologías equivalentes permiten recordar información en el navegador, mantener una sesión, conservar preferencias o conocer cómo funciona un servicio.',
        ],
      },
      {
        title: 'Tecnologías necesarias',
        paragraphs: [
          'InmínerCampus utiliza el almacenamiento imprescindible para autenticar la sesión, proteger la cuenta, conservar preferencias funcionales y completar procesos expresamente solicitados.',
          'Estas tecnologías son necesarias para prestar el servicio y no se utilizan para crear perfiles publicitarios.',
        ],
      },
      {
        title: 'Servicios externos',
        paragraphs: [
          'Al iniciar un pago o utilizar una función protegida frente a abuso pueden intervenir servicios externos como Stripe o Cloudflare Turnstile. Esos servicios pueden aplicar sus propias tecnologías técnicas y de seguridad.',
        ],
      },
      {
        title: 'Analítica y publicidad',
        paragraphs: [
          'La plataforma no activa analítica, publicidad comportamental ni tecnologías no esenciales sin una base válida y, cuando resulte exigible, sin consentimiento previo.',
          'Si en el futuro se incorporan nuevas herramientas, se actualizará esta política y el panel de preferencias antes de activarlas.',
        ],
      },
      {
        title: 'Cómo controlarlas',
        paragraphs: [
          'Puedes borrar o bloquear datos desde la configuración del navegador. Si desactivas tecnologías estrictamente necesarias, es posible que no puedas iniciar sesión, comprar o continuar una formación.',
        ],
      },
    ],
  },
  contratacion: {
    title: 'Condiciones de contratación',
    description:
      'Reglas esenciales para compras individuales y plazas de formación para empresas.',
    icon: FileCheck2,
    sections: [
      {
        title: 'Prestador y alcance',
        paragraphs: [
          companyIdentity,
          'Estas condiciones se aplican a la contratación de cursos y plazas empresariales ofrecidos en InmínerCampus. La ficha de cada oferta forma parte de la información contractual.',
        ],
      },
      {
        title: 'Oferta, modalidad y precio',
        paragraphs: [
          'Cada ficha identifica el curso, versión, duración, modalidad, prácticas, requisitos, precio y moneda. Las versiones de 5 y 20 horas son ofertas distintas y pueden tener precios diferentes.',
          'Los importes se muestran antes de confirmar el pedido. Stripe presenta el desglose fiscal y el total definitivo antes del pago.',
        ],
      },
      {
        title: 'Pago y activación',
        paragraphs: [
          'El pago se realiza mediante la pasarela segura de Stripe. Una redirección del navegador no acredita por sí sola el pago.',
          'La matrícula individual o las plazas de empresa se activan después de recibir y validar la confirmación segura del proveedor de pagos.',
        ],
      },
      {
        title: 'Acceso y realización',
        paragraphs: [
          'El acceso es personal, salvo los códigos de plaza adquiridos por una organización para sus trabajadores. La persona usuaria debe cumplir el itinerario, evaluaciones, asistencia y prácticas indicados en la ficha.',
          'Superar contenido online no sustituye las prácticas o validaciones presenciales cuando sean obligatorias.',
        ],
      },
      {
        title: 'Desistimiento, cancelaciones y reembolsos',
        paragraphs: [
          'Los derechos de desistimiento y cancelación dependen de la condición del comprador, la naturaleza del contenido y el momento de inicio de la prestación. Cuando la ley lo exija, se solicitará el consentimiento correspondiente antes de comenzar contenido digital durante el plazo de desistimiento.',
          'Para solicitar información, cancelar una edición o plantear una incidencia, escribe a administracion@inminer.es indicando el número de pedido.',
        ],
      },
      {
        title: 'Soporte y reclamaciones',
        paragraphs: [
          'Puedes contactar en administracion@inminer.es, llamar al 926 21 94 17 o dirigirte a Calle La Solana, 60, 13005 Ciudad Real.',
          'INMÍNER atenderá incidencias de acceso, facturación y formación procurando una solución proporcionada y conforme a la normativa de consumo aplicable.',
        ],
      },
    ],
  },
}

const legalNavigation = [
  ['aviso', 'Aviso legal'],
  ['privacidad', 'Privacidad'],
  ['cookies', 'Cookies'],
  ['contratacion', 'Contratación'],
] as const

function LegalPage() {
  const { legalSlug } = Route.useParams()
  const page = legalPages[legalSlug] ?? legalPages.aviso
  const Icon = page.icon

  return (
    <StaticPage
      eyebrow="Información legal"
      title={page.title}
      description={page.description}
    >
      <nav className="legal-nav" aria-label="Documentos legales">
        {legalNavigation.map(([slug, label]) => (
          <Link
            aria-current={legalSlug === slug ? 'page' : undefined}
            key={slug}
            params={{ legalSlug: slug }}
            to="/legal/$legalSlug"
          >
            {label}
          </Link>
        ))}
      </nav>

      <div className="legal-overview">
        <span className="legal-overview__icon">
          <Icon size={28} />
        </span>
        <div>
          <span className="eyebrow">Documento vigente</span>
          <h2>{page.title}</h2>
          <p>
            Información adaptada a InmínerCampus a partir de la documentación
            corporativa oficial de INMÍNER y de las funciones reales de la
            plataforma.
          </p>
        </div>
        <div className="legal-overview__meta">
          <span>
            <CalendarDays size={17} /> Actualizado el 29 de julio de 2026
          </span>
          <span>
            <Building2 size={17} /> INMINER INGENIERÍA, S.L.
          </span>
          {page.sourceHref ? (
            <a href={page.sourceHref} rel="noreferrer" target="_blank">
              <ExternalLink size={17} /> {page.sourceLabel}
            </a>
          ) : null}
        </div>
      </div>

      <div className="legal-grid">
        {page.sections.map((section, index) => (
          <article className="legal-card" key={section.title}>
            <span className="legal-card__number">
              {String(index + 1).padStart(2, '0')}
            </span>
            <div>
              <h2>{section.title}</h2>
              {section.paragraphs.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
              {section.bullets ? (
                <ul>
                  {section.bullets.map((bullet) => (
                    <li key={bullet}>{bullet}</li>
                  ))}
                </ul>
              ) : null}
            </div>
          </article>
        ))}
      </div>

      <p className="legal-note legal-note--footer">
        Si necesitas aclarar cómo se aplica alguno de estos apartados a tu
        matrícula o empresa, contacta con INMÍNER antes de contratar.
      </p>
    </StaticPage>
  )
}
