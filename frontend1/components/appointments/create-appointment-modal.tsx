"use client"

import { useState } from "react"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

// Mock data
const mockUsers = [
  { _id: "1", full_name: "Ahmed Benali", roles: ["user"] },
  { _id: "2", full_name: "Fatima Zohra", roles: ["user"] }
]

const mockOrders = [
  { _id: "1", status: "ready", item: [{ title: "Anatomie Humaine" }] },
  { _id: "2", status: "ready", item: [{ title: "Pharmacologie" }] }
]

interface CreateAppointmentModalProps {
  isOpen: boolean
  onClose: () => void
  onCreateAppointment: (appointment: any) => void
}

export default function CreateAppointmentModal({ isOpen, onClose, onCreateAppointment }: CreateAppointmentModalProps) {
  const [selectedStudent, setSelectedStudent] = useState("")
  const [selectedOrder, setSelectedOrder] = useState("")
  const [appointmentTime, setAppointmentTime] = useState("")
  const [location, setLocation] = useState("Bureau d'impression - Bâtiment A")

  const handleSubmit = () => {
    const student = mockUsers.find(u => u._id === selectedStudent)
    const newAppointment = {
      student: { _id: selectedStudent, full_name: student?.full_name || "", email: "" },
      order_id: selectedOrder,
      scheduled_at: appointmentTime,
      location,
      status: "scheduled"
    }
    
    onCreateAppointment(newAppointment)
    onClose()
    setSelectedStudent("")
    setSelectedOrder("")
    setAppointmentTime("")
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Créer un nouveau rendez-vous</DialogTitle>
          <DialogDescription>
            Planifiez un rendez-vous pour la récupération d'une commande
          </DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="student" className="text-right">Étudiant</Label>
            <Select value={selectedStudent} onValueChange={setSelectedStudent}>
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Sélectionner un étudiant" />
              </SelectTrigger>
              <SelectContent>
                {mockUsers.filter(u => !u.roles.includes('admin')).map((user) => (
                  <SelectItem key={user._id} value={user._id}>
                    {user.full_name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="order" className="text-right">Commande</Label>
            <Select value={selectedOrder} onValueChange={setSelectedOrder}>
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Sélectionner une commande" />
              </SelectTrigger>
              <SelectContent>
                {mockOrders.filter(o => o.status === "ready").map((order) => (
                  <SelectItem key={order._id} value={order._id}>
                    Commande #{order._id} - {order.item.length} article(s)
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="datetime" className="text-right">Date et heure</Label>
            <Input 
              id="datetime" 
              type="datetime-local" 
              className="col-span-3"
              value={appointmentTime}
              onChange={(e) => setAppointmentTime(e.target.value)}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="location" className="text-right">Lieu</Label>
            <Input 
              id="location" 
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              className="col-span-3"
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>
            Annuler
          </Button>
          <Button onClick={handleSubmit}>
            Créer le rendez-vous
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
