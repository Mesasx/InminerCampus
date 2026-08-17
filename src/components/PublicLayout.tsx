import type { ReactNode } from 'react'
import { Footer } from './Footer'
import { PublicHeader } from './PublicHeader'

export function PublicLayout({
  children,
  heroFull = false,
}: {
  children: ReactNode
  heroFull?: boolean
}) {
  return (
    <>
      <PublicHeader heroFull={heroFull} />
      <main className={heroFull ? 'public-main campus-home' : 'public-main page-enter'}>
        {children}
      </main>
      <Footer />
    </>
  )
}
