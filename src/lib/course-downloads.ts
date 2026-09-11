// Material descargable de un curso.
//
// El alumno sólo debe encontrar dos documentos: el libro de texto y la
// presentación. Todo lo demás que exista en la base de datos —transcripciones,
// PDF sueltos por bloque, recursos auxiliares o duplicados por lección— sigue
// guardado y disponible para administración, pero no se ofrece como descarga.
//
// Ningún nombre de archivo está fijado: cada curso declara sus recursos y aquí
// se eligen por su tipo, con el título que cada curso les haya dado.

export type DownloadableResource = {
  id: string
  kind: string
  title: string
  storage_path?: string | null
  external_url?: string | null
  downloadable?: boolean
  resolvedUrl?: string
}

export type CourseDownload = {
  id: string
  slot: 'manual' | 'presentation'
  label: string
  title: string
  url: string
  downloadable: boolean
}

const SLOT_LABELS = {
  manual: 'Libro de texto / Manual',
  presentation: 'Presentación del curso',
} as const

// Tipos que cada hueco acepta, en orden de preferencia. El tipo genérico `pdf`
// sólo sirve de reserva para los cursos antiguos que no distinguían.
const SLOT_KINDS = {
  manual: ['manual'],
  presentation: ['presentation'],
} as const

function usableUrl(resource: DownloadableResource) {
  return resource.resolvedUrl || resource.external_url || ''
}

/**
 * Elige el libro de texto y la presentación entre todos los recursos de la
 * versión del curso y de la lección.
 *
 * Los recursos de la versión mandan sobre los de la lección: son los oficiales
 * del curso, mientras que los de lección suelen ser copias repetidas en cada
 * bloque. Un recurso sin enlace utilizable no se ofrece, para no dejar al
 * alumno delante de una descarga rota.
 */
export function selectCourseDownloads(
  versionResources: DownloadableResource[],
  lessonResources: DownloadableResource[] = [],
): CourseDownload[] {
  const downloads: CourseDownload[] = []

  for (const slot of ['manual', 'presentation'] as const) {
    const accepted = SLOT_KINDS[slot] as readonly string[]
    const candidate =
      versionResources.find(
        (resource) =>
          accepted.includes(resource.kind) && Boolean(usableUrl(resource)),
      ) ??
      lessonResources.find(
        (resource) =>
          accepted.includes(resource.kind) && Boolean(usableUrl(resource)),
      )

    if (!candidate) continue

    downloads.push({
      id: candidate.id,
      slot,
      label: SLOT_LABELS[slot],
      title: candidate.title,
      url: usableUrl(candidate),
      downloadable: candidate.downloadable !== false,
    })
  }

  return downloads
}
