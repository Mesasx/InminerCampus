import assert from 'node:assert/strict'
import test from 'node:test'
import { canAccessInvoiceIdentity } from '../src/server/billing/invoice-access.ts'

test('el propietario puede acceder y otro usuario no', () => {
  assert.equal(
    canAccessInvoiceIdentity({
      userId: 'user-a',
      buyerUserId: 'user-a',
      isStaff: false,
      isOrganizationManager: false,
    }),
    true,
  )
  assert.equal(
    canAccessInvoiceIdentity({
      userId: 'user-b',
      buyerUserId: 'user-a',
      isStaff: false,
      isOrganizationManager: false,
    }),
    false,
  )
})

test('solo el responsable de la organización vinculada obtiene acceso', () => {
  assert.equal(
    canAccessInvoiceIdentity({
      userId: 'manager-a',
      buyerUserId: 'buyer',
      isStaff: false,
      isOrganizationManager: true,
    }),
    true,
  )
  assert.equal(
    canAccessInvoiceIdentity({
      userId: 'manager-b',
      buyerUserId: 'buyer',
      isStaff: false,
      isOrganizationManager: false,
    }),
    false,
  )
})
