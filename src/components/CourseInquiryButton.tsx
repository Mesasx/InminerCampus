import { MessageCircle } from 'lucide-react'
import { courseInquiryHref } from '../lib/course-inquiry'

export function CourseInquiryButton({
  title,
  durationHours,
  reference,
  className = 'button button--primary',
}: {
  title?: string
  durationHours?: number
  reference?: string | null
  className?: string
}) {
  const href = courseInquiryHref({ title, durationHours, reference })
  const external = href.startsWith('https://wa.me/')

  return (
    <a
      className={className}
      href={href}
      rel={external ? 'noopener noreferrer' : undefined}
      target={external ? '_blank' : undefined}
    >
      <MessageCircle aria-hidden="true" size={18} /> Más información
    </a>
  )
}
