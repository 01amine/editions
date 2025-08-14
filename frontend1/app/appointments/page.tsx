"use client"
import AppointmentsHeader from "@/components/appointments/appointments-header"
import AppointmentsList from "@/components/appointments/appointments-list"
import AdminLayout from "@/components/layout/admin-layout"
import { useCreateAppointment, useGetAppointmentsWithUser } from "@/hooks/queries/useappointement"

export default function AppointmentsPage() {
  const { data: appointments, isLoading, error } = useGetAppointmentsWithUser(0, 10)
  const createAppointment = useCreateAppointment()
  const handleCreateAppointment = (newAppointment: any) => {
    createAppointment.mutate(newAppointment)
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <AppointmentsHeader onCreateAppointment={handleCreateAppointment} />

        {isLoading && <p>Loading appointments...</p>}
        {error && <p className="text-red-500">Failed to load appointments</p>}

        {appointments && <AppointmentsList appointments={appointments} />}
      </div>
    </AdminLayout>
  )
}