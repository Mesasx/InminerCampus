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

        let purchasesQuery = supabase
          .from('purchases')
          .select('id')
          .in('status', ['paid', 'refunded', 'partially_refunded'])
          .limit(2_000)
        if (!isStaff) {
          const filters = [`buyer_user_id.eq.${user.id}`]
          if (organizationIds.length) {
            filters.push(`organization_id.in.(${organizationIds.join(',')})`)
          }
          purchasesQuery = purchasesQuery.or(filters.join(','))
        }
        const { data: purchases, error: purchaseError } = await purchasesQuery
        if (purchaseError) {
          return Response.json(
            { error: 'No se han podido cargar las facturas.' },
            { status: 500 },
          )
        }
        const purchaseIds = (purchases ?? []).map((purchase) => purchase.id)
        if (!purchaseIds.length) {
          return Response.json({ invoices: [] })
        }

        const { data, error } = await supabase
          .from('invoices')
          .select(
            'id, invoice_number, internal_invoice_reference, official_invoice_number, status, issued_at, total_cents, currency, pdf_storage_path, refund_requires_credit_note, purchases!inner(order_number, paid_at, purchase_items(course_title_snapshot, quantity))',
          )
          .in('purchase_id', purchaseIds)
          .order('created_at', { ascending: false })
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
