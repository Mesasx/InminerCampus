import assert from 'node:assert/strict'
import test from 'node:test'
import type { SupabaseClient } from '@supabase/supabase-js'
import {
  __clearSignedUrlCacheForTests,
  resolveSignedUrls,
} from '../src/lib/signed-url-cache.ts'

function fakeClient(
  sign: (paths: string[]) => { path: string; signedUrl: string | null }[],
) {
  let calls = 0
  const client = {
    storage: {
      from(bucket: string) {
        return {
          async createSignedUrls(paths: string[], _expiresIn: number) {
            calls += 1
            void bucket
            return { data: sign(paths), error: null }
          },
        }
      },
    },
  } as unknown as SupabaseClient
  return { client, callCount: () => calls }
}

test('agrupa todas las rutas en una única llamada a createSignedUrls', async () => {
  __clearSignedUrlCacheForTests()
  const { client, callCount } = fakeClient((paths) =>
    paths.map((path) => ({ path, signedUrl: `https://signed.example/${path}` })),
  )

  const urls = await resolveSignedUrls(client, 'course-materials', [
    'a/1.jpg',
    'a/2.jpg',
    'a/3.pdf',
  ])

  assert.equal(callCount(), 1)
  assert.equal(urls['a/1.jpg'], 'https://signed.example/a/1.jpg')
  assert.equal(urls['a/2.jpg'], 'https://signed.example/a/2.jpg')
  assert.equal(urls['a/3.pdf'], 'https://signed.example/a/3.pdf')
})

test('ignora rutas nulas y duplicadas antes de firmar', async () => {
  __clearSignedUrlCacheForTests()
  const seenPaths: string[][] = []
  const { client } = fakeClient((paths) => {
    seenPaths.push(paths)
    return paths.map((path) => ({ path, signedUrl: `https://signed.example/${path}` }))
  })

  await resolveSignedUrls(client, 'course-materials', [
    'a/1.jpg',
    'a/1.jpg',
    null,
    undefined,
    'a/2.jpg',
  ])

  assert.deepEqual(seenPaths, [['a/1.jpg', 'a/2.jpg']])
})

test('sirve desde caché mientras la URL siga vigente, sin volver a llamar a Supabase', async () => {
  __clearSignedUrlCacheForTests()
  const { client, callCount } = fakeClient((paths) =>
    paths.map((path) => ({ path, signedUrl: `https://signed.example/${path}` })),
  )

  const first = await resolveSignedUrls(client, 'course-materials', ['a/1.jpg'])
  const second = await resolveSignedUrls(client, 'course-materials', ['a/1.jpg'])

  assert.equal(callCount(), 1)
  assert.equal(first['a/1.jpg'], second['a/1.jpg'])
})

test('si falla la renovación, conserva la última URL firmada en vez de dejar el hueco vacío', async () => {
  __clearSignedUrlCacheForTests()
  let attempt = 0
  const { client } = fakeClient((paths) => {
    attempt += 1
    if (attempt === 1) {
      return paths.map((path) => ({ path, signedUrl: `https://signed.example/${path}?try=1` }))
    }
    // Segundo intento (tras caducar la caché): la firma falla.
    return paths.map((path) => ({ path, signedUrl: null }))
  })

  const first = await resolveSignedUrls(client, 'course-materials', ['a/1.jpg'], -1)
  assert.equal(first['a/1.jpg'], 'https://signed.example/a/1.jpg?try=1')

  const second = await resolveSignedUrls(client, 'course-materials', ['a/1.jpg'], -1)
  assert.equal(second['a/1.jpg'], 'https://signed.example/a/1.jpg?try=1')
})
