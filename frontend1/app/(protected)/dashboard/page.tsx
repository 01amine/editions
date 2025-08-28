"use client"

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import AdminLayout from "@/components/layout/admin-layout"
import StatsCards from "@/components/dashboard/stats-cards"
import RecentOrders from "@/components/dashboard/recent-orders"
import { PieChartComponent, BarChartComponent, LineChartComponent } from "@/components/ui/chart"
import { useOrdersForAdmin } from "@/hooks/queries/useorder"
import { useAnalytics } from "@/hooks/queries/useanalytics"
import { DashboardAnalytics } from "@/lib/types/analytics"
import { StatsCardsLoading, ChartLoading, TableLoading } from "@/components/ui/loading"
import { DataError } from "@/components/ui/error"

export default function DashboardPage() {
  const { data: Orders, isError, isLoading } = useOrdersForAdmin()
  const { data: Analytics, isError: isErrorAnalytics, isLoading: isLoadingAnalytics } = useAnalytics()

  if (isLoading || isLoadingAnalytics) {
    return (
      <AdminLayout>
        <div className="space-y-6">
          <h2 className="text-2xl font-bold text-gray-900">Tableau de bord</h2>
          <StatsCardsLoading />
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <ChartLoading />
            <ChartLoading />
            <ChartLoading />
            <ChartLoading />
          </div>
          <TableLoading rows={5} />
        </div>
      </AdminLayout>
    )
  }

  if (isError || isErrorAnalytics || !Analytics) {
    return (
      <AdminLayout>
        <div className="space-y-6">
          <h2 className="text-2xl font-bold text-gray-900">Tableau de bord</h2>
          <DataError 
            error={isError ? "Erreur lors du chargement des commandes" : isErrorAnalytics ? "Erreur lors du chargement des analyses" : "Données manquantes"}
            onRetry={() => window.location.reload()}
            title="Erreur de chargement du tableau de bord"
            message="Impossible de charger les données du tableau de bord. Veuillez réessayer."
          />
        </div>
      </AdminLayout>
    )
  }

  const stats = {
    totalUsers: Analytics.total_users,
    totalMaterials: Analytics.total_available_materials,
    pendingOrders: Analytics.total_pending_orders,
    todayAppointments: Analytics.total_today_appointments,
  }

  // ✅ Order status chart (convert backend format → chart format)
  const orderStatusData = Analytics.order_status_percentages.map(status => ({
    name: status.status,
    value: status.percentage,
  }))

  const materialTypeData = Analytics.material_type_percentages.map(mat => ({
    name: mat.material_type,
    value: mat.percentage,
  }))

  // ✅ Monthly orders chart
  const monthlyOrdersData = Analytics.monthly_orders.map(order => ({
    name: order.month,
    value: order.count,
  }))

  const revenueData = Analytics.monthly_revenue.map(rev => ({
    name: rev.month,
    value: rev.revenue,
  }))

  const orderStatusPieData = [
    { name: "En attente", value: Orders.filter(o => o.status === "pending").length },
    { name: "Impression", value: Orders.filter(o => o.status === "printing").length },
    { name: "Prêt", value: Orders.filter(o => o.status === "ready").length },
    { name: "Livré", value: Orders.filter(o => o.status === "delivered").length },
  ]

  return (
    <AdminLayout>
      <div className="space-y-6">
        <h2 className="text-2xl font-bold text-gray-900">Tableau de bord</h2>

        {/* Stats Cards */}
        <StatsCards stats={stats} />

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

        <RecentOrders orders={Orders} />
      </div>
    </AdminLayout>
  )
}
