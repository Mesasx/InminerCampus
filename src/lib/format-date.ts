const MONTHS = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
]

/**
 * «2026-10-08» → «8 de octubre de 2026». Se formatea a mano, sin
 * `Intl`/zona horaria, para que el servidor y el navegador produzcan el mismo
 * texto y no haya desajustes de hidratación.
 */
export function formatReviewDate(isoDate: string): string {
  const [year, month, day] = isoDate.split('-').map(Number)
  if (!year || !month || !day) return isoDate
  return `${day} de ${MONTHS[month - 1]} de ${year}`
}
