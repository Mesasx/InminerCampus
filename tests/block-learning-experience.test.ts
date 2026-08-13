import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'

const player = readFileSync(
  new URL('../src/components/AudioLessonPlayer.tsx', import.meta.url),
  'utf8',
)
const lessonRoute = readFileSync(
  new URL('../src/routes/campus.$enrollmentId.leccion.$lessonId.tsx', import.meta.url),
  'utf8',
)
const footer = readFileSync(
  new URL('../src/components/Footer.tsx', import.meta.url),
  'utf8',
)
const shell = readFileSync(
  new URL('../src/components/AppShell.tsx', import.meta.url),
  'utf8',
)
const migration = readFileSync(
  new URL(
    '../supabase/migrations/20260813111935_block_specific_training_and_assessments.sql',
    import.meta.url,
  ),
  'utf8',
)

test('single-slide explanations hide useless slide navigation', () => {
  assert.match(player, /lesson_segment_slides\.length > 1/)
  assert.match(player, /lesson-slide__toolbar--single/)
  assert.match(player, /Descargar diapositiva/)
})

test('keyboard arrows navigate explanations and fullscreen exits only with Escape', () => {
  assert.match(player, /event\.key === 'ArrowLeft'[\s\S]*selectSegment\(activeIndex - 1\)/)
  assert.match(player, /event\.key === 'ArrowRight'[\s\S]*selectSegment\(activeIndex \+ 1\)/)
  assert.match(player, /event\.key === 'Escape'/)
  assert.match(player, /Pulsa ESC para salir/)
  assert.doesNotMatch(player, /aria-label="Cerrar diapositiva"/)
})

test('slides show and download their course, regulation, and block numbering', () => {
  assert.match(player, /function SlideIdentity/)
  assert.match(player, /numbering=\{`\$\{blockPosition\}\.\$\{activeIndex \+ 1\}`\}/)
  assert.match(player, /canvas\.toBlob/)
  assert.match(lessonRoute, /ITC 02\.1\.02 · ET 2001-1-08/)
  assert.match(lessonRoute, /ITC 02\.1\.02 · ET 2000-1-08/)
  assert.match(lessonRoute, /ITC 02\.0\.02 · Orden TED\/723\/2021/)
})

test('audio transcript and unique specific information are separate sections', () => {
  assert.match(player, /Transcripción del audio/)
  assert.match(player, /Información específica de esta parte/)
  assert.match(migration, /Every playable segment must have an audio transcript/)
  assert.match(migration, /Every playable segment must have approved specific information/)
  assert.match(migration, /ITC 02\.0\.02 · Orden TED\/723\/2021 · Cursos Pedro/)
})

test('every playable block receives 15 questions and three cumulative perfect rounds', () => {
  assert.match(migration, /Expected 25 playable blocks/)
  assert.match(migration, /Every block bank must define exactly 15 questions/)
  assert.match(migration, /question_count = 15/)
  assert.match(migration, /required_perfect_streak = 3/)
  assert.match(migration, /completion_mode = 'cumulative_perfect'/)
  assert.match(migration, /current\.fact/)
})

test('platform creation credit appears publicly and inside the campus', () => {
  const credit = 'Plataforma creada por Pedro Mesas de la Fuente.'
  assert.ok(footer.includes(credit))
  assert.ok(shell.includes(credit))
})
