# SEO Changelog — InmínerCampus

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
