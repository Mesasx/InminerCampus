// Acceso al catálogo público de cursos desde los loaders de ruta.
//
// A diferencia de `getSupabaseBrowserClient`, este cliente se ejecuta también
// en el servidor durante el SSR, que es lo que permite que el HTML inicial ya
// contenga el contenido del curso. Usa la clave *publishable* (anónima), nunca
// `service_role`: las políticas RLS `courses_public_published` y
// `course_versions_visible` ya exponen a `anon` exactamente las filas
// publicadas, así que renderizar SEO no requiere elevar privilegios.
import { createClient, type SupabaseClient } from '@supabase/supabase-js'
import { appConfig } from './config.ts'
import {
  isCourseVisibleInCatalog,
  isMissingCourseAccessColumnsError,
} from './course-access.ts'
import type { CourseModality, PublicCourse } from './types.ts'

let publicClient: SupabaseClient | undefined

/**
 * Cliente para lecturas públicas, o `null` si Supabase no está configurado.
 *
 * Para las rutas indexables usa `requireSupabasePublicClient`: distinguir
 * «no configurado» de «no existe» es importante para SEO.
 */
export function getSupabasePublicClient(): SupabaseClient | null {
  if (!appConfig.isSupabaseConfigured) return null
  if (!publicClient) {
    publicClient = createClient(
      appConfig.supabaseUrl,
      appConfig.supabasePublishableKey,
      {
        // Lecturas públicas y sin estado: en el servidor no hay sesión que
        // persistir, y activarlo provocaría accesos a un storage inexistente.
        auth: {
          persistSession: false,
          autoRefreshToken: false,
          detectSessionInUrl: false,
        },
      },
    )
  }
  return publicClient
}

/**
 * Igual que `getSupabasePublicClient`, pero falla si falta la configuración.
 *
 * Un despliegue sin las variables de Supabase debe devolver un error 5xx, no
 * un 404: un 404 le diría a Google que las fichas de curso han dejado de
 * existir y provocaría su desindexación.
 */
function requireSupabasePublicClient(): SupabaseClient {
  const supabase = getSupabasePublicClient()
  if (!supabase) {
    throw new Error(
      'Supabase no está configurado: faltan VITE_SUPABASE_URL o VITE_SUPABASE_PUBLISHABLE_KEY.',
    )
  }
  return supabase
}

const VERSION_COLUMNS =
  'id, version_number, duration_hours, modality, objectives, target_audience, requirements, syllabus_summary, practice_required, accreditation_reference, renewal_interval_months, price_net, tax_rate, currency'

const COURSE_COLUMNS = `id, slug, title, short_description, description, specialty, access_mode, listed, updated_at, course_versions!inner(${VERSION_COLUMNS})`

// Instancias que todavía no tienen las columnas `access_mode` / `listed`.
const LEGACY_COURSE_COLUMNS = `id, slug, title, short_description, description, specialty, updated_at, course_versions!inner(${VERSION_COLUMNS})`

export type PublicCourseVersion = {
  id: string
  version_number: number
  duration_hours: number
  modality: CourseModality
  objectives: Array<string>
  target_audience: Array<string>
  requirements: Array<string>
  syllabus_summary: string
  practice_required: boolean
  accreditation_reference: string | null
  renewal_interval_months: number | null
  price_net: number | null
  tax_rate: number
  currency: string
}

export type PublicCourseDetail = {
  id: string
  slug: string
  title: string
  short_description: string
  description: string
  specialty: string
  access_mode: 'purchase' | 'access_code'
  listed: boolean
  updated_at: string | null
  versions: Array<PublicCourseVersion>
}

type RawCourseRow = Record<string, unknown> & {
  course_versions?: Array<Record<string, unknown>>
}

function toNumber(value: unknown): number | null {
  if (value === null || value === undefined || value === '') return null
  const parsed = Number.parseFloat(String(value))
  return Number.isFinite(parsed) ? parsed : null
}

function toStringArray(value: unknown): Array<string> {
  if (!Array.isArray(value)) return []
  return value.filter((item): item is string => typeof item === 'string')
}

function normalizeVersion(raw: Record<string, unknown>): PublicCourseVersion {
  return {
    id: String(raw.id),
    version_number: Number(raw.version_number ?? 0),
    duration_hours: Number(raw.duration_hours ?? 0),
    modality: (raw.modality as CourseModality) ?? 'online',
    objectives: toStringArray(raw.objectives),
    target_audience: toStringArray(raw.target_audience),
    requirements: toStringArray(raw.requirements),
    syllabus_summary:
      typeof raw.syllabus_summary === 'string' ? raw.syllabus_summary : '',
    practice_required: Boolean(raw.practice_required),
    accreditation_reference:
      typeof raw.accreditation_reference === 'string'
        ? raw.accreditation_reference
        : null,
    renewal_interval_months: toNumber(raw.renewal_interval_months),
    price_net: toNumber(raw.price_net),
    tax_rate: toNumber(raw.tax_rate) ?? 0,
    currency: typeof raw.currency === 'string' ? raw.currency : 'EUR',
  }
}

function normalizeCourse(raw: RawCourseRow): PublicCourseDetail {
  const versions = (raw.course_versions ?? [])
    .map(normalizeVersion)
    // `version_number` descendente: reproduce el orden que ya devolvía la
    // consulta del cliente, de modo que `versions[0]` siga siendo la versión
    // que la ficha selecciona por defecto (la formación inicial) y el selector
    // de duración conserve el mismo orden que antes del SSR.
    .sort((a, b) => b.version_number - a.version_number)

  return {
    id: String(raw.id),
    slug: String(raw.slug),
    title: String(raw.title ?? ''),
    short_description:
      typeof raw.short_description === 'string' ? raw.short_description : '',
    description: typeof raw.description === 'string' ? raw.description : '',
    specialty: typeof raw.specialty === 'string' ? raw.specialty : '',
    access_mode: raw.access_mode === 'access_code' ? 'access_code' : 'purchase',
    listed: raw.listed !== false,
    updated_at: typeof raw.updated_at === 'string' ? raw.updated_at : null,
    versions,
  }
}

/** Todos los cursos publicados y visibles en el catálogo. */
export async function fetchPublicCourses(): Promise<Array<PublicCourseDetail>> {
  const supabase = requireSupabasePublicClient()

  const query = (columns: string) =>
    supabase
      .from('courses')
      .select(columns)
      .eq('status', 'published')
      .eq('course_versions.status', 'published')
      .order('title')

  let { data, error } = await query(COURSE_COLUMNS)
  if (isMissingCourseAccessColumnsError(error)) {
    ;({ data, error } = await query(LEGACY_COURSE_COLUMNS))
  }
  if (error) throw error

  return ((data ?? []) as unknown as Array<RawCourseRow>)
    .map(normalizeCourse)
    .filter((course) => course.versions.length > 0)
    .filter((course) =>
      isCourseVisibleInCatalog({ slug: course.slug, listed: course.listed }),
    )
}

/**
 * Una ficha concreta, o `null` si el slug no existe, no está publicado o no es
 * visible en el catálogo.
 *
 * Un curso no listado no tiene ficha pública: conocer su URL no puede bastar
 * para verlo. La ruta `/cursos/$courseSlug` convierte ese `null` en un 404, de
 * modo que ocultar la tarjeta y proteger la URL son la misma decisión.
 */
export async function fetchPublicCourse(
  slug: string,
): Promise<PublicCourseDetail | null> {
  const supabase = requireSupabasePublicClient()

  const query = (columns: string) =>
    supabase
      .from('courses')
      .select(columns)
      .eq('slug', slug)
      .eq('status', 'published')
      .eq('course_versions.status', 'published')
      .limit(1)

  let { data, error } = await query(COURSE_COLUMNS)
  if (isMissingCourseAccessColumnsError(error)) {
    ;({ data, error } = await query(LEGACY_COURSE_COLUMNS))
  }
  if (error) throw error

  const rows = (data ?? []) as unknown as Array<RawCourseRow>
  if (!rows[0]) return null
  const course = normalizeCourse(rows[0])
  if (!course.versions.length) return null
  return isCourseVisibleInCatalog({ slug: course.slug, listed: course.listed })
    ? course
    : null
}

/**
 * Cursos que deben entrar en el sitemap y ser indexables.
 *
 * Se excluyen los de acceso por invitación (`access_mode = 'access_code'`): no
 * se comercializan, su ficha sólo explica que el acceso se obtiene con un
 * código y no responden a ninguna búsqueda real, así que no aportan nada al
 * índice y diluyen el foco temático del dominio.
 */
export function isIndexableCourse(course: {
  access_mode: 'purchase' | 'access_code'
}): boolean {
  return course.access_mode !== 'access_code'
}

/**
 * Aplana el catálogo a una tarjeta por versión publicada, que es la forma que
 * consumen `CourseCard` y el carrusel de la home. Se ordena por duración para
 * reproducir el `.order('duration_hours')` que hacía el hook de cliente.
 */
export function toCourseCards(
  courses: Array<PublicCourseDetail>,
): Array<PublicCourse> {
  return courses
    .flatMap((course) =>
      course.versions.map((version) => ({
        id: course.id,
        slug: course.slug,
        title: course.title,
        short_description: course.short_description,
        specialty: course.specialty,
        accreditation_reference: version.accreditation_reference,
        cover_storage_path: null,
        access_mode: course.access_mode,
        versionId: version.id,
        versionNumber: version.version_number,
        duration_hours: version.duration_hours,
        modality: version.modality,
        price_net: version.price_net,
        currency: version.currency,
      })),
    )
    .sort((a, b) => a.duration_hours - b.duration_hours)
}
