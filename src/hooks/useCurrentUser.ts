import { useEffect, useState } from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { AppRole, SessionUser } from '../lib/types'

type CurrentUserState = {
  user: SessionUser | null
  loading: boolean
}

export function useCurrentUser(): CurrentUserState {
  const [state, setState] = useState<CurrentUserState>({
    user: null,
    loading: true,
  })

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) {
      setState({ user: null, loading: false })
      return
    }
    const client = supabase

    let active = true

    async function hydrate() {
      const {
        data: { user },
      } = await client.auth.getUser()

      if (!active) return
      if (!user?.email) {
        setState({ user: null, loading: false })
        return
      }

      const [{ data: profile }, { data: roles }] = await Promise.all([
        client
          .from('profiles')
          .select('first_name')
          .eq('id', user.id)
          .maybeSingle(),
        client.from('user_roles').select('role').eq('user_id', user.id),
      ])

      if (!active) return
      setState({
        user: {
          id: user.id,
          email: user.email,
          firstName: profile?.first_name || '',
          roles: (roles ?? []).map((item) => item.role as AppRole),
        },
        loading: false,
      })
    }

    void hydrate()
    const {
      data: { subscription },
    } = client.auth.onAuthStateChange(() => {
      void hydrate()
    })

    return () => {
      active = false
      subscription.unsubscribe()
    }
  }, [])

  return state
}
