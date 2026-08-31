import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import { DNI_ERROR_MESSAGE, isValidDni, normalizeDni } from '../src/lib/dni.ts'

const registroUrl = new URL('../src/routes/registro.tsx', import.meta.url)
const perfilUrl = new URL('../src/routes/perfil.tsx', import.meta.url)
const migrationUrl = new URL(
  '../supabase/migrations/20260831075000_transporte_online_y_dni_obligatorio.sql',
  import.meta.url,
)

test('la validación acepta DNI y NIE y rechaza lo demás', () => {
  assert.ok(isValidDni('05721030X'))
  assert.ok(isValidDni('X1234567L'))
  assert.ok(isValidDni('  05721030x  '), 'tolera espacios y minúsculas')
  assert.ok(isValidDni('0572-1030-X'), 'tolera guiones')

  assert.ok(!isValidDni(''), 'un DNI vacío ya no pasa')
  assert.ok(!isValidDni('1234567Z'), 'faltan dígitos')
  assert.ok(!isValidDni('A1234567Z'), 'letra inicial no válida')
  assert.ok(!isValidDni('123456789'), 'sin letra final')
  // La letra de control se comprueba de verdad, no solo el formato.
  assert.ok(!isValidDni('05721030B'), 'letra de control incorrecta')
  // Un CIF de empresa no identifica a una persona física.
  assert.ok(!isValidDni('A58818501'), 'un CIF no es un DNI')
})

test('normalizeDni deja el formato que guarda el perfil', () => {
  assert.equal(normalizeDni(' 05721030x '), '05721030X')
  assert.equal(normalizeDni('X-1234567-L'), 'X1234567L')
})

test('el alta exige DNI y lo envía en los metadatos', async () => {
  const registro = await readFile(registroUrl, 'utf8')

  assert.match(registro, /if \(!isValidDni\(dni\)\)/)
  assert.match(registro, /setError\(DNI_ERROR_MESSAGE\)/)
  // Sin esto el trigger de alta no puede guardarlo.
  assert.match(registro, /dni: normalizeDni\(dni\)/)
  assert.match(registro, /htmlFor="register-dni"/)
})

test('el perfil ya no permite guardar sin DNI', async () => {
  const perfil = await readFile(perfilUrl, 'utf8')

  // Antes era `if (trimmedDni && !...)`: un DNI vacío se guardaba como null.
  assert.doesNotMatch(perfil, /if \(trimmedDni &&/)
  assert.match(perfil, /if \(!isValidDni\(trimmedDni\)\)/)
  assert.match(perfil, /required=\{!dniLocked\}/)
})

test('el trigger de alta guarda el DNI en el perfil', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /insert into public\.profiles \(id, first_name, last_name, dni, status\)/)
  assert.match(sql, /raw_user_meta_data ->> 'dni'/)
  assert.match(sql, /nullif\(upper\(btrim\(/)
})

test('camión y volquete pasa a online sin práctica presencial', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /362231f3-3900-4b23-a59c-4afc0830134d/)
  assert.match(sql, /modality = 'online'::public\.course_modality/)
  assert.match(sql, /practice_required = false/)
})

test('solo se completan las matrículas cuyo alumno ya tiene DNI', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  // Completar encola el aviso interno, que falla de forma reintentable si
  // falta el DNI. Mejor dejarlas pendientes que provocar un bucle de reintentos.
  assert.match(sql, /btrim\(coalesce\(p\.dni, ''\)\) <> ''/)
})

test('el mensaje de error es el mismo en alta y perfil', async () => {
  const [registro, perfil] = await Promise.all([
    readFile(registroUrl, 'utf8'),
    readFile(perfilUrl, 'utf8'),
  ])

  assert.equal(DNI_ERROR_MESSAGE, 'El DNI/NIE no tiene un formato válido.')
  for (const source of [registro, perfil]) {
    assert.match(source, /DNI_ERROR_MESSAGE/)
    assert.match(source, /from '\.\.\/lib\/dni'/)
  }
})
