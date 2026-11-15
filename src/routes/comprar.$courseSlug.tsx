import { createFileRoute, redirect } from '@tanstack/react-router'

/**
 * Ruta histórica conservada únicamente para no romper enlaces antiguos.
 * La contratación pública no forma parte de InmínerCampus.
 */
export const Route = createFileRoute('/comprar/$courseSlug')({
  beforeLoad: () => {
    throw redirect({ to: '/catalogo', replace: true })
  },
  component: () => null,
})
