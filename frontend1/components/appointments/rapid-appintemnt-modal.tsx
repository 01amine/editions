"use client";

import React, { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import { useCreateAppointment } from "@/hooks/queries/useappointement";
import { useGetByName } from "@/hooks/queries/useAuth";
import { User } from "@/lib/types/auth";

interface RapidCreateAppointmentModalProps {
  isOpen: boolean;
  onClose: () => void;
  studentId: string;
  orderId: string;
  onCreated?: (appointment?: any) => void;
}

export default function RapidCreateAppointmentModal({
  isOpen,
  onClose,
  studentId,
  orderId,
  onCreated
}: RapidCreateAppointmentModalProps) {
  const { toast } = useToast();
  const [appointmentTime, setAppointmentTime] = useState("");
  const [location, setLocation] = useState("Bureau d'impression - Bâtiment A");

  const { mutate } = useCreateAppointment();
  const {
    data: student,
    isLoading: resolvingStudent,
    isError: studentError,
  } = useGetByName(studentId);
  useEffect(() => {
    if (!isOpen) {
      setAppointmentTime("");
      setLocation("Bureau d'impression - Bâtiment A");
    }
  }, [isOpen]);

  const handleSubmit = () => {
    // validate required fields
    if (!studentId || !orderId) {
      toast({
        title: "Erreur",
        description: "Student ID et Order ID sont requis.",
      });
      return;
    }

    if (!appointmentTime) {
      toast({
        title: "Erreur",
        description: "Veuillez sélectionner la date et l'heure du rendez-vous.",
      });
      return;
    }
    if (resolvingStudent) {
      toast({
        title: "Patientez",
        description: "Récupération des informations de l'étudiant en cours...",
      });
      return;
    }
       if (studentError || !student || !(student as User).email) {
      toast({
        title: "Erreur",
        description:
          "Impossible de trouver l'étudiant à partir du nom fourni. Vérifiez le nom et réessayez.",
      });
      return;
    }


    const payload = {
      student_id: (student as User)._id,
      order_id: orderId,
      scheduled_at: appointmentTime,
      location,
    };

    mutate(payload, {
      onSuccess: (data) => {
        toast({
          title: "Rendez-vous créé",
          description: "Le rendez-vous a été planifié avec succès.",
        });

        onCreated?.(data);
        onClose();
      },
      onError: (error: any) => {
        console.error("create appointment error:", error);
        toast({
          title: "Erreur",
          description:
            (error && (error as any).message) ||
            "Impossible de créer le rendez-vous. Réessayez.",
        });
      },
    });
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => { if (!open) onClose(); }}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Créer un rendez-vous rapide</DialogTitle>
        </DialogHeader>

        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label className="text-right">Étudiant ID</Label>
            <Input readOnly value={studentId} className="col-span-3" />
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label className="text-right">Commande ID</Label>
            <Input readOnly value={orderId} className="col-span-3" />
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label className="text-right">Date et heure</Label>
            <Input
              type="datetime-local"
              value={appointmentTime}
              onChange={(e) => setAppointmentTime(e.target.value)}
              className="col-span-3"
            />
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label className="text-right">Lieu</Label>
            <Input
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              className="col-span-3"
            />
          </div>
                    {resolvingStudent && (
            <div className="col-span-4 text-sm text-muted-foreground">
              Résolution de l'étudiant en cours...
            </div>
          )}
                    {studentError && !resolvingStudent && (
            <div className="col-span-4 text-sm text-red-500">
              Impossible de récupérer l'étudiant. Vérifiez le nom.
            </div>
          )}
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={onClose} >
            Annuler
          </Button>
          <Button onClick={handleSubmit} >
            Créer          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
