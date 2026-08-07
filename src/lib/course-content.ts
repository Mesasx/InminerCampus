export type AudioAvailability = {
  published: boolean
  audio_storage_path: string | null
  audio_external_url: string | null
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
