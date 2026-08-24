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

        const [
          { processDueBillingJobs },
          { processDueInternalCompletions },
          { processDueCompanyLicenseEmails },
        ] =
          await Promise.all([
            import('../server/billing/billing-jobs'),
            import('../server/completion/internal-completion-service'),
            import('../server/company-license-service'),
          ])
        const [billing, internalCompletions, companyLicenseEmails] = await Promise.all([
          processDueBillingJobs(10),
          processDueInternalCompletions(10),
          processDueCompanyLicenseEmails(100),
        ])
        return Response.json({ billing, internalCompletions, companyLicenseEmails }, {
          headers: { 'Cache-Control': 'no-store' },
        })
      },
    },
  },
})
