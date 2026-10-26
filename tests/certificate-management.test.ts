import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'

const migrationUrl = new URL(
  '../supabase/migrations/20261014120000_certificate_management_workflow.sql',
  import.meta.url,
)
const noDniMigrationUrl = new URL(
  '../supabase/migrations/20261022090000_certificados_sin_dni.sql',
  import.meta.url,
)
const adminApiUrl = new URL(
  '../src/routes/api.admin-certificates.ts',
  import.meta.url,
)
const downloadApiUrl = new URL(
  '../src/routes/api.certificates.$documentId.download.ts',
  import.meta.url,
)
const studentApiUrl = new URL(
  '../src/routes/api.certificates.ts',
  import.meta.url,
)
const adminPageUrl = new URL(
  '../src/routes/admin.certificados.tsx',
  import.meta.url,
)
const studentPageUrl = new URL(
  '../src/routes/certificados.tsx',
  import.meta.url,
)
const campusPageUrl = new URL(
  '../src/routes/campus.$enrollmentId.index.tsx',
  import.meta.url,
)
const completionServiceUrl = new URL(
  '../src/server/completion/internal-completion-service.ts',
  import.meta.url,
)

test('los certificados admiten varios PDF privados con RLS por propietario', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  assert.match(sql, /create table if not exists public\.certificate_documents/)
  assert.match(sql, /certificate_id uuid not null references public\.certificates/)
  assert.match(sql, /allowed_mime_types = excluded\.allowed_mime_types/)
  assert.match(sql, /array\['application\/pdf'\]/)
  assert.match(sql, /bucket_id = 'certificates'/)
  assert.match(sql, /drop policy if exists certificate_owner_read/)
  assert.match(sql, /drop policy if exists certificate_admin_write/)
  assert.match(sql, /cd\.user_id = \(select auth\.uid\(\)\)/)
  assert.match(sql, /certificate_files_admin_insert/)
  assert.match(sql, /certificate_files_admin_delete/)
})

test('la carga administrativa exige curso completado pero no DNI', async () => {
  const [api, page, noDniMigration] = await Promise.all([
    readFile(adminApiUrl, 'utf8'),
    readFile(adminPageUrl, 'utf8'),
    readFile(noDniMigrationUrl, 'utf8'),
  ])
  assert.match(api, /requireAdministrator\(request\)/)
  assert.match(api, /enrollment\.status !== 'completed'/)
  assert.doesNotMatch(api, /if \(!profile\.dni\?\.trim\(\)\)/)
  assert.match(api, /holder_dni: profile\.dni\?\.trim\(\)\.toUpperCase\(\) \|\| null/)
  assert.match(api, /MAX_CERTIFICATE_SIZE = 10 \* 1024 \* 1024/)
  assert.match(api, /String\.fromCharCode\(\.\.\.signature\) === '%PDF-'/)
  assert.match(api, /getAll\('files'\)/)
  assert.match(page, /multiple/)
  assert.match(page, /Pendiente de certificado/)
  assert.match(page, /row\.enrollment_status === 'completed'/)
  assert.doesNotMatch(page, /row\.enrollment_status === 'completed' && row\.learner\.dni/)
  assert.match(noDniMigration, /status = 'completed'::public\.enrollment_status/)
  assert.doesNotMatch(noDniMigration, /btrim\(coalesce\(p\.dni/)
})

test('las descargas verifican propietario y el estado no depende del DNI', async () => {
  const [downloadApi, studentApi, studentPage, campusPage, completionService] = await Promise.all([
    readFile(downloadApiUrl, 'utf8'),
    readFile(studentApiUrl, 'utf8'),
    readFile(studentPageUrl, 'utf8'),
    readFile(campusPageUrl, 'utf8'),
    readFile(completionServiceUrl, 'utf8'),
  ])
  assert.match(downloadApi, /document\.user_id !== user\.id && !isAdministrator/)
  assert.match(downloadApi, /createSignedUrl\([\s\S]+60/)
  assert.match(downloadApi, /Cache-Control': 'private, no-store'/)
  assert.match(studentApi, /\.eq\('user_id', user\.id\)/)
  assert.doesNotMatch(studentApi, /pending_identity|select\('dni'\)/)
  assert.match(studentApi, /pending_certificate/)
  assert.doesNotMatch(studentPage, /pending_identity|Completa tu DNI\/NIE/)
  assert.doesNotMatch(campusPage, /hasIdentity|Completa tu DNI\/NIE para tramitar/)
  assert.match(completionService, /holderDni = profile\.dni\?\.trim\(\)\.toUpperCase\(\) \|\| 'No informado'/)
  assert.doesNotMatch(completionService, /!holderName \|\| !holderDni \|\| !holderEmail/)
})
