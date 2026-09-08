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
const arranqueDeckImporterPath = new URL(
  '../scripts/upload-arranque-current-deck.mjs',
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

test('el alumno puede desplegar transcripción y explicación completa', async () => {
  const player = await readFile(playerPath, 'utf8')

  assert.match(player, /Ver transcripción/)
  assert.match(player, /Leer explicación completa/)
  assert.match(player, /aria-expanded=\{transcriptOpen\}/)
  assert.match(player, /aria-expanded=\{explanationOpen\}/)
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

test('la presentación actual de arranque se valida por lessonCode antes de sustituir diapositivas', async () => {
  const importer = await readFile(arranqueDeckImporterPath, 'utf8')

  assert.match(importer, /pages !== 51/)
  assert.match(importer, /headingCode !== expectedCode/)
  assert.match(importer, /units\.length !== 50/)
  assert.match(importer, /unit\.lesson_code !== unit\.expectedCode/)
  assert.match(importer, /pendingRegistrations/)
  assert.match(importer, /slides\/arranque-2026/)
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
    'transporte-5h-slides',
    'transporte-20h-manual',
    'transporte-20h-slides',
    'silice-manual',
    'silice-3h-slides',
    'silice-20h-slides',
    'establecimientos-manual',
  ]) {
    assert.match(importer, new RegExp(`key: '${key}'`))
  }
  assert.match(importer, /Manual_Maquinaria_Transporte_Inminer_Campus\.pdf/)
  assert.match(importer, /Manual_Polvo_Silice_Inminer_Campus\.pdf/)
  assert.match(importer, /CursoSilice\.pdf/)
  assert.match(importer, /Manual_Establecimientos_Beneficio_Inminer_Campus/)
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
