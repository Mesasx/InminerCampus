import { requireApprovedUser } from './user-auth.ts'

export async function requireAdministrator(request: Request) {
  const context = await requireApprovedUser(request)
  if (!context) return null
  const { supabase, user } = context

  const { data: role } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', user.id)
    .in('role', ['administrador', 'superadministrador'])
    .limit(1)
    .maybeSingle()
  if (!role) return null

  return { supabase, user }
}
