import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'
import { selectCourseDownloads } from '../src/lib/course-downloads.ts'
import { quizIntroCopy, quizRoundsLabel } from '../src/lib/quiz-copy.ts'

const playerUrl = new URL(
  '../src/components/AudioLessonPlayer.tsx',
  import.meta.url,
)
const hookUrl = new URL('../src/lib/use-reading-progress.ts', import.meta.url)
const indicatorUrl = new URL(
  '../src/components/ReadingProgressIndicator.tsx',
  import.meta.url,
)
const migrationUrl = new URL(
  '../supabase/migrations/20260911090000_lectura_de_explicacion_detallada.sql',
  import.meta.url,
)
const lessonRouteUrl = new URL(
  '../src/routes/campus.$enrollmentId.leccion.$lessonId.tsx',
  import.meta.url,
)

test('«Siguiente» exige audio y lectura, y dice cuál de los dos falta', async () => {
  const player = await readFile(playerUrl, 'utf8')

  // Las dos condiciones, no sólo el audio.
  assert.match(player, /const nextBlocked = !isLastSegment && !\(audioDone && readingDone\)/)
  // Y un motivo distinto para cada combinación: nunca un botón gris sin más.
  assert.match(player, /'Completa el audio y la explicación'/)
  assert.match(player, /'Continúa leyendo la explicación'/)
  assert.match(player, /'Escucha el audio para continuar'/)
  assert.match(player, /aria-describedby=\{nextBlocked \? 'lesson-next-reason' : undefined\}/)
})

test('una unidad sin explicación no bloquea al alumno', async () => {
  const player = await readFile(playerUrl, 'utf8')

  // Si no hay nada que recorrer, el requisito de lectura se da por cumplido.
  assert.match(
    player,
    /const readingAlreadyDone = activeState\.read \|\| !hasExplanation \|\| previewMode/,
  )
})

test('la lectura se mide con observadores y sin listeners permanentes', async () => {
  const hook = await readFile(hookUrl, 'utf8')

  assert.match(hook, /new IntersectionObserver/)
  // El listener de scroll sólo se suscribe mientras la explicación está a la
  // vista, es pasivo y se agrupa por fotograma.
  assert.match(hook, /addEventListener\('scroll', schedule, \{ passive: true \}\)/)
  assert.match(hook, /removeEventListener\('scroll', schedule\)/)
  assert.match(hook, /requestAnimationFrame\(measure\)/)
  assert.match(hook, /cancelAnimationFrame\(frame\)/)
  assert.match(hook, /observer\.disconnect\(\)/)
  assert.match(hook, /visibility\.disconnect\(\)/)
  // Explicación que cabe entera en pantalla: requisito cumplido sin scroll.
  assert.match(
    hook,
    /if \(rect\.top >= 0 && rect\.bottom <= viewport\) markCompleted\(\)/,
  )
})

test('el indicador de lectura es comprensible sin depender del color', async () => {
  const indicator = await readFile(indicatorUrl, 'utf8')

  assert.match(indicator, /role="progressbar"/)
  assert.match(indicator, /aria-valuenow=\{percent\}/)
  assert.match(indicator, /aria-label=\{`Lectura de la explicación: \$\{percent\} % recorrido`\}/)
  assert.match(indicator, /role="status"/)
  assert.match(indicator, /Continúa leyendo para desbloquear la siguiente diapositiva/)
  assert.match(indicator, /Te queda aproximadamente un \$\{remaining\} %/)
  assert.match(indicator, /Explicación completada/)
  // Al terminar desaparece, de modo que nunca tapa la navegación.
  assert.match(indicator, /if \(completed \|\| !visible\) return null/)
})

test('la lectura se guarda en el progreso existente y no rompe a quien ya avanzó', async () => {
  const [sql, route, player] = await Promise.all([
    readFile(migrationUrl, 'utf8'),
    readFile(lessonRouteUrl, 'utf8'),
    readFile(playerUrl, 'utf8'),
  ])

  // Columna añadida a la tabla de progreso que ya existía: ni tabla paralela
  // ni migración destructiva.
  assert.match(sql, /add column if not exists explanation_read_at timestamptz/)
  assert.doesNotMatch(sql, /drop (table|column)/i)
  assert.doesNotMatch(sql, /delete from/i)
  // Lo ya escuchado cuenta como leído: nadie retrocede.
  assert.match(
    sql,
    /set explanation_read_at = completed_at\s+where completed_at is not null/,
  )
  // La finalización de lección y el desbloqueo siguen donde estaban.
  assert.doesNotMatch(sql, /create or replace function public\.record_audio_segment_progress/)
  assert.match(sql, /create or replace function public\.record_explanation_read/)
  // El disparador deja intacto `updated_at` cuando sólo cambia la lectura,
  // porque esa marca es la que sostiene la comprobación de adelantos del audio.
  assert.match(
    sql,
    /old\.explanation_read_at is not distinct from new\.explanation_read_at/,
  )

  assert.match(route, /explanation_read_at/)
  assert.match(
    route,
    /explanationRead: Boolean\(\s*segmentProgress\?\.explanation_read_at \?\? segmentProgress\?\.completed_at,\s*\)/,
  )
  assert.match(player, /supabase\.rpc\('record_explanation_read'/)
  assert.match(
    player,
    /read: Boolean\(row\?\.explanation_read_at \|\| row\?\.completed_at\)/,
  )
})

test('el material del alumno se reduce a libro de texto y presentación', () => {
  const version = [
    { id: 'm', kind: 'manual', title: 'Libro de texto del curso', resolvedUrl: 'https://x/m.pdf' },
    { id: 'p', kind: 'presentation', title: 'Presentación del curso', resolvedUrl: 'https://x/p.pdf' },
  ]
  const lesson = [
    { id: 't', kind: 'pdf', title: 'Ver explicaciones completas · Reciclaje 5 h', resolvedUrl: 'https://x/t.pdf' },
    { id: 'd', kind: 'presentation', title: 'Diapositivas actuales del curso · 50 páginas', resolvedUrl: 'https://x/d.pdf' },
  ]

  const downloads = selectCourseDownloads(version, lesson)

  assert.deepEqual(
    downloads.map((item) => item.slot),
    ['manual', 'presentation'],
  )
  assert.deepEqual(
    downloads.map((item) => item.label),
    ['Libro de texto / Manual', 'Presentación del curso'],
  )
  // El recurso oficial de la versión manda sobre la copia de la lección, y el
  // PDF suelto no aparece.
  assert.equal(downloads[1].id, 'p')
})

test('un curso sin presentación no ofrece un enlace roto', () => {
  const downloads = selectCourseDownloads([
    { id: 'm', kind: 'manual', title: 'Libro de texto del curso', resolvedUrl: 'https://x/m.pdf' },
    { id: 'p', kind: 'presentation', title: 'Presentación', resolvedUrl: '' },
  ])

  assert.equal(downloads.length, 1)
  assert.equal(downloads[0].slot, 'manual')
})

test('el título del recurso lo pone cada curso, no el código', () => {
  const downloads = selectCourseDownloads([
    { id: 'm', kind: 'manual', title: 'Manual formativo de perforación', resolvedUrl: 'https://x/a.pdf' },
  ])

  assert.equal(downloads[0].title, 'Manual formativo de perforación')
  assert.equal(downloads[0].label, 'Libro de texto / Manual')
})

test('el texto de los tests es común y sus cifras salen del propio test', () => {
  const diez = quizIntroCopy({
    questionCount: 10,
    requiredPerfectRounds: 3,
    completionMode: 'cumulative_perfect',
  })
  const veintiseis = quizIntroCopy({
    questionCount: 26,
    requiredPerfectRounds: 3,
    completionMode: 'cumulative_perfect',
  })

  assert.match(diez, /contiene 10 preguntas/)
  assert.match(veintiseis, /contiene 26 preguntas/)
  // La explicación de la mecánica es idéntica en los dos.
  const mecanica = (texto: string) => texto.split('. ').slice(1).join('. ')
  assert.equal(mecanica(diez), mecanica(veintiseis))
  assert.match(diez, /3 rondas perfectas/)
  assert.match(diez, /no es necesario que sean consecutivas/)

  const consecutivo = quizIntroCopy({
    questionCount: 15,
    requiredPerfectRounds: 3,
    completionMode: 'consecutive_perfect',
  })
  assert.match(consecutivo, /de forma consecutiva/)
  assert.equal(quizRoundsLabel('consecutive_perfect'), 'Rondas perfectas consecutivas')
  assert.equal(quizRoundsLabel('cumulative_perfect'), 'Rondas perfectas')

  // Una sola ronda o una sola pregunta tampoco quedan mal redactadas.
  const singular = quizIntroCopy({
    questionCount: 1,
    requiredPerfectRounds: 1,
    completionMode: 'cumulative_perfect',
  })
  assert.match(singular, /contiene una pregunta/)
  assert.match(singular, /una ronda perfecta/)
})
