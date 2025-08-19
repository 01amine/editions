"use client"

import { useState, useMemo } from "react"
import AdminLayout from "@/components/layout/admin-layout"
import MaterialsHeader from "@/components/materials/materials-header"
import MaterialsGrid from "@/components/materials/materials-grid"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { PieChartComponent, BarChartComponent } from "@/components/ui/chart"
import { useGetMaterials } from "@/hooks/queries/useMaterial"



export default function MaterialsPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [typeFilter, setTypeFilter] = useState("all")
  const [sortBy, setSortBy] = useState("title")
  const { data, isLoading, isError, error } = useGetMaterials(10, 0);



  const filteredMaterials = useMemo(() => {
    if (!data) return []
    let filtered = data.filter(material => {
      const matchesSearch = 
        material.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        material.description.toLowerCase().includes(searchTerm.toLowerCase())

      const matchesType = typeFilter === "all" || material.material_type === typeFilter

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

  // Chart data
  const typeData = [
    { name: 'Livres', value: filteredMaterials.filter(m => m.material_type === 'Livre').length },
    { name: 'PDF', value: filteredMaterials.filter(m => m.material_type === 'PDF').length },
    { name: 'Polycopiés', value: filteredMaterials.filter(m => m.material_type === 'Polycopié').length },
  ]

  const priceRangeData = [
    { name: '< 1500 DZD', value: filteredMaterials.filter(m => m.price_dzd < 1500).length },
    { name: '1500-2500 DZD', value: filteredMaterials.filter(m => m.price_dzd >= 1500 && m.price_dzd < 2500).length },
    { name: '2500-3500 DZD', value: filteredMaterials.filter(m => m.price_dzd >= 2500 && m.price_dzd < 3500).length },
    { name: '> 3500 DZD', value: filteredMaterials.filter(m => m.price_dzd >= 3500).length },
  ]

  const handleRefresh = () => {
    console.log("Refreshing materials...")
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

        <MaterialsGrid materials={filteredMaterials} />
      </div>
    </AdminLayout>
  )
}
