import { createHash } from 'node:crypto'
import { constants } from 'node:fs'
import { access, mkdir, readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'
import { classifyArchiveHash } from './archive-utils.ts'

type PendingInvoice = {
  id: string
  invoiceNumber: string
  year: number
  month: string
  issuedAt: string
  sha256: string
}

const apiUrl = required('INMINERCAMPUS_ARCHIVE_API_URL').replace(/\/+$/, '')
const token = required('ARCHIVE_AGENT_TOKEN')
const configuredRoot = required('INMINERCAMPUS_ARCHIVE_ROOT')
const archiveRoot = path.resolve(configuredRoot)
const pollMs = readPositiveInteger('INMINERCAMPUS_ARCHIVE_POLL_MS', 60_000)
const once = process.argv.includes('--once')

await assertArchiveRoot(archiveRoot)
log('agent', 'inicio', once ? 'ejecución única' : `polling ${pollMs} ms`)

do {
  try {
    await poll()
  } catch (error) {
    log('agent', 'error', safeError(error))
  }
  if (!once) await new Promise((resolve) => setTimeout(resolve, pollMs))
} while (!once)

async function poll() {
  const response = await apiFetch('/api/internal/archive/pending')
  if (!response.ok) throw new Error(`cola HTTP ${response.status}`)
  const payload = (await response.json()) as { invoices?: PendingInvoice[] }
  for (const invoice of payload.invoices ?? []) {
    try {
      await archiveInvoice(invoice)
    } catch (error) {
      const message = safeError(error)
      await reportFailure(invoice, message).catch(() => undefined)
      log(invoice.invoiceNumber, 'error', message)
    }
  }
}

async function archiveInvoice(invoice: PendingInvoice) {
  const directory = path.resolve(
    archiveRoot,
    'INMINERCAMPUS',
    String(invoice.year),
    invoice.month,
  )
  ensureInsideRoot(directory)
  await mkdir(directory, { recursive: true })

  const filename = `${safeFileName(invoice.invoiceNumber)}.pdf`
  const finalPath = path.resolve(directory, filename)
  ensureInsideRoot(finalPath)

  if (await exists(finalPath)) {
    const existingHash = sha256(await readFile(finalPath))
    if (classifyArchiveHash(invoice.sha256, existingHash) === 'conflict') {
      throw new Error('archivo existente con hash diferente')
    }
    await confirm(invoice, finalPath)
    log(invoice.invoiceNumber, 'confirmado', 'archivo existente idéntico')
    return
  }

  const response = await apiFetch(
    `/api/internal/archive/${encodeURIComponent(invoice.id)}/download`,
  )
  if (!response.ok) throw new Error(`descarga HTTP ${response.status}`)
  const bytes = new Uint8Array(await response.arrayBuffer())
  const downloadedHash = sha256(bytes)
  if (downloadedHash !== invoice.sha256) {
    throw new Error('SHA-256 descargado no coincide')
  }

  try {
    await writeFile(finalPath, bytes, { flag: 'wx' })
  } catch (error) {
    if (!(error instanceof Error && 'code' in error && error.code === 'EEXIST')) {
      throw error
    }
    const existingHash = sha256(await readFile(finalPath))
    if (classifyArchiveHash(invoice.sha256, existingHash) === 'conflict') {
      throw new Error('otro proceso creó un archivo con hash diferente')
    }
  }

  await confirm(invoice, finalPath)
  log(invoice.invoiceNumber, 'archivado', finalPath)
}

async function confirm(invoice: PendingInvoice, finalPath: string) {
  const response = await apiFetch(
    `/api/internal/archive/${encodeURIComponent(invoice.id)}/confirm`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sha256: invoice.sha256, path: finalPath }),
    },
  )
  if (!response.ok) throw new Error(`confirmación HTTP ${response.status}`)
}

async function reportFailure(invoice: PendingInvoice, error: string) {
  const response = await apiFetch(
    `/api/internal/archive/${encodeURIComponent(invoice.id)}/fail`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error }),
    },
  )
  if (!response.ok) throw new Error(`reporte de fallo HTTP ${response.status}`)
}

function apiFetch(endpoint: string, init: RequestInit = {}) {
  return fetch(`${apiUrl}${endpoint}`, {
    ...init,
    headers: {
      Authorization: `Bearer ${token}`,
      ...(init.headers ?? {}),
    },
    signal: AbortSignal.timeout(30_000),
  })
}

async function assertArchiveRoot(root: string) {
  if (path.parse(root).root === root) {
    throw new Error('INMINERCAMPUS_ARCHIVE_ROOT no puede ser la raíz de la unidad')
  }
  await mkdir(root, { recursive: true })
  await access(root, constants.R_OK | constants.W_OK)
}

function ensureInsideRoot(target: string) {
  const relative = path.relative(archiveRoot, target)
  if (relative.startsWith('..') || path.isAbsolute(relative)) {
    throw new Error('ruta de archivo fuera de la raíz configurada')
  }
}

function required(name: string): string {
  const value = process.env[name]?.trim()
  if (!value) throw new Error(`Falta ${name}`)
  return value
}

function readPositiveInteger(name: string, fallback: number): number {
  const value = Number(process.env[name] ?? fallback)
  return Number.isInteger(value) && value >= 5_000 ? value : fallback
}

function safeFileName(value: string): string {
  return value.replace(/[<>:"/\\|?*\u0000-\u001F]+/g, '-').slice(0, 160)
}

function sha256(bytes: Uint8Array): string {
  return createHash('sha256').update(bytes).digest('hex')
}

async function exists(filePath: string): Promise<boolean> {
  try {
    await access(filePath, constants.F_OK)
    return true
  } catch {
    return false
  }
}

function safeError(error: unknown): string {
  return error instanceof Error ? error.message.slice(0, 300) : 'error desconocido'
}

function log(invoice: string, action: string, result: string) {
  console.log(`${new Date().toISOString()} invoice=${invoice} action=${action} result=${result}`)
}
