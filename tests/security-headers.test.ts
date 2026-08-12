import assert from 'node:assert/strict'
import { readdir, readFile } from 'node:fs/promises'
import test from 'node:test'

const configUrl = new URL('../vite.config.ts', import.meta.url)
const srcRoot = new URL('../src/', import.meta.url)

test('Nitro aplica cabeceras de seguridad a todas las rutas', async () => {
  const config = await readFile(configUrl, 'utf8')

  assert.match(config, /routeRules:\s*\{\s*\r?\n\s*'\/\*\*':\s*\{\s*headers:\s*securityHeaders/)
  assert.match(config, /'Content-Security-Policy':/)
  assert.match(config, /'Strict-Transport-Security':\s*'max-age=31536000/)
  assert.match(config, /'X-Content-Type-Options':\s*'nosniff'/)
  assert.match(config, /'X-Frame-Options':\s*'DENY'/)
  assert.match(config, /'Referrer-Policy':\s*'strict-origin-when-cross-origin'/)
  // Dominios de terceros realmente usados por la app: Supabase, Google
  // Fonts, Cloudflare Turnstile e Inmíner (logo y favicons). Si se añade un
  // nuevo dominio externo hay que ampliar la CSP a la vez que este test.
  assert.match(config, /https:\/\/\*\.supabase\.co/)
  assert.match(config, /https:\/\/fonts\.googleapis\.com/)
  assert.match(config, /https:\/\/challenges\.cloudflare\.com/)
  assert.match(config, /https:\/\/inminer\.es/)
})

async function collectSourceFiles(dir: URL): Promise<URL[]> {
  const entries = await readdir(dir, { withFileTypes: true })
  const files: URL[] = []
  for (const entry of entries) {
    const entryUrl = new URL(
      entry.name + (entry.isDirectory() ? '/' : ''),
      dir,
    )
    if (entry.isDirectory()) {
      files.push(...(await collectSourceFiles(entryUrl)))
    } else if (/\.(ts|tsx)$/.test(entry.name)) {
      files.push(entryUrl)
    }
  }
  return files
}

// Evita que se repita el incidente del logo de Inmíner: la CSP bloqueó
// silenciosamente https://inminer.es porque img-src no lo incluía (solo se
// detectó en producción, con el auto-deploy ya publicado). Este test
// escanea todo src/ en busca de imágenes/iconos servidos desde un dominio
// externo (src=/href: que termina en una extensión de imagen) y falla si
// alguno no está cubierto por img-src.
test('img-src cubre todas las imágenes e iconos externos referenciados en src/', async () => {
  const config = await readFile(configUrl, 'utf8')
  const imgSrcLine = config.match(/"img-src ([^"]+)"/)?.[1] ?? ''
  assert.ok(imgSrcLine, 'no se encontró la directiva img-src en la CSP')

  const files = await collectSourceFiles(srcRoot)
  const contents = await Promise.all(files.map((file) => readFile(file, 'utf8')))
  const urlPattern =
    /https:\/\/[a-zA-Z0-9.-]+\/[^"'\s]*\.(?:png|jpe?g|svg|gif|webp|ico)/g
  const origins = new Set<string>()
  for (const content of contents) {
    for (const match of content.matchAll(urlPattern)) {
      origins.add(new URL(match[0]).origin)
    }
  }

  assert.ok(origins.size > 0, 'no se encontró ninguna imagen externa que comprobar')
  for (const origin of origins) {
    assert.ok(
      imgSrcLine.includes(origin),
      `${origin} sirve una imagen/icono usado en src/ pero no está en img-src`,
    )
  }
})
