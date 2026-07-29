import { createFileRoute, Link } from '@tanstack/react-router'
import { Send } from 'lucide-react'
import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/dudas/$threadId')({
  component: ThreadPage,
})

type Message = {
  id: string
  sender_user_id: string
  body: string
  created_at: string
}

function ThreadPage() {
  const { threadId } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => <Thread user={user} threadId={threadId} />}
    </ProtectedGate>
  )
}

function Thread({
  user,
  threadId,
}: {
  user: SessionUser
  threadId: string
}) {
  const [subject, setSubject] = useState('')
  const [status, setStatus] = useState('')
  const [messages, setMessages] = useState<Message[]>([])
  const [reply, setReply] = useState('')

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [{ data: thread }, { data: messageRows }] = await Promise.all([
      supabase
        .from('support_threads')
        .select('subject, status')
        .eq('id', threadId)
        .maybeSingle(),
      supabase
        .from('support_messages')
        .select('id, sender_user_id, body, created_at')
        .eq('thread_id', threadId)
        .order('created_at'),
    ])
    setSubject(thread?.subject ?? '')
    setStatus(thread?.status ?? '')
    setMessages((messageRows ?? []) as Message[])
  }, [threadId])

  useEffect(() => {
    void load()
  }, [load])

  async function sendReply(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const supabase = getSupabaseBrowserClient()
    if (!supabase || !reply.trim()) return
    const { error } = await supabase.from('support_messages').insert({
      thread_id: threadId,
      sender_user_id: user.id,
      body: reply.trim(),
    })
    if (!error) {
      setReply('')
      await load()
    }
  }

  return (
    <AppShell user={user} title="Detalle de consulta">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Consulta · {status}</span>
          <h1>{subject || 'Consulta'}</h1>
        </div>
        <Link className="button button--outline" to="/dudas">
          Volver
        </Link>
      </div>
      <section className="panel" style={{ maxWidth: 850 }}>
        <div className="form-grid">
          {messages.map((message) => {
            const own = message.sender_user_id === user.id
            return (
              <article
                key={message.id}
                style={{
                  maxWidth: '82%',
                  marginLeft: own ? 'auto' : 0,
                  borderRadius: 12,
                  padding: 16,
                  background: own ? 'var(--orange-soft)' : 'var(--surface-soft)',
                }}
              >
                <p style={{ whiteSpace: 'pre-wrap', marginBottom: 8 }}>
                  {message.body}
                </p>
                <small className="muted">
                  {new Date(message.created_at).toLocaleString('es-ES')}
                </small>
              </article>
            )
          })}
          {status !== 'closed' ? (
            <form className="form-grid" onSubmit={sendReply}>
              <div className="field">
                <label htmlFor="thread-reply">Responder</label>
                <textarea
                  id="thread-reply"
                  required
                  value={reply}
                  onChange={(event) => setReply(event.target.value)}
                />
              </div>
              <button className="button button--primary" type="submit">
                <Send size={17} /> Enviar respuesta
              </button>
            </form>
          ) : null}
        </div>
      </section>
    </AppShell>
  )
}
