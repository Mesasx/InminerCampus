# InmínerCampus

Plataforma LMS de Inmíner Ingeniería, S.L. para formación técnica y preventiva
individual y empresarial.

## Desarrollo

Requisitos:

- Node.js 22 o superior;
- un proyecto Supabase;
- una cuenta Stripe en modo de prueba;
- opcionalmente, un dominio verificado en Resend para los avisos de pagos;
- Cloudflare Turnstile para activar CAPTCHA en producción.

```bash
npm install
cp .env.example .env.local
npm run dev
```

Comprobaciones:

```bash
npm test
npm run typecheck
npm run build
```

`npm run check` ejecuta las tres. El build de producción genera `.output/`
mediante Nitro.

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
- `RESEND_API_KEY`
- `ADMIN_NOTIFICATION_EMAIL` (por defecto `administracion@inminer.es`)
- `ADMIN_NOTIFICATION_FROM`
- `ADMIN_APP_URL`

Nunca se debe añadir el prefijo `VITE_` a secretos. Configure las variables en
los entornos Preview y Production de Vercel sin copiar valores reales al
repositorio.

## Base de datos

Las migraciones reproducibles están en `supabase/migrations` y deben aplicarse
en orden. La migración
`202607300009_billing_admin_notifications.sql` añade:

- snapshots fiscales y económicos inmutables para las compras nuevas;
- importes enteros en céntimos y tipos impositivos en puntos básicos;
- fulfillment y reembolsos idempotentes para el webhook;
- estados de factura y de aviso administrativo;
- funciones de servicio para reclamar/completar avisos sin envíos duplicados;
- permisos económicos de solo lectura para clientes autenticados.

No aplique esta migración directamente en producción sin revisar antes el diff,
hacer copia de seguridad y ejecutarla en un entorno de prueba. Después ejecute
`supabase/verification.sql`.

La primera cuenta no recibe permisos administrativos automáticamente. El primer
`superadministrador` debe asignarse mediante una operación segura de backend
después de verificar manualmente su identidad.

## Circuito de pago

`POST /api/checkout`:

1. autentica al comprador y valida todos los datos fiscales;
2. lee desde Supabase la versión publicada, el precio neto y el IVA;
3. calcula base, impuesto y total en céntimos, sin aceptar importes del navegador;
4. guarda snapshots fiscales, legales, del curso y del precio;
5. reutiliza o crea el Customer de Stripe;
6. crea Checkout con una clave idempotente por intento.

`POST /api/stripe-webhook` valida la firma sobre el cuerpo sin transformar. Solo
el webhook puede marcar una compra como pagada y crear la matrícula. También
registra reembolsos a partir de `charge.refunded`.

Tras confirmar un pago se reclama de forma atómica un único aviso para
Administración y se envía con Resend. Si el correo falla, la compra permanece
pagada y el fallo queda disponible para reintento. El panel
`/admin/facturacion` permite consultar el snapshot, gestionar factura y notas,
reintentar avisos fallidos y exportar CSV.

La página `/pago/confirmado` no activa accesos. Consulta al backend y espera a
que el webhook haya verificado realmente la compra.

## Configuración de Stripe

Registre este webhook:

```text
https://DOMINIO/api/stripe-webhook
```

Eventos:

- `checkout.session.completed`
- `checkout.session.async_payment_succeeded`
- `charge.refunded`

Para una prueba local con Stripe CLI:

```bash
stripe listen --forward-to localhost:3000/api/stripe-webhook
stripe trigger checkout.session.completed
```

Use tarjetas de prueba, confirme que un doble envío del mismo evento no duplica
la matrícula ni el correo y pruebe un reembolso total y parcial. El endpoint
`POST /api/company-access-codes` mantiene el flujo de plazas empresariales:
comprueba el pedido pagado y la pertenencia del responsable antes de crear los
códigos.

## Configuración de Resend

1. Verifique `inminer.es` en Resend.
2. Configure `RESEND_API_KEY`.
3. Use una dirección verificada en `ADMIN_NOTIFICATION_FROM`.
4. Mantenga `ADMIN_NOTIFICATION_EMAIL=administracion@inminer.es` o cambie el
   destinatario explícitamente por entorno.

El envío utiliza la clave de idempotencia `purchase-paid/{purchaseId}` y la base
de datos evita que dos ejecuciones reclamen simultáneamente el mismo aviso.

## Prueba funcional recomendada

1. Inicie sesión como alumno y abra dos cursos con precios distintos.
2. Compruebe que cada pantalla muestra su propia base, IVA y total.
3. Intente enviar un campo `amount` adicional: la API debe devolver `400`.
4. Complete una compra de prueba y espere en `/pago/confirmado`.
5. Verifique matrícula, snapshot del pedido y un único correo administrativo.
6. Entre como administrador en `/admin/facturacion`, filtre el pedido, actualice
   la factura y exporte el CSV.
7. Reenvíe el evento Stripe y confirme que no se duplican matrícula ni aviso.
8. Ejecute un reembolso y compruebe su reflejo en el panel.

## Antes de publicar

- revisar jurídicamente aviso legal, privacidad, cookies, contratación y
  desistimiento;
- comprobar los precios, tipos fiscales y programas documentados;
- probar Stripe y Resend en sandbox;
- aplicar y verificar la migración en un entorno de prueba;
- crear y verificar el primer superadministrador;
- ejecutar `npm run check` y pruebas manuales por cada rol.
