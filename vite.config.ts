import { tanstackStart } from '@tanstack/react-start/plugin/vite'
import react from '@vitejs/plugin-react'
import { nitro } from 'nitro/vite'
import { defineConfig } from 'vite'

// Fuentes externas que carga la aplicación: tipografía de Google Fonts
// (src/styles/app.css), el widget de verificación Cloudflare Turnstile
// (acceso, registro, recuperación de contraseña y canje de códigos) y el
// logotipo + favicons de Inmíner, servidos desde inminer.es en vez de
// desde este proyecto (src/components/Logo.tsx, src/routes/__root.tsx).
// Todo lo demás (imágenes de diapositivas, PDF de materiales, llamadas a
// la API) sale del propio proyecto de Supabase.
//
// script-src necesita 'unsafe-inline': TanStack Start inyecta scripts
// inline con el manifiesto de rutas y la barrera de streaming SSR
// (`$tsr-stream-barrier`), generados por petición y por tanto imposibles
// de fijar con un hash estático; el framework no expone ningún hook de
// nonce en esta versión. Esto reduce la protección de la CSP frente a
// inyección de <script> inline, pero conserva la más relevante en la
// práctica: sigue bloqueando la carga de script-src desde dominios no
// autorizados. Revisar si una versión futura de @tanstack/react-start
// añade soporte de nonce para poder retirar 'unsafe-inline'.
const contentSecurityPolicy = [
  "default-src 'self'",
  "script-src 'self' 'unsafe-inline' https://challenges.cloudflare.com",
  "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
  "font-src 'self' https://fonts.gstatic.com",
  "img-src 'self' data: https://*.supabase.co https://inminer.es",
  "media-src 'self' blob: https://*.supabase.co",
  "connect-src 'self' https://*.supabase.co https://challenges.cloudflare.com",
  "frame-src 'self' https://*.supabase.co https://challenges.cloudflare.com",
  "object-src 'none'",
  "base-uri 'self'",
  "form-action 'self'",
  "frame-ancestors 'none'",
  'upgrade-insecure-requests',
].join('; ')

const securityHeaders = {
  'Content-Security-Policy': contentSecurityPolicy,
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload',
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'Referrer-Policy': 'strict-origin-when-cross-origin',
  'Permissions-Policy': 'camera=(), microphone=(), geolocation=()',
}

export default defineConfig({
  server: {
    port: 3000,
  },
  resolve: {
    tsconfigPaths: true,
  },
  plugins: [
    tanstackStart({
      router: {
        routesDirectory: './routes',
        generatedRouteTree: './routeTree.gen.ts',
      },
    }),
    nitro({
      routeRules: {
        '/**': { headers: securityHeaders },
      },
    }),
    react(),
  ],
})
