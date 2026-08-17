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

  assert.match(home, /hero-loader\.png/)
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

test('el hero es una interfaz real: logo, textos y CTA como HTML, no una foto con el texto quemado', async () => {
  const [hero, home] = await Promise.all([
    read('src/components/Hero.tsx'),
    read('src/routes/index.tsx'),
  ])

  // El componente recibe el copy como props reales (eyebrow/title/subtitle),
  // no como parte de una única imagen de fondo con el texto ya dibujado.
  assert.match(hero, /\{eyebrow\}/)
  assert.match(hero, /\{title\}/)
  assert.match(hero, /\{subtitle\}/)
  assert.match(hero, /<Logo\s*\/>/)
  // La imagen de fondo se marca como decorativa (alt vacío): el contenido
  // significativo lo aporta el HTML real, no la fotografía.
  assert.match(hero, /alt=""/)
  // El CTA es un enlace real con scroll suave por JS y fallback de ancla nativo.
  assert.match(hero, /scrollIntoView/)
  assert.match(hero, /behavior:\s*'smooth'/)
  assert.doesNotMatch(hero, /hero-campus-cargadora/)
  assert.match(home, /hero-loader\.png/)
  assert.doesNotMatch(home, /hero-campus-cargadora/)
})

test('el "20H" nunca se parte carácter a carácter (regresión de overflow-wrap heredado)', async () => {
  // Regresión: `p, span... { overflow-wrap: anywhere }` es una regla global,
  // y una columna de texto demasiado estrecha (padding duplicado a ambos
  // lados) hacía que "20H" se partiera en "2 / 0 / H" en pantallas anchas.
  const styles = await read('src/styles/app.css')
  const countRule = styles.match(/\.campus-hero__count\s*\{[^}]*\}/)
  assert.ok(countRule, '.campus-hero__count debe existir')
  assert.match(countRule![0], /white-space:\s*nowrap/)
})

test('el menú móvil permanece oculto por defecto (no se dibuja sin estilo junto a la navbar de escritorio)', async () => {
  // Regresión: `.mobile-menu__panel` solo tenía `display:none` dentro del
  // media query móvil, así que en escritorio se renderizaba como bloque sin
  // estilo justo detrás de la navbar real (texto de los dos menús pegado:
  // "CampusMis cursosMineríaOtros...").
  const css = await read('src/styles/app.css')
  const lines = css.split('\n')
  let depth = 0
  const mediaStack: number[] = []
  let collectingBody: string[] | null = null

  for (const line of lines) {
    if (/@media/.test(line)) mediaStack.push(depth)
    const opens = (line.match(/\{/g) ?? []).length
    const closes = (line.match(/\}/g) ?? []).length
    const beforeDepth = depth
    depth += opens - closes
    while (mediaStack.length && depth <= mediaStack[mediaStack.length - 1]) mediaStack.pop()

    if (
      !collectingBody &&
      mediaStack.length === 0 &&
      beforeDepth === 0 &&
      /^\.mobile-menu__panel\s*\{/.test(line.trim())
    ) {
      collectingBody = []
      continue
    }
    if (collectingBody) {
      if (closes > 0) break
      collectingBody.push(line)
    }
  }

  assert.ok(
    collectingBody,
    '.mobile-menu__panel debe tener una regla fuera de cualquier @media (oculto por defecto en escritorio)',
  )
  assert.match(
    collectingBody!.join('\n'),
    /display:\s*none/,
    'esa regla de nivel superior debe ocultar el panel con display:none',
  )
})
