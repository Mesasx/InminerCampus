import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

// Prueba prioritaria: el contenido SEO de una ficha de curso no puede depender
// de una petición del cliente posterior a la hidratación.
//
// Se comprueba en dos niveles:
//
//  1. Estructural (siempre): la ruta resuelve el curso en un `loader`, que
//     TanStack Start ejecuta durante el SSR, y el componente lo lee con
//     `useLoaderData`. Si alguien volviera a mover la carga a un `useEffect`,
//     el rastreador recibiría de nuevo sólo cabecera y pie, y esto falla.
//
//  2. De extremo a extremo (opcional): si se define `SEO_SMOKE_BASE_URL`
//     (p. ej. la URL de un preview de Vercel), se descarga el HTML real y se
//     verifica el título, la canónica, el H1 y el JSON-LD sin ejecutar nada de
//     JavaScript, que es exactamente lo que ve Googlebot en el primer pase.

const courseRoute = new URL(
  '../src/routes/cursos.$courseSlug.tsx',
  import.meta.url,
)
const catalogRoute = new URL('../src/routes/catalogo.tsx', import.meta.url)
const homeRoute = new URL('../src/routes/index.tsx', import.meta.url)

test('la ficha de curso resuelve sus datos en el servidor, no en el cliente', async () => {
  const source = await readFile(courseRoute, 'utf8')

  assert.match(
    source,
    /loader: async \(\{ params \}\)/,
    'la ficha debe cargar el curso en un loader ejecutado en SSR',
  )
  assert.match(source, /fetchPublicCourse\(params\.courseSlug\)/)
  assert.match(source, /Route\.useLoaderData\(\)/)

  // Nada de cargar el curso tras la hidratación. Se busca la llamada, no la
  // palabra, para no chocar con el comentario que documenta el cambio.
  assert.doesNotMatch(
    source,
    /useEffect\(/,
    'la ficha no debe volver a cargar datos con useEffect',
  )
  assert.doesNotMatch(source, /getSupabaseBrowserClient/)

  // El `head` tiene que derivarse del curso cargado; si no, todas las fichas
  // volverían a compartir el título genérico del sitio.
  assert.match(source, /head: \(\{ loaderData \}\)/)
  assert.match(source, /courseMetaTitle\(course\)/)
  assert.match(source, /courseMetaDescription\(course\)/)

  // Un slug inexistente debe responder 404, no un 200 con «Curso no disponible».
  assert.match(source, /throw notFound\(\)/)
})

test('el catálogo y la home enlazan las fichas desde el HTML del servidor', async () => {
  for (const [name, url] of [
    ['catálogo', catalogRoute],
    ['home', homeRoute],
  ] as const) {
    const source = await readFile(url, 'utf8')
    assert.match(
      source,
      /loader: async \(\) => \(\{ courses: toCourseCards\(await fetchPublicCourses\(\)\) \}\)/,
      `${name} debe resolver el catálogo en el servidor`,
    )
    assert.match(source, /Route\.useLoaderData\(\)/)
    assert.doesNotMatch(
      source,
      /usePublicCourses/,
      `${name} no debe cargar el catálogo tras la hidratación`,
    )
  }
})

const baseUrl = process.env.SEO_SMOKE_BASE_URL?.replace(/\/$/, '')

test(
  'el HTML servido de una ficha contiene nombre, descripción y datos estructurados',
  { skip: baseUrl ? false : 'define SEO_SMOKE_BASE_URL para ejecutarla' },
  async () => {
    const slug = 'operador-maquinaria-arranque-carga-viales'
    const response = await fetch(`${baseUrl}/cursos/${slug}`)
    assert.equal(response.status, 200)
    const html = await response.text()

    // Nombre del curso en el título y en el H1.
    assert.match(html, /<title>Curso Operador de maquinaria de arranque/)
    assert.match(html, /<h1>Operador de maquinaria de arranque, carga y viales<\/h1>/)

    // Descripción propia, no la genérica del sitio.
    const description = html.match(
      /<meta name="description" content="([^"]*)"/,
    )?.[1]
    assert.ok(description, 'falta la meta description')
    assert.doesNotMatch(
      description,
      /^Campus de formación preventiva de INMINER INGENIERÍA/,
      'la ficha sigue usando la descripción genérica del sitio',
    )

    // Canónica limpia, sin `?version=`.
    assert.match(
      html,
      new RegExp(
        `<link rel="canonical" href="https://inminercampus\\.com/cursos/${slug}"`,
      ),
    )

    // El rastreador no debe encontrarse el estado de carga.
    assert.doesNotMatch(html, /Cargando la información del curso/)

    // JSON-LD presente y válido.
    const jsonLd = html.match(
      /<script type="application\/ld\+json">(.*?)<\/script>/s,
    )?.[1]
    assert.ok(jsonLd, 'falta el bloque JSON-LD')
    const graph = JSON.parse(jsonLd.replace(/\\u003c/g, '<'))['@graph'] as Array<{
      '@type': string
      name?: string
    }>
    const course = graph.find((node) => node['@type'] === 'Course')
    assert.ok(course, 'falta el nodo Course')
    assert.equal(course.name, 'Operador de maquinaria de arranque, carga y viales')
    assert.ok(graph.some((node) => node['@type'] === 'BreadcrumbList'))
  },
)

test(
  'robots.txt y sitemap.xml responden y el sitemap no expone rutas privadas',
  { skip: baseUrl ? false : 'define SEO_SMOKE_BASE_URL para ejecutarla' },
  async () => {
    const robots = await fetch(`${baseUrl}/robots.txt`)
    assert.equal(robots.status, 200)
    const robotsBody = await robots.text()
    assert.match(robotsBody, /Sitemap: https:\/\/inminercampus\.com\/sitemap\.xml/)

    const sitemap = await fetch(`${baseUrl}/sitemap.xml`)
    assert.equal(sitemap.status, 200)
    const xml = await sitemap.text()

    const locs = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map(
      (match) => match[1],
    )
    assert.ok(locs.length > 0, 'el sitemap está vacío')

    for (const loc of locs) {
      assert.ok(
        loc.startsWith('https://inminercampus.com'),
        `${loc} no usa el dominio canónico`,
      )
      assert.doesNotMatch(
        loc,
        /\/(acceso|registro|perfil|mis-cursos|facturas|campus|admin|empresa\/|comprar|pago|api)/,
        `${loc} es una ruta privada y no debe estar en el sitemap`,
      )
      assert.doesNotMatch(loc, /version=/, `${loc} incluye un id de versión`)
    }

    // Cada URL del sitemap debe responder 200: un sitemap con 404 quema
    // presupuesto de rastreo y ensucia los informes de Search Console.
    for (const loc of locs) {
      const path = loc.replace('https://inminercampus.com', '')
      const page = await fetch(`${baseUrl}${path}`)
      assert.equal(page.status, 200, `${loc} responde ${page.status}`)
    }
  },
)
