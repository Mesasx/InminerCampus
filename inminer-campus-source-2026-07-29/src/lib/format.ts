export function formatCurrency(
  amount: number | null,
  currency = 'EUR',
): string {
  if (amount === null) return 'Consultar'
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency,
  }).format(amount)
}

export function modalityLabel(modality: string): string {
  const labels: Record<string, string> = {
    online: 'Online',
    in_person: 'Presencial',
    hybrid: 'Híbrido',
  }
  return labels[modality] ?? modality
}
