import { Link } from '@tanstack/react-router'
import type { BreadcrumbItem } from '../lib/schema'

/**
 * Migas de pan visibles. El último elemento es la página actual y no enlaza.
 *
 * Los datos estructurados `BreadcrumbList` se emiten aparte, a partir de la
 * misma lista de items, para que lo que ve Google coincida con lo que ve el
 * usuario.
 */
export function Breadcrumbs({ items }: { items: Array<BreadcrumbItem> }) {
  if (items.length < 2) return null

  return (
    <nav aria-label="Migas de pan" className="breadcrumbs">
      <ol>
        {items.map((item, index) => {
          const isCurrent = index === items.length - 1
          return (
            <li key={item.path}>
              {isCurrent ? (
                <span aria-current="page">{item.name}</span>
              ) : (
                <Link to={item.path}>{item.name}</Link>
              )}
            </li>
          )
        })}
      </ol>
    </nav>
  )
}
