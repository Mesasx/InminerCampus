import { createFileRoute } from '@tanstack/react-router'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'

export const Route = createFileRoute('/admin/$adminSection')({
  component: AdminSectionPage,
})

const sections: Record<string, { title: string; description: string }> = {
  usuarios: {
    title: 'Usuarios',
    description:
      'Gestión de perfiles, matrículas y permisos administrativos.',
  },
  evaluaciones: {
    title: 'Evaluaciones',
    description:
      'Bancos de preguntas, tests, intentos y rachas de resultados perfectos.',
  },
  practicas: {
    title: 'Prácticas',
    description:
      'Sesiones presenciales, asistencia, evidencias y validación del formador.',
  },
  mensajes: {
    title: 'Mensajes',
    description:
      'Bandeja de entrada para consultas de alumnos y seguimiento de respuestas.',
  },
  configuracion: {
    title: 'Configuración',
    description:
      'Parámetros globales, integraciones y versiones de textos legales.',
  },
}

function AdminSectionPage() {
  const { adminSection } = Route.useParams()
  const section = sections[adminSection] ?? {
    title: 'Administración',
    description: 'Apartado administrativo de InmínerCampus.',
  }

  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => (
        <AppShell user={user} mode="admin" title={section.title}>
          <div className="dashboard-heading">
            <div>
              <span className="eyebrow">Administración</span>
              <h1>{section.title}.</h1>
              <p>{section.description}</p>
            </div>
          </div>
          <section className="panel">
            <div className="panel__header">
              <h2>Configuración de la plataforma</h2>
            </div>
            <p className="muted">
              Los precios, versiones, publicación, temario y contenido se
              administran desde cada curso. Los textos legales se mantienen
              versionados para conservar la trazabilidad de cada consentimiento.
            </p>
          </section>
        </AppShell>
      )}
    </ProtectedGate>
  )
}
