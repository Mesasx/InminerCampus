import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const read = (path: string) => readFile(path, 'utf8')

test('la portada de Campus usa la fotografía oficial, rutas reales e imagen optimizada', async () => {
  const [home, hero, header, accountMenu, layout, courses, slider] = await Promise.all([
    read('src/routes/index.tsx'),
    read('src/components/Hero.tsx'),
    read('src/components/PublicHeader.tsx'),
    read('src/components/AccountMenu.tsx'),
    read('src/components/PublicLayout.tsx'),
    read('src/hooks/usePublicCourses.ts'),
    read('src/components/CourseSlider.tsx'),
  ])

  assert.match(home, /hero-campus-cargadora\.png/)
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

test('no queda ningún rastro de la categoría VIP ni del sistema de navegación antiguo', async () => {
  const [header, catalogo, category, footer, home, appShell] = await Promise.all([
    read('src/components/PublicHeader.tsx'),
    read('src/routes/catalogo.tsx'),
    read('src/lib/course-category.ts'),
    read('src/components/Footer.tsx'),
    read('src/routes/index.tsx'),
    read('src/components/AppShell.tsx'),
  ])

  for (const [name, content] of [
    ['PublicHeader', header],
    ['catalogo', catalogo],
    ['course-category', category],
    ['Footer', footer],
    ['index', home],
  ] as const) {
    assert.doesNotMatch(content, /\bvip\b/i, `${name} no debería mencionar VIP`)
  }

  // Un único header/navbar: las páginas del área de alumno (mis-cursos, curso,
  // perfil...) reutilizan el mismo PublicHeader en lugar de una identidad propia.
  assert.match(appShell, /<PublicHeader\s*\/>/)
})

test('el header distingue estado autenticado, no autenticado y de carga', async () => {
  const header = await read('src/components/PublicHeader.tsx')

  assert.match(header, /loading \? null :/)
  assert.match(header, /Iniciar sesión/)
  assert.match(header, /Crear cuenta/)
  assert.match(header, /user \? \(\s*<Link to="\/mis-cursos"/)
})

test('el logotipo es un único archivo centralizado sin texto "Campus" duplicado', async () => {
  const logo = await read('src/components/Logo.tsx')

  assert.match(logo, /inminer-campus-logo\.png/)
  assert.doesNotMatch(logo, />Campus</)
  assert.doesNotMatch(logo, /brand__campus/)
})
