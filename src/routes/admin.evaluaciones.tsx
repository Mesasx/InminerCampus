import { createFileRoute } from '@tanstack/react-router'
import {
  CheckCircle2,
  ClipboardList,
  Plus,
  ShieldQuestion,
} from 'lucide-react'
import {
  useCallback,
  useEffect,
  useState,
  type FormEvent,
} from 'react'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute('/admin/evaluaciones')({
  component: AdminAssessmentsPage,
})

type Version = {
  id: string
  version_number: number
  courses: { title: string }
}

type Bank = {
  id: string
  course_version_id: string
  title: string
  questions: Array<{ id: string }>
}

type Lesson = {
  id: string
  title: string
  course_modules: { course_version_id: string; title: string }
}

type Quiz = {
  id: string
  title: string
  lesson_id: string
  question_count: number
  passing_percent: number
  active: boolean
}

function AdminAssessmentsPage() {
  return (
    <ProtectedGate roles={['administrador', 'superadministrador']}>
      {(user) => <AdminAssessments user={user} />}
    </ProtectedGate>
  )
}

function AdminAssessments({ user }: { user: SessionUser }) {
  const [versions, setVersions] = useState<Version[]>([])
  const [banks, setBanks] = useState<Bank[]>([])
  const [lessons, setLessons] = useState<Lesson[]>([])
  const [quizzes, setQuizzes] = useState<Quiz[]>([])
  const [versionId, setVersionId] = useState('')
  const [bankTitle, setBankTitle] = useState('')
  const [questionBankId, setQuestionBankId] = useState('')
  const [prompt, setPrompt] = useState('')
  const [explanation, setExplanation] = useState('')
  const [options, setOptions] = useState(['', '', '', ''])
  const [correctOption, setCorrectOption] = useState(0)
  const [quizLessonId, setQuizLessonId] = useState('')
  const [quizBankId, setQuizBankId] = useState('')
  const [quizTitle, setQuizTitle] = useState('')
  const [quizCount, setQuizCount] = useState(10)
  const [notice, setNotice] = useState('')

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [
      { data: versionRows },
      { data: bankRows },
      { data: lessonRows },
      { data: quizRows },
    ] = await Promise.all([
      supabase
        .from('course_versions')
        .select('id, version_number, courses(title)')
        .order('created_at', { ascending: false }),
      supabase
        .from('question_banks')
        .select('id, course_version_id, title, questions(id)')
        .order('created_at', { ascending: false }),
      supabase
        .from('lessons')
        .select('id, title, course_modules!inner(course_version_id, title)')
        .order('position', { ascending: true }),
      supabase
        .from('quizzes')
        .select(
          'id, title, lesson_id, question_count, passing_percent, active',
        )
        .order('created_at', { ascending: false }),
    ])
    const nextVersions = (versionRows ?? []) as unknown as Version[]
    const nextBanks = (bankRows ?? []) as unknown as Bank[]
    setVersions(nextVersions)
    setBanks(nextBanks)
    setLessons((lessonRows ?? []) as unknown as Lesson[])
    setQuizzes((quizRows ?? []) as Quiz[])
    setVersionId((current) => current || nextVersions[0]?.id || '')
    setQuestionBankId((current) => current || nextBanks[0]?.id || '')
    setQuizBankId((current) => current || nextBanks[0]?.id || '')
  }, [])

  useEffect(() => {
    void load()
  }, [load])

  const selectedVersionBanks = banks.filter(
    (bank) => bank.course_version_id === versionId,
  )
  const selectedVersionLessons = lessons.filter(
    (lesson) => lesson.course_modules.course_version_id === versionId,
  )

  async function createBank(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const { data, error } =
      (await getSupabaseBrowserClient()
        ?.from('question_banks')
        .insert({
          course_version_id: versionId,
          title: bankTitle.trim(),
          created_by: user.id,
        })
        .select('id')
        .single()) ?? {}
    setNotice(
      error ? 'No se ha podido crear el banco.' : 'Banco de preguntas creado.',
    )
    if (!error && data) {
      setBankTitle('')
      setQuestionBankId(data.id)
      setQuizBankId(data.id)
      await load()
    }
  }

  async function createQuestion(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const { data: question, error } = await supabase
      .from('questions')
      .insert({
        question_bank_id: questionBankId,
        prompt: prompt.trim(),
        type: 'single_choice',
        explanation: explanation.trim() || null,
        points: 1,
        active: true,
      })
      .select('id')
      .single()
    if (error || !question) {
      setNotice('No se ha podido crear la pregunta.')
      return
    }
    const { error: optionsError } = await supabase
      .from('question_options')
      .insert(
        options.map((option, index) => ({
          question_id: question.id,
          position: index + 1,
          option_text: option.trim(),
          is_correct: index === correctOption,
        })),
      )
    if (optionsError) {
      await supabase.from('questions').delete().eq('id', question.id)
      setNotice('No se han podido guardar las respuestas.')
      return
    }
    setPrompt('')
    setExplanation('')
    setOptions(['', '', '', ''])
    setCorrectOption(0)
    setNotice('Pregunta y respuestas guardadas.')
    await load()
  }

  async function createQuiz(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const bank = banks.find((item) => item.id === quizBankId)
    if (!bank || bank.questions.length < quizCount) {
      setNotice(
        `Este banco necesita al menos ${quizCount} preguntas activas.`,
      )
      return
    }
    const { error } =
      (await getSupabaseBrowserClient()?.from('quizzes').insert({
        lesson_id: quizLessonId,
        question_bank_id: quizBankId,
        title: quizTitle.trim(),
        question_count: quizCount,
        passing_percent: 100,
        required_perfect_streak: 3,
        completion_mode: 'cumulative_perfect',
        randomize_questions: true,
        randomize_options: true,
        minimum_retry_seconds: 0,
        active: true,
      })) ?? {}
    setNotice(
      error
        ? 'No se ha podido publicar la evaluación. Comprueba que la lección no tenga ya una.'
        : 'Evaluación publicada en la lección.',
    )
    if (!error) {
      setQuizTitle('')
      await load()
    }
  }

  return (
    <AppShell user={user} mode="admin" title="Evaluaciones">
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Control de aprendizaje</span>
          <h1>Evaluaciones.</h1>
          <p>Crea bancos, preguntas y pruebas vinculadas a cada lección.</p>
        </div>
      </div>
      {notice ? <div className="alert alert--info">{notice}</div> : null}

      <section className="panel">
        <div className="panel__header">
          <h2>Versión de trabajo</h2>
          <ShieldQuestion color="var(--orange)" />
        </div>
        <div className="field">
          <label htmlFor="assessment-version">Curso y versión</label>
          <select
            id="assessment-version"
            value={versionId}
            onChange={(event) => {
              const next = event.target.value
              setVersionId(next)
              const firstBank = banks.find(
                (bank) => bank.course_version_id === next,
              )
              setQuestionBankId(firstBank?.id ?? '')
              setQuizBankId(firstBank?.id ?? '')
              const firstLesson = lessons.find(
                (lesson) =>
                  lesson.course_modules.course_version_id === next,
              )
              setQuizLessonId(firstLesson?.id ?? '')
            }}
          >
            {versions.map((version) => (
              <option key={version.id} value={version.id}>
                {version.courses.title} · versión {version.version_number}
              </option>
            ))}
          </select>
        </div>
      </section>

      <div className="admin-three-column">
        <section className="panel">
          <div className="panel__header">
            <h2>1. Banco</h2>
            <Plus color="var(--orange)" />
          </div>
          <form className="form-grid" onSubmit={createBank}>
            <div className="field">
              <label htmlFor="bank-title">Nombre del banco</label>
              <input
                id="bank-title"
                minLength={2}
                required
                value={bankTitle}
                onChange={(event) => setBankTitle(event.target.value)}
                placeholder="Evaluación final"
              />
            </div>
            <button
              className="button button--primary"
              disabled={!versionId}
              type="submit"
            >
              Crear banco
            </button>
          </form>
          <div className="mini-list">
            {selectedVersionBanks.map((bank) => (
              <button
                className={questionBankId === bank.id ? 'is-active' : ''}
                key={bank.id}
                onClick={() => {
                  setQuestionBankId(bank.id)
                  setQuizBankId(bank.id)
                }}
                type="button"
              >
                <span>{bank.title}</span>
                <small>{bank.questions.length} preguntas</small>
              </button>
            ))}
          </div>
        </section>

        <section className="panel">
          <div className="panel__header">
            <h2>2. Pregunta</h2>
            <ClipboardList color="var(--orange)" />
          </div>
          <form className="form-grid" onSubmit={createQuestion}>
            <div className="field">
              <label htmlFor="question-bank">Banco</label>
              <select
                id="question-bank"
                required
                value={questionBankId}
                onChange={(event) => setQuestionBankId(event.target.value)}
              >
                <option value="">Selecciona un banco</option>
                {selectedVersionBanks.map((bank) => (
                  <option key={bank.id} value={bank.id}>
                    {bank.title}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="question-prompt">Enunciado</label>
              <textarea
                id="question-prompt"
                minLength={3}
                required
                value={prompt}
                onChange={(event) => setPrompt(event.target.value)}
              />
            </div>
            {options.map((option, index) => (
              <div className="answer-option" key={index}>
                <input
                  aria-label={`Marcar respuesta ${index + 1} como correcta`}
                  checked={correctOption === index}
                  name="correct-answer"
                  onChange={() => setCorrectOption(index)}
                  type="radio"
                />
                <input
                  aria-label={`Respuesta ${index + 1}`}
                  required
                  value={option}
                  onChange={(event) =>
                    setOptions((current) =>
                      current.map((item, itemIndex) =>
                        itemIndex === index ? event.target.value : item,
                      ),
                    )
                  }
                  placeholder={`Respuesta ${index + 1}`}
                />
              </div>
            ))}
            <div className="field">
              <label htmlFor="question-explanation">
                Explicación al corregir
              </label>
              <textarea
                id="question-explanation"
                value={explanation}
                onChange={(event) => setExplanation(event.target.value)}
              />
            </div>
            <button
              className="button button--primary"
              disabled={!questionBankId}
              type="submit"
            >
              Guardar pregunta
            </button>
          </form>
        </section>

        <section className="panel">
          <div className="panel__header">
            <h2>3. Publicar prueba</h2>
            <CheckCircle2 color="var(--orange)" />
          </div>
          <form className="form-grid" onSubmit={createQuiz}>
            <div className="field">
              <label htmlFor="quiz-title">Título</label>
              <input
                id="quiz-title"
                required
                value={quizTitle}
                onChange={(event) => setQuizTitle(event.target.value)}
                placeholder="Evaluación del módulo"
              />
            </div>
            <div className="field">
              <label htmlFor="quiz-lesson">Lección</label>
              <select
                id="quiz-lesson"
                required
                value={quizLessonId}
                onChange={(event) => setQuizLessonId(event.target.value)}
              >
                <option value="">Selecciona una lección</option>
                {selectedVersionLessons.map((lesson) => (
                  <option key={lesson.id} value={lesson.id}>
                    {lesson.course_modules.title} · {lesson.title}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="quiz-bank">Banco de preguntas</label>
              <select
                id="quiz-bank"
                required
                value={quizBankId}
                onChange={(event) => setQuizBankId(event.target.value)}
              >
                <option value="">Selecciona un banco</option>
                {selectedVersionBanks.map((bank) => (
                  <option key={bank.id} value={bank.id}>
                    {bank.title} ({bank.questions.length})
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="quiz-count">Preguntas por intento</label>
              <input
                id="quiz-count"
                max={100}
                min={1}
                type="number"
                value={quizCount}
                onChange={(event) =>
                  setQuizCount(Number(event.target.value) || 1)
                }
              />
            </div>
            <button className="button button--primary" type="submit">
              Publicar evaluación
            </button>
            <p className="muted">
              La prueba exigirá 100% de aciertos en 3 rondas perfectas
              acumulativas.
            </p>
          </form>
          <div className="mini-list">
            {quizzes
              .filter((quiz) =>
                selectedVersionLessons.some(
                  (lesson) => lesson.id === quiz.lesson_id,
                ),
              )
              .map((quiz) => (
                <div key={quiz.id}>
                  <span>{quiz.title}</span>
                  <small>
                    {quiz.question_count} preguntas · {quiz.passing_percent}%
                  </small>
                </div>
              ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
