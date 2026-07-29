import { createClient, type SupabaseClient } from '@supabase/supabase-js'
import { appConfig } from './config'

let browserClient: SupabaseClient | undefined

export function getSupabaseBrowserClient(): SupabaseClient | null {
  if (!appConfig.isSupabaseConfigured) return null

  if (!browserClient) {
    browserClient = createClient(
      appConfig.supabaseUrl,
      appConfig.supabasePublishableKey,
      {
        auth: {
          persistSession: true,
          autoRefreshToken: true,
          detectSessionInUrl: true,
        },
      },
    )
  }

  return browserClient
}

export function requireSupabaseBrowserClient(): SupabaseClient {
  const client = getSupabaseBrowserClient()
  if (!client) {
    throw new Error(
      'Supabase no está configurado. Añade VITE_SUPABASE_URL y VITE_SUPABASE_PUBLISHABLE_KEY.',
    )
  }
  return client
}
