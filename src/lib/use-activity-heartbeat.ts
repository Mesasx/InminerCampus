import { useEffect } from 'react'
import { getSupabaseBrowserClient } from './supabase'

const TICK_MS = 5_000
const FLUSH_EVERY_TICKS = 4 // ~20s entre escrituras a Supabase
const MAX_GAP_SECONDS = (TICK_MS / 1000) * 2

/**
 * Acumula el tiempo que el usuario pasa realmente con la pestaña visible y
 * lo sincroniza a intervalos con `record_stvh_activity_heartbeat`. Descarta
 * huecos de tiempo anómalos (pestaña en segundo plano, suspensión del
 * equipo, conexión perdida) en lugar de contarlos como actividad.
 */
export function useStvhActivityHeartbeat(enrollmentId: string, enabled: boolean) {
  useEffect(() => {
    if (!enabled) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    const sessionId = crypto.randomUUID()
    let pendingSeconds = 0
    let ticksSinceFlush = 0
    let lastTick = Date.now()
    let disposed = false

    function flush() {
      if (pendingSeconds <= 0 || disposed) return
      const delta = pendingSeconds
      pendingSeconds = 0
      void supabase!.rpc('record_stvh_activity_heartbeat', {
        p_enrollment_id: enrollmentId,
        p_session_id: sessionId,
        p_delta_seconds: delta,
      })
    }

    const interval = window.setInterval(() => {
      const now = Date.now()
      const elapsedSeconds = (now - lastTick) / 1000
      lastTick = now
      if (
        document.visibilityState === 'visible' &&
        elapsedSeconds > 0 &&
        elapsedSeconds <= MAX_GAP_SECONDS
      ) {
        pendingSeconds += elapsedSeconds
      }
      ticksSinceFlush += 1
      if (ticksSinceFlush >= FLUSH_EVERY_TICKS) {
        ticksSinceFlush = 0
        flush()
      }
    }, TICK_MS)

    function handleVisibilityChange() {
      lastTick = Date.now()
      if (document.visibilityState === 'hidden') flush()
    }
    function handleBeforeUnload() {
      flush()
    }

    document.addEventListener('visibilitychange', handleVisibilityChange)
    window.addEventListener('beforeunload', handleBeforeUnload)

    return () => {
      disposed = true
      window.clearInterval(interval)
      document.removeEventListener('visibilitychange', handleVisibilityChange)
      window.removeEventListener('beforeunload', handleBeforeUnload)
      flush()
    }
  }, [enrollmentId, enabled])
}
