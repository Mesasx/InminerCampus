# SEO Changelog — InmínerCampus

## 2026-10-08 — Clúster normativo, entidad, rendimiento y test sin referencias

Rama: `claude/stoic-wright-oz4far`

### Preguntas de los tests sin referencias de origen

Los bancos de preguntas se importan de libros editoriales y algunos enunciados
u opciones arrastraban su procedencia («…según la diapositiva?», «(Diapositiva
8)», «Tema 2 ·»…). El alumno sólo recibe enunciado y opciones a través de la RPC
`start_quiz_attempt` (nunca `explanation`), así que la limpieza se hace al
pintar: `src/lib/quiz-text.ts` → `stripSourceReferences()`, aplicada en
`src/routes/evaluacion.$enrollmentId.$quizId.tsx`. Supabase no se toca: la
procedencia sigue disponible para administración y mantenimiento. Pruebas en
`tests/quiz-sin-referencias-de-origen.test.ts`, incluido el caso real
`EB-20H-B4-Q02` y textos legítimos que no deben alterarse («conforme al
manual», «lámina de agua»…).

### Clúster de guías normativas (nuevo)

| URL | Intención |
|---|---|
| `/formacion-minera` | Qué formación necesita cada puesto (pilar general) |
| `/itc-02-1-02` | Qué es la ITC 02.1.02, especificaciones técnicas, presencialidad, cartilla |
| `/itc-02-1-02/formacion-inicial-y-reciclaje` | 20 h frente a 5 h, periodicidad, qué curso elegir |
| `/itc-02-0-02` | Polvo y sílice: valores límite y formación anual |

- Datos normativos en una única fuente: `src/lib/mining-regulation.ts` (BOE,
  identificadores, citas literales, fecha de revisión visible).
- Los cursos de cada guía salen del catálogo publicado (`src/lib/guide-courses.ts`):
  no hay slugs escritos a mano.
- `/formacion-preventiva-oficial` → **301** a `/formacion-minera`.
- JSON-LD: `Article` (autor INMINER INGENIERÍA, S.L.), `BreadcrumbList`,
  `FAQPage` con las mismas preguntas visibles, `ItemList` de cursos.

### Entidad

- `Organization` para INMINER INGENIERÍA, S.L. (CIF, dirección, inminer.es) y
  `EducationalOrganization` para InmínerCampus con `parentOrganization`,
  `alternateName` y `subOrganization` cruzados.
- `WebSite.alternateName` con las variantes «Inmíner Campus / Inminer Campus».
- Pie con razón social, CIF y dirección (mismos datos que el aviso legal).
- `/sobre-nosotros`: `Person` (sólo datos visibles en la página).

### Fichas de curso y catálogo

- `Course`: `provider` con nombre, `offers.category = "Paid"` (vocabulario de
  Google), `image`, `teaches`, `audience`, `coursePrerequisites`, `about` (norma)
  y `educationalCredentialAwarded` («Certificado de formación»).
- Tarjetas y selector: la versión por defecto enlaza la URL limpia; sólo la otra
  duración usa `?version=` (canónica siempre limpia).
- Corregido el selector de duración: con `?version=` las dos opciones quedaban
  marcadas como activas (`aria-current="page"`) y ninguna se resaltaba.
- `/catalogo?categoria=mineria` canonicaliza a `/catalogo` mientras liste los
  mismos cursos, y sale del sitemap en ese caso.
- Enlaces contextuales ficha → guía de su ITC.

### Metadatos y encabezados

- Home: H1 «Inmíner Campus · Cursos de minería y formación preventiva» (la
  línea ya visible del hero; el eslogan pasa a párrafo con la misma clase, sin
  cambio visual).
- Títulos y descripciones nuevos en home, catálogo, guías y «Sobre nosotros»;
  todas las descripciones ≤ 158 caracteres (test).
- `buildTitle` omite « | InmínerCampus» si el título superaría 70 caracteres.

### Rendimiento

| Recurso | Antes | Después |
|---|---|---|
| Imagen del hero (LCP de la home) | PNG de 2,56 MB con extensión `.webp` | WebP real, 398 KB |
| Portadas de curso (×6) | PNG ~2 MB | WebP 1280 px, ~80–100 KB |
| Logotipo en cabecera | PNG 1338 px, 403 KB | WebP 420 px, 15 KB (`<picture>` con PNG de reserva) |

Los PNG originales se mantienen para Open Graph, correo y PDF.

### Verificación

```
npm run check → 327 pruebas: 325 pasan, 0 fallan, 2 omitidas (requieren servidor)
SEO_SMOKE_BASE_URL contra build local con Supabase simulado → 4/4
```

---

## 2026-09-04 — Indexabilidad, metadatos y datos estructurados

Rama: `feat/seo-ssr-indexabilidad`

Punto de partida y evidencias en [`SEO_BASELINE.md`](./SEO_BASELINE.md).

### Causa raíz corregida

Las fichas de curso cargaban sus datos en un `useEffect` con el cliente de
Supabase del navegador. Durante el SSR ese efecto no se ejecuta, así que el
HTML servido contenía cabecera, «Cargando la información del curso…» y pie. El
catálogo y el carrusel de la home tenían el mismo problema, de modo que
**tampoco había ningún enlace a `/cursos/...` en el HTML de todo el sitio**.

La solución usa lo que el stack ya ofrecía (loaders de TanStack Start ejecutados
en SSR) en lugar de migrar de framework o añadir prerenderizado externo.

### Archivos nuevos

| Archivo | Qué hace |
|---|---|
| `src/lib/seo.ts` | Fuente única de metadatos: `seoHead()`, canónicas, Open Graph, Twitter, `robots`, y el NAP de la empresa |
| `src/lib/schema.ts` | Constructores de JSON-LD: `EducationalOrganization`, `WebSite`, `Course`, `BreadcrumbList`, `FAQPage` |
| `src/lib/course-seo.ts` | Título, descripción y FAQs de cada ficha, derivados de los datos publicados |
| `src/lib/public-courses.ts` | Lectura del catálogo desde loaders, con cliente Supabase **anónimo** (respeta RLS) |
| `src/lib/public-routes.ts` | Clasificación de rutas: indexables vs. `noindex` |
| `src/components/JsonLd.tsx` | Inserta el `@graph` en el HTML del servidor |
| `src/components/Breadcrumbs.tsx` | Migas de pan visibles |
| `src/routes/sitemap[.]xml.ts` | `sitemap.xml` generado desde Supabase en cada petición |
| `src/routes/robots[.]txt.ts` | `robots.txt` con referencia al sitemap |
| `tests/seo-metadata.test.ts` | 21 pruebas: canónicas, JSON-LD, precisión legal, clasificación de rutas |
| `tests/seo-ssr-cursos.test.ts` | Prueba prioritaria: el contenido de la ficha está en el HTML sin hidratación |

### Archivos modificados

| Archivo | Cambio |
|---|---|
| `src/routes/cursos.$courseSlug.tsx` | `loader` SSR, `head` derivado del curso, JSON-LD, migas, FAQs visibles, cursos relacionados, `notFound()` real |
| `src/routes/catalogo.tsx` | `loader` SSR, metadatos por categoría, `<h1>` por categoría, migas |
| `src/routes/index.tsx` | `loader` SSR del carrusel, metadatos propios, `Organization` + `WebSite` |
| `src/routes/__root.tsx` | `lang="es-ES"`, título y descripción de reserva |
| `src/components/Hero.tsx` | El titular pasa de `<p>` a `<h1>` (mismas clases, sin cambio visual) |
| `src/components/CourseSlider.tsx` | Recibe los cursos ya resueltos; se retiran los estados de carga y error |
| `src/styles/app.css` | Estilos de migas de pan y de FAQ, con los tokens existentes |
| 22 rutas | `head` propio con `seoHead()`; `noindex` en las privadas |
| `tests/transport-definitive-content.test.ts` | La aserción de la etiqueta de versión apunta a `course-seo.ts`, su nuevo emplazamiento |

### Archivos eliminados

| Archivo | Motivo |
|---|---|
| `src/hooks/usePublicCourses.ts` | Sin consumidores tras pasar home y catálogo a SSR. Dejarlo invitaba a reintroducir la carga en cliente |

### Antes y después (mismo `curl`, sin ejecutar JavaScript)

| Señal | Antes | Después |
|---|---|---|
| Tamaño del HTML | 7 015 B | 29 236 B |
| `<title>` | genérico del sitio | `Curso Operador de maquinaria de arranque, carga y viales \| InmínerCampus` |
| `meta description` | genérica del sitio | propia, con horas y referencia normativa |
| `<h1>` | **0** | `Operador de maquinaria de arranque, carga y viales` |
| Nombre del curso en el HTML | **0 ocurrencias** | presente en título, H1, JSON-LD y cuerpo |
| `rel="canonical"` | ausente | `https://inminercampus.com/cursos/operador-maquinaria-arranque-carga-viales` |
| `meta robots` | ausente | `index, follow, max-image-preview:large, …` |
| Open Graph | ausente | 7 etiquetas, imagen propia del curso |
| JSON-LD | ausente | `Course` + `BreadcrumbList` + `FAQPage`, validado |
| Encabezados de sección | ninguno | 9 `<h2>` |
| Enlaces `/cursos/` en la home | **0** | 4 |
| Cursos en el HTML del catálogo | **0** | los 3 publicados |
| `robots.txt` | 404 | 200 |
| `sitemap.xml` | 404 | 200, 16 URLs desde Supabase |
| Slug inexistente | 200 (soft 404) | **404** |
| `/mis-cursos`, `/acceso`, `/admin` | indexables | `noindex, nofollow` |

### Precisión legal

Verificado en el BOE antes de escribir ningún texto:

> «La formación regulada en la presente instrucción técnica complementaria
> tendrá únicamente carácter presencial.»
> — Orden ITC/2699/2011 ([BOE-A-2011-15940](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2011-15940))

En consecuencia:

- Ningún texto generado usa «oficial», «homologado» ni «habilitante». Hay una
  prueba automática que lo impide (`tests/seo-metadata.test.ts`).
- Las fichas de ITC 02.1.02 muestran la cita literal con enlace al BOE, y una
  FAQ que responde «no» a si la formación puede hacerse íntegramente en línea.
- El curso de sílice **no** hereda ese aviso: se encuadra en la ITC 02.0.02
  (Orden TED/723/2021), que es otra instrucción y no exige presencialidad.
- `courseMode` en JSON-LD refleja la modalidad guardada: `blended` para los
  híbridos, nunca `online`.
- Los `Offer` declaran `valueAddedTaxIncluded: false`, porque los precios del
  catálogo son netos.

### Seguridad

- El SSR lee con la clave **publishable** (anónima). No se usa `service_role` en
  ninguna ruta pública, y hay una prueba que lo verifica.
- Las políticas RLS `courses_public_published` y `course_versions_visible` ya
  exponen a `anon` exactamente las filas publicadas: no hizo falta tocar RLS.
- Sin cambios en autenticación, Stripe, facturación, progreso, evaluaciones ni
  panel de administración. Ninguna migración de base de datos.
- `robots.txt` bloquea sólo `/api/`. Las rutas privadas se excluyen con
  `noindex`, que Google necesita poder rastrear para obedecer.

### Verificación

```
npm run check   → 180 pruebas, 178 pasan, 0 fallan (2 omitidas sin servidor)
                  typecheck limpio · build correcto
```

Pruebas de humo contra el servidor construido (`SEO_SMOKE_BASE_URL`): las 4
pasan, incluida la que comprueba que **todas** las URLs del sitemap responden
200.
