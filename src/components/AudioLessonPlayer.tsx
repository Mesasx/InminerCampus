import {
  ChevronLeft,
  ChevronRight,
  ExternalLink,
  FileText,
  Maximize2,
  Pause,
  Play,
  RotateCcw,
  Volume2,
  X,
} from 'lucide-react'
import { useEffect, useMemo, useRef, useState } from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'

export type LessonSlide = {
  id: string
  position: number
  title: string
  body: string
  image_storage_path: string | null
  image_external_url: string | null
  source_label: string | null
  source_page: string | null
  alt_text: string | null
}

export type LessonNote = {
  summary: string
  key_points: string[]
  stop_criterion: string
  source_label: string
  source_pages: string
}

export type AudioSegment = {
  id: string
  position: number
  title: string
  narration_text: string
  audio_storage_path: string | null
  audio_external_url: string | null
  duration_seconds: number
  lesson_segment_slides: LessonSlide[]
  lesson_segment_notes: LessonNote[]
}

export type AudioProgress = {
  segment_id: string
  max_position_seconds: number
  completed_at: string | null
}

export type LessonAudioSegment = {
  id: string
  position: number
  title: string
  narrationText: string
  audioUrl: string
  audioStoragePath: string | null
  durationSeconds: number
  maxPositionSeconds: number
  completed: boolean
  note: {
    summary: string
    keyPoints: string[]
    stopCriterion: string
    sourceLabel: string
    sourcePages: string
  } | null
  slides: Array<{
    id: string
    position: number
    title: string
    body: string
    imageUrl: string | null
    imageStoragePath: string | null
    sourceLabel: string | null
    sourcePage: string | null
    altText: string
  }>
}

export type CoursePdfResource = {
  title: string
  storagePath: string | null
  resolvedUrl: string
}

type SegmentState = {
  max: number
  completed: boolean
}

function formatTime(seconds: number) {
  const safeSeconds = Math.max(0, Math.floor(seconds || 0))
  return `${Math.floor(safeSeconds / 60)}:${String(safeSeconds % 60).padStart(2, '0')}`
}

export function AudioLessonPlayer({
  enrollmentId,
  segments: sourceSegments,
  progress: sourceProgress,
  initialSegments,
  blockPosition = 1,
  pdfResource = null,
  onLessonProgress,
  previewMode = false,
}: {
  enrollmentId: string
  segments?: AudioSegment[]
  progress?: AudioProgress[]
  initialSegments?: LessonAudioSegment[]
  blockPosition?: number
  pdfResource?: CoursePdfResource | null
  onLessonProgress?: () => void
  previewMode?: boolean
}) {
  const segments = useMemo<AudioSegment[]>(
    () =>
      initialSegments
        ? initialSegments.map((segment) => ({
            id: segment.id,
            position: segment.position,
            title: segment.title,
            narration_text: segment.narrationText,
            audio_storage_path: segment.audioStoragePath,
            audio_external_url: segment.audioStoragePath ? null : segment.audioUrl,
            duration_seconds: segment.durationSeconds,
            lesson_segment_slides: segment.slides.map((slide) => ({
              id: slide.id,
              position: slide.position,
              title: slide.title,
              body: slide.body,
              image_storage_path: slide.imageStoragePath,
              image_external_url: slide.imageStoragePath ? null : slide.imageUrl,
              source_label: slide.sourceLabel,
              source_page: slide.sourcePage,
              alt_text: slide.altText,
            })),
            lesson_segment_notes: segment.note
              ? [
                  {
                    summary: segment.note.summary,
                    key_points: segment.note.keyPoints,
                    stop_criterion: segment.note.stopCriterion,
                    source_label: segment.note.sourceLabel,
                    source_pages: segment.note.sourcePages,
                  },
                ]
              : [],
          }))
        : sourceSegments ?? [],
    [initialSegments, sourceSegments],
  )
  const progress = useMemo<AudioProgress[]>(
    () =>
      initialSegments
        ? initialSegments.map((segment) => ({
            segment_id: segment.id,
            max_position_seconds: segment.maxPositionSeconds,
            completed_at: segment.completed ? new Date(0).toISOString() : null,
          }))
        : sourceProgress ?? [],
    [initialSegments, sourceProgress],
  )
  const audioRef = useRef<HTMLAudioElement | null>(null)
  const dialogRef = useRef<HTMLDivElement | null>(null)
  const lastReportedRef = useRef(0)
  const touchStartXRef = useRef<number | null>(null)
  const initialActiveIndex = segments.findIndex((segment) => {
    const row = progress.find((item) => item.segment_id === segment.id)
    return !row?.completed_at
  })
  const [activeIndex, setActiveIndex] = useState(
    initialActiveIndex === -1 ? Math.max(segments.length - 1, 0) : initialActiveIndex,
  )
  const [playing, setPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [notice, setNotice] = useState('')
  const [expandedSlideId, setExpandedSlideId] = useState<string | null>(null)
  const [pdfOpen, setPdfOpen] = useState(false)
  const [activeSlideIndex, setActiveSlideIndex] = useState(0)
  const [sources, setSources] = useState<Record<string, string>>(() =>
    Object.fromEntries(
      initialSegments?.map((segment) => [segment.id, segment.audioUrl]) ?? [],
    ),
  )
  const [slideSources, setSlideSources] = useState<Record<string, string>>(() =>
    Object.fromEntries(
      initialSegments?.flatMap((segment) =>
        segment.slides.map((slide) => [slide.id, slide.imageUrl ?? '']),
      ) ?? [],
    ),
  )
  const [pdfSource, setPdfSource] = useState(pdfResource?.resolvedUrl ?? '')
  const [segmentState, setSegmentState] = useState<Record<string, SegmentState>>(
    () =>
      Object.fromEntries(
        segments.map((segment) => {
          const row = progress.find((item) => item.segment_id === segment.id)
          return [
            segment.id,
            {
              max: row?.max_position_seconds ?? 0,
              completed: Boolean(row?.completed_at),
            },
          ]
        }),
      ),
  )

  const activeSegment = segments[activeIndex]
  const activeState = activeSegment
    ? segmentState[activeSegment.id] ?? { max: 0, completed: false }
    : { max: 0, completed: false }

  const firstIncompleteIndex = useMemo(() => {
    const index = segments.findIndex(
      (segment) => !segmentState[segment.id]?.completed,
    )
    return index === -1 ? Math.max(segments.length - 1, 0) : index
  }, [segmentState, segments])

  useEffect(() => {
    let cancelled = false
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const client = supabase

    async function refreshSignedSources() {
      const [audioEntries, imageEntries, resolvedPdf] = await Promise.all([
        Promise.all(
          segments.map(async (segment) => {
            if (segment.audio_external_url) {
              return [segment.id, segment.audio_external_url] as const
            }
            if (!segment.audio_storage_path) return [segment.id, ''] as const
            const { data } = await client.storage
              .from('course-materials')
              .createSignedUrl(segment.audio_storage_path, 3600)
            return [segment.id, data?.signedUrl ?? ''] as const
          }),
        ),
        Promise.all(
          segments.flatMap((segment) =>
            segment.lesson_segment_slides.map(async (slide) => {
              if (slide.image_external_url) {
                return [slide.id, slide.image_external_url] as const
              }
              if (!slide.image_storage_path) return [slide.id, ''] as const
              const { data } = await client.storage
                .from('course-materials')
                .createSignedUrl(slide.image_storage_path, 3600)
              return [slide.id, data?.signedUrl ?? ''] as const
            }),
          ),
        ),
        (async () => {
          if (!pdfResource) return ''
          if (!pdfResource.storagePath) return pdfResource.resolvedUrl
          const { data } = await client.storage
            .from('course-materials')
            .createSignedUrl(pdfResource.storagePath, 3600)
          return data?.signedUrl ?? ''
        })(),
      ])
      if (cancelled) return
      setSources((current) => ({
        ...current,
        ...Object.fromEntries(audioEntries.filter(([, value]) => Boolean(value))),
      }))
      setSlideSources((current) => ({
        ...current,
        ...Object.fromEntries(imageEntries.filter(([, value]) => Boolean(value))),
      }))
      if (resolvedPdf) setPdfSource(resolvedPdf)
    }

    void refreshSignedSources()
    const refreshTimer = window.setInterval(refreshSignedSources, 45 * 60 * 1000)

    return () => {
      cancelled = true
      window.clearInterval(refreshTimer)
    }
  }, [pdfResource, segments])

  useEffect(() => {
    const audio = audioRef.current
    if (!audio) return
    audio.pause()
    audio.currentTime = 0
    lastReportedRef.current = 0
    setCurrentTime(0)
    setPlaying(false)
    setExpandedSlideId(null)
    setActiveSlideIndex(0)
  }, [activeSegment?.id])

  useEffect(() => {
    const dialogOpen = Boolean(expandedSlideId || pdfOpen)
    if (!dialogOpen) return
    const dialog = dialogRef.current
    const previousFocus = document.activeElement as HTMLElement | null
    const focusable = dialog?.querySelectorAll<HTMLElement>(
      'button:not(:disabled), a[href], iframe, [tabindex]:not([tabindex="-1"])',
    )
    focusable?.[0]?.focus()

    function handleDialogKey(event: KeyboardEvent) {
      if (event.key === 'Escape') {
        setExpandedSlideId(null)
        setPdfOpen(false)
        return
      }
      if (event.key !== 'Tab' || !focusable?.length) return
      const first = focusable[0]
      const last = focusable[focusable.length - 1]
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault()
        last.focus()
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault()
        first.focus()
      }
    }

    document.addEventListener('keydown', handleDialogKey)
    return () => {
      document.removeEventListener('keydown', handleDialogKey)
      previousFocus?.focus()
    }
  }, [expandedSlideId, pdfOpen])

  async function reportProgress(position: number, completed = false) {
    if (!activeSegment || previewMode) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const { data, error } = await supabase.rpc('record_audio_segment_progress', {
      p_enrollment_id: enrollmentId,
      p_segment_id: activeSegment.id,
      p_position_seconds: Math.floor(position),
      p_completed: completed,
    })

    if (error) {
      setNotice(
        error.message.includes('Forward seeking')
          ? 'Para avanzar, escucha primero el contenido anterior.'
          : 'No se ha podido guardar el avance. Vuelve a intentarlo.',
      )
      return
    }

    const result = data as {
      maxPositionSeconds?: number
      completed?: boolean
      lessonAudioCompleted?: boolean
    }
    setNotice('')
    setSegmentState((current) => ({
      ...current,
      [activeSegment.id]: {
        max: result.maxPositionSeconds ?? Math.floor(position),
        completed: Boolean(result.completed),
      },
    }))
    if (result.lessonAudioCompleted) onLessonProgress?.()
  }

  function selectSegment(index: number) {
    const candidate = segments[index]
    if (!candidate) return
    const allowed =
      previewMode ||
      index <= firstIncompleteIndex ||
      segmentState[candidate.id]?.completed
    if (!allowed) {
      setNotice('Completa el audio anterior antes de abrir esta parte.')
      return
    }
    setNotice('')
    setActiveIndex(index)
  }

  async function togglePlayback() {
    const audio = audioRef.current
    if (!audio) return
    if (audio.paused) {
      await audio.play()
    } else {
      audio.pause()
    }
  }

  function handleSeek(nextValue: number) {
    const audio = audioRef.current
    if (!audio || !activeSegment) return
    const maxAllowed = activeState.completed
      ? activeSegment.duration_seconds
      : activeState.max + 1
    if (nextValue > maxAllowed) {
      setNotice('No puedes adelantar una parte que todavía no has escuchado.')
      audio.currentTime = Math.min(activeState.max, audio.duration || activeState.max)
      return
    }
    setNotice('')
    audio.currentTime = nextValue
    setCurrentTime(nextValue)
  }

  function selectSlide(index: number) {
    if (!activeSegment) return
    const lastIndex = activeSegment.lesson_segment_slides.length - 1
    setActiveSlideIndex(Math.min(Math.max(index, 0), lastIndex))
  }

  function handleSlideTouchEnd(clientX: number) {
    const startX = touchStartXRef.current
    touchStartXRef.current = null
    if (startX === null || Math.abs(clientX - startX) < 40) return
    selectSlide(activeSlideIndex + (clientX < startX ? 1 : -1))
  }

  useEffect(() => {
    function handleSlideKeys(event: KeyboardEvent) {
      if (expandedSlideId || pdfOpen) return
      const target = event.target as HTMLElement | null
      if (target?.matches('input, textarea, select, button, a')) return
      if (event.key === 'ArrowLeft') selectSlide(activeSlideIndex - 1)
      if (event.key === 'ArrowRight') selectSlide(activeSlideIndex + 1)
    }
    document.addEventListener('keydown', handleSlideKeys)
    return () => document.removeEventListener('keydown', handleSlideKeys)
  }, [activeSlideIndex, expandedSlideId, pdfOpen])

  if (!segments.length) {
    return (
      <section className="panel audio-lesson audio-lesson--empty">
        <Volume2 size={34} color="var(--orange)" />
        <div>
          <h2>Contenido de audio en preparación</h2>
          <p className="muted">
            El temario y las diapositivas ya se están preparando. Las partes se
            abrirán cuando el administrador incorpore las grabaciones.
          </p>
        </div>
      </section>
    )
  }

  const completedParts = segments.filter(
    (segment) => segmentState[segment.id]?.completed,
  ).length
  const overallPercent = Math.round((completedParts / segments.length) * 100)
  const activeNote = activeSegment.lesson_segment_notes?.[0]
  const activeSlide = activeSegment.lesson_segment_slides[activeSlideIndex]
  const expandedSlide = activeSegment.lesson_segment_slides.find(
    (slide) => slide.id === expandedSlideId,
  )
  const pdfPage = activeNote?.source_pages.match(/\d+/)?.[0]
  const pdfLabel = pdfPage
    ? `Ver PDF · página ${pdfPage}`
    : 'Ver PDF · consulta general'
  const pdfViewerUrl = pdfSource
    ? `${pdfSource}${pdfPage ? `#page=${pdfPage}` : ''}`
    : ''

  return (
    <section className="audio-lesson" aria-label="Lección en audio">
      <header className="panel explanation-switcher">
        <button
          aria-label="Explicación anterior"
          className="explanation-switcher__arrow"
          disabled={activeIndex === 0}
          onClick={() => selectSegment(activeIndex - 1)}
          type="button"
        >
          <ChevronLeft size={20} />
          <span>Anterior</span>
        </button>
        <div className="explanation-switcher__content">
          <div className="explanation-switcher__meta">
            <span className="eyebrow">Bloque {blockPosition}</span>
            <span>{completedParts} de {segments.length} escuchadas</span>
          </div>
          <label className="explanation-switcher__select">
            <span>Explicación {activeIndex + 1} de {segments.length}</span>
            <select
              aria-label="Cambiar explicación"
              onChange={(event) => selectSegment(Number(event.target.value))}
              value={activeIndex}
            >
              {segments.map((segment, index) => {
                const completed = segmentState[segment.id]?.completed
                const locked =
                  !previewMode &&
                  index > firstIncompleteIndex &&
                  !completed
                return (
                  <option disabled={locked} key={segment.id} value={index}>
                    {blockPosition}.{index + 1} · {segment.title}
                    {completed ? ' · escuchada' : ''}
                  </option>
                )
              })}
            </select>
          </label>
          <div
            aria-label={`${overallPercent}% completado`}
            aria-valuemax={100}
            aria-valuemin={0}
            aria-valuenow={overallPercent}
            className="audio-lesson__progress-track"
            role="progressbar"
          >
            <span style={{ width: `${overallPercent}%` }} />
          </div>
        </div>
        <button
          aria-label="Explicación siguiente"
          className="explanation-switcher__arrow"
          disabled={
            activeIndex >= segments.length - 1 ||
            (!previewMode && !activeState.completed)
          }
          onClick={() => selectSegment(activeIndex + 1)}
          type="button"
        >
          <span>Siguiente</span>
          <ChevronRight size={20} />
        </button>
      </header>

      <section className="lesson-slides" aria-label="Diapositivas del apartado">
        <div className="lesson-slides__heading">
          <div>
            <span className="eyebrow">Apoyo visual</span>
            <h2>{activeSlide?.title ?? 'Diapositiva'}</h2>
          </div>
          <span className="lesson-slides__counter">
            {activeSlideIndex + 1} de {activeSegment.lesson_segment_slides.length}
          </span>
        </div>
        {activeSlide ? (
          <article
            className="lesson-slide lesson-slide--stage"
            onTouchEnd={(event) => handleSlideTouchEnd(event.changedTouches[0].clientX)}
            onTouchStart={(event) => {
              touchStartXRef.current = event.changedTouches[0].clientX
            }}
          >
            <div className="lesson-slide__canvas">
              {slideSources[activeSlide.id] ? (
                <img
                  src={slideSources[activeSlide.id]}
                  alt={activeSlide.alt_text ?? activeSlide.title}
                />
              ) : (
                <div className="lesson-slide__missing">Diapositiva no disponible</div>
              )}
            </div>
            <div className="lesson-slide__toolbar">
              <button
                aria-label="Diapositiva anterior"
                className="icon-button"
                disabled={activeSlideIndex === 0}
                onClick={() => selectSlide(activeSlideIndex - 1)}
                type="button"
              >
                <ChevronLeft size={20} />
              </button>
              <span>{activeSlideIndex + 1} de {activeSegment.lesson_segment_slides.length}</span>
              <button
                aria-label="Diapositiva siguiente"
                className="icon-button"
                disabled={
                  activeSlideIndex >= activeSegment.lesson_segment_slides.length - 1
                }
                onClick={() => selectSlide(activeSlideIndex + 1)}
                type="button"
              >
                <ChevronRight size={20} />
              </button>
              <button
                aria-label={`Ver ${activeSlide.title} a pantalla completa`}
                className="icon-button lesson-slide__fullscreen"
                onClick={() => setExpandedSlideId(activeSlide.id)}
                type="button"
              >
                <Maximize2 size={19} />
              </button>
            </div>
          </article>
        ) : null}
      </section>

      <article className="panel audio-player">
        <div className="audio-player__heading">
          <div className="audio-player__label">
            <Volume2 aria-hidden="true" size={18} />
            <div>
              <span className="eyebrow">Audio explicativo</span>
              <strong>Parte {blockPosition}.{activeIndex + 1}</strong>
            </div>
          </div>
          <span className="status">
            {previewMode
              ? sources[activeSegment.id]
                ? 'Vista previa'
                : 'Audio pendiente'
              : activeState.completed
                ? 'Escuchado'
                : 'En curso'}
          </span>
        </div>

        <audio
          onEnded={() => {
            setPlaying(false)
            void reportProgress(activeSegment.duration_seconds, true)
          }}
          onLoadedMetadata={(event) => {
            const resumeAt = activeState.completed
              ? 0
              : Math.min(activeState.max, Math.max(event.currentTarget.duration - 1, 0))
            event.currentTarget.currentTime = resumeAt
            lastReportedRef.current = resumeAt
            setCurrentTime(resumeAt)
          }}
          onPause={() => setPlaying(false)}
          onPlay={() => setPlaying(true)}
          onRateChange={(event) => {
            event.currentTarget.playbackRate = 1
          }}
          onTimeUpdate={(event) => {
            const next = event.currentTarget.currentTime
            setCurrentTime(next)
            if (
              !activeState.completed &&
              next - lastReportedRef.current >= 4
            ) {
              lastReportedRef.current = next
              void reportProgress(next)
            }
          }}
          preload="metadata"
          ref={audioRef}
          src={sources[activeSegment.id]}
        />

        <div className="audio-player__controls">
          <button
            aria-label={playing ? 'Pausar' : 'Reproducir'}
            className="audio-player__play"
            disabled={!sources[activeSegment.id]}
            onClick={togglePlayback}
            type="button"
          >
            {playing ? <Pause size={19} /> : <Play size={19} />}
          </button>
          <button
            aria-label="Retroceder diez segundos"
            className="icon-button audio-player__rewind"
            onClick={() => handleSeek(Math.max(0, currentTime - 10))}
            type="button"
          >
            <RotateCcw size={16} />
          </button>
          <span>{formatTime(currentTime)}</span>
          <input
            aria-label="Posición del audio"
            max={activeSegment.duration_seconds}
            min={0}
            onChange={(event) => handleSeek(Number(event.target.value))}
            step={1}
            type="range"
            value={Math.min(currentTime, activeSegment.duration_seconds)}
          />
          <span>{formatTime(activeSegment.duration_seconds)}</span>
        </div>
        {notice ? <p className="audio-player__notice">{notice}</p> : null}

        {previewMode ? (
          <div className="alert alert--info audio-player__preview">
            Vista previa administrativa: puedes revisar los guiones y las
            diapositivas aunque todavía no exista una grabación.
          </div>
        ) : null}

        {previewMode && activeSegment.narration_text ? (
          <div className="audio-player__script">
            <span className="eyebrow">Guion del audio</span>
            <p>{activeSegment.narration_text}</p>
          </div>
        ) : null}
      </article>

      {activeNote ? (
        <section className="panel lesson-notes">
          <div className="panel__header">
            <div>
              <span className="eyebrow">Parte {blockPosition}.{activeIndex + 1}</span>
              <h2>Explicación y puntos esenciales</h2>
            </div>
          </div>
          <p>{activeNote.summary}</p>
          <ul>
            {activeNote.key_points.map((point) => <li key={point}>{point}</li>)}
          </ul>
          <div className="lesson-notes__stop">
            <strong>Criterio preventivo o de parada</strong>
            <p>{activeNote.stop_criterion}</p>
          </div>
          <p className="lesson-notes__source">
            Fuente: {activeNote.source_label}
          </p>
          <p className="lesson-notes__source">
            Páginas relacionadas: {activeNote.source_pages}
          </p>
          <button
            className="button button--outline lesson-notes__pdf"
            disabled={!pdfViewerUrl}
            onClick={() => setPdfOpen(true)}
            type="button"
          >
            <FileText size={18} /> {pdfLabel}
          </button>
        </section>
      ) : null}

      <div className="audio-lesson__navigation">
        <button
          className="button button--outline"
          disabled={activeIndex === 0}
          onClick={() => selectSegment(activeIndex - 1)}
          type="button"
        >
          <ChevronLeft size={18} /> Parte anterior
        </button>
        <button
          className="button button--primary"
          disabled={
            activeIndex >= segments.length - 1 ||
            (!previewMode && !activeState.completed)
          }
          onClick={() => selectSegment(activeIndex + 1)}
          type="button"
        >
          Siguiente parte <ChevronRight size={18} />
        </button>
      </div>

      {expandedSlide ? (
        <div
          aria-label={expandedSlide.title}
          aria-modal="true"
          className="lesson-slide-modal"
          ref={dialogRef}
          role="dialog"
        >
          <button
            aria-label="Cerrar diapositiva"
            className="lesson-slide-modal__close"
            onClick={() => setExpandedSlideId(null)}
            type="button"
          >
            <X size={22} />
          </button>
          <article className="lesson-slide lesson-slide--expanded">
            {slideSources[expandedSlide.id] ? (
              <img
                src={slideSources[expandedSlide.id]}
                alt={expandedSlide.alt_text ?? expandedSlide.title}
              />
            ) : null}
            <span className="eyebrow">
              Parte {blockPosition}.{activeIndex + 1} · diapositiva {expandedSlide.position}
            </span>
            <h2>{expandedSlide.title}</h2>
            <small className="lesson-slide__source">
              {[expandedSlide.source_label, expandedSlide.source_page]
                .filter(Boolean)
                .join(' · ')}
            </small>
          </article>
        </div>
      ) : null}

      {pdfOpen && pdfViewerUrl ? (
        <div
          aria-label="Visor del manual del curso"
          aria-modal="true"
          className="lesson-pdf-modal"
          ref={dialogRef}
          role="dialog"
        >
          <div className="lesson-pdf-modal__panel">
            <div className="lesson-pdf-modal__header">
              <div>
                <span className="eyebrow">Manual complementario</span>
                <h2>{pdfResource?.title ?? 'PDF del curso'}</h2>
              </div>
              <div className="lesson-pdf-modal__actions">
                <a
                  className="button button--outline"
                  href={pdfViewerUrl}
                  rel="noopener noreferrer"
                  target="_blank"
                >
                  Abrir en otra pestaña <ExternalLink size={17} />
                </a>
                <button
                  aria-label="Cerrar PDF"
                  className="icon-button"
                  onClick={() => setPdfOpen(false)}
                  type="button"
                >
                  <X size={22} />
                </button>
              </div>
            </div>
            <iframe
              src={pdfViewerUrl}
              title={pdfResource?.title ?? 'Manual del curso'}
            />
            <p className="muted">
              Si el visor no carga, utiliza «Abrir en otra pestaña».
            </p>
          </div>
        </div>
      ) : null}
    </section>
  )
}
