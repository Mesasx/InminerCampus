import { createFileRoute, Link } from '@tanstack/react-router'
import { FileDown, ShieldCheck } from 'lucide-react'
import { useEffect, useState } from 'react'
import {
  AudioLessonPlayer,
  type LessonAudioSegment,
} from '../components/AudioLessonPlayer'
import { SlideDeckViewer, type DeckChapter } from '../components/SlideDeckViewer'
import { AppShell } from '../components/AppShell'
import { ProtectedGate } from '../components/ProtectedGate'
import { relationArray, type Relation } from '../lib/course-content'
import { resolveSignedUrls } from '../lib/signed-url-cache'
import { getSupabaseBrowserClient } from '../lib/supabase'
import type { SessionUser } from '../lib/types'

export const Route = createFileRoute(
  '/campus/$enrollmentId/leccion/$lessonId',
)({
  component: LessonPage,
})

type Resource = {
  id: string
  kind: string
  title: string
  storage_path: string | null
  external_url: string | null
  downloadable: boolean
  resolvedUrl: string
}

type ContentMode = 'audio' | 'slides'

type LessonData = {
  id: string
  title: string
  summary: string
  blockPosition: number
  courseTitle: string
  regulationLabel: string
  contentMode: ContentMode
  resources: Resource[]
  quiz: {
    id: string
    questionCount: number
    requiredPerfectRounds: number
    completionMode: 'consecutive_perfect' | 'cumulative_perfect'
  } | null
}

type QuizRow = {
  id: string
  question_count: number
  required_perfect_streak: number
  completion_mode: 'consecutive_perfect' | 'cumulative_perfect'
  active: boolean
}

type LessonRow = {
  id: string
  title: string
  content_mode: ContentMode | null
  course_modules: Relation<{
    position: number
    title: string
    course_versions: Relation<{
      duration_hours: number
      courses: Relation<{
        title: string
        slug: string
      }>
    }>
  }>
  lesson_resources: Relation<Resource>
  quizzes: Relation<QuizRow>
}

function LessonPage() {
  const { enrollmentId, lessonId } = Route.useParams()
  return (
    <ProtectedGate>
      {(user) => (
        <Lesson
          user={user}
          enrollmentId={enrollmentId}
          lessonId={lessonId}
        />
      )}
    </ProtectedGate>
  )
}

function Lesson({
  user,
  enrollmentId,
  lessonId,
}: {
  user: SessionUser
  enrollmentId: string
  lessonId: string
}) {
  const [lesson, setLesson] = useState<LessonData | null>(null)
  const [segments, setSegments] = useState<LessonAudioSegment[]>([])
  const [chapters, setChapters] = useState<DeckChapter[]>([])
  const [contentCompleted, setContentCompleted] = useState(false)
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(false)
  const isAdministrator = user.roles.some((role) =>
    ['administrador', 'superadministrador'].includes(role),
  )

  useEffect(() => {
    let active = true

    async function load() {
      setLoading(true)
      setLoadError(false)
      setLesson(null)
      setSegments([])
      setChapters([])

      const supabase = getSupabaseBrowserClient()
      if (!supabase) {
        if (active) {
          setLoadError(true)
          setLoading(false)
        }
        return
      }

      try {
        const [lessonResponse, progressResponse, segmentResponse] =
          await Promise.all([
            supabase
              .from('lessons')
              .select(
                'id, title, content_mode, course_modules(position, title, course_versions(duration_hours, courses(title, slug))), lesson_resources(id, kind, title, storage_path, external_url, downloadable), quizzes(id, question_count, required_perfect_streak, completion_mode, active)',
              )
              .eq('id', lessonId)
              .maybeSingle(),
            supabase
              .from('lesson_progress')
              .select('status')
              .eq('enrollment_id', enrollmentId)
              .eq('lesson_id', lessonId)
              .maybeSingle(),
            supabase
              .from('lesson_audio_segments')
              .select(
                'id, position, title, narration_text, audio_storage_path, audio_external_url, duration_seconds, lesson_segment_slides(id, position, title, body, image_storage_path, image_external_url, source_label, source_page, alt_text), lesson_segment_notes(summary, key_points, stop_criterion, source_label, source_pages), lesson_audio_progress(max_position_seconds, completed_at)',
              )
              .eq('lesson_id', lessonId)
              .eq('lesson_audio_progress.enrollment_id', enrollmentId)
              .eq('published', true)
              .order('position', { ascending: true }),
          ])

        const requestError =
          lessonResponse.error || progressResponse.error || segmentResponse.error
        if (requestError) throw requestError
        if (!active) return

        const progress = progressResponse.data
        if (
          lessonResponse.data &&
          (isAdministrator || (progress && progress.status !== 'locked'))
        ) {
          const row = lessonResponse.data as unknown as LessonRow
          const contentMode: ContentMode = row.content_mode ?? 'audio'
          const courseModule = relationArray(row.course_modules)[0]
          const courseVersion = relationArray(courseModule?.course_versions)[0]
          const course = relationArray(courseVersion?.courses)[0]
          const quizzes = relationArray(row.quizzes).filter(
            (quiz) => quiz.active,
          )
          const resources = relationArray(row.lesson_resources)
          const segmentRows = (segmentResponse.data ??
            []) as unknown as SegmentRow[]

          // Una única llamada por lotes para todo lo que necesita esta
          // lección (audios, diapositivas y recursos descargables), en vez
          // de una llamada createSignedUrl por elemento.
          const storagePaths = [
            ...segmentRows.map((segment) => segment.audio_storage_path),
            ...segmentRows.flatMap((segment) =>
              relationArray(segment.lesson_segment_slides).map(
                (slide) => slide.image_storage_path,
              ),
            ),
            ...resources.map((resource) => resource.storage_path),
          ]
          const signedUrls = await resolveSignedUrls(
            supabase,
            'course-materials',
            storagePaths,
          )
          if (!active) return

          const resolvedResources = resolveResources(resources, signedUrls)
          const resolved = resolveSegments(segmentRows, signedUrls)

          const quiz = quizzes[0]
          const baseLesson = {
            id: row.id,
            title: row.title,
            blockPosition: courseModule?.position ?? 1,
            courseTitle: course?.title ?? 'Curso Inmíner',
            regulationLabel: getRegulationLabel(course?.slug ?? ''),
            contentMode,
            resources: resolvedResources,
            quiz: quiz
              ? {
                  id: quiz.id,
                  questionCount: quiz.question_count,
                  requiredPerfectRounds: quiz.required_perfect_streak,
                  completionMode: quiz.completion_mode,
                }
              : null,
          }

          if (contentMode === 'slides') {
            const deckChapters: DeckChapter[] = resolved
              .filter((segment) => segment.slides.length > 0)
              .map((segment) => ({
                id: segment.id,
                position: segment.position,
                title: segment.title,
                description: segment.narrationText,
                completed: segment.completed,
                slidesViewed: segment.maxPositionSeconds,
                slides: segment.slides.map((slide) => ({
                  id: slide.id,
                  position: slide.position,
                  title: slide.title,
                  body: slide.body,
                  imageUrl: slide.imageUrl,
                  altText: slide.altText,
                })),
              }))
            if (!deckChapters.length) return

            const totalSlides = deckChapters.reduce(
              (count, item) => count + item.slides.length,
              0,
            )
            setLesson({
              ...baseLesson,
              summary: `Presentación de ${totalSlides} diapositivas en ${deckChapters.length} capítulos.`,
            })
            setChapters(deckChapters)
            setContentCompleted(
              deckChapters.every((item) => item.completed),
            )
            return
          }

          const playableSegments = resolved.filter((segment) =>
            Boolean(segment.audioUrl),
          )
          if (!playableSegments.length) return

          setLesson({
            ...baseLesson,
            summary: `Contenido disponible en ${playableSegments.length} partes de audio.`,
          })
          setSegments(playableSegments)
          setContentCompleted(
            playableSegments.every((segment) => segment.completed),
          )
        }
      } catch (error) {
        console.error('[campus:lesson] No se pudo cargar el bloque', {
          enrollmentId,
          lessonId,
          error,
        })
        if (active) setLoadError(true)
      } finally {
        if (active) setLoading(false)
      }
    }

    void load()
    return () => {
      active = false
    }
  }, [enrollmentId, isAdministrator, lessonId])

  const pdfResource = lesson?.resources.find(
    (resource) => resource.kind === 'pdf' || resource.kind === 'presentation',
  )
  const isSlideLesson = lesson?.contentMode === 'slides'

  return (
    <AppShell user={user} title={lesson?.title || 'Lección'}>
      <div className="dashboard-heading">
        <div>
          <span className="eyebrow">Bloque</span>
          <h1>{lesson?.title || 'Contenido'}</h1>
          <p>{lesson?.summary}</p>
        </div>
        <Link
          className="button button--outline"
          to="/campus/$enrollmentId"
          params={{ enrollmentId }}
        >
          Volver al curso
        </Link>
      </div>
      {loading ? (
        <section className="panel">
          <p className="muted">Cargando la lección…</p>
        </section>
      ) : loadError ? (
        <section className="empty-state">
          <div>
            <h2>No hemos podido cargar este bloque</h2>
            <p>Vuelve al curso e inténtalo de nuevo.</p>
            <Link
              className="button button--outline"
              to="/campus/$enrollmentId"
              params={{ enrollmentId }}
            >
              Volver al curso
            </Link>
          </div>
        </section>
      ) : lesson ? (
        <div className="form-grid">
          {isSlideLesson ? (
            <SlideDeckViewer
              chapters={chapters}
              enrollmentId={enrollmentId}
              onDeckCompleted={() => setContentCompleted(true)}
              previewMode={isAdministrator}
            />
          ) : (
            <AudioLessonPlayer
              blockPosition={lesson.blockPosition}
              courseTitle={lesson.courseTitle}
              enrollmentId={enrollmentId}
              initialSegments={segments}
              onLessonProgress={() => setContentCompleted(true)}
              pdfResource={
                pdfResource
                  ? {
                      title: pdfResource.title,
                      storagePath: pdfResource.storage_path,
                      resolvedUrl: pdfResource.resolvedUrl,
                    }
                  : null
              }
              previewMode={isAdministrator}
              regulationLabel={lesson.regulationLabel}
            />
          )}
          {lesson.resources.length ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Contenido para utilizar</h2>
              </div>
              <p className="muted">
                Documentación de partida de la formación. Puedes descargarla y
                consultarla siempre que la necesites.
              </p>
              <div className="app-course-list">
                {lesson.resources.map((resource) => (
                  <article className="app-course" key={resource.id}>
                    <span className="app-course__number">
                      <FileDown size={20} />
                    </span>
                    <div>
                      <h3>{resource.title}</h3>
                      <p>{resource.kind}</p>
                    </div>
                    <span className="status">
                      {resource.downloadable ? 'Descargable' : 'Consulta'}
                    </span>
                    {resource.resolvedUrl ? (
                      <a
                        className="button button--outline"
                        download={resource.downloadable ? '' : undefined}
                        href={resource.resolvedUrl}
                        target="_blank"
                        rel="noreferrer"
                      >
                        {resource.downloadable ? 'Descargar' : 'Abrir'}
                      </a>
                    ) : (
                      <button className="button button--outline" disabled>
                        Protegido
                      </button>
                    )}
                  </article>
                ))}
              </div>
            </section>
          ) : null}
          {lesson.quiz && contentCompleted ? (
            <section className="panel">
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Evaluación</span>
                  <h2>Demuestra lo aprendido</h2>
                </div>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                {lesson.quiz.questionCount === 15
                  ? 'Este test consta de 15 preguntas, cada una con cuatro opciones de respuesta y una única respuesta correcta. Para superarlo debes acertar las 15 preguntas. El siguiente bloque se desbloqueará cuando hayas completado tres intentos perfectos; no es necesario que sean consecutivos.'
                  : `Esta evaluación consta de ${lesson.quiz.questionCount} preguntas. Debes acertarlas todas y completar ${lesson.quiz.requiredPerfectRounds} intentos perfectos${
                      lesson.quiz.completionMode === 'cumulative_perfect'
                        ? '; no es necesario que sean consecutivos.'
                        : ' consecutivos.'
                    }`}
              </p>
              <Link
                className="button button--primary"
                to="/evaluacion/$enrollmentId/$quizId"
                params={{ enrollmentId, quizId: lesson.quiz.id }}
              >
                Abrir evaluación
              </Link>
            </section>
          ) : lesson.quiz ? (
            <section className="panel">
              <div className="panel__header">
                <h2>Evaluación bloqueada</h2>
                <ShieldCheck color="var(--orange)" size={28} />
              </div>
              <p className="muted">
                {isSlideLesson
                  ? 'Recorre todos los capítulos de la presentación para abrir la evaluación.'
                  : 'Completa las partes de audio en orden para abrir la evaluación.'}
              </p>
            </section>
          ) : null}
        </div>
      ) : (
        <section className="empty-state">
          <p>Esta lección está bloqueada o no forma parte de tu matrícula.</p>
        </section>
      )}
    </AppShell>
  )
}

function getRegulationLabel(courseSlug: string) {
  if (courseSlug.includes('polvo') || courseSlug.includes('silice')) {
    return 'ITC 02.0.02 · Orden TED/723/2021'
  }
  if (courseSlug.includes('transporte') || courseSlug.includes('volquete')) {
    return 'ITC 02.1.02 · ET 2000-1-08'
  }
  if (courseSlug.includes('arranque') || courseSlug.includes('carga')) {
    return 'ITC 02.1.02 · ET 2001-1-08'
  }
  return 'Formación preventiva minera'
}

type SegmentRow = {
  id: string
  position: number
  title: string
  narration_text: string
  audio_storage_path: string | null
  audio_external_url: string | null
  duration_seconds: number
  lesson_segment_slides: Relation<{
    id: string
    position: number
    title: string
    body: string
    image_storage_path: string | null
    image_external_url: string | null
    source_label: string | null
    source_page: string | null
    alt_text: string | null
  }>
  lesson_segment_notes: Relation<{
    summary: string
    key_points: string[]
    stop_criterion: string
    source_label: string
    source_pages: string
  }>
  lesson_audio_progress: Relation<{
    max_position_seconds: number
    completed_at: string | null
  }>
}

function resolveSegments(
  segmentRows: SegmentRow[],
  signedUrls: Record<string, string>,
): LessonAudioSegment[] {
  return segmentRows.map((segment) => {
    const audioUrl = segment.audio_storage_path
      ? (signedUrls[segment.audio_storage_path] ?? '')
      : (segment.audio_external_url ?? '')
    const slides = relationArray(segment.lesson_segment_slides)
      .sort((a, b) => a.position - b.position)
      .map((slide) => {
        const imageUrl = slide.image_storage_path
          ? (signedUrls[slide.image_storage_path] ?? null)
          : slide.image_external_url
        return {
          id: slide.id,
          position: slide.position,
          title: slide.title,
          body: slide.body,
          imageUrl,
          imageStoragePath: slide.image_storage_path,
          sourceLabel: slide.source_label,
          sourcePage: slide.source_page,
          altText: slide.alt_text ?? slide.title,
        }
      })
    const segmentProgress = relationArray(segment.lesson_audio_progress)[0]
    const note = relationArray(segment.lesson_segment_notes)[0]
    return {
      id: segment.id,
      position: segment.position,
      title: segment.title,
      narrationText: segment.narration_text,
      audioUrl,
      audioStoragePath: segment.audio_storage_path,
      durationSeconds: segment.duration_seconds,
      maxPositionSeconds: segmentProgress?.max_position_seconds ?? 0,
      completed: Boolean(segmentProgress?.completed_at),
      note: note
        ? {
            summary: note.summary,
            keyPoints: note.key_points,
            stopCriterion: note.stop_criterion,
            sourceLabel: note.source_label,
            sourcePages: note.source_pages,
          }
        : null,
      slides,
    }
  })
}

function resolveResources(
  resources: Resource[],
  signedUrls: Record<string, string>,
): Resource[] {
  return resources.map((resource) => {
    if (resource.external_url) {
      return { ...resource, resolvedUrl: resource.external_url }
    }
    if (!resource.storage_path) return { ...resource, resolvedUrl: '' }
    return {
      ...resource,
      resolvedUrl: signedUrls[resource.storage_path] ?? '',
    }
  })
}
