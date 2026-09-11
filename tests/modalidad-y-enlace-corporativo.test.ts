import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import { modalityLabel } from '../src/lib/format.ts'
import { ORGANIZATION } from '../src/lib/seo.ts'

const migration = await readFile(
  new URL(
    '../supabase/migrations/20260911170000_modalidad_hibrida_salvo_silice.sql',
    import.meta.url,
  ),
  'utf8',
)
const linkComponent = await readFile(
  new URL('../src/components/InminerLink.tsx', import.meta.url),
  'utf8',
)

test('ningún curso queda como presencial', () => {
  assert.match(migration, /set modality = 'hybrid'/)
  assert.match(migration, /where cv\.modality = 'in_person'/)
  // Y la migración se planta si quedara alguno.
  assert.match(migration, /raise exception 'Siguen quedando % versiones presenciales'/)
})

test('la formación de sílice sigue siendo online', () => {
  assert.match(migration, /prevencion-polvo-silice-cristalina-respirable/)
  assert.match(migration, /debe seguir siendo online/)
})

test('la migración no borra ni redefine nada', () => {
  for (const forbidden of [/delete from/i, /drop /i, /truncate/i, /alter table/i]) {
    assert.doesNotMatch(migration, forbidden)
  }
  // Las prácticas dependen de su propio campo y no se tocan.
  assert.doesNotMatch(migration, /practice_required\s*=/)
})

test('las etiquetas públicas de modalidad siguen siendo las de siempre', () => {
  assert.equal(modalityLabel('hybrid'), 'Híbrido')
  assert.equal(modalityLabel('online'), 'Online')
  // El valor presencial se conserva por si apareciera en datos históricos.
  assert.equal(modalityLabel('in_person'), 'Presencial')
})

test('el enlace corporativo apunta a la web de la empresa y se abre seguro', () => {
  assert.equal(ORGANIZATION.corporateSite, 'https://inminer.es')
  // La dirección no se escribe a mano en el componente: sale de ORGANIZATION.
  assert.match(linkComponent, /href=\{ORGANIZATION\.corporateSite\}/)
  assert.doesNotMatch(linkComponent, /href="https/)
  // Abrir en pestaña nueva sin exponer la ventana de origen.
  assert.match(linkComponent, /rel="noopener noreferrer"/)
  assert.match(linkComponent, /target="_blank"/)
})

test('el enlace usa el nombre con que cada página ya llama a la empresa', () => {
  // Sin hijos cae al nombre oficial; con hijos respeta la forma de la página.
  assert.match(linkComponent, /\{children \?\? ORGANIZATION\.name\}/)
  // Y la forma societaria puede quedar fuera del enlace.
  assert.match(linkComponent, /\{suffix\}/)
})

test('se enlaza una sola vez por página, y no dentro del encabezado', async () => {
  const pages = [
    '../src/routes/index.tsx',
    '../src/routes/contacto.tsx',
    '../src/routes/sobre-nosotros.tsx',
    '../src/components/Footer.tsx',
    '../src/components/AuthLayout.tsx',
  ]
  for (const page of pages) {
    const source = await readFile(new URL(page, import.meta.url), 'utf8')
    const uses = source.match(/<InminerLink[\s>]/g) ?? []
    assert.equal(uses.length, 1, `${page} enlaza ${uses.length} veces`)
  }

  // El encabezado del catálogo nombra a la empresa, pero un enlace dentro del
  // h1 sería mala práctica: ahí se queda como texto.
  const catalog = await readFile(
    new URL('../src/routes/catalogo.tsx', import.meta.url),
    'utf8',
  )
  assert.doesNotMatch(catalog, /<InminerLink/)
})

test('los documentos y los correos no llevan enlace', async () => {
  // Un certificado en PDF y un correo administrativo no son páginas web.
  for (const file of [
    '../src/lib/certificate-pdf.ts',
    '../src/server/admin-payment-email.ts',
    '../src/server/completion/internal-completion-pdf.ts',
  ]) {
    const source = await readFile(new URL(file, import.meta.url), 'utf8')
    assert.doesNotMatch(source, /InminerLink/)
  }
})
