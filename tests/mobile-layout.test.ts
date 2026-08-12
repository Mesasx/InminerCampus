import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'

const shell = readFileSync(
  new URL('../src/components/AppShell.tsx', import.meta.url),
  'utf8',
)
const authLayout = readFileSync(
  new URL('../src/components/AuthLayout.tsx', import.meta.url),
  'utf8',
)
const styles = readFileSync(
  new URL('../src/styles/app.css', import.meta.url),
  'utf8',
)

test('campus navigation remains available as an accessible mobile drawer', () => {
  assert.match(shell, /aria-controls="campus-navigation"/)
  assert.match(shell, /aria-expanded=\{navigationOpen\}/)
  assert.match(shell, /app-sidebar--open/)
  assert.match(shell, /event\.key === 'Escape'/)
  assert.match(styles, /\.app-topbar__menu[\s\S]*display: grid/)
  assert.match(styles, /\.app-sidebar--open[\s\S]*visibility: visible/)
})

test('mobile layouts cover learning, forms, certificates, and wide data', () => {
  assert.match(styles, /@media \(max-width: 680px\)/)
  assert.match(styles, /\.audio-player__controls input\[type='range'\]/)
  assert.match(styles, /\.audio-lesson__navigation \.button/)
  assert.match(styles, /\.lesson-pdf-modal__panel[\s\S]*100dvh/)
  assert.match(styles, /\.slide-deck__controls \.button/)
  assert.match(styles, /\.certificate-card \.button/)
  assert.match(styles, /\.data-table[\s\S]*min-width: 640px/)
  assert.match(styles, /font-size: 16px/)
})

test('authentication keeps its brand visible on mobile', () => {
  assert.match(authLayout, /className="auth-mobile-brand"/)
  assert.match(styles, /\.auth-mobile-brand[\s\S]*display: block/)
})
