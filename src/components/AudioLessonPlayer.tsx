import {
  Check,
  ChevronLeft,
  ChevronRight,
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
  durationSeconds: number
  maxPositionSeconds: number
  completed: boolean
  note: {
    summary: string
    keyPoints: string[]
    sourceLabel: string
    sourcePages: string
  } | null
  slides: Array<{
    id: string
    position: number
    title: string
    body: string
    imageUrl: string | null
    sourceLabel: string | null
    sourcePage: string | null
    altText: string
  }>
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
  onLessonProgress,
  previewMode = false,
}: {
  enrollmentId: string
  segments?: AudioSegment[]
  progress?: AudioProgress[]
  initialSegments?: LessonAudioSegment[]
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
            audio_storage_path: null,
            audio_external_url: segment.audioUrl,
            duration_seconds: segment.durationSeconds,
            lesson_segment_slides: segment.slides.map((slide) => ({
              id: slide.id,
              position: slide.position,
              title: slide.title,
              body: slide.body,
              image_storage_path: null,
              image_external_url: slide.imageUrl,
              source_label: slide.sourceLabel,
              source_page: slide.sourcePage,
              alt_text: slide.altText,
            })),
            lesson_segment_notes: segment.note
              ? [
                  {
                    summary: segment.note.summary,
                    key_points: segment.note.keyPoints,
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
  const lastReportedRef = useRef(0)
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
  const [sources, setSources] = useState<Record<string, string>>({})
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

    void Promise.all(
      segments.map(async (segment) => {
        if (segment.audio_external_url) {
          return [segment.id, segment.audio_external_url] as const
        }
        if (!segment.audio_storage_path) return [segment.id, ''] as const
        const { data } = await supabase.storage
          .from('course-materials')
          .createSignedUrl(segment.audio_storage_path, 3600)
        return [segment.id, data?.signedUrl ?? ''] as const
      }),
    ).then((entries) => {
      if (!cancelled) setSources(Object.fromEntries(entries))
    })

    return () => {
      cancelled = true
    }
  }, [segments])

  useEffect(() => {
    const audio = audioRef.current
    if (!audio) return
    audio.pause()
    audio.currentTime = 0
    lastReportedRef.current = 0
    setCurrentTime(0)
    setPlaying(false)
    setExpandedSlideId(null)
  }, [activeSegment?.id])

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
  const expandedSlide = activeSegment.lesson_segment_slides.find(
    (slide) => slide.id === expandedSlideId,
  )

  return (
    <section className="audio-lesson" aria-label="Lección en audio">
      <div className="audio-lesson__progress panel">
        <div>
          <span className="eyebrow">Progreso del bloque</span>
          <strong>{completedParts} de {segments.length} partes escuchadas</strong>
        </div>
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

      <div className="audio-lesson__steps" aria-label="Partes de la lección">
        {segments.map((segment, index) => {
          const state = segmentState[segment.id]
          const locked =
            !previewMode && index > firstIncompleteIndex && !state?.completed
          return (
            <button
              aria-current={index === activeIndex ? 'step' : undefined}
              className={[
                'audio-step',
                index === activeIndex ? 'is-active' : '',
                state?.completed ? 'is-complete' : '',
              ]
                .filter(Boolean)
                .join(' ')}
              disabled={locked}
              key={segment.id}
              onClick={() => selectSegment(index)}
              type="button"
            >
              <span>{state?.completed ? <Check size={16} /> : index + 1}</span>
              <small>Parte 1.{index + 1}</small>
              <strong>{segment.title}</strong>
            </button>
          )
        })}
      </div>

      <article className="panel audio-player">
        <div className="audio-player__heading">
          <div>
            <span className="eyebrow">
              Parte 1.{activeIndex + 1} de 1.{segments.length}
            </span>
            <h2>{activeSegment.title}</h2>
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

        {previewMode ? (
          <div className="alert alert--info">
            Vista previa administrativa: puedes revisar los diez guiones y sus
            diapositivas aunque todavía no exista una grabación.
          </div>
        ) : null}

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
            {playing ? <Pause size={24} /> : <Play size={24} />}
          </button>
          <button
            aria-label="Retroceder diez segundos"
            className="icon-button"
            onClick={() => handleSeek(Math.max(0, currentTime - 10))}
            type="button"
          >
            <RotateCcw size={18} />
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

        {previewMode && activeSegment.narration_text ? (
          <div className="audio-player__script">
            <span className="eyebrow">Guion del audio</span>
            <p>{activeSegment.narration_text}</p>
          </div>
        ) : null}
      </article>

      <section className="lesson-slides">
        <div className="panel__header">
          <div>
            <span className="eyebrow">Apoyo visual</span>
            <h2>Diapositivas de este audio</h2>
          </div>
        </div>
        <div className="lesson-slides__grid">
          {activeSegment.lesson_segment_slides.map((slide) => (
            <article className="lesson-slide" key={slide.id}>
              {slide.image_external_url ? (
                <img
                  src={slide.image_external_url}
                  alt={slide.alt_text ?? slide.title}
                />
              ) : null}
              <div className="lesson-slide__toolbar">
                <span className="lesson-slide__number">{slide.position}</span>
                <button
                  aria-label={`Ampliar ${slide.title}`}
                  className="icon-button"
                  onClick={() => setExpandedSlideId(slide.id)}
                  type="button"
                >
                  <Maximize2 size={18} />
                </button>
              </div>
              <h3>{slide.title}</h3>
              <p>{slide.body}</p>
              {slide.source_label || slide.source_page ? (
                <small className="lesson-slide__source">
                  {[slide.source_label, slide.source_page].filter(Boolean).join(' · ')}
                </small>
              ) : null}
            </article>
          ))}
        </div>
      </section>

      {activeNote ? (
        <section className="panel lesson-notes">
          <div className="panel__header">
            <div>
              <span className="eyebrow">Apuntes de la parte 1.{activeIndex + 1}</span>
              <h2>Ideas que debes retener</h2>
            </div>
          </div>
          <p>{activeNote.summary}</p>
          <ul>
            {activeNote.key_points.map((point) => <li key={point}>{point}</li>)}
          </ul>
          <p className="lesson-notes__source">
            Fuente: {activeNote.source_label} · páginas {activeNote.source_pages}
          </p>
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
            {expandedSlide.image_external_url ? (
              <img
                src={expandedSlide.image_external_url}
                alt={expandedSlide.alt_text ?? expandedSlide.title}
              />
            ) : null}
            <span className="eyebrow">Parte 1.{activeIndex + 1}</span>
            <h2>{expandedSlide.title}</h2>
            <p>{expandedSlide.body}</p>
            <small className="lesson-slide__source">
              {[expandedSlide.source_label, expandedSlide.source_page]
                .filter(Boolean)
                .join(' · ')}
            </small>
          </article>
        </div>
      ) : null}
    </section>
  )
}
