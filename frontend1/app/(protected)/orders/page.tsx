"use client"

import { useState, useMemo } from "react"
import AdminLayout from "@/components/layout/admin-layout"
import OrdersTable from "@/components/orders/orders-table"
import OrdersHeader from "@/components/orders/orders-header"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { PieChartComponent, BarChartComponent } from "@/components/ui/chart"
import { useOrdersForAdmin } from "@/hooks/queries/useorder"
import { ref } from "process"
import { useToast } from "@/hooks/use-toast"



export default function OrdersPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [statusFilter, setStatusFilter] = useState("all")
  const [dateRange, setDateRange] = useState<any>(undefined)
  const {data:mockOrders , isError,isLoading,refetch} = useOrdersForAdmin()
  const { toast } = useToast();
  console.log(mockOrders)

  const filteredOrders = useMemo(() => {
    if (!mockOrders) return []
    return mockOrders.filter(order => {
      const matchesSearch = 
        order.student.full_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order.student.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order._id.includes(searchTerm)

      const matchesStatus = statusFilter === "all" || order.status === statusFilter

      const matchesDate = !dateRange?.from || (
        new Date(order.created_at) >= dateRange.from &&
        (!dateRange.to || new Date(order.created_at) <= dateRange.to)
      )

      return matchesSearch && matchesStatus && matchesDate
    })
  }, [searchTerm, statusFilter, dateRange])

  const statusData = [
    { name: 'En attente', value: filteredOrders.filter(o => o.status === 'pending').length },
    { name: 'Impression', value: filteredOrders.filter(o => o.status === 'printing').length },
    { name: 'Prêt', value: filteredOrders.filter(o => o.status === 'ready').length },
    { name: 'Livré', value: filteredOrders.filter(o => o.status === 'delivered').length },
  ]

  const dailyOrdersData = [
    { name: 'Lun', value: 12 },
    { name: 'Mar', value: 19 },
    { name: 'Mer', value: 15 },
    { name: 'Jeu', value: 22 },
    { name: 'Ven', value: 18 },
    { name: 'Sam', value: 8 },
    { name: 'Dim', value: 5 },
  ]

  const handleRefresh = () => {
    refetch()
    console.log("Refreshing orders...")
  }

  const handleExport = () => {
    console.log("Exporting orders...")
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <OrdersHeader 
          searchTerm={searchTerm}
          setSearchTerm={setSearchTerm}
          statusFilter={statusFilter}
          setStatusFilter={setStatusFilter}
          dateRange={dateRange}
          setDateRange={setDateRange}
          onRefresh={handleRefresh}
          onExport={handleExport}
        />
        
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader>
              <CardTitle>Répartition par statut</CardTitle>
              <CardDescription>Commandes filtrées par statut</CardDescription>
            </CardHeader>
            <CardContent>
              <PieChartComponent data={statusData} className="h-48" />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Commandes par jour</CardTitle>
              <CardDescription>Activité de la semaine</CardDescription>
            </CardHeader>
            <CardContent>
              <BarChartComponent data={dailyOrdersData} className="h-48" />
            </CardContent>
          </Card>
        </div>

        <OrdersTable orders={filteredOrders} />
      </div>
    </AdminLayout>
  )
}
