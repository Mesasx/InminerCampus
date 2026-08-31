import { useEffect } from 'react'
import { getSupabaseBrowserClient } from './supabase'

const TICK_MS = 5_000
const FLUSH_EVERY_TICKS = 4 // ~20s entre escrituras a Supabase
const MAX_GAP_SECONDS = (TICK_MS / 1000) * 2
// Tope que aplica `record_learning_activity_heartbeat` a cada delta.
const MAX_DELTA_SECONDS = 30

/**
 * Acumula el tiempo que el usuario pasa realmente con la pestaña visible y
 * lo sincroniza a intervalos con `record_learning_activity_heartbeat`. Descarta
 * huecos de tiempo anómalos (pestaña en segundo plano, suspensión del
 * equipo, conexión perdida) en lugar de contarlos como actividad.
 */
export function useLearningActivityHeartbeat(
  enrollmentId: string,
  enabled: boolean,
) {
  useEffect(() => {
    if (!enabled) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    const sessionId = crypto.randomUUID()
    let pendingSeconds = 0
    let ticksSinceFlush = 0
    let lastTick = Date.now()
    let disposed = false

    let flushing = false

    async function flush() {
      if (pendingSeconds <= 0 || disposed || flushing) return
      // El RPC descarta cualquier delta por encima de MAX_DELTA_SECONDS, así
      // que enviamos como mucho ese tramo y dejamos el resto pendiente.
      const delta = Math.min(Math.floor(pendingSeconds), MAX_DELTA_SECONDS)
      if (delta <= 0) return
      flushing = true
      pendingSeconds -= delta
      try {
        const { error } = await supabase!.rpc(
          'record_learning_activity_heartbeat',
          {
            p_enrollment_id: enrollmentId,
            p_session_id: sessionId,
            p_delta_seconds: delta,
          },
        )
        if (error) throw error
      } catch (error) {
        // Devolvemos los segundos a la cola para no perder tiempo de estudio
        // por un fallo puntual de red, y dejamos rastro: hasta ahora este
        // error se descartaba en silencio y el tiempo se perdía sin aviso.
        pendingSeconds += delta
        console.error(
          '[heartbeat] no se pudo registrar la actividad de aprendizaje',
          { enrollmentId, delta, error },
        )
      } finally {
        flushing = false
      }
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
        void flush()
      }
    }, TICK_MS)

    function handleVisibilityChange() {
      lastTick = Date.now()
      if (document.visibilityState === 'hidden') void flush()
    }
    function handleBeforeUnload() {
      void flush()
    }

    document.addEventListener('visibilitychange', handleVisibilityChange)
    window.addEventListener('beforeunload', handleBeforeUnload)
    // En móvil `beforeunload` a menudo no llega; `pagehide` sí.
    window.addEventListener('pagehide', handleBeforeUnload)

    return () => {
      window.clearInterval(interval)
      document.removeEventListener('visibilitychange', handleVisibilityChange)
      window.removeEventListener('beforeunload', handleBeforeUnload)
      window.removeEventListener('pagehide', handleBeforeUnload)
      void flush()
      disposed = true
    }
  }, [enrollmentId, enabled])
}

// Alias temporal para no romper imports de bundles o ramas anteriores.
export const useStvhActivityHeartbeat = useLearningActivityHeartbeat
