import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

interface Notification {
  _id: string
  title: string
  message: string
  type: string
  created_at: string
  read: boolean
}

interface NotificationsListProps {
  notifications: Notification[]
}

export default function NotificationsList({ notifications }: NotificationsListProps) {
  return (
    <div className="space-y-4">
      {notifications.map((notification) => (
        <Card key={notification._id} className={`${!notification.read ? 'border-l-4 border-l-blue-500' : ''}`}>
          <CardContent className="p-4">
            <div className="flex items-start justify-between">
              <div className="flex-1">
                <h3 className="font-semibold text-sm mb-1">{notification.title}</h3>
                <p className="text-sm text-gray-600 mb-2">{notification.message}</p>
                <p className="text-xs text-gray-400">
                  {new Date(notification.created_at).toLocaleString('fr-FR')}
                </p>
              </div>
              {!notification.read && (
                <Badge variant="default" className="ml-4">Nouveau</Badge>
              )}
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  )
}
