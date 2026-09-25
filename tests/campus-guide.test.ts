import assert from 'node:assert/strict'
import { readFile, stat } from 'node:fs/promises'
import test from 'node:test'

const read = (path: string) => readFile(path, 'utf8')

test('la portada incorpora la guía de acceso en vídeo y por escrito', async () => {
  const [home, hero, captions, video] = await Promise.all([
    read('src/routes/index.tsx'),
    read('src/components/Hero.tsx'),
    read('public/videos/guia-inminer-campus-es.vtt'),
    stat('public/videos/guia-inminer-campus.mp4'),
  ])

  assert.match(home, /id="guia-campus"/)
  assert.match(home, /guia-inminer-campus\.mp4/)
  assert.match(home, /kind="captions"/)
  assert.match(home, /Crea tu cuenta/)
  assert.match(home, /Canjea el código de tu empresa/)
  assert.match(home, /Compra un curso/)
  assert.match(home, /Supera los test/)
  assert.match(home, /Descarga materiales y certificado/)
  assert.match(hero, /campus-hero__guide/)
  assert.match(hero, /scrollIntoView/)
  assert.match(captions, /^WEBVTT/)
  assert.ok(video.size > 1_000_000, 'el vídeo publicado no debe estar vacío')
  assert.ok(video.size < 30_000_000, 'el vídeo web debe mantenerse optimizado')
})

test('la guía enlaza a todos los puntos de entrada del alumno', async () => {
  const home = await read('src/routes/index.tsx')

  for (const route of [
    '/registro',
    '/acceso',
    '/canjear-codigo',
    '/catalogo',
    '/certificados',
  ]) {
    assert.match(home, new RegExp(`to="${route}"`))
  }
})
