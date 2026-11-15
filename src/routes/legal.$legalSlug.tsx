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
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/legal/$legalSlug')({
  // Cada documento legal tiene título y descripción propios: sin esto los
  // cuatro compartían el mismo `<title>` genérico del sitio.
  head: ({ params }) => {
    const document = legalPages[params.legalSlug]
    if (!document) return {}
    return seoHead({
      title: document.title,
      description: document.description,
      path: `/legal/${params.legalSlug}`,
    })
  },
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
          'InmínerCampus es el entorno privado de formación de INMINER INGENIERÍA, S.L. y facilita información introductoria, acceso autorizado a contenidos, seguimiento, evaluación, soporte y gestión de evidencias formativas.',
          'El acceso a la información introductoria es libre. Las áreas de aprendizaje, empresa y administración requieren una cuenta, validación humana previa y los permisos correspondientes. Registrarse no genera un derecho automático de acceso.',
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
          'Tratamos los datos que facilitas, los generados durante el uso de la plataforma y los necesarios para comprobar la relación profesional y gestionar la actividad formativa autorizada.',
        ],
        bullets: [
          'Crear y proteger la cuenta, autenticar sesiones y gestionar perfiles y roles.',
          'Revisar solicitudes, validar la relación con Inmíner y gestionar asignaciones, progreso, evaluaciones y demás evidencias.',
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
        title: 'Datos facilitados por organizaciones vinculadas',
        paragraphs: [
          'Una empresa cliente o colaboradora puede facilitar los datos profesionales imprescindibles de las personas autorizadas para verificar su vinculación, asignar el acceso, prestar soporte y realizar el seguimiento permitido.',
          'La organización debe estar legitimada para facilitar esos datos y proporcionar a las personas afectadas la información pertinente.',
        ],
      },
      {
        title: 'Destinatarios y proveedores',
        paragraphs: [
          'No se prevén comunicaciones ajenas a la prestación del servicio, salvo obligación legal. Determinados proveedores tecnológicos pueden tratar datos por cuenta de INMÍNER para prestar alojamiento, autenticación, comunicaciones o seguridad.',
          'La plataforma utiliza Supabase para funciones de base de datos y autenticación. Cada proveedor actúa conforme a sus condiciones y garantías de protección de datos.',
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
          'Al utilizar una función protegida frente a abuso pueden intervenir servicios externos como Cloudflare Turnstile. Esos servicios pueden aplicar sus propias tecnologías técnicas y de seguridad.',
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
          'Puedes borrar o bloquear datos desde la configuración del navegador. Si desactivas tecnologías estrictamente necesarias, es posible que no puedas iniciar sesión o continuar una formación autorizada.',
        ],
      },
    ],
  },
  contratacion: {
    title: 'Condiciones de acceso',
    description:
      'Reglas de solicitud, validación y uso del área privada de InmínerCampus.',
    icon: FileCheck2,
    sections: [
      {
        title: 'Titular y finalidad',
        paragraphs: [
          companyIdentity,
          'InmínerCampus es un entorno de acceso restringido destinado a personas y organizaciones vinculadas profesionalmente con Inmíner. La web pública presenta información introductoria y no constituye una oferta de contratación por internet.',
        ],
      },
      {
        title: 'Solicitud y validación',
        paragraphs: [
          'La creación de una cuenta inicia una solicitud. La persona debe facilitar datos veraces sobre identidad, empresa, puesto, relación con Inmíner y motivo de acceso.',
          'La confirmación del correo electrónico no activa el Campus. Un administrador revisa la solicitud y puede aprobarla, solicitar aclaraciones, suspenderla o denegarla.',
        ],
      },
      {
        title: 'Asignación de formación',
        paragraphs: [
          'Una cuenta aprobada no obtiene acceso indiscriminado al catálogo. Inmíner asigna o autoriza únicamente las formaciones que correspondan a la relación profesional y a la necesidad previamente comprobada.',
          'La introducción pública de un curso no sustituye la confirmación individual de su alcance, requisitos, calendario o condiciones aplicables.',
        ],
      },
      {
        title: 'Acceso personal e intransferible',
        paragraphs: [
          'Las credenciales y autorizaciones son personales. No pueden compartirse, cederse, revenderse ni utilizarse para acceder en nombre de otra persona.',
          'Inmíner puede suspender el acceso cuando detecte datos inexactos, una relación no acreditada, uso indebido, extracción de materiales o cualquier riesgo para la seguridad o confidencialidad del Campus.',
        ],
      },
      {
        title: 'Contenido y confidencialidad',
        paragraphs: [
          'Los materiales, evaluaciones y recursos del área privada se facilitan exclusivamente para la finalidad formativa autorizada. No se permite copiarlos, publicarlos, redistribuirlos ni emplearlos fuera de ese contexto.',
        ],
        bullets: [
          'No compartir capturas, audios, diapositivas, manuales o preguntas de evaluación.',
          'No facilitar credenciales ni códigos de acceso a terceros.',
          'Comunicar inmediatamente cualquier acceso no autorizado.',
        ],
      },
      {
        title: 'Seguimiento y evidencias',
        paragraphs: [
          'La plataforma registra actividad, avance y resultados para gestionar el itinerario y conservar la trazabilidad exigible. La emisión de cualquier documento depende del cumplimiento de todos los requisitos definidos para la acción formativa.',
        ],
      },
      {
        title: 'Consultas e incidencias',
        paragraphs: [
          'Puedes contactar en administracion@inminer.es, llamar al 926 21 94 17 o dirigirte a Calle La Solana, 60, 13005 Ciudad Real.',
          'INMÍNER atenderá las consultas sobre validación, acceso y formación y revisará cualquier incidencia comunicada por la persona interesada o su organización.',
        ],
      },
    ],
  },
}

const legalNavigation = [
  ['aviso', 'Aviso legal'],
  ['privacidad', 'Privacidad'],
  ['cookies', 'Cookies'],
  ['contratacion', 'Condiciones de acceso'],
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
            <CalendarDays size={17} /> Actualizado el 15 de noviembre de 2026
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
      <p className="legal-note legal-note--footer">
        Los textos relativos al flujo empresarial deben revisarse por asesoría
        jurídica y de protección de datos antes de su publicación en producción.
      </p>
    </StaticPage>
  )
}
