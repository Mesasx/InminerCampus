import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const requestSchema = z.object({
  purchaseItemId: z.uuid(),
})

const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'

function randomSegment(): string {
  const bytes = crypto.getRandomValues(new Uint8Array(4))
  return Array.from(bytes, (byte) => alphabet[byte % alphabet.length]).join('')
}

function createCode(): string {
  return `INM-${randomSegment()}-${randomSegment()}-${randomSegment()}`
}

export const Route = createFileRoute('/api/company-access-codes')({
  server: {
    handlers: {
      POST: async ({ request }) => {
        const { getBearerToken, getSupabaseAdmin } = await import(
          '../server/supabase-admin'
        )
        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        let body: z.infer<typeof requestSchema>
        try {
          body = requestSchema.parse(await request.json())
        } catch {
          return Response.json({ error: 'Solicitud no válida.' }, { status: 400 })
        }

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
        } = await supabase.auth.getUser(token)
        if (!user) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const { data: item } = await supabase
          .from('purchase_items')
          .select(
            'id, quantity, purchases!inner(id, organization_id, kind, status)',
          )
          .eq('id', body.purchaseItemId)
          .maybeSingle()

        if (!item) {
          return Response.json({ error: 'Pedido no encontrado.' }, { status: 404 })
        }

        const purchase = item.purchases as unknown as {
          organization_id: string | null
          kind: string
          status: string
        }
        if (
          !purchase.organization_id ||
          purchase.kind !== 'company' ||
          purchase.status !== 'paid'
        ) {
          return Response.json(
            { error: 'El pedido no permite generar códigos.' },
            { status: 409 },
          )
        }

        const [{ data: membership }, { data: globalRole }] = await Promise.all([
          supabase
            .from('organization_members')
            .select('user_id')
            .eq('organization_id', purchase.organization_id)
            .eq('user_id', user.id)
            .eq('role', 'responsable_empresa')
            .eq('status', 'active')
            .maybeSingle(),
          supabase
            .from('user_roles')
            .select('user_id')
            .eq('user_id', user.id)
            .eq('role', 'superadministrador')
            .maybeSingle(),
        ])

        if (!membership && !globalRole) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }

        const { count } = await supabase
          .from('access_codes')
          .select('*', { count: 'exact', head: true })
          .eq('purchase_item_id', body.purchaseItemId)
        const remaining = Number(item.quantity) - (count ?? 0)
        if (remaining <= 0) {
          return Response.json(
            { error: 'Todas las plazas ya tienen código.' },
            { status: 409 },
          )
        }

        const codes = Array.from({ length: remaining }, createCode)
        const { error } = await supabase.rpc(
          'create_company_access_code_batch',
          {
            p_purchase_item_id: body.purchaseItemId,
            p_plaintext_codes: codes,
          },
        )
        if (error) {
          return Response.json(
            { error: 'No se ha podido generar el lote.' },
            { status: 500 },
          )
        }

        return Response.json({ codes })
      },
    },
  },
})
