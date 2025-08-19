"use client"

import { useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import AdminLayout from "@/components/layout/admin-layout"
import LoginPage from "@/components/auth/login-page"
import StatsCards from "@/components/dashboard/stats-cards"
import RecentOrders from "@/components/dashboard/recent-orders"
import { PieChartComponent, BarChartComponent, LineChartComponent } from "@/components/ui/chart"
import { useIsAuthenticated } from "@/hooks/queries/useAuth"

const mockStats = {
  totalUsers: 1247,
  totalMaterials: 89,
  pendingOrders: 23,
  todayAppointments: 8
}

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

const orderStatusData = [
  { name: 'En attente', value: mockOrders.filter(o => o.status === 'pending').length },
  { name: 'Impression', value: mockOrders.filter(o => o.status === 'printing').length },
  { name: 'Prêt', value: mockOrders.filter(o => o.status === 'ready').length },
  { name: 'Livré', value: mockOrders.filter(o => o.status === 'delivered').length },
]

const materialTypeData = [
  { name: 'Livres', value: 45 },
  { name: 'PDF', value: 32 },
  { name: 'Polycopiés', value: 12 },
]

const monthlyOrdersData = [
  { name: 'Jan', value: 65 },
  { name: 'Fév', value: 78 },
  { name: 'Mar', value: 90 },
  { name: 'Avr', value: 81 },
  { name: 'Mai', value: 95 },
  { name: 'Juin', value: 87 },
]

const revenueData = [
  { name: 'Jan', value: 125000 },
  { name: 'Fév', value: 145000 },
  { name: 'Mar', value: 165000 },
  { name: 'Avr', value: 155000 },
  { name: 'Mai', value: 175000 },
  { name: 'Juin', value: 185000 },
]

export default function DashboardPage() {


  return (
    <AdminLayout>
      <div className="space-y-6">
        <h2 className="text-2xl font-bold text-gray-900">Tableau de bord</h2>
        
        {/* Stats Cards */}
        <StatsCards stats={mockStats} />
        
        {/* Charts Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader>
              <CardTitle>Statut des commandes</CardTitle>
              <CardDescription>Répartition des commandes par statut</CardDescription>
            </CardHeader>
            <CardContent>
              <PieChartComponent data={orderStatusData} className="h-64" />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Types de supports</CardTitle>
              <CardDescription>Répartition des supports par type</CardDescription>
            </CardHeader>
            <CardContent>
              <PieChartComponent data={materialTypeData} className="h-64" />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Évolution des commandes</CardTitle>
              <CardDescription>Nombre de commandes par mois</CardDescription>
            </CardHeader>
            <CardContent>
              <LineChartComponent data={monthlyOrdersData} className="h-64" />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Chiffre d'affaires</CardTitle>
              <CardDescription>Revenus mensuels en DZD</CardDescription>
            </CardHeader>
            <CardContent>
              <BarChartComponent data={revenueData} className="h-64" />
            </CardContent>
          </Card>
        </div>
        
        {/* Recent Orders */}
        <RecentOrders orders={mockOrders} />
      </div>
    </AdminLayout>
  )
}
