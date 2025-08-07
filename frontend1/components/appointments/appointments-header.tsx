"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Plus } from 'lucide-react'
import CreateAppointmentModal from "./create-appointment-modal"

interface AppointmentsHeaderProps {
  onCreateAppointment: (appointment: any) => void
}

export default function AppointmentsHeader({ onCreateAppointment }: AppointmentsHeaderProps) {
  const [isCreateAppointmentOpen, setIsCreateAppointmentOpen] = useState(false)

  return (
    <>
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-gray-900">Rendez-vous de récupération</h2>
        <Button onClick={() => setIsCreateAppointmentOpen(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Créer un rendez-vous
        </Button>
      </div>
      
      <CreateAppointmentModal 
        isOpen={isCreateAppointmentOpen} 
        onClose={() => setIsCreateAppointmentOpen(false)}
        onCreateAppointment={onCreateAppointment}
      />
    </>
  )
}
