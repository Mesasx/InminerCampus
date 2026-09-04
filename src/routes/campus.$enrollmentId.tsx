import { createFileRoute, Outlet } from '@tanstack/react-router'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute('/campus/$enrollmentId')({
  head: () => seoHead({
    title: 'Campus',
    description: 'Contenido del curso matriculado.',
    path: '/campus',
    noindex: true,
  }),
  component: Outlet,
})
