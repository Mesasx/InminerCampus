import { createFileRoute } from '@tanstack/react-router'
import type { User } from '@supabase/supabase-js'

const AUTH_PAGE_SIZE = 1_000

type ProfileRow = {
  id: string
  email: string | null
  first_name: string
  last_name: string
  phone: string | null
  dni: string | null
  status: string
  first_access_at: string | null
  last_access_at: string | null
  created_at: string
}

type RoleRow = {
  user_id: string
  role: string
}

type EnrollmentRow = {
  id: string
  user_id: string
  status: string
  progress_percent: number | string
  enrolled_at: string
  started_at: string | null
  theory_completed_at: string | null
  completed_at: string | null
  active_seconds: number | string
  course_versions: {
    version_number: number
    duration_hours: number
    modality: string
    courses: {
      title: string
      slug: string
    }
  }
}

export const Route = createFileRoute('/api/admin-users')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const { requireAdministrator } = await import('../server/admin-auth')
        const administrator = await requireAdministrator(request)
        if (!administrator) {
          return Response.json({ error: 'No tienes permisos.' }, { status: 403 })
        }

        try {
          const users = await listAllAuthUsers(administrator.supabase)
          const [profilesResult, rolesResult, enrollmentsResult] =
            await Promise.all([
              administrator.supabase
                .from('profiles')
                .select(
                  'id, email, first_name, last_name, phone, dni, status, first_access_at, last_access_at, created_at',
                )
                .limit(10_000),
              administrator.supabase
                .from('user_roles')
                .select('user_id, role')
                .limit(50_000),
              administrator.supabase
                .from('enrollments')
                .select(
                  'id, user_id, status, progress_percent, enrolled_at, started_at, theory_completed_at, completed_at, active_seconds, course_versions!inner(version_number, duration_hours, modality, courses!inner(title, slug))',
                )
                .order('enrolled_at', { ascending: false })
                .limit(50_000),
            ])

          if (
            profilesResult.error ||
            rolesResult.error ||
            enrollmentsResult.error
          ) {
            throw new Error('Could not load administrative user data')
          }

          const profiles = new Map(
            ((profilesResult.data ?? []) as ProfileRow[]).map((profile) => [
              profile.id,
              profile,
            ]),
          )
          const rolesByUser = groupRows(
            (rolesResult.data ?? []) as RoleRow[],
            (role) => role.user_id,
          )
          const enrollmentsByUser = groupRows(
            (enrollmentsResult.data ?? []) as unknown as EnrollmentRow[],
            (enrollment) => enrollment.user_id,
          )

          const rows = users
            .map((authUser) => {
              const profile = profiles.get(authUser.id)
              return {
                id: authUser.id,
                email: authUser.email ?? profile?.email ?? null,
                phone: profile?.phone ?? authUser.phone ?? null,
                first_name: profile?.first_name ?? '',
                last_name: profile?.last_name ?? '',
                dni: profile?.dni ?? null,
                status: profile?.status ?? 'profile_missing',
                profile_exists: Boolean(profile),
                registered_at: authUser.created_at,
                email_confirmed_at: authUser.email_confirmed_at ?? null,
                last_sign_in_at: authUser.last_sign_in_at ?? null,
                first_access_at: profile?.first_access_at ?? null,
                last_access_at: profile?.last_access_at ?? null,
                roles: (rolesByUser.get(authUser.id) ?? []).map(
                  (role) => role.role,
                ),
                enrollments: (enrollmentsByUser.get(authUser.id) ?? []).map(
                  (enrollment) => ({
                    id: enrollment.id,
                    status: enrollment.status,
                    progress_percent: Number(enrollment.progress_percent),
                    enrolled_at: enrollment.enrolled_at,
                    started_at: enrollment.started_at,
                    theory_completed_at: enrollment.theory_completed_at,
                    completed_at: enrollment.completed_at,
                    active_seconds: Number(enrollment.active_seconds),
                    course: {
                      title: enrollment.course_versions.courses.title,
                      slug: enrollment.course_versions.courses.slug,
                      version_number:
                        enrollment.course_versions.version_number,
                      duration_hours:
                        enrollment.course_versions.duration_hours,
                      modality: enrollment.course_versions.modality,
                    },
                  })),
              }
            })
            .sort(
              (left, right) =>
                Date.parse(right.registered_at) - Date.parse(left.registered_at),
            )

          return Response.json(
            { users: rows },
            { headers: { 'Cache-Control': 'private, no-store' } },
          )
        } catch {
          return Response.json(
            { error: 'No se ha podido cargar el listado de usuarios.' },
            { status: 500 },
          )
        }
      },
    },
  },
})

async function listAllAuthUsers(supabase: {
  auth: {
    admin: {
      listUsers: (options: {
        page: number
        perPage: number
      }) => Promise<{ data: { users: User[] }; error: Error | null }>
    }
  }
}): Promise<User[]> {
  const users: User[] = []
  for (let page = 1; ; page += 1) {
    const { data, error } = await supabase.auth.admin.listUsers({
      page,
      perPage: AUTH_PAGE_SIZE,
    })
    if (error) throw error
    users.push(...data.users)
    if (data.users.length < AUTH_PAGE_SIZE) return users
  }
}

function groupRows<Row>(
  rows: Row[],
  key: (row: Row) => string,
): Map<string, Row[]> {
  const grouped = new Map<string, Row[]>()
  rows.forEach((row) => {
    const rowKey = key(row)
    grouped.set(rowKey, [...(grouped.get(rowKey) ?? []), row])
  })
  return grouped
}
