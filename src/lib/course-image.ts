import type { PublicCourse } from './types'

const imagesBySlug: Record<string, string> = {
  'operador-maquinaria-arranque-carga-viales':
    '/images/campus-carousel-operacion.jpg',
  'operador-maquinaria-transporte-camion-volquete':
    '/images/campus-carousel-inspeccion.jpg',
  'prevencion-polvo-silice-cristalina-respirable':
    '/images/campus-carousel-silice.jpg',
  'formacion-stvh': '/images/curso-stvh-portada.jpg',
}

export function courseImage(
  course: Pick<PublicCourse, 'cover_storage_path' | 'slug'>,
) {
  if (course.cover_storage_path?.startsWith('/')) {
    return course.cover_storage_path
  }

  return imagesBySlug[course.slug] ?? '/images/inminer-campus-hero-engineering.png'
}
