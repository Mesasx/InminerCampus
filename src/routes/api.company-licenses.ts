import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const actionSchema = z
  .object({
    action: z.enum(['reveal', 'retry']),
    recipientId: z.uuid(),
  })
  .strict()

export const Route = createFileRoute('/api/company-licenses')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const context = await authorizedContext(request)
        if (context instanceof Response) return context
        const { organizationIds, supabase } = context
        if (!organizationIds.length) return Response.json({ licenses: [] })

        const { data, error } = await supabase
          .from('company_license_recipients')
          .select(
            'id, organization_id, given_name, family_name, email, delivery_status, delivery_attempts, email_sent_at, last_error, redeemed_at, created_at, access_codes(id, code_last_four, status, used_at, used_by, course_version_id), purchases!inner(order_number, status, paid_at, total_amount_cents, currency, discount_basis_points, discount_amount_cents), purchase_items!inner(course_title_snapshot, quantity)',
          )
          .in('organization_id', organizationIds)
          .eq('purchases.status', 'paid')
          .order('created_at', { ascending: false })
        if (error) {
          return Response.json(
            { error: 'No se han podido cargar las licencias.' },
            { status: 500 },
          )
        }
        const usedUserIds = Array.from(
          new Set(
            (data ?? [])
              .map((row) => (row.access_codes as unknown as { used_by?: string } | null)?.used_by)
              .filter((value): value is string => Boolean(value)),
          ),
        )
        const { data: enrollments } = usedUserIds.length
          ? await supabase
              .from('enrollments')
              .select('id, user_id, course_version_id, status, progress_percent, completed_at')
              .in('organization_id', organizationIds)
              .in('user_id', usedUserIds)
          : { data: [] }
        const enrollmentIds = (enrollments ?? []).map(({ id }) => id)
        const { data: certificates } = enrollmentIds.length
          ? await supabase
              .from('certificates')
              .select('enrollment_id')
              .in('enrollment_id', enrollmentIds)
              .eq('status', 'valid')
          : { data: [] }
        const certifiedEnrollmentIds = new Set(
          (certificates ?? []).map(({ enrollment_id }) => enrollment_id),
        )
        const enrollmentByUserAndCourse = new Map(
          (enrollments ?? []).map((enrollment) => [
            `${enrollment.user_id}:${enrollment.course_version_id}`,
            enrollment,
          ]),
        )
        return Response.json(
          {
            licenses: (data ?? []).map((row) => {
              const accessCode = row.access_codes as unknown as {
                code_last_four: string
                status: string
                used_at: string | null
                used_by: string | null
                course_version_id: string
              } | null
              const purchase = row.purchases as unknown as Record<string, unknown>
              const item = row.purchase_items as unknown as Record<string, unknown>
              const enrollment = accessCode?.used_by
                ? enrollmentByUserAndCourse.get(
                    `${accessCode.used_by}:${accessCode.course_version_id}`,
                  )
                : null
              return {
                id: row.id,
                organizationId: row.organization_id,
                givenName: row.given_name,
                familyName: row.family_name,
                email: row.email,
                maskedCode: accessCode
                  ? `INM-••••-••••-${accessCode.code_last_four}`
                  : 'Pendiente',
                licenseStatus: accessCode?.status ?? 'pending',
                deliveryStatus: row.delivery_status,
                deliveryAttempts: row.delivery_attempts,
                emailSentAt: row.email_sent_at,
                lastError: row.last_error,
                redeemedAt: row.redeemed_at ?? accessCode?.used_at ?? null,
                createdAt: row.created_at,
                orderNumber: purchase.order_number,
                paidAt: purchase.paid_at,
                totalAmountCents: purchase.total_amount_cents,
                currency: purchase.currency,
                discountBasisPoints: purchase.discount_basis_points,
                discountAmountCents: purchase.discount_amount_cents,
                courseTitle: item.course_title_snapshot,
                quantity: item.quantity,
                enrollmentStatus: enrollment?.status ?? null,
                progressPercent: enrollment?.progress_percent ?? null,
                completedAt: enrollment?.completed_at ?? null,
                certificateIssued: enrollment
                  ? certifiedEnrollmentIds.has(enrollment.id)
                  : false,
              }
            }),
          },
          { headers: { 'Cache-Control': 'private, no-store' } },
        )
      },
      POST: async ({ request }) => {
        const context = await authorizedContext(request)
        if (context instanceof Response) return context
        const parsed = actionSchema.safeParse(await request.json().catch(() => null))
        if (!parsed.success) {
          return Response.json({ error: 'Solicitud no válida.' }, { status: 400 })
        }
        const { data: recipient } = await context.supabase
          .from('company_license_recipients')
          .select('id, organization_id')
          .eq('id', parsed.data.recipientId)
          .maybeSingle()
        if (!recipient || !context.organizationIds.includes(recipient.organization_id)) {
          return Response.json({ error: 'Licencia no encontrada.' }, { status: 404 })
        }

        if (parsed.data.action === 'reveal') {
          const { revealRecipientCode } = await import(
            '../server/company-license-service'
          )
          try {
            return Response.json(
              { code: await revealRecipientCode(recipient.id) },
              { headers: { 'Cache-Control': 'private, no-store' } },
            )
          } catch {
            return Response.json(
              { error: 'El código todavía no está disponible.' },
              { status: 409 },
            )
          }
        }

        const { data: retryable } = await context.supabase
          .from('company_license_recipients')
          .update({
            delivery_status: 'failed',
            next_attempt_at: new Date().toISOString(),
          })
          .eq('id', recipient.id)
          .eq('delivery_status', 'failed')
          .select('id')
          .maybeSingle()
        if (!retryable) {
          return Response.json(
            { error: 'Este correo no está pendiente de reintento.' },
            { status: 409 },
          )
        }
        const { sendCompanyLicenseEmail } = await import(
          '../server/company-license-service'
        )
        try {
          const result = await sendCompanyLicenseEmail(recipient.id)
          if (result === 'skipped') {
            return Response.json(
              { error: 'Se ha alcanzado el límite de reintentos. Contacta con administración.' },
              { status: 409 },
            )
          }
          return Response.json({ status: result })
        } catch {
          return Response.json(
            { error: 'No se ha podido reenviar. Podrás volver a intentarlo.' },
            { status: 502 },
          )
        }
      },
    },
  },
})

async function authorizedContext(request: Request) {
  const { getBearerToken, getSupabaseAdmin } = await import(
    '../server/supabase-admin'
  )
  const token = getBearerToken(request)
  if (!token) return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
  const supabase = getSupabaseAdmin()
  const {
    data: { user },
  } = await supabase.auth.getUser(token)
  if (!user) return Response.json({ error: 'Sesión no válida.' }, { status: 401 })

  const [{ data: memberships }, { data: superadmin }] = await Promise.all([
    supabase
      .from('organization_members')
      .select('organization_id')
      .eq('user_id', user.id)
      .eq('role', 'responsable_empresa')
      .eq('status', 'active'),
    supabase
      .from('user_roles')
      .select('user_id')
      .eq('user_id', user.id)
      .eq('role', 'superadministrador')
      .maybeSingle(),
  ])
  let organizationIds = (memberships ?? []).map(({ organization_id }) => organization_id)
  if (superadmin) {
    const { data: organizations } = await supabase.from('organizations').select('id')
    organizationIds = (organizations ?? []).map(({ id }) => id)
  }
  return { supabase, organizationIds }
}
