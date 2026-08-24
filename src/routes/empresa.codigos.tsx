import { createFileRoute } from '@tanstack/react-router'
import { Check, Copy, Eye, KeyRound, RefreshCw } from 'lucide-react'
import { useCallback, useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { formatCents } from '../lib/billing'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/empresa/codigos')({ component: CompanyCodesPage })

type License = {
  id: string
  givenName: string
  familyName: string
  email: string
  maskedCode: string
  licenseStatus: string
  deliveryStatus: string
  emailSentAt: string | null
  lastError: string | null
  redeemedAt: string | null
  orderNumber: string
  paidAt: string
  totalAmountCents: number
  currency: string
  discountBasisPoints: number
  courseTitle: string
  quantity: number
  enrollmentStatus: string | null
  progressPercent: number | null
  completedAt: string | null
  certificateIssued: boolean
}

function CompanyCodesPage() {
  return <ProtectedGate>{(user) => <CompanyLicenses user={user} />}</ProtectedGate>
}

function CompanyLicenses({ user }: { user: SessionUser }) {
  const [licenses, setLicenses] = useState<License[]>([])
  const [revealed, setRevealed] = useState<Record<string, string>>({})
  const [busy, setBusy] = useState('')
  const [message, setMessage] = useState('')

  const request = useCallback(async (body?: object) => {
    const { data } = (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
    const token = data?.session?.access_token
    if (!token) throw new Error('Tu sesión ha caducado.')
    return fetch('/api/company-licenses', {
      method: body ? 'POST' : 'GET',
      headers: { Authorization: `Bearer ${token}`, ...(body ? { 'Content-Type': 'application/json' } : {}) },
      body: body ? JSON.stringify(body) : undefined,
    })
  }, [])

  const load = useCallback(async () => {
    try {
      const response = await request()
      const payload = (await response.json()) as { licenses?: License[]; error?: string }
      if (!response.ok) throw new Error(payload.error)
      setLicenses(payload.licenses ?? [])
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'No se han podido cargar las licencias.')
    }
  }, [request])

  useEffect(() => { void load() }, [load])

  async function reveal(license: License) {
    setBusy(license.id); setMessage('')
    try {
      const response = await request({ action: 'reveal', recipientId: license.id })
      const payload = (await response.json()) as { code?: string; error?: string }
      if (!response.ok || !payload.code) throw new Error(payload.error)
      setRevealed((current) => ({ ...current, [license.id]: payload.code! }))
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'No se ha podido mostrar el código.')
    } finally { setBusy('') }
  }

  async function retry(license: License) {
    setBusy(license.id); setMessage('')
    try {
      const response = await request({ action: 'retry', recipientId: license.id })
      const payload = (await response.json()) as { error?: string }
      if (!response.ok) throw new Error(payload.error)
      setMessage(`Correo reenviado a ${license.email}.`)
      await load()
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'No se ha podido reenviar.')
    } finally { setBusy('') }
  }

  async function copy(license: License) {
    const code = revealed[license.id]
    if (!code) return
    await navigator.clipboard.writeText(code)
    setMessage('Código copiado de forma segura.')
  }

  return (
    <AppShell user={user} mode="company" title="Licencias">
      <div className="dashboard-heading"><div><span className="eyebrow">Formación corporativa</span><h1>Licencias.</h1><p>Consulta cada asignación sin exponer masivamente los códigos.</p></div></div>
      {message ? <div className="alert alert--info" style={{ marginBottom: 20 }}>{message}</div> : null}
      <section className="panel">
        <div className="panel__header"><h2>Personas y accesos</h2><span className="status status--orange">{licenses.length} licencias</span></div>
        {licenses.length ? <div className="license-list">{licenses.map((license) => (
          <article className="license-card" key={license.id}>
            <div className="license-card__person"><span className="app-course__number"><KeyRound size={18} /></span><div><h3>{license.givenName} {license.familyName}</h3><p title={license.email}>{license.email}</p><small>{license.courseTitle} · Pedido {license.orderNumber}</small></div></div>
            <div className="license-card__code"><code>{revealed[license.id] ?? license.maskedCode}</code><div className="license-card__actions">{revealed[license.id] ? <button aria-label="Copiar código" className="button button--outline" onClick={() => void copy(license)} type="button"><Copy size={16} /> Copiar</button> : <button className="button button--outline" disabled={busy === license.id || license.maskedCode === 'Pendiente'} onClick={() => void reveal(license)} type="button"><Eye size={16} /> Mostrar</button>}</div></div>
            <div className="license-card__status"><span className={`status ${license.licenseStatus === 'used' ? 'status--green' : 'status--orange'}`}>{license.licenseStatus === 'used' ? <><Check size={14} /> Canjeada</> : 'Sin canjear'}</span><span className={`status ${license.deliveryStatus === 'sent' ? 'status--green' : ''}`}>{license.deliveryStatus === 'sent' ? <><Check size={14} /> Email enviado</> : 'Error al enviar'}</span>{license.enrollmentStatus ? <span className={`status ${license.enrollmentStatus === 'completed' ? 'status--green' : ''}`}>{license.enrollmentStatus === 'completed' ? 'Formación completada' : `Progreso ${Math.round(Number(license.progressPercent ?? 0))} %`}</span> : null}{license.certificateIssued ? <span className="status status--green"><Check size={14} /> Certificado emitido</span> : null}{license.deliveryStatus === 'failed' ? <button className="text-link button-reset" disabled={busy === license.id} onClick={() => void retry(license)} type="button"><RefreshCw size={14} /> Reintentar</button> : null}</div>
            <div className="license-card__purchase"><small>{new Intl.DateTimeFormat('es-ES', { dateStyle: 'medium' }).format(new Date(license.paidAt))}</small><strong>{formatCents(license.totalAmountCents, license.currency)}</strong>{license.discountBasisPoints ? <span>{license.discountBasisPoints / 100} % dto.</span> : null}</div>
          </article>
        ))}</div> : <div className="empty-state"><p>Todavía no hay licencias automáticas en pedidos pagados.</p></div>}
      </section>
    </AppShell>
  )
}
