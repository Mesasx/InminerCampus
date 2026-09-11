import { createFileRoute, Link } from '@tanstack/react-router'
import { CheckCircle2, RotateCcw, ShieldCheck, XCircle } from 'lucide-react'
import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { requestInternalCompletion } from '../lib/internal-completion'
import { quizIntroCopy, quizRoundsLabel, QUIZ_INTRO_TITLE } from '../lib/quiz-copy'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'
import { useLearningActivityHeartbeat } from '../lib/use-activity-heartbeat'
import { seoHead } from '../lib/seo'

export const Route = createFileRoute(
  '/evaluacion/$enrollmentId/$quizId',
)({
  head: () => seoHead({
    title: 'Evaluación',
    description: 'Evaluación final del curso.',
    path: '/evaluacion',
    noindex: true,
  }),
  component: EvaluationPage,
})

type AttemptQuestion = {
  id: string
  prompt: string
  type: 'single_choice' | 'multiple_choice'
  options: Array<{ id: string; text: string }>
}

type Attempt = {
  attemptId: string
  attemptNumber: number
  title: string
  currentStreak: number
  requiredStreak: number
  currentPerfectRounds?: number
  requiredPerfectRounds?: number
  completionMode?: 'consecutive_perfect' | 'cumulative_perfect'
  questions: AttemptQuestion[]
}

type AttemptResult = {
  scorePercent: number
  isPerfect: boolean
  perfectStreak: number
  requiredStreak: number
  perfectRounds?: number
  requiredPerfectRounds?: number
  completionMode?: 'consecutive_perfect' | 'cumulative_perfect'
  reviewParts?: Array<{ position: number; title: string }>
  evaluationCompleted: boolean
}

// La mecánica es común a todos los tests; sólo cambian las cifras, que salen
// del propio intento. Ningún número está escrito a mano.
function getEvaluationInstructions(attempt: Attempt | null) {
  if (!attempt) return 'Lee atentamente cada pregunta antes de responder.'

  return quizIntroCopy({
    questionCount: attempt.questions.length,
    requiredPerfectRounds:
      attempt.requiredPerfectRounds ?? attempt.requiredStreak,
    completionMode: attempt.completionMode ?? 'cumulative_perfect',
  })
}

function EvaluationPage() {
  const { enrollmentId, quizId } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => (
        <Evaluation
          user={user}
          enrollmentId={enrollmentId}
          quizId={quizId}
        />
      )}
    </ProtectedGate>
  )
}

function Evaluation({
  user,
  enrollmentId,
  quizId,
}: {
  user: SessionUser
  enrollmentId: string
  quizId: string
}) {
  const [attempt, setAttempt] = useState<Attempt | null>(null)
  const [answers, setAnswers] = useState<Record<string, string[]>>({})
  const [result, setResult] = useState<AttemptResult | null>(null)
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')

  useLearningActivityHeartbeat(enrollmentId, Boolean(attempt && !result))

  const loadAttempt = useCallback(async () => {
    setLoading(true)
    setError('')
    setResult(null)
    setAnswers({})
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return

    const { data, error: startError } = await supabase.rpc(
      'start_quiz_attempt',
      {
        p_quiz_id: quizId,
        p_enrollment_id: enrollmentId,
      },
    )
    if (startError || !data) {
      setError(
        'La evaluación no está disponible o todavía debes completar la lección.',
      )
    } else {
      setAttempt(data as Attempt)
    }
    setLoading(false)
  }, [enrollmentId, quizId])

  useEffect(() => {
    void loadAttempt()
  }, [loadAttempt])

  function updateAnswer(
    question: AttemptQuestion,
    optionId: string,
    checked: boolean,
  ) {
    setAnswers((current) => {
      if (question.type === 'single_choice') {
        return { ...current, [question.id]: [optionId] }
      }
      const existing = current[question.id] ?? []
      return {
        ...current,
        [question.id]: checked
          ? [...new Set([...existing, optionId])]
          : existing.filter((id) => id !== optionId),
      }
    })
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!attempt) return
    const unanswered = attempt.questions.some(
      (question) => !(answers[question.id]?.length),
    )
    if (unanswered) {
      setError('Responde todas las preguntas antes de enviar el intento.')
      return
    }

    setSubmitting(true)
    setError('')
    const { data, error: submitError } =
      (await getSupabaseBrowserClient()?.rpc('submit_quiz_attempt', {
        p_attempt_id: attempt.attemptId,
        p_answers: attempt.questions.map((question) => ({
          question_id: question.id,
          selected_option_ids: answers[question.id] ?? [],
        })),
      })) ?? {}
    setSubmitting(false)

    if (submitError || !data) {
      setError('No se ha podido corregir el intento. Inténtalo de nuevo.')
      return
    }
    const attemptResult = data as AttemptResult
    setResult(attemptResult)
    if (attemptResult.evaluationCompleted) {
      void requestInternalCompletion(enrollmentId)
    }
  }

  return (
    <AppShell user={user} title="Evaluación">
      <div className="dashboard-heading">
        <div>
          <span className="label-industrial">{QUIZ_INTRO_TITLE}</span>
          <h1>{attempt?.title || 'Comprueba tus conocimientos'}</h1>
          <p>{getEvaluationInstructions(attempt)}</p>
        </div>
        <Link
          className="button button--outline"
          to="/campus/$enrollmentId"
          params={{ enrollmentId }}
        >
          Volver al curso
        </Link>
      </div>

      {error ? <div className="alert alert--error">{error}</div> : null}
      {loading ? (
        <section className="panel" style={{ marginTop: 18 }}>
          <p className="muted">Preparando preguntas…</p>
        </section>
      ) : result ? (
        <section className="panel" style={{ maxWidth: 760, marginTop: 18 }}>
          <div
            className={result.isPerfect ? 'alert alert--success' : 'alert alert--error'}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              {result.isPerfect ? <CheckCircle2 /> : <XCircle />}
              <strong>
                {result.isPerfect
                  ? 'Intento perfecto'
                  : result.completionMode === 'consecutive_perfect'
                    ? 'La racha vuelve a cero'
                    : 'Repasa las partes indicadas y vuelve a intentarlo'}
              </strong>
            </div>
          </div>
          <div className="stats-grid" style={{ marginTop: 24 }}>
            <article className="stat-card">
              <span className="stat-card__label">Resultado</span>
              <span className="stat-card__value">{result.scorePercent}%</span>
            </article>
            <article className="stat-card">
              <span className="stat-card__label">
                {quizRoundsLabel(result.completionMode ?? 'cumulative_perfect')}
              </span>
              <span className="stat-card__value">
                {result.completionMode === 'consecutive_perfect'
                  ? result.perfectStreak
                  : (result.perfectRounds ?? result.perfectStreak)}
                /{result.requiredPerfectRounds ?? result.requiredStreak}
              </span>
            </article>
          </div>
          {!result.isPerfect && result.reviewParts?.length ? (
            <div className="evaluation-review">
              <h2>Partes que conviene repasar</h2>
              <ul>
                {/* El bloque lo define el curso, no el código: aquí sólo se
                    identifica la parte por su número dentro de la lección. */}
                {result.reviewParts.map((part) => (
                  <li key={part.position}>
                    <strong>Parte {part.position}</strong> · {part.title}
                  </li>
                ))}
              </ul>
              <p className="muted">
                Por seguridad académica no mostramos la respuesta correcta.
                {result.completionMode === 'consecutive_perfect'
                  ? 'Necesitas iniciar una nueva racha perfecta.'
                  : 'Tus rondas perfectas anteriores se conservan.'}
              </p>
            </div>
          ) : null}
          {result.evaluationCompleted ? (
            <Link
              className="button button--primary"
              to="/campus/$enrollmentId"
              params={{ enrollmentId }}
            >
              <ShieldCheck size={18} /> Continuar formación
            </Link>
          ) : (
            <button
              className="button button--primary"
              onClick={() => void loadAttempt()}
              type="button"
            >
              <RotateCcw size={18} /> Realizar otro intento
            </button>
          )}
        </section>
      ) : attempt ? (
        <form className="form-grid" style={{ marginTop: 18 }} onSubmit={submit}>
          <div className="alert alert--info">
            Ronda {attempt.attemptNumber} ·{' '}
            {attempt.completionMode === 'consecutive_perfect'
              ? 'Racha perfecta'
              : 'Rondas perfectas'}:{' '}
            {attempt.completionMode === 'consecutive_perfect'
              ? attempt.currentStreak
              : (attempt.currentPerfectRounds ?? attempt.currentStreak)}
            /
            {attempt.requiredPerfectRounds ?? attempt.requiredStreak}
          </div>
          {attempt.questions.map((question, index) => (
            <fieldset className="quiz-question" key={question.id}>
              <span className="quiz-question__index label-industrial">
                Pregunta {index + 1}/{attempt.questions.length}
              </span>
              <legend className="quiz-question__prompt">{question.prompt}</legend>
              <div className="quiz-options">
                {question.options.map((option) => {
                  const selected = answers[question.id]?.includes(option.id)
                  return (
                    <label
                      className={`quiz-option${selected ? ' quiz-option--selected' : ''}`}
                      key={option.id}
                    >
                      <input
                        type={
                          question.type === 'single_choice' ? 'radio' : 'checkbox'
                        }
                        name={`question-${question.id}`}
                        checked={Boolean(selected)}
                        onChange={(event) =>
                          updateAnswer(question, option.id, event.target.checked)
                        }
                      />
                      <span>{option.text}</span>
                    </label>
                  )
                })}
              </div>
            </fieldset>
          ))}
          <button
            className="button button--primary"
            disabled={submitting}
            type="submit"
          >
            {submitting ? 'Corrigiendo…' : 'Enviar respuestas'}
          </button>
        </form>
      ) : null}
    </AppShell>
  )
}
