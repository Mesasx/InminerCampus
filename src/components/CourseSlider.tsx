import { useEffect, useRef, useState } from 'react'
import { Link } from '@tanstack/react-router'
import { ArrowLeft, ArrowRight } from 'lucide-react'
import { courseImage } from '../lib/course-image'
import { modalityLabel } from '../lib/format'
import type { PublicCourse } from '../lib/types'

function prefersReducedMotion() {
  return (
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches
  )
}

export function CourseSlider({
  courses,
  loading,
  loadError,
}: {
  courses: PublicCourse[]
  loading: boolean
  loadError: boolean
}) {
  const trackRef = useRef<HTMLDivElement>(null)
  const slideRefs = useRef<(HTMLElement | null)[]>([])
  const dragState = useRef<{ startX: number; startScroll: number } | null>(null)
  const [activeIndex, setActiveIndex] = useState(0)
  const [isDragging, setIsDragging] = useState(false)
  const total = courses.length

  useEffect(() => {
    const track = trackRef.current
    if (!track || !total) return

    // IntersectionObserver only reports targets whose ratio crossed a
    // threshold since the last check, not every observed target's current
    // state — so we accumulate ratios across callbacks instead of trusting
    // a single batch of entries to represent every slide.
    const ratios = new Map<Element, number>()

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          ratios.set(entry.target, entry.intersectionRatio)
        })

        let bestIndex = 0
        let bestRatio = -1
        slideRefs.current.slice(0, total).forEach((slide, index) => {
          if (!slide) return
          const ratio = ratios.get(slide) ?? 0
          if (ratio > bestRatio) {
            bestRatio = ratio
            bestIndex = index
          }
        })
        setActiveIndex(bestIndex)
      },
      { root: track, threshold: [0, 0.25, 0.5, 0.75, 1] },
    )

    slideRefs.current.slice(0, total).forEach((slide) => {
      if (slide) observer.observe(slide)
    })

    return () => observer.disconnect()
  }, [total])

  function scrollToIndex(index: number) {
    const clamped = Math.max(0, Math.min(total - 1, index))
    slideRefs.current[clamped]?.scrollIntoView({
      behavior: prefersReducedMotion() ? 'auto' : 'smooth',
      inline: 'start',
      block: 'nearest',
    })
  }

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    if (event.key === 'ArrowRight') {
      event.preventDefault()
      scrollToIndex(activeIndex + 1)
    } else if (event.key === 'ArrowLeft') {
      event.preventDefault()
      scrollToIndex(activeIndex - 1)
    } else if (event.key === 'Home') {
      event.preventDefault()
      scrollToIndex(0)
    } else if (event.key === 'End') {
      event.preventDefault()
      scrollToIndex(total - 1)
    }
  }

  function handlePointerDown(event: React.PointerEvent<HTMLDivElement>) {
    if (event.pointerType !== 'mouse' || !trackRef.current) return
    dragState.current = {
      startX: event.clientX,
      startScroll: trackRef.current.scrollLeft,
    }
    setIsDragging(true)
  }

  function handlePointerMove(event: React.PointerEvent<HTMLDivElement>) {
    if (!dragState.current || !trackRef.current) return
    const delta = event.clientX - dragState.current.startX
    trackRef.current.scrollLeft = dragState.current.startScroll - delta
  }

  function endDrag() {
    dragState.current = null
    setIsDragging(false)
  }

  const position = String(activeIndex + 1).padStart(2, '0')
  const count = String(total || 0).padStart(2, '0')
  const progress = total ? ((activeIndex + 1) / total) * 100 : 0

  return (
    <>
      <div className="course-slider__head">
        <div>
          <span className="campus-section__eyebrow">Nuestra formación</span>
          <h2 className="campus-section__heading">Cursos con criterio técnico.</h2>
        </div>
        {total ? (
          <div className="course-slider__controls">
            <span className="course-slider__counter" aria-hidden="true">
              {position} <i>/</i> {count}
            </span>
            <div className="course-slider__progress" aria-hidden="true">
              <span style={{ width: `${progress}%` }} />
            </div>
            <div className="course-slider__arrows">
              <button
                aria-label="Curso anterior"
                disabled={activeIndex === 0}
                onClick={() => scrollToIndex(activeIndex - 1)}
                type="button"
              >
                <ArrowLeft size={18} />
              </button>
              <button
                aria-label="Curso siguiente"
                disabled={activeIndex === total - 1}
                onClick={() => scrollToIndex(activeIndex + 1)}
                type="button"
              >
                <ArrowRight size={18} />
              </button>
            </div>
          </div>
        ) : null}
      </div>

      {loading ? (
        <div className="course-slider__status" aria-live="polite">
          <p>Catálogo Inmíner</p>
          <h2>Preparando la formación disponible.</h2>
        </div>
      ) : loadError ? (
        <div className="course-slider__status" role="alert">
          <p>Catálogo Inmíner</p>
          <h2>No hemos podido cargar los cursos.</h2>
          <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
            Abrir catálogo <ArrowRight aria-hidden="true" size={17} />
          </Link>
        </div>
      ) : total ? (
        <div
          aria-label="Cursos disponibles"
          aria-roledescription="carousel"
          className="course-slider__track"
          onKeyDown={handleKeyDown}
          onPointerDown={handlePointerDown}
          onPointerLeave={endDrag}
          onPointerMove={handlePointerMove}
          onPointerUp={endDrag}
          ref={trackRef}
          role="region"
          style={isDragging ? { scrollSnapType: 'none' } : undefined}
          tabIndex={0}
        >
          {courses.map((course, index) => (
            <article
              className={`course-slider__slide${index === activeIndex ? ' is-active' : ''}`}
              key={course.versionId}
              ref={(el) => {
                slideRefs.current[index] = el
              }}
            >
              <img
                alt={`Imagen del curso ${course.title}`}
                className="course-slider__image"
                decoding="async"
                draggable={false}
                loading="lazy"
                src={courseImage(course)}
              />
              <div className="course-slider__shade" aria-hidden="true" />
              <div className="course-slider__content">
                <span className="course-slider__eyebrow">
                  {course.specialty ?? 'Formación técnica especializada'}
                </span>
                <h3>{course.title}</h3>
                <p className="course-slider__details">
                  {course.duration_hours} horas · {modalityLabel(course.modality)}
                </p>
                <p className="course-slider__copy">
                  {course.short_description ??
                    'Formación especializada para aplicar el conocimiento técnico con seguridad y criterio profesional.'}
                </p>
                <Link
                  className="editorial-cta editorial-cta--solid"
                  params={{ courseSlug: course.slug }}
                  search={{ version: course.versionId }}
                  to="/cursos/$courseSlug"
                >
                  Ver curso <ArrowRight aria-hidden="true" size={17} />
                </Link>
              </div>
            </article>
          ))}
        </div>
      ) : (
        <div className="course-slider__status">
          <p>Catálogo Inmíner</p>
          <h2>Explora la formación técnica disponible.</h2>
          <Link className="editorial-cta editorial-cta--solid" to="/catalogo">
            Ver todos los cursos <ArrowRight aria-hidden="true" size={17} />
          </Link>
        </div>
      )}
    </>
  )
}
