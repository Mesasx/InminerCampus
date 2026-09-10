import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

// La pantalla de lección se reordenó para que diapositiva y locución formen una
// sola superficie de aprendizaje, en vez de tres tarjetas independientes
// (audio, diapositiva y explicación) separadas por huecos grandes.

const playerUrl = new URL(
  '../src/components/AudioLessonPlayer.tsx',
  import.meta.url,
)
const routeUrl = new URL(
  '../src/routes/campus.$enrollmentId.leccion.$lessonId.tsx',
  import.meta.url,
)
const stylesUrl = new URL('../src/styles/app.css', import.meta.url)

test('la diapositiva abre la pantalla y el reproductor cuelga de ella', async () => {
  const player = await readFile(playerUrl, 'utf8')

  const stage = player.indexOf('lesson-slide--stage')
  const canvas = player.indexOf('lesson-slide__canvas')
  const bar = player.indexOf('lesson-slide__bar')
  const reading = player.indexOf('lesson-reading')

  assert.ok(stage > 0 && stage < canvas)
  assert.ok(canvas < bar)
  assert.ok(bar < reading)
  // La barra vive dentro del mismo <article> que el visor: si volviera a ser
  // una tarjeta suelta, reaparecería el efecto de bloques desconectados.
  assert.doesNotMatch(player, /className="panel audio-player"/)
  assert.doesNotMatch(player, /className="panel explanation-switcher"/)
})

test('el reproductor conserva sus controles mínimos y el volumen', async () => {
  const player = await readFile(playerUrl, 'utf8')

  assert.match(player, /aria-label=\{\s*playing \? 'Pausar la locución'/)
  assert.match(player, /aria-label="Retroceder diez segundos"/)
  assert.match(player, /aria-label="Posición del audio"/)
  assert.match(player, /aria-label="Volumen"/)
  assert.match(player, /aria-label=\{muted \? 'Activar el sonido' : 'Silenciar'\}/)
  // La velocidad sigue bloqueada a 1×: el tiempo de formación es normativo.
  assert.match(player, /playbackRate = 1/)
})

test('la explicación se lee sin desplegar y la transcripción va plegada', async () => {
  const player = await readFile(playerUrl, 'utf8')

  assert.match(player, /aria-label="Explicación detallada"/)
  assert.doesNotMatch(player, /Leer explicación completa/)
  assert.match(player, /className="lesson-disclosure__toggle"/)
  assert.match(player, /aria-expanded=\{transcriptOpen\}/)
})

test('el alto del visor se limita para que quepa con su barra en pantalla', async () => {
  const styles = await readFile(stylesUrl, 'utf8')

  // El ancho del visor se deriva de la altura libre, de modo que diapositiva y
  // barra entren sin desplazamiento en un portátil normal.
  assert.match(styles, /\.lesson-slides \{[^}]*100dvh/s)
  assert.match(styles, /\.lesson-slide__canvas \{[^}]*aspect-ratio: 16 \/ 9/s)
  // Una columna acotada impide que un texto sin cortes desborde en móvil.
  assert.match(styles, /\.audio-lesson \{[^}]*grid-template-columns: minmax\(0, 1fr\)/s)
})

test('la cabecera de la lección no compite con la diapositiva', async () => {
  const [route, styles] = await Promise.all([
    readFile(routeUrl, 'utf8'),
    readFile(stylesUrl, 'utf8'),
  ])

  assert.match(route, /dashboard-heading dashboard-heading--lesson/)
  assert.match(
    styles,
    /\.dashboard-heading--lesson h1 \{[^}]*font-size: clamp\(1\.15rem/s,
  )
})
