"use client"
import AppointmentsHeader from "@/components/appointments/appointments-header"
import AppointmentsList from "@/components/appointments/appointments-list"
import AdminLayout from "@/components/layout/admin-layout"
import { useCreateAppointment, useGetAppointmentsWithUser } from "@/hooks/queries/useappointement"
import { TableLoading } from "@/components/ui/loading"
import { DataError } from "@/components/ui/error"

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

        {isLoading ? (
          <TableLoading rows={6} />
        ) : error ? (
          <DataError 
            error={error} 
            onRetry={() => window.location.reload()}
            title="Erreur de chargement des rendez-vous"
            message="Impossible de charger la liste des rendez-vous. Veuillez réessayer."
          />
        ) : appointments ? (
          <AppointmentsList appointments={appointments} />
        ) : null}
      </div>
    </AdminLayout>
  )
}