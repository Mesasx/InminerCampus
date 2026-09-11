import {
  ChevronLeft,
  ChevronRight,
  Download,
  FileText,
  Pause,
  Play,
  RotateCcw,
  Volume2,
  VolumeX,
} from 'lucide-react'
import { useEffect, useMemo, useRef, useState } from 'react'
import { DetailedExplanation } from './DetailedExplanation'
import {
  ReadingProgressBadge,
  ReadingProgressIndicator,
} from './ReadingProgressIndicator'
import { buildExplanation, complementaryNote } from '../lib/lesson-explanation'
import { resolveSignedUrls } from '../lib/signed-url-cache'
import { getSupabaseBrowserClient } from '../lib/supabase'
import { useReadingProgress } from '../lib/use-reading-progress'

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
  lesson_code: string | null
  manual_chapter: string | null
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
  explanation_read_at?: string | null
}

export type LessonAudioSegment = {
  id: string
  position: number
  lessonCode: string | null
  manualChapter: string | null
  title: string
  narrationText: string
  audioUrl: string
  audioStoragePath: string | null
  durationSeconds: number
  maxPositionSeconds: number
  completed: boolean
  explanationRead: boolean
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

type SegmentState = {
  max: number
  completed: boolean
  read: boolean
}

// Todas las diapositivas del campus se generan en 1600×900 (16:9). Fijar el
// tamaño intrínseco evita el salto de layout mientras carga la imagen.
const SLIDE_INTRINSIC_WIDTH = 1600
const SLIDE_INTRINSIC_HEIGHT = 900

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
  courseTitle = 'Curso Inmíner',
  regulationLabel = 'Formación preventiva',
  onLessonProgress,
  previewMode = false,
}: {
  enrollmentId: string
  segments?: AudioSegment[]
  progress?: AudioProgress[]
  initialSegments?: LessonAudioSegment[]
  blockPosition?: number
  courseTitle?: string
  regulationLabel?: string
  onLessonProgress?: () => void
  previewMode?: boolean
}) {
  const segments = useMemo<AudioSegment[]>(
    () =>
      initialSegments
        ? initialSegments.map((segment) => ({
            id: segment.id,
            position: segment.position,
            lesson_code: segment.lessonCode,
            manual_chapter: segment.manualChapter,
            title: segment.title,
            narration_text: segment.narrationText,
            audio_storage_path: segment.audioStoragePath,
            audio_external_url: segment.audioStoragePath
              ? null
              : segment.audioUrl,
            duration_seconds: segment.durationSeconds,
            lesson_segment_slides: segment.slides.map((slide) => ({
              id: slide.id,
              position: slide.position,
              title: slide.title,
              body: slide.body,
              image_storage_path: slide.imageStoragePath,
              image_external_url: slide.imageStoragePath
                ? null
                : slide.imageUrl,
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
        : (sourceSegments ?? []),
    [initialSegments, sourceSegments],
  )
  const progress = useMemo<AudioProgress[]>(
    () =>
      initialSegments
        ? initialSegments.map((segment) => ({
            segment_id: segment.id,
            max_position_seconds: segment.maxPositionSeconds,
            completed_at: segment.completed ? new Date(0).toISOString() : null,
            explanation_read_at: segment.explanationRead
              ? new Date(0).toISOString()
              : null,
          }))
        : (sourceProgress ?? []),
    [initialSegments, sourceProgress],
  )
  const audioRef = useRef<HTMLAudioElement | null>(null)
  const lastReportedRef = useRef(0)
  const touchStartXRef = useRef<number | null>(null)
  const initialActiveIndex = segments.findIndex((segment) => {
    const row = progress.find((item) => item.segment_id === segment.id)
    return !row?.completed_at
  })
  const [activeIndex, setActiveIndex] = useState(
    initialActiveIndex === -1
      ? Math.max(segments.length - 1, 0)
      : initialActiveIndex,
  )
  const [playing, setPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [notice, setNotice] = useState('')
  const [transcriptOpen, setTranscriptOpen] = useState(false)
  // El volumen vive en React y no sólo en el elemento <audio> para que
  // sobreviva al cambio de unidad, que reinicia la reproducción.
  const [volume, setVolume] = useState(1)
  const [muted, setMuted] = useState(false)
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
  const [segmentState, setSegmentState] = useState<
    Record<string, SegmentState>
  >(() =>
    Object.fromEntries(
      segments.map((segment) => {
        const row = progress.find((item) => item.segment_id === segment.id)
        return [
          segment.id,
          {
            max: row?.max_position_seconds ?? 0,
            completed: Boolean(row?.completed_at),
            // Compatibilidad con quien ya avanzó antes de que existiera el
            // requisito de lectura: una unidad escuchada cuenta como leída.
            read: Boolean(row?.explanation_read_at || row?.completed_at),
          },
        ]
      }),
    ),
  )

  const emptyState: SegmentState = { max: 0, completed: false, read: false }
  const activeSegment = segments[activeIndex]
  const activeState = activeSegment
    ? (segmentState[activeSegment.id] ?? emptyState)
    : emptyState

  const firstIncompleteIndex = useMemo(() => {
    const index = segments.findIndex(
      (segment) => !segmentState[segment.id]?.completed,
    )
    return index === -1 ? Math.max(segments.length - 1, 0) : index
  }, [segmentState, segments])

  // La explicación de la unidad activa, ya interpretada: el mismo intérprete
  // para los seis manuales, de modo que el alumno lee siempre con la misma
  // jerarquía aunque cada curso se cargara con un vocabulario distinto.
  // Cuando una unidad tiene varias diapositivas, la explicación acompaña a la
  // que se está viendo, igual que antes de unificar el pintado.
  const explanationSource = useMemo(() => {
    const note = activeSegment?.lesson_segment_notes?.[0]
    const slide = activeSegment?.lesson_segment_slides?.[activeSlideIndex]
    return {
      slideBody: slide?.body ?? '',
      noteSummary: note?.summary ?? '',
      noteKeyPoints: note?.key_points ?? [],
      noteStopCriterion: note?.stop_criterion ?? '',
    }
  }, [activeSegment, activeSlideIndex])

  const explanation = useMemo(
    () => buildExplanation(explanationSource),
    [explanationSource],
  )
  const extraNote = useMemo(
    () => complementaryNote(explanation, explanationSource),
    [explanation, explanationSource],
  )

  // Sin explicación que recorrer no hay requisito de lectura que exigir.
  const hasExplanation = explanation.sections.length > 0
  const readingAlreadyDone = activeState.read || !hasExplanation || previewMode

  const reading = useReadingProgress({
    contentKey: `${activeSegment?.id ?? ''}:${activeSlideIndex}`,
    enabled: hasExplanation && !previewMode,
    initiallyCompleted: readingAlreadyDone,
    onCompleted: () => {
      const segmentId = activeSegment?.id
      if (!segmentId || activeState.read) return
      void reportExplanationRead(segmentId)
    },
  })

  const readingDone = readingAlreadyDone || reading.completed

  useEffect(() => {
    let cancelled = false
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const client = supabase

    async function refreshSignedSources() {
      // Una sola llamada por lotes para todos los audios y diapositivas de
      // esta lección. La caché compartida hace que, si nada está a punto de
      // caducar, esta llamada no genere tráfico de red alguno.
      const storagePaths = [
        ...segments.map((segment) => segment.audio_storage_path),
        ...segments.flatMap((segment) =>
          segment.lesson_segment_slides.map(
            (slide) => slide.image_storage_path,
          ),
        ),
      ]
      const signedUrls = await resolveSignedUrls(
        client,
        'course-materials',
        storagePaths,
      )
      if (cancelled) return

      const audioEntries = segments.map((segment) => {
        const url = segment.audio_storage_path
          ? (signedUrls[segment.audio_storage_path] ?? '')
          : (segment.audio_external_url ?? '')
        return [segment.id, url] as const
      })
      const imageEntries = segments.flatMap((segment) =>
        segment.lesson_segment_slides.map((slide) => {
          const url = slide.image_storage_path
            ? (signedUrls[slide.image_storage_path] ?? '')
            : (slide.image_external_url ?? '')
          return [slide.id, url] as const
        }),
      )
      setSources((current) => ({
        ...current,
        ...Object.fromEntries(
          audioEntries.filter(([, value]) => Boolean(value)),
        ),
      }))
      setSlideSources((current) => ({
        ...current,
        ...Object.fromEntries(
          imageEntries.filter(([, value]) => Boolean(value)),
        ),
      }))
    }

    void refreshSignedSources()
    // Se comprueba cada pocos minutos, pero la caché solo vuelve a firmar
    // (y solo hace red) las rutas que estén a punto de caducar: renovación
    // silenciosa, sin cortar el contenido que el alumno tiene abierto.
    const refreshTimer = window.setInterval(refreshSignedSources, 5 * 60 * 1000)

    return () => {
      cancelled = true
      window.clearInterval(refreshTimer)
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
    setActiveSlideIndex(0)
    setTranscriptOpen(false)
  }, [activeSegment?.id])

  useEffect(() => {
    const audio = audioRef.current
    if (audio) audio.volume = muted ? 0 : volume
  }, [muted, volume])

  async function reportProgress(position: number, completed = false) {
    if (!activeSegment || previewMode) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const { data, error } = await supabase.rpc(
      'record_audio_segment_progress',
      {
        p_enrollment_id: enrollmentId,
        p_segment_id: activeSegment.id,
        p_position_seconds: Math.floor(position),
        p_completed: completed,
      },
    )

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
        ...(current[activeSegment.id] ?? emptyState),
        max: result.maxPositionSeconds ?? Math.floor(position),
        completed: Boolean(result.completed),
      },
    }))
    if (result.lessonAudioCompleted) onLessonProgress?.()
  }

  // La lectura se guarda en la misma fila de progreso que el audio, con su
  // propia marca de tiempo. Si la escritura falla, el avance de la sesión se
  // conserva en memoria: el alumno no se queda bloqueado por un fallo de red,
  // y la próxima vez que llegue al final volverá a intentarse.
  async function reportExplanationRead(segmentId: string) {
    setSegmentState((current) => ({
      ...current,
      [segmentId]: { ...(current[segmentId] ?? emptyState), read: true },
    }))
    if (previewMode) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const { error } = await supabase.rpc('record_explanation_read', {
      p_enrollment_id: enrollmentId,
      p_segment_id: segmentId,
    })
    if (error) {
      console.error('[audio-player] No se pudo guardar la lectura', {
        segmentId,
        error,
      })
    }
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
    try {
      if (audio.paused) {
        await audio.play()
        setNotice('')
      } else {
        audio.pause()
      }
    } catch (error) {
      console.error('[audio-player] No se pudo reproducir el audio', {
        segmentId: activeSegment?.id,
        hasSource: Boolean(activeSegment && sources[activeSegment.id]),
        error,
      })
      setPlaying(false)
      setNotice(
        'No se ha podido reproducir el audio. Recarga la página e inténtalo de nuevo.',
      )
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
      audio.currentTime = Math.min(
        activeState.max,
        audio.duration || activeState.max,
      )
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

  async function downloadCurrentSlide() {
    if (!activeSlide) return
    const source = slideSources[activeSlide.id]
    if (!source) {
      setNotice(
        'La diapositiva actual todavía no está disponible para descargar.',
      )
      return
    }

    try {
      const response = await fetch(source)
      if (!response.ok) throw new Error(`HTTP ${response.status}`)
      const imageBlob = await response.blob()
      const imageUrl = URL.createObjectURL(imageBlob)
      const image = new Image()
      await new Promise<void>((resolve, reject) => {
        image.onload = () => resolve()
        image.onerror = () => reject(new Error('No se pudo cargar la imagen'))
        image.src = imageUrl
      })

      const width = SLIDE_INTRINSIC_WIDTH
      const headerHeight = 150
      const height = headerHeight + SLIDE_INTRINSIC_HEIGHT
      const canvas = document.createElement('canvas')
      canvas.width = width
      canvas.height = height
      const context = canvas.getContext('2d')
      if (!context) throw new Error('Canvas no disponible')

      context.fillStyle = '#ffffff'
      context.fillRect(0, 0, width, height)
      context.fillStyle = '#f47a16'
      context.fillRect(0, 0, 12, headerHeight)
      context.fillStyle = '#17202a'
      context.font = '700 38px Arial, sans-serif'
      context.fillText(courseTitle, 52, 62, width - 104)
      context.fillStyle = '#4f5962'
      context.font = '600 26px Arial, sans-serif'
      context.fillText(regulationLabel, 52, 112, width - 260)
      context.fillStyle = '#d4d8dc'
      context.fillRect(width - 190, 78, 2, 36)
      context.fillStyle = '#f47a16'
      context.font = '700 30px Arial, sans-serif'
      context.fillText(`${blockPosition}.${activeIndex + 1}`, width - 158, 108)

      const scale = Math.min(
        width / image.naturalWidth,
        SLIDE_INTRINSIC_HEIGHT / image.naturalHeight,
      )
      const drawWidth = image.naturalWidth * scale
      const drawHeight = image.naturalHeight * scale
      context.fillStyle = '#11191e'
      context.fillRect(0, headerHeight, width, SLIDE_INTRINSIC_HEIGHT)
      context.drawImage(
        image,
        (width - drawWidth) / 2,
        headerHeight + (SLIDE_INTRINSIC_HEIGHT - drawHeight) / 2,
        drawWidth,
        drawHeight,
      )
      URL.revokeObjectURL(imageUrl)

      const downloadBlob = await new Promise<Blob>((resolve, reject) => {
        canvas.toBlob((blob) => {
          if (blob) resolve(blob)
          else reject(new Error('No se pudo generar la descarga'))
        }, 'image/png')
      })
      const downloadUrl = URL.createObjectURL(downloadBlob)
      const link = document.createElement('a')
      const safeCourse = courseTitle
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/[^a-zA-Z0-9]+/g, '-')
        .replace(/^-|-$/g, '')
        .toLowerCase()
      link.download = `${safeCourse}-${blockPosition}.${activeIndex + 1}.png`
      link.href = downloadUrl
      document.body.appendChild(link)
      link.click()
      link.remove()
      URL.revokeObjectURL(downloadUrl)
      setNotice('Se ha descargado la diapositiva actual.')
    } catch (error) {
      console.error(
        '[slide-download] No se pudo descargar la diapositiva',
        error,
      )
      setNotice('No se ha podido descargar la diapositiva. Inténtalo de nuevo.')
    }
  }

  // Precarga la diapositiva anterior y la siguiente para que el cambio de
  // diapositiva sea instantáneo una vez que su URL firmada ya está resuelta.
  useEffect(() => {
    const slides = activeSegment?.lesson_segment_slides ?? []
    const neighborIds = [
      slides[activeSlideIndex - 1]?.id,
      slides[activeSlideIndex + 1]?.id,
    ]
    for (const slideId of neighborIds) {
      const url = slideId ? slideSources[slideId] : undefined
      if (!url) continue
      const preload = new Image()
      preload.src = url
    }
  }, [activeSegment, activeSlideIndex, slideSources])

  function handleSlideTouchEnd(clientX: number) {
    const startX = touchStartXRef.current
    touchStartXRef.current = null
    if (startX === null || Math.abs(clientX - startX) < 40) return
    selectSlide(activeSlideIndex + (clientX < startX ? 1 : -1))
  }

  useEffect(() => {
    function handleSlideKeys(event: KeyboardEvent) {
      const target = event.target as HTMLElement | null
      if (target?.matches('input, textarea, select, button, a')) return
      if (event.key === 'ArrowLeft') {
        event.preventDefault()
        selectSegment(activeIndex - 1)
      }
      if (event.key === 'ArrowRight') {
        event.preventDefault()
        selectSegment(activeIndex + 1)
      }
    }
    document.addEventListener('keydown', handleSlideKeys)
    return () => document.removeEventListener('keydown', handleSlideKeys)
  }, [activeIndex, firstIncompleteIndex, previewMode, segmentState, segments])

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
  const activeSlide = activeSegment.lesson_segment_slides[activeSlideIndex]
  const activeCode =
    activeSegment.lesson_code ?? `${blockPosition}.${activeSegment.position}`

  // «Siguiente» exige las dos cosas: haber escuchado la locución completa y
  // haber recorrido la explicación hasta el final. El botón dice siempre cuál
  // de las dos falta, en vez de quedarse gris sin explicación.
  const audioDone = previewMode || activeState.completed
  const isLastSegment = activeIndex >= segments.length - 1
  const nextBlocked = !isLastSegment && !(audioDone && readingDone)
  const nextLabel = isLastSegment
    ? 'Siguiente parte'
    : audioDone && readingDone
      ? 'Siguiente parte'
      : !audioDone && !readingDone
        ? 'Completa el audio y la explicación'
        : audioDone
          ? 'Continúa leyendo la explicación'
          : 'Escucha el audio para continuar'

  return (
    <section className="audio-lesson" aria-label="Lección en audio">
      {/* Contexto discreto. El alumno debe saber dónde está sin que la
          cabecera compita con la diapositiva, que es la protagonista. */}
      <div className="lesson-context">
        <p className="lesson-context__trail">
          <span className="lesson-context__course">{courseTitle}</span>
          <i aria-hidden="true" />
          <span>
            Bloque {blockPosition} · Unidad {activeIndex + 1} de{' '}
            {segments.length}
          </span>
        </p>
        <div className="lesson-context__tracking">
          <label className="lesson-context__jump">
            <span>Ir a</span>
            <select
              aria-label="Cambiar explicación"
              onChange={(event) => selectSegment(Number(event.target.value))}
              value={activeIndex}
            >
              {segments.map((segment, index) => {
                const completed = segmentState[segment.id]?.completed
                const locked =
                  !previewMode && index > firstIncompleteIndex && !completed
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
          <span className="lesson-context__count">
            {completedParts}/{segments.length} escuchadas
          </span>
        </div>
      </div>

      {/* Diapositiva y audio forman una sola superficie: la barra de
          reproducción cuelga del visor en lugar de vivir en su propia tarjeta,
          de modo que el conjunto se lee como una única unidad formativa. */}
      <section className="lesson-slides" aria-label="Diapositiva y locución">
        <article
          className="lesson-slide lesson-slide--stage"
          onTouchEnd={(event) =>
            handleSlideTouchEnd(event.changedTouches[0].clientX)
          }
          onTouchStart={(event) => {
            touchStartXRef.current = event.changedTouches[0].clientX
          }}
        >
          <SlideIdentity
            courseTitle={courseTitle}
            numbering={`${blockPosition}.${activeIndex + 1}`}
            regulationLabel={regulationLabel}
            slideTitle={activeSlide?.title ?? activeSegment.title}
          />
          <div className="lesson-slide__canvas">
            {activeSlide && slideSources[activeSlide.id] ? (
              <img
                alt={activeSlide.alt_text ?? activeSlide.title}
                height={SLIDE_INTRINSIC_HEIGHT}
                src={slideSources[activeSlide.id]}
                width={SLIDE_INTRINSIC_WIDTH}
              />
            ) : (
              <div className="lesson-slide__missing">
                Diapositiva no disponible
              </div>
            )}
            {activeSegment.lesson_segment_slides.length > 1 ? (
              <>
                <button
                  aria-label="Diapositiva anterior"
                  className="lesson-slide__step lesson-slide__step--prev"
                  disabled={activeSlideIndex === 0}
                  onClick={() => selectSlide(activeSlideIndex - 1)}
                  type="button"
                >
                  <ChevronLeft size={22} />
                </button>
                <button
                  aria-label="Diapositiva siguiente"
                  className="lesson-slide__step lesson-slide__step--next"
                  disabled={
                    activeSlideIndex >=
                    activeSegment.lesson_segment_slides.length - 1
                  }
                  onClick={() => selectSlide(activeSlideIndex + 1)}
                  type="button"
                >
                  <ChevronRight size={22} />
                </button>
              </>
            ) : null}
          </div>

          <audio
            onEnded={(event) => {
              setPlaying(false)
              void reportProgress(event.currentTarget.duration, true)
            }}
            onLoadedMetadata={(event) => {
              const resumeAt = activeState.completed
                ? 0
                : Math.min(
                    activeState.max,
                    Math.max(event.currentTarget.duration - 1, 0),
                  )
              event.currentTarget.currentTime = resumeAt
              event.currentTarget.volume = muted ? 0 : volume
              lastReportedRef.current = resumeAt
              setCurrentTime(resumeAt)
            }}
            onPause={() => setPlaying(false)}
            onPlay={() => setPlaying(true)}
            onError={() => {
              setPlaying(false)
              setNotice(
                'No se ha podido reproducir el audio. Recarga la página e inténtalo de nuevo.',
              )
            }}
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

          <div className="lesson-slide__bar">
            <div className="audio-player__controls">
              <button
                aria-label={
                  playing ? 'Pausar la locución' : 'Reproducir la locución'
                }
                className="audio-player__play"
                disabled={!sources[activeSegment.id]}
                onClick={togglePlayback}
                type="button"
              >
                {playing ? <Pause size={18} /> : <Play size={18} />}
              </button>
              <button
                aria-label="Retroceder diez segundos"
                className="icon-button audio-player__rewind"
                onClick={() => handleSeek(Math.max(0, currentTime - 10))}
                type="button"
              >
                <RotateCcw size={15} />
              </button>
              <span className="audio-player__time">
                {formatTime(currentTime)}
              </span>
              <input
                aria-label="Posición del audio"
                max={activeSegment.duration_seconds}
                min={0}
                onChange={(event) => handleSeek(Number(event.target.value))}
                step={1}
                type="range"
                value={Math.min(currentTime, activeSegment.duration_seconds)}
              />
              <span className="audio-player__time">
                {formatTime(activeSegment.duration_seconds)}
              </span>
              <div className="audio-player__volume">
                <button
                  aria-label={muted ? 'Activar el sonido' : 'Silenciar'}
                  aria-pressed={muted}
                  className="icon-button audio-player__mute"
                  onClick={() => setMuted((current) => !current)}
                  type="button"
                >
                  {muted ? <VolumeX size={16} /> : <Volume2 size={16} />}
                </button>
                <input
                  aria-label="Volumen"
                  max={1}
                  min={0}
                  onChange={(event) => {
                    const next = Number(event.target.value)
                    setVolume(next)
                    setMuted(next === 0)
                  }}
                  step={0.05}
                  type="range"
                  value={muted ? 0 : volume}
                />
              </div>
            </div>

            <div
              className={`lesson-slide__toolbar${activeSegment.lesson_segment_slides.length === 1 ? ' lesson-slide__toolbar--single' : ''}`}
            >
              {activeSegment.lesson_segment_slides.length > 1 ? (
                <span>
                  {activeSlideIndex + 1} de{' '}
                  {activeSegment.lesson_segment_slides.length}
                </span>
              ) : null}
              <button
                aria-label={`Descargar diapositiva ${blockPosition}.${activeIndex + 1}`}
                className="icon-button lesson-slide__download"
                disabled={!activeSlide}
                onClick={() => void downloadCurrentSlide()}
                title="Descargar diapositiva"
                type="button"
              >
                <Download size={16} />
              </button>
            </div>
          </div>
        </article>
        {notice ? <p className="audio-player__notice">{notice}</p> : null}
        {previewMode ? (
          <div className="alert alert--info audio-player__preview">
            Vista previa administrativa: puedes revisar los guiones y las
            diapositivas aunque todavía no exista una grabación.
          </div>
        ) : null}
      </section>

      {/* Lectura continua: la explicación desarrolla la diapositiva y se ve
          sin abrir nada; la transcripción queda un escalón por debajo. */}
      <div className="lesson-reading">
        {hasExplanation ? (
          <section
            className="lesson-notes"
            aria-label="Explicación detallada"
            ref={reading.containerRef}
          >
            <span className="eyebrow">
              Información específica de la diapositiva · Unidad {activeCode}
            </span>
            <h2 className="lesson-notes__title">
              Explicación detallada ·{' '}
              {activeSegment.manual_chapter || activeSegment.title}
            </h2>
            <DetailedExplanation document={explanation} />
            {extraNote.keyPoints.length ? (
              <ul className="lesson-notes__points">
                {extraNote.keyPoints.map((point) => (
                  <li key={point}>{point}</li>
                ))}
              </ul>
            ) : null}
            {extraNote.stopCriterion ? (
              <div className="lesson-notes__stop">
                <strong>Criterio preventivo o de parada</strong>
                <p>{extraNote.stopCriterion}</p>
              </div>
            ) : null}
            {/* Centinela de lectura: al entrar en pantalla, el alumno ha
                llegado al final de la explicación. */}
            <span
              aria-hidden="true"
              className="lesson-notes__end"
              ref={reading.sentinelRef}
            />
            <ReadingProgressBadge completed={readingDone} />
          </section>
        ) : null}

        {activeSegment.narration_text ? (
          <div className="lesson-disclosure">
            <button
              aria-expanded={transcriptOpen}
              className="lesson-disclosure__toggle"
              onClick={() => setTranscriptOpen((current) => !current)}
              type="button"
            >
              <ChevronRight
                aria-hidden="true"
                className={`lesson-disclosure__chevron${transcriptOpen ? ' lesson-disclosure__chevron--open' : ''}`}
                size={16}
              />
              <FileText aria-hidden="true" size={16} />
              <span>Transcripción del audio · texto exacto</span>
            </button>
            {transcriptOpen ? (
              <div className="audio-player__script">
                <p>{activeSegment.narration_text}</p>
              </div>
            ) : null}
          </div>
        ) : null}
      </div>

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
          aria-describedby={nextBlocked ? 'lesson-next-reason' : undefined}
          className="button button--primary"
          disabled={isLastSegment || nextBlocked}
          onClick={() => selectSegment(activeIndex + 1)}
          type="button"
        >
          {nextLabel} <ChevronRight size={18} />
        </button>
      </div>
      {nextBlocked ? (
        <p className="audio-lesson__requirement" id="lesson-next-reason">
          {audioDone
            ? 'Has escuchado la locución completa. Recorre la explicación detallada hasta el final para desbloquear la siguiente diapositiva.'
            : readingDone
              ? 'Has recorrido la explicación. Escucha la locución completa para desbloquear la siguiente diapositiva.'
              : 'Escucha la locución completa y recorre la explicación detallada hasta el final para desbloquear la siguiente diapositiva.'}
        </p>
      ) : null}

      <ReadingProgressIndicator
        audioPending={!audioDone}
        completed={readingDone}
        percent={reading.percent}
        visible={hasExplanation && !previewMode}
      />
    </section>
  )
}

// Cabecera del visor. Manda el título de la diapositiva, porque es lo que el
// alumno está estudiando; el curso y la referencia normativa quedan como
// procedencia, en un segundo plano tipográfico.
function SlideIdentity({
  courseTitle,
  numbering,
  regulationLabel,
  slideTitle,
}: {
  courseTitle: string
  numbering: string
  regulationLabel: string
  slideTitle?: string
}) {
  return (
    <header className="lesson-slide__identity">
      <strong>
        <b>{numbering}</b>
        {slideTitle ?? courseTitle}
      </strong>
      <span>
        {courseTitle}
        <i aria-hidden="true" />
        {regulationLabel}
      </span>
    </header>
  )
}
