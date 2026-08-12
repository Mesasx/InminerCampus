import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const configUrl = new URL('../vite.config.ts', import.meta.url)

test('Nitro aplica cabeceras de seguridad a todas las rutas', async () => {
  const config = await readFile(configUrl, 'utf8')

  assert.match(config, /routeRules:\s*\{\s*\r?\n\s*'\/\*\*':\s*\{\s*headers:\s*securityHeaders/)
  assert.match(config, /'Content-Security-Policy':/)
  assert.match(config, /'Strict-Transport-Security':\s*'max-age=31536000/)
  assert.match(config, /'X-Content-Type-Options':\s*'nosniff'/)
  assert.match(config, /'X-Frame-Options':\s*'DENY'/)
  assert.match(config, /'Referrer-Policy':\s*'strict-origin-when-cross-origin'/)
  // Dominios de terceros realmente usados por la app: Supabase, Google
  // Fonts y Cloudflare Turnstile. Si se añade un nuevo dominio externo hay
  // que ampliar la CSP a la vez que este test.
  assert.match(config, /https:\/\/\*\.supabase\.co/)
  assert.match(config, /https:\/\/fonts\.googleapis\.com/)
  assert.match(config, /https:\/\/challenges\.cloudflare\.com/)
})
