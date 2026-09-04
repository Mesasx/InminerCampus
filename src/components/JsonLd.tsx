import { jsonLdGraph, type JsonLd as JsonLdNode } from '../lib/schema'

/**
 * Inserta un bloque de datos estructurados en el cuerpo de la página.
 *
 * Se renderiza dentro del árbol de componentes (y no en `head`) porque así
 * forma parte del HTML del SSR sin depender de la hidratación, que es
 * justamente lo que necesita el rastreador.
 */
export function JsonLd({ nodes }: { nodes: Array<JsonLdNode> }) {
  if (!nodes.length) return null

  // `JSON.stringify` no escapa `<`, así que un dato que contuviese la
  // secuencia `</script>` cerraría la etiqueta antes de tiempo. Escaparlo como
  // `<` es equivalente para el parser de JSON y neutraliza el caso.
  const json = jsonLdGraph(nodes).replace(/</g, '\\u003c')

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: json }}
    />
  )
}
