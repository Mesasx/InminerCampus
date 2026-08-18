import { PDFDocument, StandardFonts, rgb, type PDFFont, type RGB } from 'pdf-lib'

// Coordenadas (en puntos PDF, página A4 apaisada 841.89 x 595.28) calculadas
// a partir de la posición real de cada placeholder rasterizado en
// public/certificates/stvh-certificado-base.pdf. Si el diseño base cambia,
// estas coordenadas deben recalcularse.
type FieldBox = {
  rectX: number
  rectY: number
  rectWidth: number
  rectHeight: number
  textX: number
  textY: number
  maxWidth: number
}

const NOMBRE: FieldBox = {
  rectX: 227,
  rectY: 179.4,
  rectWidth: 168,
  rectHeight: 13,
  textX: 231,
  textY: 182.7,
  maxWidth: 160,
}
const HORAS_TOTALES: FieldBox = {
  rectX: 642,
  rectY: 179.4,
  rectWidth: 148,
  rectHeight: 13,
  textX: 645,
  textY: 182.7,
  maxWidth: 140,
}
const DNI: FieldBox = {
  rectX: 227,
  rectY: 156.3,
  rectWidth: 168,
  rectHeight: 14.2,
  textX: 231,
  textY: 159.6,
  maxWidth: 160,
}
const FECHA_EMISION: FieldBox = {
  rectX: 642,
  rectY: 156.3,
  rectWidth: 148,
  rectHeight: 14.2,
  textX: 645,
  textY: 159.6,
  maxWidth: 140,
}
const FECHA_HORA_INICIO: FieldBox = {
  rectX: 227,
  rectY: 133.7,
  rectWidth: 168,
  rectHeight: 13,
  textX: 231,
  textY: 137.0,
  maxWidth: 160,
}
const CODIGO_CERTIFICADO: FieldBox = {
  rectX: 642,
  rectY: 133.7,
  rectWidth: 148,
  rectHeight: 13,
  textX: 645,
  textY: 137.0,
  maxWidth: 140,
}
const FECHA_HORA_FIN: FieldBox = {
  rectX: 227,
  rectY: 110.6,
  rectWidth: 168,
  rectHeight: 13,
  textX: 231,
  textY: 113.9,
  maxWidth: 160,
}
// Los mismos placeholders también aparecen citados dentro del párrafo
// narrativo ("Se certifica que [NOMBRE Y APELLIDOS], con DNI [DNI], ha
// completado..."), incrustados en texto corrido. Deben cubrirse y
// reescribirse igual que los del bloque de datos, sin invadir el texto
// fijo adyacente.
const NOMBRE_PARRAFO: FieldBox = {
  rectX: 248.6,
  rectY: 380.9,
  rectWidth: 150.6,
  rectHeight: 14.7,
  textX: 251,
  textY: 384.4,
  maxWidth: 146,
}
const DNI_PARRAFO: FieldBox = {
  rectX: 450.6,
  rectY: 380.9,
  rectWidth: 34.4,
  rectHeight: 14.7,
  textX: 455,
  textY: 384.4,
  maxWidth: 30,
}

const BLUE: RGB = rgb(0.086, 0.349, 0.643)
const ORANGE: RGB = rgb(0.94, 0.33, 0.06)
const BASE_FONT_SIZE = 10.5
const MIN_FONT_SIZE = 7.5
const MIN_FONT_SIZE_TIGHT = 5

export type StvhCertificateData = {
  certificateCode: string
  holderName: string
  holderDni: string | null
  startedAt: string
  completedAt: string
  activeSeconds: number
  issuedAt: string
}

function formatDateTime(iso: string) {
  const date = new Date(iso)
  const day = String(date.getDate()).padStart(2, '0')
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const year = date.getFullYear()
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return {
    date: `${day}/${month}/${year}`,
    time: `${hours}:${minutes}`,
  }
}

function formatDateOnly(iso: string) {
  return formatDateTime(iso).date
}

export function formatActiveDuration(totalSeconds: number) {
  const seconds = Math.max(0, Math.round(totalSeconds))
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  if (hours <= 0) return `${minutes} min`
  if (minutes <= 0) return `${hours} h`
  return `${hours} h ${minutes} min`
}

function fitFontSize(
  font: PDFFont,
  text: string,
  maxWidth: number,
  minSize: number = MIN_FONT_SIZE,
) {
  let size = BASE_FONT_SIZE
  while (size > minSize && font.widthOfTextAtSize(text, size) > maxWidth) {
    size -= 0.5
  }
  return size
}

function drawField(
  page: import('pdf-lib').PDFPage,
  font: PDFFont,
  box: FieldBox,
  text: string,
  color: RGB = BLUE,
  minFontSize: number = MIN_FONT_SIZE,
) {
  page.drawRectangle({
    x: box.rectX,
    y: box.rectY,
    width: box.rectWidth,
    height: box.rectHeight,
    color: rgb(1, 1, 1),
  })
  const size = fitFontSize(font, text, box.maxWidth, minFontSize)
  page.drawText(text, {
    x: box.textX,
    y: box.textY,
    size,
    font,
    color,
  })
}

export async function createStvhCertificatePdf(
  baseTemplateBytes: Uint8Array,
  data: StvhCertificateData,
): Promise<Uint8Array> {
  const document = await PDFDocument.load(baseTemplateBytes)
  const page = document.getPage(0)
  const [helvetica, helveticaBold] = await Promise.all([
    document.embedFont(StandardFonts.Helvetica),
    document.embedFont(StandardFonts.HelveticaBold),
  ])

  const started = formatDateTime(data.startedAt)
  const completed = formatDateTime(data.completedAt)

  drawField(page, helveticaBold, NOMBRE, data.holderName)
  drawField(page, helvetica, DNI, data.holderDni ?? '—')
  drawField(page, helveticaBold, NOMBRE_PARRAFO, data.holderName)
  drawField(
    page,
    helvetica,
    DNI_PARRAFO,
    data.holderDni ?? '—',
    BLUE,
    MIN_FONT_SIZE_TIGHT,
  )
  drawField(
    page,
    helvetica,
    FECHA_HORA_INICIO,
    `${started.date} · ${started.time}`,
  )
  drawField(
    page,
    helvetica,
    FECHA_HORA_FIN,
    `${completed.date} · ${completed.time}`,
  )
  drawField(
    page,
    helvetica,
    HORAS_TOTALES,
    formatActiveDuration(data.activeSeconds),
  )
  drawField(page, helvetica, FECHA_EMISION, formatDateOnly(data.issuedAt))
  drawField(
    page,
    helveticaBold,
    CODIGO_CERTIFICADO,
    data.certificateCode,
    ORANGE,
  )

  return document.save()
}

export function stvhCertificateFileName(certificateCode: string) {
  return `certificado-stvh-${certificateCode.toLowerCase()}.pdf`
}

export function stvhCertificateStoragePath(
  userId: string,
  certificateCode: string,
) {
  return `stvh/${userId}/${certificateCode}.pdf`
}
