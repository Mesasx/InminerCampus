import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import { matchesQuery, normalizeForSearch, searchableText } from '../src/lib/course-search.ts'

const cssPath = new URL('../src/styles/app.css', import.meta.url)
const catalogPath = new URL('../src/routes/catalogo.tsx', import.meta.url)

const css = await readFile(cssPath, 'utf8')
const catalog = await readFile(catalogPath, 'utf8')

const perforadora = {
  title: 'Operador de perforadora / perforista',
  short_description: 'Formación Preventiva Oficial para perforación en exterior.',
  specialty: 'ITC 02.1.02 · ET 2003-1-10',
  accreditation_reference: 'ET 2003-1-10',
}
const administracion = {
  title: 'Administración y personal de servicios distintos a los de mantenimiento',
  short_description: 'Formación Preventiva Oficial para el personal de administración.',
  specialty: 'ITC 02.1.02 · ET 2004-1-10',
  accreditation_reference: 'ET 2004-1-10',
}

test('la búsqueda ignora acentos y mayúsculas', () => {
  assert.equal(normalizeForSearch('  PERFORACIÓN  '), 'perforacion')
  assert.ok(matchesQuery(perforadora, 'perforacion'))
  assert.ok(matchesQuery(perforadora, 'PERFORADORA'))
  assert.ok(matchesQuery(perforadora, 'perforación'))
})

test('se busca también por especialidad y por referencia normativa', () => {
  // Lo que el alumno ve escrito en la ficha, debajo de la descripción.
  assert.ok(matchesQuery(administracion, 'ET 2004'))
  assert.ok(matchesQuery(perforadora, 'ITC 02.1.02'))
  assert.ok(searchableText(perforadora).includes('2003-1-10'))
})

test('varias palabras se buscan en cualquier orden y en campos distintos', () => {
  assert.ok(matchesQuery(administracion, 'administracion 2004'))
  assert.ok(matchesQuery(administracion, '2004 administracion'))
  // Una palabra que no está en ningún campo descarta el curso.
  assert.equal(matchesQuery(administracion, 'administracion perforadora'), false)
})

test('una búsqueda vacía no descarta ningún curso', () => {
  for (const query of ['', '   ']) {
    assert.ok(matchesQuery(perforadora, query))
    assert.ok(matchesQuery(administracion, query))
  }
})

test('los campos ausentes no rompen la búsqueda', () => {
  const minimo = {
    title: 'Formación STVH',
    short_description: null,
    specialty: null,
    accreditation_reference: null,
  }
  assert.ok(matchesQuery(minimo, 'stvh'))
  assert.equal(matchesQuery(minimo, 'perforadora'), false)
})

test('el buscador está sobre la rejilla, con recuento y con forma de limpiar', () => {
  assert.match(catalog, /className="catalog-search"/)
  assert.match(catalog, /aria-label="Buscar curso por nombre, especialidad o normativa"/)
  assert.match(catalog, /aria-label="Borrar la búsqueda"/)
  assert.match(catalog, /className="catalog-search__count" role="status"/)
  // El buscador va antes de la rejilla de tarjetas, no debajo.
  assert.ok(catalog.indexOf('catalog-search') < catalog.indexOf('course-grid'))
  // Y ya no se maqueta con estilos en línea.
  assert.doesNotMatch(catalog, /gridTemplateColumns: '1fr minmax\(180px, 240px\)'/)
})

test('la portada de la tarjeta se encuadra en 16:9, que es su proporción real', () => {
  // Las portadas del catálogo son 1672x941. Con un hueco 4/3 se perdía la
  // cuarta parte del ancho y se cortaba el título compuesto en la imagen.
  const visual = css.slice(
    css.indexOf('.course-card__visual {'),
    css.indexOf('.course-card__visual-shade'),
  )
  assert.match(visual, /aspect-ratio: 16 \/ 9;/)
  assert.doesNotMatch(visual, /aspect-ratio: 4 \/ 3;/)
  // Las que no son 16:9 se encuadran por arriba, donde está el título.
  assert.match(visual, /object-position: 50% 22%;/)
})

test('la sombra superior no apaga el título de la portada', () => {
  const shade = css.slice(
    css.indexOf('.course-card__visual-shade {'),
    css.indexOf('.course-card .category-badge'),
  )
  // Cubre sólo la franja de las píldoras, no media imagen.
  const height = shade.match(/height: (\d+)%;/)
  assert.ok(height, 'la sombra declara una altura')
  assert.ok(Number(height![1]) <= 40, `la sombra cubre ${height![1]} %`)
})
