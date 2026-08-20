import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'
import { requireArchiveAgent } from '../server/billing/machine-auth'

const failureSchema = z.object({
  error: z.string().trim().min(1).max(300),
})

export const Route = createFileRoute('/api/internal/archive/$invoiceId/fail')({
  server: {
    handlers: {
      POST: async ({ request, params }) => {
        const agent = await requireArchiveAgent(request)
        if (!agent) return new Response('Unauthorized', { status: 401 })
        if (agent.rateLimited) {
          return new Response('Too many requests', { status: 429 })
        }
        const parsed = failureSchema.safeParse(
          await request.json().catch(() => null),
        )
        if (!parsed.success) {
          return Response.json({ error: 'Invalid failure report' }, { status: 400 })
        }

        const { data: job } = await agent.supabase
          .from('billing_jobs')
          .select('id')
          .eq('invoice_id', params.invoiceId)
          .eq('type', 'local_archive')
          .eq('status', 'processing')
          .maybeSingle()
        if (!job) return new Response('Archive job not found', { status: 404 })

        const message = parsed.data.error.slice(0, 300)
        const { error } = await agent.supabase.rpc('complete_billing_job', {
          p_job_id: job.id,
          p_success: false,
          p_retryable: true,
          p_error: message,
        })
        if (error) return new Response('Failure report rejected', { status: 500 })

        await agent.supabase
          .from('invoices')
          .update({ local_archive_status: 'error', last_error: message })
          .eq('id', params.invoiceId)
        return Response.json({ ok: true })
      },
    },
  },
})
