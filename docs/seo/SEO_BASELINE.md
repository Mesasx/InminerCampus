# SEO Baseline — InmínerCampus

**Fecha de la auditoría:** 4 de septiembre de 2026
**Dominio:** https://inminercampus.com
**Stack:** TanStack Start 1.168 + TanStack Router 1.170 + React 19, servidor Nitro, desplegado en Vercel. Datos en Supabase.

Este documento describe el estado **anterior** a la intervención. Lo implementado
está en [`SEO_CHANGELOG.md`](./SEO_CHANGELOG.md).

---

## 1. Hallazgo principal: las fichas de curso eran invisibles

El proyecto ya hacía SSR (la cabecera y el pie llegaban renderizados), pero
**la ficha de curso cargaba sus datos en un `useEffect` con el cliente de
Supabase del navegador**. Durante el SSR ese efecto no se ejecuta, así que el
HTML servido no contenía nada del curso.

Evidencia — `curl` a producción antes del cambio:

```
$ curl -s https://inminercampus.com/cursos/operador-maquinaria-arranque-carga-viales
status=200  size=7015 bytes

<title>InmínerCampus | Formación Preventiva Oficial en seguridad minera</title>
```

| Señal | Valor recibido |
|---|---|
| `<h1>` | **0 ocurrencias** |
| Nombre del curso en el HTML | **0 ocurrencias** |
| `rel="canonical"` | ausente |
| `application/ld+json` | ausente |
| Texto visible | `Campus Minería Otros Sobre nosotros` → **`Cargando la información del curso…`** → pie de página |

El rastreador recibía navegación, un mensaje de carga y el pie. Nada más.

### Agravante: las fichas estaban huérfanas

No existía **ni un solo enlace** a `/cursos/...` en el HTML servido de ninguna
página. El catálogo (`/catalogo`) también resolvía la lista en cliente
(`usePublicCourses`), y el carrusel de la home igual.

```
$ grep -c 'href="/cursos/' home.html catalogo.html
home.html:0
catalogo.html:0
```

Sin sitemap y sin enlaces internos, Google no tenía **ninguna** vía de
descubrimiento de las fichas salvo renderizar JavaScript por su cuenta, y aun
así no habría encontrado las URLs porque no estaban enlazadas en el DOM inicial.

---

## 2. Metadatos

Los metadatos estaban definidos **una sola vez**, en `src/routes/__root.tsx`.
Ninguna ruta declaraba `head` propio salvo la home, y sólo para precargar la
imagen del hero.

Las 12 URLs públicas comprobadas devolvían **el mismo `<title>` y la misma
`meta description`**:

```
[200] /                             InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /catalogo                     InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /sobre-nosotros               InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /formacion-preventiva-oficial InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /contacto                     InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /acceso                       InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /registro                     InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /mis-cursos                   InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /empresas                     InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /como-funciona                InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /certificados                 InmínerCampus | Formación Preventiva Oficial en seguridad minera
[200] /verificar-certificado        InmínerCampus | Formación Preventiva Oficial en seguridad minera
```

Ausentes en todo el sitio: `canonical`, `robots`, Open Graph, Twitter Cards,
datos estructurados.

---

## 3. Indexación y rutas privadas

`/acceso`, `/registro`, `/mis-cursos`, `/certificados`, `/perfil`, `/facturas`,
`/comprar/...`, `/pago/confirmado`, `/campus/...`, `/empresa/...` y `/admin/...`
devolvían **HTTP 200 con el título genérico y sin `noindex`**.

El contenido real está protegido por autenticación y RLS —no hay fuga de datos—
pero las URLs eran indexables y competían por el mismo título que las páginas
comerciales.

---

## 4. robots.txt y sitemap.xml

Ambos **inexistentes**:

```
$ curl -sI https://inminercampus.com/robots.txt   → 404
$ curl -sI https://inminercampus.com/sitemap.xml  → 404
```

No había forma de declarar el catálogo a Google ni de excluir zonas privadas.

---

## 5. Duplicación por parámetros

`CourseCard` enlaza cada ficha con `?version=<uuid>`, y el catálogo pinta una
tarjeta **por versión publicada**. Un curso con formación inicial (20 h) y
reciclaje (5 h) generaba por tanto dos URLs distintas para el mismo contenido:

```
/cursos/operador-maquinaria-arranque-carga-viales?version=406c3a42-…
/cursos/operador-maquinaria-arranque-carga-viales?version=ce4a139a-…
```

Sin `canonical`, las tres variantes (dos con parámetro y la limpia) competían
entre sí.

---

## 6. Errores 404

Un slug inexistente devolvía **HTTP 200** con el mensaje «Curso no disponible»:
un *soft 404* clásico. Google lo trata como página válida y lo mantiene en el
índice de rastreo.

---

## 7. Estructura de encabezados

- **Home:** ningún `<h1>`. El titular del hero (`CONOCIMIENTO QUE SE CONVIERTE
  EN SEGURIDAD.`) era un `<p class="campus-hero__count">` — estilo sin
  semántica. La página empezaba directamente en `<h2>`.
- **Ficha de curso:** `<h1>` presente en el DOM hidratado, pero **inexistente en
  el HTML servido**, que es lo que cuenta.
- **Catálogo y páginas estáticas:** `<h1>` correcto, pero genérico y sin
  relación con la consulta objetivo.

---

## 8. Señales geográficas y de entidad

| Señal | Estado anterior |
|---|---|
| `lang` | `es` (no distingue España de Latinoamérica) |
| Dirección corporativa | Sólo como texto en `/legal/aviso` |
| `Organization` / `EducationalOrganization` | Ausente |
| Relación InmínerCampus ↔ INMÍNER Ingeniería | Sólo insinuada en texto del pie |
| Moneda | EUR en la interfaz, no declarada en datos estructurados |
| `og:locale` | Ausente |

Los datos existen y son verificables (aviso legal): **INMINER INGENIERÍA, S.L.**,
CIF B13476148, Calle La Solana 60, 13005 Ciudad Real, 926 21 94 17,
administracion@inminer.es. Simplemente no estaban expresados de forma legible
para máquinas.

---

## 9. Marco legal: la restricción que condiciona toda la estrategia

Verificado en el BOE:

> **«La formación regulada en la presente instrucción técnica complementaria
> tendrá únicamente carácter presencial.»**
> — Orden ITC/2699/2011, de 4 de octubre ([BOE-A-2011-15940](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2011-15940)), que modifica la ITC 02.1.02.

> «Los cursos de formación con carácter de reciclaje o actualización de
> conocimientos, se adecuarán a un mínimo de cinco horas lectivas.»

Esto significa que **la keyword «curso ITC 02.1.02 online» no se puede atacar
con una promesa de formación conforme impartida 100 % en línea**. Varios
competidores lo hacen igualmente; InmínerCampus no debe.

El catálogo actual ya es coherente con la norma: los dos cursos de ITC 02.1.02
están guardados como `modality = 'hybrid'` con `practice_required = true`, y el
curso de sílice se encuadra explícitamente en la **ITC 02.0.02** (Orden
TED/723/2021), que es una instrucción distinta y **no** está sujeta a la
exigencia de presencialidad de la 02.1.02.

Normas verificadas y aplicables al catálogo:

| Referencia | Norma | Contenido |
|---|---|---|
| ITC 02.1.02 | Orden ITC/1316/2008 ([BOE-A-2008-8415](https://www.boe.es/buscar/act.php?id=BOE-A-2008-8415)) | Formación preventiva para el desempeño del puesto de trabajo |
| — modificación | Orden ITC/2699/2011 ([BOE-A-2011-15940](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2011-15940)) | Carácter **únicamente presencial**; reciclaje mínimo 5 h lectivas |
| ET 2001-1-08 | Res. 9-6-2008 ([BOE-A-2008-11500](https://www.boe.es/buscar/act.php?id=BOE-A-2008-11500)) | Arranque/carga/viales: pala cargadora y excavadora hidráulica de cadenas. **20 h**, frecuencia máxima **2 años** |
| — modificación | Res. 16-10-2014 ([BOE-A-2014-11209](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2014-11209)) | Añade el tractor de cadenas |
| ET 2000-1-08 | Res. 9-6-2008 ([BOE-A-2008-10482](https://boe.es/buscar/act.php?id=BOE-A-2008-10482)) | Maquinaria de transporte: camión y volquete, exterior |
| ITC 02.0.02 | Orden TED/723/2021 ([BOE-A-2021-11458](https://www.boe.es/buscar/doc.php?id=BOE-A-2021-11458)) | Protección frente a polvo y sílice cristalina respirable |

Especificaciones técnicas **no** cubiertas hoy por el catálogo, relevantes para
la estrategia de contenidos:

| Referencia | Norma | Puestos |
|---|---|---|
| ET 2002-1-08 | [BOE-A-2008-17191](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2008-17191) | Arranque/carga y perforación/voladura; picador, barrenista y ayudante minero, **interior** |
| ET 2003-1-10 | [BOE-A-2010-18826](https://www.boe.es/buscar/doc.php?id=BOE-A-2010-18826) | Grupos 5.1 a), b), c) y 5.2 a), b), d), f), h) |
| ET 2004-1-10 | [BOE-A-2010-18827](https://boe.es/buscar/doc.php?id=BOE-A-2010-18827) | Grupos 5.4 y 5.5 — **establecimientos de beneficio** y puestos comunes |
| ET 2005-1-11 | [BOE-A-2014-11208](https://www.boe.es/buscar/doc.php?id=BOE-A-2014-11208) | Cartilla de formación personal y Libro de registro de cursos |

> **Nota para revisión de negocio.** El título global del sitio usaba la
> expresión «Formación Preventiva Oficial», y `short_description` de dos cursos
> la repite. No es un término definido en la ITC 02.1.02. Nada de lo generado
> automáticamente en esta intervención emplea «oficial», «homologado» ni
> «habilitante»; los textos existentes se han dejado intactos porque son
> decisiones de marca y deben revisarse con criterio legal, no de SEO.

---

## 10. Contenido y catálogo actual

| Slug | Estado | Versiones publicadas | Modalidad | Referencia |
|---|---|---|---|---|
| `operador-maquinaria-arranque-carga-viales` | publicado | 20 h (349 €) · 5 h (149 €) | híbrida, práctica obligatoria | ITC 02.1.02 · ET 2001-1-08 |
| `operador-maquinaria-transporte-camion-volquete` | publicado | 20 h (349 €) · 5 h (149 €) | híbrida, práctica obligatoria | ITC 02.1.02 · ET 2000-1-08 |
| `prevencion-polvo-silice-cristalina-respirable` | publicado | 3 h (78 €) | online | ITC 02.0.02 · Orden TED/723/2021 |
| `formacion-stvh` | publicado | 3 h (sin precio) | online, acceso por código | — (formación interna de cliente) |
| `operadores-perforacion-corte-exterior` | **borrador** | — | — | — |

Sólo **tres** fichas tienen valor comercial en búsqueda. Es un catálogo
pequeño: la estrategia no puede depender del volumen de fichas, sino de la
calidad y precisión normativa de cada una y del contenido informacional que las
rodea.

---

## 11. Rendimiento

No se ha medido con datos de campo (no hay acceso a Search Console ni CrUX en
esta sesión). Observaciones estructurales:

- El hero ya declara `width`/`height`, `fetchPriority="high"` y `loading="eager"`,
  con `preload` en el `head`. Correcto para el LCP.
- Las imágenes de tarjeta llevan `loading="lazy"`.
- Fuentes desde Google Fonts (`fonts.googleapis.com` / `fonts.gstatic.com`):
  dos conexiones externas en la ruta crítica.
- El bundle cliente incluye `@supabase/supabase-js` completo (auth + realtime +
  storage) en la ruta pública, donde sólo hacen falta lecturas.
- **Cambio de esta intervención:** las páginas públicas ya no hacen una petición
  a Supabase desde el navegador para pintar el contenido principal; se resuelve
  en el servidor. Elimina una cascada cliente→Supabase del camino crítico de
  renderizado, aunque añade esa latencia al TTFB.

Medición real de LCP/CLS/INP: pendiente, requiere Search Console (ver
[`SEO_SEARCH_CONSOLE_SETUP.md`](./SEO_SEARCH_CONSOLE_SETUP.md)).

---

## 12. Situación competitiva

SERP española para las consultas del núcleo. Competidores reales observados:

| Dominio | Perfil | Fortaleza | Hueco que deja |
|---|---|---|---|
| `didascalia.es` | Centro formativo, catálogo ITC muy amplio | Cobertura de **todas** las ET, páginas por ciudad, autoridad temática | Fichas comerciales sin desarrollo normativo; poco contenido explicativo |
| `prevea.es` | Catálogo formativo | Páginas por especificación técnica | Contenido delgado, sin citas al BOE |
| `institutotecnologico.es` | Centro formativo | Volumen de cursos | Genérico, no especializado en minería |
| `inremin.es` | Especialista minero | Páginas por ET, lenguaje técnico | Poca profundidad por página |
| `prominerconsult.com` | Consultora minera | Perfil de ingeniería similar al de INMÍNER | Web escasa, poco contenido |
| `aridos.org` (ANEFA) | Asociación sectorial | Autoridad institucional | No compite comercialmente en todas las consultas |
| `camaraminera.org` | Asociación | Autoridad institucional | Informativo |
| `prevencionar.com` | Medio de PRL | Posiciona el artículo de referencia sobre ITC 02.1.02 y sus ET | Es un medio: no vende formación |
| `siliceysalud.es` | Portal institucional SCR | Autoridad en sílice | No comercial |
| `cursosenconstruccion.com`, `aprendemas.com` | Agregadores | Volumen de long tail | Contenido de baja calidad |

**Content gaps aprovechables:**

1. **Nadie explica bien la presencialidad.** La mayoría vende «curso ITC
   02.1.02» sin aclarar que la Orden ITC/2699/2011 exige carácter presencial.
   Una página que lo explique con la cita literal del BOE es simultáneamente
   más útil, más honesta y un imán de enlaces.
2. **Nadie mapea puesto → especificación técnica.** El usuario real («soy
   operador de pala cargadora, ¿qué curso necesito?») no sabe que busca la
   ET 2001-1-08. Falta una tabla puesto → ET → horas → periodicidad.
3. **Inicial vs. reciclaje.** Confusión generalizada entre las 20 h y las 5 h,
   y sobre cada cuánto hay que renovar.
4. **La cartilla de formación (ET 2005-1-11).** Documento que las empresas
   necesitan gestionar y sobre el que casi no hay contenido útil.
5. **Perfil de ingeniería.** Los competidores son academias. INMÍNER es una
   ingeniería con experiencia de campo en minería: es la ventaja de E-E-A-T más
   difícil de copiar, y hoy no se explota en absoluto.

---

## 13. Tabla de problemas

| Problema | Evidencia | Impacto | Prioridad | Solución | Archivo / URL |
|---|---|---|---|---|---|
| Ficha de curso sin contenido en el HTML servido | `curl` → 0 ocurrencias del título del curso, «Cargando la información del curso…» | Crítico: las fichas comerciales no pueden posicionar | **P0** | `loader` SSR con cliente Supabase anónimo | `src/routes/cursos.$courseSlug.tsx` |
| Fichas huérfanas: 0 enlaces `/cursos/` en el HTML | `grep -c 'href="/cursos/'` → 0 | Crítico: sin vía de descubrimiento | **P0** | SSR del catálogo y del carrusel de la home | `src/routes/catalogo.tsx`, `src/routes/index.tsx` |
| Sin `robots.txt` ni `sitemap.xml` | Ambos 404 | Crítico | **P0** | Rutas de servidor dinámicas desde Supabase | `src/routes/robots[.]txt.ts`, `src/routes/sitemap[.]xml.ts` |
| Título y descripción idénticos en las 12 URLs públicas | Auditoría §2 | Alto: canibalización total | **P0** | Sistema centralizado `seoHead()` por ruta | `src/lib/seo.ts` + todas las rutas |
| Sin `canonical` en ninguna página | 0 ocurrencias | Alto | **P0** | `canonical` en `seoHead()` | `src/lib/seo.ts` |
| `?version=` genera URLs duplicadas | 2 URLs por curso con 2 versiones | Alto | **P0** | Canónica siempre a la URL limpia | `src/routes/cursos.$courseSlug.tsx` |
| Rutas privadas indexables (200, sin `noindex`) | `/mis-cursos`, `/acceso`, `/admin`… | Alto | **P0** | `noindex, nofollow` por ruta | 22 rutas |
| Slug inexistente → HTTP 200 (soft 404) | `curl /cursos/inexistente` → 200 | Medio | **P0** | `throw notFound()` en el loader | `src/routes/cursos.$courseSlug.tsx` |
| Sin datos estructurados | 0 bloques `ld+json` | Alto | **P1** | `Organization`, `Course`, `Breadcrumb`, `FAQ` | `src/lib/schema.ts` |
| Home sin `<h1>` | 0 ocurrencias | Medio | **P1** | Hero pasa de `<p>` a `<h1>` | `src/components/Hero.tsx` |
| Sin migas de pan | — | Medio | **P1** | Componente + `BreadcrumbList` | `src/components/Breadcrumbs.tsx` |
| `lang="es"` sin región | `__root.tsx` | Medio | **P1** | `lang="es-ES"` + `og:locale` | `src/routes/__root.tsx` |
| Entidad de empresa no declarada | Sin `Organization` | Medio | **P1** | NAP completo en JSON-LD | `src/lib/schema.ts` |
| Sin Open Graph ni Twitter Cards | 0 ocurrencias | Medio | **P1** | Incluidos en `seoHead()` | `src/lib/seo.ts` |
| Modalidad legal no explicada al usuario | Ficha no cita la ITC/2699/2011 | Medio (confianza) | **P1** | Bloque visible + FAQ con cita al BOE | `src/lib/course-seo.ts` |
| Sin analítica de conversión orgánica | — | Medio | **P2** | Pendiente, con consentimiento | — |
| Sin contenido informacional (guías) | 0 URLs | Alto (crecimiento) | **P2** | Hub editorial | Ver plan |
| Catálogo duplica tarjetas por versión | 2 tarjetas del mismo curso | Bajo | **P3** | Agrupar por curso en la rejilla | `src/routes/catalogo.tsx` |
