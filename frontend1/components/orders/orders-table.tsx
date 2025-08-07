import { Card, CardContent } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Eye, Clock, Package, Check, Truck } from 'lucide-react'

interface Order {
  _id: string
  student: { full_name: string; email: string }
  item: Array<[{ title: string; material_type: string; price_dzd: number }, number]>
  status: string
  created_at: string
  appointment_date: string | null
}

interface OrdersTableProps {
  orders: Order[]
}

export default function OrdersTable({ orders }: OrdersTableProps) {
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
      <CardContent className="p-0">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Étudiant</TableHead>
              <TableHead>Articles</TableHead>
              <TableHead>Statut</TableHead>
              <TableHead>Date de commande</TableHead>
              <TableHead>Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {orders.map((order) => (
              <TableRow key={order._id}>
                <TableCell>
                  <div className="flex items-center space-x-3">
                    <Avatar className="w-8 h-8">
                      <AvatarFallback className="text-xs">
                        {order.student.full_name.split(' ').map(n => n[0]).join('')}
                      </AvatarFallback>
                    </Avatar>
                    <div>
                      <p className="font-medium">{order.student.full_name}</p>
                      <p className="text-sm text-gray-500">{order.student.email}</p>
                    </div>
                  </div>
                </TableCell>
                <TableCell>
                  <div className="space-y-1">
                    {order.item.map((item, index) => (
                      <div key={index} className="text-sm">
                        <span className="font-medium">{item[0].title}</span>
                        <span className="text-gray-500"> (x{item[1]})</span>
                      </div>
                    ))}
                  </div>
                </TableCell>
                <TableCell>
                  <Badge className={getStatusColor(order.status)}>
                    {getStatusIcon(order.status)}
                    <span className="ml-1 capitalize">{order.status}</span>
                  </Badge>
                </TableCell>
                <TableCell>
                  {new Date(order.created_at).toLocaleDateString('fr-FR')}
                </TableCell>
                <TableCell>
                  <div className="flex items-center space-x-2">
                    <Button variant="ghost" size="sm">
                      <Eye className="w-4 h-4" />
                    </Button>
                    {order.status === "pending" && (
                      <Button variant="outline" size="sm">
                        Accepter
                      </Button>
                    )}
                    {order.status === "printing" && (
                      <Button variant="outline" size="sm">
                        Marquer prêt
                      </Button>
                    )}
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  )
}
