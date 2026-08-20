import type {
  InvoiceProvider,
  InvoiceProviderResult,
  IssuedInvoice,
} from '../../billing/invoice-provider'

const REASON =
  'NOT_CONFIGURED: the private MNprogram invoice issue/PDF operations are not present in the public documentation or repository WSDL'

export class MnProgramInvoiceProvider implements InvoiceProvider {
  async issueInvoice(
    _invoiceId: string,
  ): Promise<InvoiceProviderResult<IssuedInvoice>> {
    return { status: 'not_configured', reason: REASON }
  }

  async getInvoice(
    _invoiceId: string,
  ): Promise<InvoiceProviderResult<IssuedInvoice>> {
    return { status: 'not_configured', reason: REASON }
  }

  async getInvoicePdf(
    _invoiceId: string,
  ): Promise<InvoiceProviderResult<Uint8Array>> {
    return { status: 'not_configured', reason: REASON }
  }
}
