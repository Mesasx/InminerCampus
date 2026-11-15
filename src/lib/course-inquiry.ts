import { appConfig } from './config'

type CourseInquiry = {
  title?: string
  durationHours?: number
  reference?: string | null
}

export function courseInquiryHref(course: CourseInquiry = {}): string {
  if (!appConfig.courseWhatsAppPhone) return '/contacto'

  const details = [
    course.title,
    course.durationHours ? `${course.durationHours} horas` : null,
    course.reference,
  ].filter(Boolean)
  const subject = details.length ? ` sobre ${details.join(' · ')}` : ''
  const message =
    `Hola, contacto desde InmínerCampus. Quisiera recibir más información${subject}. ` +
    '¿Podéis indicarme el alcance, los requisitos y el proceso de acceso?'

  return `https://wa.me/${appConfig.courseWhatsAppPhone}?text=${encodeURIComponent(message)}`
}

export function isWhatsAppInquiryConfigured(): boolean {
  return Boolean(appConfig.courseWhatsAppPhone)
}
