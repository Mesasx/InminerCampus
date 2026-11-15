import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const requestSchema = z.object({
  enrollmentId: z.uuid(),
})

export const Route = createFileRoute('/api/internal-completion')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        const { requireApprovedUser } = await import('../server/user-auth')

        const parsed = requestSchema.safeParse(
          await request.json().catch(() => null),
        )
        if (!parsed.success) {
          return Response.json(
            { error: 'Solicitud de finalización no válida.' },
            { status: 400 },
          )
        }

        const context = await requireApprovedUser(request)
        if (!context) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }
        const { supabase, user } = context

        const { data: enrollment, error: enrollmentError } = await supabase
          .from('enrollments')
          .select('id, status, completed_at')
          .eq('id', parsed.data.enrollmentId)
          .eq('user_id', user.id)
          .maybeSingle()
        if (enrollmentError || !enrollment) {
          return Response.json({ error: 'Matrícula no encontrada.' }, { status: 404 })
        }
        if (enrollment.status !== 'completed' || !enrollment.completed_at) {
          return Response.json(
            { error: 'La formación todavía no está finalizada.' },
            { status: 409 },
          )
        }

        const { processInternalCompletion } = await import(
          '../server/completion/internal-completion-service'
        )
        const result = await processInternalCompletion(enrollment.id)
        return Response.json(
          { status: result },
          { headers: { 'Cache-Control': 'no-store' } },
        )
      },
    },
  },
})
