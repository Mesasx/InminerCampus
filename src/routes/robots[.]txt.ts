import { createFileRoute } from '@tanstack/react-router'
import { SITE_URL } from '../lib/seo'

// Criterio de este archivo: `robots.txt` NO se usa para desindexar.
//
// Todas las rutas sin valor de búsqueda (acceso, registro, compra, campus,
// panel de empresa, administración…) declaran `noindex` en su propio `<head>`,
// y para que Google lo lea tiene que poder rastrearlas: bloquearlas aquí
// conseguiría el efecto contrario, dejando indexada la URL sin poder ver
// nunca la directiva. Por eso sólo se bloquea `/api/`, que devuelve JSON y no
// puede llevar etiquetas meta.
//
// La protección real de las zonas privadas es la autenticación y las
// políticas RLS de Supabase, no este archivo.
export const Route = createFileRoute('/robots.txt')({
  server: {
    handlers: {
      GET: () => {
        const body = [
          'User-agent: *',
          'Disallow: /api/',
          // Los recursos estáticos deben poder rastrearse: si Googlebot no
          // puede cargar CSS ni JS no renderiza la página correctamente.
          'Allow: /assets/',
          'Allow: /images/',
          'Allow: /brand/',
          '',
          `Sitemap: ${SITE_URL}/sitemap.xml`,
          '',
        ].join('\n')

        return new Response(body, {
          headers: {
            'Content-Type': 'text/plain; charset=utf-8',
            'Cache-Control': 'public, max-age=0, s-maxage=86400',
          },
        })
      },
    },
  },
})
