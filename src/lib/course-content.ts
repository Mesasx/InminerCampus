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
