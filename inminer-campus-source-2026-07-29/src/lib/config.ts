const supabaseUrl = import.meta.env.VITE_SUPABASE_URL?.trim() ?? ''
const supabasePublishableKey =
  import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY?.trim() ?? ''

export const appConfig = {
  appName: 'InmínerCampus',
  appUrl: import.meta.env.VITE_APP_URL?.trim() || 'http://localhost:3000',
  supabaseUrl,
  supabasePublishableKey,
  turnstileSiteKey: import.meta.env.VITE_TURNSTILE_SITE_KEY?.trim() ?? '',
  isSupabaseConfigured: Boolean(supabaseUrl && supabasePublishableKey),
} as const
