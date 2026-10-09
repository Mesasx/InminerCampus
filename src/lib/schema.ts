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
 * Identificador de la empresa titular. Vive en este dominio (y no en
 * inminer.es) porque es aquí donde se declara el nodo completo; `url` y
 * `sameAs` ya apuntan a la web corporativa.
 */
export const INMINER_ID = `${SITE_URL}/#inminer-ingenieria`

/**
 * Variantes con las que se escribe la marca. Existen otras entidades
 * extranjeras con nombres parecidos a «Inminer»: declarar las variantes junto
 * a la empresa, el país y la web corporativa ayuda a que el buscador no las
 * confunda.
 */
const CAMPUS_ALTERNATE_NAMES = ['Inmíner Campus', 'Inminer Campus', 'InminerCampus']

const POSTAL_ADDRESS = {
  '@type': 'PostalAddress',
  streetAddress: ORGANIZATION.streetAddress,
  postalCode: ORGANIZATION.postalCode,
  addressLocality: ORGANIZATION.addressLocality,
  addressRegion: ORGANIZATION.addressRegion,
  addressCountry: ORGANIZATION.addressCountry,
} as const

/**
 * Empresa titular: INMINER INGENIERÍA, S.L. Los datos fiscales y de contacto
 * son los del aviso legal. Es la entidad jurídica; InmínerCampus es su
 * plataforma de formación.
 */
export function inminerIngenieriaSchema(): JsonLd {
  return {
    '@type': 'Organization',
    '@id': INMINER_ID,
    name: ORGANIZATION.name,
    legalName: ORGANIZATION.legalName,
    alternateName: ['INMÍNER', 'Inminer Ingeniería', 'INMINER INGENIERÍA'],
    url: ORGANIZATION.corporateSite,
    description:
      'Ingeniería multidisciplinar con sede en Ciudad Real que trabaja en minería, industria, seguridad industrial, medioambiente y energía.',
    vatID: ORGANIZATION.vatID,
    taxID: ORGANIZATION.taxID,
    email: ORGANIZATION.email,
    telephone: ORGANIZATION.telephone,
    address: POSTAL_ADDRESS,
    areaServed: { '@type': 'Country', name: 'España' },
    knowsAbout: [
      'Ingeniería de minas',
      'Seguridad minera',
      'Prevención de riesgos laborales en actividades extractivas',
      'Seguridad industrial',
      'Medio ambiente',
    ],
    subOrganization: { '@id': ORGANIZATION_ID },
  }
}

/**
 * Identidad de la plataforma. Se emite completa en la home y en «Sobre
 * nosotros», y el resto de páginas la referencian por `@id`, de modo que
 * Google consolide una única entidad en lugar de repetirla suelta en cada URL.
 */
export function organizationSchema(): JsonLd {
  return {
    '@type': 'EducationalOrganization',
    '@id': ORGANIZATION_ID,
    name: SITE_NAME,
    alternateName: CAMPUS_ALTERNATE_NAMES,
    url: SITE_URL,
    logo: absoluteUrl('/brand/inminer-campus-logo.png'),
    image: absoluteUrl('/brand/inminer-campus-logo.png'),
    description:
      'Plataforma de formación técnica y preventiva de INMINER INGENIERÍA, S.L. (España), especializada en seguridad minera y en la formación preventiva regulada por el Reglamento General de Normas Básicas de Seguridad Minera.',
    email: ORGANIZATION.email,
    telephone: ORGANIZATION.telephone,
    address: POSTAL_ADDRESS,
    // Ámbito de actuación: señal explícita de que la oferta se dirige a España.
    areaServed: { '@type': 'Country', name: 'España' },
    knowsLanguage: 'es-ES',
    knowsAbout: [
      'ITC 02.1.02 Formación preventiva para el desempeño del puesto de trabajo',
      'ITC 02.0.02 Protección de los trabajadores contra el polvo y la sílice cristalina respirable',
      'Formación preventiva en minería',
      'Maquinaria minera',
    ],
    // La relación de marca InmínerCampus -> INMINER INGENIERÍA, S.L. queda
    // explícita, y la web corporativa se declara como perfil de la misma
    // organización matriz.
    parentOrganization: {
      '@type': 'Organization',
      '@id': INMINER_ID,
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

/** Referencia breve a la plataforma, válida aunque el nodo completo no esté en la página. */
export function campusReference(): JsonLd {
  return {
    '@type': 'EducationalOrganization',
    '@id': ORGANIZATION_ID,
    name: SITE_NAME,
    url: SITE_URL,
  }
}

export function webSiteSchema(): JsonLd {
  return {
    '@type': 'WebSite',
    '@id': WEBSITE_ID,
    // `name` + `alternateName` son lo que Google usa para el nombre del sitio
    // en los resultados.
    name: SITE_NAME,
    alternateName: CAMPUS_ALTERNATE_NAMES,
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
  /** Ruta de la imagen del curso. */
  image?: string
  /** Objetivos visibles en la ficha. */
  teaches?: Array<string>
  /** Destinatarios visibles en la ficha. */
  audience?: Array<string>
  /** Requisitos visibles en la ficha. */
  prerequisites?: Array<string>
  /** Referencia normativa visible en la ficha (p. ej. «ITC 02.1.02 · ET 2001-1-08»). */
  normativeReference?: string | null
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
          // Vocabulario que exige Google para `Course`: Free, Partially Free,
          // Subscription o Paid.
          category: 'Paid',
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
    // Nodo breve y no sólo `@id`: la ficha no repite la organización completa
    // y el validador de Google necesita el nombre del proveedor.
    provider: campusReference(),
    // Google exige uno de estos dos campos en `Course` desde 2024.
    hasCourseInstance: instances,
    // Es el documento que genera la plataforma al completar el itinerario
    // (`src/lib/certificate-pdf.ts`).
    educationalCredentialAwarded: {
      '@type': 'EducationalOccupationalCredential',
      name: 'Certificado de formación',
      credentialCategory: 'certificate',
    },
  }
  if (input.image) schema.image = absoluteUrl(input.image)
  if (input.teaches?.length) schema.teaches = input.teaches
  if (input.prerequisites?.length) schema.coursePrerequisites = input.prerequisites
  if (input.audience?.length) {
    schema.audience = {
      '@type': 'Audience',
      audienceType: input.audience.join('; '),
      geographicArea: { '@type': 'Country', name: 'España' },
    }
  }
  if (input.normativeReference) {
    // La norma es el «tema» de la formación: se declara como `about`, sin
    // afirmar ninguna acreditación ni homologación.
    schema.about = { '@type': 'Thing', name: input.normativeReference }
  }
  if (offers.length) schema.offers = offers
  return schema
}

/**
 * Persona visible en «Sobre nosotros». Sólo datos que la propia página muestra.
 */
export function personSchema(input: {
  name: string
  jobTitle: string
  description: string
  image: string
  path: string
  /** Centro de estudios que la propia página menciona. */
  alumniOf?: string
}): JsonLd {
  return {
    ...(input.alumniOf
      ? { alumniOf: { '@type': 'CollegeOrUniversity', name: input.alumniOf } }
      : {}),
    '@type': 'Person',
    '@id': `${absoluteUrl(input.path)}#${input.name
      .toLocaleLowerCase('es')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]+/g, '-')}`,
    name: input.name,
    jobTitle: input.jobTitle,
    description: input.description,
    image: absoluteUrl(input.image),
    worksFor: { '@id': INMINER_ID },
  }
}

export type ArticleSchemaInput = {
  path: string
  headline: string
  description: string
  /** Fecha ISO (AAAA-MM-DD) de la última revisión del contenido, visible en la página. */
  dateModified: string
  image?: string
}

/**
 * Página informativa (guía normativa). El autor y editor es la empresa: no se
 * atribuye la autoría ni la revisión a una persona que no la haya asumido.
 */
export function articleSchema(input: ArticleSchemaInput): JsonLd {
  const url = absoluteUrl(input.path)
  return {
    '@type': 'Article',
    '@id': `${url}#article`,
    headline: input.headline,
    description: input.description,
    url,
    mainEntityOfPage: url,
    inLanguage: 'es-ES',
    dateModified: input.dateModified,
    image: absoluteUrl(input.image ?? '/brand/inminer-campus-logo.png'),
    author: {
      '@type': 'Organization',
      '@id': INMINER_ID,
      name: ORGANIZATION.legalName,
      url: ORGANIZATION.corporateSite,
    },
    publisher: campusReference(),
    isPartOf: { '@id': WEBSITE_ID },
  }
}

export type ItemListEntry = { name: string; path: string }

/** Lista ordenada de URLs (catálogo, cursos relacionados con una norma). */
export function itemListSchema(name: string, items: Array<ItemListEntry>): JsonLd {
  return {
    '@type': 'ItemList',
    name,
    itemListElement: items.map((item, index) => ({
      '@type': 'ListItem',
      position: index + 1,
      name: item.name,
      url: absoluteUrl(item.path),
    })),
  }
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
