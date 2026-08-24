import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const querySchema = z.object({
  session_id: z.string().trim().min(8).max(255),
})

export const Route = createFileRoute('/api/payment-status')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const { getBearerToken, getSupabaseAdmin } = await import(
          '../server/supabase-admin'
        )
        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const parsed = querySchema.safeParse(
          Object.fromEntries(new URL(request.url).searchParams),
        )
        if (!parsed.success) {
          return Response.json(
            { error: 'Referencia de pago no válida.' },
            { status: 400 },
          )
        }

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser(token)
        if (userError || !user) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const { data: purchase, error } = await supabase
          .from('purchases')
          .select(
            'id, order_number, status, total_amount_cents, currency, billing_email, invoice_email, purchase_items(course_title_snapshot, modality_snapshot, duration_hours_snapshot, quantity)',
          )
          .eq('stripe_checkout_session_id', parsed.data.session_id)
          .eq('buyer_user_id', user.id)
          .maybeSingle()
        if (error || !purchase) {
          return Response.json(
            { error: 'No se ha encontrado este pago.' },
            { status: 404 },
          )
        }

        const paymentStatus =
          purchase.status === 'paid' ||
          purchase.status === 'refunded' ||
          purchase.status === 'partially_refunded'
            ? 'confirmed'
            : purchase.status === 'cancelled' ||
                purchase.status === 'payment_failed'
              ? 'failed'
              : 'pending'

        const item = (
          purchase.purchase_items as unknown as Array<{
            course_title_snapshot: string | null
            modality_snapshot: string | null
            duration_hours_snapshot: number | null
            quantity: number
          }>
        )[0]
        return Response.json({
          status: paymentStatus,
          orderNumber: purchase.order_number,
          courseTitle: item?.course_title_snapshot ?? null,
          modality: item?.modality_snapshot ?? null,
          durationHours: item?.duration_hours_snapshot ?? null,
          quantity: item?.quantity ?? null,
          totalAmountCents: purchase.total_amount_cents,
          currency: purchase.currency,
          invoiceEmail: purchase.invoice_email ?? purchase.billing_email,
        })
      },
    },
  },
})
