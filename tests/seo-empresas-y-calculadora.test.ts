import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

import { getCompanyVolumeDiscountBasisPoints } from '../src/lib/billing.ts'
import {
  REFRESHER_RULES,
  SILICA_REFRESHER_YEARS,
  refresherDueDate,
  refresherOptions,
  refresherRuleFor,
} from '../src/lib/mining-regulation.ts'
import {
  GUIDE_PATHS,
  INDEXABLE_STATIC_ROUTES,
  isNoindexPath,
} from '../src/lib/public-routes.ts'

const read = (path: string) => readFile(new URL(`../${path}`, import.meta.url), 'utf8')

test('el plazo de reciclaje sale de la norma de cada puesto', () => {
  assert.deepEqual(refresherRuleFor('ITC 02.1.02 · ET 2001-1-08'), {
    years: 2,
    basis: 'specification',
    source: 'ET 2001-1-08',
  })
  assert.equal(refresherRuleFor('ITC 02.1.02 · ET 2000-1-08')?.years, 2)
  assert.deepEqual(refresherRuleFor('ITC 02.1.02 · ET 2002-1-08'), {
    years: 2,
    basis: 'specification',
    source: 'ET 2002-1-08',
  })
  // Sin plazo propio de la ET se aplica el máximo general, y se dice así.
  assert.deepEqual(refresherRuleFor('ITC 02.1.02 · ET 2003-1-10'), {
    years: REFRESHER_RULES.generalMaxYears,
    basis: 'general',
    source: 'ITC 02.1.02',
  })
  assert.equal(refresherRuleFor('ITC 02.0.02 · Orden TED/723/2021')?.years, SILICA_REFRESHER_YEARS)
  assert.equal(refresherRuleFor('Formación STVH'), null)
  assert.equal(refresherRuleFor(null), null)
})

test('la calculadora ofrece cada itinerario y no la ET de la cartilla', () => {
  const ids = refresherOptions().map((option) => option.id)
  assert.ok(ids.includes('ET 2001-1-08'))
  assert.ok(ids.includes('ITC 02.0.02'))
  assert.equal(ids.includes('ET 2005-1-11'), false)
  for (const option of refresherOptions()) {
    assert.match(option.url, /^https:\/\/www\.boe\.es\//, option.id)
    assert.ok(option.rule.years >= 1 && option.rule.years <= 4, option.id)
  }
})

test('la fecha límite suma años sin depender de la zona horaria', () => {
  assert.equal(refresherDueDate('2024-10-23', 2), '2026-10-23')
  assert.equal(refresherDueDate('2025-01-31', 1), '2026-01-31')
  // 29 de febrero en un año no bisiesto pasa al 28.
  assert.equal(refresherDueDate('2024-02-29', 1), '2025-02-28')
  assert.equal(refresherDueDate('2024-02-29', 4), '2028-02-29')
  assert.equal(refresherDueDate('2025-04-31', 1), null)
  assert.equal(refresherDueDate('no-es-fecha', 1), null)
})

test('la calculadora y empresas son indexables y están en el sitemap', () => {
  const sitemap = INDEXABLE_STATIC_ROUTES.map((route) => route.path)
  for (const path of [GUIDE_PATHS.refresherCalculator, '/empresas']) {
    assert.equal(isNoindexPath(path), false, path)
    assert.ok(sitemap.includes(path), `${path} falta en el sitemap`)
  }
})

test('la calculadora no guarda nada y calcula «hoy» en el navegador', async () => {
  const source = await read('src/routes/calculadora-reciclaje-formacion-minera.tsx')
  assert.doesNotMatch(source, /localStorage|sessionStorage|fetch\(|\.rpc\(|\.insert\(/)
  assert.match(source, /useEffect\(/)
  assert.match(source, /faqSchema\(faqs\)/)
  assert.match(source, /faqs\.map\(/)
  assert.match(source, /seoHead\(/)
})

test('empresas coordina el acceso sin publicar descuentos ni compra', async () => {
  assert.equal(getCompanyVolumeDiscountBasisPoints(6), 500)
  assert.equal(getCompanyVolumeDiscountBasisPoints(8), 1_000)
  const source = await read('src/routes/empresas.tsx')
  assert.doesNotMatch(source, /getCompanyVolumeDiscountBasisPoints|checkout|precio|pago/i)
  assert.match(source, /Acceso validado/)
  assert.match(source, /CourseInquiryButton/)
  assert.match(source, /breadcrumbSchema\(/)
})

test('la ficha de curso explica el marco normativo de su puesto', async () => {
  const source = await read('src/routes/cursos.$courseSlug.tsx')
  assert.match(source, /<CourseRegulationSection/)
  assert.match(source, /refresherRuleFor\(reference\)/)
  assert.match(source, /GUIDE_PATHS\.refresherCalculator/)
  assert.match(source, /CourseInquiryButton/)
  assert.doesNotMatch(source, /getCompanyVolumeDiscountBasisPoints|Comprar ahora|price-display/)
})

test('el menú principal no enlaza a una categoría vacía y sí a empresas y normativa', async () => {
  const header = await read('src/components/PublicHeader.tsx')
  assert.doesNotMatch(header, /label: 'Otros'/)
  assert.match(header, /to: '\/empresas'/)
  assert.match(header, /to: '\/formacion-minera'/)
})
