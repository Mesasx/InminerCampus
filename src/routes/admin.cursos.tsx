import { createFileRoute, Outlet } from '@tanstack/react-router'

export const Route = createFileRoute('/admin/cursos')({
  component: Outlet,
})
