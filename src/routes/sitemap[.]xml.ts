import { createFileRoute } from '@tanstack/react-router'
import {
  fetchPublicCourses,
  isIndexableCourse,
} from '../lib/public-courses'
import { INDEXABLE_STATIC_ROUTES, isNoindexPath } from '../lib/public-routes'
import { absoluteUrl, canonicalPath } from '../lib/seo'

type SitemapEntry = {
  loc: string
  lastmod?: string
  priority: number
  changefreq: string
}

function escapeXml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')
}

function renderSitemap(entries: Array<SitemapEntry>): string {
  const urls = entries
    .map((entry) =>
      [
        '  <url>',
        `    <loc>${escapeXml(entry.loc)}</loc>`,
        entry.lastmod ? `    <lastmod>${entry.lastmod}</lastmod>` : null,
        `    <changefreq>${entry.changefreq}</changefreq>`,
        `    <priority>${entry.priority.toFixed(1)}</priority>`,
        '  </url>',
      ]
        .filter(Boolean)
        .join('\n'),
    )
    .join('\n')

  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls}\n</urlset>\n`
}

export const Route = createFileRoute('/sitemap.xml')({
  server: {
    handlers: {
      // Se genera en cada petición a partir de Supabase: publicar un curso
      // nuevo lo añade al sitemap sin tocar el repositorio ni redesplegar.
      GET: async () => {
        const entries: Array<SitemapEntry> = INDEXABLE_STATIC_ROUTES.filter(
          (route) => !isNoindexPath(route.path),
        ).map((route) => ({
          loc: absoluteUrl(canonicalPath(route.path)),
          priority: route.priority,
          changefreq: route.changefreq,
        }))

        try {
          const courses = await fetchPublicCourses()
          for (const course of courses) {
            if (!isIndexableCourse(course)) continue
            entries.push({
              loc: absoluteUrl(`/cursos/${course.slug}`),
              lastmod: course.updated_at?.slice(0, 10),
              priority: 0.8,
              changefreq: 'monthly',
            })
          }
        } catch (error) {
          // Un fallo de Supabase no debe devolver un sitemap roto ni un 500:
          // se sirven las rutas estáticas y Google reintentará más adelante.
          console.error('No se han podido añadir los cursos al sitemap.', error)
        }

        return new Response(renderSitemap(entries), {
          headers: {
            'Content-Type': 'application/xml; charset=utf-8',
            'Cache-Control': 'public, max-age=0, s-maxage=3600',
          },
        })
      },
    },
  },
})
