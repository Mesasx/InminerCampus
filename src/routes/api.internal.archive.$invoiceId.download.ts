import { createFileRoute } from '@tanstack/react-router'
import { requireArchiveAgent } from '../server/billing/machine-auth'

export const Route = createFileRoute('/api/internal/archive/$invoiceId/download')({
  server: {
    handlers: {
      GET: async ({ request, params }) => {
        const agent = await requireArchiveAgent(request)
        if (!agent) return new Response('Unauthorized', { status: 401 })
        if (agent.rateLimited) return new Response('Too many requests', { status: 429 })

        const { data: invoice } = await agent.supabase
          .from('invoices')
          .select(
            'invoice_number, official_invoice_number, pdf_storage_path, pdf_sha256, billing_jobs!inner(type, status)',
          )
          .eq('id', params.invoiceId)
          .eq('billing_jobs.type', 'local_archive')
          .eq('billing_jobs.status', 'processing')
          .maybeSingle()
        if (!invoice?.pdf_storage_path || !invoice.pdf_sha256) {
          return new Response('Invoice not available', { status: 404 })
        }
        const { data: pdf, error } = await agent.supabase.storage
          .from('billing-documents')
          .download(invoice.pdf_storage_path)
        if (error || !pdf) return new Response('Download failed', { status: 500 })

        return new Response(pdf, {
          headers: {
            'Content-Type': 'application/pdf',
            'Content-Disposition': `attachment; filename="${safeFileName(invoice.official_invoice_number || invoice.invoice_number)}.pdf"`,
            'X-Invoice-Sha256': invoice.pdf_sha256,
            'Cache-Control': 'no-store',
          },
        })
      },
    },
  },
})

function safeFileName(value: string): string {
  return value.replace(/[^A-Za-z0-9._-]+/g, '-')
}
