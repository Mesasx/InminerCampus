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
| 4 | `/formacion-minera` | Guía general: tabla puesto → especificación técnica → curso |
| 5 | `/itc-02-1-02` | `Article`, `FAQPage`, `ItemList`; enlaces al BOE |
| 6 | `/itc-02-1-02/formacion-inicial-y-reciclaje` | Tabla comparativa 20 h / 5 h |
| 7 | `/itc-02-0-02` | Valores límite y formación anual |
| 8 | `/` | `<h1>` «Inmíner Campus · Cursos de minería y formación preventiva»; `EducationalOrganization` + `Organization` (INMINER INGENIERÍA, S.L.) + `WebSite` |
| 9 | `/catalogo` | Enlaces a todas las fichas, `ItemList` |
| 10 | `/sobre-nosotros` | Entidad INMINER INGENIERÍA, S.L., `Person`, NAP |

Resto de fichas de curso (perforadora, establecimientos de beneficio,
administración): inspeccionarlas también; están todas en el sitemap.

`/formacion-preventiva-oficial` responde **301 → `/formacion-minera`**. Si
aparece en Search Console como «Página con redirección», es lo esperado. No
hace falta solicitar su indexación.

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

Primeras consultas a vigilar: `ITC 02.1.02`, `ITC 02.01.02`, `curso operador
maquinaria arranque carga viales`, `curso pala cargadora minería`, `ET
2001-1-08`, `ET 2000-1-08`, `curso perforista`, `establecimientos de
beneficio formación`, `reciclaje 5 horas minería`, `curso sílice cristalina
respirable`, `ITC 02.0.02`, `camión y volquete minería`, `inminer campus`.

Para la marca, filtra también por consultas que contengan `inminer`: si
aparecen impresiones de otras entidades homónimas, la desambiguación (pie con
NAP, `Organization` con CIF y dirección, enlace a inminer.es) debe ir
ganando terreno con el tiempo.

## 8. Detectar canibalización

En **Rendimiento**, filtra por una consulta concreta y mira la pestaña
**Páginas**. Si dos URLs reciben impresiones para la misma consulta, compiten
entre sí.

Riesgos conocidos:

- `/formacion-minera` (informacional: qué exige la norma) frente a
  `/catalogo` (comercial: qué se puede comprar) para «formación preventiva
  minería». Si compiten, reforzar la intención de cada una en vez de fusionar.
- `/itc-02-1-02` frente a `/itc-02-1-02/formacion-inicial-y-reciclaje` para
  «reciclaje ITC 02.1.02». La segunda debe ganar las consultas de horas y
  plazos; la primera, las de «qué es».
- `/catalogo?categoria=mineria` declara hoy como canónica `/catalogo` porque
  lista exactamente los mismos cursos. Si se publica un curso de otra
  categoría, la categoría recupera su canónica propia y vuelve al sitemap sin
  tocar código.

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
