import { createFileRoute, Link, useNavigate } from '@tanstack/react-router'
import { Award, BookOpen, LogOut, ReceiptText } from 'lucide-react'
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
  const navigate = useNavigate()
  const [firstName, setFirstName] = useState(user.firstName)
  const [lastName, setLastName] = useState('')
  const [phone, setPhone] = useState('')
  const [dni, setDni] = useState('')
  const [message, setMessage] = useState('')
  const [nameLocked, setNameLocked] = useState(false)
  const [dniLocked, setDniLocked] = useState(false)
  const initials = (
    firstName?.[0] ||
    user.email[0] ||
    '?'
  ).toUpperCase()

  async function signOut() {
    await getSupabaseBrowserClient()?.auth.signOut()
    await navigate({ to: '/', replace: true })
  }

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    void supabase
      .from('profiles')
      .select('first_name, last_name, phone, dni')
      .eq('id', user.id)
      .maybeSingle()
      .then(({ data }) => {
        if (!data) return
        setFirstName(data.first_name)
        setLastName(data.last_name)
        setPhone(data.phone ?? '')
        setDni(data.dni ?? '')
        setNameLocked(Boolean(data.first_name?.trim() && data.last_name?.trim()))
        setDniLocked(Boolean(data.dni?.trim()))
      })
  }, [user.id])

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setMessage('')
    const trimmedDni = dni.trim().toUpperCase()
    if (trimmedDni && !/^[0-9XYZ][0-9]{7}[A-Z]$/.test(trimmedDni)) {
      setMessage('El DNI/NIE no tiene un formato válido.')
      return
    }
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('profiles')
        .update({
          first_name: firstName.trim(),
          last_name: lastName.trim(),
          phone: phone.trim() || null,
          dni: trimmedDni || null,
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
      <div className="profile-header">
        <span className="profile-header__avatar">{initials}</span>
        <div>
          <span className="label-industrial">Mi cuenta</span>
          <h1>{firstName ? `${firstName} ${lastName}`.trim() : 'Tu perfil'}</h1>
          <p>{user.email}</p>
        </div>
        <button className="button button--outline" onClick={signOut} type="button">
          <LogOut size={16} /> Cerrar sesión
        </button>
      </div>

      <div className="profile-links">
        <Link className="profile-link-card" to="/mis-cursos">
          <BookOpen size={22} />
          <div>
            <strong>Mis cursos</strong>
            <span>Progreso y acceso a tu formación activa</span>
          </div>
        </Link>
        <Link className="profile-link-card" to="/certificados">
          <Award size={22} />
          <div>
            <strong>Certificados</strong>
            <span>Descarga los certificados ya emitidos</span>
          </div>
        </Link>
        <Link className="profile-link-card" to="/facturas">
          <ReceiptText size={22} />
          <div>
            <strong>Facturas</strong>
            <span>Estado y descarga de tus facturas</span>
          </div>
        </Link>
      </div>

      <section className="panel" style={{ maxWidth: 740 }}>
        <div className="panel__header">
          <h2>Datos personales</h2>
        </div>
        <form className="form-grid" onSubmit={handleSubmit}>
          {message ? <div className="alert alert--info">{message}</div> : null}
          <div className="form-row">
            <div className="field">
              <label htmlFor="profile-first-name">Nombre</label>
              <input
                id="profile-first-name"
                required
                disabled={nameLocked}
                value={firstName}
                onChange={(event) => setFirstName(event.target.value)}
              />
              <span className="muted">
                {nameLocked
                  ? 'Este dato ya está guardado y no se puede modificar.'
                  : 'No podrás cambiarlo una vez lo guardes.'}
              </span>
            </div>
            <div className="field">
              <label htmlFor="profile-last-name">Apellidos</label>
              <input
                id="profile-last-name"
                required
                disabled={nameLocked}
                value={lastName}
                onChange={(event) => setLastName(event.target.value)}
              />
              <span className="muted">
                {nameLocked
                  ? 'Este dato ya está guardado y no se puede modificar.'
                  : 'No podrás cambiarlo una vez lo guardes.'}
              </span>
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
          <div className="field">
            <label htmlFor="profile-dni">DNI / NIE</label>
            <input
              id="profile-dni"
              placeholder="12345678Z"
              disabled={dniLocked}
              value={dni}
              onChange={(event) => setDni(event.target.value)}
            />
            <span className="muted">
              {dniLocked
                ? 'Este dato ya está guardado y no se puede modificar.'
                : 'Necesario para emitir certificados con tus datos personales. No podrás cambiarlo una vez lo guardes.'}
            </span>
          </div>
          <button className="button button--primary" type="submit">
            Guardar cambios
          </button>
        </form>
      </section>
    </AppShell>
  )
}
