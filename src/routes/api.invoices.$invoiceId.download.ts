import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/invoices/$invoiceId/download')({
  server: {
    handlers: {
      GET: async ({ request, params }) => {
        const { requireInvoiceAccess } = await import(
          '../server/billing/invoice-access'
        )
        const access = await requireInvoiceAccess(request, params.invoiceId)
        if (!access) {
          return Response.json({ error: 'No autorizado.' }, { status: 403 })
        }
        if (
          !access.invoice.pdf_storage_path ||
          !access.invoice.official_invoice_number
        ) {
          return Response.json(
            { error: 'La factura todavía no está disponible.' },
            { status: 409 },
          )
        }

        const { data, error } = await access.supabase.storage
          .from('billing-documents')
          .createSignedUrl(access.invoice.pdf_storage_path, 60, {
            download: `${safeFileName(access.invoice.official_invoice_number)}.pdf`,
          })
        if (error || !data) {
          return Response.json(
            { error: 'No se ha podido preparar la descarga.' },
            { status: 500 },
          )
        }
        return Response.json(
          {
            url: data.signedUrl,
            filename: `${safeFileName(access.invoice.official_invoice_number)}.pdf`,
          },
          { headers: { 'Cache-Control': 'no-store' } },
        )
      },
    },
  },
})

function safeFileName(value: string): string {
  return value.replace(/[^A-Za-z0-9._-]+/g, '-')
}
