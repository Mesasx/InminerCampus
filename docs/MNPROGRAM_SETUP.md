# Configuración de MNprogram

## Qué está implementado

La sincronización comercial usa la operación SOAP pública `ContratosCliente` de `API/ContratosService.asmx`, con namespace y SOAPAction `http://tempuri.org/ContratosCliente`. La documentación oficial indica que la operación busca al cliente prioritariamente por NIF/CIF, crea cliente y expediente si faltan y añade una actuación. Véase [Desarrolladores - integraciones de MNprogram](https://www.mnprogram.com/desarrolladores-integraciones/).

La emisión fiscal no está inventada: `MnProgramInvoiceProvider` devuelve `NOT_CONFIGURED` hasta que soporte proporcione el WSDL y las operaciones reales de la instancia.

## Datos que se deben pedir a soporte

Solicitar por escrito:

1. Modalidad exacta: MNprogram Web, Escritorio Cloud o MNprogram Cloud.
2. URL base accesible desde Vercel y requisitos de allowlist/IP/VPN.
3. URL del WSDL de `ContratosService` de la instancia.
4. Valor de `instancia`.
5. `numEmpresa`.
6. Operador API con permisos suficientes, preferentemente dedicado.
7. Método de autenticación exacto: `passMD5`, token u otro; no enviar contraseñas por email sin canal seguro.
8. Confirmación de la firma exacta de `ContratosCliente` para esa modalidad.
9. Método SOAP oficial para dar de alta una factura emitida.
10. Parámetros para serie, fecha, cliente, líneas, base, IVA, total y referencia externa/idempotencia.
11. Método para registrar el cobro mediante Stripe.
12. Método para consultar una factura por referencia externa o número de pedido.
13. Método para obtener el número fiscal asignado.
14. Método para descargar el PDF oficial.
15. Método para emitir factura rectificativa por reembolso.
16. Garantía de idempotencia o campo de referencia externa único (`purchase.id`/`order_number`).
17. Formato de respuestas, códigos de error, timeouts y límites de frecuencia.

No se deben aceptar nombres supuestos como `CrearFactura`, `AltaFactura` o `RegistrarCobro` sin que aparezcan en el WSDL real.

## Configuración previa dentro de MNprogram

Crear una pestaña personalizada de actuación llamada `InmínerCampus` y los campos siguientes, respetando tildes y espacios:

- Número pedido
- Purchase ID
- Curso
- Código curso
- Versión
- Tipo compra
- Número plazas
- Base imponible
- IVA
- Total
- Fecha pago
- Stripe Payment ID
- Stripe Checkout ID
- Stripe Customer ID
- Estado pago
- Razón social
- NIF/CIF
- Email
- Factura
- Estado factura

MNprogram no crea estos campos mediante SOAP. Si no existen, la documentación oficial advierte que no se guardarán.

## Variables Vercel

```text
MNPROGRAM_SYNC_ENABLED=false
MNPROGRAM_BASE_URL=
MNPROGRAM_INSTANCE=
MNPROGRAM_COMPANY_NUMBER=
MNPROGRAM_OPERATOR=
MNPROGRAM_TOKEN=
MNPROGRAM_PASS_MD5=
MNPROGRAM_WSDL_URL=
MNPROGRAM_CUSTOM_TAB=InmínerCampus
MNPROGRAM_EXPEDIENT_TITLE=INMINERCAMPUS
MNPROGRAM_EXPEDIENT_TYPE=Formación
```

La implementación ejecutable actual corresponde a la firma Web demostrada públicamente con `passMD5`. Si la instancia usa token, mantener `MNPROGRAM_SYNC_ENABLED=false` hasta validar el WSDL; añadir un elemento SOAP no confirmado podría romper la llamada o exponer credenciales.

## Puesta en marcha

1. Probar en una empresa/base de pruebas.
2. Crear los campos personalizados.
3. Configurar secretos solo en Vercel, nunca con prefijo `VITE_`.
4. Mantener `MNPROGRAM_SYNC_ENABLED=false` hasta validar una llamada manual.
5. Activar `true` y ejecutar un reintento desde Administración.
6. Confirmar que existe una única actuación con naturaleza `Venta InmínerCampus - {order_number}`.
7. Completar el adaptador fiscal con el WSDL privado y sus pruebas contractuales.
8. Tras validar emisión y PDF oficiales, establecer `STRIPE_INVOICE_CREATION_ENABLED=false`.
