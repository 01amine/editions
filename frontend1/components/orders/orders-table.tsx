"use client"

import { Card, CardContent } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Eye, Clock, Package, Check, Truck, CalendarPlus } from 'lucide-react'
import { useMakeOrderAccepted, useMakeOrderDelivered, useMakeOrderprinted, useMakeOrderrejected } from "@/hooks/queries/useorder"
import { useToast } from "@/hooks/use-toast"
import CreateAppointmentModal from "../appointments/create-appointment-modal"
import { useState } from "react"
import RapidCreateAppointmentModal from "../appointments/rapid-appintemnt-modal"
import OrderDetailsModal from "./order-details-modal"

interface Order {
  _id: string
  student: { full_name: string; email: string }
  item: Array<[{ title: string; material_type: string; price_dzd: number }, number]>
  status: "pending" | "printing" | "ready" | "delivered"
  created_at: string
  appointment_date: string | null
}

interface OrdersTableProps {
  orders: Order[]
}

export default function OrdersTable({ orders }: OrdersTableProps) {
  console.log(orders , "are here")
  const { mutate: makeOrderAccepted } = useMakeOrderAccepted()
  const { mutate: makeOrderPrinted } = useMakeOrderprinted()
  const { mutate: makeOrderDelivered } = useMakeOrderDelivered()
  const { mutate: makeOrderRejected } = useMakeOrderrejected()
  const [open, setOpen] = useState(false);
  
  const { toast } = useToast()
  const [rapidModalOpen, setRapidModalOpen] = useState(false);
  const [rapidStudentId, setRapidStudentId] = useState<string>("");
  const [rapidOrderId, setRapidOrderId] = useState<string>("");

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

  const handleAction = (order: Order, action: "accept" | "print" | "deliver" | "reject") => {
    switch (action) {
      case "accept":
        makeOrderAccepted(order._id, {
          onSuccess: () => toast({ title: "Commande acceptée", description: "La commande est maintenant en cours d'impression." })
        })
        break
      case "print":
        makeOrderPrinted(order._id, {
          onSuccess: () => toast({ title: "Commande imprimée", description: "La commande est prête pour retrait." })
        })
        break
      case "deliver":
        makeOrderDelivered(order._id, {
          onSuccess: () => toast({ title: "Commande livrée", description: "La commande a été livrée avec succès." })
        })
        break
      case "reject":
        makeOrderRejected(order._id, {
          onSuccess: () => toast({ title: "Commande rejetée", description: "La commande a été annulée." })
        })
        break
    }
  }

  const handleCreateAppointment = (order: Order) => {
 
    const studentId = order.student.email 
    setRapidStudentId(studentId);
    setRapidOrderId(order._id);
    setRapidModalOpen(true);
  };
    const handleAppointmentCreated = (appointment: any) => {
    toast({
      title: "Rendez-vous créé",
      description: "Rendez-vous créé avec succès.",
    });
  };
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null)
  const [isOrderDetailsOpen, setIsOrderDetailsOpen] = useState(false)

  const handleViewOrder = (order: Order) => {
    setSelectedOrder(order)
    setIsOrderDetailsOpen(true)
  }
  return (
    <>
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
                    <Button variant="ghost" size="sm" onClick={() => handleViewOrder(order)}>
                      <Eye className="w-4 h-4" />
                    </Button>

                    {order.status === "pending" && (
                      <>
                        <Button 
                          variant="outline" 
                          size="sm" 
                          onClick={() => handleAction(order, "accept")}
                          disabled={false}
                        >
                          Accepter
                        </Button>
                        <Button 
                          variant="destructive" 
                          size="sm" 
                          onClick={() => handleAction(order, "reject")}
                          disabled={false}
                        >
                          Rejeter
                        </Button>
                      </>
                    )}

                    {order.status === "printing" && (
                      <Button 
                        variant="outline" 
                        size="sm" 
                        onClick={() => handleAction(order, "print")}
                        disabled={false}
                      >
                        Marquer prêt
                      </Button>
                    )}

                    {order.status === "ready" && (
                      <Button 
                        variant="outline" 
                        size="sm" 
                        onClick={() => handleAction(order, "deliver")}
                        disabled={false}
                      >
                        Marquer livré
                      </Button>
                    )}

                    <Button variant="secondary" size="sm" onClick={() => handleCreateAppointment(order)}>
                      <CalendarPlus className="w-4 h-4 mr-1" /> Rendez-vous
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
          <RapidCreateAppointmentModal
            isOpen={rapidModalOpen}
            onClose={() => setRapidModalOpen(false)}
            studentId={rapidStudentId}
            orderId={rapidOrderId}
            onCreated={handleAppointmentCreated}
          />

          <OrderDetailsModal
            order={selectedOrder}
            isOpen={isOrderDetailsOpen}
            onClose={() => setIsOrderDetailsOpen(false)}
          />

    </>
  )
}
