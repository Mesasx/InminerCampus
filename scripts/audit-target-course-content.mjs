import process from 'node:process'
import { createClient } from '@supabase/supabase-js'

const targets = [
  {
    slug: 'operadores-establecimientos-beneficio',
    label: 'Establecimiento de Beneficio',
    durations: [5, 20],
    expectedSegments: 50,
    expectedSlides: 100,
  },
  {
    slug: 'operadores-perforacion-corte-exterior',
    label: 'Perforadora',
    durations: [20],
    expectedSegments: 50,
    expectedSlides: 50,
  },
]

const supabaseUrl = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Faltan SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY.')
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
})

const portuguesePatterns = [
  /\b(?:não|também|informação|explicação|formação|trabalho|segurança)\b/giu,
  /\b(?:equipamentos|máquinas e equipamentos|riscos associados)\b/giu,
]

function relationRows(value) {
  if (!value) return []
  return Array.isArray(value) ? value : [value]
}

function countPortuguese(text) {
  return portuguesePatterns.reduce(
    (count, pattern) => count + (text.match(pattern)?.length ?? 0),
    0,
  )
}

async function auditVersion(course, target, version) {
  const { data: modules, error } = await supabase
    .from('course_modules')
    .select(
      'id, position, title, lessons(id, position, title, lesson_audio_segments(id, position, lesson_code, manual_chapter, title, published, narration_text, audio_storage_path, audio_external_url, lesson_segment_slides(id, position, title, body, image_storage_path, image_external_url), lesson_segment_notes(summary, source_label, approved)))',
    )
    .eq('course_version_id', version.id)
    .gte('position', 1)
    .lte('position', 5)
    .order('position')
  if (error) throw error

  const segments = relationRows(modules).flatMap((module) =>
    relationRows(module.lessons).flatMap((lesson) =>
      relationRows(lesson.lesson_audio_segments),
    ),
  )
  const slides = segments.flatMap((segment) =>
    relationRows(segment.lesson_segment_slides),
  )
  const notes = segments.flatMap((segment) =>
    relationRows(segment.lesson_segment_notes),
  )
  const explanations = slides.map((slide) => slide.body?.trim() ?? '')
  const noteExplanations = notes.map((note) => note.summary?.trim() ?? '')
  const visibleTexts = [
    course.title,
    ...relationRows(modules).flatMap((module) => [
      module.title,
      ...relationRows(module.lessons).map((lesson) => lesson.title),
    ]),
    ...segments.flatMap((segment) => [
      segment.title,
      segment.manual_chapter,
      segment.narration_text,
    ]),
    ...slides.flatMap((slide) => [slide.title, slide.body]),
    ...noteExplanations,
  ].filter(Boolean)
  const portugueseMatches = visibleTexts.reduce(
    (count, text) => count + countPortuguese(text),
    0,
  )
  const mojibakeMatches = visibleTexts.filter((text) => /Ã|Â|�/u.test(text))
    .length
  const sourceLabels = [...new Set(notes.map((note) => note.source_label).filter(Boolean))]

  return {
    course: target.label,
    slug: course.slug,
    durationHours: version.duration_hours,
    versionId: version.id,
    segments: {
      actual: segments.length,
      expected: target.expectedSegments,
      published: segments.filter((segment) => segment.published).length,
    },
    slides: {
      actual: slides.length,
      expected: target.expectedSlides,
      withImage: slides.filter(
        (slide) => slide.image_storage_path || slide.image_external_url,
      ).length,
      withExplanation: explanations.filter(Boolean).length,
    },
    audio: {
      withSource: segments.filter(
        (segment) =>
          segment.audio_storage_path || segment.audio_external_url,
      ).length,
      expected: target.expectedSegments,
    },
    transcripts: {
      actual: segments.filter((segment) => segment.narration_text?.trim())
        .length,
      expected: target.expectedSegments,
    },
    notes: {
      actual: notes.length,
      approved: notes.filter((note) => note.approved).length,
      nonEmpty: noteExplanations.filter(Boolean).length,
      shortestCharacters: noteExplanations.length
        ? Math.min(...noteExplanations.map((text) => text.length))
        : 0,
      sources: sourceLabels,
    },
    portugueseMatches,
    mojibakeMatches,
  }
}

const report = []
for (const target of targets) {
  const { data: course, error } = await supabase
    .from('courses')
    .select('id, slug, title, course_versions(id, duration_hours)')
    .eq('slug', target.slug)
    .single()
  if (error) throw error

  for (const duration of target.durations) {
    const version = relationRows(course.course_versions).find(
      (candidate) => candidate.duration_hours === duration,
    )
    if (!version) throw new Error(`Falta ${target.label} ${duration} h.`)
    report.push(await auditVersion(course, target, version))
  }
}

console.log(JSON.stringify(report, null, 2))
