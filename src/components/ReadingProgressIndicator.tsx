import { CheckCircle2 } from 'lucide-react'

// Indicador de lectura. Aparece anclado abajo mientras el alumno recorre la
// explicación y desaparece en cuanto llega al final, de modo que no compite con
// la navegación ni tapa el reproductor: cuando el botón «Siguiente» entra en
// pantalla, la lectura ya está dada por completada.

export function ReadingProgressIndicator({
  percent,
  completed,
  visible,
  audioPending,
}: {
  percent: number
  completed: boolean
  visible: boolean
  audioPending: boolean
}) {
  if (completed || !visible) return null

  const remaining = Math.max(0, 100 - percent)

  return (
    <div className="reading-progress" role="status">
      <div className="reading-progress__panel">
        <div className="reading-progress__copy">
          <strong>Lectura de la explicación</strong>
          <span>
            {remaining > 0
              ? `Continúa leyendo para desbloquear la siguiente diapositiva. Te queda aproximadamente un ${remaining} %.`
              : 'Continúa leyendo para desbloquear la siguiente diapositiva.'}
            {audioPending ? ' También queda audio por escuchar.' : ''}
          </span>
        </div>
        <div
          aria-label={`Lectura de la explicación: ${percent} % recorrido`}
          aria-valuemax={100}
          aria-valuemin={0}
          aria-valuenow={percent}
          className="reading-progress__track"
          role="progressbar"
        >
          <span style={{ width: `${percent}%` }} />
        </div>
        <span className="reading-progress__value">{percent} %</span>
      </div>
    </div>
  )
}

export function ReadingProgressBadge({ completed }: { completed: boolean }) {
  if (!completed) return null
  return (
    <p className="reading-progress__done">
      <CheckCircle2 aria-hidden="true" size={16} /> Explicación completada
    </p>
  )
}
