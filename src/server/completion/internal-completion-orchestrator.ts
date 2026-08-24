export type InternalCompletionJob = {
  id: string
  enrollment_id: string
  user_id: string
  course_version_id: string
  attempt_count: number
  generated_at: string | null
  snapshot: unknown
  pdf_storage_path: string | null
  pdf_sha256: string | null
}

export type InternalCompletionRunResult =
  | 'sent'
  | 'already_handled'
  | 'failed'

export class InternalCompletionJobError extends Error {
  readonly retryable: boolean

  constructor(
    message: string,
    retryable: boolean,
  ) {
    super(message)
    this.name = 'InternalCompletionJobError'
    this.retryable = retryable
  }
}

export async function runInternalCompletionOnce<Prepared>(
  enrollmentId: string,
  dependencies: {
    claim: (enrollmentId: string) => Promise<InternalCompletionJob | null>
    validate: (job: InternalCompletionJob) => Promise<void>
    prepare: (job: InternalCompletionJob) => Promise<Prepared>
    send: (job: InternalCompletionJob, prepared: Prepared) => Promise<string>
    complete: (result: {
      job: InternalCompletionJob
      success: boolean
      retryable: boolean
      messageId: string
      error: string
    }) => Promise<void>
  },
): Promise<InternalCompletionRunResult> {
  const job = await dependencies.claim(enrollmentId)
  if (!job) return 'already_handled'

  try {
    await dependencies.validate(job)
    const prepared = await dependencies.prepare(job)
    const messageId = await dependencies.send(job, prepared)
    await dependencies.complete({
      job,
      success: true,
      retryable: false,
      messageId,
      error: '',
    })
    return 'sent'
  } catch (error) {
    const normalized = normalizeInternalCompletionError(error)
    await dependencies.complete({
      job,
      success: false,
      retryable: normalized.retryable,
      messageId: '',
      error: normalized.message,
    })
    return 'failed'
  }
}

export function normalizeInternalCompletionError(error: unknown): {
  message: string
  retryable: boolean
} {
  if (error instanceof InternalCompletionJobError) {
    return { message: error.message, retryable: error.retryable }
  }
  return {
    message: 'Unexpected internal completion error',
    retryable: true,
  }
}
