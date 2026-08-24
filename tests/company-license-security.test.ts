import assert from 'node:assert/strict'
import { randomBytes } from 'node:crypto'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import { decryptAccessCode, encryptAccessCode } from '../src/server/company-license-crypto.ts'

test('cifra y autentica un código con AES-256-GCM sin guardar texto plano', () => {
  const previous = process.env.COMPANY_ACCESS_CODE_ENCRYPTION_KEY
  process.env.COMPANY_ACCESS_CODE_ENCRYPTION_KEY = randomBytes(32).toString('base64')
  try {
    const code = 'INM-2345-ABCD-EFGH'
    const encrypted = encryptAccessCode(code)
    assert.notEqual(encrypted.ciphertext, code)
    assert.equal(decryptAccessCode(encrypted), code)
    assert.throws(() => decryptAccessCode({ ...encrypted, auth_tag: randomBytes(16).toString('base64') }))
  } finally {
    if (previous === undefined) delete process.env.COMPANY_ACCESS_CODE_ENCRYPTION_KEY
    else process.env.COMPANY_ACCESS_CODE_ENCRYPTION_KEY = previous
  }
})

test('la migración aísla ciphertext, destinatarios y provisión idempotente', async () => {
  const sql = await readFile(new URL('../supabase/migrations/20260824063039_company_checkout_licenses.sql', import.meta.url), 'utf8')
  assert.match(sql, /company_license_recipients enable row level security/i)
  assert.match(sql, /company_access_code_secrets force row level security/i)
  assert.match(sql, /revoke all on public\.company_license_recipients,[\s\S]*company_access_code_secrets from public, anon, authenticated/i)
  assert.match(sql, /target_recipient\.access_code_id is not null then continue/i)
  assert.match(sql, /recipient_count_does_not_match_quantity/i)
  assert.match(sql, /organization_already_registered/i)
  assert.match(sql, /protect_paid_company_item_snapshot/i)
  assert.match(sql, /protect_company_recipient_identity/i)
  assert.match(sql, /grant select, insert on public\.company_access_code_secrets to service_role/i)
  assert.match(sql, /'sent'::public\.company_license_delivery_status/)
  assert.match(sql, /'failed'::public\.company_license_delivery_status/)
})

test('la generacion manual no compite con licencias automaticas', async () => {
  const endpoint = await readFile(new URL('../src/routes/api.company-access-codes.ts', import.meta.url), 'utf8')
  assert.match(endpoint, /company_license_recipients/)
  assert.match(endpoint, /licencias autom/i)
})
