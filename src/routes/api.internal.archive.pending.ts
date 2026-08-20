import { createFileRoute } from '@tanstack/react-router'
import { requireArchiveAgent } from '../server/billing/machine-auth'

export const Route = createFileRoute('/api/internal/archive/pending')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const agent = await requireArchiveAgent(request)
        if (!agent) return new Response('Unauthorized', { status: 401 })
        if (agent.rateLimited) {
          return new Response('Too many requests', { status: 429 })
        }

        const { data: claimed, error: claimError } = await agent.supabase.rpc(
          'claim_archive_jobs',
          { p_limit: 50 },
        )
        if (claimError) {
          return Response.json({ error: 'Archive queue unavailable' }, { status: 500 })
        }
        const jobs = (claimed ?? []) as Array<{
          id: string
          invoice_id: string
        }>
        if (!jobs.length) {
          return Response.json(
            { invoices: [] },
            { headers: { 'Cache-Control': 'no-store' } },
          )
        }

        const { data, error } = await agent.supabase
          .from('invoices')
          .select(
            'id, invoice_number, official_invoice_number, invoice_year, issued_at, pdf_sha256, pdf_storage_path',
          )
          .in(
            'id',
            jobs.map((job) => job.invoice_id),
          )
        if (error) {
          return Response.json({ error: 'Archive queue unavailable' }, { status: 500 })
        }
        const jobByInvoice = new Map(
          jobs.map((job) => [job.invoice_id, job.id]),
        )

        return Response.json(
          {
            invoices: (data ?? [])
              .filter(
                (invoice) =>
                  invoice.official_invoice_number &&
                  invoice.issued_at &&
                  invoice.pdf_storage_path &&
                  invoice.pdf_sha256,
              )
              .map((invoice) => ({
                id: invoice.id,
                jobId: jobByInvoice.get(invoice.id),
                invoiceNumber:
                  invoice.official_invoice_number || invoice.invoice_number,
                year: invoice.invoice_year,
                month: String(new Date(invoice.issued_at!).getMonth() + 1).padStart(2, '0'),
                issuedAt: invoice.issued_at,
                sha256: invoice.pdf_sha256,
              })),
          },
          { headers: { 'Cache-Control': 'no-store' } },
        )
      },
    },
  },
})
