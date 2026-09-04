import { createFileRoute, Outlet } from '@tanstack/react-router'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/admin')({
  head: () => seoHead({
    title: 'Administración',
    description:
      'Panel interno de administración.',
    path: '/admin',
    noindex: true,
  }),
  component: Outlet,
})
