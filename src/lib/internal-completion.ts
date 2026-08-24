import { getSupabaseBrowserClient } from './supabase'

export async function requestInternalCompletion(
  enrollmentId: string,
): Promise<void> {
  const supabase = getSupabaseBrowserClient()
  if (!supabase) return
  const { data } = await supabase.auth.getSession()
  const accessToken = data.session?.access_token
  if (!accessToken) return

  await fetch('/api/internal-completion', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ enrollmentId }),
  })
}
