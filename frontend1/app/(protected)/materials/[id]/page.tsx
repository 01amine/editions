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
import { useToast } from "@/hooks/use-toast"

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
  })

  const [existingImageUrls, setExistingImageUrls] = useState<string[]>([])
  const [newImages, setNewImages] = useState<File[]>([])
  const [newFile, setNewFile] = useState<File | null>(null)
  const [removePdf, setRemovePdf] = useState(false)
    const [imageInputKey, setImageInputKey] = useState(Date.now())


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
      })
      setExistingImageUrls(material.image_urls)
      setNewImages([])
      setNewFile(null)
      setRemovePdf(false)
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

  const handleExistingImageRemove = (urlToRemove: string) => {
    setExistingImageUrls(prev => prev.filter(url => url !== urlToRemove))
  }
  
  const handleNewImageRemove = (fileToRemove: File) => {
    setNewImages(prev => prev.filter(file => file !== fileToRemove));
  }
  
  const handleFileRemove = () => {
    setNewFile(null)
    setRemovePdf(true)
  }

  const allImagesForDisplay = [
    ...existingImageUrls.map(url => ({ src: url, isNew: false })),
    ...newImages.map(file => ({ src: URL.createObjectURL(file), isNew: true, file })),
  ];

  const handleUpdate = () => {
    mutate({
      id,
      data: formData,
      newImages,
      existingImageUrls,
      newFile,
      removePdf
    }, {
      onSuccess: () => {
        setImageInputKey(Date.now());
        setNewImages([]);
      },
      onError: (err) => {
        console.log(err)
      }
    })
    toast({
      title: "Support mis à jour",
      description: "Le support a bien été mis à jour.",
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
                value={formData.title || ''} 
                onChange={handleChange} 
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="description" className="md:text-right">Description</Label>
              <Textarea 
                id="description" 
                className="col-span-3" 
                value={formData.description || ''} 
                onChange={handleChange} 
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="material_type" className="md:text-right">Type</Label>
              <Select 
                value={formData.material_type || ''} 
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
                value={formData.price_dzd || 0} 
                onChange={handleChange} 
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="study_year" className="md:text-right">Année d'étude</Label>
              <Input 
                id="study_year" 
                className="col-span-3" 
                value={formData.study_year || ''}
                onChange={handleChange}
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="specialite" className="md:text-right">Spécialité</Label>
              <Input 
                id="specialite" 
                className="col-span-3" 
                value={formData.specialite || ''}
                onChange={handleChange}
              />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
              <Label htmlFor="module" className="md:text-right">Module</Label>
              <Input 
                id="module" 
                className="col-span-3" 
                value={formData.module || ''}
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
              {allImagesForDisplay.length > 0 ? (
                allImagesForDisplay.map((image, index) => (
                  <div key={index} className="relative w-24 h-24 rounded-md overflow-hidden group">
                    <Image 
                      src={image.src} 
                      alt={`Material Image ${index + 1}`} 
                      fill 
                      className="object-cover"
                    />
                    <div className="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                      <Button 
                        variant="destructive" 
                        size="icon" 
                        onClick={() => image.isNew ? handleNewImageRemove(image.file) : handleExistingImageRemove(image.src)}
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
            <Input 
                key={imageInputKey} // Use key to force re-render and clear the input
                id="add-images" 
                type="file" 
                accept="image/*" 
                multiple
                onChange={(e) => {
                    if (e.target.files) {
                        const newlySelectedFiles = Array.from(e.target.files);
                        setNewImages(prevFiles => [...prevFiles, ...newlySelectedFiles]);
                    }
                }}
            />
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileTextIcon className="w-5 h-5" /> Fichier PDF
            </CardTitle>
          </CardHeader>
          <CardContent>
            {/* Display either the new file or the existing one */}
            {(newFile || (material.pdf_url && !removePdf)) ? (
                <div className="flex items-center gap-2">
                    <Badge variant="secondary" className="max-w-xs truncate">
                        {newFile ? newFile.name : material.pdf_url}
                    </Badge>
                    <Button variant="destructive" size="icon" onClick={handleFileRemove}>
                        <Trash2 className="w-4 h-4" />
                    </Button>
                </div>
            ) : (
                <>
                    <p className="text-gray-500 text-sm mb-2">Aucun fichier PDF n'a été ajouté.</p>
                    <Label htmlFor="add-file" className="block mb-2">Ajouter un fichier PDF</Label>
                    <Input 
                        id="add-file" 
                        type="file" 
                        accept=".pdf"
                        onChange={(e) => {
                            if (e.target.files && e.target.files.length > 0) {
                                setNewFile(e.target.files[0]);
                                setRemovePdf(false); 
                            }
                        }}
                    />
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