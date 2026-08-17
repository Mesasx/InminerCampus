import { Link } from '@tanstack/react-router'
import { CategoryBadge } from './CategoryBadge'
import { categoryOf } from '../lib/course-category'
import { courseImage } from '../lib/course-image'
import { formatCurrency, modalityLabel } from '../lib/format'
import type { PublicCourse } from '../lib/types'

export function CourseCard({ course }: { course: PublicCourse }) {
  return (
    <article className="course-card">
      <div className="course-card__visual">
        <img alt="" loading="lazy" src={courseImage(course)} />
        <div className="course-card__visual-shade" aria-hidden="true" />
        <CategoryBadge category={categoryOf(course)} />
        <span className="course-card__hours">{course.duration_hours} h</span>
      </div>
      <div className="course-card__body">
        <span className="course-card__modality label-industrial">
          {modalityLabel(course.modality)}
        </span>
        <h3>{course.title}</h3>
        <p>{course.short_description}</p>
        <div className="course-card__footer">
          <span>
            {course.access_mode === 'access_code'
              ? 'Solo con invitación'
              : formatCurrency(course.price_net, course.currency)}
          </span>
          <Link
            className="text-link"
            to="/cursos/$courseSlug"
            params={{ courseSlug: course.slug }}
            search={{ version: course.versionId }}
          >
            Ver curso →
          </Link>
        </div>
      </div>
    </article>
  )
}
