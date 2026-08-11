export type AudioAvailability = {
  published: boolean
  audio_storage_path: string | null
  audio_external_url: string | null
}

export type Relation<T> = T | T[] | null

export function relationArray<T>(value: Relation<T> | undefined): T[] {
  if (Array.isArray(value)) return value
  return value == null ? [] : [value]
}

export function isPublishedAudioSegment(
  segment: AudioAvailability,
): boolean {
  return (
    segment.published &&
    Boolean(segment.audio_storage_path || segment.audio_external_url)
  )
}

/**
 * Un capítulo de una lección de diapositivas se publica sin fichero de audio:
 * basta con que esté publicado y tenga al menos una diapositiva.
 */
export function isPublishedSlideSegment(segment: {
  published: boolean
  lesson_segment_slides: unknown[]
}): boolean {
  return segment.published && segment.lesson_segment_slides.length > 0
}

export function hasAvailableLessonContent(lesson: {
  lesson_audio_segments: unknown[]
}): boolean {
  return lesson.lesson_audio_segments.length > 0
}

export function hasAvailableModuleContent(module: {
  lessons: Array<{ lesson_audio_segments: unknown[] }>
}): boolean {
  return module.lessons.some(hasAvailableLessonContent)
}
