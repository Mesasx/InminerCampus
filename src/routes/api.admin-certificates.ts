import { randomBytes, randomUUID } from 'node:crypto'
import { createFileRoute } from '@tanstack/react-router'

const MAX_CERTIFICATE_SIZE = 10 * 1024 * 1024
const MAX_FILES_PER_UPLOAD = 10

type EnrollmentRow = {
  id: string
  user_id: string
  course_version_id: string
  status: string
  progress_percent: number | string
  theory_completed_at: string | null
  completed_at: string | null
  started_at: string | null
  active_seconds: number | string
  course_versions: {
    duration_hours: number
    modality: string
    practice_required: boolean
    courses: { title: string; slug: string }
  }
}

type ProfileRow = {
  id: string
  email: string | null
  first_name: string
  last_name: string
  dni: string | null
}

type CertificateRow = {
  id: string
  enrollment_id: string
  certificate_code: string
  status: string
  issued_at: string
  pdf_storage_path: string | null
  validated_by: string | null
}

type DocumentRow = {
  id: string
  certificate_id: string
  enrollment_id: string
  display_name: string
  original_file_name: string
  issued_at: string
}

export const Route = createFileRoute('/api/admin-certificates')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const { requireAdministrator } = await import('../server/admin-auth')
        const administrator = await requireAdministrator(request)
        if (!administrator) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }

        try {
          const { data: enrollmentData, error: enrollmentError } =
            await administrator.supabase
              .from('enrollments')
              .select(
                'id, user_id, course_version_id, status, progress_percent, theory_completed_at, completed_at, started_at, active_seconds, course_versions!inner(duration_hours, modality, practice_required, courses!inner(title, slug))',
              )
              .in('status', [
                'theory_passed',
                'practice_pending',
                'practice_completed',
                'validation_pending',
                'completed',
              ])
              .order('completed_at', { ascending: false, nullsFirst: false })
              .limit(10_000)
          if (enrollmentError) throw enrollmentError

          const enrollments = (enrollmentData ?? []) as unknown as EnrollmentRow[]
          const userIds = [...new Set(enrollments.map((row) => row.user_id))]
          const enrollmentIds = enrollments.map((row) => row.id)

          const [profilesResult, certificatesResult, documentsResult] =
            await Promise.all([
              userIds.length
                ? administrator.supabase
                    .from('profiles')
                    .select('id, email, first_name, last_name, dni')
                    .in('id', userIds)
                : Promise.resolve({ data: [], error: null }),
              enrollmentIds.length
                ? administrator.supabase
                    .from('certificates')
                    .select(
                      'id, enrollment_id, certificate_code, status, issued_at, pdf_storage_path, validated_by',
                    )
                    .in('enrollment_id', enrollmentIds)
                : Promise.resolve({ data: [], error: null }),
              enrollmentIds.length
                ? administrator.supabase
                    .from('certificate_documents')
                    .select(
                      'id, certificate_id, enrollment_id, display_name, original_file_name, issued_at',
                    )
                    .in('enrollment_id', enrollmentIds)
                    .order('issued_at', { ascending: false })
                : Promise.resolve({ data: [], error: null }),
            ])
          if (
            profilesResult.error ||
            certificatesResult.error ||
            documentsResult.error
          ) {
            throw new Error('Could not load certificate management data')
          }

          const profiles = new Map(
            ((profilesResult.data ?? []) as ProfileRow[]).map((profile) => [
              profile.id,
              profile,
            ]),
          )
          const certificates = new Map(
            ((certificatesResult.data ?? []) as CertificateRow[]).map(
              (certificate) => [certificate.enrollment_id, certificate],
            ),
          )
          const documentsByEnrollment = groupBy(
            (documentsResult.data ?? []) as DocumentRow[],
            (document) => document.enrollment_id,
          )

          const rows = enrollments.map((enrollment) => {
            const profile = profiles.get(enrollment.user_id)
            const certificate = certificates.get(enrollment.id) ?? null
            const documents = documentsByEnrollment.get(enrollment.id) ?? []
            const hasDownload = Boolean(
              documents.length ||
                certificate?.pdf_storage_path ||
                certificate?.validated_by,
            )
            const workflowStatus = hasDownload
              ? 'available'
              : enrollment.status === 'completed'
                ? 'pending_certificate'
                : 'course_processing'

            return {
              enrollment_id: enrollment.id,
              user_id: enrollment.user_id,
              learner: {
                name: `${profile?.first_name ?? ''} ${profile?.last_name ?? ''}`.trim(),
                email: profile?.email ?? null,
                dni: profile?.dni ?? null,
              },
              course: {
                title: enrollment.course_versions.courses.title,
                slug: enrollment.course_versions.courses.slug,
                duration_hours: enrollment.course_versions.duration_hours,
                modality: enrollment.course_versions.modality,
                practice_required:
                  enrollment.course_versions.practice_required,
              },
              enrollment_status: enrollment.status,
              progress_percent: Number(enrollment.progress_percent),
              theory_completed_at: enrollment.theory_completed_at,
              completed_at: enrollment.completed_at,
              workflow_status: workflowStatus,
              certificate,
              documents,
            }
          })

          return Response.json(
            { rows },
            { headers: { 'Cache-Control': 'private, no-store' } },
          )
        } catch {
          return Response.json(
            { error: 'No se ha podido cargar la gestión de certificados.' },
            { status: 500 },
          )
        }
      },

      POST: async ({ request }) => {
        const { requireAdministrator } = await import('../server/admin-auth')
        const administrator = await requireAdministrator(request)
        if (!administrator) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }

        let formData: FormData
        try {
          formData = await request.formData()
        } catch {
          return Response.json({ error: 'Formulario no válido.' }, { status: 400 })
        }

        const enrollmentId = String(formData.get('enrollmentId') ?? '').trim()
        const files = formData
          .getAll('files')
          .filter((entry): entry is File => entry instanceof File)
        if (!isUuid(enrollmentId) || !files.length) {
          return Response.json(
            { error: 'Selecciona una matrícula y al menos un PDF.' },
            { status: 400 },
          )
        }
        if (files.length > MAX_FILES_PER_UPLOAD) {
          return Response.json(
            { error: `Puedes subir un máximo de ${MAX_FILES_PER_UPLOAD} archivos cada vez.` },
            { status: 400 },
          )
        }

        for (const file of files) {
          if (
            file.size <= 0 ||
            file.size > MAX_CERTIFICATE_SIZE ||
            file.type !== 'application/pdf' ||
            !file.name.toLowerCase().endsWith('.pdf') ||
            !(await hasPdfSignature(file))
          ) {
            return Response.json(
              { error: `«${file.name}» no es un PDF válido de hasta 10 MB.` },
              { status: 400 },
            )
          }
        }

        const supabase = administrator.supabase
        const { data: enrollmentData, error: enrollmentError } = await supabase
          .from('enrollments')
          .select(
            'id, user_id, course_version_id, status, completed_at, started_at, active_seconds, course_versions!inner(duration_hours, modality, courses!inner(title))',
          )
          .eq('id', enrollmentId)
          .maybeSingle()
        if (enrollmentError || !enrollmentData) {
          return Response.json({ error: 'Matrícula no encontrada.' }, { status: 404 })
        }

        const enrollment = enrollmentData as unknown as EnrollmentRow
        if (enrollment.status !== 'completed' || !enrollment.completed_at) {
          return Response.json(
            { error: 'La formación aún no figura como completada.' },
            { status: 409 },
          )
        }

        const { data: profile, error: profileError } = await supabase
          .from('profiles')
          .select('first_name, last_name, dni')
          .eq('id', enrollment.user_id)
          .maybeSingle()
        if (profileError || !profile) {
          return Response.json({ error: 'Perfil del alumno no encontrado.' }, { status: 404 })
        }
        const holderName = `${profile.first_name ?? ''} ${profile.last_name ?? ''}`.trim()
        const existingResult = await supabase
          .from('certificates')
          .select('id, status')
          .eq('enrollment_id', enrollment.id)
          .maybeSingle()
        if (existingResult.error) {
          return Response.json(
            { error: 'No se ha podido preparar el certificado.' },
            { status: 500 },
          )
        }

        let certificateId = existingResult.data?.id ?? null
        let certificateCreated = false
        if (existingResult.data && existingResult.data.status !== 'valid') {
          return Response.json(
            { error: 'El certificado existente no está vigente y requiere revisión.' },
            { status: 409 },
          )
        }
        if (!certificateId) {
          const { data: created, error: createError } = await supabase
            .from('certificates')
            .insert({
              enrollment_id: enrollment.id,
              user_id: enrollment.user_id,
              course_version_id: enrollment.course_version_id,
              certificate_code: certificateCode(enrollment.completed_at),
              holder_name: holderName || 'Alumno/a',
              holder_dni: profile.dni?.trim().toUpperCase() || null,
              course_title: enrollment.course_versions.courses.title,
              duration_hours: enrollment.course_versions.duration_hours,
              modality: enrollment.course_versions.modality,
              completion_date: enrollment.completed_at.slice(0, 10),
              started_at: enrollment.started_at ?? enrollment.completed_at,
              active_seconds: Number(enrollment.active_seconds),
              issued_by: administrator.user.id,
            })
            .select('id')
            .single()
          if (createError || !created) {
            return Response.json(
              { error: 'No se ha podido crear el registro del certificado.' },
              { status: 500 },
            )
          }
          certificateId = created.id
          certificateCreated = true
        }

        const uploadedPaths: string[] = []
        const documentIds: string[] = []
        try {
          for (const file of files) {
            const documentId = randomUUID()
            const storagePath = `${enrollment.user_id}/${enrollment.id}/${documentId}.pdf`
            const bytes = new Uint8Array(await file.arrayBuffer())
            const { error: uploadError } = await supabase.storage
              .from('certificates')
              .upload(storagePath, bytes, {
                contentType: 'application/pdf',
                upsert: false,
              })
            if (uploadError) throw uploadError
            uploadedPaths.push(storagePath)

            const { error: documentError } = await supabase
              .from('certificate_documents')
              .insert({
                id: documentId,
                certificate_id: certificateId,
                enrollment_id: enrollment.id,
                user_id: enrollment.user_id,
                display_name: file.name.replace(/\.pdf$/i, '').trim(),
                original_file_name: file.name,
                storage_path: storagePath,
                uploaded_by: administrator.user.id,
              })
            if (documentError) throw documentError
            documentIds.push(documentId)
          }
        } catch {
          if (documentIds.length) {
            await supabase.from('certificate_documents').delete().in('id', documentIds)
          }
          if (uploadedPaths.length) {
            await supabase.storage.from('certificates').remove(uploadedPaths)
          }
          if (certificateCreated && certificateId) {
            await supabase.from('certificates').delete().eq('id', certificateId)
          }
          return Response.json(
            { error: 'No se han podido guardar todos los certificados.' },
            { status: 500 },
          )
        }

        return Response.json(
          { uploaded: documentIds.length },
          { status: 201, headers: { 'Cache-Control': 'no-store' } },
        )
      },
    },
  },
})

function certificateCode(completedAt: string): string {
  return `INM-${new Date(completedAt).getUTCFullYear()}-${randomBytes(6).toString('hex').toUpperCase()}`
}

async function hasPdfSignature(file: File): Promise<boolean> {
  const signature = new Uint8Array(await file.slice(0, 5).arrayBuffer())
  return String.fromCharCode(...signature) === '%PDF-'
}

function isUuid(value: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
    value,
  )
}

function groupBy<Row>(
  rows: Row[],
  key: (row: Row) => string,
): Map<string, Row[]> {
  const grouped = new Map<string, Row[]>()
  for (const row of rows) {
    const rowKey = key(row)
    grouped.set(rowKey, [...(grouped.get(rowKey) ?? []), row])
  }
  return grouped
}
