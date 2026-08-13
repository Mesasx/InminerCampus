import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

test('the platform uses the supplied Inmíner Ingeniería logo locally', async () => {
  const [component, image] = await Promise.all([
    readFile(new URL('../src/components/Logo.tsx', import.meta.url), 'utf8'),
    readFile(new URL('../public/images/inminer-logo.jpeg', import.meta.url)),
  ])

  assert.match(component, /src=\{officialLogoUrl\}/)
  assert.match(component, /'\/images\/inminer-logo\.jpeg'/)
  assert.match(component, /alt="Inmíner Ingeniería"/)
  assert.doesNotMatch(component, /https:\/\/inminer\.es/)
  assert.deepEqual([...image.subarray(0, 3)], [0xff, 0xd8, 0xff])
  assert.equal(
    createHash('sha256').update(image).digest('hex'),
    '971acbd7dfa269107ab7e79e510e03f671bbb0ac80505fcb2c29d7e43376449a',
  )
})
