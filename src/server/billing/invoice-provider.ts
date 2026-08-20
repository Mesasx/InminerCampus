export type IssuedInvoice = {
  officialInvoiceNumber: string
  issuedAt: string
  providerReference: string
}

export type InvoiceProviderResult<T> =
  | { status: 'ok'; value: T }
  | { status: 'not_configured'; reason: string }

export interface InvoiceProvider {
  issueInvoice(invoiceId: string): Promise<InvoiceProviderResult<IssuedInvoice>>
  getInvoice(invoiceId: string): Promise<InvoiceProviderResult<IssuedInvoice>>
  getInvoicePdf(invoiceId: string): Promise<InvoiceProviderResult<Uint8Array>>
}
