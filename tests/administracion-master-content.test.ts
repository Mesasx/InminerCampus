import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const unitsPath = new URL('../content/administracion-units.json', import.meta.url)
const transcriptsPath = new URL(
  '../content/administracion-transcripts.json',
  import.meta.url,
)
const courseMigrationPath = new URL(
  '../supabase/migrations/20260910160000_administracion_personal_servicios_course.sql',
  import.meta.url,
)
const importerPath = new URL(
  '../scripts/import-administracion-master-content.mjs',
  import.meta.url,
)
const courseImagePath = new URL('../src/lib/course-image.ts', import.meta.url)

type Unit = {
  ordinal: number
  code: string
  block: number
  position: number
  title: string
  slidePage: number
  manualPage: number
  explanation: string
  audio: Record<string, string>
}

const units: Array<Unit> = JSON.parse(await readFile(unitsPath, 'utf8')).units
const transcripts: Record<string, { text: string; duration: number }> =
  JSON.parse(await readFile(transcriptsPath, 'utf8'))

// Reparto de unidades por bloque de la ET 2004-1-10.
const unitsPerBlock = [9, 10, 9, 6, 9, 7]

test('el curso tiene las cincuenta unidades repartidas en los seis bloques', () => {
  assert.equal(units.length, 50)
  for (const [index, expected] of unitsPerBlock.entries()) {
    const block = index + 1
    const inBlock = units.filter((unit) => unit.block === block)
    assert.equal(inBlock.length, expected, `bloque ${block}`)
    assert.deepEqual(
      inBlock.map((unit) => unit.position),
      Array.from({ length: expected }, (_, position) => position + 1),
    )
  }
  assert.equal(new Set(units.map((unit) => unit.code)).size, 50)
})

test('cada unidad apunta a su diapositiva y a su apartado del manual', () => {
  assert.deepEqual(
    units.map((unit) => unit.slidePage),
    Array.from({ length: 50 }, (_, index) => index + 1),
  )
  // Los apartados del manual avanzan sin saltarse ninguna unidad y siempre por
  // detrás de la diapositiva, porque el manual abre con portada, índice y las
  // divisorias de cada bloque.
  for (const [index, unit] of units.entries()) {
    assert.equal(unit.ordinal, index + 1)
    assert.ok(unit.manualPage > unit.slidePage, `unidad ${unit.code}`)
    if (index > 0) {
      assert.ok(unit.manualPage > units[index - 1].manualPage, `unidad ${unit.code}`)
    }
  }
})

test('las locuciones de cada modalidad corresponden a su propia unidad', () => {
  for (const unit of units) {
    for (const hours of ['5', '20']) {
      const track = unit.audio[hours]
      assert.ok(track, `unidad ${unit.code}, ${hours} h`)
      assert.match(track, new RegExp(`Curso de ${hours} horas`))
      assert.match(track, new RegExp(`bloque-${unit.block}`))
      assert.match(
        track,
        new RegExp(`parte-${unit.block}\\.${unit.position}-`),
      )
    }
    // Nunca se cruzan: la pista de 5 h y la de 20 h son ficheros distintos.
    assert.notEqual(unit.audio['5'], unit.audio['20'])
  }
})

test('cada unidad tiene transcripción propia en las dos modalidades', () => {
  assert.equal(Object.keys(transcripts).length, 100)
  for (const unit of units) {
    const short = transcripts[`5h/${unit.code}`]
    const long = transcripts[`20h/${unit.code}`]
    assert.ok(short?.text.length > 80, `transcripción 5 h de ${unit.code}`)
    assert.ok(long?.text.length > 80, `transcripción 20 h de ${unit.code}`)
    // La locución de la formación inicial desarrolla más que la de reciclaje.
    assert.notEqual(short.text, long.text)
    assert.ok(long.duration > short.duration, `duración de ${unit.code}`)
  }
})

test('la explicación detallada sale del manual y no repite la transcripción', () => {
  for (const unit of units) {
    const explanation = unit.explanation
    assert.ok(explanation.includes('\nObjetivo\n'), `unidad ${unit.code}`)
    assert.ok(
      explanation.includes('\nExplicación detallada\n'),
      `unidad ${unit.code}`,
    )
    assert.ok(
      explanation.includes('\nProfundización técnica y criterio preventivo\n'),
      `unidad ${unit.code}`,
    )
    assert.ok(explanation.length > 900, `unidad ${unit.code}`)
    // No arrastra cabeceras, pies ni rótulos internos del PDF del manual.
    for (const noise of [
      'INMÍNER CAMPUS',
      'Manual formativo',
      'Objetivo formativo',
      'Desarrollo detallado',
      'Mensaje clave',
      'BLOQUE',
    ]) {
      assert.ok(!explanation.includes(noise), `${unit.code}: arrastra «${noise}»`)
    }
    assert.notEqual(explanation.trim(), transcripts[`5h/${unit.code}`].text)
    assert.notEqual(explanation.trim(), transcripts[`20h/${unit.code}`].text)
  }
})

test('el curso se da de alta publicado y con el precio de cada duración', async () => {
  const sql = await readFile(courseMigrationPath, 'utf8')

  assert.match(sql, /'administracion-personal-servicios-no-mantenimiento'/)
  assert.match(sql, /'ITC 02\.1\.02 · ET 2004-1-10'/)
  // Mismo importe que el resto del catálogo para cada duración.
  assert.match(
    sql,
    /case when v_duration = 20 then 259\.00 else 149\.00 end/,
  )
  assert.match(sql, /foreach v_duration in array array\[5, 20\]/)
  assert.match(sql, /for v_block in 1\.\.6/)
  // Los títulos de las cincuenta unidades se siembran tal cual salen del PDF.
  for (const unit of units) {
    assert.ok(
      sql.includes(`(${unit.block},${unit.position},'${unit.title.replace(/'/g, "''")}')`),
      `falta la unidad ${unit.code} en la migración`,
    )
  }
})

test('el importador separa las dos modalidades y publica cada unidad', async () => {
  const source = await readFile(importerPath, 'utf8')

  // La locución se elige por la duración de la versión que se está cargando.
  assert.match(source, /unit\.audio\[String\(hours\)\]/)
  assert.match(source, /transcripts\[`\$\{hours\}h\/\$\{unit\.code\}`\]\.text/)
  // Diapositiva, audio, transcripción y explicación son cuatro piezas
  // distintas: la nota del manual nunca se escribe como transcripción.
  assert.match(source, /summary: unit\.explanation/)
  assert.match(source, /published: true/)
  assert.match(source, /lesson_segment_notes/)
  assert.match(source, /lesson_segment_slides/)
})

test('los tres cursos con portada nueva apuntan a su imagen oficial', async () => {
  const source = await readFile(courseImagePath, 'utf8')

  for (const [slug, image] of [
    [
      'operador-maquinaria-arranque-carga-viales',
      '/images/curso-maquinaria-arranque-portada.png',
    ],
    [
      'operador-maquinaria-transporte-camion-volquete',
      '/images/curso-maquinaria-transporte-portada.png',
    ],
    [
      'administracion-personal-servicios-no-mantenimiento',
      '/images/curso-administracion-portada.png',
    ],
  ]) {
    assert.ok(source.includes(`'${slug}':`), `falta el slug ${slug}`)
    assert.ok(source.includes(`'${image}'`), `falta la portada ${image}`)
  }
})
