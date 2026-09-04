import { createFileRoute, Outlet } from '@tanstack/react-router'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/empresa')({
  head: () => seoHead({
    title: 'Panel de empresa',
    description:
      'Gestión de licencias y trabajadores.',
    path: '/empresa',
    noindex: true,
  }),
  component: Outlet,
})
