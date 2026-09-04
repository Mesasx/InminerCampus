# Alta y uso de Google Search Console — InmínerCampus

El repositorio **no contiene ninguna verificación de Search Console** (no hay
`google-site-verification`, ni archivo HTML de verificación, ni integración de
analítica). Hay que darla de alta desde cero.

Hazlo **inmediatamente después de desplegar** los cambios de esta intervención:
hasta que Google no rastree el sitio con el SSR activo, seguirá teniendo en
caché la versión sin contenido.

---

## 1. Crear la propiedad (usar propiedad de dominio)

1. Entra en <https://search.google.com/search-console>.
2. **Añadir propiedad → Dominio** (no «Prefijo de URL»).
   La propiedad de dominio cubre `http`, `https`, `www` y todos los subdominios
   con una sola verificación, y es la que da datos completos.
3. Introduce `inminercampus.com` (sin `https://` ni `www`).

## 2. Verificar por DNS

Google mostrará un registro `TXT` del tipo
`google-site-verification=XXXXXXXXXXXXXXXXXXXX`.

En el proveedor DNS del dominio:

| Campo | Valor |
|---|---|
| Tipo | `TXT` |
| Nombre / Host | `@` (la raíz del dominio) |
| Valor | `google-site-verification=XXXXXXXXXXXXXXXXXXXX` |
| TTL | el que ofrezca por defecto (3600) |

Guarda y pulsa **Verificar**. Si falla, espera la propagación (de minutos a
24 h) y reintenta. Comprobación desde terminal:

```bash
nslookup -type=TXT inminercampus.com
```

> **No borres el registro TXT después de verificar.** Google lo revalida
> periódicamente y perderías la propiedad.

## 3. Enviar el sitemap

En **Indexación → Sitemaps**, añade:

```
sitemap.xml
```

El sitemap se genera dinámicamente desde Supabase en cada petición: cuando se
publique un curso nuevo aparecerá solo, sin tocar el repositorio ni redesplegar.

Comprobación previa:

```bash
curl -s https://inminercampus.com/sitemap.xml | head -20
curl -s https://inminercampus.com/robots.txt
```

`robots.txt` debe terminar con
`Sitemap: https://inminercampus.com/sitemap.xml`.

## 4. Inspeccionar las primeras URLs

Usa **Inspección de URLs** y, en cada una, «Probar URL publicada» → revisa
**HTML probado** para confirmar que el contenido está en el HTML servido. Luego
«Solicitar indexación».

En este orden exacto:

| # | URL | Qué confirmar en el HTML probado |
|---|---|---|
| 1 | `/cursos/operador-maquinaria-arranque-carga-viales` | `<h1>` con el nombre del curso, `Course` en JSON-LD, canónica sin `?version=` |
| 2 | `/cursos/operador-maquinaria-transporte-camion-volquete` | Ídem |
| 3 | `/cursos/prevencion-polvo-silice-cristalina-respirable` | Ídem |
| 4 | `/catalogo?categoria=mineria` | Los tres cursos listados con enlaces `/cursos/...` |
| 5 | `/formacion-preventiva-oficial` | Título propio, no el genérico del sitio |
| 6 | `/` | `<h1>` presente, `EducationalOrganization` en JSON-LD |
| 7 | `/catalogo` | Enlaces a las tres fichas |
| 8 | `/sobre-nosotros` | Entidad INMÍNER, NAP |

Las tres primeras son las que sostienen el negocio. Si alguna sigue mostrando
«Cargando la información del curso…», el despliegue no ha entrado.

## 5. Comprobar la indexación

**Indexación → Páginas.** A vigilar durante las primeras semanas:

- *Descubierta: actualmente sin indexar* → normal al principio; si persiste más
  de un mes, revisar enlazado interno y calidad.
- *Rastreada: actualmente sin indexar* → Google la ve pero no la considera
  suficientemente valiosa. Señal de que hay que mejorar el contenido.
- *Página alternativa con etiqueta canónica adecuada* → **es lo esperado** para
  las URLs `?version=`: significa que la canonicalización funciona.
- *Excluida por la etiqueta «noindex»* → esperado en `/acceso`, `/registro`,
  `/mis-cursos`, `/comprar/...`, `/campus/...`, `/admin/...`.

Búsqueda manual para ver qué tiene Google indexado hoy:

```
site:inminercampus.com
```

## 6. Core Web Vitals

**Experiencia → Core Web Vitals.** Necesita ~28 días de datos de campo. Hasta
entonces el informe estará vacío; usa PageSpeed Insights para datos de
laboratorio:

<https://pagespeed.web.dev/analysis?url=https://inminercampus.com/cursos/operador-maquinaria-arranque-carga-viales>

Objetivos en móvil: LCP < 2,5 s · CLS < 0,1 · INP < 200 ms.

## 7. Consultas y rendimiento

**Rendimiento → Resultados de búsqueda.** Configuración recomendada:

- Filtro **País = España** (esencial: descarta el tráfico latinoamericano que no
  interesa).
- Pestaña **Consultas** para ver por qué se está entrando.
- Pestaña **Páginas** para ver qué URL recibe cada impresión.

Primeras consultas a vigilar: `ITC 02.1.02`, `curso operador maquinaria
arranque carga viales`, `ET 2001-1-08`, `ET 2000-1-08`, `curso sílice
cristalina respirable`, `ITC 02.0.02`, `camión y volquete minería`.

## 8. Detectar canibalización

En **Rendimiento**, filtra por una consulta concreta y mira la pestaña
**Páginas**. Si dos URLs reciben impresiones para la misma consulta, compiten
entre sí.

El riesgo conocido está entre `/formacion-preventiva-oficial` y
`/catalogo?categoria=mineria`. Si ambas aparecen para «formación preventiva
minería», decide cuál es la principal y reorienta la otra —la primera debe ser
informacional (qué exige la norma) y la segunda comercial (qué se puede
comprar).

## 9. Controlar errores

- **Indexación → Páginas → «No encontrada (404)»**: no debería haber ninguna URL
  del sitemap ahí. La prueba automática
  `tests/seo-ssr-cursos.test.ts` ya lo comprueba contra un despliegue real.
- **Mejoras → Fragmentos de reseña / Preguntas frecuentes**: valida `Course`,
  `BreadcrumbList` y `FAQPage`.
- **Acciones manuales** y **Problemas de seguridad**: deberían estar vacíos.

Validador de datos estructurados:
<https://search.google.com/test/rich-results>

---

## Prueba automática contra un despliegue

Las pruebas de humo SEO se pueden lanzar contra cualquier entorno:

```bash
SEO_SMOKE_BASE_URL=https://inminercampus.com \
  node --test --experimental-strip-types tests/seo-ssr-cursos.test.ts
```

Sin esa variable las comprobaciones de red se omiten y sólo se ejecutan las
estructurales, que no necesitan servidor.
