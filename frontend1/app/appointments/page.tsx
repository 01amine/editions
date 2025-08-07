"use client"

import { useState } from "react"
import AdminLayout from "@/components/layout/admin-layout"
import AppointmentsHeader from "@/components/appointments/appointments-header"
import AppointmentsList from "@/components/appointments/appointments-list"

const mockAppointments = [
  {
    _id: "1",
    student: { _id: "1", full_name: "Ahmed Benali", email: "ahmed@example.com" },
    order_id: "1",
    scheduled_at: "2024-01-20T14:00:00Z",
    location: "Bureau d'impression - Bâtiment A",
    status: "scheduled"
  }
]

export default function AppointmentsPage() {
  const [appointments, setAppointments] = useState(mockAppointments)

  const handleCreateAppointment = (newAppointment: any) => {
    setAppointments([...appointments, { ...newAppointment, _id: Date.now().toString() }])
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <AppointmentsHeader onCreateAppointment={handleCreateAppointment} />
        <AppointmentsList appointments={appointments} />
      </div>
    </AdminLayout>
  )
}
