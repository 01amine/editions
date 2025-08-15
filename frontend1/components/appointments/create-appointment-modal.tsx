"use client";

import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@/components/ui/select";
import { useGetStudents } from "@/hooks/queries/useAuth";
import { useOrdersForStudent } from "@/hooks/queries/useorder";
import { summarizeOrder } from "@/lib/utils";

interface CreateAppointmentModalProps {
  isOpen: boolean;
  onClose: () => void;
  onCreateAppointment: (appointment: any) => void;
}

export default function CreateAppointmentModal({
  isOpen,
  onClose,
  onCreateAppointment
}: CreateAppointmentModalProps) {
  const { data: students, isLoading, error } = useGetStudents(0, 1000);
  console.log(students);
  const [id, setId] = useState("");
  const { data: orders, isLoading: isLoadingOrders, error: errorOrders } = useOrdersForStudent(id);
  console.log(orders);
  const [selectedOrder, setSelectedOrder] = useState("");
  const [appointmentTime, setAppointmentTime] = useState("");
  const [location, setLocation] = useState(
    "Bureau d'impression - Bâtiment A"
  );
if (isLoading) return <p>Chargement...</p>;
if (error) return <p className="text-red-500">Erreur lors du chargement des étudiants</p>;
const isOrdersNotFound = errorOrders && (errorOrders as any)?.response?.status === 404;

  const handleSubmit = () => {
    // if (!id || !selectedOrder || !appointmentTime) {
    //   console.warn("Missing required fields");
    //   return;
    // }
    // onCreateAppointment({
    //   student_id: id,
    //   order_id: selectedOrder,
    //   scheduled_at: appointmentTime,
    //   location
    // });
    onClose();
  };

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
            <Label htmlFor="student" className="text-right">
              Étudiant
            </Label>
            <Select value={id} onValueChange={setId}>
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Sélectionner un étudiant" />
              </SelectTrigger>
              <SelectContent>
                {students?.map((student) => (
                  <SelectItem key={student._id} value={student._id}>
                    {student.full_name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="order" className="text-right">
              Commande
            </Label>
<Select value={selectedOrder} onValueChange={setSelectedOrder}>
  <SelectTrigger className="col-span-3">
    <SelectValue placeholder="Sélectionner une commande" />
  </SelectTrigger>
  <SelectContent>
    {isLoadingOrders && <SelectItem disabled value="loading">Chargement...</SelectItem>}

    {isOrdersNotFound && (
      <SelectItem disabled value="none">Aucune commande disponible</SelectItem>
    )}

    {!isOrdersNotFound && orders?.map((order) => (
      <SelectItem key={order.id} value={order.id}>
        {summarizeOrder(order)}
      </SelectItem>
    ))}
  </SelectContent>
</Select>
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="datetime" className="text-right">
              Date et heure
            </Label>
            <Input
              id="datetime"
              type="datetime-local"
              className="col-span-3"
              value={appointmentTime}
              onChange={(e) => setAppointmentTime(e.target.value)}
            />
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="location" className="text-right">
              Lieu
            </Label>
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
          <Button onClick={handleSubmit}>Créer le rendez-vous</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
