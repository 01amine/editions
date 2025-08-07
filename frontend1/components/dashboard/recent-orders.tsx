import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Clock, Package, Check, Truck } from 'lucide-react'

interface Order {
  _id: string
  student: { full_name: string; email: string }
  item: Array<[{ title: string; material_type: string; price_dzd: number }, number]>
  status: string
  created_at: string
  appointment_date: string | null
}

interface RecentOrdersProps {
  orders: Order[]
}

export default function RecentOrders({ orders }: RecentOrdersProps) {
  const getStatusColor = (status: string) => {
    switch (status) {
      case "pending": return "bg-yellow-100 text-yellow-800"
      case "printing": return "bg-blue-100 text-blue-800"
      case "ready": return "bg-green-100 text-green-800"
      case "delivered": return "bg-gray-100 text-gray-800"
      default: return "bg-gray-100 text-gray-800"
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "pending": return <Clock className="w-4 h-4" />
      case "printing": return <Package className="w-4 h-4" />
      case "ready": return <Check className="w-4 h-4" />
      case "delivered": return <Truck className="w-4 h-4" />
      default: return <Clock className="w-4 h-4" />
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Commandes récentes</CardTitle>
        <CardDescription>Les dernières commandes reçues</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {orders.slice(0, 3).map((order) => (
            <div key={order._id} className="flex items-center justify-between p-4 border rounded-lg">
              <div className="flex items-center space-x-4">
                <Avatar>
                  <AvatarFallback>{order.student.full_name.split(' ').map(n => n[0]).join('')}</AvatarFallback>
                </Avatar>
                <div>
                  <p className="font-medium">{order.student.full_name}</p>
                  <p className="text-sm text-gray-500">{order.item.length} article(s)</p>
                </div>
              </div>
              <div className="flex items-center space-x-2">
                <Badge className={getStatusColor(order.status)}>
                  {getStatusIcon(order.status)}
                  <span className="ml-1 capitalize">{order.status}</span>
                </Badge>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  )
}
