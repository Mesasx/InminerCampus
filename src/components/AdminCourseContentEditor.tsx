import {
  FileAudio,
  ImagePlus,
  Layers3,
  Plus,
  Save,
  Upload,
} from 'lucide-react'
import {
  useCallback,
  useEffect,
  useState,
  type ChangeEvent,
  type FormEvent,
} from 'react'
import { getSupabaseBrowserClient } from '../lib/supabase'

type Slide = {
  id: string
  position: number
  title: string
  body: string
  image_storage_path: string | null
  image_external_url: string | null
}

type Segment = {
  id: string
  position: number
  title: string
  narration_text: string
  audio_storage_path: string | null
  audio_external_url: string | null
  duration_seconds: number
  published: boolean
  lesson_segment_slides: Slide[]
}

type Lesson = {
  id: string
  position: number
  title: string
  summary: string
  duration_minutes: number
  lesson_audio_segments: Segment[]
}

type Module = {
  id: string
  position: number
  title: string
  description: string
  lessons: Lesson[]
}

export function AdminCourseContentEditor({
  versionId,
  onNotice,
}: {
  versionId: string
  onNotice: (message: string) => void
}) {
  const [modules, setModules] = useState<Module[]>([])
  const [selectedLessonId, setSelectedLessonId] = useState<string | null>(null)
  const [moduleTitle, setModuleTitle] = useState('')
  const [lessonTitle, setLessonTitle] = useState('')
  const [lessonModuleId, setLessonModuleId] = useState('')
  const [slideDrafts, setSlideDrafts] = useState<
    Record<string, { title: string; body: string }>
  >({})
  const [busy, setBusy] = useState(false)

  const load = useCallback(async () => {
    const { data, error } =
      (await getSupabaseBrowserClient()
        ?.from('course_modules')
        .select(
          'id, position, title, description, lessons(id, position, title, summary, duration_minutes, lesson_audio_segments(id, position, title, narration_text, audio_storage_path, audio_external_url, duration_seconds, published, lesson_segment_slides(id, position, title, body, image_storage_path, image_external_url)))',
        )
        .eq('course_version_id', versionId)
        .order('position', { ascending: true })) ?? {}

    if (error) {
      onNotice('No se ha podido cargar el contenido de la versión.')
      return
    }

    const rows = ((data ?? []) as unknown as Module[]).map((module) => ({
      ...module,
      lessons: [...(module.lessons ?? [])]
        .sort((a, b) => a.position - b.position)
        .map((lesson) => ({
          ...lesson,
          lesson_audio_segments: [...(lesson.lesson_audio_segments ?? [])]
            .sort((a, b) => a.position - b.position)
            .map((segment) => ({
              ...segment,
              lesson_segment_slides: [
                ...(segment.lesson_segment_slides ?? []),
              ].sort((a, b) => a.position - b.position),
            })),
        })),
    }))

    setModules(rows)
    setLessonModuleId((current) => current || rows[0]?.id || '')
    setSelectedLessonId((current) => {
      if (current && rows.some((m) => m.lessons.some((l) => l.id === current))) {
        return current
      }
      return rows[0]?.lessons[0]?.id ?? null
    })
  }, [onNotice, versionId])

  useEffect(() => {
    void load()
  }, [load])

  const selectedLesson = modules
    .flatMap((module) => module.lessons)
    .find((lesson) => lesson.id === selectedLessonId)

  async function createModule(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const position = Math.max(0, ...modules.map((module) => module.position)) + 1
    const { error } =
      (await getSupabaseBrowserClient()?.from('course_modules').insert({
        course_version_id: versionId,
        position,
        title: moduleTitle.trim(),
        description: '',
      })) ?? {}
    if (error) {
      onNotice('No se ha podido crear el módulo.')
      return
    }
    setModuleTitle('')
    onNotice('Módulo creado.')
    await load()
  }

  async function createLesson(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const module = modules.find((item) => item.id === lessonModuleId)
    if (!module) return
    const position =
      Math.max(0, ...module.lessons.map((lesson) => lesson.position)) + 1
    const { data, error } =
      (await getSupabaseBrowserClient()
        ?.from('lessons')
        .insert({
          module_id: module.id,
          position,
          title: lessonTitle.trim(),
          summary: '',
          kind: 'mixed',
          duration_minutes: 10,
          sequential_required: true,
          active: true,
        })
        .select('id')
        .single()) ?? {}
    if (error || !data) {
      onNotice('No se ha podido crear la lección.')
      return
    }
    setLessonTitle('')
    setSelectedLessonId(data.id)
    onNotice('Lección creada. Ya puedes preparar sus diez partes.')
    await load()
  }

  async function createTenSegments() {
    if (!selectedLesson) return
    const occupied = new Set(
      selectedLesson.lesson_audio_segments.map((segment) => segment.position),
    )
    const rows = Array.from({ length: 10 }, (_, index) => index + 1)
      .filter((position) => !occupied.has(position))
      .map((position) => ({
        lesson_id: selectedLesson.id,
        position,
        title: `Parte ${position}`,
        narration_text: '',
        duration_seconds: 120,
        published: false,
      }))
    if (!rows.length) {
      onNotice('Esta lección ya tiene sus diez partes.')
      return
    }
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('lesson_audio_segments')
        .insert(rows)) ?? {}
    onNotice(
      error
        ? 'No se ha podido crear la estructura de audio.'
        : 'Estructura de diez partes creada como borrador.',
    )
    if (!error) await load()
  }

  function updateSegment(id: string, patch: Partial<Segment>) {
    setModules((current) =>
      current.map((module) => ({
        ...module,
        lessons: module.lessons.map((lesson) => ({
          ...lesson,
          lesson_audio_segments: lesson.lesson_audio_segments.map((segment) =>
            segment.id === id ? { ...segment, ...patch } : segment,
          ),
        })),
      })),
    )
  }

  async function saveSegment(segment: Segment) {
    setBusy(true)
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('lesson_audio_segments')
        .update({
          title: segment.title.trim(),
          narration_text: segment.narration_text.trim(),
          duration_seconds: segment.duration_seconds,
          audio_external_url: segment.audio_external_url?.trim() || null,
          published: segment.published,
        })
        .eq('id', segment.id)) ?? {}
    setBusy(false)
    onNotice(
      error
        ? segment.published &&
          !segment.audio_storage_path &&
          !segment.audio_external_url
          ? 'Añade un audio antes de publicar la parte.'
          : 'No se ha podido guardar la parte.'
        : `Parte ${segment.position} guardada.`,
    )
    if (!error) await load()
  }

  async function uploadAudio(
    segment: Segment,
    event: ChangeEvent<HTMLInputElement>,
  ) {
    const file = event.target.files?.[0]
    const supabase = getSupabaseBrowserClient()
    if (!file || !supabase || !selectedLesson) return
    setBusy(true)
    const extension = file.name.split('.').pop()?.toLowerCase() || 'mp3'
    const path = `${versionId}/${selectedLesson.id}/audio/${segment.id}.${extension}`
    const { error: uploadError } = await supabase.storage
      .from('course-materials')
      .upload(path, file, { upsert: true, contentType: file.type })
    if (uploadError) {
      setBusy(false)
      onNotice('No se ha podido subir el audio.')
      return
    }
    const { error } = await supabase
      .from('lesson_audio_segments')
      .update({ audio_storage_path: path, audio_external_url: null })
      .eq('id', segment.id)
    setBusy(false)
    onNotice(error ? 'El audio subió, pero no pudo asociarse.' : 'Audio cargado.')
    if (!error) await load()
  }

  async function addSlide(
    event: FormEvent<HTMLFormElement>,
    segment: Segment,
  ) {
    event.preventDefault()
    const draft = slideDrafts[segment.id]
    if (!draft?.title.trim()) return
    const position =
      Math.max(
        0,
        ...segment.lesson_segment_slides.map((slide) => slide.position),
      ) + 1
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('lesson_segment_slides')
        .insert({
          segment_id: segment.id,
          position,
          title: draft.title.trim(),
          body: draft.body.trim(),
        })) ?? {}
    if (error) {
      onNotice('No se ha podido añadir la diapositiva.')
      return
    }
    setSlideDrafts((current) => ({
      ...current,
      [segment.id]: { title: '', body: '' },
    }))
    onNotice('Diapositiva añadida.')
    await load()
  }

  function updateSlide(id: string, patch: Partial<Slide>) {
    setModules((current) =>
      current.map((module) => ({
        ...module,
        lessons: module.lessons.map((lesson) => ({
          ...lesson,
          lesson_audio_segments: lesson.lesson_audio_segments.map((segment) => ({
            ...segment,
            lesson_segment_slides: segment.lesson_segment_slides.map((slide) =>
              slide.id === id ? { ...slide, ...patch } : slide,
            ),
          })),
        })),
      })),
    )
  }

  async function saveSlide(slide: Slide) {
    const { error } =
      (await getSupabaseBrowserClient()
        ?.from('lesson_segment_slides')
        .update({
          title: slide.title.trim(),
          body: slide.body.trim(),
          image_external_url: slide.image_external_url?.trim() || null,
        })
        .eq('id', slide.id)) ?? {}
    onNotice(
      error
        ? 'No se ha podido guardar la diapositiva.'
        : 'Diapositiva actualizada.',
    )
    if (!error) await load()
  }

  async function uploadSlideImage(
    slide: Slide,
    event: ChangeEvent<HTMLInputElement>,
  ) {
    const file = event.target.files?.[0]
    const supabase = getSupabaseBrowserClient()
    if (!file || !supabase || !selectedLesson) return
    setBusy(true)
    const extension = file.name.split('.').pop()?.toLowerCase() || 'jpg'
    const path = `${versionId}/${selectedLesson.id}/slides/${slide.id}.${extension}`
    const { error: uploadError } = await supabase.storage
      .from('course-materials')
      .upload(path, file, { upsert: true, contentType: file.type })
    if (!uploadError) {
      await supabase
        .from('lesson_segment_slides')
        .update({ image_storage_path: path, image_external_url: null })
        .eq('id', slide.id)
    }
    setBusy(false)
    onNotice(
      uploadError ? 'No se ha podido subir la imagen.' : 'Imagen añadida.',
    )
    if (!uploadError) await load()
  }

  return (
    <section className="panel course-content-editor">
      <div className="panel__header">
        <div>
          <span className="eyebrow">Temario y lecciones</span>
          <h2>Contenido de la versión</h2>
        </div>
        <Layers3 color="var(--orange)" />
      </div>

      <div className="content-editor__create">
        <form className="form-grid" onSubmit={createModule}>
          <div className="field">
            <label htmlFor={`module-${versionId}`}>Nuevo módulo</label>
            <input
              id={`module-${versionId}`}
              minLength={1}
              required
              value={moduleTitle}
              onChange={(event) => setModuleTitle(event.target.value)}
              placeholder="Nombre del módulo"
            />
          </div>
          <button className="button button--outline" type="submit">
            <Plus size={17} /> Añadir módulo
          </button>
        </form>
        <form className="form-grid" onSubmit={createLesson}>
          <div className="field">
            <label htmlFor={`lesson-module-${versionId}`}>Módulo</label>
            <select
              id={`lesson-module-${versionId}`}
              required
              value={lessonModuleId}
              onChange={(event) => setLessonModuleId(event.target.value)}
            >
              <option value="">Selecciona un módulo</option>
              {modules.map((module) => (
                <option key={module.id} value={module.id}>
                  {module.position}. {module.title}
                </option>
              ))}
            </select>
          </div>
          <div className="field">
            <label htmlFor={`lesson-${versionId}`}>Nueva lección</label>
            <input
              id={`lesson-${versionId}`}
              minLength={1}
              required
              value={lessonTitle}
              onChange={(event) => setLessonTitle(event.target.value)}
              placeholder="Nombre de la lección"
            />
          </div>
          <button className="button button--outline" type="submit">
            <Plus size={17} /> Añadir lección
          </button>
        </form>
      </div>

      <div className="content-editor__layout">
        <aside className="content-editor__tree" aria-label="Lecciones">
          {modules.map((module) => (
            <div key={module.id}>
              <strong>
                {module.position}. {module.title}
              </strong>
              {module.lessons.map((lesson) => (
                <button
                  className={
                    lesson.id === selectedLessonId
                      ? 'content-editor__lesson is-active'
                      : 'content-editor__lesson'
                  }
                  key={lesson.id}
                  onClick={() => setSelectedLessonId(lesson.id)}
                  type="button"
                >
                  {lesson.position}. {lesson.title}
                </button>
              ))}
            </div>
          ))}
        </aside>

        <div className="content-editor__workspace">
          {selectedLesson ? (
            <>
              <div className="panel__header">
                <div>
                  <span className="eyebrow">Lección seleccionada</span>
                  <h3>{selectedLesson.title}</h3>
                </div>
                <button
                  className="button button--primary"
                  onClick={createTenSegments}
                  type="button"
                >
                  <FileAudio size={18} /> Preparar 10 partes
                </button>
              </div>
              <p className="muted">
                Cada parte contiene un audio secuencial. Solo se puede
                publicar cuando tenga un archivo o una URL de audio.
              </p>
              <div className="audio-segment-editor">
                {selectedLesson.lesson_audio_segments.map((segment) => {
                  const draft = slideDrafts[segment.id] ?? {
                    title: '',
                    body: '',
                  }
                  return (
                    <article className="audio-segment-card" key={segment.id}>
                      <div className="audio-segment-card__heading">
                        <span className="app-course__number">
                          {segment.position}
                        </span>
                        <strong>{segment.title}</strong>
                        <span className="status">
                          {segment.published ? 'Publicado' : 'Borrador'}
                        </span>
                      </div>
                      <div className="form-grid">
                        <div className="field">
                          <label htmlFor={`segment-title-${segment.id}`}>
                            Título de la parte
                          </label>
                          <input
                            id={`segment-title-${segment.id}`}
                            value={segment.title}
                            onChange={(event) =>
                              updateSegment(segment.id, {
                                title: event.target.value,
                              })
                            }
                          />
                        </div>
                        <div className="field">
                          <label htmlFor={`segment-script-${segment.id}`}>
                            Guion de narración
                          </label>
                          <textarea
                            id={`segment-script-${segment.id}`}
                            value={segment.narration_text}
                            onChange={(event) =>
                              updateSegment(segment.id, {
                                narration_text: event.target.value,
                              })
                            }
                            placeholder="Texto específico que se grabará en este audio…"
                          />
                        </div>
                        <div className="content-editor__row">
                          <div className="field">
                            <label htmlFor={`segment-duration-${segment.id}`}>
                              Duración (segundos)
                            </label>
                            <input
                              id={`segment-duration-${segment.id}`}
                              max={1800}
                              min={1}
                              type="number"
                              value={segment.duration_seconds}
                              onChange={(event) =>
                                updateSegment(segment.id, {
                                  duration_seconds:
                                    Number(event.target.value) || 120,
                                })
                              }
                            />
                          </div>
                          <div className="field">
                            <label htmlFor={`segment-url-${segment.id}`}>
                              URL de audio
                            </label>
                            <input
                              id={`segment-url-${segment.id}`}
                              type="url"
                              value={segment.audio_external_url ?? ''}
                              onChange={(event) =>
                                updateSegment(segment.id, {
                                  audio_external_url: event.target.value,
                                })
                              }
                              placeholder="https://…"
                            />
                          </div>
                        </div>
                        <div className="content-editor__actions">
                          <label className="button button--outline">
                            <Upload size={17} />
                            {segment.audio_storage_path
                              ? 'Sustituir audio'
                              : 'Subir audio'}
                            <input
                              accept="audio/*"
                              hidden
                              onChange={(event) =>
                                uploadAudio(segment, event)
                              }
                              type="file"
                            />
                          </label>
                          <label className="content-editor__check">
                            <input
                              checked={segment.published}
                              onChange={(event) =>
                                updateSegment(segment.id, {
                                  published: event.target.checked,
                                })
                              }
                              type="checkbox"
                            />
                            Publicado
                          </label>
                          <button
                            className="button button--primary"
                            disabled={busy}
                            onClick={() => saveSegment(segment)}
                            type="button"
                          >
                            <Save size={17} /> Guardar parte
                          </button>
                        </div>
                      </div>

                      <div className="slide-editor">
                        <strong>Diapositivas bajo este audio</strong>
                        {segment.lesson_segment_slides.map((slide) => (
                          <div className="slide-editor__item" key={slide.id}>
                            <div className="slide-editor__fields">
                              <strong>Diapositiva {slide.position}</strong>
                              <input
                                aria-label={`Título de la diapositiva ${slide.position}`}
                                value={slide.title}
                                onChange={(event) =>
                                  updateSlide(slide.id, {
                                    title: event.target.value,
                                  })
                                }
                              />
                              <textarea
                                aria-label={`Contenido de la diapositiva ${slide.position}`}
                                value={slide.body}
                                onChange={(event) =>
                                  updateSlide(slide.id, {
                                    body: event.target.value,
                                  })
                                }
                              />
                            </div>
                            <div className="content-editor__actions">
                              <label className="button button--outline">
                                <ImagePlus size={16} />
                                {slide.image_storage_path
                                  ? 'Cambiar imagen'
                                  : 'Añadir imagen'}
                                <input
                                  accept="image/*"
                                  hidden
                                  onChange={(event) =>
                                    uploadSlideImage(slide, event)
                                  }
                                  type="file"
                                />
                              </label>
                              <button
                                className="button button--primary"
                                onClick={() => saveSlide(slide)}
                                type="button"
                              >
                                <Save size={16} /> Guardar
                              </button>
                            </div>
                          </div>
                        ))}
                        <form
                          className="slide-editor__form"
                          onSubmit={(event) => addSlide(event, segment)}
                        >
                          <input
                            aria-label="Título de la diapositiva"
                            required
                            value={draft.title}
                            onChange={(event) =>
                              setSlideDrafts((current) => ({
                                ...current,
                                [segment.id]: {
                                  ...draft,
                                  title: event.target.value,
                                },
                              }))
                            }
                            placeholder="Título de la diapositiva"
                          />
                          <textarea
                            aria-label="Contenido de la diapositiva"
                            value={draft.body}
                            onChange={(event) =>
                              setSlideDrafts((current) => ({
                                ...current,
                                [segment.id]: {
                                  ...draft,
                                  body: event.target.value,
                                },
                              }))
                            }
                            placeholder="Ideas clave que verá el alumno"
                          />
                          <button className="button button--outline" type="submit">
                            <Plus size={16} /> Añadir diapositiva
                          </button>
                        </form>
                      </div>
                    </article>
                  )
                })}
              </div>
            </>
          ) : (
            <div className="empty-state">
              <p>Crea o selecciona una lección para preparar su contenido.</p>
            </div>
          )}
        </div>
      </div>
    </section>
  )
}
