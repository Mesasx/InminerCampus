import { createHash, timingSafeEqual } from 'node:crypto'
import { getBearerToken, getSupabaseAdmin } from '../supabase-admin.ts'

export async function requireArchiveAgent(request: Request) {
  const supplied = getBearerToken(request)
  const expected = process.env.ARCHIVE_AGENT_TOKEN?.trim()
  if (!supplied || !expected || !secureTokenEqual(supplied, expected)) {
    return null
  }

  const subject = hashToUuid(supplied)
  const supabase = getSupabaseAdmin()
  const { data: allowed, error } = await supabase.rpc(
    'check_archive_agent_rate_limit',
    { p_subject: subject },
  )
  if (error || !allowed) {
    return { supabase, subject, rateLimited: true as const }
  }
  return { supabase, subject, rateLimited: false as const }
}

export function secureTokenEqual(supplied: string, expected: string): boolean {
  const suppliedHash = createHash('sha256').update(supplied).digest()
  const expectedHash = createHash('sha256').update(expected).digest()
  return timingSafeEqual(suppliedHash, expectedHash)
}

function hashToUuid(value: string): string {
  const bytes = createHash('sha256').update(value).digest('hex').slice(0, 32)
  return [
    bytes.slice(0, 8),
    bytes.slice(8, 12),
    `4${bytes.slice(13, 16)}`,
    `8${bytes.slice(17, 20)}`,
    bytes.slice(20, 32),
  ].join('-')
}
