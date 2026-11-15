import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const read = (path: string) => readFile(new URL(`../${path}`, import.meta.url), 'utf8')

test('las nuevas cuentas quedan pendientes hasta una revisión humana', async () => {
  const [registration, gate, migration] = await Promise.all([
    read('src/routes/registro.tsx'),
    read('src/components/ProtectedGate.tsx'),
    read('supabase/migrations/20261115104529_approval_gated_private_campus.sql'),
  ])

  for (const field of [
    'company_name',
    'job_title',
    'relationship_type',
    'access_reason',
  ]) {
    assert.match(registration, new RegExp(field))
  }
  assert.match(migration, /'pending'::public\.account_status/)
  assert.match(migration, /current_user_is_approved/)
  assert.match(migration, /reviewed_at = now\(\)/)
  assert.match(migration, /reviewed_by = \(select auth\.uid\(\)\)/)
  assert.match(migration, /if not \(select app_private\.current_user_is_approved\(\)\)/)
  assert.match(gate, /user\.status !== 'active'/)
  assert.match(gate, /Solicitud en revisión/)
})

test('el contenido interno exige cuenta aprobada y matrícula', async () => {
  const migration = await read(
    'supabase/migrations/20261115104529_approval_gated_private_campus.sql',
  )

  assert.match(migration, /revoke select on public\.course_modules, public\.lessons from anon/)
  assert.match(migration, /lessons_enrolled_or_staff/)
  assert.match(migration, /current_user_is_enrolled\(cm\.course_version_id\)/)
  assert.match(migration, /create policy approved_account_gate/)
  assert.match(migration, /create trigger require_approved_learning_write/)
  assert.match(migration, /c\.status = 'published'[\s\S]*c\.listed/)

  const publicGrant = migration.match(
    /grant select \(([\s\S]*?)\) on public\.course_versions to anon/,
  )?.[1]
  assert.ok(publicGrant, 'debe existir una lista pública explícita de columnas')
  assert.doesNotMatch(publicGrant, /\b(modality|price_net|tax_rate|currency)\b/)
})

test('las rutas de servidor que usan privilegios administrativos vuelven a comprobar la cuenta', async () => {
  const helper = await read('src/server/user-auth.ts')
  assert.match(helper, /\.eq\('status', 'active'\)/)

  for (const file of [
    'src/routes/api.certificates.$documentId.download.ts',
    'src/routes/api.certificado-stvh.ts',
    'src/routes/api.certificates.ts',
    'src/routes/api.internal-completion.ts',
    'src/routes/api.company-access-codes.ts',
    'src/routes/api.invoices.ts',
    'src/routes/api.company-licenses.ts',
    'src/server/billing/invoice-access.ts',
  ]) {
    assert.match(await read(file), /requireApprovedUser/, file)
  }
})

test('la superficie pública no ofrece contratación ni publica precios', async () => {
  const files = await Promise.all([
    read('src/components/CourseCard.tsx'),
    read('src/components/CourseSlider.tsx'),
    read('src/routes/catalogo.tsx'),
    read('src/routes/cursos.$courseSlug.tsx'),
    read('src/routes/empresas.tsx'),
    read('src/routes/index.tsx'),
  ])
  const publicSource = files.join('\n')

  assert.match(publicSource, /CourseInquiryButton/)
  assert.doesNotMatch(publicSource, /Comprar ahora|Continuar con Stripe|price-display|Precio neto/)

  const checkout = await read('src/routes/api.checkout.ts')
  assert.match(checkout, /status: 410/)
  assert.doesNotMatch(checkout, /sessions\.create|payment_method_types/)
  const paymentStatus = await read('src/routes/api.payment-status.ts')
  assert.match(paymentStatus, /status: 410/)
})

test('el contacto de cursos abre WhatsApp con mensaje predeterminado', async () => {
  const [config, inquiry, button] = await Promise.all([
    read('src/lib/config.ts'),
    read('src/lib/course-inquiry.ts'),
    read('src/components/CourseInquiryButton.tsx'),
  ])
  assert.match(config, /VITE_COURSE_WHATSAPP_PHONE/)
  assert.match(config, /34652823290/)
  assert.match(inquiry, /https:\/\/wa\.me\//)
  assert.match(inquiry, /encodeURIComponent\(message\)/)
  assert.match(button, /Más información/)
  assert.match(button, /target=\{external \? '_blank' : undefined\}/)
  assert.match(button, /rel=\{external \? 'noopener noreferrer' : undefined\}/)
})
