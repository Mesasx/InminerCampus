import { AlertTriangle, ListChecks, Lightbulb, Quote } from 'lucide-react'
import type { ReactNode } from 'react'
import {
  isOrderedTone,
  type ExplanationBlock,
  type ExplanationDocument,
  type ExplanationSection,
  type ExplanationTone,
} from '../lib/lesson-explanation'

// Pintado único de la explicación detallada para todo InmínerCampus.
//
// El sistema visual es el del curso de Administración: rótulo de apartado en
// naranja corporativo, cuerpo en tinta normal y ancho de lectura acotado. El
// naranja ordena la jerarquía; no se usa para el texto que hay que leer.

const toneIcons: Partial<Record<ExplanationTone, ReactNode>> = {
  key: <Lightbulb aria-hidden="true" size={16} />,
  warning: <AlertTriangle aria-hidden="true" size={16} />,
  procedure: <ListChecks aria-hidden="true" size={16} />,
  example: <Quote aria-hidden="true" size={16} />,
}

function Blocks({
  blocks,
  ordered,
}: {
  blocks: ExplanationBlock[]
  ordered: boolean
}) {
  return (
    <>
      {blocks.map((block, index) => {
        if (block.type === 'subheading') {
          return <h4 key={`sub-${index}-${block.text}`}>{block.text}</h4>
        }
        if (block.type === 'list') {
          const items = block.items.map((item) => (
            <li key={item}>{item}</li>
          ))
          return block.ordered || ordered ? (
            <ol key={`list-${index}`}>{items}</ol>
          ) : (
            <ul key={`list-${index}`}>{items}</ul>
          )
        }
        return <p key={`text-${index}-${block.text.slice(0, 24)}`}>{block.text}</p>
      })}
    </>
  )
}

function Section({
  section,
  index,
}: {
  section: ExplanationSection
  index: number
}) {
  const { heading, tone } = section
  const ordered = isOrderedTone(tone)

  if (!heading) {
    return (
      <section className="lesson-notes__section" key={`plain-${index}`}>
        <Blocks blocks={section.blocks} ordered={false} />
      </section>
    )
  }

  // La idea clave cierra la unidad: se destaca como aviso, no como otro
  // apartado más, porque es lo que el alumno debe retener.
  if (tone === 'key') {
    return (
      <aside className="lesson-notes__key">
        <strong>
          {toneIcons.key} {heading}
        </strong>
        <Blocks blocks={section.blocks} ordered={false} />
      </aside>
    )
  }

  return (
    <section
      className={`lesson-notes__section lesson-notes__section--${tone}`}
    >
      <h3>
        {toneIcons[tone] ?? null}
        {heading}
      </h3>
      <Blocks blocks={section.blocks} ordered={ordered} />
    </section>
  )
}

export function DetailedExplanation({
  document,
}: {
  document: ExplanationDocument
}) {
  if (!document.sections.length) return null

  return (
    <div className="lesson-notes__content">
      {document.sections.map((section, index) => (
        <Section
          index={index}
          key={`${section.heading ?? 'texto'}-${index}`}
          section={section}
        />
      ))}
    </div>
  )
}
