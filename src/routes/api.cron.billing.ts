import { createFileRoute } from '@tanstack/react-router'
import { secureTokenEqual } from '../server/billing/machine-auth'

export const Route = createFileRoute('/api/cron/billing')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const expected = process.env.CRON_SECRET?.trim()
        const authorization = request.headers.get('authorization')
        const supplied = authorization?.startsWith('Bearer ')
          ? authorization.slice('Bearer '.length).trim()
          : ''
        if (!expected || !supplied || !secureTokenEqual(supplied, expected)) {
          return new Response('Unauthorized', { status: 401 })
        }

        const { processDueBillingJobs } = await import(
          '../server/billing/billing-jobs'
        )
        const result = await processDueBillingJobs(10)
        return Response.json(result, {
          headers: { 'Cache-Control': 'no-store' },
        })
      },
    },
  },
})
