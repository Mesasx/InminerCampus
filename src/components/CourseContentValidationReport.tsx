import { AlertTriangle, CheckCircle2, Download, RefreshCw } from 'lucide-react'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { resolveSignedUrls } from '../lib/signed-url-cache'
import { getSupabaseBrowserClient } from '../lib/supabase'

type AuditSlide = {
  image_storage_path: string | null
  image_external_url: string | null
}

type AuditNote = {
  summary: string
  approved: boolean
}

type AuditSegment = {
  id: string
  position: number
  lesson_code: string | null
  manual_chapter: string | null
  title: string
  narration_text: string
  audio_storage_path: string | null
  audio_external_url: string | null
  published: boolean
  lesson_segment_slides: AuditSlide[]
  lesson_segment_notes: AuditNote[]
}

type AuditModule = {
  position: number
  lessons: Array<{
    lesson_audio_segments: AuditSegment[]
  }>
}

type AuditMaterial = {
  id: string
  kind: string
  title: string
  storage_path: string | null
  external_url: string | null
  is_published: boolean
}

type AssetState = 'ok' | 'broken' | 'unchecked'

function assetKey(storagePath: string | null, externalUrl: string | null) {
  return storagePath || externalUrl || ''
}

function manualChapterMatches(code: string, manualChapter: string | null) {
  const chapterCode = manualChapter?.match(/\b([1-9]\d*\.(?:10|[1-9]))\b/)?.[1]
  return chapterCode === code
}

function csvCell(value: string | number) {
  return `"${String(value).replaceAll('"', '""')}"`
}

async function runInBatches<T>(
  items: T[],
  batchSize: number,
  operation: (item: T) => Promise<void>,
) {
  for (let index = 0; index < items.length; index += batchSize) {
    await Promise.all(items.slice(index, index + batchSize).map(operation))
  }
}

export function CourseContentValidationReport({
  versionId,
  durationHours,
  onNotice,
}: {
  versionId: string
  durationHours: number
  onNotice: (message: string) => void
}) {
  const [modules, setModules] = useState<AuditModule[]>([])
  const [materials, setMaterials] = useState<AuditMaterial[]>([])
  const [assetStates, setAssetStates] = useState<Record<string, AssetState>>({})
  const [checking, setChecking] = useState(false)

  const load = useCallback(async () => {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    const [contentResponse, materialResponse] = await Promise.all([
      supabase
        .from('course_modules')
        .select(
          'position, lessons(lesson_audio_segments(id, position, lesson_code, manual_chapter, title, narration_text, audio_storage_path, audio_external_url, published, lesson_segment_slides(image_storage_path, image_external_url), lesson_segment_notes(summary, approved)))',
        )
        .eq('course_version_id', versionId)
        .order('position'),
      supabase
        .from('course_materials')
        .select('id, kind, title, storage_path, external_url, is_published')
        .eq('course_version_id', versionId),
    ])
    if (contentResponse.error || materialResponse.error) {
      onNotice('No se ha podido generar el informe de validación.')
      return
    }
    setModules((contentResponse.data ?? []) as unknown as AuditModule[])
    setMaterials((materialResponse.data ?? []) as AuditMaterial[])
    setAssetStates({})
  }, [onNotice, versionId])

  useEffect(() => {
    void load()
  }, [load])

  const segments = useMemo(
    () =>
      modules
        .filter((module) => module.position >= 1 && module.position <= 5)
        .flatMap((module) =>
        (module.lessons ?? []).flatMap((lesson) =>
          (lesson.lesson_audio_segments ?? [])
            .filter((segment) => segment.position >= 1 && segment.position <= 10)
            .map((segment) => ({
              ...segment,
              blockNumber: module.position,
              expectedCode: `${module.position}.${segment.position}`,
            })),
        ),
      ),
    [modules],
  )

  const duplicateAudio = useMemo(() => {
    const counts = new Map<string, number>()
    for (const segment of segments) {
      const key = assetKey(
        segment.audio_storage_path,
        segment.audio_external_url,
      )
      if (key) counts.set(key, (counts.get(key) ?? 0) + 1)
    }
    return new Set(
      [...counts.entries()]
        .filter(([, count]) => count > 1)
        .map(([key]) => key),
    )
  }, [segments])

  const duplicateCodes = useMemo(() => {
    const counts = new Map<string, number>()
    for (const segment of segments) {
      if (segment.lesson_code) {
        counts.set(
          segment.lesson_code,
          (counts.get(segment.lesson_code) ?? 0) + 1,
        )
      }
    }
    return new Set(
      [...counts.entries()]
        .filter(([, count]) => count > 1)
        .map(([code]) => code),
    )
  }, [segments])

  const duplicateSlides = useMemo(() => {
    const counts = new Map<string, number>()
    for (const segment of segments) {
      for (const slide of segment.lesson_segment_slides ?? []) {
        const key = assetKey(slide.image_storage_path, slide.image_external_url)
        if (key) counts.set(key, (counts.get(key) ?? 0) + 1)
      }
    }
    return new Set(
      [...counts.entries()]
        .filter(([, count]) => count > 1)
        .map(([key]) => key),
    )
  }, [segments])

  const rows = useMemo(
    () =>
      segments
        .map((segment) => {
          const code = segment.lesson_code || segment.expectedCode
          const audio = assetKey(
            segment.audio_storage_path,
            segment.audio_external_url,
          )
          const slides = (segment.lesson_segment_slides ?? [])
            .map((slide) =>
              assetKey(slide.image_storage_path, slide.image_external_url),
            )
            .filter(Boolean)
          const explanation = segment.lesson_segment_notes?.[0]
          const incidents: string[] = []
          if (!segment.lesson_code) incidents.push('Sin lessonCode')
          else if (segment.lesson_code !== segment.expectedCode)
            incidents.push(`Código esperado ${segment.expectedCode}`)
          if (segment.lesson_code && duplicateCodes.has(segment.lesson_code))
            incidents.push('lessonCode duplicado')
          if (!audio) incidents.push('Sin audio')
          else if (duplicateAudio.has(audio)) incidents.push('Audio duplicado')
          else if (assetStates[audio] === 'broken')
            incidents.push('Audio inaccesible')
          else if (assetStates[audio] === 'unchecked')
            incidents.push('URL de audio no verificable')
          if (!slides.length) incidents.push('Sin diapositiva')
          else if (slides.some((slide) => duplicateSlides.has(slide)))
            incidents.push('Diapositiva duplicada')
          else if (slides.some((slide) => assetStates[slide] === 'broken'))
            incidents.push('Diapositiva inaccesible')
          else if (slides.some((slide) => assetStates[slide] === 'unchecked'))
            incidents.push('URL de diapositiva no verificable')
          if (!segment.narration_text.trim())
            incidents.push('Sin transcripción')
          if (!manualChapterMatches(code, segment.manual_chapter))
            incidents.push('Capítulo del manual no coincide')
          if (!explanation?.summary.trim() || !explanation.approved)
            incidents.push('Sin explicación aprobada')
          if (!segment.published) incidents.push('Unidad no publicada')
          return {
            id: segment.id,
            code,
            title: segment.title,
            slide: slides.length ? `${slides.length} vinculada(s)` : 'No',
            audio: audio ? 'Sí' : 'No',
            modality: durationHours === 20 ? 'Extendida' : 'Breve',
            transcript: segment.narration_text.trim() ? 'Sí' : 'No',
            manualChapter: segment.manual_chapter || 'No',
            explanation:
              explanation?.summary.trim() && explanation.approved ? 'Sí' : 'No',
            status: incidents.length ? incidents.join('; ') : 'Correcto',
          }
        })
        .sort((a, b) => {
          const [aBlock, aUnit] = a.code.split('.').map(Number)
          const [bBlock, bUnit] = b.code.split('.').map(Number)
          return aBlock - bBlock || aUnit - bUnit
        }),
    [
      assetStates,
      duplicateAudio,
      duplicateCodes,
      duplicateSlides,
      durationHours,
      segments,
    ],
  )

  const incidentCount = rows.filter((row) => row.status !== 'Correcto').length
  const unpublishedMaterials = materials.filter(
    (material) => !material.is_published,
  )
  const duplicateMaterials = useMemo(() => {
    const counts = new Map<string, number>()
    for (const material of materials) {
      const source = assetKey(material.storage_path, material.external_url)
      const key = source || `${material.kind}:${material.title.trim().toLowerCase()}`
      counts.set(key, (counts.get(key) ?? 0) + 1)
    }
    const repeated = new Set(
      [...counts.entries()]
        .filter(([, count]) => count > 1)
        .map(([key]) => key),
    )
    return materials.filter((material) => {
      const source = assetKey(material.storage_path, material.external_url)
      const key = source || `${material.kind}:${material.title.trim().toLowerCase()}`
      return repeated.has(key)
    })
  }, [materials])

  async function verifyAssets() {
    const supabase = getSupabaseBrowserClient()
    if (!supabase) return
    setChecking(true)
    const storagePaths = segments.flatMap((segment) => [
      segment.audio_storage_path,
      ...(segment.lesson_segment_slides ?? []).map(
        (slide) => slide.image_storage_path,
      ),
    ])
    const signedUrls = await resolveSignedUrls(
      supabase,
      'course-materials',
      storagePaths,
      600,
    )
    const targets = segments.flatMap((segment) => [
      [segment.audio_storage_path, segment.audio_external_url] as const,
      ...(segment.lesson_segment_slides ?? []).map(
        (slide) =>
          [slide.image_storage_path, slide.image_external_url] as const,
      ),
    ])
    const uniqueTargets = [
      ...new Map(
        targets
          .filter(([storagePath, externalUrl]) =>
            Boolean(assetKey(storagePath, externalUrl)),
          )
          .map((target) => [assetKey(...target), target]),
      ).values(),
    ]
    const nextStates: Record<string, AssetState> = {}
    await runInBatches(uniqueTargets, 8, async ([storagePath, externalUrl]) => {
      const key = assetKey(storagePath, externalUrl)
      const url = storagePath ? signedUrls[storagePath] : externalUrl
      if (!url) {
        nextStates[key] = 'broken'
        return
      }
      try {
        const response = await fetch(url, { method: 'HEAD' })
        nextStates[key] = response.ok ? 'ok' : 'broken'
      } catch {
        nextStates[key] = externalUrl ? 'unchecked' : 'broken'
      }
    })
    setAssetStates(nextStates)
    setChecking(false)
    onNotice('Comprobación de archivos y URLs completada.')
  }

  function downloadCsv() {
    const headers = [
      'Unidad',
      'Título',
      'Diapositiva vinculada',
      'Audio vinculado',
      'Modalidad del audio',
      'Transcripción vinculada',
      'Capítulo del manual',
      'Explicación detallada',
      'Estado',
    ]
    const csv = [
      headers.map(csvCell).join(','),
      ...rows.map((row) =>
        [
          row.code,
          row.title,
          row.slide,
          row.audio,
          row.modality,
          row.transcript,
          row.manualChapter,
          row.explanation,
          row.status,
        ]
          .map(csvCell)
          .join(','),
      ),
    ].join('\r\n')
    const url = URL.createObjectURL(
      new Blob([`\uFEFF${csv}`], { type: 'text/csv;charset=utf-8' }),
    )
    const anchor = document.createElement('a')
    anchor.href = url
    anchor.download = `informe-contenidos-${durationHours}h.csv`
    anchor.click()
    URL.revokeObjectURL(url)
  }

  return (
    <section className="panel content-audit">
      <div className="panel__header">
        <div>
          <span className="eyebrow">Control editorial y técnico</span>
          <h2>Informe de validación de contenidos</h2>
          <p>
            {rows.length} unidades revisadas · {incidentCount} con incidencias
          </p>
        </div>
        <div className="content-editor__actions">
          <button
            className="button button--outline"
            disabled={checking}
            onClick={() => void verifyAssets()}
            type="button"
          >
            <RefreshCw size={17} />
            {checking ? 'Comprobando…' : 'Verificar archivos y URLs'}
          </button>
          <button
            className="button button--primary"
            disabled={!rows.length}
            onClick={downloadCsv}
            type="button"
          >
            <Download size={17} /> Descargar CSV
          </button>
        </div>
      </div>

      {unpublishedMaterials.length ? (
        <div className="alert alert--info">
          <AlertTriangle size={17} /> {unpublishedMaterials.length} materiales
          no publicados:{' '}
          {unpublishedMaterials.map((item) => item.title).join(', ')}.
        </div>
      ) : null}

      {duplicateMaterials.length ? (
        <div className="alert alert--info">
          <AlertTriangle size={17} /> {duplicateMaterials.length} registros de
          material duplicados: {duplicateMaterials.map((item) => item.title).join(', ')}.
        </div>
      ) : null}

      <div className="content-audit__table-wrap">
        <table className="content-audit__table">
          <thead>
            <tr>
              <th>Unidad</th>
              <th>Título</th>
              <th>Diapositiva</th>
              <th>Audio</th>
              <th>Modalidad</th>
              <th>Transcripción</th>
              <th>Capítulo</th>
              <th>Explicación</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id}>
                <td>
                  <strong>{row.code}</strong>
                </td>
                <td>{row.title}</td>
                <td>{row.slide}</td>
                <td>{row.audio}</td>
                <td>{row.modality}</td>
                <td>{row.transcript}</td>
                <td>{row.manualChapter}</td>
                <td>{row.explanation}</td>
                <td>
                  <span
                    className={
                      row.status === 'Correcto'
                        ? 'content-audit__status is-ok'
                        : 'content-audit__status is-warning'
                    }
                  >
                    {row.status === 'Correcto' ? (
                      <CheckCircle2 size={15} />
                    ) : (
                      <AlertTriangle size={15} />
                    )}
                    {row.status}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  )
}
