import {
  PDFDocument,
  StandardFonts,
  rgb,
  type PDFFont,
  type PDFPage,
} from 'pdf-lib'

const PAGE_WIDTH = 841.89
const PAGE_HEIGHT = 595.28
const NAVY = rgb(0.035, 0.105, 0.165)
const NAVY_SOFT = rgb(0.095, 0.17, 0.235)
const ORANGE = rgb(0.957, 0.584, 0.125)
const ORANGE_PALE = rgb(1, 0.975, 0.93)
const GREEN = rgb(0.075, 0.43, 0.285)
const GREEN_PALE = rgb(0.93, 0.98, 0.95)
const BORDER = rgb(0.82, 0.855, 0.885)
const MUTED = rgb(0.38, 0.45, 0.52)
const WHITE = rgb(1, 1, 1)

export type InternalCompletionPdfData = {
  courseName: string
  accreditationReference: string | null
  enrollmentId: string
  holderName: string
  holderDni: string
  holderEmail: string
  startedAt: string
  completedAt: string
  activeSeconds: number
  activityDates: string[]
  generatedAt: string
}

export type TrainingReferences = {
  itcReference: string
  etReference: string
}

function normalizedParts(value: string | null): string[] {
  return (value ?? '')
    .split(/[·|;\n]+/)
    .map((part) => part.trim())
    .filter(Boolean)
}

export function parseTrainingReferences(
  value: string | null,
): TrainingReferences {
  const parts = normalizedParts(value)
  const itcReference =
    parts.find((part) => /^ITC\b/i.test(part)) ?? 'No indicada'
  const etReference =
    parts.find((part) => /^(?:E\.?\s*T\.?|ET)\b/i.test(part)) ??
    parts.find((part) => !/^ITC\b/i.test(part)) ??
    'No indicada'
  return { itcReference, etReference }
}

export function formatInternalDateTime(value: string): string {
  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
    timeZone: 'Europe/Madrid',
  })
    .format(new Date(value))
    .replace(',', ' -')
}

export function formatInternalDate(value: string): string {
  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    timeZone: 'Europe/Madrid',
  }).format(new Date(value))
}

export function formatInternalActiveTime(totalSeconds: number): string {
  const seconds = Math.max(0, Math.floor(totalSeconds))
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  return `${String(hours).padStart(2, '0')} h ${String(minutes).padStart(2, '0')} min`
}

function splitLongToken(
  font: PDFFont,
  token: string,
  size: number,
  maxWidth: number,
): string[] {
  const pieces: string[] = []
  let current = ''
  for (const character of token) {
    const candidate = current + character
    if (current && font.widthOfTextAtSize(candidate, size) > maxWidth) {
      pieces.push(current)
      current = character
    } else {
      current = candidate
    }
  }
  if (current) pieces.push(current)
  return pieces
}

function wrapText(
  font: PDFFont,
  text: string,
  size: number,
  maxWidth: number,
): string[] {
  const tokens = text.trim().split(/\s+/).filter(Boolean)
  const lines: string[] = []
  let current = ''
  for (const rawToken of tokens) {
    const pieces =
      font.widthOfTextAtSize(rawToken, size) > maxWidth
        ? splitLongToken(font, rawToken, size, maxWidth)
        : [rawToken]
    for (const token of pieces) {
      const candidate = current ? `${current} ${token}` : token
      if (current && font.widthOfTextAtSize(candidate, size) > maxWidth) {
        lines.push(current)
        current = token
      } else {
        current = candidate
      }
    }
  }
  if (current) lines.push(current)
  return lines.length ? lines : ['—']
}

function fitWrappedText(
  font: PDFFont,
  text: string,
  maxWidth: number,
  maxLines: number,
  startSize: number,
  minSize = 6,
): { lines: string[]; size: number } {
  let size = startSize
  while (size > minSize) {
    const lines = wrapText(font, text, size, maxWidth)
    if (lines.length <= maxLines) return { lines, size }
    size -= 0.5
  }
  return { lines: wrapText(font, text, minSize, maxWidth), size: minSize }
}

function drawLines(
  page: PDFPage,
  font: PDFFont,
  lines: string[],
  x: number,
  y: number,
  size: number,
  lineHeight: number,
  color = NAVY,
) {
  lines.forEach((line, index) => {
    page.drawText(line, { x, y: y - index * lineHeight, size, font, color })
  })
}

function drawRoundedBlock(
  page: PDFPage,
  x: number,
  y: number,
  width: number,
  height: number,
  fill = WHITE,
  border = BORDER,
) {
  page.drawRectangle({
    x,
    y,
    width,
    height,
    color: fill,
    borderColor: border,
    borderWidth: 0.8,
  })
}

function drawHeader(
  page: PDFPage,
  logo: import('pdf-lib').PDFImage,
  bold: PDFFont,
  regular: PDFFont,
) {
  page.drawRectangle({ x: 0, y: 510, width: PAGE_WIDTH, height: 85, color: NAVY })
  page.drawRectangle({ x: 0, y: 590, width: PAGE_WIDTH, height: 5, color: ORANGE })

  const logoScale = Math.min(150 / logo.width, 54 / logo.height)
  page.drawImage(logo, {
    x: 47,
    y: 525,
    width: logo.width * logoScale,
    height: logo.height * logoScale,
  })

  drawRoundedBlock(page, 594, 538, 200, 36, ORANGE, ORANGE)
  page.drawText('USO INTERNO - NO ENTREGAR AL ALUMNO', {
    x: 612,
    y: 559,
    size: 8.2,
    font: bold,
    color: NAVY,
  })
  page.drawText('Documento de trazabilidad para tramitación interna', {
    x: 618,
    y: 547,
    size: 6.7,
    font: regular,
    color: NAVY,
  })
}

function drawFooter(page: PDFPage, regular: PDFFont) {
  const footer =
    'Este documento es exclusivamente un registro interno de trazabilidad de Inmíner Ingeniería, S.L. No constituye el certificado definitivo de formación ni debe ser entregado al alumno o a terceros.'
  const fitted = fitWrappedText(regular, footer, 710, 2, 6.2, 5.5)
  drawLines(
    page,
    regular,
    fitted.lines,
    66,
    25,
    fitted.size,
    fitted.size + 1.5,
    MUTED,
  )
}

function drawLabel(page: PDFPage, font: PDFFont, text: string, x: number, y: number) {
  page.drawText(text.toLocaleUpperCase('es-ES'), {
    x,
    y,
    size: 6.5,
    font,
    color: MUTED,
  })
}

function uniqueActivityDates(values: string[]) {
  const byFormatted = new Map<string, string>()
  for (const value of values) {
    const formatted = formatInternalDate(value)
    if (!byFormatted.has(formatted)) byFormatted.set(formatted, value)
  }
  return [...byFormatted.entries()]
    .sort((left, right) => left[1].localeCompare(right[1]))
    .map(([formatted]) => formatted)
}

function drawActivityGrid(
  page: PDFPage,
  dates: string[],
  regular: PDFFont,
  x: number,
  y: number,
  columns: number,
  rows: number,
  columnWidth: number,
) {
  dates.slice(0, columns * rows).forEach((date, index) => {
    const column = Math.floor(index / rows)
    const row = index % rows
    page.drawText(date, {
      x: x + column * columnWidth,
      y: y - row * 11,
      size: 7.2,
      font: regular,
      color: NAVY_SOFT,
    })
  })
}

export async function createInternalCompletionPdf(
  data: InternalCompletionPdfData,
  logoBytes: Uint8Array,
): Promise<Uint8Array> {
  const document = await PDFDocument.create()
  const [regular, bold, logo] = await Promise.all([
    document.embedFont(StandardFonts.Helvetica),
    document.embedFont(StandardFonts.HelveticaBold),
    document.embedPng(logoBytes),
  ])
  const generatedDate = new Date(data.generatedAt)
  document.setTitle('Registro interno de finalización de formación')
  document.setAuthor('INMÍNER Ingeniería, S.L.')
  document.setSubject('Documento interno de trazabilidad de formación')
  document.setCreator('InmínerCampus')
  document.setProducer('InmínerCampus')
  document.setCreationDate(generatedDate)
  document.setModificationDate(generatedDate)

  const references = parseTrainingReferences(data.accreditationReference)
  const activityDates = uniqueActivityDates(data.activityDates)
  const page = document.addPage([PAGE_WIDTH, PAGE_HEIGHT])
  drawHeader(page, logo, bold, regular)

  const title = fitWrappedText(
    bold,
    'REGISTRO INTERNO DE FINALIZACIÓN DE FORMACIÓN',
    570,
    2,
    18,
    14,
  )
  drawLines(page, bold, title.lines, 48, 478, title.size, title.size + 2)
  page.drawText('Generado automáticamente por InmínerCampus al completar la acción formativa.', {
    x: 48,
    y: 450,
    size: 8.5,
    font: regular,
    color: MUTED,
  })

  drawRoundedBlock(page, 642, 460, 152, 28, GREEN_PALE, rgb(0.55, 0.8, 0.67))
  page.drawText('FORMACIÓN FINALIZADA', {
    x: 667,
    y: 471,
    size: 8,
    font: bold,
    color: GREEN,
  })

  drawRoundedBlock(page, 48, 362, 746, 72, ORANGE_PALE, rgb(0.95, 0.76, 0.47))
  page.drawRectangle({ x: 48, y: 362, width: 5, height: 72, color: ORANGE })
  drawLabel(page, bold, 'Acción formativa', 66, 414)
  const course = fitWrappedText(bold, data.courseName, 560, 2, 13, 8)
  drawLines(page, bold, course.lines, 66, 397, course.size, course.size + 2)
  const referencesText = `Referencia formativa: ${references.itcReference} · ${references.etReference}`
  const referencesLines = fitWrappedText(regular, referencesText, 560, 2, 8, 6.5)
  drawLines(page, regular, referencesLines.lines, 66, 375, referencesLines.size, 9, MUTED)
  drawLabel(page, bold, 'Registro de curso', 675, 414)
  const enrollment = fitWrappedText(bold, data.enrollmentId, 105, 2, 7.5, 5.5)
  drawLines(page, bold, enrollment.lines, 675, 395, enrollment.size, 8)
  page.drawText('ID interno de matrícula', {
    x: 675,
    y: 374,
    size: 6.5,
    font: regular,
    color: MUTED,
  })

  drawRoundedBlock(page, 48, 185, 360, 153)
  page.drawText('Datos del alumno', { x: 66, y: 315, size: 11, font: bold, color: NAVY })
  page.drawLine({ start: { x: 66, y: 305 }, end: { x: 390, y: 305 }, thickness: 0.6, color: BORDER })
  drawLabel(page, bold, 'Nombre y apellidos', 66, 286)
  const name = fitWrappedText(bold, data.holderName, 315, 2, 12, 8)
  drawLines(page, bold, name.lines, 66, 270, name.size, name.size + 2)
  drawLabel(page, bold, 'DNI / NIE', 66, 235)
  page.drawText(data.holderDni, { x: 66, y: 219, size: 10, font: bold, color: NAVY })
  drawLabel(page, bold, 'Correo electrónico', 66, 199)
  const email = fitWrappedText(regular, data.holderEmail, 315, 2, 9, 6.5)
  drawLines(page, regular, email.lines, 66, 186, email.size, email.size + 1.5)

  drawRoundedBlock(page, 426, 185, 368, 153)
  page.drawText('Trazabilidad de la formación', { x: 444, y: 315, size: 11, font: bold, color: NAVY })
  page.drawLine({ start: { x: 444, y: 305 }, end: { x: 776, y: 305 }, thickness: 0.6, color: BORDER })
  const traceCards = [
    ['INICIO', formatInternalDateTime(data.startedAt)],
    ['FINALIZACIÓN', formatInternalDateTime(data.completedAt)],
    ['TIEMPO ACTIVO REGISTRADO', formatInternalActiveTime(data.activeSeconds)],
    ['DÍAS CON ACTIVIDAD', `${activityDates.length} ${activityDates.length === 1 ? 'día' : 'días'}`],
  ] as const
  traceCards.forEach(([label, value], index) => {
    const column = index % 2
    const row = Math.floor(index / 2)
    const x = 444 + column * 166
    const y = 252 - row * 57
    drawRoundedBlock(page, x, y, 150, 45, WHITE, BORDER)
    drawLabel(page, bold, label, x + 10, y + 29)
    const fitted = fitWrappedText(bold, value, 130, 2, 8.5, 6)
    drawLines(page, bold, fitted.lines, x + 10, y + 13, fitted.size, 9)
  })

  drawRoundedBlock(page, 48, 50, 746, 119)
  page.drawText('Detalle útil para tramitación', { x: 66, y: 148, size: 9.5, font: bold, color: NAVY })
  drawLabel(page, bold, 'Días / fechas con actividad registrada', 66, 130)
  const firstPageDates = activityDates.slice(0, 15)
  drawActivityGrid(page, firstPageDates, regular, 66, 113, 3, 5, 93)
  if (activityDates.length > firstPageDates.length) {
    page.drawText(`Continúa en la página siguiente (${activityDates.length - firstPageDates.length} fechas).`, {
      x: 66,
      y: 56,
      size: 6.5,
      font: regular,
      color: MUTED,
    })
  }
  page.drawLine({ start: { x: 520, y: 62 }, end: { x: 520, y: 151 }, thickness: 0.7, color: BORDER })
  drawLabel(page, bold, 'Destino interno', 536, 130)
  page.drawText('pedro@inminer.es', { x: 536, y: 111, size: 9.5, font: bold, color: NAVY })
  const generated = fitWrappedText(
    regular,
    `Generado: ${formatInternalDateTime(data.generatedAt)}`,
    235,
    2,
    7.5,
    6,
  )
  drawLines(page, regular, generated.lines, 536, 92, generated.size, 9, MUTED)
  page.drawText('Pendiente de revisión y emisión del certificado definitivo.', {
    x: 536,
    y: 70,
    size: 6.6,
    font: regular,
    color: MUTED,
  })
  drawFooter(page, regular)

  const remainingDates = activityDates.slice(15)
  const datesPerContinuationPage = 50
  for (let offset = 0; offset < remainingDates.length; offset += datesPerContinuationPage) {
    const continuation = document.addPage([PAGE_WIDTH, PAGE_HEIGHT])
    drawHeader(continuation, logo, bold, regular)
    continuation.drawText('FECHAS DE ACTIVIDAD REGISTRADA', {
      x: 48,
      y: 472,
      size: 18,
      font: bold,
      color: NAVY,
    })
    continuation.drawText(data.courseName, {
      x: 48,
      y: 450,
      size: 9,
      font: regular,
      color: MUTED,
      maxWidth: 730,
    })
    drawRoundedBlock(continuation, 48, 62, 746, 360)
    drawActivityGrid(
      continuation,
      remainingDates.slice(offset, offset + datesPerContinuationPage),
      regular,
      70,
      390,
      5,
      10,
      140,
    )
    drawFooter(continuation, regular)
  }

  return document.save({ useObjectStreams: false })
}

export function internalCompletionFileName(data: Pick<InternalCompletionPdfData, 'holderName' | 'courseName'>) {
  const slug = `${data.holderName}-${data.courseName}`
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase('es')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
  return `registro-interno-finalizacion-${slug || 'formacion'}.pdf`
}
