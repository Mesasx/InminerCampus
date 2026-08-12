import {
  CheckCircle2,
  ChevronLeft,
  ChevronRight,
  FileDown,
  LockKeyhole,
  Presentation,
} from 'lucide-react'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'

export type DeckSlide = {
  id: string
  position: number
  title: string
  body: string
  imageUrl: string | null
  altText: string
}

export type DeckChapter = {
  id: string
  position: number
  title: string
  description: string
  slides: DeckSlide[]
  completed: boolean
  slidesViewed: number
}

type Props = {
  enrollmentId: string
  chapters: DeckChapter[]
  previewMode?: boolean
  onDeckCompleted?: () => void
}

// Todas las diapositivas del campus se generan en 1600×900 (16:9). Fijar el
// tamaño intrínseco evita el salto de layout mientras carga la imagen.
const SLIDE_INTRINSIC_WIDTH = 1600
const SLIDE_INTRINSIC_HEIGHT = 900

/**
 * Visor de presentaciones para lecciones sin audio.
 *
 * Reglas de avance:
 *   · Los capítulos se recorren en orden; uno se desbloquea cuando el anterior
 *     está completado.
 *   · Un capítulo se marca como completado cuando el alumno ha visto todas sus
 *     diapositivas. El servidor vuelve a comprobarlo en
 *     record_slide_chapter_progress, de modo que saltar la interfaz no sirve.
 */
export function SlideDeckViewer({
  enrollmentId,
  chapters,
  previewMode = false,
  onDeckCompleted,
}: Props) {
  const [state, setState] = useState(chapters)
  const [chapterIndex, setChapterIndex] = useState(() => {
    const pending = chapters.findIndex((chapter) => !chapter.completed)
    return pending === -1 ? 0 : pending
  })
  const [slideIndex, setSlideIndex] = useState(0)
  const [seen, setSeen] = useState<Record<string, Set<number>>>(() => {
    const initial: Record<string, Set<number>> = {}
    chapters.forEach((chapter) => {
      initial[chapter.id] = new Set(
        chapter.completed
          ? chapter.slides.map((_, index) => index)
          : Array.from({ length: chapter.slidesViewed }, (_, index) => index),
      )
    })
    return initial
  })
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')

  const chapter = state[chapterIndex]
  const slide = chapter?.slides[slideIndex]

  const firstPendingIndex = useMemo(() => {
    const pending = state.findIndex((item) => !item.completed)
    return pending === -1 ? state.length - 1 : pending
  }, [state])

  const isChapterUnlocked = useCallback(
    (index: number) => previewMode || index <= firstPendingIndex,
    [firstPendingIndex, previewMode],
  )

  // Registrar la diapositiva actual como vista.
  useEffect(() => {
    if (!chapter || !slide) return
    setSeen((current) => {
      const chapterSeen = current[chapter.id] ?? new Set<number>()
      if (chapterSeen.has(slideIndex)) return current
      const next = new Set(chapterSeen)
      next.add(slideIndex)
      return { ...current, [chapter.id]: next }
    })
  }, [chapter, slide, slideIndex])

  const viewedCount = chapter ? (seen[chapter.id]?.size ?? 0) : 0
  const allSlidesSeen = chapter ? viewedCount >= chapter.slides.length : false

  // Precarga la diapositiva anterior y la siguiente (incluida la primera
  // del próximo capítulo) para que la navegación sea instantánea.
  useEffect(() => {
    if (!chapter) return
    const candidates = [
      chapter.slides[slideIndex - 1],
      chapter.slides[slideIndex + 1],
      slideIndex === chapter.slides.length - 1
        ? state[chapterIndex + 1]?.slides[0]
        : undefined,
    ]
    for (const candidate of candidates) {
      if (!candidate?.imageUrl) continue
      const preload = new Image()
      preload.src = candidate.imageUrl
    }
  }, [chapter, chapterIndex, slideIndex, state])

  const persistProgress = useCallback(
    async (targetChapter: DeckChapter, slidesViewed: number) => {
      if (previewMode) return true
      const supabase = getSupabaseBrowserClient()
      if (!supabase) return false
      setSaving(true)
      setError('')
      const { data, error: rpcError } = await supabase.rpc(
        'record_slide_chapter_progress',
        {
          p_enrollment_id: enrollmentId,
          p_segment_id: targetChapter.id,
          p_slides_viewed: slidesViewed,
        },
      )
      setSaving(false)
      if (rpcError) {
        console.error('[campus:slides] No se pudo guardar el avance', rpcError)
        setError('No hemos podido guardar tu avance. Inténtalo de nuevo.')
        return false
      }
      const payload = data as {
        completed?: boolean
        lessonCompleted?: boolean
      } | null
      if (payload?.completed) {
        setState((current) =>
          current.map((item) =>
            item.id === targetChapter.id
              ? { ...item, completed: true, slidesViewed }
              : item,
          ),
        )
      }
      if (payload?.lessonCompleted) onDeckCompleted?.()
      return true
    },
    [enrollmentId, onDeckCompleted, previewMode],
  )

  // Guardado periódico del avance parcial dentro del capítulo.
  useEffect(() => {
    if (!chapter || chapter.completed || previewMode) return
    if (viewedCount === 0 || allSlidesSeen) return
    const timer = window.setTimeout(() => {
      void persistProgress(chapter, viewedCount)
    }, 1500)
    return () => window.clearTimeout(timer)
  }, [allSlidesSeen, chapter, persistProgress, previewMode, viewedCount])

  if (!chapter || !slide) {
    return (
      <section className="panel">
        <p className="muted">Esta presentación todavía no tiene contenido.</p>
      </section>
    )
  }

  const isLastSlide = slideIndex === chapter.slides.length - 1
  const isLastChapter = chapterIndex === state.length - 1

  async function goForward() {
    if (!isLastSlide) {
      setSlideIndex((index) => index + 1)
      return
    }
    const ok = await persistProgress(chapter, chapter.slides.length)
    if (!ok) return
    if (!isLastChapter) {
      setChapterIndex((index) => index + 1)
      setSlideIndex(0)
    }
  }

  function goBack() {
    if (slideIndex > 0) {
      setSlideIndex((index) => index - 1)
      return
    }
    if (chapterIndex > 0) {
      const previous = state[chapterIndex - 1]
      setChapterIndex(chapterIndex - 1)
      setSlideIndex(Math.max(previous.slides.length - 1, 0))
    }
  }

  return (
    <section className="panel slide-deck">
      <div className="panel__header">
        <div>
          <span className="eyebrow">
            Capítulo {chapter.position} de {state.length}
          </span>
          <h2>{chapter.title}</h2>
          {chapter.description ? <p>{chapter.description}</p> : null}
        </div>
        <Presentation color="var(--orange)" size={28} />
      </div>

      {error ? <div className="alert alert--error">{error}</div> : null}

      <div className="slide-deck__stage">
        {slide.imageUrl ? (
          <img
            alt={slide.altText || slide.title}
            height={SLIDE_INTRINSIC_HEIGHT}
            src={slide.imageUrl}
            width={SLIDE_INTRINSIC_WIDTH}
          />
        ) : (
          <div className="slide-deck__placeholder">
            <h3>{slide.title}</h3>
            <p>{slide.body}</p>
          </div>
        )}
      </div>

      <div className="slide-deck__controls">
        <button
          className="button button--outline"
          disabled={chapterIndex === 0 && slideIndex === 0}
          onClick={goBack}
          type="button"
        >
          <ChevronLeft size={16} /> Anterior
        </button>
        <span className="slide-deck__counter">
          Diapositiva {slideIndex + 1} de {chapter.slides.length}
          {chapter.completed ? (
            <>
              {' '}
              · <CheckCircle2 size={14} /> capítulo completado
            </>
          ) : null}
        </span>
        <button
          className="button button--primary"
          disabled={saving || (isLastSlide && isLastChapter && !allSlidesSeen)}
          onClick={() => {
            void goForward()
          }}
          type="button"
        >
          {saving
            ? 'Guardando…'
            : isLastSlide
              ? isLastChapter
                ? 'Terminar presentación'
                : 'Siguiente capítulo'
              : 'Siguiente'}
          <ChevronRight size={16} />
        </button>
      </div>

      <div className="slide-deck__chapters">
        {state.map((item, index) => {
          const unlocked = isChapterUnlocked(index)
          return (
            <button
              className={
                index === chapterIndex
                  ? 'slide-deck__chapter slide-deck__chapter--active'
                  : 'slide-deck__chapter'
              }
              disabled={!unlocked}
              key={item.id}
              onClick={() => {
                setChapterIndex(index)
                setSlideIndex(0)
              }}
              type="button"
            >
              <span>
                {item.completed ? (
                  <CheckCircle2 size={14} />
                ) : unlocked ? (
                  <FileDown size={14} style={{ visibility: 'hidden' }} />
                ) : (
                  <LockKeyhole size={14} />
                )}
                {item.position}. {item.title}
              </span>
              <small>{item.slides.length} diapositivas</small>
            </button>
          )
        })}
      </div>
    </section>
  )
}
