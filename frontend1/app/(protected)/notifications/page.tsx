"use client"

import AdminLayout from "@/components/layout/admin-layout"
import NotificationsList from "@/components/notifications/notifications-list"

const mockNotifications = [
  {
    _id: "1",
    title: "Nouvelle commande reçue",
    message: "Ahmed Benali a passé une nouvelle commande",
    type: "order",
    created_at: "2024-01-15T10:30:00Z",
    read: false
  },
  {
    _id: "2", 
    title: "Impression terminée",
    message: "L'impression pour Fatima Zohra est prête",
    type: "printing",
    created_at: "2024-01-14T16:45:00Z",
    read: true
  }
]

export default function NotificationsPage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <h2 className="text-2xl font-bold text-gray-900">Notifications</h2>
        <NotificationsList notifications={mockNotifications} />
      </div>
    </AdminLayout>
  )
}
