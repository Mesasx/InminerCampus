import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

import {
  coursesForSpecification,
  guideCatalog,
  itc020002Courses,
  itc020102Courses,
} from '../src/lib/guide-courses.ts'
import {
  ITC_02_0_02,
  ITC_02_1_02,
  ITC_02_1_02_AMENDMENT,
  REFRESHER_RULES,
  REGULATION_REVIEWED_AT,
  TECHNICAL_SPECIFICATIONS,
} from '../src/lib/mining-regulation.ts'
import type { PublicCourseDetail } from '../src/lib/public-courses.ts'
import {
  GUIDE_PATHS,
  INDEXABLE_STATIC_ROUTES,
  REDIRECTED_PATHS,
  isNoindexPath,
} from '../src/lib/public-routes.ts'
import { articleSchema, jsonLdGraph } from '../src/lib/schema.ts'

const routesDir = new URL('../src/routes/', import.meta.url)

const guideFiles = [
  'formacion-minera.tsx',
  'itc-02-1-02.index.tsx',
  'itc-02-1-02.formacion-inicial-y-reciclaje.tsx',
  'itc-02-0-02.tsx',
]

function course(
  slug: string,
  reference: string,
  durations: Array<number>,
  overrides: Partial<PublicCourseDetail> = {},
): PublicCourseDetail {
  return {
    id: slug,
    slug,
    title: slug,
    short_description: '',
    description: '',
    specialty: reference,
    access_mode: 'purchase',
    listed: true,
    updated_at: null,
    versions: durations.map((hours, index) => ({
      id: `${slug}-${hours}`,
      version_number: durations.length - index,
      duration_hours: hours,
      modality: 'hybrid',
      objectives: [],
      target_audience: [],
      requirements: [],
      syllabus_summary: '',
      practice_required: true,
      accreditation_reference: reference,
      renewal_interval_months: null,
      price_net: 100,
      tax_rate: 21,
      currency: 'EUR',
    })),
    ...overrides,
  }
}

test('los datos normativos citan siempre una fuente oficial', () => {
  for (const norm of [ITC_02_1_02, ITC_02_1_02_AMENDMENT, ITC_02_0_02, ...TECHNICAL_SPECIFICATIONS]) {
    assert.match(norm.url, /^https:\/\/www\.boe\.es\//, `${norm.code} sin enlace al BOE`)
    assert.match(norm.boeId ?? '', /^BOE-A-\d{4}-\d+$/, `${norm.code} sin identificador BOE`)
  }
  // Las dos citas literales de la modificación de 2011.
  assert.match(ITC_02_1_02_AMENDMENT.presencialQuote, /únicamente carácter presencial/)
  assert.match(ITC_02_1_02_AMENDMENT.refresherQuote, /mínimo de cinco horas lectivas/)
  assert.equal(REFRESHER_RULES.minimumHours, 5)
  assert.equal(REFRESHER_RULES.generalMaxYears, 4)
  assert.match(REGULATION_REVIEWED_AT, /^\d{4}-\d{2}-\d{2}$/)
})

test('las guías emparejan cada curso con su especificación sin slugs fijos', () => {
  const catalog = guideCatalog([
    course('arranque', 'ITC 02.1.02 · ET 2001-1-08', [20, 5]),
    course('transporte', 'ITC 02.1.02 · ET 2000-1-08', [20, 5]),
    course('silice', 'ITC 02.0.02 · Orden TED/723/2021', [3], {
      versions: course('x', 'ITC 02.0.02 · Orden TED/723/2021', [3]).versions.map((v) => ({
        ...v,
        modality: 'online',
        practice_required: false,
      })),
    }),
    course('interno', '', [3], { access_mode: 'access_code' }),
  ])

  // Los cursos por invitación no se enlazan desde contenido indexable.
  assert.equal(catalog.some((item) => item.slug === 'interno'), false)
  assert.deepEqual(coursesForSpecification(catalog, 'ET 2001-1-08').map((c) => c.slug), ['arranque'])
  assert.deepEqual(itc020102Courses(catalog).map((c) => c.slug), ['arranque', 'transporte'])
  assert.deepEqual(itc020002Courses(catalog).map((c) => c.slug), ['silice'])
  const arranque = catalog.find((item) => item.slug === 'arranque')
  assert.equal(arranque?.hasInitial, true)
  assert.equal(arranque?.hasRefresher, true)
})

test('las guías son indexables, están en el sitemap y tienen metadatos y JSON-LD', async () => {
  const sitemapPaths = INDEXABLE_STATIC_ROUTES.map((route) => route.path)
  for (const path of Object.values(GUIDE_PATHS)) {
    assert.equal(isNoindexPath(path), false, path)
    assert.ok(sitemapPaths.includes(path), `${path} falta en el sitemap`)
  }

  for (const file of guideFiles) {
    const source = await readFile(new URL(file, routesDir), 'utf8')
    assert.match(source, /seoHead\(/, `${file}: sin seoHead`)
    assert.match(source, /articleSchema\(/, `${file}: sin Article`)
    assert.match(source, /breadcrumbSchema\(/, `${file}: sin BreadcrumbList`)
    assert.match(source, /<OfficialSources/, `${file}: sin fuentes oficiales`)
    assert.match(source, /<GuideReviewNote/, `${file}: sin fecha de revisión visible`)
    // Las FAQ marcadas son las mismas que se pintan.
    assert.match(source, /faqSchema\(faqs\)/)
    assert.match(source, /faqs\.map\(/)
    // Precisión legal: ninguna guía promete formación ITC 02.1.02 en línea ni
    // atribuye a un curso carácter «habilitante» u «homologado».
    assert.doesNotMatch(source, /habilitante/i, file)
    assert.doesNotMatch(source, /curso (homologado|oficial)/i, file)
    if (file !== 'itc-02-0-02.tsx') {
      // Toda guía que trata la ITC 02.1.02 cita literalmente su presencialidad.
      assert.match(source, /presencialQuote/, `${file}: falta la cita de presencialidad`)
    }
  }
})

test('la antigua página «oficial» redirige con 301 y no está en el sitemap', async () => {
  assert.equal(REDIRECTED_PATHS['/formacion-preventiva-oficial'], GUIDE_PATHS.hub)
  const source = await readFile(new URL('formacion-preventiva-oficial.ts', routesDir), 'utf8')
  assert.match(source, /status: 301/)
  assert.match(source, /Location: target/)
  const sitemapPaths = INDEXABLE_STATIC_ROUTES.map((route) => route.path)
  for (const path of Object.keys(REDIRECTED_PATHS)) {
    assert.equal(sitemapPaths.includes(path), false, `${path} redirige y no debe estar en el sitemap`)
  }
})

test('ningún enlace interno apunta a la URL retirada', async () => {
  for (const file of ['../src/components/Footer.tsx', '../src/routes/index.tsx', '../src/routes/sobre-nosotros.tsx']) {
    const source = await readFile(new URL(file, import.meta.url), 'utf8')
    assert.doesNotMatch(source, /formacion-preventiva-oficial/, file)
  }
})

test('Article atribuye la autoría a la empresa y declara la fecha de revisión', () => {
  const node = articleSchema({
    path: '/itc-02-1-02',
    headline: 'ITC 02.1.02',
    description: 'Guía',
    dateModified: REGULATION_REVIEWED_AT,
  }) as Record<string, any>
  assert.equal(node.author.name, 'INMINER INGENIERÍA, S.L.')
  assert.equal(node.author.url, 'https://inminer.es')
  assert.equal(node.dateModified, REGULATION_REVIEWED_AT)
  assert.equal(node.publisher.name, 'InmínerCampus')
  JSON.parse(jsonLdGraph([node]))
})

test('las tarjetas enlazan la versión por defecto con la URL limpia', async () => {
  const { courseLinkSearch } = await import('../src/lib/course-url.ts')
  assert.deepEqual(courseLinkSearch({ versionId: 'v20', isDefaultVersion: true }), {})
  assert.deepEqual(courseLinkSearch({ versionId: 'v5', isDefaultVersion: false }), { version: 'v5' })

  // `public-courses.ts` lee la configuración de Vite y no se puede importar
  // aquí: se comprueba que marca como defecto la versión que abre la ficha.
  const publicCourses = await readFile(
    new URL('../src/lib/public-courses.ts', import.meta.url),
    'utf8',
  )
  assert.match(publicCourses, /isDefaultVersion: index === 0/)

  for (const file of ['../src/components/CourseCard.tsx', '../src/components/CourseSlider.tsx']) {
    const source = await readFile(new URL(file, import.meta.url), 'utf8')
    assert.match(source, /search=\{courseLinkSearch\(course\)\}/, file)
  }
})
