export type AppRole =
  | 'alumno'
  | 'responsable_empresa'
  | 'tutor'
  | 'administrador'
  | 'superadministrador'

export type CourseModality = 'online' | 'in_person' | 'hybrid'

export interface PublicCourse {
  id: string
  versionId: string
  versionNumber: number
  slug: string
  title: string
  short_description: string | null
  duration_hours: 5 | 20
  modality: CourseModality
  cover_storage_path: string | null
  price_net: number | null
  currency: string
}

export interface EnrollmentCard {
  id: string
  status: string
  progress_percent: number
  enrolled_at: string
  course: {
    slug: string
    title: string
    duration_hours: number
    modality: CourseModality
  }
}

export interface SessionUser {
  id: string
  email: string
  firstName: string
  roles: AppRole[]
}
