import {
  ChevronLeft,
  ChevronRight,
  Download,
  ExternalLink,
  FileText,
  Maximize2,
  Pause,
  Play,
  RotateCcw,
  Volume2,
  VolumeX,
  X,
} from 'lucide-react'
import { useEffect, useMemo, useRef, useState } from 'react'
import { resolveSignedUrls } from '../lib/signed-url-cache'
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

// Todas las diapositivas del campus se generan en 1600×900 (16:9). Fijar el
// tamaño intrínseco evita el salto de layout mientras carga la imagen.
const SLIDE_INTRINSIC_WIDTH = 1600
const SLIDE_INTRINSIC_HEIGHT = 900

function formatTime(seconds: number) {
  const safeSeconds = Math.max(0, Math.floor(seconds || 0))
  return `${Math.floor(safeSeconds / 60)}:${String(safeSeconds % 60).padStart(2, '0')}`
}

const detailedInformationHeadings = new Set([
  'Objetivo',
  'Explicación detallada',
  'Explicación de base',
  'Profundización técnica y criterio preventivo',
  'Aplicación práctica',
  'Secuencia operativa recomendada',
  'Caso práctico razonado',
  'Riesgos y errores que deben evitarse',
  'Errores críticos que deben evitarse',
  'Comprobación antes de continuar',
  'Idea clave',
  'Idea central',
  'Definición y alcance',
  'Fundamento técnico ampliado',
  'Riesgo que debe comprenderse',
  'Aplicación operativa',
  'Criterio de actuación',
  'Caso razonado',
])

const detailedInformationListHeadings = new Set([
  'Secuencia operativa recomendada',
  'Riesgos y errores que deben evitarse',
  'Errores críticos que deben evitarse',
  'Comprobación antes de continuar',
])

// Los manuales maestros titulan sus propios apartados dentro de cada sección
// («Riesgos vinculados a las interfaces», «Puestos comprendidos»…). Esos
// rótulos son distintos en cada unidad, así que no caben en una lista cerrada:
// se reconocen por forma. Se excluyen explícitamente las viñetas y las líneas
// numeradas, que sí abren bloque pero son contenido, no título.
function looksLikeSubheading(line: string, rest: string[]) {
  if (!rest.length) return false
  if (line.length < 3 || line.length > 94) return false
  if (/^[•\-–—\d]/.test(line)) return false
  return !/[.:;,]$/.test(line)
}

function DetailedSpecificInformation({ text }: { text: string }) {
  const blocks = text
    .split(/\n{2,}/)
    .map((block) => block.trim())
    .filter(Boolean)

  if (blocks.length === 1) return <p>{text}</p>

  const sections: Array<{
    heading: string | null
    blocks: Array<string | { subheading: string }>
  }> = []

  for (const block of blocks) {
    const lines = block
      .split('\n')
      .map((line) => line.trim())
      .filter(Boolean)
    const heading = lines[0]

    if (detailedInformationHeadings.has(heading)) {
      sections.push({ heading, blocks: lines.slice(1) })
      continue
    }

    const activeSection = sections.at(-1)
    const rest = lines.slice(1)
    // Un rótulo propio del manual se conserva como subtítulo dentro de la
    // sección abierta, en vez de disolverse en el párrafo anterior.
    const nested =
      activeSection?.heading && looksLikeSubheading(heading, rest)
        ? [{ subheading: heading }, ...rest]
        : null

    if (activeSection && nested) {
      activeSection.blocks.push(...nested)
    } else if (activeSection?.heading) {
      activeSection.blocks.push(block)
    } else {
      sections.push({ heading: null, blocks: [block] })
    }
  }

  return (
    <div className="lesson-notes__content">
      {sections.map((section, sectionIndex) => {
        const { heading } = section

        const paragraphs = section.blocks.map((block) =>
          typeof block === 'string' ? (
            <p key={block}>{block}</p>
          ) : (
            <h4 key={`sub-${block.subheading}`}>{block.subheading}</h4>
          ),
        )

        if (heading && detailedInformationListHeadings.has(heading)) {
          const items = section.blocks.flatMap((block) =>
            (typeof block === 'string' ? block : block.subheading)
              .split('\n')
              .map((line) => line.trim().replace(/^[-•]\s*/, ''))
              .filter(Boolean),
          )
          return (
            <section key={`${heading}-${sectionIndex}`}>
              <h3>{heading}</h3>
              <ul>
                {items.map((item) => (
                  <li key={item}>{item}</li>
                ))}
              </ul>
            </section>
          )
        }

        if (heading === 'Idea clave' || heading === 'Idea central') {
          return (
            <aside
              className="lesson-notes__key"
              key={`${heading}-${sectionIndex}`}
            >
              <strong>{heading}</strong>
              {paragraphs}
            </aside>
          )
        }

        if (heading) {
          return (
            <section key={`${heading}-${sectionIndex}`}>
              <h3>{heading}</h3>
              {paragraphs}
            </section>
          )
        }

        return paragraphs
      })}
    </div>
  )
}

export function AudioLessonPlayer({
  enrollmentId,
  segments: sourceSegments,
  progress: sourceProgress,
  initialSegments,
  blockPosition = 1,
  courseTitle = 'Curso Inmíner',
  regulationLabel = 'Formación preventiva',
  pdfResource = null,
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
          }))
        : (sourceProgress ?? []),
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
    initialActiveIndex === -1
      ? Math.max(segments.length - 1, 0)
      : initialActiveIndex,
  )
  const [playing, setPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [notice, setNotice] = useState('')
  const [expandedSlideId, setExpandedSlideId] = useState<string | null>(null)
  const [pdfOpen, setPdfOpen] = useState(false)
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
  const [pdfSource, setPdfSource] = useState(pdfResource?.resolvedUrl ?? '')
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
          },
        ]
      }),
    ),
  )

  const activeSegment = segments[activeIndex]
  const activeState = activeSegment
    ? (segmentState[activeSegment.id] ?? { max: 0, completed: false })
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
      // Una sola llamada por lotes para todos los audios, diapositivas y el
      // PDF de esta lección. La caché compartida hace que, si nada está a
      // punto de caducar, esta llamada no genere tráfico de red alguno.
      const storagePaths = [
        ...segments.map((segment) => segment.audio_storage_path),
        ...segments.flatMap((segment) =>
          segment.lesson_segment_slides.map(
            (slide) => slide.image_storage_path,
          ),
        ),
        pdfResource?.storagePath ?? null,
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
      const resolvedPdf = pdfResource
        ? pdfResource.storagePath
          ? (signedUrls[pdfResource.storagePath] ?? '')
          : pdfResource.resolvedUrl
        : ''

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
      if (resolvedPdf) setPdfSource(resolvedPdf)
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
    setTranscriptOpen(false)
  }, [activeSegment?.id])

  useEffect(() => {
    const audio = audioRef.current
    if (audio) audio.volume = muted ? 0 : volume
  }, [muted, volume])

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
      if (expandedSlideId || pdfOpen) return
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
  }, [
    activeIndex,
    expandedSlideId,
    firstIncompleteIndex,
    pdfOpen,
    previewMode,
    segmentState,
    segments,
  ])

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
  const activeSpecificText =
    activeSlide?.body?.trim() || activeNote?.summary || ''
  const activeSpecificPoints = (activeNote?.key_points ?? []).filter(
    (point) => !activeSpecificText.includes(point),
  )
  const activeSourceLabel =
    activeSlide?.source_label || activeNote?.source_label
  const activeSourcePages = [
    activeSlide?.source_page ? `Diapositiva ${activeSlide.source_page}` : null,
    activeNote?.source_pages,
  ]
    .filter(Boolean)
    .join(' · ')
  const pdfPage = activeSlide?.source_page?.match(/\d+/)?.[0]
  const pdfLabel = pdfPage
    ? `Ver PDF · página ${pdfPage}`
    : 'Ver PDF · consulta general'
  const pdfViewerUrl = pdfSource
    ? `${pdfSource}${pdfPage ? `#page=${pdfPage}` : ''}`
    : ''
  const activeCode =
    activeSegment.lesson_code ?? `${blockPosition}.${activeSegment.position}`

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
              <button
                aria-label={`Ver la diapositiva ${blockPosition}.${activeIndex + 1} a pantalla completa`}
                className="icon-button lesson-slide__fullscreen"
                disabled={!activeSlide}
                onClick={() =>
                  activeSlide ? setExpandedSlideId(activeSlide.id) : undefined
                }
                title="Pantalla completa"
                type="button"
              >
                <Maximize2 size={16} />
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
        {activeSpecificText ? (
          <section className="lesson-notes" aria-label="Explicación detallada">
            <span className="eyebrow">
              Información específica de la diapositiva · Unidad {activeCode}
            </span>
            <h2 className="lesson-notes__title">
              Explicación detallada ·{' '}
              {activeSegment.manual_chapter || activeSegment.title}
            </h2>
            <DetailedSpecificInformation text={activeSpecificText} />
            {activeSpecificPoints.length ? (
              <ul>
                {activeSpecificPoints.map((point) => (
                  <li key={point}>{point}</li>
                ))}
              </ul>
            ) : null}
            {activeNote?.stop_criterion ? (
              <div className="lesson-notes__stop">
                <strong>Criterio preventivo o de parada</strong>
                <p>{activeNote.stop_criterion}</p>
              </div>
            ) : null}
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

        {activeSourceLabel || activeSourcePages || pdfViewerUrl ? (
          <footer className="lesson-reading__meta">
            <span className="lesson-notes__source">
              {[activeSourceLabel, activeSourcePages]
                .filter(Boolean)
                .join(' · ')}
            </span>
            <button
              className="button button--outline lesson-notes__pdf"
              disabled={!pdfViewerUrl}
              onClick={() => setPdfOpen(true)}
              type="button"
            >
              <FileText size={17} /> {pdfLabel}
            </button>
          </footer>
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
          <article className="lesson-slide lesson-slide--expanded">
            <SlideIdentity
              courseTitle={courseTitle}
              numbering={`${blockPosition}.${activeIndex + 1}`}
              regulationLabel={regulationLabel}
            />
            {slideSources[expandedSlide.id] ? (
              <img
                alt={expandedSlide.alt_text ?? expandedSlide.title}
                height={SLIDE_INTRINSIC_HEIGHT}
                src={slideSources[expandedSlide.id]}
                width={SLIDE_INTRINSIC_WIDTH}
              />
            ) : null}
            <span className="lesson-slide-modal__hint">
              Pulsa ESC para salir
            </span>
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
