import {
  HeadContent,
  Outlet,
  Scripts,
  createRootRoute,
} from '@tanstack/react-router'
import type { ReactNode } from 'react'
import appCss from '../styles/app.css?url'

export const Route = createRootRoute({
  head: () => ({
    meta: [
      { charSet: 'utf-8' },
      {
        name: 'viewport',
        content: 'width=device-width, initial-scale=1, viewport-fit=cover',
      },
      {
        title:
          'InmínerCampus | Formación técnica y preventiva con trazabilidad',
      },
      {
        name: 'description',
        content:
          'Plataforma de formación de Inmíner Ingeniería, S.L. para profesionales, trabajadores y empresas.',
      },
      { name: 'theme-color', content: '#E97824' },
    ],
    links: [{ rel: 'stylesheet', href: appCss }],
  }),
  notFoundComponent: () => (
    <RootDocument>
      <main className="container section page-enter">
        <span className="eyebrow">Error 404</span>
        <h1>Esta página no existe</h1>
        <p className="muted">
          Comprueba la dirección o vuelve al inicio de InmínerCampus.
        </p>
        <a className="button button--primary" href="/">
          Volver al inicio
        </a>
      </main>
    </RootDocument>
  ),
  errorComponent: ({ error }) => (
    <RootDocument>
      <main className="container section page-enter">
        <span className="eyebrow">Se ha producido un error</span>
        <h1>No hemos podido cargar esta página</h1>
        <p className="muted">{error.message}</p>
        <button className="button button--primary" onClick={() => location.reload()}>
          Reintentar
        </button>
      </main>
    </RootDocument>
  ),
  component: RootComponent,
})

function RootComponent() {
  return (
    <RootDocument>
      <Outlet />
    </RootDocument>
  )
}

function RootDocument({ children }: { children: ReactNode }) {
  return (
    <html lang="es">
      <head>
        <HeadContent />
      </head>
      <body>
        {children}
        <Scripts />
      </body>
    </html>
  )
}
