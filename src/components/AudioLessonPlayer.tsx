import {
  Check,
  ChevronLeft,
  ChevronRight,
  Pause,
  Play,
  RotateCcw,
  Volume2,
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
  slides: Array<{
    id: string
    position: number
    title: string
    body: string
    imageUrl: string | null
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
            })),
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
  const [activeIndex, setActiveIndex] = useState(0)
  const [playing, setPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [notice, setNotice] = useState('')
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
    setActiveIndex(firstIncompleteIndex)
  }, [firstIncompleteIndex])

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
      setNotice('Completa el audio anterior antes de abrir este bloque.')
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
            El temario y las diapositivas ya se están preparando. Los bloques se
            abrirán cuando el administrador incorpore las grabaciones.
          </p>
        </div>
      </section>
    )
  }

  return (
    <section className="audio-lesson" aria-label="Lección en audio">
      <div className="audio-lesson__steps" aria-label="Bloques de la lección">
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
              <small>Audio {index + 1}</small>
              <strong>{segment.title}</strong>
            </button>
          )
        })}
      </div>

      <article className="panel audio-player">
        <div className="audio-player__heading">
          <div>
            <span className="eyebrow">
              Bloque {activeIndex + 1} de {segments.length}
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
            Vista previa administrativa: puedes revisar los cinco guiones y sus
            diapositivas aunque todavía no exista una grabación.
          </div>
        ) : null}

        <audio
          onEnded={() => {
            setPlaying(false)
            void reportProgress(activeSegment.duration_seconds, true)
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
                <img src={slide.image_external_url} alt="" />
              ) : null}
              <span className="lesson-slide__number">{slide.position}</span>
              <h3>{slide.title}</h3>
              <p>{slide.body}</p>
            </article>
          ))}
        </div>
      </section>

      <div className="audio-lesson__navigation">
        <button
          className="button button--outline"
          disabled={activeIndex === 0}
          onClick={() => selectSegment(activeIndex - 1)}
          type="button"
        >
          <ChevronLeft size={18} /> Audio anterior
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
          Siguiente audio <ChevronRight size={18} />
        </button>
      </div>
    </section>
  )
}
