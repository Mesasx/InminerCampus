import { createFileRoute, Outlet } from '@tanstack/react-router'

export const Route = createFileRoute('/dudas')({
  component: Outlet,
})
