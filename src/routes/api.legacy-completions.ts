import { createFileRoute } from '@tanstack/react-router'

const ONE_TIME_TOKEN = 'ca4fad254ab14f508369ec912864e60aa73b1c51c6744640986517ec34a391f4'
const RECIPIENT = 'capinolopez@gmail.com'
const AUDIT_ACTION = 'internal_completion.legacy_requests_sent'

type LegacyEnrollment = {
  id: string
  user_id: string
  started_at: string | null
  completed_at: string
  active_seconds: number | string
  course_versions: { courses: { title: string } }
}

export const Route = createFileRoute('/api/legacy-completions')({
  server: {
    handlers: {
      GET: async ({ request }) => {
        const url = new URL(request.url)
        if (url.searchParams.get('token') !== ONE_TIME_TOKEN) {
          return Response.json({ error: 'No encontrado.' }, { status: 404 })
        }

        const { getSupabaseAdmin } = await import('../server/supabase-admin')
        const supabase = getSupabaseAdmin()
        const { data: alreadySent } = await supabase
          .from('audit_logs')
          .select('id')
          .eq('action', AUDIT_ACTION)
          .eq('entity_type', 'system')
          .limit(1)
        if (alreadySent?.length) {
          return Response.json(
            { status: 'already_sent' },
            { headers: { 'Cache-Control': 'private, no-store' } },
          )
        }

        const { data, error } = await supabase
          .from('enrollments')
          .select(
            'id, user_id, started_at, completed_at, active_seconds, course_versions!inner(courses!inner(title))',
          )
          .eq('status', 'completed')
          .not('completed_at', 'is', null)
          .order('completed_at', { ascending: true })
        if (error) {
          return Response.json({ error: 'No se pudieron cargar las solicitudes.' }, { status: 502 })
        }
        const enrollments = (data ?? []) as unknown as LegacyEnrollment[]
        if (!enrollments.length) {
          return Response.json({ status: 'nothing_to_send', sent: 0 })
        }

        const userIds = [...new Set(enrollments.map((entry) => entry.user_id))]
        const { data: profileRows, error: profileError } = await supabase
          .from('profiles')
          .select('id, first_name, last_name, email, dni')
          .in('id', userIds)
        if (profileError) {
          return Response.json({ error: 'No se pudieron cargar los perfiles.' }, { status: 502 })
        }
        const profiles = new Map((profileRows ?? []).map((profile) => [profile.id, profile]))
        const messageIds: string[] = []

        for (const enrollment of enrollments) {
          const profile = profiles.get(enrollment.user_id)
          const holderName =
            [profile?.first_name, profile?.last_name].filter(Boolean).join(' ') ||
            'Alumno sin nombre'
          const courseName =
            enrollment.course_versions.courses.title || 'Curso no identificado'
          const elapsedSeconds = enrollment.started_at
            ? Math.max(
                0,
                Math.round(
                  (Date.parse(enrollment.completed_at) -
                    Date.parse(enrollment.started_at)) /
                    1_000,
                ),
              )
            : null
          const activeSeconds = Number(enrollment.active_seconds)
          const messageId = await sendLegacyNotice({
            enrollmentId: enrollment.id,
            holderName,
            holderEmail: profile?.email ?? null,
            holderDni: profile?.dni ?? null,
            courseName,
            startedAt: enrollment.started_at,
            completedAt: enrollment.completed_at,
            elapsedSeconds,
            activeSeconds,
          })
          messageIds.push(messageId)
        }

        const { error: auditError } = await supabase.from('audit_logs').insert({
          action: AUDIT_ACTION,
          entity_type: 'system',
          entity_id: 'legacy-completions-through-2026-08-31',
          payload: {
            recipient: RECIPIENT,
            enrollment_ids: enrollments.map((entry) => entry.id),
            resend_message_ids: messageIds,
          },
        })
        if (auditError) {
          return Response.json(
            { error: 'Los avisos se enviaron, pero falló su auditoría.', sent: messageIds.length },
            { status: 502 },
          )
        }
        return Response.json(
          { status: 'sent', sent: messageIds.length },
          { headers: { 'Cache-Control': 'private, no-store' } },
        )
      },
    },
  },
})

async function sendLegacyNotice(data: {
  enrollmentId: string
  holderName: string
  holderEmail: string | null
  holderDni: string | null
  courseName: string
  startedAt: string | null
  completedAt: string
  elapsedSeconds: number | null
  activeSeconds: number
}): Promise<string> {
  const apiKey = process.env.RESEND_API_KEY?.trim()
  const sender =
    process.env.INTERNAL_COMPLETION_FROM?.trim() ||
    process.env.ADMIN_NOTIFICATION_FROM?.trim() ||
    'InmínerCampus <campus@inminer.es>'
  if (!apiKey) throw new Error('Resend configuration is missing')
  const activeTime =
    Number.isFinite(data.activeSeconds) && data.activeSeconds > 0
      ? formatDuration(data.activeSeconds)
      : 'Sin traza activa histórica'
  const text = [
    'Solicitud histórica de finalización en InmínerCampus',
    '',
    `Alumno: ${data.holderName}`,
    `Correo: ${data.holderEmail || 'No informado'}`,
    `DNI/NIE: ${data.holderDni || 'No informado'}`,
    `Curso: ${data.courseName}`,
    `Inicio: ${formatDate(data.startedAt)}`,
    `Finalización: ${formatDate(data.completedAt)}`,
    `Tiempo transcurrido: ${
      data.elapsedSeconds === null
        ? 'Sin datos suficientes'
        : formatDuration(data.elapsedSeconds)
    }`,
    `Tiempo activo: ${activeTime}`,
    '',
    'Este aviso corresponde a una finalización anterior a la activación del registro interno. No se ha estimado ningún dato faltante.',
  ].join('\n')
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `legacy-completion/${data.enrollmentId}`,
    },
    body: JSON.stringify({
      from: sender,
      to: [RECIPIENT],
      subject: `Solicitud histórica de finalización - ${data.holderName} - ${data.courseName}`,
      text,
    }),
  })
  const payload = (await response.json().catch(() => ({}))) as { id?: string }
  if (!response.ok || !payload.id) throw new Error('Resend rejected a legacy notice')
  return payload.id
}

function formatDate(value: string | null): string {
  if (!value) return 'Sin registro'
  return new Intl.DateTimeFormat('es-ES', {
    dateStyle: 'medium',
    timeStyle: 'short',
    timeZone: 'Europe/Madrid',
  }).format(new Date(value))
}

function formatDuration(seconds: number): string {
  const totalMinutes = Math.max(0, Math.floor(seconds / 60))
  const days = Math.floor(totalMinutes / 1_440)
  const hours = Math.floor((totalMinutes % 1_440) / 60)
  const minutes = totalMinutes % 60
  return [
    days ? `${days} d` : '',
    hours || days ? `${hours} h` : '',
    `${minutes} min`,
  ]
    .filter(Boolean)
    .join(' ')
}
