import type { PublicCourse } from './types'

// Portadas oficiales del catálogo. Las tres primeras sustituyen a las fotos
// genéricas del carrusel (`campus-carousel-*`), que se conservan porque la
// home las sigue usando como imágenes de sección.
const imagesBySlug: Record<string, string> = {
  'operador-maquinaria-arranque-carga-viales':
    '/images/curso-maquinaria-arranque-portada.png',
  'operador-maquinaria-transporte-camion-volquete':
    '/images/curso-maquinaria-transporte-portada.png',
  'administracion-personal-servicios-no-mantenimiento':
    '/images/curso-administracion-portada.png',
  'prevencion-polvo-silice-cristalina-respirable':
    '/images/campus-carousel-silice.jpg',
  'formacion-stvh': '/images/curso-stvh-portada.jpg',
  'operadores-establecimientos-beneficio':
    '/images/curso-establecimientos-beneficio-portada.png',
  'operadores-perforacion-corte-exterior':
    '/images/curso-perforadora-portada.png',
}

export function courseImage(
  course: Pick<PublicCourse, 'cover_storage_path' | 'slug'>,
) {
  if (course.cover_storage_path?.startsWith('/')) {
    return course.cover_storage_path
  }

  return imagesBySlug[course.slug] ?? '/images/inminer-campus-hero-engineering.png'
}
