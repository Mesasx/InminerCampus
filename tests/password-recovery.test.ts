import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const recoveryPage = await readFile(
  'src/routes/recuperar-contrasena.tsx',
  'utf8',
)
const newPasswordPage = await readFile(
  'src/routes/nueva-contrasena.tsx',
  'utf8',
)
const publicRoutes = await readFile('src/lib/public-routes.ts', 'utf8')

test('el correo vuelve al mismo dominio desde el que se solicita', () => {
  assert.match(recoveryPage, /window\.location\.origin/)
  assert.match(recoveryPage, /\/nueva-contrasena/)
  assert.doesNotMatch(
    recoveryPage,
    /redirectTo:\s*`\$\{appConfig\.appUrl\}\/nueva-contrasena`/,
  )
})

test('la nueva contraseña exige sesión válida y confirmación', () => {
  assert.match(newPasswordPage, /onAuthStateChange/)
  assert.match(newPasswordPage, /PASSWORD_RECOVERY/)
  assert.match(newPasswordPage, /getSession\(\)/)
  assert.match(newPasswordPage, /password !== passwordConfirmation/)
  assert.match(newPasswordPage, /updateUser\(\{ password \}\)/)
})

test('las dos pantallas de recuperación siguen siendo públicas', () => {
  assert.match(publicRoutes, /'\/recuperar-contrasena'/)
  assert.match(publicRoutes, /'\/nueva-contrasena'/)
})
