import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const apiUrl = new URL('../src/routes/api.admin-users.ts', import.meta.url)
const pageUrl = new URL('../src/routes/admin.usuarios.tsx', import.meta.url)

test('el directorio administrativo parte de Auth y permanece protegido', async () => {
  const api = await readFile(apiUrl, 'utf8')

  assert.match(api, /requireAdministrator\(request\)/)
  assert.match(api, /auth\.admin\.listUsers/)
  assert.match(api, /Cache-Control': 'private, no-store'/)
  assert.doesNotMatch(api, /raw_user_meta_data|user_metadata/)
})

test('la ficha incluye datos personales, cursos y tiempos de realización', async () => {
  const [api, page] = await Promise.all([
    readFile(apiUrl, 'utf8'),
    readFile(pageUrl, 'utf8'),
  ])

  for (const field of [
    'phone',
    'dni',
    'registered_at',
    'last_sign_in_at',
    'started_at',
    'completed_at',
    'active_seconds',
    'progress_percent',
  ]) {
    assert.match(api, new RegExp(`\\b${field}\\b`))
  }

  assert.match(page, /Tiempo activo/)
  assert.match(page, /Tiempo transcurrido/)
  assert.match(page, /Cursos y progreso/)
  assert.match(page, /fetch\('\/api\/admin-users'/)
})
