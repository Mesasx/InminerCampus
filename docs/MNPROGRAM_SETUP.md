# Uso actual de MNprogram

## Decisión de integración

MNprogram no dispone de una API de pagos o facturación que debamos conectar ahora. La documentación recibida describe operaciones SOAP de clientes, oportunidades, expedientes y contratos; no documenta la creación fiscal de facturas ni la importación de pagos de Stripe.

Por ello, la integración automática de MNprogram permanece desactivada:

```text
MNPROGRAM_SYNC_ENABLED=false
STRIPE_INVOICE_CREATION_ENABLED=false
```

## Procedimiento para Administración

Después de cada pago confirmado:

1. Resend envía el aviso a `administracion@inminer.es`.
2. Administración abre el pedido desde el enlace del correo.
3. Crea el cliente en MNprogram si todavía no existe.
4. Genera la factura con los datos fiscales y económicos del aviso.
5. Envía la factura desde MNprogram al correo indicado como “Correo de factura”.
6. Registra el número y marca la factura como emitida o enviada en `/admin/facturacion`.

El email contiene las referencias `purchase.id`, número de pedido, Checkout Session y PaymentIntent para facilitar la conciliación sin duplicar facturas.

## Configuración de Resend y Vercel

Configurar como variables de servidor en Producción y Preview:

```text
RESEND_API_KEY=<secreto>
ADMIN_NOTIFICATION_EMAIL=administracion@inminer.es
ADMIN_NOTIFICATION_FROM=InmínerCampus <campus@inminer.es>
ADMIN_APP_URL=https://inminercampus.com
```

Antes del primer envío real, verificar el dominio `inminer.es` en Resend. No compartir `RESEND_API_KEY` por chat ni guardarla en archivos versionados.

## Posible fase futura

La API SOAP de clientes puede utilizarse más adelante para crear o localizar clientes y contratos. Esa ampliación debe probarse de forma separada y no cambia la regla actual: las facturas se emiten manualmente en MNprogram.
