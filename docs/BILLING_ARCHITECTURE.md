# Flujo de cobro y facturación manual

## Responsabilidad de cada sistema

- **Stripe** procesa el cobro. Solo un webhook con firma válida y `payment_status=paid` confirma el pago.
- **Supabase/InmínerCampus** conserva el pedido, los datos fiscales, los importes, la matrícula y el estado de gestión de la factura.
- **Resend** avisa a `administracion@inminer.es` después de confirmar el pago.
- **MNprogram** es el sistema donde Administración crea y envía manualmente la factura.

MNprogram no recibe pagos de Stripe ni emite facturas mediante API en esta fase.

## Flujo activo

1. Checkout valida los datos fiscales en el servidor y crea `purchases` y `purchase_items` con snapshots económicos.
2. Stripe Checkout cobra sin que InmínerCampus almacene datos de tarjeta.
3. El webhook verifica `stripe-signature`, confirma el pago y crea la matrícula de forma idempotente.
4. El servidor reclama el aviso administrativo mediante `claim_admin_payment_notification`.
5. Resend envía un único correo por compra con la clave idempotente `purchase-paid/{purchase.id}`.
6. El correo incluye pedido, cliente, NIF/CIF, dirección, emails, teléfono, curso, descripción, plazas, precio unitario, base, IVA, total y referencias de Stripe.
7. Administración crea la factura en MNprogram y registra en `/admin/facturacion` su número y estado: pendiente, emitida o enviada.
8. El cliente consulta el estado en `/facturas`; el documento oficial se recibe por correo.

Si Resend falla, el cobro y la matrícula no se revierten. El aviso queda en estado `failed` y puede reenviarse desde Administración.

## Configuración activa

```text
STRIPE_INVOICE_CREATION_ENABLED=false
MNPROGRAM_SYNC_ENABLED=false
RESEND_API_KEY=<secreto en Vercel>
ADMIN_NOTIFICATION_EMAIL=administracion@inminer.es
ADMIN_NOTIFICATION_FROM=InmínerCampus <campus@inminer.es>
ADMIN_APP_URL=https://inminercampus.com
```

`inminer.es` debe estar verificado en Resend antes de usar `campus@inminer.es` como remitente. Los secretos se configuran solo en Vercel y nunca con prefijo `VITE_`.

No hay un cron activo en `vercel.json`. La migración conservada en `supabase/migrations-disabled/20260820160000_automate_billing_mnprogram.sql`, los endpoints de emisión automática, el PDF privado y el agente DataBox quedan reservados para una fase futura y no deben aplicarse ni activarse en producción bajo este flujo.

## Campos equivalentes a la plantilla Word

La plantilla `01FRA.CUENTA GESTIÓN.docx` contiene campos para fecha y número de factura, nombre, NIF/CIF, domicilio, CP, población, provincia, email, teléfono, unidades, descripción, precio unitario, base, IVA y total. Todos los datos que InmínerCampus conoce antes de emitir la factura se incluyen en el aviso a Administración.

El número y la fecha fiscal se asignan posteriormente dentro de MNprogram y se registran en el panel administrativo.

## Reembolsos

Stripe continúa notificando los reembolsos. La compra se marca como reembolsada y Administración debe gestionar manualmente la factura rectificativa correspondiente en MNprogram.
