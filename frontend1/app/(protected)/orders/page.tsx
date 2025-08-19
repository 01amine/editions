"use client"

import { useState, useMemo } from "react"
import AdminLayout from "@/components/layout/admin-layout"
import OrdersTable from "@/components/orders/orders-table"
import OrdersHeader from "@/components/orders/orders-header"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { PieChartComponent, BarChartComponent } from "@/components/ui/chart"

const mockOrders = [
  {
    _id: "1",
    student: { full_name: "Ahmed Benali", email: "ahmed@example.com" },
    item: [
      [{ title: "Anatomie Humaine", material_type: "Livre", price_dzd: 2500 }, 2],
      [{ title: "Physiologie", material_type: "PDF", price_dzd: 1200 }, 1]
    ],
    status: "pending",
    created_at: "2024-01-15T10:30:00Z",
    appointment_date: null
  },
  {
    _id: "2", 
    student: { full_name: "Fatima Zohra", email: "fatima@example.com" },
    item: [
      [{ title: "Pharmacologie", material_type: "Livre", price_dzd: 3000 }, 1]
    ],
    status: "printing",
    created_at: "2024-01-14T14:20:00Z",
    appointment_date: null
  },
  {
    _id: "3",
    student: { full_name: "Yacine Meziani", email: "yacine@example.com" },
    item: [
      [{ title: "Cardiologie", material_type: "PDF", price_dzd: 1800 }, 1]
    ],
    status: "ready",
    created_at: "2024-01-13T09:15:00Z",
    appointment_date: null
  },
  {
    _id: "4",
    student: { full_name: "Amina Khelifi", email: "amina@example.com" },
    item: [
      [{ title: "Neurologie", material_type: "Livre", price_dzd: 3500 }, 1]
    ],
    status: "delivered",
    created_at: "2024-01-12T16:45:00Z",
    appointment_date: null
  }
]

export default function OrdersPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [statusFilter, setStatusFilter] = useState("all")
  const [dateRange, setDateRange] = useState<any>(undefined)

  // Filter and search logic
  const filteredOrders = useMemo(() => {
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

  // Chart data
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
    // Implement refresh logic
    console.log("Refreshing orders...")
  }

  const handleExport = () => {
    // Implement export logic
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
