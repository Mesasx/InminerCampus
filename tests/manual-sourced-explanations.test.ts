import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

// Establecimientos de beneficio y perforadora reciben sus explicaciones del
// manual maestro de cada curso. Estas comprobaciones fijan lo que no puede
// romperse al regenerar las migraciones: el reparto por modalidad, el uso de
// encabezados que el reproductor sabe representar y la separación estricta
// entre explicación y transcripción.

const beneficioUrl = new URL(
  '../supabase/migrations/20260910120000_beneficio_explicaciones_del_manual.sql',
  import.meta.url,
)
const perforadoraUrl = new URL(
  '../supabase/migrations/20260910130000_perforadora_explicaciones_del_manual.sql',
  import.meta.url,
)
const audioScriptUrl = new URL(
  '../scripts/sync-beneficio-audio.mjs',
  import.meta.url,
)
const slidesScriptUrl = new URL(
  '../scripts/copy-beneficio-20h-slides.mjs',
  import.meta.url,
)
const deckSyncScriptUrl = new URL(
  '../scripts/sync-two-slide-course-decks.mjs',
  import.meta.url,
)
const beneficioImporterUrl = new URL(
  '../scripts/import-establecimientos-master-content.mjs',
  import.meta.url,
)
const playerUrl = new URL(
  '../src/components/AudioLessonPlayer.tsx',
  import.meta.url,
)

const V_BENEFICIO_5 = '4945d77b-d931-4054-a534-8a7466ce6a0b'
const V_BENEFICIO_20 = 'f5a7da9c-a3f2-4163-bb65-90395827f146'
const V_PERFORADORA_5 = '430e4109-6f25-4036-9deb-82674c9bec5e'
const V_PERFORADORA_20 = 'beb6890b-e1cc-4d3b-a709-da4771c90521'

test('beneficio escribe cien explicaciones por modalidad y no cruza carpetas', async () => {
  const sql = await readFile(beneficioUrl, 'utf8')

  // Cien cuerpos en 5 h; en 20 h se crean las diapositivas y se rellenan.
  assert.equal((sql.match(new RegExp(V_BENEFICIO_5, 'g')) ?? []).length, 101)
  assert.equal(
    (sql.match(/insert into public\.lesson_segment_slides/g) ?? []).length,
    100,
  )
  // La política del bucket exige que la primera carpeta sea la versión
  // matriculada, así que la modalidad de 20 h no puede reutilizar rutas de 5 h.
  assert.match(
    sql,
    new RegExp(`'${V_BENEFICIO_20}/slides/establecimientos-20h-2026/`),
  )
  assert.doesNotMatch(
    sql,
    new RegExp(`'${V_BENEFICIO_5}/slides/[^']*',[^;]*course_version_id = '${V_BENEFICIO_20}'`),
  )
  assert.match(sql, /Explicación detallada/)
  assert.match(sql, /Aplicación práctica/)
  assert.match(sql, /Idea clave/)
  assert.match(sql, /begin;/)
  assert.match(sql, /commit;/)
})

test('beneficio conserva una transcripción distinta en cada modalidad', async () => {
  const sql = await readFile(beneficioUrl, 'utf8')

  // El manual registra una locución de formación inicial y otra abreviada de
  // reciclaje: la migración no toca ninguna y comprueba que no coinciden.
  assert.doesNotMatch(sql, /update public\.lesson_audio_segments/)
  assert.match(sql, /comparten transcripción entre las dos modalidades/)
})

test('perforadora explica las dos modalidades y deja la locución pendiente', async () => {
  const [sql, importer] = await Promise.all([
    readFile(perforadoraUrl, 'utf8'),
    readFile(
      new URL('../scripts/import-perforadora-master-content.mjs', import.meta.url),
      'utf8',
    ),
  ])

  assert.equal((sql.match(new RegExp(V_PERFORADORA_5, 'g')) ?? []).length, 51)
  assert.equal((sql.match(new RegExp(V_PERFORADORA_20, 'g')) ?? []).length, 51)
  for (const heading of [
    'Idea central',
    'Definición y alcance',
    'Fundamento técnico ampliado',
    'Riesgo que debe comprenderse',
    'Criterio de actuación',
    'Caso razonado',
  ]) {
    assert.ok(sql.includes(heading), `falta el encabezado ${heading}`)
  }
  // La transcripción no se inventa: el guion de producción no está aportado.
  assert.doesNotMatch(sql, /narration_text = /)
  assert.match(sql, /Perforadora_Guiones_Locucion_15s_55s_y_Gamma/)
  assert.match(sql, /tienen transcripción sin que se haya aportado el guion/)
  assert.match(importer, /manual_chapter: `Capítulo \$\{note\.code\}`/)
  assert.match(importer, /title: note\.title/)
})

test('los scripts de beneficio separan las dos modalidades y sus carpetas', async () => {
  const [audio, slides, deckSync, importer] = await Promise.all([
    readFile(audioScriptUrl, 'utf8'),
    readFile(slidesScriptUrl, 'utf8'),
    readFile(deckSyncScriptUrl, 'utf8'),
    readFile(beneficioImporterUrl, 'utf8'),
  ])

  assert.match(audio, /folder: '5 horas', durationHours: 5/)
  assert.match(audio, /folder: '20 horas', durationHours: 20/)
  // Si una unidad fuese el mismo fichero en las dos carpetas sería una copia
  // pegada por error, no la locución propia de esa modalidad.
  assert.match(audio, /es el mismo audio en/)
  assert.match(audio, /--dry-run/)
  assert.match(slides, new RegExp(V_BENEFICIO_20))
  assert.match(slides, /copied !== 50/)
  assert.match(deckSync, /Que-es-un-Establecimiento-de-Beneficio\.pdf/)
  assert.match(deckSync, /durationHours: 5/)
  assert.match(deckSync, /durationHours: 20/)
  assert.match(deckSync, /pages !== 50/)
  assert.match(importer, /baseExplanation: `Explicación detallada/)
  assert.match(importer, /appliedExplanation/)
  assert.match(importer, /\.gt\('position', 1\)/)
  assert.match(importer, /onConflict: 'segment_id,position'/)
  assert.match(
    importer,
    /published: Boolean\(unit\.audio_storage_path \|\| unit\.audio_external_url\)/,
  )
})

test('el intérprete conserva los rótulos propios del manual', async () => {
  const [explanation, component] = await Promise.all([
    readFile(
      new URL('../src/lib/lesson-explanation.ts', import.meta.url),
      'utf8',
    ),
    readFile(
      new URL('../src/components/DetailedExplanation.tsx', import.meta.url),
      'utf8',
    ),
  ])

  // Los manuales titulan apartados dentro de cada sección con rótulos distintos
  // en cada unidad, así que se reconocen por forma y no por lista cerrada.
  assert.match(explanation, /function looksLikeSubheading/)
  // Las viñetas y las líneas numeradas abren bloque pero son contenido: nunca
  // deben ascender a título.
  assert.match(explanation, /if \(BULLET\.test\(line\) \|\| NUMBERED\.test\(line\)\) return false/)
  assert.match(component, /block\.type === 'subheading'/)
  assert.match(component, /<h4 key=\{`sub-\$\{index\}-\$\{block\.text\}`\}/)
})

const arranque20Url = new URL(
  '../supabase/migrations/20260910140000_arranque_20h_explicaciones_bloques_2_a_5.sql',
  import.meta.url,
)
const siliceUrl = new URL(
  '../supabase/migrations/20260910150000_silice_explicaciones_y_titulos.sql',
  import.meta.url,
)

test('arranque 20 h completa los bloques 2 a 5 sin tocar el 1 ni el reciclaje', async () => {
  const sql = await readFile(arranque20Url, 'utf8')

  assert.equal(
    (sql.match(/^update public\.lesson_segment_slides/gm) ?? []).length,
    40,
  )
  assert.doesNotMatch(sql, /m\.position = 1 and seg\.position/)
  assert.doesNotMatch(sql, /m\.position = 6 and seg\.position/)
  for (const heading of [
    'Objetivo',
    'Explicación de base',
    'Profundización técnica y criterio preventivo',
    'Secuencia operativa recomendada',
    'Caso práctico razonado',
    'Errores críticos que deben evitarse',
    'Comprobación antes de continuar',
    'Idea clave',
  ]) {
    assert.ok(sql.includes(heading), `falta el encabezado ${heading}`)
  }
  // El bloque 1 ya tenía su propia redacción y no puede perderla.
  assert.match(sql, /partes del bloque 1 han perdido su explicación/)
  // Las dos modalidades de arranque conservan redacciones distintas.
  assert.match(sql, /idénticas en las dos modalidades/)
})

test('polvo y sílice recupera explicaciones y acentos sin tocar el bloque 6', async () => {
  const sql = await readFile(siliceUrl, 'utf8')

  assert.equal(
    (sql.match(/^update public\.lesson_segment_slides/gm) ?? []).length,
    50,
  )
  assert.equal(
    (sql.match(/^update public\.lesson_audio_segments/gm) ?? []).length,
    50,
  )
  assert.match(sql, /Qué es el polvo/)
  assert.match(sql, /Cuándo existe riesgo de exposición/)
  assert.match(sql, /siguen sin acentuar/)
  assert.match(sql, /diapositivas del bloque 6 han sido sobrescritas/)
  // La lista de verificación repetía la secuencia: se conserva una sola vez.
  assert.match(sql, /Secuencia de aplicación/)
  assert.doesNotMatch(sql, /Comprobación antes de continuar\$b\$/)
})

test('el intérprete conoce el vocabulario de encabezados de todos los manuales', async () => {
  const explanation = await readFile(
    new URL('../src/lib/lesson-explanation.ts', import.meta.url),
    'utf8',
  )

  for (const heading of [
    'Explicación vinculada al audio',
    'Profundización técnica',
    'Secuencia de aplicación',
    'Errores críticos',
  ]) {
    assert.ok(
      explanation.includes(`'${heading}'`),
      `el intérprete no reconoce ${heading}`,
    )
  }
  // Las secuencias se pintan como procedimiento y los errores como aviso.
  assert.match(explanation, /\['Secuencia de aplicación', 'procedure'\]/)
  assert.match(explanation, /\['Errores críticos', 'warning'\]/)
})
