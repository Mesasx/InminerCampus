import { createFileRoute } from '@tanstack/react-router'
import { CircleHelp, MessageSquarePlus } from 'lucide-react'
import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/dudas')({
  component: SupportPage,
})

type Thread = {
  id: string
  subject: string
  status: string
  last_message_at: string
  created_at: string
}

function SupportPage() {
  return (
    <ProtectedGate>
      {(user) => <Support user={user} />}
    </ProtectedGate>
  )
}

function Support({ user }: { user: SessionUser }) {
  const [threads, setThreads] = useState<Thread[]>([])
  const [subject, setSubject] = useState('')
  const [body, setBody] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)

  const loadThreads = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const { data } = await supabase
      .from('support_threads')
      .select('id, subject, status, last_message_at, created_at')
      .eq('user_id', user.id)
      .order('last_message_at', { ascending: false })
    setThreads((data ?? []) as Thread[])
    setLoading(false)
  }, [user.id])

  useEffect(() => {
    void loadThreads()
  }, [loadThreads])

  async function createThread(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setMessage('')
    setSubmitting(true)
    const { error } =
      (await getSupabaseBrowserClient()?.rpc('create_support_thread', {
        p_subject: subject.trim(),
        p_body: body.trim(),
        p_enrollment_id: null,
        p_lesson_id: null,
      })) ?? {}
    setSubmitting(false)

    if (error) {
      setMessage('No se ha podido enviar la consulta.')
      return
    }

    setSubject('')
    setBody('')
    setMessage('Consulta enviada. Nuestro equipo podrá responder desde el panel.')
    await loadThreads()
  }

  return (
    <AppShell user={user} title="Dudas">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Soporte formativo</span>
          <h1>Tus consultas.</h1>
          <p>Plantea una duda y conserva el historial de respuesta.</p>
        </div>
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'minmax(0,1fr) minmax(340px,.72fr)',
          gap: 24,
          alignItems: 'start',
        }}
      >
        <section className="panel">
          <div className="panel__header">
            <h2>Historial</h2>
            <span className="status">{threads.length} consultas</span>
          </div>
          {loading ? (
            <p className="muted">Cargando consultas…</p>
          ) : threads.length ? (
            <div className="app-course-list">
              {threads.map((thread) => (
                <article className="app-course" key={thread.id}>
                  <span className="app-course__number">
                    <CircleHelp size={20} />
                  </span>
                  <div>
                    <h3>{thread.subject}</h3>
                    <p>
                      Actualizada{' '}
                      {new Date(thread.last_message_at).toLocaleDateString(
                        'es-ES',
                      )}
                    </p>
                  </div>
                  <span className="status">{thread.status}</span>
                  <a
                    className="button button--outline"
                    href={`/dudas/${thread.id}`}
                  >
                    Abrir
                  </a>
                </article>
              ))}
            </div>
          ) : (
            <div className="empty-state">
              <p>No has enviado ninguna consulta.</p>
            </div>
          )}
        </section>
        <section className="panel">
          <div className="panel__header">
            <h2>Nueva consulta</h2>
            <MessageSquarePlus color="var(--orange)" />
          </div>
          <form className="form-grid" onSubmit={createThread}>
            {message ? <div className="alert alert--info">{message}</div> : null}
            <div className="field">
              <label htmlFor="support-subject">Asunto</label>
              <input
                id="support-subject"
                minLength={3}
                maxLength={240}
                required
                value={subject}
                onChange={(event) => setSubject(event.target.value)}
              />
            </div>
            <div className="field">
              <label htmlFor="support-body">Consulta</label>
              <textarea
                id="support-body"
                maxLength={10000}
                required
                value={body}
                onChange={(event) => setBody(event.target.value)}
              />
            </div>
            <button
              className="button button--primary"
              disabled={submitting}
              type="submit"
            >
              {submitting ? 'Enviando…' : 'Enviar consulta'}
            </button>
          </form>
        </section>
      </div>
    </AppShell>
  )
}
