import { getBearerToken, getSupabaseAdmin } from './supabase-admin'

export async function requireAdministrator(request: Request) {
  const token = getBearerToken(request)
  if (!token) return null

  const supabase = getSupabaseAdmin()
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser(token)
  if (error || !user) return null

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
