import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { CalendarDays } from 'lucide-react'

interface Appointment {
  _id: string
  student: { _id: string; full_name: string; email: string }
  order_id: string
  scheduled_at: string
  location: string
  status: string
}

interface AppointmentsListProps {
  appointments: Appointment[]
}

export default function AppointmentsList({ appointments }: AppointmentsListProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Rendez-vous planifiés</CardTitle>
        <CardDescription>Liste des rendez-vous de récupération</CardDescription>
      </CardHeader>
      <CardContent>
        {appointments.length > 0 ? (
          <div className="space-y-4">
            {appointments.map((appointment) => (
              <div key={appointment._id} className="flex items-center justify-between p-4 border rounded-lg">
                <div className="flex items-center space-x-4">
                  <Avatar>
                    <AvatarFallback>
                      {appointment.student.full_name.split(' ').map(n => n[0]).join('')}
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <p className="font-medium">{appointment.student.full_name}</p>
                    <p className="text-sm text-gray-500">Commande #{appointment.order_id}</p>
                    <p className="text-sm text-gray-500">{appointment.location}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="font-medium">
                    {new Date(appointment.scheduled_at).toLocaleDateString('fr-FR')}
                  </p>
                  <p className="text-sm text-gray-500">
                    {new Date(appointment.scheduled_at).toLocaleTimeString('fr-FR', { 
                      hour: '2-digit', 
                      minute: '2-digit' 
                    })}
                  </p>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-8 text-gray-500">
            <CalendarDays className="w-12 h-12 mx-auto mb-4 text-gray-300" />
            <p>Aucun rendez-vous planifié pour le moment</p>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
