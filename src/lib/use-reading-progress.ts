import { useCallback, useEffect, useRef, useState } from 'react'

// Progreso de lectura de la explicación detallada.
//
// No mide si el alumno lee: mide si ha recorrido la explicación hasta el final,
// que es la condición acordada. Dos observadores y ningún listener permanente:
//
//   · un IntersectionObserver sobre el contenedor decide si merece la pena
//     calcular el porcentaje, de modo que fuera de pantalla no se calcula nada;
//   · un segundo observador vigila un centinela colocado al final del texto y
//     es quien da la lectura por terminada;
//   · el porcentaje se recalcula en un listener de scroll pasivo que sólo está
//     suscrito mientras la explicación está a la vista, y que además se agrupa
//     con requestAnimationFrame para no provocar un render por evento.
//
// Si la explicación entra entera en el viewport no hay nada que recorrer y el
// requisito se da por cumplido en el primer cálculo.

export type ReadingProgress = {
  percent: number
  completed: boolean
  containerRef: (node: HTMLElement | null) => void
  sentinelRef: (node: HTMLElement | null) => void
}

export function useReadingProgress({
  contentKey,
  enabled = true,
  initiallyCompleted = false,
  onCompleted,
}: {
  // Cambia con la unidad: reinicia la medición al pasar de diapositiva.
  contentKey: string
  enabled?: boolean
  initiallyCompleted?: boolean
  onCompleted?: () => void
}): ReadingProgress {
  const [percent, setPercent] = useState(initiallyCompleted ? 100 : 0)
  const [completed, setCompleted] = useState(initiallyCompleted)
  const [container, setContainer] = useState<HTMLElement | null>(null)
  const [sentinel, setSentinel] = useState<HTMLElement | null>(null)
  const completedRef = useRef(initiallyCompleted)
  const onCompletedRef = useRef(onCompleted)

  onCompletedRef.current = onCompleted

  useEffect(() => {
    completedRef.current = initiallyCompleted
    setCompleted(initiallyCompleted)
    setPercent(initiallyCompleted ? 100 : 0)
  }, [contentKey, initiallyCompleted])

  const markCompleted = useCallback(() => {
    if (completedRef.current) return
    completedRef.current = true
    setCompleted(true)
    setPercent(100)
    onCompletedRef.current?.()
  }, [])

  // Porcentaje recorrido: cuánto del contenedor ha pasado ya por encima del
  // borde inferior de la ventana.
  useEffect(() => {
    if (!enabled || !container) return
    if (typeof window === 'undefined') return

    let frame = 0
    let visible = false

    const measure = () => {
      frame = 0
      const rect = container.getBoundingClientRect()
      const viewport = window.innerHeight || 0
      if (rect.height <= 0) return

      const seen = viewport - rect.top
      const next = Math.round(
        Math.min(100, Math.max(0, (seen / rect.height) * 100)),
      )
      setPercent((current) =>
        completedRef.current ? 100 : Math.max(current, next),
      )

      // Explicación corta: cabe entera y no hay recorrido que exigir.
      if (rect.top >= 0 && rect.bottom <= viewport) markCompleted()
    }

    const schedule = () => {
      if (frame) return
      frame = window.requestAnimationFrame(measure)
    }

    const visibility = new IntersectionObserver(
      (entries) => {
        const entry = entries[0]
        if (!entry) return
        if (entry.isIntersecting === visible) return
        visible = entry.isIntersecting
        if (visible) {
          window.addEventListener('scroll', schedule, { passive: true })
          window.addEventListener('resize', schedule, { passive: true })
          schedule()
        } else {
          window.removeEventListener('scroll', schedule)
          window.removeEventListener('resize', schedule)
        }
      },
      { threshold: 0 },
    )
    visibility.observe(container)
    schedule()

    return () => {
      visibility.disconnect()
      window.removeEventListener('scroll', schedule)
      window.removeEventListener('resize', schedule)
      if (frame) window.cancelAnimationFrame(frame)
    }
  }, [container, enabled, markCompleted])

  // Centinela final: entrar en el viewport es la condición fiable de que se ha
  // llegado hasta el final del contenido.
  useEffect(() => {
    if (!enabled || !sentinel) return
    if (typeof window === 'undefined') return

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries.some((entry) => entry.isIntersecting)) markCompleted()
      },
      { threshold: 0 },
    )
    observer.observe(sentinel)
    return () => observer.disconnect()
  }, [enabled, markCompleted, sentinel])

  return {
    percent: completed ? 100 : percent,
    completed,
    containerRef: setContainer,
    sentinelRef: setSentinel,
  }
}
