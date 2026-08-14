import type { ReactNode } from 'react'
import { Footer } from './Footer'
import { PublicHeader } from './PublicHeader'

export function PublicLayout({
  children,
  editorial = false,
}: {
  children: ReactNode
  editorial?: boolean
}) {
  return (
    <>
      <PublicHeader editorial={editorial} />
      <main className={editorial ? 'campus-home' : 'page-enter'}>{children}</main>
      <Footer />
    </>
  )
}
