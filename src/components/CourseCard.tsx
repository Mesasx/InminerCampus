import { Link } from '@tanstack/react-router'
import { CourseInquiryButton } from './CourseInquiryButton'
import { CategoryBadge } from './CategoryBadge'
import { categoryOf } from '../lib/course-category'
import { courseImage } from '../lib/course-image'
import { courseLinkSearch } from '../lib/course-url'
import type { PublicCourse } from '../lib/types'

export function CourseCard({ course }: { course: PublicCourse }) {
  return (
    <article className="course-card">
      <div className="course-card__visual">
        <img alt="" decoding="async" loading="lazy" src={courseImage(course)} />
        <div className="course-card__visual-shade" aria-hidden="true" />
        <CategoryBadge category={categoryOf(course)} />
        <span className="course-card__hours">{course.duration_hours} h</span>
      </div>
      <div className="course-card__body">
        <span className="course-card__modality label-industrial">
          Acceso supervisado
        </span>
        <h3>{course.title}</h3>
        <p>{course.short_description}</p>
        {course.specialty ? (
          <span className="course-card__specialty">{course.specialty}</span>
        ) : null}
        <div className="course-card__footer">
          <CourseInquiryButton
            className="text-link"
            durationHours={course.duration_hours}
            reference={course.accreditation_reference}
            title={course.title}
          />
          <Link
            className="text-link"
            to="/cursos/$courseSlug"
            params={{ courseSlug: course.slug }}
            search={courseLinkSearch(course)}
          >
            Ver introducción →
          </Link>
        </div>
      </div>
    </article>
  )
}
