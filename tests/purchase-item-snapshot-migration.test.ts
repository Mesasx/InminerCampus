import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

test('la migración correctiva restaura los snapshots requeridos por checkout', async () => {
  const sql = await readFile(
    new URL('../supabase/migrations/20260824113407_fix_purchase_item_snapshot_columns.sql', import.meta.url),
    'utf8',
  )

  assert.match(sql, /add column if not exists course_code_snapshot text/i)
  assert.match(sql, /add column if not exists description_snapshot text/i)
  assert.match(sql, /course_code_snapshot = coalesce\(purchase_item\.course_code_snapshot, course\.slug\)/i)
  assert.match(sql, /description_snapshot = coalesce/i)
})
