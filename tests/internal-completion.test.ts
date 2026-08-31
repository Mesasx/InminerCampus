import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'
import { PDFDocument } from 'pdf-lib'
import {
  createInternalCompletionPdf,
  formatInternalActiveTime,
  parseTrainingReferences,
} from '../src/server/completion/internal-completion-pdf.ts'
import {
  runInternalCompletionOnce,
  type InternalCompletionJob,
} from '../src/server/completion/internal-completion-orchestrator.ts'

const migrationUrl = new URL(
  '../supabase/migrations/20260821122229_internal_completion_records.sql',
  import.meta.url,
)
const completionRouteUrl = new URL(
  '../src/routes/api.internal-completion.ts',
  import.meta.url,
)
const certificatesRouteUrl = new URL(
  '../src/routes/certificados.tsx',
  import.meta.url,
)
const serviceUrl = new URL(
  '../src/server/completion/internal-completion-service.ts',
  import.meta.url,
)
const logoUrl = new URL(
  '../public/brand/inminer-campus-logo.png',
  import.meta.url,
)

const job: InternalCompletionJob = {
  id: '11111111-1111-4111-8111-111111111111',
  enrollment_id: '22222222-2222-4222-8222-222222222222',
  user_id: '33333333-3333-4333-8333-333333333333',
  course_version_id: '44444444-4444-4444-8444-444444444444',
  attempt_count: 1,
  generated_at: null,
  snapshot: null,
  pdf_storage_path: null,
  pdf_sha256: null,
}

test('una finalización repetida prepara un PDF y envía un único email', async () => {
  let available = true
  let pdfs = 0
  let emails = 0
  const completions: boolean[] = []
  const dependencies = {
    claim: async () => {
      if (!available) return null
      available = false
      return job
    },
    validate: async () => undefined,
    prepare: async () => {
      pdfs += 1
      return new Uint8Array([37, 80, 68, 70])
    },
    send: async () => {
      emails += 1
      return 'email_internal_123'
    },
    complete: async ({ success }: { success: boolean }) => {
      completions.push(success)
    },
  }

  assert.equal(
    await runInternalCompletionOnce(job.enrollment_id, dependencies),
    'sent',
  )
  assert.equal(
    await runInternalCompletionOnce(job.enrollment_id, dependencies),
    'already_handled',
  )
  assert.equal(pdfs, 1)
  assert.equal(emails, 1)
  assert.deepEqual(completions, [true])
})

test('el PDF soporta datos largos y muchas fechas sin recortar contenido', async () => {
  const logo = new Uint8Array(await readFile(logoUrl))
  const activityDates = Array.from({ length: 68 }, (_, index) =>
    new Date(Date.UTC(2026, 0, index + 1, 10, 30)).toISOString(),
  )
  const bytes = await createInternalCompletionPdf(
    {
      courseName:
        'Curso extraordinariamente extenso de formación preventiva para operadores de maquinaria de transporte, camión y volquete en explotaciones mineras de exterior',
      accreditationReference: 'ITC 02.1.02 · E.T. 2000-1-08',
      enrollmentId: 'fec849ae-60f8-4f8a-9075-c8927ccaade3',
      holderName:
        'María de los Ángeles Fernández-García López de la Fuente y Rodríguez',
      holderDni: 'X1234567L',
      holderEmail:
        'maria.fernandez-garcia.lopez-de-la-fuente@empresa-industrial.example',
      startedAt: '2026-01-01T08:34:00.000Z',
      completedAt: '2026-03-09T17:12:00.000Z',
      activeSeconds: 24_120,
      activityDates,
      generatedAt: '2026-03-09T17:13:00.000Z',
    },
    logo,
  )
  const pdf = await PDFDocument.load(bytes)
  assert.equal(Buffer.from(bytes.subarray(0, 4)).toString(), '%PDF')
  assert.ok(pdf.getPageCount() >= 2)
  assert.equal(pdf.getTitle(), 'Registro interno de finalización de formación')
  assert.equal(pdf.getAuthor(), 'INMÍNER Ingeniería, S.L.')
})

test('las referencias y el tiempo se obtienen dinámicamente', () => {
  assert.deepEqual(
    parseTrainingReferences('ITC 02.1.02 · ET 2000-1-08'),
    { itcReference: 'ITC 02.1.02', etReference: 'ET 2000-1-08' },
  )
  assert.deepEqual(
    parseTrainingReferences('ITC 02.0.02 · Orden TED/723/2021'),
    {
      itcReference: 'ITC 02.0.02',
      etReference: 'Orden TED/723/2021',
    },
  )
  assert.equal(formatInternalActiveTime(24_120), '06 h 42 min')
})

test('la migración mantiene PDF y cola fuera del alcance del alumno', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  assert.match(sql, /drop trigger if exists enrollments_issue_stvh_certificate/)
  assert.match(sql, /enrollment_id uuid not null unique/)
  assert.match(sql, /internal_completion_records force row level security/)
  assert.match(
    sql,
    /revoke all on public\.internal_completion_records\s+from public, anon, authenticated/,
  )
  assert.match(sql, /'internal-completion-documents',[\s\S]*false/)
  assert.doesNotMatch(
    sql,
    /create policy[\s\S]+internal-completion-documents/i,
  )
  assert.match(sql, /for update skip locked/)
})

test('el backend acepta solo la matrícula y Resend usa idempotencia', async () => {
  const [route, service, certificates] = await Promise.all([
    readFile(completionRouteUrl, 'utf8'),
    readFile(serviceUrl, 'utf8'),
    readFile(certificatesRouteUrl, 'utf8'),
  ])
  assert.match(route, /enrollmentId: z\.uuid\(\)/)
  assert.doesNotMatch(route, /holderName|holderDni|activeSeconds|courseName/)
  assert.match(service, /'Idempotency-Key': `internal-completion\/\$\{job\.enrollment_id\}`/)
  assert.match(service, /capinolopez@gmail\.com/)
  assert.doesNotMatch(service, /pedro@inminer\.es/)
  assert.doesNotMatch(certificates, /Descargar certificado|Descargar PDF/)
  assert.doesNotMatch(certificates, /createSignedUrl|downloadCertificate/)
})
