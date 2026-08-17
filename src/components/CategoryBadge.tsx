import { categoryLabels, type CourseCategory } from '../lib/course-category'

export function CategoryBadge({ category }: { category: CourseCategory }) {
  return (
    <span className={`category-badge category-badge--${category}`}>
      {categoryLabels[category]}
    </span>
  )
}
