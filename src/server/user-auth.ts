import { getBearerToken, getSupabaseAdmin } from './supabase-admin.ts'

/**
 * Authenticates the bearer token and also enforces the administrative account
 * status. Server routes use the service role and therefore cannot rely on RLS
 * to reject pending or suspended accounts.
 */
export async function requireApprovedUser(request: Request) {
  const token = getBearerToken(request)
  if (!token) return null

  const supabase = getSupabaseAdmin()
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser(token)
  if (error || !user) return null

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('id', user.id)
    .eq('status', 'active')
    .maybeSingle()
  if (!profile) return null

  return { supabase, user }
}
