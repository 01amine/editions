"use client"

import { useEditMaterial, useGetMaterialById } from "@/hooks/queries/useMaterial"
import { MaterialsAdmin } from "@/lib/types/material"
import { useParams, useRouter } from "next/navigation"
import AdminLayout from "@/components/layout/admin-layout"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { ImageIcon, FileTextIcon, Save, Trash2, ArrowLeft } from 'lucide-react'
import Image from "next/image"
import { useState, useEffect } from "react"
import { useToast } from "@/components/ui/use-toast"

export default function MaterialDetailPage() {
  const { id } = useParams<{ id: string }>()
  const router = useRouter()
  const { data: material, isLoading, isError } = useGetMaterialById(id)
  const { mutate, isPending } = useEditMaterial()
  const { toast } = useToast()

  const [formData, setFormData] = useState<Partial<MaterialsAdmin>>({
    title: "",
    description: "",
    price_dzd: 0,
    material_type: "",
    study_year: "",
    specialite: "",
    module: "",
    image_urls: [],
    pdf_url: ""
  })

  useEffect(() => {
    if (material) {
      setFormData({
        title: material.title,
        description: material.description,
        price_dzd: material.price_dzd,
        material_type: material.material_type,
        study_year: material.study_year,
        specialite: material.specialite,
        module: material.module,
        image_urls: material.image_urls,
        pdf_url: material.pdf_url,
      })
    }
  }, [material])

  if (isLoading) return <AdminLayout><div className="flex justify-center items-center h-screen">Loading...</div></AdminLayout>
  if (isError || !material) return <AdminLayout><div className="flex justify-center items-center h-screen text-red-500">Failed to load material.</div></AdminLayout>

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { id, value } = e.target
    setFormData(prev => ({
      ...prev,
      [id]: id === "price_dzd" ? Number(value) : value
    }))
  }

  const handleSelectChange = (value: string) => {
    setFormData(prev => ({
      ...prev,
      material_type: value
    }))
  }

  const handleImageRemove = (urlToRemove: string) => {
    setFormData(prev => ({
      ...prev,
      image_urls: prev.image_urls?.filter(url => url !== urlToRemove)
    }))
  }
  
  const handleFileRemove = () => {
      setFormData(prev => ({
          ...prev,
          pdf_url: ""
      }))
  }

  const handleUpdate = () => {
    mutate({ id, data: formData }, {
      onSuccess: () => {
        toast({
          title: "Success! 🎉",
          description: "Material updated successfully.",
        })
      },
      onError: () => {
        toast({
          title: "Error! 😞",
          description: "Failed to update material.",
          variant: "destructive",
        })
      }
    })
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <Button variant="ghost" onClick={() => router.back()}>
            <ArrowLeft className="w-4 h-4 mr-2" /> Retour
          </Button>
          <h1 className="text-2xl font-bold">Modifier le support</h1>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Détails du support</CardTitle>
          </CardHeader>
          <CardContent className="grid gap-4 py-4">
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="title" className="md:text-right">Titre</Label>
              <Input 
                id="title" 
                className="col-span-3" 
                value={formData.title} 
                onChange={handleChange} 
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="description" className="md:text-right">Description</Label>
              <Textarea 
                id="description" 
                className="col-span-3" 
                value={formData.description} 
                onChange={handleChange} 
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="material_type" className="md:text-right">Type</Label>
              <Select 
                value={formData.material_type} 
                onValueChange={handleSelectChange}
              >
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
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="price_dzd" className="md:text-right">Prix (DZD)</Label>
              <Input 
                id="price_dzd" 
                type="number" 
                className="col-span-3" 
                value={formData.price_dzd} 
                onChange={handleChange} 
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="study_year" className="md:text-right">Année d'étude</Label>
              <Input 
                id="study_year" 
                className="col-span-3" 
                value={formData.study_year}
                onChange={handleChange}
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="specialite" className="md:text-right">Spécialité</Label>
              <Input 
                id="specialite" 
                className="col-span-3" 
                value={formData.specialite}
                onChange={handleChange}
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="module" className="md:text-right">Module</Label>
              <Input 
                id="module" 
                className="col-span-3" 
                value={formData.module}
                onChange={handleChange}
              />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <ImageIcon className="w-5 h-5" /> Images
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap gap-2 mb-4">
              {
              formData.image_urls?.length > 0 ? (
                formData.image_urls.map((url, index) => (
                  <div key={index} className="relative w-24 h-24 rounded-md overflow-hidden group">
                    <Image 
                      src={url} 
                      alt={`Material Image ${index + 1}`} 
                      fill 
                      className="object-cover"
                    />
                    <div className="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                      <Button 
                        variant="destructive" 
                        size="icon" 
                        onClick={() => handleImageRemove(url)}
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                ))
              ) : (
                <p className="text-gray-500 text-sm">Aucune image pour l'instant.</p>
              )}
            </div>
            <Label htmlFor="add-images" className="block mb-2">Ajouter de nouvelles images</Label>
            <Input id="add-images" type="file" accept="image/*" multiple />
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileTextIcon className="w-5 h-5" /> Fichier PDF
            </CardTitle>
          </CardHeader>
          <CardContent>
            {formData.pdf_url ? (
                <div className="flex items-center gap-2">
                    <Badge variant="secondary" className="max-w-xs truncate">{formData.pdf_url}</Badge>
                    <Button variant="destructive" size="icon" onClick={handleFileRemove}>
                        <Trash2 className="w-4 h-4" />
                    </Button>
                </div>
            ) : (
                <>
                    <p className="text-gray-500 text-sm mb-2">Aucun fichier PDF n'a été ajouté.</p>
                    <Label htmlFor="add-file" className="block mb-2">Ajouter un fichier PDF</Label>
                    <Input id="add-file" type="file" accept=".pdf" />
                </>
            )}
          </CardContent>
        </Card>

        <div className="flex justify-end gap-2">
          <Button onClick={handleUpdate} disabled={isPending}>
            <Save className="w-4 h-4 mr-2" />
            {isPending ? "Sauvegarde en cours..." : "Sauvegarder"}
          </Button>
        </div>
      </div>
    </AdminLayout>
  )
}