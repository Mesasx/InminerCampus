// Enlaces internos a las fichas de curso.

/**
 * Parámetros de búsqueda del enlace a una ficha.
 *
 * La versión que la ficha selecciona por defecto se enlaza con la URL limpia,
 * que es la canónica. Así el sitio deja de generar un enlace interno con
 * `?version=<uuid>` por cada tarjeta: sólo la otra duración (p. ej. el
 * reciclaje de 5 h) lo necesita para abrir la ficha con esa opción marcada, y
 * su canónica sigue siendo la URL limpia.
 */
export function courseLinkSearch(course: {
  versionId: string
  isDefaultVersion?: boolean
}): { version?: string } {
  return course.isDefaultVersion ? {} : { version: course.versionId }
}
