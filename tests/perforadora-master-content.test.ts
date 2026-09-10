import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import test from 'node:test'

const schemaMigration = new URL(
  '../supabase/migrations/20260907120000_course_unit_metadata_and_materials.sql',
  import.meta.url,
)
const contentMigration = new URL(
  '../supabase/migrations/20260907121000_perforadora_master_map.sql',
  import.meta.url,
)
const materialEditorMigration = new URL(
  '../supabase/migrations/20260907123000_course_materials_editor_and_publishing.sql',
  import.meta.url,
)
const playerPath = new URL(
  '../src/components/AudioLessonPlayer.tsx',
  import.meta.url,
)
const materialsPath = new URL(
  '../src/components/CourseMaterialsPanel.tsx',
  import.meta.url,
)
const importerPath = new URL(
  '../scripts/import-perforadora-master-content.mjs',
  import.meta.url,
)
const auditPath = new URL(
  '../src/components/CourseContentValidationReport.tsx',
  import.meta.url,
)
const perforadoraUtf8Migration = new URL(
  '../supabase/migrations/20260908140000_perforadora_utf8_repair.sql',
  import.meta.url,
)
const unitDeckImporterPath = new URL(
  '../scripts/upload-course-unit-decks.mjs',
  import.meta.url,
)
const sharedMaterialsImporterPath = new URL(
  '../scripts/upload-course-master-materials.mjs',
  import.meta.url,
)
const remainingCodesMigration = new URL(
  '../supabase/migrations/20260907125000_transport_and_silica_stable_unit_codes.sql',
  import.meta.url,
)
const establecimientosMigration = new URL(
  '../supabase/migrations/20260907130000_establecimientos_beneficio_draft_course.sql',
  import.meta.url,
)
const transportTestImporterPath = new URL(
  '../scripts/import-transport-test.mjs',
  import.meta.url,
)
const establecimientosImporterPath = new URL(
  '../scripts/import-establecimientos-master-content.mjs',
  import.meta.url,
)
const audioImporterPath = new URL(
  '../scripts/import-course-audio.mjs',
  import.meta.url,
)
const establecimientosAdminAccessMigration = new URL(
  '../supabase/migrations/20260908084326_grant_establecimientos_admin_preview_access.sql',
  import.meta.url,
)

test('el modelo conserva cinco bloques y añade identidad estable y materiales por versión', async () => {
  const sql = await readFile(schemaMigration, 'utf8')

  assert.match(sql, /add column if not exists lesson_code text/)
  assert.match(sql, /add column if not exists manual_chapter text/)
  assert.match(
    sql,
    /unique index if not exists lesson_audio_segments_lesson_code_idx/,
  )
  assert.match(sql, /create table if not exists public\.course_materials/)
  assert.match(sql, /current_user_is_enrolled\(course_version_id\)/)
  assert.match(sql, /course_materials_admin_manage/)
  assert.doesNotMatch(sql, /create table[^;]*course_units/i)
})

test('el mapa maestro contiene las 50 unidades de perforadora sin crear otro curso', async () => {
  const sql = await readFile(contentMigration, 'utf8')
  const codes = new Set(
    [...sql.matchAll(/\([1-5],(?:10|[1-9]),'([1-5]\.(?:10|[1-9]))'/g)].map(
      (match) => match[1],
    ),
  )

  assert.equal(codes.size, 50)
  for (let block = 1; block <= 5; block += 1) {
    for (let unit = 1; unit <= 10; unit += 1) {
      assert.ok(codes.has(`${block}.${unit}`))
    }
  }
  assert.match(sql, /where slug = 'operadores-perforacion-corte-exterior'/)
  assert.doesNotMatch(sql, /insert into public\.courses/)
})

test('la explicación se lee sin abrir nada y la transcripción queda plegada', async () => {
  const player = await readFile(playerPath, 'utf8')

  // La explicación detallada es contenido esencial: se muestra directamente,
  // sin botón que obligue al alumno a desplegarla en cada unidad.
  assert.doesNotMatch(player, /Leer explicación completa/)
  assert.doesNotMatch(player, /explanationOpen/)
  assert.match(player, /aria-label="Explicación detallada"/)
  // La transcripción sí conserva su acordeón, un escalón por debajo.
  assert.match(player, /Transcripción del audio/)
  assert.match(player, /aria-expanded=\{transcriptOpen\}/)
  assert.match(player, /activeSegment\.lesson_code/)
  assert.match(player, /activeSegment\.manual_chapter/)
})

test('los materiales privados se administran y resuelven mediante URLs firmadas', async () => {
  const [panel, migration] = await Promise.all([
    readFile(materialsPath, 'utf8'),
    readFile(materialEditorMigration, 'utf8'),
  ])

  assert.match(
    panel,
    /resolveSignedUrls\([\s\S]*supabase,[\s\S]*["']course-materials["']/,
  )
  assert.match(panel, /PDF, PPTX, DOCX o XLSX/)
  assert.match(panel, /MAX_MATERIAL_BYTES = 50 \* 1024 \* 1024/)
  assert.match(panel, /course_version_id: versionId/)
  assert.match(
    panel,
    /storage[\s\S]*\.from\(["']course-materials["']\)[\s\S]*\.remove/,
  )
  assert.match(panel, /MATERIAL DESCARGABLE/)
  assert.match(panel, /Descargar libro de texto/)
  assert.match(panel, /Sustituir archivo/)
  assert.match(panel, /is_published/)
  assert.match(migration, /add column if not exists is_published boolean/)
  assert.match(migration, /is_published[\s\S]*current_user_is_enrolled/)
})

test('el administrador obtiene el informe unitario y lo puede exportar', async () => {
  const audit = await readFile(auditPath, 'utf8')

  assert.match(audit, /Informe de validación de contenidos/)
  assert.match(audit, /Audio duplicado/)
  assert.match(audit, /Diapositiva duplicada/)
  assert.match(audit, /lessonCode duplicado/)
  assert.match(audit, /Sin transcripción/)
  assert.match(audit, /Capítulo del manual no coincide/)
  assert.match(audit, /Verificar archivos y URLs/)
  assert.match(audit, /Descargar CSV/)
  assert.match(audit, /registros de[\s\S]*material duplicados/)
})

test('el importador obtiene las explicaciones exclusivamente del manual maestro', async () => {
  const importer = await readFile(importerPath, 'utf8')

  assert.match(importer, /Manual_Operador_Perforadora_Inminer_Campus\.pdf/)
  assert.match(importer, /pdftotext/)
  assert.match(importer, /lesson_segment_notes/)
  assert.match(importer, /approved: true/)
  assert.match(importer, /versions\.length !== 2/)
  assert.match(importer, /units\.length !== 100/)
})

test('las presentaciones por unidad se validan por lessonCode antes de sustituir diapositivas', async () => {
  const importer = await readFile(unitDeckImporterPath, 'utf8')

  assert.match(importer, /pages !== deck\.totalPages/)
  assert.match(importer, /headingCode !== expectedCode/)
  assert.match(importer, /units\.length !== 50/)
  assert.match(importer, /unit\.lesson_code !== unit\.expectedCode/)
  assert.match(importer, /pendingRegistrations/)
  assert.match(importer, /slides\/\$\{deck\.release\}/)

  // El código se lee de una posición fija de la diapositiva —el rótulo de la
  // cabecera o el título que la abre—, nunca de una cifra suelta del cuerpo,
  // para que una página descolocada no pase inadvertida. Cada presentación
  // declara cuál de las dos plantillas usa.
  assert.match(importer, /rotulo: \/\\b\(\?:PARTE\|UNIDAD\)/)
  assert.match(importer, /titulo: \/\^\[ \\t\]\*\(\[1-5\]/)
  const deckCount = [...importer.matchAll(/^    key: '/gm)].length
  const patternCount = [...importer.matchAll(/headingCode: headingCodePatterns\./g)]
    .length
  assert.equal(patternCount, deckCount)

  // Arranque y perforadora abren con una portada y encadenan las 50 unidades;
  // transporte intercala una divisoria antes de los diez apartados de cada
  // bloque, así que su unidad n cae diez páginas más allá cada bloque.
  assert.equal(
    [...importer.matchAll(/pageForUnit: \(index\) => index \+ 2,/g)].length,
    2,
  )
  assert.match(
    importer,
    /totalPages: 55,[\s\S]*?pageForUnit: \(index\) => index \+ 2 \+ Math\.floor\(index \/ 10\),/,
  )
  for (const pdf of [
    'Operador-de-Maquinaria-de-Arranque-Carga-y-Viales.pdf',
    'El-transporte-en-el-movimiento-de-tierras-y-los-tipos-de-vehiculos.pdf',
    'Formacion-Preventiva-para-el-Desempeno-del-Puesto-de-Trabajo.pdf',
  ]) {
    assert.match(importer, new RegExp(pdf.replace(/\./g, '\\.')))
  }
})

test('la reparación de perforadora deshace la doble codificación sin tocar el resto', async () => {
  const migration = await readFile(perforadoraUtf8Migration, 'utf8')

  // Solo se convierte lo que aún arrastra la doble codificación: repetir la
  // migración no cambia nada y un texto correcto nunca entra en la conversión.
  const conversions = [...migration.matchAll(/convert_from\(convert_to\(/g)].length
  const guards = [...migration.matchAll(/~ '\[ÃÂ\]'/g)].length
  assert.ok(conversions > 0)
  assert.ok(guards >= conversions)

  assert.match(migration, /'operadores-perforacion-corte-exterior'/)
  for (const table of [
    'public.courses',
    'public.course_modules',
    'public.lessons',
    'public.lesson_audio_segments',
    'public.lesson_segment_slides',
    'public.lesson_segment_notes',
  ]) {
    assert.match(migration, new RegExp(`update ${table.replace('.', '\\.')}`))
  }
})

test('transporte y silice reciben identidad estable sin tocar evaluaciones', async () => {
  const migration = await readFile(remainingCodesMigration, 'utf8')

  assert.match(
    migration,
    /'operador-maquinaria-transporte-camion-volquete'/,
  )
  assert.match(
    migration,
    /'prevencion-polvo-silice-cristalina-respirable'/,
  )
  assert.match(migration, /module\.position between 1 and 5/)
  assert.match(migration, /segment\.position between 1 and 10/)
  assert.doesNotMatch(migration, /insert into public\.courses/)
})

test('el catalogo de materiales separa cada modalidad documental', async () => {
  const importer = await readFile(sharedMaterialsImporterPath, 'utf8')

  for (const key of [
    'transporte-5h-manual',
    'transporte-20h-manual',
    'transporte-slides',
    'silice-manual',
    'silice-3h-slides',
    'establecimientos-manual',
  ]) {
    assert.match(importer, new RegExp(`key: '${key}'`))
  }
  assert.match(importer, /Manual_Maquinaria_Transporte_Inminer_Campus\.pdf/)
  assert.match(importer, /Manual_Polvo_Silice_Inminer_Campus\.pdf/)
  assert.match(importer, /CursoSilice\.pdf/)
  assert.match(importer, /Manual_Establecimientos_Beneficio_Inminer_Campus/)

  // Sílice conserva una sola modalidad, así que nada debe publicarse contra la
  // versión de 20 horas, que está retirada.
  assert.doesNotMatch(importer, /key: 'silice-20h-slides'/)
  for (const [, durations] of importer.matchAll(
    /slug: 'prevencion-polvo-silice-cristalina-respirable',\s*durations: \[([^\]]+)\]/g,
  )) {
    assert.equal(durations.trim(), '3')
  }

  // La presentación de arranque es la de 51 páginas —portada más 50 unidades—
  // y cubre por igual el reciclaje de 5 h y la formación inicial de 20 h.
  assert.match(
    importer,
    /key: 'arranque-slides',\s*slug: 'operador-maquinaria-arranque-carga-viales',\s*durations: \[5, 20\]/,
  )
  assert.match(importer, /pageCount: 51/)
  assert.match(importer, /Operador-de-Maquinaria-de-Arranque-Carga-y-Viales\.pdf/)
  assert.doesNotMatch(importer, /Curso-1-V2-IMAGENES-Y-LOGO-CORREGIDO/)
})

test('establecimientos de beneficio nace como borrador presencial de 50 unidades', async () => {
  const migration = await readFile(establecimientosMigration, 'utf8')
  const codes = new Set(
    [...migration.matchAll(/\(([1-5]),(10|[1-9]),'/g)].map(
      ([, block, unit]) => `${block}.${unit}`,
    ),
  )

  assert.equal(codes.size, 50)
  assert.match(migration, /'operadores-establecimientos-beneficio'/)
  assert.match(migration, /foreach v_duration in array array\[5, 20\]/)
  assert.match(migration, /'in_person'/)
  assert.match(migration, /'draft'/)
  assert.match(migration, /listed[\s\S]*false/)
})

test('el importador de establecimientos separa las locuciones de 5 y 20 horas', async () => {
  const importer = await readFile(establecimientosImporterPath, 'utf8')

  assert.match(importer, /LOCUCIÓN PRINCIPAL · FORMACIÓN INICIAL 20 H/)
  assert.match(importer, /LOCUCIÓN ALTERNATIVA · RECICLAJE 5 H/)
  assert.match(importer, /chapters\.push\(parseChapter/)
  assert.match(importer, /versions\.length !== 2 \|\| units\.length !== 100/)
  assert.match(importer, /lesson_segment_notes/)
  assert.match(importer, /approved: true/)
})

test('los administradores pueden revisar establecimientos sin publicarlo', async () => {
  const migration = await readFile(
    establecimientosAdminAccessMigration,
    'utf8',
  )

  assert.match(migration, /'operadores-establecimientos-beneficio'/)
  assert.match(migration, /'administrador'::public\.app_role/)
  assert.match(migration, /'superadministrador'::public\.app_role/)
  assert.match(migration, /'establecimientos_draft_preview'/)
  assert.match(migration, /on conflict \(user_id, course_version_id\) do nothing/)
  assert.doesNotMatch(migration, /status\s*=\s*'published'/)
})

test('el test aportado de transporte conserva 30 preguntas y 10 por intento', async () => {
  const importer = await readFile(transportTestImporterPath, 'utf8')

  assert.match(importer, /questions\.length !== 30/)
  assert.match(importer, /lessonCode/)
  assert.match(importer, /lesson_audio_segment_id/)
  assert.match(importer, /question_options/)
  assert.match(importer, /question_count: 10/)
  assert.doesNotMatch(importer, /active:\s*true,\s*question_count/)
})

test('el importador de audio dirige cada carpeta a una modalidad que existe', async () => {
  const importer = await readFile(audioImporterPath, 'utf8')

  // Modalidades vivas de cada curso. Sílice conserva solo la de 3 horas pese a
  // que su carpeta de audio siga llamándose «5 horas», y establecimientos
  // entrega 5 y 20 horas bajo un mismo directorio.
  const modalities: Record<string, number[]> = {
    'operador-maquinaria-arranque-carga-viales': [5, 20],
    'operador-maquinaria-transporte-camion-volquete': [5, 20],
    'prevencion-polvo-silice-cristalina-respirable': [3],
    'operadores-perforacion-corte-exterior': [5, 20],
    'operadores-establecimientos-beneficio': [5, 20],
  }

  const tableStart = importer.indexOf('const courseMappings = [')
  const table = importer.slice(
    tableStart,
    importer.indexOf('\n]', tableStart),
  )
  const mappings = table
    .split(/pattern: \/\^curso /)
    .slice(1)
    .map((entry) => ({
      folder: Number(entry.match(/^(\d+)/)?.[1]),
      slug: entry.match(/slug: '([^']+)'/)?.[1] ?? null,
      durationHours: entry.match(/durationHours: (\d+)/)
        ? Number(entry.match(/durationHours: (\d+)/)?.[1])
        : null,
      fromFolder: /durationFromFolder: true/.test(entry),
      skipped: /skip: '/.test(entry),
    }))

  assert.deepEqual(
    mappings.map(({ folder }) => folder),
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
  )

  for (const { folder, slug, durationHours, skipped } of mappings) {
    if (skipped) {
      assert.equal(slug, null, `Curso ${folder}: una carpeta omitida no apunta a ningún curso.`)
      continue
    }
    assert.ok(slug && modalities[slug], `Curso ${folder}: slug desconocido ${slug}`)
    if (durationHours !== null) {
      assert.ok(
        modalities[slug!].includes(durationHours),
        `Curso ${folder}: ${slug} no ofrece una modalidad de ${durationHours} h.`,
      )
    }
  }

  // El curso 9 resuelve su modalidad leyendo el subdirectorio; el 1 y el 6 se
  // omiten enteros y toda carpeta restante declara su duración de forma
  // explícita. El 1 se omite porque el reciclaje de arranque pasó a su juego
  // definitivo de locuciones, que sube su propio script.
  assert.equal(mappings.filter(({ fromFolder }) => fromFolder).length, 1)
  assert.equal(mappings.filter(({ skipped }) => skipped).length, 2)
  assert.match(importer, /pattern: \/\^operador maquinaria de arranque\/i/)
  assert.match(importer, /skip: 'lo sube sync-arranque-5h-final-audio\.mjs'/)
  assert.equal(
    mappings.filter(
      ({ durationHours, fromFolder, skipped }) =>
        durationHours === null && !fromFolder && !skipped,
    ).length,
    0,
  )
  assert.match(importer, /Duración no reconocida/)
})