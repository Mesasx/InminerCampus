import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/payment-status')({
  server: {
    handlers: {
      GET: async () =>
        Response.json(
          { error: 'La contratación por internet no está disponible.' },
          { status: 410, headers: { 'Cache-Control': 'no-store' } },
        ),
    },
  },
})
