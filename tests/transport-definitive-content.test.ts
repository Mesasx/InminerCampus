import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/20260821160000_transport_courses_definitive_content.sql',
  import.meta.url,
)
const lessonRouteUrl = new URL(
  '../src/routes/campus.$enrollmentId.leccion.$lessonId.tsx',
  import.meta.url,
)
const courseRouteUrl = new URL('../src/routes/cursos.$courseSlug.tsx', import.meta.url)
const audioPlayerUrl = new URL('../src/components/AudioLessonPlayer.tsx', import.meta.url)
const stylesUrl = new URL('../src/styles/app.css', import.meta.url)

function sectionBetween(sql: string, start: string, end: string) {
  const startIndex = sql.indexOf(start)
  const endIndex = sql.indexOf(end, startIndex + start.length)
  assert.notEqual(startIndex, -1, `No se encontró ${start}`)
  assert.notEqual(endIndex, -1, `No se encontró ${end}`)
  return sql.slice(startIndex, endIndex)
}

function splitSqlRow(row: string) {
  const values: string[] = []
  let value = ''
  let quoted = false
  for (let index = 1; index < row.length - 1; index += 1) {
    const character = row[index]
    const next = row[index + 1]
    if (character === "'" && quoted && next === "'") {
      value += "''"
      index += 1
      continue
    }
    if (character === "'") {
      quoted = !quoted
      value += character
      continue
    }
    if (character === ',' && !quoted) {
      values.push(value.trim())
      value = ''
      continue
    }
    value += character
  }
  values.push(value.trim())
  return values
}

test('define las 50 partes independientes de cada versión', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const content = sectionBetween(
    sql,
    'insert into _transport_content values',
    'create temporary table _transport_question_source',
  )
  const rows = content.match(/^  \((?:5|20), [1-5], (?:[1-9]|10), '/gm) ?? []
  assert.equal(rows.length, 100)

  const labels = new Set(
    rows.map((row) => {
      const [duration, block, part] = row.slice(3).split(', ').map(Number)
      return `${duration}:${block}.${part}`
    }),
  )
  assert.equal(labels.size, 100)
  for (const duration of [5, 20]) {
    for (let block = 1; block <= 5; block += 1) {
      for (let part = 1; part <= 10; part += 1) {
        assert.ok(labels.has(`${duration}:${block}.${part}`))
      }
    }
  }
})

test('integra 75 preguntas por curso con cuatro opciones y una respuesta', async () => {
  const sql = await readFile(migrationUrl, 'utf8')
  const questions = sectionBetween(
    sql,
    'insert into _transport_question_source values',
    'do $$',
  )
  const rows = questions
    .split(/\r?\n/)
    .map((line) => line.trim().replace(/,$/, '').replace(/;$/, ''))
    .filter((line) => /^\((?:5|20), [1-5], (?:[1-9]|1[0-5]), '/.test(line))

  assert.equal(rows.length, 150)
  const labels = new Set<string>()
  for (const row of rows) {
    const values = splitSqlRow(row)
    assert.equal(values.length, 12)
    const [duration, block, position] = values.slice(0, 3).map(Number)
    assert.ok([5, 20].includes(duration))
    assert.ok(block >= 1 && block <= 5)
    assert.ok(position >= 1 && position <= 15)
    assert.ok(Number(values[8]) >= 1 && Number(values[8]) <= 4)
    assert.equal(Number(values[9]), block)
    labels.add(`${duration}:${block}:${position}`)
  }
  assert.equal(labels.size, 150)
})

test('preserva audios, progreso, precios, Stripe y autenticación', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /expected 100 stored audio objects/)
  assert.doesNotMatch(sql, /delete\s+from\s+public\.lesson_audio_segments/i)
  assert.doesNotMatch(sql, /audio_storage_path\s*=/i)
  assert.doesNotMatch(sql, /\b(?:enrollments|lesson_progress|lesson_audio_progress)\b\s+(?:set|where|values)/i)
  assert.doesNotMatch(sql, /\b(?:price_net|stripe_price_id|auth\.)\b/i)
  assert.match(sql, /renewal_interval_months = case when cv\.duration_hours=5 then 24/)
})

test('publica un único slide y ambos PDF completos por parte/bloque', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /transport-definitive-20260821/)
  assert.match(sql, /\('presentation', 'presentacion-completa', 1\)/)
  assert.match(sql, /transport-' \|\| t\.duration_hours \|\| 'h-' \|\| resource\.file_suffix \|\| '\.pdf'/)
  assert.match(sql, /'explicaciones-completas'/)
  assert.match(sql, /v_segments<>100 or v_slides<>100 or v_notes<>100/)
  assert.match(sql, /required_perfect_streak=3/)
})

test('la interfaz muestra diapositiva, audio y transcripción en ese orden', async () => {
  const [lessonRoute, courseRoute, audioPlayer, styles] = await Promise.all([
    readFile(lessonRouteUrl, 'utf8'),
    readFile(courseRouteUrl, 'utf8'),
    readFile(audioPlayerUrl, 'utf8'),
    readFile(stylesUrl, 'utf8'),
  ])

  const slideIndex = audioPlayer.indexOf('<section className="lesson-slides"')
  const audioIndex = audioPlayer.indexOf('<article className="panel audio-player"')
  const transcriptIndex = audioPlayer.indexOf('<div className="audio-player__script"')
  assert.ok(slideIndex >= 0 && slideIndex < audioIndex)
  assert.ok(audioIndex < transcriptIndex)
  assert.doesNotMatch(styles, /\.explanation-switcher\s*\{[^}]*\border\s*:/s)
  assert.doesNotMatch(styles, /\.audio-player\s*\{[^}]*\border\s*:/s)
  assert.match(
    lessonRoute,
    /find\(\(resource\) => resource\.kind === 'presentation'\)[\s\S]*resource\.kind === 'pdf'/,
  )
  assert.match(courseRoute, /Reciclaje periódico/)
  assert.match(courseRoute, /Renovación máxima cada/)
  assert.match(courseRoute, /accreditation_reference/)
})
