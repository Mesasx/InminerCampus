import { createFileRoute } from '@tanstack/react-router'

type EnrollmentRow = {
  id: string
  status: string
  completed_at: string
  course_versions: {
    courses: { title: string }
  }
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

type CertificateDocument = {
  id: string
  name: string
  file_name: string
  issued_at: string
  download_kind: 'uploaded' | 'certificate' | 'stvh'
}

export const Route = createFileRoute('/api/certificates')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const { getBearerToken, getSupabaseAdmin } = await import(
          '../server/supabase-admin'
        )
        const token = getBearerToken(request)
        if (!token) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const supabase = getSupabaseAdmin()
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser(token)
        if (userError || !user) {
          return Response.json({ error: 'Sesión no válida.' }, { status: 401 })
        }

        const { data: enrollmentData, error: enrollmentError } = await supabase
          .from('enrollments')
          .select(
            'id, status, completed_at, course_versions!inner(courses!inner(title))',
          )
          .eq('user_id', user.id)
          .eq('status', 'completed')
          .order('completed_at', { ascending: false })
        if (enrollmentError) {
          return Response.json(
            { error: 'No se han podido cargar tus certificados.' },
            { status: 500 },
          )
        }

        const enrollments = (enrollmentData ?? []) as unknown as EnrollmentRow[]
        const enrollmentIds = enrollments.map((enrollment) => enrollment.id)
        const [certificatesResult, documentsResult] = enrollmentIds.length
          ? await Promise.all([
              supabase
                .from('certificates')
                .select(
                  'id, enrollment_id, certificate_code, status, issued_at, pdf_storage_path, validated_by',
                )
                .eq('user_id', user.id)
                .in('enrollment_id', enrollmentIds),
              supabase
                .from('certificate_documents')
                .select(
                  'id, certificate_id, enrollment_id, display_name, original_file_name, issued_at',
                )
                .eq('user_id', user.id)
                .in('enrollment_id', enrollmentIds)
                .order('issued_at', { ascending: false }),
            ])
          : [
              { data: [], error: null },
              { data: [], error: null },
            ]
        if (certificatesResult.error || documentsResult.error) {
          return Response.json(
            { error: 'No se han podido cargar tus certificados.' },
            { status: 500 },
          )
        }

        const certificates = new Map(
          ((certificatesResult.data ?? []) as CertificateRow[]).map(
            (certificate) => [certificate.enrollment_id, certificate],
          ),
        )
        const documentsByEnrollment = groupBy(
          (documentsResult.data ?? []) as DocumentRow[],
          (document) => document.enrollment_id,
        )
        const courses = enrollments.map((enrollment) => {
          const certificate = certificates.get(enrollment.id) ?? null
          const uploadedDocuments = documentsByEnrollment.get(enrollment.id) ?? []
          const documents: CertificateDocument[] = uploadedDocuments.map((document) => ({
            id: document.id,
            name: document.display_name,
            file_name: document.original_file_name,
            issued_at: document.issued_at,
            download_kind: 'uploaded' as const,
          }))
          if (
            certificate?.status === 'valid' &&
            (certificate.pdf_storage_path || certificate.validated_by)
          ) {
            documents.push({
              id: certificate.id,
              name: 'Certificado de formación',
              file_name: `${certificate.certificate_code}.pdf`,
              issued_at: certificate.issued_at,
              download_kind: certificate.pdf_storage_path
                ? ('certificate' as const)
                : ('stvh' as const),
            })
          }

          return {
            enrollment_id: enrollment.id,
            course_title: enrollment.course_versions.courses.title,
            completed_at: enrollment.completed_at,
            status: documents.length ? 'available' : 'pending_certificate',
            documents,
          }
        })

        return Response.json(
          { courses },
          { headers: { 'Cache-Control': 'private, no-store' } },
        )
      },
    },
  },
})

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
