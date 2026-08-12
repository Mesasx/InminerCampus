import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202608120003_rate_limit_redeem_and_support.sql',
  import.meta.url,
)
const redeemRouteUrl = new URL(
  '../src/routes/canjear-codigo.tsx',
  import.meta.url,
)
const dudasRouteUrl = new URL('../src/routes/dudas.index.tsx', import.meta.url)

test('la tabla de límite de frecuencia no concede privilegios directos a anon/authenticated', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /create table if not exists app_private\.rate_limit_hits/)
  assert.match(sql, /alter table app_private\.rate_limit_hits enable row level security/)
  assert.match(
    sql,
    /revoke all on table app_private\.rate_limit_hits from public, anon, authenticated/,
  )
  assert.match(sql, /security definer/)
  assert.match(sql, /set search_path = ''/)
})

test('redeem_access_code comprueba el límite antes de validar el código', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const fn = sql.split('function public.redeem_access_code')[1]

  const rateLimitIndex = fn.indexOf('check_rate_limit')
  const formatCheckIndex = fn.indexOf('char_length(trim(input_code))')
  assert.ok(rateLimitIndex > 0 && formatCheckIndex > 0)
  assert.ok(rateLimitIndex < formatCheckIndex)
  assert.match(fn, /check_rate_limit\('redeem_access_code', current_user_id, 8, interval '15 minutes'\)/)
})

test('create_support_thread comprueba el límite antes de insertar el hilo', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const fn = sql.split('function public.create_support_thread')[1]

  const rateLimitIndex = fn.indexOf('check_rate_limit')
  const insertIndex = fn.indexOf('insert into public.support_threads')
  assert.ok(rateLimitIndex > 0 && insertIndex > 0)
  assert.ok(rateLimitIndex < insertIndex)
  assert.match(fn, /check_rate_limit\('create_support_thread', current_user_id, 5, interval '60 minutes'\)/)
})

test('los formularios distinguen el aviso de límite de frecuencia del resto de errores', async () => {
  const [redeemRoute, dudasRoute] = await Promise.all([
    readFile(redeemRouteUrl, 'utf8'),
    readFile(dudasRouteUrl, 'utf8'),
  ])

  assert.match(redeemRoute, /Demasiados intentos/)
  assert.match(dudasRoute, /Too many support threads/)
})
