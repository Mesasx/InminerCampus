import { createFileRoute, Outlet } from '@tanstack/react-router'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/dudas')({
  head: () => seoHead({
    title: 'Dudas',
    description:
      'Canal de dudas con el equipo docente.',
    path: '/dudas',
    noindex: true,
  }),
  component: Outlet,
})
