import { createFileRoute } from '@tanstack/react-router'
import { REDIRECTED_PATHS } from '../lib/public-routes'

// URL retirada: su contenido se ha ampliado en la guía general de formación
// minera. Se responde con un 301 desde el servidor (y no con una redirección
// de cliente) para que Google traslade las señales de la URL antigua a la
// nueva y deje de mostrarla en los resultados.
const target = REDIRECTED_PATHS['/formacion-preventiva-oficial']

export const Route = createFileRoute('/formacion-preventiva-oficial')({
  server: {
    handlers: {
      GET: () =>
        new Response(null, {
          status: 301,
          headers: {
            Location: target,
            'Cache-Control': 'public, max-age=3600, s-maxage=86400',
          },
        }),
    },
  },
})
