import assert from 'node:assert/strict'
import test from 'node:test'
import { readFile } from 'node:fs/promises'
import { secureTokenEqual } from '../src/server/billing/machine-auth.ts'
import { classifyArchiveHash } from '../tools/inminercampus-archive-agent/src/archive-utils.ts'

test('compara el token del agente sin comparación directa del secreto', () => {
  assert.equal(secureTokenEqual('secret-value', 'secret-value'), true)
  assert.equal(secureTokenEqual('secret-value', 'wrong-value'), false)
})

test('el agente archiva de forma inmutable y verifica SHA-256 y rutas', async () => {
  const source = await readFile(
    new URL('../tools/inminercampus-archive-agent/src/index.ts', import.meta.url),
    'utf8',
  )
  assert.match(source, /downloadedHash !== invoice\.sha256/)
  assert.match(source, /writeFile\(finalPath, bytes, \{ flag: 'wx' \}\)/)
  assert.match(source, /relative\.startsWith\('\.\.'\)/)
  assert.match(source, /path\.parse\(root\)\.root === root/)
  assert.doesNotMatch(source, /console\.log\([^\n]*token/)
})

test('un archivo existente solo es idempotente si conserva el mismo hash', () => {
  const expected = 'a'.repeat(64)
  assert.equal(classifyArchiveHash(expected, expected), 'same')
  assert.equal(classifyArchiveHash(expected, 'b'.repeat(64)), 'conflict')
})
