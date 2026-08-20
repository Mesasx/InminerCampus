import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'
import {
  requireArchiveAgent,
  secureTokenEqual,
} from '../server/billing/machine-auth'

const confirmationSchema = z.object({
  sha256: z.string().regex(/^[a-f0-9]{64}$/),
  path: z.string().trim().min(3).max(1_000),
})

export const Route = createFileRoute('/api/internal/archive/$invoiceId/confirm')({
  server: {
    handlers: {
      POST: async ({ request, params }) => {
        const agent = await requireArchiveAgent(request)
        if (!agent) return new Response('Unauthorized', { status: 401 })
        if (agent.rateLimited) return new Response('Too many requests', { status: 429 })

        const parsed = confirmationSchema.safeParse(
          await request.json().catch(() => null),
        )
        if (!parsed.success) {
          return Response.json({ error: 'Invalid confirmation' }, { status: 400 })
        }
        const { data: invoice } = await agent.supabase
          .from('invoices')
          .select('pdf_sha256, email_sent_at, billing_jobs!inner(type, status)')
          .eq('id', params.invoiceId)
          .eq('billing_jobs.type', 'local_archive')
          .eq('billing_jobs.status', 'processing')
          .maybeSingle()
        if (!invoice?.pdf_sha256) return new Response('Invoice not found', { status: 404 })
        if (!secureTokenEqual(parsed.data.sha256, invoice.pdf_sha256)) {
          return Response.json({ error: 'SHA-256 mismatch' }, { status: 409 })
        }

        const now = new Date().toISOString()
        const { error } = await agent.supabase
          .from('invoices')
          .update({
            local_archive_status: 'archived',
            local_archive_path: parsed.data.path,
            local_archived_at: now,
            status: invoice.email_sent_at ? 'archived' : 'email_pending',
            last_error: null,
          })
          .eq('id', params.invoiceId)
        if (error) return new Response('Confirmation failed', { status: 500 })

        await agent.supabase
          .from('billing_jobs')
          .update({ status: 'completed', next_attempt_at: null, last_error: null, locked_at: null })
          .eq('invoice_id', params.invoiceId)
          .eq('type', 'local_archive')
        return Response.json({ ok: true })
      },
    },
  },
})
