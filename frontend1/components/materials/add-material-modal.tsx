"use client";

import { useState } from "react";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useCreateMaterial } from "@/hooks/queries/useMaterial";
import { useToast } from "@/hooks/use-toast";

interface AddMaterialModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function AddMaterialModal({ isOpen, onClose }: AddMaterialModalProps) {
  const { mutate, isPending } = useCreateMaterial();
  const {toast } = useToast();

  const [formData, setFormData] = useState({
    title: "",
    description: "",
    material_type: "",
    price_dzd: 0,
    study_year: "",
    specialite: "",
    module: "",
  });
  const [file, setFile] = useState<File | null>(null);
  const [images, setImages] = useState<File[]>([]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { id, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [id]: id === "price" ? Number(value) : value,
    }));
  };

  const handleSelectChange = (value: string) => {
    setFormData(prev => ({ ...prev, material_type: value }));
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      setFile(e.target.files[0]);
    }
  };

  const handleImagesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      setImages(Array.from(e.target.files));
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.title || !formData.description || !formData.material_type || !file || images.length === 0) {
     toast({
       title: "Veuillez remplir tous les champs",
       variant: "destructive"
       
     })
      return;
    }

    mutate(
      {
        data: {
          ...formData,
          study_year: formData.study_year || '', 
          specialite: formData.specialite || '', 
          module: formData.module || undefined,
        },
        file,
        images,
      },
      {
        onSuccess: () => {
          onClose();
          setFormData({
            title: "",
            description: "",
            material_type: "",
            price_dzd: 0,
            study_year: "",
            specialite: "",
            module: "",
          });
          setFile(null);
          setImages([]);
        },
      }
    );
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle>Ajouter un nouveau support</DialogTitle>
          <DialogDescription>
            Ajoutez un nouveau livre ou document pour les étudiants
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit}>
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="title" className="text-right">Titre</Label>
              <Input id="title" className="col-span-3" value={formData.title} onChange={handleChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="description" className="text-right">Description</Label>
              <Textarea id="description" className="col-span-3" value={formData.description} onChange={handleChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="type" className="text-right">Type</Label>
              <Select value={formData.material_type} onValueChange={handleSelectChange}>
                <SelectTrigger className="col-span-3">
                  <SelectValue placeholder="Sélectionner le type" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="livre">Livre</SelectItem>
                  <SelectItem value="pdf">PDF</SelectItem>
                  <SelectItem value="polycopie">Polycopié</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="price" className="text-right">Prix (DZD)</Label>
              <Input id="price" type="number" className="col-span-3" value={formData.price_dzd} onChange={handleChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="study_year" className="text-right">Année d'étude</Label>
              <Input id="study_year" className="col-span-3" value={formData.study_year} onChange={handleChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="specialite" className="text-right">Spécialité</Label>
              <Input id="specialite" className="col-span-3" value={formData.specialite} onChange={handleChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="module" className="text-right">Module</Label>
              <Input id="module" className="col-span-3" value={formData.module} onChange={handleChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="file" className="text-right">Fichier PDF</Label>
              <Input id="file" type="file" accept=".pdf" className="col-span-3" onChange={handleFileChange} />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="images" className="text-right">Images</Label>
              <Input id="images" type="file" accept="image/*" multiple className="col-span-3" onChange={handleImagesChange} />
            </div>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose}>
              Annuler
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending ? "Ajout en cours..." : "Ajouter"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}