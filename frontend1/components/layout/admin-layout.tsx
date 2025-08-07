"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Calendar, CalendarDays, Users, BookOpen, ShoppingCart, Bell } from 'lucide-react'
import Image from "next/image"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet"
import { Menu } from 'lucide-react'

interface AdminLayoutProps {
  children: React.ReactNode
}

export default function AdminLayout({ children }: AdminLayoutProps) {
  const pathname = usePathname()
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false)

  const navigation = [
    { name: "Tableau de bord", href: "/", icon: Calendar },
    { name: "Commandes", href: "/orders", icon: ShoppingCart },
    { name: "Supports de cours", href: "/materials", icon: BookOpen },
    { name: "Utilisateurs", href: "/users", icon: Users },
    { name: "Rendez-vous", href: "/appointments", icon: CalendarDays },
    { name: "Notifications", href: "/notifications", icon: Bell },
  ]

  const NavigationItems = () => (
    <>
      {navigation.map((item) => {
        const Icon = item.icon
        const isActive = pathname === item.href
        
        return (
          <Link key={item.name} href={item.href} onClick={() => setIsMobileMenuOpen(false)}>
            <Button
              variant={isActive ? "default" : "ghost"}
              className="w-full justify-start"
            >
              <Icon className="w-4 h-4 mr-2" />
              {item.name}
            </Button>
          </Link>
        )
      })}
    </>
  )

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 px-4 lg:px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            {/* Mobile menu button */}
            <Sheet open={isMobileMenuOpen} onOpenChange={setIsMobileMenuOpen}>
              <SheetTrigger asChild>
                <Button variant="ghost" size="icon" className="lg:hidden">
                  <Menu className="w-5 h-5" />
                </Button>
              </SheetTrigger>
              <SheetContent side="left" className="w-64 p-0">
                <div className="flex flex-col h-full">
                  <div className="p-4 border-b">
                    <Image 
                      src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-f5LeSrdR2QWRhYoAV60ml8jY25FJNm.png" 
                      alt="Lectio Logo" 
                      width={120} 
                      height={40}
                      className="h-8 w-auto"
                    />
                  </div>
                  <nav className="flex-1 p-4 space-y-2">
                    <NavigationItems />
                  </nav>
                </div>
              </SheetContent>
            </Sheet>

            <Image 
              src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-f5LeSrdR2QWRhYoAV60ml8jY25FJNm.png" 
              alt="Lectio Logo" 
              width={120} 
              height={40}
              className="h-8 lg:h-10 w-auto"
            />
            <div className="hidden lg:block h-8 w-px bg-gray-300" />
            <h1 className="hidden lg:block text-xl font-semibold text-gray-900">Administration</h1>
          </div>
          <div className="flex items-center space-x-2 lg:space-x-4">
            <Button variant="ghost" size="icon">
              <Bell className="w-5 h-5" />
            </Button>
            <Avatar className="w-8 h-8 lg:w-10 lg:h-10">
              <AvatarImage src="/admin-avatar.png" />
              <AvatarFallback>AD</AvatarFallback>
            </Avatar>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* Desktop Sidebar */}
        <aside className="hidden lg:block w-64 bg-white border-r border-gray-200 min-h-screen">
          <nav className="p-4 space-y-2">
            <NavigationItems />
          </nav>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-4 lg:p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
