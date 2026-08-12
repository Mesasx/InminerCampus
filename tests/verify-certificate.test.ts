import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const routeUrl = new URL(
  '../src/routes/verificar-certificado.tsx',
  import.meta.url,
)
const migrationUrl = new URL(
  '../supabase/migrations/202607290003_commerce_practices_support_certificates.sql',
  import.meta.url,
)

test('la verificación pública usa el nombre del argumento publicado por la función RPC', async () => {
  const [route, migration] = await Promise.all([
    readFile(routeUrl, 'utf8'),
    readFile(migrationUrl, 'utf8'),
  ])

  assert.match(migration, /function public\.verify_certificate\(input_code text\)/)
  assert.match(route, /'verify_certificate',[\s\S]*\{\s*input_code:/)
  assert.doesNotMatch(route, /'verify_certificate',[\s\S]*\{\s*p_code:/)
})
