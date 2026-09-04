import assert from 'node:assert/strict'
import { readFile, readdir } from 'node:fs/promises'
import test from 'node:test'

import {
  SITE_URL,
  absoluteUrl,
  buildTitle,
  canonicalPath,
  clampDescription,
  seoHead,
} from '../src/lib/seo.ts'
import {
  breadcrumbSchema,
  courseSchema,
  faqSchema,
  jsonLdGraph,
  organizationSchema,
  webSiteSchema,
} from '../src/lib/schema.ts'
import {
  INDEXABLE_STATIC_ROUTES,
  isNoindexPath,
} from '../src/lib/public-routes.ts'
import {
  courseFaqs,
  courseMetaDescription,
  courseMetaTitle,
  isItc020102,
} from '../src/lib/course-seo.ts'
import type { PublicCourseDetail } from '../src/lib/public-courses.ts'

const routesDir = new URL('../src/routes/', import.meta.url)

function courseFixture(
  overrides: Partial<PublicCourseDetail> = {},
): PublicCourseDetail {
  return {
    id: 'course-1',
    slug: 'operador-maquinaria-arranque-carga-viales',
    title: 'Operador de maquinaria de arranque, carga y viales',
    short_description:
      'Formación preventiva para operadores en actividades extractivas de exterior.',
    description: 'Itinerario preventivo adaptado al puesto.',
    specialty: 'ITC 02.1.02 · ET 2001-1-08',
    access_mode: 'purchase',
    listed: true,
    updated_at: '2026-01-15T10:00:00Z',
    versions: [
      {
        id: 'v20',
        version_number: 2,
        duration_hours: 20,
        modality: 'hybrid',
        objectives: ['Objetivo'],
        target_audience: ['Personal de nueva incorporación'],
        requirements: ['Completar las 20 horas mínimas'],
        syllabus_summary: 'Bloque 1',
        practice_required: true,
        accreditation_reference: 'ITC 02.1.02 · ET 2001-1-08',
        renewal_interval_months: null,
        price_net: 349,
        tax_rate: 21,
        currency: 'EUR',
      },
      {
        id: 'v5',
        version_number: 1,
        duration_hours: 5,
        modality: 'hybrid',
        objectives: [],
        target_audience: [],
        requirements: [],
        syllabus_summary: '',
        practice_required: true,
        accreditation_reference: 'ITC 02.1.02 · ET 2001-1-08',
        renewal_interval_months: 24,
        price_net: 149,
        tax_rate: 21,
        currency: 'EUR',
      },
    ],
    ...overrides,
  }
}

test('la canónica de una ficha de curso ignora el parámetro ?version', () => {
  // Cada versión publicada genera un enlace `?version=<uuid>` en el catálogo.
  // Si esas URLs se canonicalizaran a sí mismas, Google indexaría el mismo
  // curso tantas veces como duraciones tenga.
  const { links } = seoHead({
    title: 'Curso',
    description: 'Descripción',
    path: '/cursos/mi-curso',
  })
  const canonical = links.find((link) => link.rel === 'canonical')
  assert.equal(canonical?.href, `${SITE_URL}/cursos/mi-curso`)
  assert.doesNotMatch(canonical?.href ?? '', /version=/)
})

test('canonicalPath normaliza la barra final y el fragmento', () => {
  assert.equal(canonicalPath('/catalogo/'), '/catalogo')
  assert.equal(canonicalPath('/catalogo#filtros'), '/catalogo')
  assert.equal(canonicalPath('/'), '/')
  // El filtro de categoría sí es una URL propia y debe conservarse.
  assert.equal(
    canonicalPath('/catalogo?categoria=mineria'),
    '/catalogo?categoria=mineria',
  )
})

test('una página noindex no declara canonical', () => {
  // `noindex` + `canonical` son señales contradictorias: Google puede acabar
  // ignorando el `noindex` y dejar la URL indexada.
  const { meta, links } = seoHead({
    title: 'Acceso',
    description: 'Acceso al campus',
    path: '/acceso',
    noindex: true,
  })
  assert.equal(links.length, 0)
  const robots = meta.find((tag) => tag.name === 'robots')
  assert.match(robots?.content ?? '', /noindex/)
})

test('seoHead emite el bloque social y de indexación completo', () => {
  const { meta } = seoHead({
    title: 'Curso de prueba',
    description: 'Una descripción',
    path: '/cursos/prueba',
  })
  const names = new Set(
    meta.map((tag) => tag.name ?? tag.property ?? (tag.title ? 'title' : '')),
  )
  for (const required of [
    'title',
    'description',
    'robots',
    'og:title',
    'og:description',
    'og:url',
    'og:image',
    'og:locale',
    'twitter:card',
  ]) {
    assert.ok(names.has(required), `falta la etiqueta ${required}`)
  }
  assert.equal(
    meta.find((tag) => tag.property === 'og:locale')?.content,
    'es_ES',
  )
})

test('buildTitle no duplica la marca ni recorta un título propio', () => {
  assert.equal(buildTitle('Contacto'), 'Contacto | InmínerCampus')
  assert.equal(
    buildTitle('InmínerCampus | Formación preventiva'),
    'InmínerCampus | Formación preventiva',
  )
})

test('clampDescription corta por palabra completa', () => {
  const long = `${'palabra '.repeat(40)}final`
  const clamped = clampDescription(long)
  assert.ok(clamped.length <= 159, `demasiado larga: ${clamped.length}`)
  assert.doesNotMatch(clamped, /palabr…$/)
})

test('las descripciones de curso caben en la SERP sin truncarse a media palabra', () => {
  const description = courseMetaDescription(courseFixture())
  assert.ok(description.length <= 158)
  assert.doesNotMatch(description, /Inmíner…$/)
})

test('el título de la ficha es único y contiene el nombre del puesto', () => {
  const title = courseMetaTitle(courseFixture())
  assert.match(title, /^Curso Operador de maquinaria de arranque/)
  assert.notEqual(
    buildTitle(title),
    'InmínerCampus | Formación preventiva para minería',
  )
})

test('todo el JSON-LD generado es JSON válido', () => {
  const course = courseFixture()
  const graph = jsonLdGraph([
    organizationSchema(),
    webSiteSchema(),
    courseSchema({
      slug: course.slug,
      title: course.title,
      description: course.short_description,
      purchasable: true,
      versions: course.versions.map((version) => ({
        durationHours: version.duration_hours,
        modality: version.modality,
        priceNet: version.price_net,
        currency: version.currency,
      })),
    }),
    breadcrumbSchema([
      { name: 'Inicio', path: '/' },
      { name: 'Catálogo', path: '/catalogo' },
    ]),
    faqSchema(courseFaqs(course)),
  ])

  const parsed = JSON.parse(graph)
  assert.equal(parsed['@context'], 'https://schema.org')
  assert.deepEqual(
    parsed['@graph'].map((node: { '@type': string }) => node['@type']),
    [
      'EducationalOrganization',
      'WebSite',
      'Course',
      'BreadcrumbList',
      'FAQPage',
    ],
  )
})

test('Course declara instancias y ofertas coherentes con las versiones', () => {
  const course = courseFixture()
  const schema = courseSchema({
    slug: course.slug,
    title: course.title,
    description: course.short_description,
    purchasable: true,
    versions: course.versions.map((version) => ({
      durationHours: version.duration_hours,
      modality: version.modality,
      priceNet: version.price_net,
      currency: version.currency,
    })),
  }) as Record<string, Array<Record<string, unknown>>>

  assert.equal(schema.hasCourseInstance.length, 2)
  assert.deepEqual(
    schema.hasCourseInstance.map((instance) => instance.courseWorkload),
    ['PT20H', 'PT5H'],
  )
  // Modalidad híbrida: nunca debe declararse como formación en línea.
  for (const instance of schema.hasCourseInstance) {
    assert.equal(instance.courseMode, 'blended')
  }
  assert.deepEqual(
    schema.offers.map((offer) => offer.price),
    ['349', '149'],
  )
  for (const offer of schema.offers) {
    assert.equal(offer.priceCurrency, 'EUR')
    assert.equal(offer.valueAddedTaxIncluded, false)
  }
})

test('un curso de acceso por invitación no publica oferta', () => {
  const schema = courseSchema({
    slug: 'formacion-stvh',
    title: 'Formación STVH',
    description: 'Formación interna.',
    purchasable: false,
    versions: [
      { durationHours: 3, modality: 'online', priceNet: null, currency: 'EUR' },
    ],
  })
  assert.equal('offers' in schema, false)
})

test('la organización declara el NAP verificable y la relación con INMÍNER', () => {
  const organization = organizationSchema() as Record<string, never>
  const address = organization.address as unknown as Record<string, string>
  assert.equal(address.addressCountry, 'ES')
  assert.equal(address.addressLocality, 'Ciudad Real')
  assert.equal(address.postalCode, '13005')
  assert.equal(
    (organization.parentOrganization as unknown as Record<string, string>).name,
    'INMINER INGENIERÍA, S.L.',
  )
  assert.equal(organization.vatID as unknown as string, 'ESB13476148')
})

test('la ficha de ITC 02.1.02 explica que la formación es presencial', () => {
  const course = courseFixture()
  assert.equal(isItc020102(course), true)

  const faqs = courseFaqs(course)
  const modality = faqs.find((faq) => /íntegramente online/.test(faq.question))
  assert.ok(modality, 'falta la pregunta sobre modalidad online')
  // Precisión legal: la respuesta debe negar el curso 100 % online y citar la
  // orden del BOE que lo establece.
  assert.match(modality.answer, /^No\./)
  assert.match(modality.answer, /únicamente carácter presencial/)
  assert.match(modality.answer, /ITC\/2699\/2011/)
})

test('ninguna FAQ generada afirma que el curso sea homologado u oficial', () => {
  for (const course of [
    courseFixture(),
    courseFixture({
      specialty: 'ITC 02.0.02',
      versions: [
        {
          ...courseFixture().versions[0],
          modality: 'online',
          practice_required: false,
          accreditation_reference: 'ITC 02.0.02 · Orden TED/723/2021',
        },
      ],
    }),
  ]) {
    for (const faq of courseFaqs(course)) {
      assert.doesNotMatch(faq.answer, /homologad/i)
      assert.doesNotMatch(faq.answer, /\bhabilitante\b/i)
    }
  }
})

test('un curso sin ITC 02.1.02 no hereda el aviso de presencialidad', () => {
  const online = courseFixture({
    versions: [
      {
        ...courseFixture().versions[0],
        modality: 'online',
        practice_required: false,
        accreditation_reference: 'ITC 02.0.02 · Orden TED/723/2021',
      },
    ],
  })
  assert.equal(isItc020102(online), false)
  const faqs = courseFaqs(online)
  assert.equal(
    faqs.some((faq) => /íntegramente online/.test(faq.question)),
    false,
  )
})

test('las rutas privadas se reconocen como noindex y las públicas no', () => {
  for (const path of [
    '/acceso',
    '/mis-cursos',
    '/campus/abc',
    '/admin/usuarios',
    '/comprar/mi-curso',
    '/empresa/codigos',
  ]) {
    assert.equal(isNoindexPath(path), true, `${path} debería ser noindex`)
  }
  for (const path of [
    '/',
    '/catalogo',
    '/cursos/mi-curso',
    '/sobre-nosotros',
    // `/empresas` es la landing pública y no debe confundirse con `/empresa`.
    '/empresas',
    '/formacion-preventiva-oficial',
  ]) {
    assert.equal(isNoindexPath(path), false, `${path} debería indexarse`)
  }
})

test('el sitemap estático no contiene ninguna ruta privada', () => {
  for (const route of INDEXABLE_STATIC_ROUTES) {
    assert.equal(
      isNoindexPath(route.path),
      false,
      `${route.path} no puede estar en el sitemap`,
    )
    assert.ok(route.path.startsWith('/'), `${route.path} debe ser relativa`)
    assert.doesNotMatch(route.path, /localhost|https?:/)
  }
})

test('absoluteUrl usa siempre el dominio de producción', () => {
  assert.equal(absoluteUrl('/catalogo'), 'https://inminercampus.com/catalogo')
  assert.doesNotMatch(SITE_URL, /localhost|vercel\.app/)
})

test('robots.txt referencia el sitemap y no bloquea las páginas con noindex', async () => {
  const source = await readFile(
    new URL('robots[.]txt.ts', routesDir),
    'utf8',
  )
  assert.match(source, /Sitemap: \$\{SITE_URL\}\/sitemap\.xml/)
  // Bloquear en robots una URL que lleva `noindex` impide que Google lea la
  // directiva, así que sólo debe bloquearse `/api/`, que no devuelve HTML.
  const disallow = [...source.matchAll(/'Disallow: ([^']+)'/g)].map(
    (match) => match[1],
  )
  assert.deepEqual(disallow, ['/api/'])
})

test('todas las rutas públicas declaran metadatos propios', async () => {
  const files = await readdir(routesDir)
  // Rutas de datos (`api.*`), archivos servidos como texto y el documento raíz
  // no renderizan una página indexable con `<head>` propio.
  const excluded = /^(api\.|__root|routeTree|sitemap\[|robots\[)/
  const pages = files.filter(
    (file) => file.endsWith('.tsx') && !excluded.test(file),
  )

  // Las rutas hijas heredan el `head` de su layout: `campus.$enrollmentId.
  // leccion.$lessonId.tsx` lo recibe de `campus.$enrollmentId.tsx`.
  const hasLayoutAncestor = (file: string) => {
    const segments = file.replace(/\.tsx$/, '').split('.')
    for (let end = segments.length - 1; end > 0; end -= 1) {
      if (pages.includes(`${segments.slice(0, end).join('.')}.tsx`)) return true
    }
    return false
  }

  const missing: Array<string> = []
  for (const file of pages) {
    const source = await readFile(new URL(file, routesDir), 'utf8')
    if (!source.includes('seoHead') && !hasLayoutAncestor(file)) {
      missing.push(file)
    }
  }

  assert.deepEqual(missing, [], `rutas sin metadatos: ${missing.join(', ')}`)
})

test('un despliegue sin Supabase falla en vez de devolver 404 en las fichas', async () => {
  // Si `fetchPublicCourse` devolviera `null` al faltar la configuración, el
  // loader lanzaría `notFound()` y Google recibiría un 404 por cada curso, que
  // es la orden explícita de desindexarlos. Debe fallar con 5xx.
  const source = await readFile(
    new URL('../src/lib/public-courses.ts', import.meta.url),
    'utf8',
  )
  for (const fn of ['fetchPublicCourses', 'fetchPublicCourse']) {
    const body = source.slice(source.indexOf(`export async function ${fn}`))
    assert.match(
      body.slice(0, 400),
      /requireSupabasePublicClient\(\)/,
      `${fn} debe exigir la configuración de Supabase`,
    )
  }
})

test('no se filtran URLs de desarrollo ni claves en el código de SEO', async () => {
  for (const file of [
    '../src/lib/seo.ts',
    '../src/lib/schema.ts',
    '../src/lib/course-seo.ts',
    '../src/lib/public-courses.ts',
  ]) {
    const source = await readFile(new URL(file, import.meta.url), 'utf8')
    assert.doesNotMatch(source, /localhost/, `${file} referencia localhost`)
    // El SEO debe leer siempre con la clave anónima y respetar RLS: ninguna
    // de estas rutas puede acabar usando el cliente con `service_role`.
    assert.doesNotMatch(
      source,
      /SUPABASE_SERVICE_ROLE_KEY|supabase-admin|getSupabaseAdmin/,
      `${file} usa la clave de servicio`,
    )
    assert.doesNotMatch(source, /eyJhbGciOi/, `${file} incrusta un JWT`)
  }
})
