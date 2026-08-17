export function ProgressBar({
  percent,
  label,
}: {
  percent: number
  label?: string
}) {
  const clamped = Math.max(0, Math.min(100, Math.round(percent)))

  return (
    <div className="progress-bar">
      {label ? (
        <span className="progress-bar__label">
          <span>{label}</span>
          <span>{clamped}%</span>
        </span>
      ) : null}
      <div className="progress" aria-label={`${clamped}% completado`}>
        <div className="progress__bar" style={{ width: `${clamped}%` }} />
      </div>
    </div>
  )
}
