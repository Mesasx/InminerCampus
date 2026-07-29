# InmínerCampus

Plataforma LMS de Inmíner Ingeniería, S.L. para formación técnica y
preventiva individual y empresarial.

## Estado

La aplicación incluye:

- identidad visual naranja de InmínerCampus y transiciones accesibles;
- páginas públicas, catálogo y fichas alimentadas por Supabase;
- registro, confirmación de correo, acceso, recuperación de contraseña y
  CAPTCHA adaptativo con Cloudflare Turnstile;
- áreas separadas para alumno, responsable de empresa y administración;
- cursos, versiones, módulos, lecciones, recursos y progreso secuencial;
- códigos empresariales de un solo uso consumidos de forma atómica;
- tests corregidos en base de datos con la regla configurable de intentos
  perfectos consecutivos;
- prácticas presenciales, soporte, certificados y verificación pública;
- Stripe Checkout individual y empresarial con webhook firmado e idempotente;
- compra por plazas y generación segura de lotes de códigos empresariales;
- RLS en todas las tablas, buckets privados y registro de auditoría;
- salida Nitro compatible con Vercel.

Los textos legales son provisionales. No se publican afirmaciones de
homologación, normativa o precios que no estén documentadas.

## Desarrollo

Requisitos:

- Node.js 22 o superior;
- un proyecto Supabase;
- una cuenta Stripe para probar pagos;
- Cloudflare Turnstile para activar CAPTCHA en producción.

```bash
npm install
cp .env.example .env.local
npm run dev
```

Comprobaciones:

```bash
npm run typecheck
npm run build
```

El build de producción genera `.output/` mediante Nitro.

## Variables de entorno

Variables públicas:

- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY`
- `VITE_TURNSTILE_SITE_KEY`
- `VITE_APP_URL`

Variables exclusivas del servidor:

- `SUPABASE_SERVICE_ROLE_KEY`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`

Nunca se debe añadir el prefijo `VITE_` a secretos.

## Base de datos

Las migraciones reproducibles están en `supabase/migrations` y deben aplicarse
en orden. `supabase/verification.sql` contiene comprobaciones de solo lectura
para RLS, permisos, buckets e índices.

La primera cuenta no recibe permisos administrativos automáticamente. El primer
`superadministrador` debe asignarse por una operación segura de backend después
de verificar manualmente su identidad.

## Stripe

El endpoint `POST /api/checkout`:

1. valida el token de Supabase;
2. lee el curso y el precio publicados desde la base de datos;
3. valida la empresa y el número de plazas cuando la compra es empresarial;
4. crea un pedido en borrador;
5. abre Stripe Checkout con impuestos automáticos;
6. devuelve únicamente la URL de pago.

El endpoint `POST /api/stripe-webhook` valida la firma sobre el cuerpo sin
transformar. La matrícula se crea mediante `fulfill_stripe_checkout` y nunca a
partir de la página de retorno.

El endpoint `POST /api/company-access-codes` comprueba el pedido pagado y la
pertenencia del responsable a la empresa antes de crear los códigos. La base de
datos conserva únicamente su hash; el valor completo se devuelve una sola vez
para exportarlo o entregarlo al trabajador.

En Stripe debe registrarse:

```text
https://DOMINIO/api/stripe-webhook
```

Eventos mínimos:

- `checkout.session.completed`
- `checkout.session.async_payment_succeeded`

## Antes de publicar

- completar y revisar jurídicamente aviso legal, privacidad, cookies,
  contratación y desistimiento;
- introducir cursos, precios, programas y acreditaciones documentadas;
- configurar correo transaccional y plantillas de Supabase Auth;
- cargar vídeos y materiales reales en buckets privados o proveedor de vídeo;
- probar Stripe en sandbox, impuestos, facturas, reembolsos y webhook;
- crear y verificar el primer superadministrador;
- ejecutar la auditoría SQL y pruebas de usuario por cada rol;
- conectar el repositorio de GitHub y desplegar con las variables de Vercel.
