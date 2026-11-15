import { createFileRoute, redirect } from '@tanstack/react-router'

/**
 * Compatibilidad con enlaces históricos de confirmación. No existe un flujo
 * público de contratación dentro del Campus.
 */
export const Route = createFileRoute('/pago/confirmado')({
  beforeLoad: () => {
    throw redirect({ to: '/catalogo', replace: true })
  },
  component: () => null,
})
