import assert from 'node:assert/strict'
import { access, readFile } from 'node:fs/promises'
import test from 'node:test'

const migrationUrl = new URL(
  '../supabase/migrations/202608120001_stvh_private_storage.sql',
  import.meta.url,
)
const publicSlidesRoot = new URL('../public/course-slides/stvh/', import.meta.url)
const publicMaterialsRoot = new URL(
  '../public/course-materials/stvh/',
  import.meta.url,
)
const seedSlidesRoot = new URL(
  '../supabase/storage-seed/stvh/slides/',
  import.meta.url,
)
const seedMaterialsRoot = new URL(
  '../supabase/storage-seed/stvh/materials/',
  import.meta.url,
)

test('la migración repunta las diapositivas y materiales de STVH al bucket privado', async () => {
  const sql = await readFile(migrationUrl, 'utf8')

  assert.match(sql, /c\.slug = 'formacion-stvh'/)
  assert.match(sql, /cv\.version_number = 1/)
  assert.match(sql, /image_storage_path = v_version_id::text \|\| '\/slides\/'/)
  assert.match(sql, /image_external_url = null/)
  assert.match(sql, /storage_path = v_version_id::text \|\| '\/materials\/'/)
  assert.match(sql, /external_url = null/)
  // No debe crear una política de storage nueva: la genérica por
  // <course_version_id>/... ya cubre este bucket (202607290008).
  assert.doesNotMatch(sql, /create policy/i)
})

// Este repositorio se despliega automáticamente a producción en cada push,
// sin esperar a que se apliquen las migraciones. Como la base de datos
// todavía apunta a estas rutas públicas (202608120001 no se ha aplicado
// aún en producción), los ficheros deben seguir sirviéndose desde public/
// hasta que se despliegue en el orden documentado en el propio SQL:
// 1) scripts/upload-stvh-private-assets.mjs, 2) aplicar la migración,
// 3) solo entonces retirar estas dos carpetas de public/ en un PR aparte.
test('las diapositivas y materiales de STVH siguen sirviéndose desde public/ hasta que se aplique la migración', async () => {
  await access(new URL('slide-001.jpg', publicSlidesRoot))
  await access(
    new URL('formacion-stvh-diapositivas.pdf', publicMaterialsRoot),
  )
})

test('las diapositivas y materiales de STVH también están versionados en storage-seed para poder subirlos al bucket', async () => {
  await access(new URL('slide-001.jpg', seedSlidesRoot))
  await access(new URL('slide-057.jpg', seedSlidesRoot))
  await access(
    new URL('formacion-stvh-diapositivas.pdf', seedMaterialsRoot),
  )
})
