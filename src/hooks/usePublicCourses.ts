import { useEffect, useState } from 'react'
import {
  isCourseVisibleInCatalog,
  isMissingCourseAccessColumnsError,
} from '../lib/course-access'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { CourseModality, PublicCourse } from '../lib/types'

type VersionRow = {
  id: string
  version_number: number
  duration_hours: number
  modality: CourseModality
  price_net: number | string | null
  currency: string
  courses: {
    id: string
    slug: string
    title: string
    short_description: string | null
    specialty: string | null
    cover_storage_path: string | null
    access_mode?: 'purchase' | 'access_code'
    listed?: boolean
  }
}

export function usePublicCourses() {
  const [courses, setCourses] = useState<PublicCourse[]>([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(false)

  useEffect(() => {
    let active = true

    async function loadCourses() {
      const supabase = getSupabaseBrowserClient()
      if (!supabase) {
        setLoading(false)
        return
      }

      const currentSchemaResult = await supabase
        .from('course_versions')
        .select(
          'id, version_number, duration_hours, modality, price_net, currency, courses!inner(id, slug, title, short_description, specialty, cover_storage_path, access_mode, listed)',
        )
        .eq('status', 'published')
        .eq('courses.status', 'published')
        .order('duration_hours')

      let data: unknown = currentSchemaResult.data
      let error = currentSchemaResult.error

      if (isMissingCourseAccessColumnsError(error)) {
        const legacySchemaResult = await supabase
          .from('course_versions')
          .select(
            'id, version_number, duration_hours, modality, price_net, currency, courses!inner(id, slug, title, short_description, specialty, cover_storage_path)',
          )
          .eq('status', 'published')
          .eq('courses.status', 'published')
          .order('duration_hours')

        data = legacySchemaResult.data
        error = legacySchemaResult.error
      }

      if (!active) return
      if (error) {
        console.error('No se ha podido cargar el catálogo de cursos.', error)
        setLoadError(true)
        setLoading(false)
        return
      }

      const mapped = ((data ?? []) as unknown as VersionRow[])
        .filter((row) => isCourseVisibleInCatalog(row.courses))
        .map((row) => ({
          ...row.courses,
          access_mode: row.courses.access_mode ?? 'purchase',
          versionId: row.id,
          versionNumber: row.version_number,
          duration_hours: row.duration_hours,
          modality: row.modality,
          price_net:
            row.price_net === null
              ? null
              : Number.parseFloat(String(row.price_net)),
          currency: row.currency,
        }))

      setCourses(mapped)
      setLoadError(false)
      setLoading(false)
    }

    void loadCourses()
    return () => {
      active = false
    }
  }, [])

  return { courses, loading, loadError }
}
