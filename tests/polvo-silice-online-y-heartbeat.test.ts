import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260831065001_polvo_silice_modalidad_online.sql',
  import.meta.url,
)
const heartbeatUrl = new URL('../src/lib/use-activity-heartbeat.ts', import.meta.url)
const adminPageUrl = new URL('../src/routes/admin.usuarios.tsx', import.meta.url)

const POLVO_SILICE_COURSE_ID = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'

test('Polvo y Sílice pasa a online y deja de exigir práctica presencial', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /update public\.course_versions/)
  assert.match(sql, /modality = 'online'::public\.course_modality/)
  assert.match(sql, /practice_required = false/)
  assert.match(sql, new RegExp(POLVO_SILICE_COURSE_ID))
})

test('la migración desatasca las matrículas que esperaban una práctica inexistente', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /update public\.enrollments/)
  assert.match(sql, /status = 'completed'::public\.enrollment_status/)
  // Sin `completed_at` la ficha del alumno no puede calcular cuánto tardó.
  assert.match(sql, /completed_at = coalesce\(/)
  assert.match(sql, /theory_completed_at is not null/)
  // Y se verifica sola: si algo queda a medias, la migración falla.
  assert.match(sql, /raise exception/)
})

test('el heartbeat no pierde el tiempo de estudio cuando el RPC falla', async () => {
  const hook = await readFile(heartbeatUrl, 'utf8')

  // Antes era `void supabase.rpc(...)`: el error se descartaba en silencio
  // y los segundos ya restados se perdían para siempre.
  assert.doesNotMatch(hook, /void supabase!?\.rpc\(/)
  assert.match(hook, /const \{ error \} = await supabase!\.rpc\(/)
  assert.match(hook, /pendingSeconds \+= delta/)
  assert.match(hook, /console\.error\(/)
})

test('el heartbeat respeta el tope de 30 s que aplica el RPC', async () => {
  const hook = await readFile(heartbeatUrl, 'utf8')

  assert.match(hook, /MAX_DELTA_SECONDS = 30/)
  assert.match(hook, /Math\.min\(Math\.floor\(pendingSeconds\), MAX_DELTA_SECONDS\)/)
  assert.match(hook, /addEventListener\('pagehide'/)
})

test('el tiempo transcurrido se mide hasta el fin de la teoría, no hasta hoy', async () => {
  const page = await readFile(adminPageUrl, 'utf8')

  assert.match(
    page,
    /const finishedAt = enrollment\.completed_at \?\? enrollment\.theory_completed_at/,
  )
  assert.match(page, /finishedAt \? elapsed : `\$\{elapsed\} \(en curso\)`/)
})
