import { createRouter } from '@tanstack/react-router'
import { routeTree } from './routeTree.gen'

const STALE_BUNDLE_RELOAD_KEY = 'inminer-campus:stale-bundle-reload'

if (typeof window !== 'undefined') {
  // After a deploy, tabs left open still reference JS chunk hashes that no
  // longer exist on the server. Vite reports that as `vite:preloadError`;
  // reload once (guarded to avoid a refresh loop) to fetch the current build.
  window.addEventListener('vite:preloadError', () => {
    if (sessionStorage.getItem(STALE_BUNDLE_RELOAD_KEY)) return
    sessionStorage.setItem(STALE_BUNDLE_RELOAD_KEY, '1')
    window.location.reload()
  })
  window.addEventListener('load', () => {
    sessionStorage.removeItem(STALE_BUNDLE_RELOAD_KEY)
  })
}

export function getRouter() {
  const router = createRouter({
    routeTree,
    scrollRestoration: true,
    defaultPreload: 'intent',
  })

  return router
}

declare module '@tanstack/react-router' {
  interface Register {
    router: ReturnType<typeof getRouter>
  }
}
