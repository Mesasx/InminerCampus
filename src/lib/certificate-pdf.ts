export type CertificatePdfData = {
  certificateCode: string
  holderName: string
  courseTitle: string
  durationHours: number
  modality: string
  completionDate: string
  issuedAt: string
}

const PAGE_WIDTH = 841.89
const PAGE_HEIGHT = 595.28

const WIN_1252: Record<string, number> = {
  '\u20ac': 0x80,
  '\u201a': 0x82,
  '\u0192': 0x83,
  '\u201e': 0x84,
  '\u2026': 0x85,
  '\u2020': 0x86,
  '\u2021': 0x87,
  '\u02c6': 0x88,
  '\u2030': 0x89,
  '\u0160': 0x8a,
  '\u2039': 0x8b,
  '\u0152': 0x8c,
  '\u017d': 0x8e,
  '\u2018': 0x91,
  '\u2019': 0x92,
  '\u201c': 0x93,
  '\u201d': 0x94,
  '\u2022': 0x95,
  '\u2013': 0x96,
  '\u2014': 0x97,
  '\u02dc': 0x98,
  '\u2122': 0x99,
  '\u0161': 0x9a,
  '\u203a': 0x9b,
  '\u0153': 0x9c,
  '\u017e': 0x9e,
  '\u0178': 0x9f,
}

function encodePdfText(value: string) {
  return Array.from(value)
    .map((character) => {
      const codePoint = character.codePointAt(0) ?? 0x3f
      const byte = codePoint <= 0xff ? codePoint : (WIN_1252[character] ?? 0x3f)
      return byte.toString(16).padStart(2, '0')
    })
    .join('')
    .toUpperCase()
}

function pdfText(
  font: 'F1' | 'F2' | 'F3' | 'F4',
  size: number,
  x: number,
  y: number,
  value: string,
  color = '0.086 0.125 0.169',
) {
  return `BT /${font} ${size} Tf ${color} rg 1 0 0 1 ${x} ${y} Tm <${encodePdfText(value)}> Tj ET`
}

function wrapText(value: string, maximumCharacters: number) {
  const words = value.trim().split(/\s+/)
  const lines: string[] = []
  let current = ''
  for (const word of words) {
    const candidate = current ? `${current} ${word}` : word
    if (candidate.length <= maximumCharacters || !current) {
      current = candidate
    } else {
      lines.push(current)
      current = word
    }
  }
  if (current) lines.push(current)
  return lines
}

function formatDate(value: string) {
  const isoDate = value.slice(0, 10)
  const [year, month, day] = isoDate.split('-')
  return year && month && day ? `${day}/${month}/${year}` : value
}

function modalityLabel(modality: string) {
  return (
    {
      online: 'Online',
      hybrid: 'Semipresencial',
      in_person: 'Presencial',
    }[modality] ?? modality
  )
}

function courseDescription(courseTitle: string) {
  if (courseTitle.toLocaleLowerCase('es').includes('stvh')) {
    return (
      'Medición de dimensiones y masas de vehículos y registro de datos ' +
      'primarios en la inspección. Comprende la sistemática y los criterios ' +
      'de medición, las exenciones dimensionales por categoría, los ' +
      'remolques y tractores agrícolas y la cumplimentación de las fichas ' +
      'de inspección LVH-13.1 a LVH-13.6.'
    )
  }
  return 'Acción formativa completada y superada con aprovechamiento.'
}

function makePdf(objects: string[]) {
  const header = '%PDF-1.4\n%\xE2\xE3\xCF\xD3\n'
  let body = header
  const offsets = [0]

  objects.forEach((object, index) => {
    offsets.push(body.length)
    body += `${index + 1} 0 obj\n${object}\nendobj\n`
  })

  const xrefOffset = body.length
  body += `xref\n0 ${objects.length + 1}\n`
  body += '0000000000 65535 f \n'
  for (let index = 1; index <= objects.length; index += 1) {
    body += `${String(offsets[index]).padStart(10, '0')} 00000 n \n`
  }
  body +=
    `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R /Info 9 0 R >>\n` +
    `startxref\n${xrefOffset}\n%%EOF\n`

  return Uint8Array.from(body, (character) => character.charCodeAt(0) & 0xff)
}

export function createCertificatePdf(data: CertificatePdfData) {
  const completionDate = formatDate(data.completionDate)
  const issuedDate = formatDate(data.issuedAt)
  const descriptionLines = wrapText(courseDescription(data.courseTitle), 105).slice(
    0,
    3,
  )
  const verificationLines = wrapText(
    `Registro interno de formación emitido el ${issuedDate}. ` +
      'Su autenticidad puede comprobarse en el Campus Inmíner mediante este código.',
    52,
  ).slice(0, 4)
  const nameSize = data.holderName.length > 50 ? 20 : data.holderName.length > 36 ? 24 : 28
  const courseSize = data.courseTitle.length > 60 ? 18 : 22
  const stream = [
    'q',
    '1 1 1 rg 0 0 841.89 595.28 re f',
    '0.086 0.125 0.169 RG 1.1 w 26 26 789.89 543.28 re S',
    '0.961 0.702 0.004 RG 0.7 w 32 32 777.89 531.28 re S',
    '0.086 0.125 0.169 rg 26 26 20 543.28 re f',
    '0.961 0.702 0.004 rg 48 26 3 543.28 re f',
    pdfText('F2', 22, 76, 529, 'INMÍNER'),
    pdfText('F1', 9, 676, 532, 'Inmíner Ingeniería, S.L.', '0.086 0.125 0.169'),
    pdfText('F1', 8, 677, 516, 'Formación interna · LVH Carricoche', '0.373 0.447 0.522'),
    pdfText(
      'F2',
      9,
      76,
      470,
      'FORMACIÓN INTERNA · REGISTRO DE APROVECHAMIENTO',
      '0.722 0.522 0.039',
    ),
    pdfText('F3', 30, 76, 427, 'Certificado de formación'),
    '0.961 0.702 0.004 rg 76 409 102 4 re f',
    pdfText('F1', 11, 76, 380, 'Se certifica que', '0.373 0.447 0.522'),
    pdfText('F3', nameSize, 76, 342, data.holderName),
    pdfText(
      'F1',
      11,
      76,
      307,
      'ha completado y superado con aprovechamiento la acción formativa',
      '0.373 0.447 0.522',
    ),
    pdfText('F3', courseSize, 76, 275, data.courseTitle),
    ...descriptionLines.map((line, index) =>
      pdfText('F1', 9.2, 76, 251 - index * 14, line, '0.373 0.447 0.522'),
    ),
    '0.867 0.89 0.91 RG 0.6 w 76 198 m 785 198 l S',
    pdfText('F1', 7.5, 76, 177, 'DURACIÓN', '0.541 0.604 0.659'),
    pdfText('F2', 11.5, 76, 158, `${data.durationHours} horas`),
    pdfText('F1', 7.5, 250, 177, 'MODALIDAD', '0.541 0.604 0.659'),
    pdfText('F2', 11.5, 250, 158, modalityLabel(data.modality)),
    pdfText('F1', 7.5, 424, 177, 'FECHA DE SUPERACIÓN', '0.541 0.604 0.659'),
    pdfText('F2', 11.5, 424, 158, completionDate),
    pdfText('F1', 7.5, 627, 177, 'EVALUACIÓN', '0.541 0.604 0.659'),
    pdfText('F2', 11.5, 627, 158, 'Superada al 100 %'),
    '0.086 0.125 0.169 RG 0.8 w 76 105 m 280 105 l S',
    pdfText('F2', 10, 76, 87, 'Pedro Mesas'),
    pdfText('F1', 8.5, 76, 72, 'Dirección · Inmíner Ingeniería, S.L.', '0.373 0.447 0.522'),
    pdfText('F4', 13, 581, 112, data.certificateCode),
    ...verificationLines.map((line, index) =>
      pdfText('F1', 7.8, 581, 91 - index * 11, line, '0.373 0.447 0.522'),
    ),
    'Q',
  ].join('\n')

  const objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 ${PAGE_WIDTH} ${PAGE_HEIGHT}] /Resources << /Font << /F1 4 0 R /F2 5 0 R /F3 6 0 R /F4 7 0 R >> >> /Contents 8 0 R >>`,
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Times-Bold /Encoding /WinAnsiEncoding >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Courier-Bold /Encoding /WinAnsiEncoding >>',
    `<< /Length ${stream.length} >>\nstream\n${stream}\nendstream`,
    `<< /Title <${encodePdfText(`Certificado de formación · ${data.courseTitle}`)}> /Author <${encodePdfText('Inmíner Ingeniería, S.L.')}> /Subject <${encodePdfText('Certificado interno de formación')}> >>`,
  ]

  return makePdf(objects)
}

export function certificateFileName(data: Pick<CertificatePdfData, 'holderName' | 'courseTitle'>) {
  const slug = `${data.courseTitle}-${data.holderName}`
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase('es')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
  return `certificado-${slug || 'formacion'}.pdf`
}

export function downloadCertificatePdf(data: CertificatePdfData) {
  const bytes = createCertificatePdf(data)
  const blob = new Blob([new Uint8Array(bytes)], { type: 'application/pdf' })
  const url = URL.createObjectURL(blob)
  const anchor = document.createElement('a')
  anchor.href = url
  anchor.download = certificateFileName(data)
  document.body.append(anchor)
  anchor.click()
  anchor.remove()
  window.setTimeout(() => URL.revokeObjectURL(url), 1_000)
}
