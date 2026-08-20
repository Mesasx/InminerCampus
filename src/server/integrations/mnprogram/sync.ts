import { MnProgramClient } from './client.ts'

export type MnProgramSaleSnapshot = {
  purchaseId: string
  orderNumber: string
  purchaseKind: string
  customerName: string
  customerTaxId: string
  customerEmail: string
  totalAmountCents: number
  subtotalCents: number
  taxCents: number
  currency: string
  paidAt: string
  stripePaymentIntentId: string | null
  stripeCheckoutSessionId: string | null
  stripeCustomerId: string | null
  invoiceNumber: string
  invoiceStatus: string
  items: Array<{
    courseTitle: string
    courseCode: string | null
    courseVersion: number
    modality: string
    quantity: number
  }>
}

export async function syncSaleToMnProgram(
  sale: MnProgramSaleSnapshot,
): Promise<{ reference: string | null }> {
  const client = MnProgramClient.fromEnvironment()
  return client.contratosCliente(toMnProgramContract(sale))
}

export function toMnProgramContract(sale: MnProgramSaleSnapshot) {
  const firstItem = sale.items[0]
  const customTab =
    process.env.MNPROGRAM_CUSTOM_TAB?.trim() || 'InmínerCampus'
  const expedientTitle =
    process.env.MNPROGRAM_EXPEDIENT_TITLE?.trim() || 'INMINERCAMPUS'
  const expedientType =
    process.env.MNPROGRAM_EXPEDIENT_TYPE?.trim() || 'Formación'

  return {
    customerName: sale.customerName,
    customerTaxId: sale.customerTaxId,
    totalAmount: sale.totalAmountCents / 100,
    nature: `Venta InmínerCampus - ${sale.orderNumber}`,
    expedientTitle,
    expedientType,
    customTab,
    customFields: {
      'Número pedido': sale.orderNumber,
      'Purchase ID': sale.purchaseId,
      Curso: firstItem?.courseTitle ?? '',
      'Código curso': firstItem?.courseCode ?? '',
      Versión: firstItem?.courseVersion ?? '',
      'Tipo compra': sale.purchaseKind,
      'Número plazas': sale.items.reduce(
        (total, item) => total + item.quantity,
        0,
      ),
      'Base imponible': sale.subtotalCents / 100,
      IVA: sale.taxCents / 100,
      Total: sale.totalAmountCents / 100,
      'Fecha pago': sale.paidAt,
      'Stripe Payment ID': sale.stripePaymentIntentId ?? '',
      'Stripe Checkout ID': sale.stripeCheckoutSessionId ?? '',
      'Stripe Customer ID': sale.stripeCustomerId ?? '',
      'Estado pago': 'PAGADO',
      'Razón social': sale.customerName,
      'NIF/CIF': sale.customerTaxId,
      Email: sale.customerEmail,
      Factura: sale.invoiceNumber,
      'Estado factura': sale.invoiceStatus,
    },
  }
}
