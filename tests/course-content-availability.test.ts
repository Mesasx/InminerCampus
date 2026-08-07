import assert from 'node:assert/strict'
import test from 'node:test'
import {
  hasAvailableLessonContent,
  hasAvailableModuleContent,
  isPublishedAudioSegment,
  relationArray,
} from '../src/lib/course-content.ts'

test('normaliza relaciones opcionales de Supabase', () => {
  const quiz = { id: 'quiz-1' }

  assert.deepEqual(relationArray(null), [])
  assert.deepEqual(relationArray(undefined), [])
  assert.deepEqual(relationArray(quiz), [quiz])
  assert.deepEqual(relationArray([quiz]), [quiz])
})

test('solo considera disponibles las partes publicadas que tienen audio', () => {
  assert.equal(
    isPublishedAudioSegment({
      published: true,
      audio_storage_path: 'version/block-1/audio/part-1-01.mp3',
      audio_external_url: null,
    }),
    true,
  )
  assert.equal(
    isPublishedAudioSegment({
      published: true,
      audio_storage_path: null,
      audio_external_url: 'https://media.example/audio.mp3',
    }),
    true,
  )
  assert.equal(
    isPublishedAudioSegment({
      published: false,
      audio_storage_path: 'version/block-1/audio/draft.mp3',
      audio_external_url: null,
    }),
    false,
  )
  assert.equal(
    isPublishedAudioSegment({
      published: true,
      audio_storage_path: null,
      audio_external_url: null,
    }),
    false,
  )
})

test('oculta las lecciones y módulos que no tienen partes disponibles', () => {
  const emptyLesson = { lesson_audio_segments: [] }
  const availableLesson = { lesson_audio_segments: [{ id: 'segment-1' }] }

  assert.equal(hasAvailableLessonContent(emptyLesson), false)
  assert.equal(hasAvailableLessonContent(availableLesson), true)
  assert.equal(hasAvailableModuleContent({ lessons: [emptyLesson] }), false)
  assert.equal(
    hasAvailableModuleContent({ lessons: [emptyLesson, availableLesson] }),
    true,
  )
})
