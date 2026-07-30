export type BillingCsvRow = {
  order_number: string
  paid_at: string | null
  invoice_status: string
  invoice_number: string | null
  billing_name: string
  billing_tax_id: string
  billing_email: string
  invoice_email: string
  subtotal_net_cents: number
  tax_amount_cents: number
  total_amount_cents: number
  currency: string
  stripe_payment_intent_id: string | null
  purchase_items: Array<{
    course_title_snapshot: string
    course_version_snapshot: number
    quantity: number
  }>
}

export function createBillingCsv(rows: BillingCsvRow[]): string {
  const header = [
    'Pedido',
    'Fecha de pago',
    'Estado de factura',
    'Número de factura',
    'Cliente',
    'NIF/CIF',
    'Correo de facturación',
    'Correo de factura',
    'Curso',
    'Versión',
    'Plazas',
    'Base imponible',
    'IVA',
    'Total',
    'Moneda',
    'PaymentIntent',
  ]
  const body = rows.map((row) => {
    const item = row.purchase_items[0]
    return [
      row.order_number,
      row.paid_at ?? '',
      row.invoice_status,
      row.invoice_number ?? '',
      row.billing_name,
      row.billing_tax_id,
      row.billing_email,
      row.invoice_email,
      item?.course_title_snapshot ?? '',
      item?.course_version_snapshot ?? '',
      item?.quantity ?? '',
      centsForCsv(row.subtotal_net_cents),
      centsForCsv(row.tax_amount_cents),
      centsForCsv(row.total_amount_cents),
      row.currency,
      row.stripe_payment_intent_id ?? '',
    ]
  })
  return `\uFEFF${[header, ...body]
    .map((record) => record.map(csvCell).join(';'))
    .join('\r\n')}`
}

function centsForCsv(cents: number): string {
  return (cents / 100).toFixed(2).replace('.', ',')
}

export function csvCell(value: string | number): string {
  let text = String(value)
  if (/^[=+\-@]/.test(text)) text = `'${text}`
  return `"${text.replaceAll('"', '""')}"`
}
