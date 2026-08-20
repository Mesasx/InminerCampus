import { getBearerToken, getSupabaseAdmin } from '../supabase-admin.ts'

export async function requireInvoiceAccess(
  request: Request,
  invoiceId: string,
) {
  const token = getBearerToken(request)
  if (!token) return null

  const supabase = getSupabaseAdmin()
  const {
    data: { user },
    error: userError,
  } = await supabase.auth.getUser(token)
  if (userError || !user) return null

  const { data: invoice, error } = await supabase
    .from('invoices')
    .select(
      'id, purchase_id, invoice_number, official_invoice_number, status, pdf_storage_path, pdf_sha256, purchases!inner(buyer_user_id, organization_id)',
    )
    .eq('id', invoiceId)
    .maybeSingle()
  if (error || !invoice) return null

  const purchase = invoice.purchases as unknown as {
    buyer_user_id: string | null
    organization_id: string | null
  }
  if (
    canAccessInvoiceIdentity({
      userId: user.id,
      buyerUserId: purchase.buyer_user_id,
      isStaff: false,
      isOrganizationManager: false,
    })
  ) {
    return { supabase, user, invoice, isStaff: false }
  }

  const [{ data: staffRole }, { data: membership }] = await Promise.all([
    supabase
      .from('user_roles')
      .select('role')
      .eq('user_id', user.id)
      .in('role', ['administrador', 'superadministrador'])
      .limit(1)
      .maybeSingle(),
    purchase.organization_id
      ? supabase
          .from('organization_members')
          .select('role')
          .eq('organization_id', purchase.organization_id)
          .eq('user_id', user.id)
          .eq('role', 'responsable_empresa')
          .eq('status', 'active')
          .maybeSingle()
      : Promise.resolve({ data: null }),
  ])

  if (
    !canAccessInvoiceIdentity({
      userId: user.id,
      buyerUserId: purchase.buyer_user_id,
      isStaff: Boolean(staffRole),
      isOrganizationManager: Boolean(membership),
    })
  ) {
    return null
  }
  return { supabase, user, invoice, isStaff: Boolean(staffRole) }
}

export function canAccessInvoiceIdentity(input: {
  userId: string
  buyerUserId: string | null
  isStaff: boolean
  isOrganizationManager: boolean
}): boolean {
  return (
    input.buyerUserId === input.userId ||
    input.isStaff ||
    input.isOrganizationManager
  )
}
