import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const manifestUrl = new URL('../content/course-1-complete.manifest.json', import.meta.url)
const audioInventoryUrl = new URL(
  '../content/course-1-audio-inventory.json',
  import.meta.url,
)
const migrationUrl = new URL(
  '../supabase/migrations/202608100002_finalize_course_one_five_hours.sql',
  import.meta.url,
)
const slideDeckMigrationUrl = new URL(
  '../supabase/migrations/20260810121209_update_course_one_slide_deck_v2.sql',
  import.meta.url,
)
const slideAccessMigrationUrl = new URL(
  '../supabase/migrations/20260810123511_allow_course_one_v2_slide_reads.sql',
  import.meta.url,
)
const playerUrl = new URL('../src/components/AudioLessonPlayer.tsx', import.meta.url)

type Manifest = {
  courseSlug: string
  durationHours: number
  slideDeck: string
  totalAudios: number
  totalSlides: number
  audios: Array<{
    part: string
    block: number
    position: number
    explanation: string
    keyPoints: string[]
    stopCriterion: string
    source: string
    slides: Array<{ position: number; storagePath: string }>
  }>
}

type AudioInventory = {
  totalAudios: number
  audios: Array<{
    part: string
    block: number
    position: number
    durationSeconds: number
    sizeBytes: number
    decodeOk: boolean
    duplicateHash: boolean
    contentStatus: string
  }>
}

test('el manifiesto definitivo contiene cinco bloques, cincuenta audios y cien PNG privados', async () => {
  const manifest = JSON.parse(await readFile(manifestUrl, 'utf8')) as Manifest

  assert.equal(manifest.courseSlug, 'operador-maquinaria-arranque-carga-viales')
  assert.equal(manifest.durationHours, 5)
  assert.equal(manifest.slideDeck, 'Curso-1-V2-IMAGENES-Y-LOGO-CORREGIDO.pptx')
  assert.equal(manifest.totalAudios, 50)
  assert.equal(manifest.totalSlides, 100)
  assert.equal(manifest.audios.length, 50)

  const parts = new Set<string>()
  const paths = new Set<string>()
  for (const audio of manifest.audios) {
    assert.equal(audio.part, `${audio.block}.${audio.position}`)
    assert.ok(audio.block >= 1 && audio.block <= 5)
    assert.ok(audio.position >= 1 && audio.position <= 10)
    assert.ok(!parts.has(audio.part), `Parte duplicada: ${audio.part}`)
    parts.add(audio.part)
    assert.ok(audio.explanation.length >= 80)
    assert.equal(audio.keyPoints.length, 3)
    assert.ok(audio.stopCriterion.length >= 10)
    assert.ok(audio.source.length >= 10)
    assert.equal(audio.slides.length, 2)
    assert.deepEqual(
      audio.slides.map((slide) => slide.position),
      [1, 2],
    )
    for (const slide of audio.slides) {
      assert.match(
        slide.storagePath,
        new RegExp(
          `^course-1/5h-v2/block-${audio.block}/slides/audio-${audio.block}-${String(audio.position).padStart(2, '0')}-slide-0[12]\\.png$`,
        ),
      )
      assert.ok(!paths.has(slide.storagePath), `Ruta duplicada: ${slide.storagePath}`)
      paths.add(slide.storagePath)
    }
  }

  assert.equal(parts.size, 50)
  assert.equal(paths.size, 100)
  assert.match(JSON.stringify(manifest), /frecuencia máxima obligatoria de dos años/i)
  assert.doesNotMatch(JSON.stringify(manifest), /frecuencia máxima obligatoria de cuatro años/i)
})

test('los cincuenta audios están validados, son únicos y tienen contenido aprobado', async () => {
  const inventory = JSON.parse(
    (await readFile(audioInventoryUrl, 'utf8')).replace(/^\uFEFF/, ''),
  ) as AudioInventory

  assert.equal(inventory.totalAudios, 50)
  assert.equal(inventory.audios.length, 50)
  assert.equal(new Set(inventory.audios.map((audio) => audio.part)).size, 50)
  for (const audio of inventory.audios) {
    assert.equal(audio.part, `${audio.block}.${audio.position}`)
    assert.equal(audio.decodeOk, true)
    assert.equal(audio.duplicateHash, false)
    assert.ok(audio.sizeBytes > 1000)
    assert.ok(audio.durationSeconds >= 10)
    assert.equal(audio.contentStatus, 'approved')
  }
})

test('la migración está limitada al Curso 1 de cinco horas y valida todos los activos', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /c\.slug = 'operador-maquinaria-arranque-carga-viales'/)
  assert.match(sql, /cv\.duration_hours = 5/)
  assert.match(sql, /module\.position between 1 and 5/)
  assert.match(sql, /count\(\*\) from course_one_parts\) <> 50/)
  assert.match(sql, /count\(\*\) from course_one_slides\) <> 100/)
  assert.match(sql, /having count\(slide\.id\) <> 2/)
  assert.match(sql, /Los 100 PNG privados no están disponibles/)
  assert.match(sql, /Los 50 audios privados no están disponibles/)
  assert.match(sql, /El manual PDF privado no está disponible/)
  assert.match(sql, /No se elimina el sexto módulo porque contiene progreso/)
  assert.match(sql, /name like 'course-1\/5h\/%'/)
  assert.doesNotMatch(sql, /duration_hours\s*=\s*20/)
  assert.doesNotMatch(sql, /[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/i)
  assert.doesNotMatch(sql, /@[a-z0-9.-]+\.[a-z]{2,}/i)
})

test('el reproductor prioriza una diapositiva, la numeración real y el PDF protegido', async () => {
  const player = await readFile(playerUrl, 'utf8')

  assert.match(player, /Parte \{blockPosition\}\.\{activeIndex \+ 1\}/)
  assert.match(player, /activeSegment\.lesson_segment_slides\[activeSlideIndex\]/)
  assert.match(player, /handleSlideTouchEnd/)
  assert.match(player, /event\.key === 'ArrowLeft'/)
  assert.match(player, /event\.key === 'Escape'/)
  assert.match(player, /createSignedUrl\(pdfResource\.storagePath, 3600\)/)
  assert.match(player, /45 \* 60 \* 1000/)
  assert.match(player, /Ver PDF · página/)
  assert.match(player, /rel="noopener noreferrer"/)
  assert.match(player, /aria-label="Cambiar explicación"/)
  assert.ok(player.indexOf('explanation-switcher') < player.indexOf('lesson-slides'))
  assert.ok(player.indexOf('lesson-slides') < player.indexOf('panel audio-player'))
})

test('la V2 usa rutas nuevas y solo sustituye las cien diapositivas del Curso 1', async () => {
  const sql = await readFile(slideDeckMigrationUrl, 'utf8')

  assert.match(sql, /course-1\/5h-v2\/%/)
  assert.match(sql, /uploaded_slide_count <> 100/)
  assert.match(sql, /updated_slide_count not in \(0, 100\)/)
  assert.match(sql, /current_slide_count <> 100/)
  assert.match(sql, /c(?:ourse)?\.slug = 'operador-maquinaria-arranque-carga-viales'/)
  assert.match(sql, /course_version\.duration_hours = 5/)
  assert.match(sql, /module\.position between 1 and 5/)
  assert.doesNotMatch(sql, /lesson_audio_progress|enrollments|audio_storage_path/)
})

test('la política privada permite firmar las diapositivas V2 solo a usuarios autorizados', async () => {
  const sql = await readFile(slideAccessMigrationUrl, 'utf8')

  assert.match(sql, /bucket_id = 'course-materials'/)
  assert.match(sql, /name like 'course-1\/5h-v2\/%'/)
  assert.match(sql, /current_user_is_enrolled\(cv\.id\)/)
  assert.match(sql, /cv\.status = 'published'/)
  assert.match(sql, /'tutor'::public\.app_role/)
  assert.match(sql, /'administrador'::public\.app_role/)
  assert.match(sql, /'superadministrador'::public\.app_role/)
  assert.doesNotMatch(sql, /to anon|using \(true\)/i)
})
