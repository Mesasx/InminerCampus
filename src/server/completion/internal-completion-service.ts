import { createHash } from 'node:crypto'
import type { SupabaseClient } from '@supabase/supabase-js'
import { getSupabaseAdmin } from '../supabase-admin'
import {
  createInternalCompletionPdf,
  formatInternalActiveTime,
  formatInternalDateTime,
  internalCompletionFileName,
  type InternalCompletionPdfData,
} from './internal-completion-pdf'
import {
  InternalCompletionJobError,
  runInternalCompletionOnce,
  type InternalCompletionJob,
  type InternalCompletionRunResult,
} from './internal-completion-orchestrator'

const COMPLETION_BUCKET = 'internal-completion-documents'

type CompletionContext = InternalCompletionPdfData & {
  practiceRequired: boolean
}

type PreparedCompletion = {
  bytes: Uint8Array
  snapshot: InternalCompletionPdfData
  fileName: string
}

type EnrollmentRow = {
  id: string
  user_id: string
  course_version_id: string
  status: string
  progress_percent: number | string
  started_at: string | null
  completed_at: string | null
  active_seconds: number | string
  course_versions: {
    practice_required: boolean
    accreditation_reference: string | null
    courses: { title: string }
  }
}

export async function processInternalCompletion(
  enrollmentId: string,
): Promise<InternalCompletionRunResult> {
  const supabase = getSupabaseAdmin()
  return runInternalCompletionOnce(
    enrollmentId,
    createDependencies(supabase, async () =>
      claimSingleInternalCompletion(supabase, enrollmentId),
    ),
  )
}

export async function processDueInternalCompletions(limit = 10): Promise<{
  claimed: number
  sent: number
  failed: number
}> {
  const supabase = getSupabaseAdmin()
  const { data, error } = await supabase.rpc('claim_internal_completion_jobs', {
    p_limit: limit,
    p_enrollment_id: null,
  })
  if (error) throw new Error('Could not claim internal completion jobs')

  const jobs = (data ?? []) as InternalCompletionJob[]
  let sent = 0
  let failed = 0
  for (const job of jobs) {
    const result = await runInternalCompletionOnce(
      job.enrollment_id,
      createDependencies(supabase, async () => job),
    )
    if (result === 'sent') sent += 1
    if (result === 'failed') failed += 1
  }
  return { claimed: jobs.length, sent, failed }
}

function createDependencies(
  supabase: SupabaseClient,
  claim: (enrollmentId: string) => Promise<InternalCompletionJob | null>,
) {
  const contexts = new Map<string, CompletionContext>()
  return {
    claim,
    validate: async (job: InternalCompletionJob) => {
      contexts.set(job.id, await loadAndValidateContext(supabase, job))
    },
    prepare: async (job: InternalCompletionJob) => {
      const context = contexts.get(job.id)
      if (!context) {
        throw new InternalCompletionJobError(
          'Completion context was not validated',
          true,
        )
      }
      return prepareInternalCompletion(supabase, job, context)
    },
    send: async (job: InternalCompletionJob, prepared: PreparedCompletion) =>
      sendInternalCompletionEmail(job, prepared),
    complete: async ({
      job,
      success,
      retryable,
      messageId,
      error,
    }: {
      job: InternalCompletionJob
      success: boolean
      retryable: boolean
      messageId: string
      error: string
    }) => {
      const { error: completionError } = await supabase.rpc(
        'complete_internal_completion_job',
        {
          p_record_id: job.id,
          p_success: success,
          p_retryable: retryable,
          p_resend_message_id: messageId,
          p_error: error,
        },
      )
      if (completionError) {
        throw new Error('Could not persist internal completion result')
      }
    },
  }
}

async function claimSingleInternalCompletion(
  supabase: SupabaseClient,
  enrollmentId: string,
): Promise<InternalCompletionJob | null> {
  const { data, error } = await supabase.rpc('claim_internal_completion_jobs', {
    p_limit: 1,
    p_enrollment_id: enrollmentId,
  })
  if (error) throw new Error('Could not claim internal completion')
  return ((data ?? [])[0] as InternalCompletionJob | undefined) ?? null
}

async function loadAndValidateContext(
  supabase: SupabaseClient,
  job: InternalCompletionJob,
): Promise<CompletionContext> {
  const { data: enrollment, error: enrollmentError } = await supabase
    .from('enrollments')
    .select(
      'id, user_id, course_version_id, status, progress_percent, started_at, completed_at, active_seconds, course_versions!inner(practice_required, accreditation_reference, courses!inner(title))',
    )
    .eq('id', job.enrollment_id)
    .maybeSingle()
  if (enrollmentError || !enrollment) {
    throw new InternalCompletionJobError('Enrollment not found', false)
  }
  const row = enrollment as unknown as EnrollmentRow
  if (
    row.user_id !== job.user_id ||
    row.course_version_id !== job.course_version_id ||
    row.status !== 'completed' ||
    !row.completed_at ||
    !row.started_at ||
    Number(row.progress_percent) < 100
  ) {
    throw new InternalCompletionJobError(
      'Enrollment does not meet completion requirements',
      false,
    )
  }

  const [profileResult, progressResult, activityResult, practiceResult] =
    await Promise.all([
      supabase
        .from('profiles')
        .select('first_name, last_name, dni, email')
        .eq('id', row.user_id)
        .maybeSingle(),
      supabase
        .from('lesson_progress')
        .select('status')
        .eq('enrollment_id', row.id),
      supabase
        .from('learning_activity_events')
        .select('created_at')
        .eq('enrollment_id', row.id)
        .order('created_at', { ascending: true }),
      row.course_versions.practice_required
        ? supabase
            .from('practice_attendance')
            .select('id')
            .eq('enrollment_id', row.id)
            .eq('result', 'passed')
            .limit(1)
        : Promise.resolve({ data: [{ id: 'not-required' }], error: null }),
    ])

  if (profileResult.error || !profileResult.data) {
    throw new InternalCompletionJobError('Student profile not found', true)
  }
  if (
    progressResult.error ||
    !progressResult.data?.length ||
    progressResult.data.some((progress) => progress.status !== 'completed')
  ) {
    throw new InternalCompletionJobError(
      'Not every required lesson is completed',
      false,
    )
  }
  if (practiceResult.error || !practiceResult.data?.length) {
    throw new InternalCompletionJobError(
      'Required practice has not been validated',
      false,
    )
  }
  if (activityResult.error) {
    throw new InternalCompletionJobError('Activity trace could not be loaded', true)
  }

  const profile = profileResult.data
  const holderName = `${profile.first_name ?? ''} ${profile.last_name ?? ''}`.trim()
  const holderDni = profile.dni?.trim().toUpperCase() ?? ''
  let holderEmail = profile.email?.trim().toLowerCase() ?? ''
  if (!holderEmail) {
    const { data: authData, error: authError } =
      await supabase.auth.admin.getUserById(row.user_id)
    if (authError) {
      throw new InternalCompletionJobError('Student email could not be loaded', true)
    }
    holderEmail = authData.user?.email?.trim().toLowerCase() ?? ''
  }
  if (!holderName || !holderDni || !holderEmail) {
    throw new InternalCompletionJobError(
      'Student name, DNI/NIE or email is missing from the profile',
      true,
    )
  }

  const activeSeconds = Number(row.active_seconds)
  const activityDates = (activityResult.data ?? []).map(
    (event) => event.created_at,
  )
  if (!Number.isFinite(activeSeconds) || activeSeconds <= 0 || !activityDates.length) {
    throw new InternalCompletionJobError(
      'No reliable active-time trace exists for this enrollment',
      false,
    )
  }

  return {
    courseName: row.course_versions.courses.title,
    accreditationReference: row.course_versions.accreditation_reference,
    enrollmentId: row.id,
    holderName,
    holderDni,
    holderEmail,
    startedAt: row.started_at,
    completedAt: row.completed_at,
    activeSeconds,
    activityDates,
    generatedAt: job.generated_at ?? new Date().toISOString(),
    practiceRequired: row.course_versions.practice_required,
  }
}

async function prepareInternalCompletion(
  supabase: SupabaseClient,
  job: InternalCompletionJob,
  context: CompletionContext,
): Promise<PreparedCompletion> {
  if (job.pdf_storage_path && isCompletionSnapshot(job.snapshot)) {
    const { data, error } = await supabase.storage
      .from(COMPLETION_BUCKET)
      .download(job.pdf_storage_path)
    if (error || !data) {
      throw new InternalCompletionJobError('Stored completion PDF is unavailable', true)
    }
    const bytes = new Uint8Array(await data.arrayBuffer())
    if (job.pdf_sha256 && sha256(bytes) !== job.pdf_sha256) {
      throw new InternalCompletionJobError('Stored completion PDF hash mismatch', false)
    }
    return {
      bytes,
      snapshot: job.snapshot,
      fileName: internalCompletionFileName(job.snapshot),
    }
  }

  const snapshot: InternalCompletionPdfData = {
    courseName: context.courseName,
    accreditationReference: context.accreditationReference,
    enrollmentId: context.enrollmentId,
    holderName: context.holderName,
    holderDni: context.holderDni,
    holderEmail: context.holderEmail,
    startedAt: context.startedAt,
    completedAt: context.completedAt,
    activeSeconds: context.activeSeconds,
    activityDates: context.activityDates,
    generatedAt: context.generatedAt,
  }
  const logoBytes = await loadBrandLogo()
  const bytes = await createInternalCompletionPdf(snapshot, logoBytes)
  const hash = sha256(bytes)
  const storagePath = `completions/${job.enrollment_id}/registro-finalizacion.pdf`
  const bucket = supabase.storage.from(COMPLETION_BUCKET)
  const { error: uploadError } = await bucket.upload(storagePath, bytes, {
    contentType: 'application/pdf',
    upsert: false,
  })
  if (uploadError) {
    const { data: existing, error: downloadError } = await bucket.download(
      storagePath,
    )
    if (downloadError || !existing) {
      throw new InternalCompletionJobError('Completion PDF could not be stored', true)
    }
    const existingBytes = new Uint8Array(await existing.arrayBuffer())
    if (sha256(existingBytes) !== hash) {
      throw new InternalCompletionJobError(
        'Completion PDF path already contains different content',
        false,
      )
    }
  }

  const { error: updateError } = await supabase
    .from('internal_completion_records')
    .update({
      generated_at: snapshot.generatedAt,
      snapshot,
      pdf_storage_path: storagePath,
      pdf_sha256: hash,
    })
    .eq('id', job.id)
    .is('pdf_storage_path', null)
  if (updateError) {
    throw new InternalCompletionJobError(
      'Completion PDF trace could not be persisted',
      true,
    )
  }

  return {
    bytes,
    snapshot,
    fileName: internalCompletionFileName(snapshot),
  }
}

async function sendInternalCompletionEmail(
  job: InternalCompletionJob,
  prepared: PreparedCompletion,
): Promise<string> {
  const apiKey = process.env.RESEND_API_KEY?.trim()
  const recipient =
    process.env.INTERNAL_COMPLETION_EMAIL?.trim() || 'pedro@inminer.es'
  const sender =
    process.env.INTERNAL_COMPLETION_FROM?.trim() ||
    process.env.ADMIN_NOTIFICATION_FROM?.trim() ||
    'InmínerCampus <campus@inminer.es>'
  if (!apiKey) {
    throw new InternalCompletionJobError('RESEND_API_KEY is not configured', false)
  }

  const data = prepared.snapshot
  const text = [
    'Un alumno ha completado una formación en InmínerCampus.',
    '',
    'Alumno:',
    data.holderName,
    '',
    'DNI/NIE:',
    data.holderDni,
    '',
    'Curso:',
    data.courseName,
    '',
    'Inicio:',
    formatInternalDateTime(data.startedAt),
    '',
    'Finalización:',
    formatInternalDateTime(data.completedAt),
    '',
    'Tiempo activo:',
    formatInternalActiveTime(data.activeSeconds),
    '',
    'Se adjunta el registro interno de finalización para la tramitación del certificado definitivo.',
  ].join('\n')
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `internal-completion/${job.enrollment_id}`,
    },
    body: JSON.stringify({
      from: sender,
      to: [recipient],
      subject: `Formación finalizada - ${data.holderName} - ${data.courseName}`,
      text,
      attachments: [
        {
          filename: prepared.fileName,
          content: Buffer.from(prepared.bytes).toString('base64'),
        },
      ],
    }),
  })
  const payload = (await response.json().catch(() => ({}))) as {
    id?: string
    message?: string
  }
  if (!response.ok || !payload.id) {
    throw new InternalCompletionJobError(
      payload.message
        ? `Resend rejected the completion email: ${payload.message}`
        : `Resend returned HTTP ${response.status}`,
      response.status >= 500,
    )
  }
  return payload.id
}

async function loadBrandLogo(): Promise<Uint8Array> {
  const appUrl = (
    process.env.INTERNAL_APP_URL?.trim() ||
    process.env.VITE_APP_URL?.trim() ||
    ''
  ).replace(/\/+$/, '')
  if (!appUrl) {
    throw new InternalCompletionJobError('Application URL is not configured', false)
  }
  const response = await fetch(`${appUrl}/brand/inminer-campus-logo.png`, {
    signal: AbortSignal.timeout(5_000),
  })
  if (!response.ok) {
    throw new InternalCompletionJobError('Brand logo could not be loaded', true)
  }
  return new Uint8Array(await response.arrayBuffer())
}

function isCompletionSnapshot(value: unknown): value is InternalCompletionPdfData {
  if (!value || typeof value !== 'object') return false
  const snapshot = value as Partial<InternalCompletionPdfData>
  return Boolean(
    snapshot.courseName &&
      snapshot.enrollmentId &&
      snapshot.holderName &&
      snapshot.holderDni &&
      snapshot.holderEmail &&
      snapshot.startedAt &&
      snapshot.completedAt &&
      snapshot.generatedAt &&
      Array.isArray(snapshot.activityDates) &&
      Number.isFinite(snapshot.activeSeconds),
  )
}

function sha256(bytes: Uint8Array): string {
  return createHash('sha256').update(bytes).digest('hex')
}

export const internalCompletionInternals = {
  isCompletionSnapshot,
  sha256,
}
