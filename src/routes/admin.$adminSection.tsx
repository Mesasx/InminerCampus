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
          <section className="empty-state">
            <div>
              <h2>Estructura preparada</h2>
              <p>
                Este módulo utilizará las tablas y permisos ya creados. Su
                interfaz operativa se completará junto con el contenido real.
              </p>
            </div>
          </section>
        </AppShell>
      )}
    </ProtectedGate>
  )
}
