# Arquitectura de facturación y trazabilidad

## Responsabilidad de cada sistema

- **Stripe** confirma y procesa el cobro. El webhook firmado es la única fuente que cambia un pedido a pagado.
- **Supabase/InmínerCampus** conserva el pedido, los snapshots fiscales y económicos, la matrícula, la trazabilidad, los trabajos y el PDF privado.
- **MNprogram** recibe la trazabilidad comercial mediante `ContratosCliente` y será el emisor fiscal cuando soporte confirme el método privado real de emisión.
- **DataBox/servidor local** conserva una copia documental verificada por SHA-256 mediante un agente Windows independiente.

La regla de cardinalidad es: una venta, un `purchase.id`, un `order_number`, un PaymentIntent, una fila `invoices`, un número fiscal oficial y un PDF inmutable.

## Flujo

1. Checkout valida en servidor los datos fiscales y crea `purchases` y `purchase_items` con snapshots.
2. Stripe Checkout cobra sin almacenar datos de tarjeta en InmínerCampus.
3. El webhook verifica `stripe-signature`, exige `payment_status=paid` y ejecuta `fulfill_stripe_checkout_v2`.
4. La misma transacción marca el pedido como pagado, crea la matrícula y llama a `enqueue_invoice_for_purchase`.
5. La factura y los trabajos de integración se crean con restricciones únicas. Una repetición del webhook reutiliza las mismas filas.
6. `/api/cron/billing` procesa trabajos fuera de la transacción de Stripe.
7. `mnprogram_sync` registra la venta con la operación pública `ContratosCliente` cuando está configurada.
8. `invoice_issue` permanece en `NOT_CONFIGURED` hasta disponer del WSDL y método fiscal reales. No se inventa una operación SOAP.
9. Cuando el proveedor devuelve número oficial y fecha, el sistema conserva el PDF oficial o genera una representación PDF server-side con esos datos ya emitidos, lo almacena sin `upsert` y registra SHA-256.
10. El email y el archivo DataBox son trabajos separados e idempotentes.

La frecuencia incluida en `vercel.json` es diaria a las 06:00 UTC para ser
compatible con Vercel Hobby. Para procesar facturas casi inmediatamente, usar
Vercel Pro y cambiarla a `*/5 * * * *`, o configurar un programador externo
que invoque el endpoint cada cinco minutos con `CRON_SECRET`.

## Numeración e idempotencia

`purchase.order_number` es la referencia humana principal. `purchase.id` e `invoice.id` son las referencias internas.

La referencia interna `CAMPUS-AAAA-NNNNNN` se obtiene con un contador por serie y año mediante `INSERT ... ON CONFLICT DO UPDATE ... RETURNING`, dentro de la transacción y con la compra bloqueada. No se usa `SELECT max()+1`.

`internal_invoice_reference` no es necesariamente el número fiscal. Cuando MNprogram emita la factura, `official_invoice_number` e `invoice_number` se sustituyen por el valor oficial sin perder la referencia interna.

Protecciones principales:

- `invoices.purchase_id UNIQUE`.
- `billing_jobs(invoice_id,type) UNIQUE`.
- PaymentIntent, Checkout Session, evento Stripe y pedido ya tienen índices únicos.
- El PDF no se sobreescribe y un trigger impide cambiar su ruta o hash una vez fijados.
- Un snapshot fiscal emitido no puede alterarse.
- Resend usa una clave idempotente por factura y versión de entrega.

## Trabajos y reintentos

Los trabajos remotos no forman parte del commit de Stripe. Los estados son `pending`, `processing`, `completed` y `failed`. El claim usa `FOR UPDATE SKIP LOCKED`.

Backoff: 1 minuto, 5 minutos, 15 minutos, 1 hora y 6 horas; máximo seis intentos. Un timeout de MNprogram se considera ambiguo y no se reintenta automáticamente, porque el servidor podría haber creado la actuación antes de perderse la respuesta. Administración debe comprobar MNprogram y reintentar de forma explícita.

## Stripe `invoice_creation`

El checkout existente mantiene `invoice_creation` por compatibilidad mediante `STRIPE_INVOICE_CREATION_ENABLED=true`. Ese documento de Stripe no debe tratarse como una segunda factura fiscal.

Cuando soporte confirme que MNprogram será el emisor fiscal definitivo y el adaptador esté operativo:

1. comprobar la numeración y PDF oficial en sandbox;
2. definir `STRIPE_INVOICE_CREATION_ENABLED=false` en Vercel;
3. mantener Stripe como procesador de pago y conservar PaymentIntent/Checkout Session para conciliación.

## Campos de la plantilla Word/MNprogram

La plantilla `01FRA.CUENTA GESTIÓN.docx` no contiene VBA. Contiene campos MNprogram equivalentes a fecha y número de factura, nombre, NIF/CIF, domicilio, CP, población, provincia, email, teléfono, unidades, descripción, precio unitario, base, IVA y total. El generador y los snapshots usan esos mismos conceptos.

Datos del emisor extraídos de la plantilla:

- INMÍNER Ingeniería, S.L.
- B-13476148
- C/ Aragón, 29, 13004 Ciudad Real, España
- Hoja CR-18847, Tomo 476, Folio 92, Inscripción 1ª

## Reembolsos

`charge.refunded` continúa siendo procesado. Marca `refund_requires_credit_note=true` en pedido y factura. No se emite automáticamente una rectificativa hasta conocer el método fiscal real de MNprogram.

## Endpoints

- `GET /api/invoices`
- `GET /api/invoices/:invoiceId/download`
- `POST /api/admin/billing/retry/:invoiceId`
- `GET /api/cron/billing`
- `GET /api/internal/archive/pending`
- `GET /api/internal/archive/:invoiceId/download`
- `POST /api/internal/archive/:invoiceId/confirm`
- `POST /api/internal/archive/:invoiceId/fail`

Los PDFs viven en el bucket privado `billing-documents` bajo `invoices/{year}/{invoiceId}/invoice.pdf`. Las descargas de usuario usan una URL firmada de 60 segundos después de autorizar propietario, responsable de organización o administrador.
