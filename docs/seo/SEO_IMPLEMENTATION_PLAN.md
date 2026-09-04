# Plan de implementación SEO — InmínerCampus

Prioridades: **P0** bloquea la indexación · **P1** impacto alto · **P2**
crecimiento · **P3** mejoras futuras.

Estado a 4 de septiembre de 2026.

---

## P0 — Completado ✅

Todo lo que impedía físicamente que Google viera o entendiera el sitio.

| # | Tarea | Estado | Archivos |
|---|---|---|---|
| P0-1 | Ficha de curso renderizada en servidor (`loader` + Supabase anónimo) | ✅ | `src/routes/cursos.$courseSlug.tsx`, `src/lib/public-courses.ts` |
| P0-2 | Catálogo renderizado en servidor | ✅ | `src/routes/catalogo.tsx` |
| P0-3 | Carrusel de cursos de la home renderizado en servidor | ✅ | `src/routes/index.tsx`, `src/components/CourseSlider.tsx` |
| P0-4 | `sitemap.xml` dinámico desde Supabase | ✅ | `src/routes/sitemap[.]xml.ts` |
| P0-5 | `robots.txt` con referencia al sitemap | ✅ | `src/routes/robots[.]txt.ts` |
| P0-6 | Sistema centralizado de metadatos (`seoHead`) | ✅ | `src/lib/seo.ts` |
| P0-7 | Título y descripción únicos en las 20+ rutas públicas | ✅ | todas las rutas |
| P0-8 | `canonical` en todas las páginas indexables | ✅ | `src/lib/seo.ts` |
| P0-9 | Canonicalización de `?version=` a la URL limpia | ✅ | `src/routes/cursos.$courseSlug.tsx` |
| P0-10 | `noindex, nofollow` en 22 rutas privadas o sin valor de búsqueda | ✅ | rutas de acceso, compra, campus, empresa, admin |
| P0-11 | HTTP 404 real para slugs inexistentes | ✅ | `src/routes/cursos.$courseSlug.tsx` |
| P0-12 | Pruebas automáticas de SEO e indexabilidad | ✅ | `tests/seo-metadata.test.ts`, `tests/seo-ssr-cursos.test.ts` |

---

## P1 — Completado ✅

| # | Tarea | Estado | Archivos |
|---|---|---|---|
| P1-1 | `EducationalOrganization` + `WebSite` con NAP verificable | ✅ | `src/lib/schema.ts` |
| P1-2 | `Course` con `hasCourseInstance` y `Offer` por versión | ✅ | `src/lib/schema.ts` |
| P1-3 | `BreadcrumbList` + migas de pan visibles | ✅ | `src/components/Breadcrumbs.tsx` |
| P1-4 | `FAQPage` generado desde datos reales y visible en la ficha | ✅ | `src/lib/course-seo.ts` |
| P1-5 | Open Graph y Twitter Cards, con imagen propia por curso | ✅ | `src/lib/seo.ts` |
| P1-6 | `lang="es-ES"` y `og:locale=es_ES` | ✅ | `src/routes/__root.tsx` |
| P1-7 | `<h1>` en la home (el hero pasa de `<p>` a `<h1>`) | ✅ | `src/components/Hero.tsx` |
| P1-8 | `<h1>` propio por categoría del catálogo | ✅ | `src/routes/catalogo.tsx` |
| P1-9 | Enlaces internos: cursos relacionados en cada ficha | ✅ | `src/routes/cursos.$courseSlug.tsx` |
| P1-10 | Bloque visible con la cita del BOE sobre presencialidad | ✅ | `src/lib/course-seo.ts` |

---

## P1 — Pendiente (requiere decisión de negocio)

| # | Tarea | Por qué no se ha hecho |
|---|---|---|
| P1-11 | Revisar el uso de «Formación Preventiva Oficial» | Es un claim de marca presente en `short_description` de dos cursos y en el título global anterior. «Oficial» no es un término definido en la ITC 02.1.02. **Requiere validación legal, no una decisión de SEO.** |
| P1-12 | Rellenar `renewal_interval_months` del curso de arranque | La ET 2001-1-08 fija frecuencia máxima de 2 años, pero el campo está vacío en Supabase. Al rellenarlo (24), la FAQ de periodicidad aparece sola. **Es un cambio de dato: lo debe confirmar quien gestiona el catálogo.** |
| P1-13 | Página de equipo docente / responsable técnico | Necesita nombres, titulaciones y consentimiento de las personas. No se puede inventar. |

---

## P2 — Crecimiento: hub editorial

Ninguna de estas páginas existe. **No generar 100 artículos con IA.** Estas
ocho responden preguntas reales que hoy nadie contesta bien en español.

Para cada una: keyword, intención, dificultad, URL, H1, esquema, enlaces y CTA.

### 1. ¿Se puede hacer la formación ITC 02.1.02 online? ⭐ máxima prioridad

- **Keyword:** curso ITC 02.1.02 online · **Intención:** comercial conflictiva
- **Dificultad:** M · **SERP actual:** centros que venden «ITC online» sin matizar
- **URL:** `/guias/itc-02-1-02-presencial-u-online`
- **H1:** ¿La formación de la ITC 02.1.02 se puede hacer online?
- **Outline:** respuesta directa (no) → cita literal de la Orden ITC/2699/2011 →
  qué sí puede hacerse en línea (teoría, material, seguimiento, registro) → cómo
  lo organiza InmínerCampus → cómo reconocer una oferta que no cumple
- **Enlaces:** → `/guias/itc-02-1-02`, → las dos fichas de ITC 02.1.02
- **CTA:** consultar modalidad para tu centro de trabajo
- **Por qué primero:** captura una intención con demanda real que los
  competidores resuelven mal, y es contenido que gana enlaces por sí solo.

### 2. Qué es la ITC 02.1.02

- **Keyword:** ITC 02.1.02 · **Intención:** informacional · **Dificultad:** M
- **URL:** `/guias/itc-02-1-02` · **H1:** Qué es la ITC 02.1.02 y a quién obliga
- **Outline:** qué es y de dónde viene (Orden ITC/1316/2008) → a quién aplica →
  tabla puesto → especificación técnica → horas → presencialidad → reciclaje
- **Esquema:** `Article` + `FAQPage` · **Enlaces:** a todas las guías del cluster
- **Es la página pilar del cluster B.**

### 3. Formación inicial vs. reciclaje

- **Keyword:** reciclaje ITC minería / formación inicial 20 horas
- **Intención:** comercial · **Dificultad:** B
- **URL:** `/guias/formacion-inicial-vs-reciclaje`
- **H1:** Formación inicial y reciclaje en minería: diferencias, horas y plazos
- **Outline:** 20 h inicial (ET 2001-1-08) → mínimo 5 h lectivas de reciclaje
  (Orden ITC/2699/2011) → frecuencia máxima 2 años → qué pasa si caduca →
  cuál te toca a ti
- **CTA:** selector directo a la versión de 5 h o 20 h de cada ficha
- **Alto valor comercial: resuelve la duda previa a la compra.**

### 4. Qué formación necesita un trabajador minero

- **Keyword:** formación obligatoria minería · **Intención:** informacional
- **Dificultad:** M · **URL:** `/guias/formacion-obligatoria-trabajador-minero`
- **H1:** Qué formación preventiva debe recibir un trabajador de minería
- **Outline:** marco (RGNBSM) → ITC 02.1.02 por puesto → ITC 02.0.02 por agente
  → quién debe impartirla → documentación que debe conservar la empresa
- **Es la puerta de entrada del embudo para quien no conoce la normativa.**

### 5. La ITC 02.0.02 y la sílice cristalina respirable

- **Keyword:** ITC 02.0.02 · **Intención:** informacional · **Dificultad:** B
- **URL:** `/guias/itc-02-0-02-silice`
- **H1:** ITC 02.0.02: formación frente al polvo y la sílice cristalina respirable
- **Outline:** Orden TED/723/2021 → por qué es distinta de la ITC 02.1.02 →
  a quién aplica → **periodicidad anual** → qué debe cubrir la formación
- **Enlaces:** → ficha de sílice · **CTA:** curso de 3 h
- **Baja competencia y norma reciente: la oportunidad más rentable del hub.**

### 6. Las especificaciones técnicas de la ITC 02.1.02

- **Keyword:** ET 2001-1-08 / ET 2000-1-08 / ET 2004-1-10
- **Intención:** informacional · **Dificultad:** B
- **URL:** `/guias/especificaciones-tecnicas-itc-02-1-02`
- **H1:** Especificaciones técnicas de la ITC 02.1.02: qué regula cada una
- **Outline:** tabla completa (2000-1-08, 2001-1-08, 2002-1-08, 2003-1-10,
  2004-1-10, 2005-1-11) con enlace al BOE de cada una y a la ficha si existe
- **Cubre el cluster E sin crear páginas comerciales de cursos inexistentes.**

### 7. La cartilla de formación del trabajador (ET 2005-1-11)

- **Keyword:** cartilla de formación minera · **Intención:** informacional B2B
- **Dificultad:** B · **URL:** `/guias/cartilla-formacion-minera`
- **H1:** Cartilla de formación y libro de registro de cursos en minería
- **Outline:** qué son (ET 2005-1-11) → quién los custodia → qué debe constar →
  cómo se acredita ante la autoridad minera
- **CTA:** gestión de formación para empresas → `/empresas`

### 8. Prevención de riesgos en actividades extractivas

- **Keyword:** prevención de riesgos en minería · **Intención:** informacional
- **Dificultad:** A (compite con portales institucionales) · **Prioridad:** la
  más baja del hub
- **URL:** `/guias/prevencion-riesgos-mineria`
- **Sólo abordarla cuando las siete anteriores estén publicadas e indexadas.**

### Requisitos comunes del hub

- Plantilla con `Article` + `author` + `dateModified` visible.
- Bloque **«Fuentes oficiales»** con enlaces directos al BOE.
- **«Revisado por [profesional]»** y **«Última actualización»** sólo cuando haya
  una persona real que asuma la revisión y un compromiso de mantenerlo. Si no,
  se omite: un sello de revisión falso es peor que ninguno.
- Cada guía enlaza a la ficha comercial correspondiente, nunca al revés como
  única salida.

---

## P2 — Otras tareas

| # | Tarea | Notas |
|---|---|---|
| P2-1 | Analítica con consentimiento | Medir: landing orgánica → visita a ficha → CTA → checkout → compra, y conversión orgánica por curso. Evaluar una solución sin cookies (Plausible/Umami) para no tocar el banner ni la política de privacidad. |
| P2-2 | Alta y verificación en Search Console | Ver [`SEO_SEARCH_CONSOLE_SETUP.md`](./SEO_SEARCH_CONSOLE_SETUP.md). **Hacer inmediatamente tras el despliegue.** |
| P2-3 | Medir Core Web Vitals reales | Sin datos de campo no se puede optimizar con criterio. |
| P2-4 | Reducir el bundle de Supabase en rutas públicas | Las páginas públicas ya no consultan Supabase desde el navegador, pero el cliente completo (auth + realtime + storage) sigue entrando en el bundle. |
| P2-5 | Autoalojar las fuentes | Elimina dos conexiones externas de la ruta crítica. |
| P2-6 | Imagen Open Graph propia por curso | Hoy se reutiliza la foto de catálogo. Una imagen 1200×630 con el nombre del curso mejora el CTR al compartir. |
| P2-7 | Google Business Profile | Sólo si hay atención presencial real en Calle La Solana 60, Ciudad Real. **No inventar sedes.** |

---

## P3 — Futuro

| # | Tarea | Notas |
|---|---|---|
| P3-1 | Agrupar tarjetas por curso en el catálogo | Hoy un curso con dos versiones ocupa dos tarjetas. Cambio de UX, no de SEO. |
| P3-2 | Ampliar catálogo a ET 2004-1-10 (establecimientos de beneficio) | Decisión de producto. Abre el cluster E. |
| P3-3 | Publicar `operadores-perforacion-corte-exterior` | Está en borrador. Al publicarlo entra solo en el sitemap. |
| P3-4 | Página por convocatoria presencial | Sólo si hay fechas y ubicaciones reales; entonces deja de ser doorway. |
| P3-5 | `hreflang` | Innecesario hoy: un solo idioma y un solo mercado. |

---

## Riesgos vigilados

1. **Caída de TTFB.** Las páginas públicas ahora consultan Supabase en el
   servidor. Es la contrapartida correcta (contenido indexable), pero conviene
   vigilar el TTFB y, si sube, cachear el catálogo en el borde: cambia poco y
   `s-maxage` ya está puesto en sitemap y robots.
2. **`noindex` recién aplicado a rutas que ya estaban indexadas.** Google tarda
   semanas en procesarlo. **No bloquear esas rutas en `robots.txt`**: si no
   puede rastrearlas, nunca leerá el `noindex`. Por eso `robots.txt` sólo
   bloquea `/api/`.
3. **`formacion-stvh` marcado como `noindex`.** Es formación interna de cliente,
   sin precio y por invitación. Si se decidiera comercializarla, basta cambiar
   `access_mode` a `purchase`: entra sola en el sitemap y pasa a indexable.
