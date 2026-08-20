# Agente de archivo DataBox para Windows

El agente se ejecuta en el PC o servidor que sí tiene acceso a la unidad local, mapeada o UNC. Vercel nunca intenta escribir directamente en `C:`, `D:`, `Z:` o `\\SERVIDOR`.

## Variables del agente

```powershell
$env:INMINERCAMPUS_ARCHIVE_API_URL='https://campus.example.com'
$env:ARCHIVE_AGENT_TOKEN='un-token-largo-y-aleatorio'
$env:INMINERCAMPUS_ARCHIVE_ROOT='D:\INMINER\FACTURACION'
$env:INMINERCAMPUS_ARCHIVE_POLL_MS='60000'
```

El mismo `ARCHIVE_AGENT_TOKEN` debe configurarse como secreto server-only en Vercel. No usar `VITE_ARCHIVE_AGENT_TOKEN`.

También se admiten rutas como:

- `Z:\FACTURACION`
- `\\DATABOX\INMINER\FACTURACION`

No se admite usar la raíz completa de una unidad. La cuenta de Windows que ejecuta la tarea debe tener lectura/escritura en la carpeta y acceso persistente a la ruta de red.

## Prueba

Desde la raíz del repositorio:

```powershell
npm.cmd run archive-agent -- --once
```

El modo residente se inicia con:

```powershell
npm.cmd run archive-agent
```

La estructura creada es:

```text
{ROOT}\INMINERCAMPUS\{YEAR}\{MONTH}\{NUMERO_FACTURA}.pdf
```

El agente descarga, calcula SHA-256, escribe sin sobrescribir y confirma el archivo. Si ya existe con el mismo hash, solo confirma. Si el hash es distinto, registra conflicto y no modifica el archivo.

Cada descarga se reclama de forma transaccional. Si falla, el agente informa al
servidor y el trabajo aplica el backoff 1 min, 5 min, 15 min, 1 h y 6 h, con un
máximo de seis intentos automáticos. Un trabajo interrumpido se libera para un
nuevo intento tras quince minutos; Administración puede reiniciarlo manualmente.

## Programador de tareas

1. Abrir **Programador de tareas** y elegir **Crear tarea**.
2. Ejecutar con una cuenta de servicio que tenga permisos sobre DataBox.
3. Activar “Ejecutar tanto si el usuario inició sesión como si no”.
4. Desencadenador: al iniciar el sistema, o cada minuto si se usa `--once`.
5. Programa: `C:\Program Files\nodejs\npm.cmd`.
6. Argumentos para proceso residente: `run archive-agent`.
7. Directorio inicial: raíz local del repositorio desplegado.
8. Configurar las variables en el entorno de la cuenta o mediante un script de arranque protegido fuera del repositorio.
9. Habilitar reinicio de la tarea si falla.

Para una tarea cada minuto, usar argumentos `run archive-agent -- --once` y evitar que se inicie una instancia nueva si la anterior sigue activa.

## Logs y seguridad

Cada línea incluye timestamp, factura, acción y resultado. El agente nunca imprime el token ni credenciales completas. El API compara tokens en tiempo constante, aplica límite básico en PostgreSQL y solo entrega facturas con trabajo de archivo pendiente.

Rotar el token si cambia el equipo o la persona administradora. Probar primero con una carpeta local vacía y después con la ruta DataBox definitiva.
