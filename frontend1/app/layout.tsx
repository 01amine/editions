import type { Metadata } from "next"
import { Inter } from 'next/font/google'
import "./globals.css"
import Provider from "./provider"
import { Toaster } from "@/components/ui/toaster"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Lectio - Administration",
  description: "Plateforme d'administration Lectio",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <Provider>
          <main>
          {children}
          </main>
                  <Toaster />

          </Provider>
        </body>
    </html>
  )
}
