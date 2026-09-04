// Constructores de datos estructurados (JSON-LD).
//
// Regla que se aplica en todo el archivo: sólo se emiten propiedades cuyo
// valor existe realmente en la base de datos o en el aviso legal. Nunca se
// inventan acreditaciones, valoraciones ni fechas. Si un dato falta, la
// propiedad se omite en vez de rellenarse con un valor por defecto.
import { ORGANIZATION, SITE_NAME, SITE_URL, absoluteUrl } from './seo.ts'

export type JsonLd = Record<string, unknown>

const ORGANIZATION_ID = `${SITE_URL}/#organization`
const WEBSITE_ID = `${SITE_URL}/#website`

/**
 * Identidad de la empresa. Se emite una sola vez (en la home) y el resto de
 * páginas la referencian por `@id`, de modo que Google consolide una única
 * entidad en lugar de repetirla suelta en cada URL.
 */
export function organizationSchema(): JsonLd {
  return {
    '@type': 'EducationalOrganization',
    '@id': ORGANIZATION_ID,
    name: SITE_NAME,
    legalName: ORGANIZATION.legalName,
    url: SITE_URL,
    logo: absoluteUrl('/brand/inminer-campus-logo.png'),
    image: absoluteUrl('/brand/inminer-campus-logo.png'),
    description:
      'Plataforma de formación técnica y preventiva de INMINER INGENIERÍA, S.L., especializada en seguridad minera y en la formación preventiva regulada por el Reglamento General de Normas Básicas de Seguridad Minera.',
    vatID: ORGANIZATION.vatID,
    taxID: ORGANIZATION.taxID,
    email: ORGANIZATION.email,
    telephone: ORGANIZATION.telephone,
    address: {
      '@type': 'PostalAddress',
      streetAddress: ORGANIZATION.streetAddress,
      postalCode: ORGANIZATION.postalCode,
      addressLocality: ORGANIZATION.addressLocality,
      addressRegion: ORGANIZATION.addressRegion,
      addressCountry: ORGANIZATION.addressCountry,
    },
    // Ámbito de actuación: señal explícita de que la oferta se dirige a España.
    areaServed: { '@type': 'Country', name: 'España' },
    knowsLanguage: 'es-ES',
    // `parentOrganization` mantiene explícita la relación de marca
    // InmínerCampus -> INMÍNER Ingeniería, que hoy sólo se deduce del texto.
    parentOrganization: {
      '@type': 'Organization',
      name: ORGANIZATION.legalName,
      url: ORGANIZATION.corporateSite,
    },
    sameAs: [ORGANIZATION.corporateSite],
    contactPoint: {
      '@type': 'ContactPoint',
      contactType: 'customer service',
      telephone: ORGANIZATION.telephone,
      email: ORGANIZATION.email,
      areaServed: 'ES',
      availableLanguage: ['es-ES'],
    },
  }
}

export function webSiteSchema(): JsonLd {
  return {
    '@type': 'WebSite',
    '@id': WEBSITE_ID,
    name: SITE_NAME,
    url: SITE_URL,
    inLanguage: 'es-ES',
    publisher: { '@id': ORGANIZATION_ID },
  }
}

export type BreadcrumbItem = { name: string; path: string }

export function breadcrumbSchema(items: Array<BreadcrumbItem>): JsonLd {
  return {
    '@type': 'BreadcrumbList',
    itemListElement: items.map((item, index) => ({
      '@type': 'ListItem',
      position: index + 1,
      name: item.name,
      item: absoluteUrl(item.path),
    })),
  }
}

/** Traduce la modalidad interna al vocabulario de Schema.org. */
export function schemaCourseMode(modality: string): string | null {
  switch (modality) {
    case 'online':
      return 'online'
    case 'in_person':
      return 'onsite'
    case 'hybrid':
      return 'blended'
    default:
      return null
  }
}

export type CourseSchemaVersion = {
  durationHours: number
  modality: string
  priceNet: number | null
  currency: string
}

export type CourseSchemaInput = {
  slug: string
  title: string
  description: string
  /** `true` si el curso se comercializa; los de acceso por código no llevan oferta. */
  purchasable: boolean
  versions: Array<CourseSchemaVersion>
}

/**
 * `Course` con una instancia por versión publicada (5 h de reciclaje y 20 h de
 * formación inicial son instancias distintas del mismo curso, no dos cursos).
 */
export function courseSchema(input: CourseSchemaInput): JsonLd {
  const url = absoluteUrl(`/cursos/${input.slug}`)

  const instances = input.versions.map((version) => {
    const mode = schemaCourseMode(version.modality)
    const instance: JsonLd = {
      '@type': 'CourseInstance',
      name: `${input.title} · ${version.durationHours} horas`,
      // ISO 8601: 20 horas lectivas -> PT20H.
      courseWorkload: `PT${version.durationHours}H`,
    }
    if (mode) instance.courseMode = mode
    return instance
  })

  const offers = input.purchasable
    ? input.versions
        .filter((version) => version.priceNet !== null)
        .map((version) => ({
          '@type': 'Offer',
          price: String(version.priceNet),
          priceCurrency: version.currency || 'EUR',
          // Los precios del catálogo son netos: declararlo evita que el
          // resultado enriquecido muestre un importe distinto al del checkout.
          valueAddedTaxIncluded: false,
          availability: 'https://schema.org/InStock',
          category: 'Formación profesional',
          url,
        }))
    : []

  const schema: JsonLd = {
    '@type': 'Course',
    '@id': `${url}#course`,
    name: input.title,
    description: input.description,
    url,
    inLanguage: 'es-ES',
    provider: { '@id': ORGANIZATION_ID },
    // Google exige uno de estos dos campos en `Course` desde 2024.
    hasCourseInstance: instances,
  }
  if (offers.length) schema.offers = offers
  return schema
}

export type FaqItem = { question: string; answer: string }

/**
 * `FAQPage`. Sólo debe usarse en páginas donde las mismas preguntas y
 * respuestas son visibles para el usuario.
 */
export function faqSchema(items: Array<FaqItem>): JsonLd {
  return {
    '@type': 'FAQPage',
    mainEntity: items.map((item) => ({
      '@type': 'Question',
      name: item.question,
      acceptedAnswer: { '@type': 'Answer', text: item.answer },
    })),
  }
}

/** Envuelve uno o varios nodos en un único `@graph`. */
export function jsonLdGraph(nodes: Array<JsonLd>): string {
  return JSON.stringify({ '@context': 'https://schema.org', '@graph': nodes })
}
