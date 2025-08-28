"use client"

import { useState, useMemo } from "react"
import AdminLayout from "@/components/layout/admin-layout"
import OrdersTable from "@/components/orders/orders-table"
import OrdersHeader from "@/components/orders/orders-header"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { PieChartComponent, BarChartComponent } from "@/components/ui/chart"
import { useOrdersForAdmin } from "@/hooks/queries/useorder"
import { useToast } from "@/hooks/use-toast"
import { TableLoading, ChartLoading } from "@/components/ui/loading"
import { DataError } from "@/components/ui/error"

export default function OrdersPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [statusFilter, setStatusFilter] = useState("all")
  const [dateRange, setDateRange] = useState<any>(undefined)

  const { data: mockOrders, isError, isLoading, refetch } = useOrdersForAdmin()
  const { toast } = useToast()
  

  const filteredOrders = useMemo(() => {
    if (!mockOrders || mockOrders.length === 0) return []

    const result = mockOrders.filter(order => {
      const matchesSearch =
        searchTerm.trim() === "" ||
        order.student.full_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order.student.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order._id.includes(searchTerm)

      const matchesStatus =
        statusFilter === "all" || order.status === statusFilter

      const createdAt = new Date(order.created_at)
      const matchesDate =
        !dateRange?.from ||
        (createdAt >= dateRange.from &&
          (!dateRange.to || createdAt <= dateRange.to))

      return matchesSearch && matchesStatus && matchesDate
    })

    console.log({
      mockOrders,
      searchTerm,
      statusFilter,
      dateRange,
      beforeFilter: mockOrders.length,
      afterFilter: result.length
    })

    return result
  }, [mockOrders, searchTerm, statusFilter, dateRange])

  const statusData = [
    { name: "En attente", value: filteredOrders.filter(o => o.status === "pending").length },
    { name: "Impression", value: filteredOrders.filter(o => o.status === "printing").length },
    { name: "Prêt", value: filteredOrders.filter(o => o.status === "ready").length },
    { name: "Livré", value: filteredOrders.filter(o => o.status === "delivered").length },
  ]
  // Calculate daily orders from real data
  const dailyOrdersData = (() => {
    if (!mockOrders || mockOrders.length === 0) {
      return [
        { name: "Lun", value: 0 },
        { name: "Mar", value: 0 },
        { name: "Mer", value: 0 },
        { name: "Jeu", value: 0 },
        { name: "Ven", value: 0 },
        { name: "Sam", value: 0 },
        { name: "Dim", value: 0 },
      ];
    }

    const daysOfWeek = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
    const dailyCounts = new Array(7).fill(0);

    mockOrders.forEach(order => {
      const orderDate = new Date(order.created_at);
      const dayOfWeek = orderDate.getDay(); // 0 = Sunday, 1 = Monday, etc.
      dailyCounts[dayOfWeek]++;
    });

    return daysOfWeek.map((day, index) => ({
      name: day,
      value: dailyCounts[index]
    }));
  })();

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
        )}

        {/* Orders Table */}
        {isLoading ? (
          <TableLoading rows={8} />
        ) : isError ? (
          <DataError 
            error={null} 
            onRetry={handleRefresh}
            title="Erreur de chargement des commandes"
            message="Impossible de charger la liste des commandes. Veuillez réessayer."
          />
        ) : (
          <OrdersTable orders={filteredOrders} />
        )}
      </div>
    </AdminLayout>
  )
}
