import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

test('la plataforma usa localmente el nuevo logotipo oficial de Inmíner Campus', async () => {
  const [component, image] = await Promise.all([
    readFile(new URL('../src/components/Logo.tsx', import.meta.url), 'utf8'),
    readFile(new URL('../public/brand/inminer-campus-logo.png', import.meta.url)),
  ])

  assert.match(component, /src=\{logoUrl\}/)
  assert.match(component, /'\/brand\/inminer-campus-logo\.png'/)
  assert.match(component, /alt="Inmíner Campus"/)
  assert.doesNotMatch(component, /https:\/\/inminer\.es/)
  assert.doesNotMatch(component, />Campus</)

  // Firma PNG y canal alfa (color type 6 = RGBA): el logotipo debe
  // conservarse con fondo transparente, sin la caja negra del archivo
  // original que se adjuntó.
  assert.deepEqual(
    [...image.subarray(0, 8)],
    [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
  )
  assert.equal(image.readUInt8(25), 6)
})
