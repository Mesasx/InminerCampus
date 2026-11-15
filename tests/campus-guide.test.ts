import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const read = (path: string) => readFile(path, 'utf8')

test('la portada explica el acceso supervisado sin vídeo comercial', async () => {
  const [home, hero] = await Promise.all([
    read('src/routes/index.tsx'),
    read('src/components/Hero.tsx'),
  ])

  assert.match(home, /id="guia-campus"/)
  assert.doesNotMatch(home, /<video|guia-inminer-campus\.mp4|Compra un curso/)
  assert.match(home, /Solicita una cuenta/)
  assert.match(home, /Espera la validación humana/)
  assert.match(home, /Solicita información/)
  assert.match(hero, /campus-hero__guide/)
  assert.match(hero, /scrollIntoView/)
})

test('la guía enlaza a todos los puntos de entrada del alumno', async () => {
  const home = await read('src/routes/index.tsx')

  for (const route of ['/registro', '/acceso', '/catalogo', '/contacto']) {
    assert.match(home, new RegExp(`to="${route}"`))
  }
})
