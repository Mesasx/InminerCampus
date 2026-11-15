import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/checkout')({
  server: {
    handlers: {
      POST: async () =>
        Response.json(
          {
            error:
              'La contratación por internet no está disponible. Contacta con Inmíner para recibir información.',
          },
          { status: 410, headers: { 'Cache-Control': 'no-store' } },
        ),
    },
  },
})
