import type { SupabaseClient } from '@supabase/supabase-js'

/**
 * Caché en memoria de URLs firmadas de Supabase Storage, compartida por toda
 * la pestaña. Evita firmar el mismo storage_path más de una vez por curso de
 * vida (hasta que se acerque su caducidad) y agrupa todas las rutas que
 * necesita un componente en una sola llamada a `createSignedUrls`.
 */

type CacheEntry = { url: string; expiresAt: number }

const RENEW_MARGIN_MS = 5 * 60 * 1000

const cache = new Map<string, CacheEntry>()

function cacheKey(bucket: string, path: string) {
  return `${bucket}:${path}`
}

/**
 * Resuelve URLs firmadas para un lote de storage_path, usando la caché
 * cuando quede vigencia suficiente y agrupando el resto en una única
 * llamada a `createSignedUrls`. Si la renovación de una ruta falla, se
 * conserva la última URL firmada conocida en vez de dejarla en blanco, para
 * no cortar el contenido que el alumno ya tiene abierto.
 */
export async function resolveSignedUrls(
  supabase: SupabaseClient,
  bucket: string,
  paths: Array<string | null | undefined>,
  expiresIn = 3600,
): Promise<Record<string, string>> {
  const uniquePaths = Array.from(
    new Set(paths.filter((path): path is string => Boolean(path))),
  )
  if (!uniquePaths.length) return {}

  const now = Date.now()
  const result: Record<string, string> = {}
  const stale: string[] = []

  for (const path of uniquePaths) {
    const entry = cache.get(cacheKey(bucket, path))
    if (entry && entry.expiresAt - now > RENEW_MARGIN_MS) {
      result[path] = entry.url
    } else {
      stale.push(path)
    }
  }

  if (stale.length) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .createSignedUrls(stale, expiresIn)
    if (error) {
      console.error('[signed-url-cache] No se pudieron firmar las URLs', {
        bucket,
        count: stale.length,
        error,
      })
    }
    for (const item of data ?? []) {
      if (!item.path || !item.signedUrl) continue
      cache.set(cacheKey(bucket, item.path), {
        url: item.signedUrl,
        expiresAt: now + expiresIn * 1000,
      })
      result[item.path] = item.signedUrl
    }
    // Ruta que no se pudo (re)firmar: si había una URL previa, se conserva
    // (aunque esté cerca de caducar) en vez de dejar el contenido roto.
    for (const path of stale) {
      if (result[path]) continue
      const previous = cache.get(cacheKey(bucket, path))
      if (previous) result[path] = previous.url
    }
  }

  return result
}

/** Solo para tests: vacía la caché entre casos. */
export function __clearSignedUrlCacheForTests() {
  cache.clear()
}
