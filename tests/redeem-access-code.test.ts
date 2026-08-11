import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const routeUrl = new URL('../src/routes/canjear-codigo.tsx', import.meta.url)
const migrationUrl = new URL(
  '../supabase/migrations/202607290003_commerce_practices_support_certificates.sql',
  import.meta.url,
)

test('el canje usa el nombre del argumento publicado por la función RPC', async () => {
  const [route, migration] = await Promise.all([
    readFile(routeUrl, 'utf8'),
    readFile(migrationUrl, 'utf8'),
  ])

  assert.match(migration, /function public\.redeem_access_code\(input_code text\)/)
  assert.match(route, /'redeem_access_code',[\s\S]*\{ input_code:/)
  assert.doesNotMatch(route, /'redeem_access_code',[\s\S]*\{ p_code:/)
})
