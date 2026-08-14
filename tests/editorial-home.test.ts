import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const read = (path: string) => readFile(path, 'utf8')

test('la portada editorial conserva rutas reales, imagen optimizada y cursos dinámicos', async () => {
  const [home, header, layout, courses] = await Promise.all([
    read('src/routes/index.tsx'),
    read('src/components/PublicHeader.tsx'),
    read('src/components/PublicLayout.tsx'),
    read('src/hooks/usePublicCourses.ts'),
  ])

  assert.match(home, /hero-inminer-campus\.jpg/)
  assert.match(home, /Formación Preventiva Oficial · ITC 02\.1\.02/)
  assert.match(home, /total=\{courses\.length\}/)
  assert.doesNotMatch(home, /\b01\s*\/\s*06\b/)
  assert.match(header, /'\/mis-cursos'/)
  assert.match(header, /'\/catalogo'/)
  assert.match(header, /'\/sobre-nosotros'/)
  assert.match(header, /'\/perfil'/)
  assert.match(layout, /<PublicHeader editorial=\{editorial\}/)
  assert.match(courses, /\.from\('course_versions'\)/)
  assert.match(courses, /\.eq\('status', 'published'\)/)
})

test('la experiencia contempla carga diferida, scroll suave y movimiento reducido', async () => {
  const [home, styles] = await Promise.all([
    read('src/routes/index.tsx'),
    read('src/styles/app.css'),
  ])

  assert.match(home, /fetchPriority="high"/)
  assert.match(home, /loading="lazy"/)
  assert.match(styles, /scroll-snap-type:\s*y proximity/)
  assert.match(styles, /@media \(prefers-reduced-motion: reduce\)/)
  assert.match(styles, /min-height:\s*100svh/)
})
