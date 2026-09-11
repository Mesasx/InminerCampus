import {
  ArrowDown,
  ArrowUp,
  Download,
  ExternalLink,
  Eye,
  FileArchive,
  FileText,
  Plus,
  Save,
  Trash2,
  Upload,
  X,
} from 'lucide-react'
import {
  useCallback,
  useEffect,
  useMemo,
  useState,
  type ChangeEvent,
  type FormEvent,
} from 'react'
import { resolveSignedUrls } from '../lib/signed-url-cache'
import { getSupabaseBrowserClient } from '../lib/supabase'

type MaterialKind =
  'manual' | 'presentation' | 'spreadsheet' | 'document' | 'other'

type CourseMaterial = {
  id: string
  kind: MaterialKind
  title: string
  description: string
  storage_path: string | null
  external_url: string | null
  mime_type: string | null
  file_name: string | null
  size_bytes: number | null
  page_count: number | null
  downloadable: boolean
  is_published: boolean
  position: number
}

type MaterialEdit = Pick<
  CourseMaterial,
  | 'kind'
  | 'title'
  | 'description'
  | 'page_count'
  | 'downloadable'
  | 'is_published'
  | 'position'
>

const MAX_MATERIAL_BYTES = 50 * 1024 * 1024
const allowedExtensions = new Set([
  'pdf',
  'ppt',
  'pptx',
  'doc',
  'docx',
  'xls',
  'xlsx',
])

const kindLabels: Record<MaterialKind, string> = {
  manual: 'Libro de texto',
  presentation: 'Presentación del curso',
  spreadsheet: 'Guiones y transcripciones',
  document: 'Documento de apoyo',
  other: 'Material complementario',
}

const emptyDraft: MaterialEdit = {
  kind: 'manual',
  title: '',
  description: '',
  page_count: null,
  downloadable: true,
  is_published: false,
  position: 1,
}

function formatBytes(bytes: number | null) {
  if (!bytes) return ''
  const megabytes = bytes / (1024 * 1024)
  return megabytes >= 1
    ? `${megabytes.toFixed(1)} MB`
    : `${Math.ceil(bytes / 1024)} KB`
}

function extensionOf(fileName: string) {
  return fileName.split('.').pop()?.toLowerCase() ?? ''
}

function inferKind(file: File): MaterialKind {
  const extension = extensionOf(file.name)
  if (extension === 'pdf') return 'manual'
  if (extension === 'ppt' || extension === 'pptx') return 'presentation'
  if (extension === 'xls' || extension === 'xlsx') return 'spreadsheet'
  if (extension === 'doc' || extension === 'docx') return 'document'
  return 'other'
}

function materialEdit(material: CourseMaterial): MaterialEdit {
  return {
    kind: material.kind,
    title: material.title,
    description: material.description,
    page_count: material.page_count,
    downloadable: material.downloadable,
    is_published: material.is_published,
    position: material.position,
  }
}

function downloadableLabel(material: CourseMaterial) {
  if (material.kind === 'manual') return 'Descargar libro de texto'
  const extension = extensionOf(material.file_name ?? '')
  if (
    material.kind === 'presentation' &&
    (extension === 'ppt' || extension === 'pptx')
  ) {
    return 'Descargar PowerPoint'
  }
  return 'Descargar archivo'
}

function validateFile(file: File) {
  if (!allowedExtensions.has(extensionOf(file.name))) {
    return 'Formato no admitido. Usa PDF, PPTX, DOCX o XLSX.'
  }
  if (file.size > MAX_MATERIAL_BYTES) {
    return 'El material supera el límite de 50 MB.'
  }
  return ''
}

export function CourseMaterialsPanel({
  versionId,
  admin = false,
  onNotice,
}: {
  versionId: string
  admin?: boolean
  onNotice?: (message: string) => void
}) {
  const [materials, setMaterials] = useState<CourseMaterial[]>([])
  const [urls, setUrls] = useState<Record<string, string>>({})
  const [edits, setEdits] = useState<Record<string, MaterialEdit>>({})
  const [draft, setDraft] = useState<MaterialEdit>(emptyDraft)
  const [draftFile, setDraftFile] = useState<File | null>(null)
  const [preview, setPreview] = useState<CourseMaterial | null>(null)
  const [busy, setBusy] = useState(false)

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    let query = supabase
      .from('course_materials')
      .select(
        'id, kind, title, description, storage_path, external_url, mime_type, file_name, size_bytes, page_count, downloadable, is_published, position',
      )
      .eq('course_version_id', versionId)
      .order('position')
    if (!admin) query = query.eq('is_published', true)
    const { data, error } = await query

    if (error) {
      if (admin) onNotice?.('No se han podido cargar los materiales del curso.')
      return
    }

    const rows = (data ?? []) as CourseMaterial[]
    setMaterials(rows)
    setEdits(
      Object.fromEntries(
        rows.map((material) => [material.id, materialEdit(material)]),
      ),
    )
    setDraft((current) => ({
      ...current,
      position: Math.max(0, ...rows.map((material) => material.position)) + 1,
    }))
    const storagePaths = rows
      .map((material) => material.storage_path)
      .filter((path): path is string => Boolean(path))
    setUrls(
      storagePaths.length
        ? await resolveSignedUrls(
            supabase,
            'course-materials',
            storagePaths,
            900,
          )
        : {},
    )
  }, [admin, onNotice, versionId])

  useEffect(() => {
    void load()
  }, [load])

  useEffect(() => {
    if (!preview) return
    const close = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setPreview(null)
    }
    window.addEventListener('keydown', close)
    return () => window.removeEventListener('keydown', close)
  }, [preview])

  // El alumno sólo encuentra dos documentos: libro de texto y presentación.
  // El resto sigue guardado y lo sigue viendo y gestionando administración,
  // pero no se ofrece como descarga en el curso.
  const groupedMaterials = useMemo(
    () => ({
      manuals: materials.filter((material) => material.kind === 'manual'),
      presentations: materials.filter(
        (material) => material.kind === 'presentation',
      ),
      supporting: admin
        ? materials.filter(
            (material) =>
              material.kind !== 'manual' && material.kind !== 'presentation',
          )
        : [],
    }),
    [admin, materials],
  )

  function resolvedUrl(material: CourseMaterial) {
    return material.storage_path
      ? (urls[material.storage_path] ?? '')
      : (material.external_url ?? '')
  }

  function updateEdit(id: string, patch: Partial<MaterialEdit>) {
    setEdits((current) => ({
      ...current,
      [id]: { ...current[id], ...patch },
    }))
  }

  async function uploadMaterial(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const form = event.currentTarget
    const supabase = getSupabaseBrowserClient()
    if (!draftFile || !supabase) return
    const validationError = validateFile(draftFile)
    if (validationError) {
      onNotice?.(validationError)
      return
    }

    setBusy(true)
    const id = crypto.randomUUID()
    const path = `${versionId}/materials/${id}.${extensionOf(draftFile.name)}`
    try {
      const { error: uploadError } = await supabase.storage
        .from('course-materials')
        .upload(path, draftFile, { contentType: draftFile.type || undefined })
      if (uploadError) throw uploadError

      const { error } = await supabase.from('course_materials').insert({
        id,
        course_version_id: versionId,
        ...draft,
        title: draft.title.trim() || draftFile.name.replace(/\.[^.]+$/, ''),
        description: draft.description.trim(),
        storage_path: path,
        file_name: draftFile.name,
        mime_type: draftFile.type || null,
        size_bytes: draftFile.size,
      })
      if (error) {
        await supabase.storage.from('course-materials').remove([path])
        throw error
      }

      onNotice?.('Material añadido al curso.')
      setDraftFile(null)
      setDraft({ ...emptyDraft, position: draft.position + 1 })
      form.reset()
      await load()
    } catch (error) {
      console.error('[course-materials] No se pudo subir el material', error)
      onNotice?.('No se ha podido subir y registrar el material.')
    } finally {
      setBusy(false)
    }
  }

  async function saveMaterial(material: CourseMaterial) {
    const supabase = getSupabaseBrowserClient()
    const edit = edits[material.id]
    if (!supabase || !edit) return
    setBusy(true)
    const { error } = await supabase
      .from('course_materials')
      .update({
        ...edit,
        title: edit.title.trim(),
        description: edit.description.trim(),
      })
      .eq('id', material.id)
    onNotice?.(
      error ? 'No se ha podido guardar el material.' : 'Material actualizado.',
    )
    if (!error) await load()
    setBusy(false)
  }

  async function replaceMaterial(
    material: CourseMaterial,
    event: ChangeEvent<HTMLInputElement>,
  ) {
    const file = event.target.files?.[0]
    event.target.value = ''
    const supabase = getSupabaseBrowserClient()
    if (!file || !supabase) return
    const validationError = validateFile(file)
    if (validationError) {
      onNotice?.(validationError)
      return
    }

    setBusy(true)
    const path = `${versionId}/materials/${material.id}-${Date.now()}.${extensionOf(file.name)}`
    try {
      const { error: uploadError } = await supabase.storage
        .from('course-materials')
        .upload(path, file, { contentType: file.type || undefined })
      if (uploadError) throw uploadError

      const { error } = await supabase
        .from('course_materials')
        .update({
          storage_path: path,
          external_url: null,
          file_name: file.name,
          mime_type: file.type || null,
          size_bytes: file.size,
        })
        .eq('id', material.id)
      if (error) {
        await supabase.storage.from('course-materials').remove([path])
        throw error
      }
      if (material.storage_path) {
        await supabase.storage
          .from('course-materials')
          .remove([material.storage_path])
      }
      onNotice?.('Archivo sustituido conservando el registro.')
      await load()
    } catch (error) {
      console.error('[course-materials] No se pudo sustituir el archivo', error)
      onNotice?.('No se ha podido sustituir el archivo.')
    } finally {
      setBusy(false)
    }
  }

  async function moveMaterial(material: CourseMaterial, direction: -1 | 1) {
    const currentIndex = materials.findIndex((item) => item.id === material.id)
    const target = materials[currentIndex + direction]
    const supabase = getSupabaseBrowserClient()
    if (!target || !supabase) return
    setBusy(true)
    const [{ error: firstError }, { error: secondError }] = await Promise.all([
      supabase
        .from('course_materials')
        .update({ position: target.position })
        .eq('id', material.id),
      supabase
        .from('course_materials')
        .update({ position: material.position })
        .eq('id', target.id),
    ])
    onNotice?.(
      firstError || secondError
        ? 'No se ha podido cambiar el orden.'
        : 'Orden actualizado.',
    )
    await load()
    setBusy(false)
  }

  async function removeMaterial(material: CourseMaterial) {
    if (!window.confirm(`¿Retirar “${material.title}”?`)) return
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    setBusy(true)
    const { error } = await supabase
      .from('course_materials')
      .delete()
      .eq('id', material.id)
    if (!error && material.storage_path) {
      await supabase.storage
        .from('course-materials')
        .remove([material.storage_path])
    }
    onNotice?.(
      error ? 'No se ha podido retirar el material.' : 'Material retirado.',
    )
    if (!error) await load()
    setBusy(false)
  }

  function renderMaterial(material: CourseMaterial) {
    const url = resolvedUrl(material)
    const edit = edits[material.id] ?? materialEdit(material)
    const extension = extensionOf(material.file_name ?? '')
    return (
      <article className="course-materials__item" key={material.id}>
        <FileText aria-hidden="true" size={24} />
        <div className="course-materials__copy">
          <div className="course-materials__title-row">
            <span className="eyebrow">{kindLabels[material.kind]}</span>
            {admin ? (
              <span
                className={
                  material.is_published ? 'status status--success' : 'status'
                }
              >
                {material.is_published ? 'Publicado' : 'Oculto'}
              </span>
            ) : null}
          </div>
          <h3>{material.title}</h3>
          {material.description ? <p>{material.description}</p> : null}
          <div className="course-materials__meta">
            {extension ? <span>{extension.toUpperCase()}</span> : null}
            {material.page_count ? (
              <span>{material.page_count} páginas</span>
            ) : null}
            {material.size_bytes ? (
              <span>{formatBytes(material.size_bytes)}</span>
            ) : null}
            <span>Documento de estudio y consulta</span>
          </div>
        </div>
        <div className="course-materials__actions">
          {url &&
          (material.mime_type === 'application/pdf' || extension === 'pdf') ? (
            <button
              className="button button--outline"
              onClick={() => setPreview(material)}
              type="button"
            >
              <Eye size={16} /> Consultar en línea
            </button>
          ) : null}
          {url ? (
            <a
              className="button button--outline"
              href={url}
              rel="noopener noreferrer"
              target="_blank"
            >
              <ExternalLink size={16} /> Abrir en otra pestaña
            </a>
          ) : null}
          {url && material.downloadable ? (
            <a className="button button--primary" download href={url}>
              <Download size={16} /> {downloadableLabel(material)}
            </a>
          ) : null}
          {admin ? (
            <details className="course-materials__editor">
              <summary>Editar recurso</summary>
              <div className="form-grid">
                <div className="content-editor__row">
                  <div className="field">
                    <label htmlFor={`material-kind-${material.id}`}>Tipo</label>
                    <select
                      id={`material-kind-${material.id}`}
                      onChange={(event) =>
                        updateEdit(material.id, {
                          kind: event.target.value as MaterialKind,
                        })
                      }
                      value={edit.kind}
                    >
                      {Object.entries(kindLabels).map(([value, label]) => (
                        <option key={value} value={value}>
                          {label}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="field">
                    <label htmlFor={`material-pages-${material.id}`}>
                      Páginas o diapositivas
                    </label>
                    <input
                      id={`material-pages-${material.id}`}
                      min="1"
                      onChange={(event) =>
                        updateEdit(material.id, {
                          page_count: event.target.value
                            ? Number(event.target.value)
                            : null,
                        })
                      }
                      type="number"
                      value={edit.page_count ?? ''}
                    />
                  </div>
                  <div className="field">
                    <label htmlFor={`material-position-${material.id}`}>
                      Orden
                    </label>
                    <input
                      id={`material-position-${material.id}`}
                      min="1"
                      onChange={(event) =>
                        updateEdit(material.id, {
                          position: Number(event.target.value) || 1,
                        })
                      }
                      type="number"
                      value={edit.position}
                    />
                  </div>
                </div>
                <div className="field">
                  <label htmlFor={`material-title-${material.id}`}>
                    Título
                  </label>
                  <input
                    id={`material-title-${material.id}`}
                    onChange={(event) =>
                      updateEdit(material.id, { title: event.target.value })
                    }
                    required
                    value={edit.title}
                  />
                </div>
                <div className="field">
                  <label htmlFor={`material-description-${material.id}`}>
                    Descripción
                  </label>
                  <textarea
                    id={`material-description-${material.id}`}
                    onChange={(event) =>
                      updateEdit(material.id, {
                        description: event.target.value,
                      })
                    }
                    value={edit.description}
                  />
                </div>
                <div className="content-editor__actions">
                  <label className="content-editor__check">
                    <input
                      checked={edit.is_published}
                      onChange={(event) =>
                        updateEdit(material.id, {
                          is_published: event.target.checked,
                        })
                      }
                      type="checkbox"
                    />
                    Publicado
                  </label>
                  <label className="content-editor__check">
                    <input
                      checked={edit.downloadable}
                      onChange={(event) =>
                        updateEdit(material.id, {
                          downloadable: event.target.checked,
                        })
                      }
                      type="checkbox"
                    />
                    Permitir descarga
                  </label>
                </div>
                <div className="content-editor__actions">
                  <button
                    aria-label="Mover hacia arriba"
                    className="icon-button"
                    disabled={busy || materials[0]?.id === material.id}
                    onClick={() => void moveMaterial(material, -1)}
                    type="button"
                  >
                    <ArrowUp size={17} />
                  </button>
                  <button
                    aria-label="Mover hacia abajo"
                    className="icon-button"
                    disabled={busy || materials.at(-1)?.id === material.id}
                    onClick={() => void moveMaterial(material, 1)}
                    type="button"
                  >
                    <ArrowDown size={17} />
                  </button>
                  <label className="button button--outline">
                    <Upload size={17} /> Sustituir archivo
                    <input
                      accept=".pdf,.ppt,.pptx,.doc,.docx,.xls,.xlsx"
                      disabled={busy}
                      hidden
                      onChange={(event) =>
                        void replaceMaterial(material, event)
                      }
                      type="file"
                    />
                  </label>
                  <button
                    className="button button--primary"
                    disabled={busy}
                    onClick={() => void saveMaterial(material)}
                    type="button"
                  >
                    <Save size={17} /> Guardar
                  </button>
                  <button
                    aria-label={`Retirar ${material.title}`}
                    className="icon-button"
                    disabled={busy}
                    onClick={() => void removeMaterial(material)}
                    type="button"
                  >
                    <Trash2 size={17} />
                  </button>
                </div>
              </div>
            </details>
          ) : null}
        </div>
      </article>
    )
  }

  if (!admin && !materials.length) return null

  const previewUrl = preview ? resolvedUrl(preview) : ''
  return (
    <section
      className="panel course-materials"
      aria-labelledby={`materials-${versionId}`}
    >
      <div className="panel__header">
        <div>
          <span className="eyebrow">Documentación</span>
          <h2 id={`materials-${versionId}`}>Material del curso</h2>
          <p>Documentos oficiales de estudio y consulta de esta formación.</p>
        </div>
        <FileArchive color="var(--orange)" size={30} />
      </div>

      {groupedMaterials.manuals.length ? (
        <div className="course-materials__group">
          <h3>Libro de texto / Manual</h3>
          <div className="course-materials__list">
            {groupedMaterials.manuals.map(renderMaterial)}
          </div>
        </div>
      ) : admin ? (
        <div className="course-materials__group">
          <h3>Libro de texto / Manual</h3>
          <p className="muted">El libro de texto todavía no está publicado.</p>
        </div>
      ) : null}

      {groupedMaterials.presentations.length ? (
        <div className="course-materials__group">
          <h3>Presentación del curso</h3>
          <div className="course-materials__list">
            {groupedMaterials.presentations.map(renderMaterial)}
          </div>
        </div>
      ) : admin ? (
        // Al alumno no se le anuncia un documento que no existe; a quien lo
        // gestiona sí, porque es quien puede subirlo.
        <div className="course-materials__group">
          <h3>Presentación del curso</h3>
          <article className="course-materials__pending">
            <FileText aria-hidden="true" size={22} />
            <div>
              <strong>Presentación del curso</strong>
              <p>
                Próximamente. No existe todavía un archivo publicado válido.
              </p>
            </div>
          </article>
        </div>
      ) : null}

      {groupedMaterials.supporting.length ? (
        <div className="course-materials__group">
          <h3>Documentos complementarios</h3>
          <div className="course-materials__list">
            {groupedMaterials.supporting.map(renderMaterial)}
          </div>
        </div>
      ) : null}

      {admin ? (
        <form
          className="course-materials__new form-grid"
          onSubmit={uploadMaterial}
        >
          <div>
            <span className="eyebrow">Nuevo recurso</span>
            <h3>Añadir material</h3>
          </div>
          <div className="content-editor__row">
            <div className="field">
              <label htmlFor={`new-material-kind-${versionId}`}>Tipo</label>
              <select
                id={`new-material-kind-${versionId}`}
                onChange={(event) =>
                  setDraft((current) => ({
                    ...current,
                    kind: event.target.value as MaterialKind,
                  }))
                }
                value={draft.kind}
              >
                {Object.entries(kindLabels).map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor={`new-material-pages-${versionId}`}>
                Páginas o diapositivas
              </label>
              <input
                id={`new-material-pages-${versionId}`}
                min="1"
                onChange={(event) =>
                  setDraft((current) => ({
                    ...current,
                    page_count: event.target.value
                      ? Number(event.target.value)
                      : null,
                  }))
                }
                type="number"
                value={draft.page_count ?? ''}
              />
            </div>
          </div>
          <div className="field">
            <label htmlFor={`new-material-title-${versionId}`}>Título</label>
            <input
              id={`new-material-title-${versionId}`}
              onChange={(event) =>
                setDraft((current) => ({
                  ...current,
                  title: event.target.value,
                }))
              }
              placeholder="Libro de texto del curso"
              value={draft.title}
            />
          </div>
          <div className="field">
            <label htmlFor={`new-material-description-${versionId}`}>
              Descripción
            </label>
            <textarea
              id={`new-material-description-${versionId}`}
              onChange={(event) =>
                setDraft((current) => ({
                  ...current,
                  description: event.target.value,
                }))
              }
              value={draft.description}
            />
          </div>
          <div className="field">
            <label htmlFor={`new-material-file-${versionId}`}>Archivo</label>
            <input
              accept=".pdf,.ppt,.pptx,.doc,.docx,.xls,.xlsx"
              id={`new-material-file-${versionId}`}
              onChange={(event) => {
                const file = event.target.files?.[0] ?? null
                setDraftFile(file)
                if (file) {
                  setDraft((current) => ({
                    ...current,
                    kind: inferKind(file),
                    title: current.title || file.name.replace(/\.[^.]+$/, ''),
                  }))
                }
              }}
              required
              type="file"
            />
            <small>PDF, PPTX, DOCX o XLSX · máximo 50 MB.</small>
          </div>
          <div className="content-editor__actions">
            <label className="content-editor__check">
              <input
                checked={draft.is_published}
                onChange={(event) =>
                  setDraft((current) => ({
                    ...current,
                    is_published: event.target.checked,
                  }))
                }
                type="checkbox"
              />
              Publicar al guardar
            </label>
            <label className="content-editor__check">
              <input
                checked={draft.downloadable}
                onChange={(event) =>
                  setDraft((current) => ({
                    ...current,
                    downloadable: event.target.checked,
                  }))
                }
                type="checkbox"
              />
              Permitir descarga
            </label>
          </div>
          <button
            className="button button--primary"
            disabled={busy}
            type="submit"
          >
            {busy ? <Upload size={17} /> : <Plus size={17} />}
            {busy ? 'Subiendo…' : 'Añadir material'}
          </button>
        </form>
      ) : null}

      {preview && previewUrl ? (
        <div
          aria-label={`Visor de ${preview.title}`}
          aria-modal="true"
          className="course-materials__modal"
          onClick={() => setPreview(null)}
          role="dialog"
        >
          <div
            className="course-materials__viewer"
            onClick={(event) => event.stopPropagation()}
          >
            <div className="panel__header">
              <div>
                <span className="eyebrow">Consulta en línea</span>
                <h2>{preview.title}</h2>
              </div>
              <button
                aria-label="Cerrar visor"
                className="icon-button"
                onClick={() => setPreview(null)}
                type="button"
              >
                <X size={20} />
              </button>
            </div>
            <iframe src={previewUrl} title={preview.title} />
            <p className="course-materials__viewer-fallback">
              Si el navegador no permite visualizar el PDF, ábrelo en otra
              pestaña o descárgalo.
            </p>
            <div className="content-editor__actions">
              <a
                className="button button--outline"
                href={previewUrl}
                rel="noopener noreferrer"
                target="_blank"
              >
                <ExternalLink size={16} /> Abrir en otra pestaña
              </a>
              {preview.downloadable ? (
                <a
                  className="button button--primary"
                  download
                  href={previewUrl}
                >
                  <Download size={16} /> {downloadableLabel(preview)}
                </a>
              ) : null}
            </div>
          </div>
        </div>
      ) : null}
    </section>
  )
}
