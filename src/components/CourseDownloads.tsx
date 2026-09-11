import { FileText, Presentation } from 'lucide-react'
import type { CourseDownload } from '../lib/course-downloads'

const slotIcons = {
  manual: FileText,
  presentation: Presentation,
} as const

export function CourseDownloads({
  downloads,
}: {
  downloads: CourseDownload[]
}) {
  if (!downloads.length) return null

  return (
    <section className="lesson-downloads" aria-label="Material del curso">
      <h2>Material del curso</h2>
      <div className="lesson-downloads__list">
        {downloads.map((download) => {
          const Icon = slotIcons[download.slot]
          return (
            <article className="lesson-downloads__item" key={download.id}>
              <span className="lesson-downloads__icon" aria-hidden="true">
                <Icon size={20} />
              </span>
              <div>
                <strong>{download.label}</strong>
                <p>{download.title}</p>
              </div>
              <a
                className="button button--outline"
                download={download.downloadable ? '' : undefined}
                href={download.url}
                rel="noreferrer"
                target="_blank"
              >
                {download.downloadable ? 'Descargar PDF' : 'Abrir PDF'}
              </a>
            </article>
          )
        })}
      </div>
    </section>
  )
}
