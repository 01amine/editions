"use client"

import { useState, useMemo } from "react"
import AdminLayout from "@/components/layout/admin-layout"
import MaterialsHeader from "@/components/materials/materials-header"
import MaterialsGrid from "@/components/materials/materials-grid"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { PieChartComponent, BarChartComponent } from "@/components/ui/chart"
import { useGetMaterials } from "@/hooks/queries/useMaterial"
import { toast, useToast } from "@/components/ui/use-toast"
import { MaterialsGridLoading, ChartLoading } from "@/components/ui/loading"
import { DataError } from "@/components/ui/error"



export default function MaterialsPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [typeFilter, setTypeFilter] = useState("all")
  const [sortBy, setSortBy] = useState("title")
  const { toast } = useToast();
  const { data, isLoading, isError, error, refetch } = useGetMaterials(10, 0);



  const filteredMaterials = useMemo(() => {
    if (!data) return []
    let filtered = data.filter(material => {
      const matchesSearch = 
        material.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        material.description.toLowerCase().includes(searchTerm.toLowerCase())

      const matchesType = typeFilter === "all" || material.material_type.toLowerCase() === typeFilter

      return matchesSearch && matchesType
    })

    filtered.sort((a, b) => {
      switch (sortBy) {
        case "title":
          return a.title.localeCompare(b.title)
        case "price_asc":
          return a.price_dzd - b.price_dzd
        case "price_desc":
          return b.price_dzd - a.price_dzd
        case "date_desc":
          return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
        case "date_asc":
          return new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
        default:
          return 0
      }
    })

    return filtered
  }, [data,searchTerm, typeFilter, sortBy])

const typeData = [
  { name: 'Livres', value: filteredMaterials.filter(m => m.material_type.toLowerCase() === 'livre').length },
  { name: 'PDF', value: filteredMaterials.filter(m => m.material_type.toLowerCase() === 'pdf').length },
  { name: 'Polycopiés', value: filteredMaterials.filter(m => m.material_type.toLowerCase() === 'polycopie').length },
];

  const priceRangeData = [
    { name: '< 1500 DZD', value: filteredMaterials.filter(m => m.price_dzd < 1500).length },
    { name: '1500-2500 DZD', value: filteredMaterials.filter(m => m.price_dzd >= 1500 && m.price_dzd < 2500).length },
    { name: '2500-3500 DZD', value: filteredMaterials.filter(m => m.price_dzd >= 2500 && m.price_dzd < 3500).length },
    { name: '> 3500 DZD', value: filteredMaterials.filter(m => m.price_dzd >= 3500).length },
  ]

  const handleRefresh = () => {
    
        refetch();
    toast({
      title: "material refreshed",
      description: "Materials refreshed successfully.",
    })
  }

  const handleExport = () => {
    console.log("Exporting materials...")
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <MaterialsHeader 
          searchTerm={searchTerm}
          setSearchTerm={setSearchTerm}
          typeFilter={typeFilter}
          setTypeFilter={setTypeFilter}
          sortBy={sortBy}
          setSortBy={setSortBy}
          onRefresh={handleRefresh}
          onExport={handleExport}
        />
        
        {/* Charts */}
        {isLoading ? (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <ChartLoading />
            <ChartLoading />
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Répartition par type</CardTitle>
                <CardDescription>Types de supports disponibles</CardDescription>
              </CardHeader>
              <CardContent>
                <PieChartComponent data={typeData} className="h-48" />
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Répartition par prix</CardTitle>
                <CardDescription>Gammes de prix des supports</CardDescription>
              </CardHeader>
              <CardContent>
                <BarChartComponent data={priceRangeData} className="h-48" />
              </CardContent>
            </Card>
          </div>
        )}

        {/* Materials Grid */}
        {isLoading ? (
          <MaterialsGridLoading />
        ) : isError ? (
          <DataError 
            error={error} 
            onRetry={handleRefresh}
            title="Erreur de chargement des supports"
            message="Impossible de charger la liste des supports. Veuillez réessayer."
          />
        ) : (
          <MaterialsGrid materials={filteredMaterials} />
        )}
      </div>
    </AdminLayout>
  )
}
