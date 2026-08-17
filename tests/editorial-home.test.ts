import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const read = (path: string) => readFile(path, 'utf8')

test('la portada de Campus conserva rutas reales, imagen optimizada y cursos dinámicos', async () => {
  const [home, hero, header, accountMenu, layout, courses, slider] = await Promise.all([
    read('src/routes/index.tsx'),
    read('src/components/Hero.tsx'),
    read('src/components/PublicHeader.tsx'),
    read('src/components/AccountMenu.tsx'),
    read('src/components/PublicLayout.tsx'),
    read('src/hooks/usePublicCourses.ts'),
    read('src/components/CourseSlider.tsx'),
  ])

  assert.match(home, /hero-inminer-mundo\.jpg/)
  assert.match(home, /Formación Preventiva Oficial · ITC 02\.1\.02/)
  assert.match(hero, /id="campus-hero-sentinel"/)
  assert.match(slider, /courses\.length/)
  assert.doesNotMatch(slider, /\b01\s*\/\s*06\b/)
  assert.match(header, /['"]\/mis-cursos['"]/)
  assert.match(header, /['"]\/catalogo['"]/)
  assert.match(header, /['"]\/sobre-nosotros['"]/)
  assert.match(accountMenu, /['"]\/perfil['"]/)
  assert.match(header, /IntersectionObserver/)
  assert.match(layout, /<PublicHeader heroFull=\{heroFull\}/)
  assert.match(courses, /\.from\('course_versions'\)/)
  assert.match(courses, /\.eq\('status', 'published'\)/)
})

test('la experiencia contempla carga diferida, scroll suave y movimiento reducido', async () => {
  const [hero, slider, styles] = await Promise.all([
    read('src/components/Hero.tsx'),
    read('src/components/CourseSlider.tsx'),
    read('src/styles/app.css'),
  ])

  assert.match(hero, /fetchPriority="high"/)
  assert.match(slider, /loading="lazy"/)
  assert.match(styles, /scroll-snap-type:\s*x mandatory/)
  assert.match(styles, /@media \(prefers-reduced-motion: reduce\)/)
  assert.match(styles, /min-height:\s*100svh/)
})
