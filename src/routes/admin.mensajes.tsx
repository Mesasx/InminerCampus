import { createFileRoute } from '@tanstack/react-router'
import {
  CheckCheck,
  Inbox,
  MessageSquareReply,
  RefreshCw,
  Send,
} from 'lucide-react'
import {
  useCallback,
  useEffect,
  useMemo,
  useState,
  type FormEvent,
} from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/mensajes')({
  component: AdminMessagesPage,
})

type Thread = {
  id: string
  user_id: string
  subject: string
  status: string
  last_message_at: string
  assigned_tutor_id: string | null
}

type Message = {
  id: string
  sender_user_id: string
  body: string
  created_at: string
}

type Sender = {
  id: string
  email: string | null
  first_name: string
  last_name: string
}

function AdminMessagesPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminMessages user={user} />}
    </ProtectedGate>
  )
}

function AdminMessages({ user }: { user: SessionUser }) {
  const [threads, setThreads] = useState<Thread[]>([])
  const [senders, setSenders] = useState<Sender[]>([])
  const [messages, setMessages] = useState<Message[]>([])
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [reply, setReply] = useState('')
  const [notice, setNotice] = useState('')
  const [sending, setSending] = useState(false)

  const loadThreads = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [{ data: threadRows }, { data: profileRows }] = await Promise.all([
      supabase
        .from('support_threads')
        .select(
          'id, user_id, subject, status, last_message_at, assigned_tutor_id',
        )
        .order('last_message_at', { ascending: false }),
      supabase
        .from('profiles')
        .select('id, email, first_name, last_name'),
    ])
    const nextThreads = (threadRows ?? []) as Thread[]
    setThreads(nextThreads)
    setSenders((profileRows ?? []) as Sender[])
    setSelectedId((current) =>
      current && nextThreads.some((thread) => thread.id === current)
        ? current
        : nextThreads[0]?.id ?? null,
    )
  }, [])

  const loadMessages = useCallback(async (threadId: string) => {
    const { data } =
      (await getSupabaseBrowserClient()
        ?.from('support_messages')
        .select('id, sender_user_id, body, created_at')
        .eq('thread_id', threadId)
        .order('created_at', { ascending: true })) ?? {}
    setMessages((data ?? []) as Message[])
  }, [])

  useEffect(() => {
    void loadThreads()
  }, [loadThreads])

  useEffect(() => {
    if (selectedId) void loadMessages(selectedId)
    else setMessages([])
  }, [loadMessages, selectedId])

  const selected = threads.find((thread) => thread.id === selectedId)
  const senderMap = useMemo(
    () => new Map(senders.map((sender) => [sender.id, sender])),
    [senders],
  )

  async function answer(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!selected || !reply.trim()) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    setSending(true)
    const { error } = await supabase.from('support_messages').insert({
      thread_id: selected.id,
      sender_user_id: user.id,
      body: reply.trim(),
    })
    if (!error) {
      await supabase
        .from('support_threads')
        .update({
          assigned_tutor_id: user.id,
          status: 'answered',
          closed_at: null,
        })
        .eq('id', selected.id)
    }
    setSending(false)
    setNotice(
      error ? 'No se ha podido enviar la respuesta.' : 'Respuesta enviada.',
    )
    if (!error) {
      setReply('')
      await Promise.all([loadThreads(), loadMessages(selected.id)])
    }
  }

  async function setThreadStatus(status: 'in_review' | 'closed') {
    if (!selected) return
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('support_threads')
        .update({
          status,
          assigned_tutor_id: user.id,
          closed_at: status === 'closed' ? new Date().toISOString() : null,
        })
        .eq('id', selected.id)) ?? {}
    setNotice(
      error
        ? 'No se ha podido actualizar la consulta.'
        : status === 'closed'
          ? 'Consulta cerrada.'
          : 'Consulta asignada y en revisión.',
    )
    if (!error) await loadThreads()
  }

  return (
    <AppShell user={user} mode="admin" title="Bandeja de entrada">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Soporte y seguimiento</span>
          <h1>Bandeja de entrada.</h1>
          <p>Recibe las consultas de los alumnos y responde con su historial.</p>
        </div>
        <button
          className="button button--outline"
          onClick={loadThreads}
          type="button"
        >
          <RefreshCw size={18} /> Actualizar
        </button>
      </div>
      {notice ? <div className="alert alert--info">{notice}</div> : null}
      <div className="admin-inbox">
        <section className="panel admin-inbox__threads">
          <div className="panel__header">
            <h2>Conversaciones</h2>
            <span className="status">
              {
                threads.filter((thread) =>
                  ['new', 'in_review'].includes(thread.status),
                ).length
              }{' '}
              pendientes
            </span>
          </div>
          {threads.length ? (
            <div className="admin-list">
              {threads.map((thread) => {
                const sender = senderMap.get(thread.user_id)
                return (
                  <button
                    className={
                      selectedId === thread.id
                        ? 'admin-list__item is-active'
                        : 'admin-list__item'
                    }
                    key={thread.id}
                    onClick={() => setSelectedId(thread.id)}
                    type="button"
                  >
                    <span className="app-course__number">
                      <Inbox size={18} />
                    </span>
                    <span>
                      <strong>{thread.subject}</strong>
                      <small>
                        {sender?.email ||
                          [sender?.first_name, sender?.last_name]
                            .filter(Boolean)
                            .join(' ') ||
                          'Alumno'}
                      </small>
                    </span>
                    <span className="status">{thread.status}</span>
                  </button>
                )
              })}
            </div>
          ) : (
            <div className="empty-state">
              <Inbox size={36} color="var(--orange)" />
              <p>No hay mensajes todavía.</p>
            </div>
          )}
        </section>

        <section className="panel admin-inbox__conversation">
          {selected ? (
            <>
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Conversación</span>
                  <h2>{selected.subject}</h2>
                </div>
                <MessageSquareReply color="var(--orange)" />
              </div>
              <div className="support-conversation">
                {messages.map((message) => {
                  const mine = message.sender_user_id === user.id
                  const sender = senderMap.get(message.sender_user_id)
                  return (
                    <article
                      className={
                        mine
                          ? 'support-message is-staff'
                          : 'support-message'
                      }
                      key={message.id}
                    >
                      <strong>
                        {mine
                          ? 'Equipo Inmíner'
                          : [sender?.first_name, sender?.last_name]
                              .filter(Boolean)
                              .join(' ') || 'Alumno'}
                      </strong>
                      <p>{message.body}</p>
                      <small>
                        {new Date(message.created_at).toLocaleString('es-ES')}
                      </small>
                    </article>
                  )
                })}
              </div>
              <form className="form-grid" onSubmit={answer}>
                <div className="field">
                  <label htmlFor="admin-reply">Respuesta</label>
                  <textarea
                    id="admin-reply"
                    maxLength={10000}
                    required
                    value={reply}
                    onChange={(event) => setReply(event.target.value)}
                    placeholder="Escribe una respuesta clara para el alumno…"
                  />
                </div>
                <div className="content-editor__actions">
                  <button
                    className="button button--primary"
                    disabled={sending}
                    type="submit"
                  >
                    <Send size={17} />{' '}
                    {sending ? 'Enviando…' : 'Enviar respuesta'}
                  </button>
                  <button
                    className="button button--outline"
                    onClick={() => setThreadStatus('in_review')}
                    type="button"
                  >
                    Asignarme
                  </button>
                  <button
                    className="button button--ghost"
                    onClick={() => setThreadStatus('closed')}
                    type="button"
                  >
                    <CheckCheck size={17} /> Cerrar consulta
                  </button>
                </div>
              </form>
            </>
          ) : (
            <div className="empty-state">
              <p>Selecciona una conversación para responder.</p>
            </div>
          )}
        </section>
      </div>
    </AppShell>
  )
}
