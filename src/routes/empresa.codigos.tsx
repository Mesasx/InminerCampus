import { createFileRoute } from '@tanstack/react-router'
import { Download, KeyRound } from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/empresa/codigos')({
  component: CompanyCodesPage,
})

type PaidItem = {
  id: string
  quantity: number
  courseTitle: string
  generated: number
}

function CompanyCodesPage() {
  return (
    <ProtectedGate roles={['responsable_empresa', 'superadministrador']}>
      {(user) => <CompanyCodes user={user} />}
    </ProtectedGate>
  )
}

function CompanyCodes({ user }: { user: SessionUser }) {
  const [items, setItems] = useState<PaidItem[]>([])
  const [generatedCodes, setGeneratedCodes] = useState<string[]>([])
  const [message, setMessage] = useState('')
  const [loadingItem, setLoadingItem] = useState('')

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void supabase
      .from('purchase_items')
      .select(
        'id, quantity, purchases!inner(kind, status, organization_id), course_versions!inner(courses!inner(title)), access_codes(id)',
      )
      .eq('purchases.kind', 'company')
      .eq('purchases.status', 'paid')
      .then(({ data }) => {
        const rows = (data ?? []) as unknown as Array<{
          id: string
          quantity: number
          course_versions: { courses: { title: string } }
          access_codes: Array<{ id: string }>
        }>
        setItems(
          rows.map((row) => ({
            id: row.id,
            quantity: row.quantity,
            courseTitle: row.course_versions.courses.title,
            generated: row.access_codes.length,
          })),
        )
      })
  }, [])

  async function generate(itemId: string) {
    setLoadingItem(itemId)
    setMessage('')
    setGeneratedCodes([])
    const { data } =
      (await getSupabaseBrowserClient()?.auth.getSession()) ?? { data: null }
    const accessToken = data?.session?.access_token
    if (!accessToken) return

    const response = await fetch('/api/company-access-codes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({ purchaseItemId: itemId }),
    })
    const payload = (await response.json()) as {
      codes?: string[]
      error?: string
    }
    setLoadingItem('')
    if (!response.ok || !payload.codes) {
      setMessage(payload.error ?? 'No se han podido generar los códigos.')
      return
    }
    setGeneratedCodes(payload.codes)
    setMessage(
      'Guarda o exporta ahora los códigos: el valor completo no volverá a mostrarse.',
    )
  }

  function downloadCsv() {
    const csv = ['codigo', ...generatedCodes].join('\n')
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `codigos-inminercampus-${new Date().toISOString().slice(0, 10)}.csv`
    link.click()
    URL.revokeObjectURL(url)
  }

  return (
    <AppShell user={user} mode="company" title="Códigos">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Plazas empresariales</span>
          <h1>Códigos de acceso.</h1>
          <p>Únicos, de un solo uso y asociados al curso comprado.</p>
        </div>
      </div>
      {message ? (
        <div className="alert alert--info" style={{ marginBottom: 20 }}>
          {message}
        </div>
      ) : null}
      {generatedCodes.length ? (
        <section className="panel" style={{ marginBottom: 24 }}>
          <div className="panel__header">
            <h2>Lote recién generado</h2>
            <button
              className="button button--primary"
              onClick={downloadCsv}
              type="button"
            >
              <Download size={17} /> Descargar CSV
            </button>
          </div>
          <div className="form-grid">
            {generatedCodes.map((code) => (
              <code className="stat-card" key={code}>
                {code}
              </code>
            ))}
          </div>
        </section>
      ) : null}
      <section className="panel">
        <div className="panel__header">
          <h2>Pedidos pagados</h2>
        </div>
        {items.length ? (
          <div className="app-course-list">
            {items.map((item) => (
              <article className="app-course" key={item.id}>
                <span className="app-course__number">
                  <KeyRound size={20} />
                </span>
                <div>
                  <h3>{item.courseTitle}</h3>
                  <p>
                    {item.generated} de {item.quantity} códigos generados
                  </p>
                </div>
                <div className="progress">
                  <div
                    className="progress__bar"
                    style={{
                      width: `${(item.generated / item.quantity) * 100}%`,
                    }}
                  />
                </div>
                <button
                  className="button button--outline"
                  disabled={
                    item.generated >= item.quantity || loadingItem === item.id
                  }
                  onClick={() => void generate(item.id)}
                  type="button"
                >
                  {loadingItem === item.id ? 'Generando…' : 'Generar pendientes'}
                </button>
              </article>
            ))}
          </div>
        ) : (
          <div className="empty-state">
            <p>No hay pedidos empresariales pagados con plazas pendientes.</p>
          </div>
        )}
      </section>
    </AppShell>
  )
}
