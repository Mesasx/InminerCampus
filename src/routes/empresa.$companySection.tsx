import { createFileRoute } from '@tanstack/react-router'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'

export const Route = createFileRoute('/empresa/$companySection')({
  component: CompanySectionPage,
})

const sections: Record<string, { title: string; description: string }> = {
  formacion: {
    title: 'Formación contratada',
    description: 'Pedidos, cursos y plazas adquiridas por la organización.',
  },
  trabajadores: {
    title: 'Trabajadores',
    description: 'Asignación de plazas y seguimiento autorizado.',
  },
  codigos: {
    title: 'Códigos',
    description:
      'Códigos únicos de un solo uso. El valor completo solo se muestra al generarlo.',
  },
  facturacion: {
    title: 'Facturación',
    description: 'Historial de pagos, importes, impuestos y facturas.',
  },
}

function CompanySectionPage() {
  const { companySection } = Route.useParams()
  const section = sections[companySection] ?? {
    title: 'Área de empresa',
    description: 'Gestión de la formación corporativa.',
  }

  return (
    <ProtectedGate roles={['responsable_empresa', 'superadministrador']}>
      {(user) => (
        <AppShell user={user} mode="company" title={section.title}>
          <div className="dashboard-heading">
            <div>
              <span className="eyebrow">Área de empresa</span>
              <h1>{section.title}.</h1>
              <p>{section.description}</p>
            </div>
          </div>
          <section className="empty-state">
            <div>
              <h2>Conectado al modelo empresarial</h2>
              <p>
                El apartado utilizará los pedidos, miembros, matrículas y códigos
                protegidos por la organización.
              </p>
            </div>
          </section>
        </AppShell>
      )}
    </ProtectedGate>
  )
}
