import { createFileRoute, redirect } from '@tanstack/react-router'

/**
 * Ruta histórica conservada únicamente para no romper enlaces antiguos.
 * La coordinación con empresas se realiza directamente con Inmíner.
 */
export const Route = createFileRoute('/comprar-empresa/$courseSlug')({
  beforeLoad: () => {
    throw redirect({ to: '/empresas', replace: true })
  },
  component: () => null,
})
