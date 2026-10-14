import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'

const migrationUrl = new URL(
  '../supabase/migrations/20261014120000_certificate_management_workflow.sql',
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

test('la carga administrativa valida permisos, identidad, PDF real y tamaño', async () => {
  const [api, page] = await Promise.all([
    readFile(adminApiUrl, 'utf8'),
    readFile(adminPageUrl, 'utf8'),
  ])
  assert.match(api, /requireAdministrator\(request\)/)
  assert.match(api, /profile\.dni\?\.trim\(\)/)
  assert.match(api, /MAX_CERTIFICATE_SIZE = 10 \* 1024 \* 1024/)
  assert.match(api, /String\.fromCharCode\(\.\.\.signature\) === '%PDF-'/)
  assert.match(api, /getAll\('files'\)/)
  assert.match(page, /multiple/)
  assert.match(page, /Pendiente de certificado/)
})

test('las descargas verifican propietario y generan enlaces temporales', async () => {
  const [downloadApi, studentApi] = await Promise.all([
    readFile(downloadApiUrl, 'utf8'),
    readFile(studentApiUrl, 'utf8'),
  ])
  assert.match(downloadApi, /document\.user_id !== user\.id && !isAdministrator/)
  assert.match(downloadApi, /createSignedUrl\([\s\S]+60/)
  assert.match(downloadApi, /Cache-Control': 'private, no-store'/)
  assert.match(studentApi, /\.eq\('user_id', user\.id\)/)
  assert.match(studentApi, /pending_identity/)
  assert.match(studentApi, /pending_certificate/)
})
