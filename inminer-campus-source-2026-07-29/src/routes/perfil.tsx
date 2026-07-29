import { createFileRoute } from '@tanstack/react-router'
import { useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/perfil')({
  component: ProfilePage,
})

function ProfilePage() {
  return (
    <ProtectedGate>
      {(user) => <ProfileForm user={user} />}
    </ProtectedGate>
  )
}

function ProfileForm({ user }: { user: SessionUser }) {
  const [firstName, setFirstName] = useState(user.firstName)
  const [lastName, setLastName] = useState('')
  const [phone, setPhone] = useState('')
  const [message, setMessage] = useState('')

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void supabase
      .from('profiles')
      .select('first_name, last_name, phone')
      .eq('id', user.id)
      .maybeSingle()
      .then(({ data }) => {
        if (!data) return
        setFirstName(data.first_name)
        setLastName(data.last_name)
        setPhone(data.phone ?? '')
      })
  }, [user.id])

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setMessage('')
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('profiles')
        .update({
          first_name: firstName.trim(),
          last_name: lastName.trim(),
          phone: phone.trim() || null,
        })
        .eq('id', user.id)) ?? {}

    setMessage(
      error
        ? 'No hemos podido guardar los cambios.'
        : 'Tus datos se han actualizado.',
    )
  }

  return (
    <AppShell user={user} title="Perfil">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Datos personales</span>
          <h1>Tu perfil.</h1>
          <p>Actualiza únicamente la información necesaria para tu formación.</p>
        </div>
      </div>
      <section className="panel" style={{ maxWidth: 740 }}>
        <form className="form-grid" onSubmit={handleSubmit}>
          {message ? <div className="alert alert--info">{message}</div> : null}
          <div className="form-row">
            <div className="field">
              <label htmlFor="profile-first-name">Nombre</label>
              <input
                id="profile-first-name"
                required
                value={firstName}
                onChange={(event) => setFirstName(event.target.value)}
              />
            </div>
            <div className="field">
              <label htmlFor="profile-last-name">Apellidos</label>
              <input
                id="profile-last-name"
                required
                value={lastName}
                onChange={(event) => setLastName(event.target.value)}
              />
            </div>
          </div>
          <div className="field">
            <label htmlFor="profile-email">Correo</label>
            <input id="profile-email" disabled value={user.email} />
          </div>
          <div className="field">
            <label htmlFor="profile-phone">Teléfono</label>
            <input
              id="profile-phone"
              autoComplete="tel"
              value={phone}
              onChange={(event) => setPhone(event.target.value)}
            />
          </div>
          <button className="button button--primary" type="submit">
            Guardar cambios
          </button>
        </form>
      </section>
    </AppShell>
  )
}
