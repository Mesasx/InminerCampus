import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'
import {
  certificateFileName,
  createCertificatePdf,
} from '../src/lib/certificate-pdf.ts'

const migration = readFileSync(
  new URL(
    '../supabase/migrations/20260812130058_issue_stvh_certificates.sql',
    import.meta.url,
  ),
  'utf8',
)
const route = readFileSync(
  new URL('../src/routes/certificados.tsx', import.meta.url),
  'utf8',
)

test('STVH certificates are issued only for completed enrollments', () => {
  assert.match(migration, /c\.slug = 'formacion-stvh'/)
  assert.match(
    migration,
    /new\.status <> 'completed'::public\.enrollment_status/,
  )
  assert.match(migration, /new\.completed_at is null/)
  assert.match(migration, /on conflict \(enrollment_id\) do nothing/g)
  assert.match(migration, /after insert or update of status, completed_at/)
  assert.match(migration, /where c\.slug = 'formacion-stvh'[\s\S]*e\.status = 'completed'/)
})

test('certificate page exposes a PDF download action', () => {
  assert.match(route, /pdf_storage_path/)
  assert.match(route, /createSignedUrl/)
  assert.match(route, /downloadCertificatePdf/)
  assert.match(route, /Descargar PDF/)
})

test('personalized certificate generator creates a valid PDF envelope', () => {
  const certificateCode = 'INM-STVH-12345678-ABCDEF12'
  const bytes = createCertificatePdf({
    certificateCode,
    holderName: 'Ana Pérez García',
    courseTitle: 'Formación STVH',
    durationHours: 3,
    modality: 'online',
    completionDate: '2026-08-12',
    issuedAt: '2026-08-12T10:00:00.000Z',
  })
  const pdf = Buffer.from(bytes).toString('latin1')
  const encodedCode = Buffer.from(certificateCode, 'latin1')
    .toString('hex')
    .toUpperCase()

  assert.ok(bytes.length > 2_000)
  assert.ok(pdf.startsWith('%PDF-1.4'))
  assert.match(pdf, /\/Type \/Page/)
  assert.ok(pdf.includes(`<${encodedCode}>`))
  assert.ok(pdf.endsWith('%%EOF\n'))
  assert.equal(
    certificateFileName({
      holderName: 'Ana Pérez García',
      courseTitle: 'Formación STVH',
    }),
    'certificado-formacion-stvh-ana-perez-garcia.pdf',
  )
})
