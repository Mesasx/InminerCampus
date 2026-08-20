import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const retrySchema = z.object({
  jobType: z.enum([
    'mnprogram_sync',
    'invoice_issue',
    'invoice_email',
    'local_archive',
  ]),
})

export const Route = createFileRoute('/api/admin/billing/retry/$invoiceId')({
  server: {
    handlers: {
      POST: async ({ request, params }) => {
        const { requireAdministrator } = await import('../server/admin-auth')
        const administrator = await requireAdministrator(request)
        if (!administrator) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }
        const parsed = retrySchema.safeParse(
          await request.json().catch(() => null),
        )
        if (!parsed.success) {
          return Response.json({ error: 'Acción no válida.' }, { status: 400 })
        }

        const { data: invoice } = await administrator.supabase
          .from('invoices')
          .select('id')
          .eq('id', params.invoiceId)
          .maybeSingle()
        if (!invoice) {
          return Response.json({ error: 'Factura no encontrada.' }, { status: 404 })
        }

        const { data: affected, error } = await administrator.supabase.rpc(
          'retry_invoice_jobs',
          { p_invoice_id: invoice.id, p_type: parsed.data.jobType },
        )
        if (error || !affected) {
          return Response.json(
            { error: 'No hay un trabajo pendiente que reintentar.' },
            { status: 409 },
          )
        }

        await administrator.supabase.from('audit_logs').insert({
          actor_user_id: administrator.user.id,
          action: 'invoice.job_retried',
          entity_type: 'invoice',
          entity_id: invoice.id,
          payload: { job_type: parsed.data.jobType },
        })
        return Response.json({ ok: true, message: 'Reintento programado.' })
      },
    },
  },
})
