import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/invoices')({
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

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser(token)
        if (userError || !user) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const [{ data: roles }, { data: memberships }] = await Promise.all([
          supabase.from('user_roles').select('role').eq('user_id', user.id),
          supabase
            .from('organization_members')
            .select('organization_id')
            .eq('user_id', user.id)
            .eq('role', 'responsable_empresa')
            .eq('status', 'active'),
        ])
        const isStaff = (roles ?? []).some((row) =>
          ['administrador', 'superadministrador'].includes(row.role),
        )
        const organizationIds = (memberships ?? []).map(
          (row) => row.organization_id,
        )

        let query = supabase
          .from('purchases')
          .select(
            'id, order_number, paid_at, invoice_status, invoice_number, invoiced_at, invoice_sent_at, total_amount_cents, currency, invoice_email, purchase_items(course_title_snapshot, quantity)',
          )
          .in('status', ['paid', 'refunded', 'partially_refunded'])
          .order('paid_at', { ascending: false })
          .limit(2_000)
        if (!isStaff) {
          const filters = [`buyer_user_id.eq.${user.id}`]
          if (organizationIds.length) {
            filters.push(`organization_id.in.(${organizationIds.join(',')})`)
          }
          query = query.or(filters.join(','))
        }

        const { data, error } = await query
        if (error) {
          return Response.json(
            { error: 'No se han podido cargar las facturas.' },
            { status: 500 },
          )
        }

        return Response.json(
          { invoices: data ?? [] },
          { headers: { 'Cache-Control': 'no-store' } },
        )
      },
    },
  },
})
