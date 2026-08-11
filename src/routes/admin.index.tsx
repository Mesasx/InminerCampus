import { createFileRoute, Link } from '@tanstack/react-router'
import {
  Award,
  BookOpen,
  CircleHelp,
  ClipboardCheck,
  CreditCard,
  Users,
} from 'lucide-react'
import { useEffect, useState } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/')({
  component: AdminPage,
})

const adminRoles = ['administrador', 'superadministrador'] as const

type MetricKey =
  | 'users'
  | 'courses'
  | 'enrollments'
  | 'purchases'
  | 'questions'
  | 'certificates'

function AdminPage() {
  return (
    <ProtectedGate roles={[...adminRoles]}>
      {(user) => <AdminDashboard user={user} />}
    </ProtectedGate>
  )
}

function AdminDashboard({ user }: { user: SessionUser }) {
  const [metrics, setMetrics] = useState<Record<MetricKey, number>>({
    users: 0,
    courses: 0,
    enrollments: 0,
    purchases: 0,
    questions: 0,
    certificates: 0,
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    const count = (table: string) =>
      supabase.from(table).select('id', { count: 'exact', head: true })

    void Promise.all([
      count('profiles'),
      count('courses'),
      count('enrollments'),
      count('purchases'),
      supabase
        .from('support_threads')
        .select('*', { count: 'exact', head: true })
        .in('status', ['new', 'in_review']),
      count('certificates'),
    ]).then((results) => {
      setMetrics({
        users: results[0].count ?? 0,
        courses: results[1].count ?? 0,
        enrollments: results[2].count ?? 0,
        purchases: results[3].count ?? 0,
        questions: results[4].count ?? 0,
        certificates: results[5].count ?? 0,
      })
      setLoading(false)
    })
  }, [])

  const cards = [
    { key: 'users', label: 'Usuarios', icon: Users },
    { key: 'courses', label: 'Cursos', icon: BookOpen },
    { key: 'enrollments', label: 'Matrículas', icon: ClipboardCheck },
    { key: 'purchases', label: 'Pedidos', icon: CreditCard },
    { key: 'questions', label: 'Dudas pendientes', icon: CircleHelp },
    { key: 'certificates', label: 'Certificados', icon: Award },
  ] as const

  return (
    <AppShell user={user} mode="admin" title="Administración">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Panel administrativo</span>
          <h1>Estado de la plataforma.</h1>
          <p>Todos los indicadores proceden de la base de datos.</p>
        </div>
      </div>
      <section className="stats-grid" style={{ gridTemplateColumns: 'repeat(3,1fr)' }}>
        {cards.map(({ key, label, icon: Icon }) => (
          <article className="stat-card" key={key}>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
              }}
            >
              <span className="stat-card__label">{label}</span>
              <Icon size={18} color="var(--orange)" />
            </div>
            <span className="stat-card__value">
              {loading ? '—' : metrics[key]}
            </span>
          </article>
        ))}
      </section>
      <section className="panel">
        <div className="panel__header">
          <h2>Controles operativos</h2>
        </div>
        <div className="feature-grid">
          <Link className="feature-card" to="/admin/cursos">
            <h3>Publicar formación</h3>
            <p>Gestiona cursos, versiones, módulos y lecciones.</p>
          </Link>
          <Link className="feature-card" to="/admin/codigos">
            <h3>Emitir códigos de acceso</h3>
            <p>Genera códigos de un solo uso para los cursos restringidos.</p>
          </Link>
          <Link className="feature-card" to="/admin/evaluaciones">
            <h3>Preparar evaluaciones</h3>
            <p>Crea bancos de preguntas y criterios de superación.</p>
          </Link>
          <Link className="feature-card" to="/admin/practicas">
            <h3>Validar prácticas</h3>
            <p>Registra asistencia, evidencias y resultado.</p>
          </Link>
        </div>
      </section>
    </AppShell>
  )
}
