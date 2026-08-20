import {
  PDFDocument,
  StandardFonts,
  rgb,
  type PDFFont,
  type PDFPage,
} from 'pdf-lib'
import { formatCents } from '../../lib/billing.ts'

const PAGE_WIDTH = 595.28
const PAGE_HEIGHT = 841.89
const MARGIN = 48
const INMINER_ORANGE = rgb(0.91, 0.38, 0.08)
const INK = rgb(0.12, 0.15, 0.18)
const MUTED = rgb(0.42, 0.46, 0.5)
const LINE = rgb(0.86, 0.87, 0.88)

export type InvoicePdfData = {
  invoiceNumber: string
  issuedAt: string
  orderNumber: string
  customerName: string
  customerTaxId: string
  customerEmail: string
  addressLine1: string
  postalCode: string
  city: string
  province: string
  countryCode: string
  subtotalCents: number
  taxCents: number
  totalCents: number
  currency: string
  items: Array<{
    description: string
    quantity: number
    unitNetCents: number
    lineNetCents: number
    taxRateBasisPoints: number
    lineTotalCents: number
  }>
}

export async function createInvoicePdf(
  data: InvoicePdfData,
  logoBytes?: Uint8Array,
): Promise<Uint8Array> {
  if (!data.invoiceNumber.trim()) {
    throw new Error('An official invoice number is required')
  }
  if (!data.items.length) throw new Error('At least one invoice item is required')

  const document = await PDFDocument.create()
  const [regular, bold] = await Promise.all([
    document.embedFont(StandardFonts.Helvetica),
    document.embedFont(StandardFonts.HelveticaBold),
  ])
  const logo = logoBytes
    ? await embedLogo(document, logoBytes).catch(() => null)
    : null

  const pages = chunk(data.items, 6)
  pages.forEach((items, pageIndex) => {
    const page = document.addPage([PAGE_WIDTH, PAGE_HEIGHT])
    drawHeader(page, regular, bold, data, logo)
    drawCustomer(page, regular, bold, data)
    drawItems(page, regular, bold, data, items, pageIndex > 0)
    if (pageIndex === pages.length - 1) {
      drawTotals(page, regular, bold, data)
    }
    drawFooter(page, regular, data, pageIndex + 1, pages.length)
  })

  document.setTitle(`Factura ${data.invoiceNumber} · InmínerCampus`)
  document.setAuthor('INMÍNER Ingeniería, S.L.')
  document.setSubject(`Factura del pedido ${data.orderNumber}`)
  document.setCreationDate(new Date(data.issuedAt))
  return document.save({ useObjectStreams: false })
}

async function embedLogo(document: PDFDocument, bytes: Uint8Array) {
  const signature = String.fromCharCode(...bytes.slice(0, 4))
  return signature.startsWith('\x89PNG')
    ? document.embedPng(bytes)
    : document.embedJpg(bytes)
}

function drawHeader(
  page: PDFPage,
  regular: PDFFont,
  bold: PDFFont,
  data: InvoicePdfData,
  logo: Awaited<ReturnType<typeof embedLogo>> | null,
) {
  page.drawRectangle({
    x: 0,
    y: PAGE_HEIGHT - 12,
    width: PAGE_WIDTH,
    height: 12,
    color: INMINER_ORANGE,
  })
  if (logo) {
    const scaled = logo.scaleToFit(128, 44)
    page.drawImage(logo, {
      x: MARGIN,
      y: PAGE_HEIGHT - 80,
      width: scaled.width,
      height: scaled.height,
    })
  } else {
    page.drawText('INMÍNER', {
      x: MARGIN,
      y: PAGE_HEIGHT - 68,
      size: 23,
      font: bold,
      color: INK,
    })
  }
  page.drawText('InmínerCampus', {
    x: MARGIN,
    y: PAGE_HEIGHT - 91,
    size: 9,
    font: regular,
    color: MUTED,
  })

  drawRight(page, bold, 'FACTURA', PAGE_WIDTH - MARGIN, PAGE_HEIGHT - 57, 22)
  drawRight(
    page,
    regular,
    data.invoiceNumber,
    PAGE_WIDTH - MARGIN,
    PAGE_HEIGHT - 78,
    10,
  )
  drawRight(
    page,
    regular,
    formatDate(data.issuedAt),
    PAGE_WIDTH - MARGIN,
    PAGE_HEIGHT - 94,
    9,
    MUTED,
  )

  page.drawLine({
    start: { x: MARGIN, y: PAGE_HEIGHT - 112 },
    end: { x: PAGE_WIDTH - MARGIN, y: PAGE_HEIGHT - 112 },
    thickness: 0.8,
    color: LINE,
  })
}

function drawCustomer(
  page: PDFPage,
  regular: PDFFont,
  bold: PDFFont,
  data: InvoicePdfData,
) {
  const top = PAGE_HEIGHT - 140
  page.drawText('EMISOR', { x: MARGIN, y: top, size: 8, font: bold, color: MUTED })
  const issuer = [
    'INMÍNER Ingeniería, S.L.',
    'B-13476148',
    'C/ Aragón, 29 · 13004 Ciudad Real · España',
    'ingenieria@inminer.es · www.inminer.es',
  ]
  issuer.forEach((line, index) =>
    page.drawText(line, {
      x: MARGIN,
      y: top - 18 - index * 14,
      size: index === 0 ? 9.5 : 8.4,
      font: index === 0 ? bold : regular,
      color: INK,
    }),
  )

  const customerX = 320
  page.drawText('DATOS DEL CLIENTE', {
    x: customerX,
    y: top,
    size: 8,
    font: bold,
    color: MUTED,
  })
  const customer = [
    data.customerName,
    data.customerTaxId,
    data.addressLine1,
    `${data.postalCode} ${data.city}`,
    `${data.province} · ${data.countryCode}`,
    data.customerEmail,
  ]
  customer.forEach((line, index) =>
    page.drawText(fitText(regular, line, 225, index === 0 ? 9.5 : 8.4), {
      x: customerX,
      y: top - 18 - index * 14,
      size: index === 0 ? 9.5 : 8.4,
      font: index === 0 ? bold : regular,
      color: INK,
    }),
  )
}

function drawItems(
  page: PDFPage,
  regular: PDFFont,
  bold: PDFFont,
  data: InvoicePdfData,
  items: InvoicePdfData['items'],
  continued: boolean,
) {
  const tableTop = PAGE_HEIGHT - 268
  if (continued) {
    page.drawText('Continuación', {
      x: MARGIN,
      y: tableTop + 24,
      size: 8,
      font: regular,
      color: MUTED,
    })
  }
  page.drawRectangle({
    x: MARGIN,
    y: tableTop - 25,
    width: PAGE_WIDTH - MARGIN * 2,
    height: 25,
    color: rgb(0.96, 0.965, 0.97),
  })
  const columns = [
    { label: 'CONCEPTO', x: MARGIN + 8 },
    { label: 'CANT.', x: 315 },
    { label: 'P. UNIT.', x: 355 },
    { label: 'BASE', x: 416 },
    { label: 'IVA', x: 474 },
    { label: 'TOTAL', x: 512 },
  ]
  columns.forEach((column) =>
    page.drawText(column.label, {
      x: column.x,
      y: tableTop - 16,
      size: 7.2,
      font: bold,
      color: MUTED,
    }),
  )

  items.forEach((item, index) => {
    const rowTop = tableTop - 25 - index * 49
    page.drawLine({
      start: { x: MARGIN, y: rowTop - 49 },
      end: { x: PAGE_WIDTH - MARGIN, y: rowTop - 49 },
      thickness: 0.6,
      color: LINE,
    })
    const descriptionLines = wrapText(regular, item.description, 247, 8.2).slice(
      0,
      2,
    )
    descriptionLines.forEach((line, lineIndex) =>
      page.drawText(line, {
        x: MARGIN + 8,
        y: rowTop - 18 - lineIndex * 12,
        size: 8.2,
        font: regular,
        color: INK,
      }),
    )
    drawRight(page, regular, String(item.quantity), 340, rowTop - 18, 8.2)
    drawRight(
      page,
      regular,
      formatCents(item.unitNetCents, data.currency),
      409,
      rowTop - 18,
      8.2,
    )
    drawRight(
      page,
      regular,
      formatCents(item.lineNetCents, data.currency),
      468,
      rowTop - 18,
      8.2,
    )
    drawRight(
      page,
      regular,
      `${item.taxRateBasisPoints / 100}%`,
      510,
      rowTop - 18,
      8.2,
    )
    drawRight(
      page,
      regular,
      formatCents(item.lineTotalCents, data.currency),
      PAGE_WIDTH - MARGIN - 7,
      rowTop - 18,
      8.2,
    )
  })
}

function drawTotals(
  page: PDFPage,
  regular: PDFFont,
  bold: PDFFont,
  data: InvoicePdfData,
) {
  const y = 235
  const labelX = 375
  const valueX = PAGE_WIDTH - MARGIN
  page.drawText('Base imponible', { x: labelX, y, size: 9, font: regular, color: INK })
  drawRight(page, regular, formatCents(data.subtotalCents, data.currency), valueX, y, 9)
  page.drawText('IVA', { x: labelX, y: y - 24, size: 9, font: regular, color: INK })
  drawRight(page, regular, formatCents(data.taxCents, data.currency), valueX, y - 24, 9)
  page.drawRectangle({ x: labelX - 10, y: y - 64, width: 182, height: 30, color: INK })
  page.drawText('TOTAL', { x: labelX, y: y - 54, size: 10, font: bold, color: rgb(1, 1, 1) })
  drawRight(
    page,
    bold,
    formatCents(data.totalCents, data.currency),
    valueX - 7,
    y - 54,
    11,
    rgb(1, 1, 1),
  )

  page.drawText('Forma de pago', { x: MARGIN, y, size: 8, font: bold, color: MUTED })
  page.drawText('Pago electrónico mediante Stripe', {
    x: MARGIN,
    y: y - 17,
    size: 9,
    font: regular,
    color: INK,
  })
  page.drawText('Estado', { x: MARGIN, y: y - 43, size: 8, font: bold, color: MUTED })
  page.drawText('PAGADO', { x: MARGIN, y: y - 60, size: 9.5, font: bold, color: INMINER_ORANGE })
  page.drawText('Referencia del pedido', {
    x: MARGIN,
    y: y - 86,
    size: 8,
    font: bold,
    color: MUTED,
  })
  page.drawText(data.orderNumber, { x: MARGIN, y: y - 103, size: 9, font: regular, color: INK })
}

function drawFooter(
  page: PDFPage,
  regular: PDFFont,
  data: InvoicePdfData,
  pageNumber: number,
  pageCount: number,
) {
  page.drawLine({
    start: { x: MARGIN, y: 75 },
    end: { x: PAGE_WIDTH - MARGIN, y: 75 },
    thickness: 0.6,
    color: LINE,
  })
  page.drawText(
    'INMÍNER Ingeniería, S.L. · Hoja CR-18847 · Tomo 476 · Folio 92 · Inscripción 1ª',
    { x: MARGIN, y: 57, size: 7.2, font: regular, color: MUTED },
  )
  drawRight(
    page,
    regular,
    `${data.invoiceNumber} · ${pageNumber}/${pageCount}`,
    PAGE_WIDTH - MARGIN,
    57,
    7.2,
    MUTED,
  )
  page.drawText(
    'Protección de datos: información adicional disponible en www.inminer.es.',
    { x: MARGIN, y: 42, size: 6.8, font: regular, color: MUTED },
  )
}

function drawRight(
  page: PDFPage,
  font: PDFFont,
  value: string,
  right: number,
  y: number,
  size: number,
  color = INK,
) {
  page.drawText(value, {
    x: right - font.widthOfTextAtSize(value, size),
    y,
    size,
    font,
    color,
  })
}

function formatDate(value: string): string {
  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    timeZone: 'Europe/Madrid',
  }).format(new Date(value))
}

function fitText(font: PDFFont, value: string, width: number, size: number) {
  if (font.widthOfTextAtSize(value, size) <= width) return value
  let candidate = value
  while (candidate.length > 1 && font.widthOfTextAtSize(`${candidate}…`, size) > width) {
    candidate = candidate.slice(0, -1)
  }
  return `${candidate}…`
}

function wrapText(font: PDFFont, value: string, width: number, size: number) {
  const lines: string[] = []
  let current = ''
  for (const word of value.trim().split(/\s+/)) {
    const candidate = current ? `${current} ${word}` : word
    if (!current || font.widthOfTextAtSize(candidate, size) <= width) {
      current = candidate
    } else {
      lines.push(current)
      current = word
    }
  }
  if (current) lines.push(current)
  return lines
}

function chunk<T>(values: T[], size: number): T[][] {
  const result: T[][] = []
  for (let index = 0; index < values.length; index += size) {
    result.push(values.slice(index, index + size))
  }
  return result
}
