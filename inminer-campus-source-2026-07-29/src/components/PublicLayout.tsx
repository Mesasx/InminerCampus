import type { ReactNode } from 'react'
import { Footer } from './Footer'
import { PublicHeader } from './PublicHeader'

export function PublicLayout({ children }: { children: ReactNode }) {
  return (
    <>
      <PublicHeader />
      <main className="page-enter">{children}</main>
      <Footer />
    </>
  )
}
