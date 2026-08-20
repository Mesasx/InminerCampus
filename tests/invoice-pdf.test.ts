import assert from 'node:assert/strict'
import test from 'node:test'
import { createHash } from 'node:crypto'
import { PDFDocument } from 'pdf-lib'
import { createInvoicePdf } from '../src/server/billing/invoice-pdf.ts'

const invoice = {
  invoiceNumber: 'MN-2026-0042',
  issuedAt: '2026-08-20T10:15:00.000Z',
  orderNumber: 'CAMPUS-2026-000042',
  customerName: 'Áridos Peña, S.L.',
  customerTaxId: 'B13476148',
  customerEmail: 'facturacion@example.com',
  addressLine1: 'Calle Aragón, 29',
  postalCode: '13004',
  city: 'Ciudad Real',
  province: 'Ciudad Real',
  countryCode: 'ES',
  subtotalCents: 14_900,
  taxCents: 3_129,
  totalCents: 18_029,
  currency: 'EUR',
  items: [
    {
      description: 'Curso de minería y prevención · Versión 2',
      quantity: 1,
      unitNetCents: 14_900,
      lineNetCents: 14_900,
      taxRateBasisPoints: 2_100,
      lineTotalCents: 18_029,
    },
  ],
}

test('genera una factura PDF válida con los importes fiscales inmutables', async () => {
  const bytes = await createInvoicePdf(invoice)
  const document = await PDFDocument.load(bytes)

  assert.equal(Buffer.from(bytes.slice(0, 5)).toString(), '%PDF-')
  assert.equal(document.getPageCount(), 1)
  assert.equal(document.getTitle(), 'Factura MN-2026-0042 · InmínerCampus')
  assert.match(createHash('sha256').update(bytes).digest('hex'), /^[a-f0-9]{64}$/)
})

test('no genera un documento fiscal sin numeración oficial', async () => {
  await assert.rejects(
    () => createInvoicePdf({ ...invoice, invoiceNumber: ' ' }),
    /official invoice number/i,
  )
})
