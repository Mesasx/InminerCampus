import { createCipheriv, createDecipheriv, randomBytes } from 'node:crypto'

export const ACCESS_CODE_ENCRYPTION_VERSION = 1

export type EncryptedAccessCode = {
  encryption_version: number
  ciphertext: string
  iv: string
  auth_tag: string
}

function encryptionKey(): Buffer {
  const encoded = process.env.COMPANY_ACCESS_CODE_ENCRYPTION_KEY?.trim()
  if (!encoded) throw new Error('Company access-code encryption is missing')
  const key = Buffer.from(encoded, 'base64')
  if (key.length !== 32) {
    throw new Error('Company access-code encryption key must be 32 bytes')
  }
  return key
}

export function encryptAccessCode(plaintext: string): EncryptedAccessCode {
  const iv = randomBytes(12)
  const cipher = createCipheriv('aes-256-gcm', encryptionKey(), iv)
  cipher.setAAD(Buffer.from(`inminercampus-access-code:v${ACCESS_CODE_ENCRYPTION_VERSION}`))
  const ciphertext = Buffer.concat([
    cipher.update(plaintext, 'utf8'),
    cipher.final(),
  ])
  return {
    encryption_version: ACCESS_CODE_ENCRYPTION_VERSION,
    ciphertext: ciphertext.toString('base64'),
    iv: iv.toString('base64'),
    auth_tag: cipher.getAuthTag().toString('base64'),
  }
}

export function decryptAccessCode(secret: EncryptedAccessCode): string {
  if (secret.encryption_version !== ACCESS_CODE_ENCRYPTION_VERSION) {
    throw new Error('Unsupported access-code encryption version')
  }
  const decipher = createDecipheriv(
    'aes-256-gcm',
    encryptionKey(),
    Buffer.from(secret.iv, 'base64'),
  )
  decipher.setAAD(Buffer.from(`inminercampus-access-code:v${secret.encryption_version}`))
  decipher.setAuthTag(Buffer.from(secret.auth_tag, 'base64'))
  return Buffer.concat([
    decipher.update(Buffer.from(secret.ciphertext, 'base64')),
    decipher.final(),
  ]).toString('utf8')
}

