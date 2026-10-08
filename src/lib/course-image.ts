import type { PublicCourse } from './types'

// Portadas oficiales del catálogo, una por curso. Llevan el título compuesto
// dentro de la propia imagen, así que la tarjeta las encuadra sin recortar por
// los lados (ver `.course-card__visual` en app.css).
//
// Las fotos genéricas del carrusel (`campus-carousel-*`) ya no son portada de
// ningún curso. Se conservan porque la home usa algunas como imágenes de
// sección.
const imagesBySlug: Record<string, string> = {
  'operador-maquinaria-arranque-carga-viales':
    '/images/curso-maquinaria-arranque-portada.png',
  'operador-maquinaria-transporte-camion-volquete':
    '/images/curso-maquinaria-transporte-portada.png',
  'administracion-personal-servicios-no-mantenimiento':
    '/images/curso-administracion-portada.png',
  'prevencion-polvo-silice-cristalina-respirable':
    '/images/curso-silice-portada.png',
  'formacion-stvh': '/images/curso-stvh-portada.jpg',
  'operadores-establecimientos-beneficio':
    '/images/curso-establecimientos-beneficio-portada.png',
  'operadores-perforacion-corte-exterior':
    '/images/curso-perforadora-portada.png',
}

// Las portadas PNG pesan unos 2 MB cada una. Para pintarlas en pantalla
// (catálogo, carrusel, fichas) se sirve una copia WebP de 1280 px generada a
// partir del mismo original, que pesa en torno a 90 KB. Los PNG se conservan
// como imagen social: algunos rastreadores de Open Graph todavía no aceptan
// WebP.
const webpCovers = new Set([
  '/images/curso-maquinaria-arranque-portada.png',
  '/images/curso-maquinaria-transporte-portada.png',
  '/images/curso-administracion-portada.png',
  '/images/curso-silice-portada.png',
  '/images/curso-establecimientos-beneficio-portada.png',
  '/images/curso-perforadora-portada.png',
])

/** Imagen original del curso, apta para Open Graph y datos estructurados. */
export function courseSocialImage(
  course: Pick<PublicCourse, 'cover_storage_path' | 'slug'>,
) {
  if (course.cover_storage_path?.startsWith('/')) {
    return course.cover_storage_path
  }

  return imagesBySlug[course.slug] ?? '/images/inminer-campus-hero-engineering.png'
}

/** Imagen del curso optimizada para mostrarla en la interfaz. */
export function courseImage(
  course: Pick<PublicCourse, 'cover_storage_path' | 'slug'>,
) {
  const original = courseSocialImage(course)
  return webpCovers.has(original) ? original.replace(/\.png$/, '.webp') : original
}
