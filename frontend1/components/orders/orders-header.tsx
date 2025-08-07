"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Search, Filter, Download, RefreshCw } from 'lucide-react'
import { DatePickerWithRange } from "@/components/ui/date-range-picker"

interface OrdersHeaderProps {
  searchTerm: string
  setSearchTerm: (term: string) => void
  statusFilter: string
  setStatusFilter: (status: string) => void
  dateRange: any
  setDateRange: (range: any) => void
  onRefresh: () => void
  onExport: () => void
}

export default function OrdersHeader({ 
  searchTerm, 
  setSearchTerm, 
  statusFilter, 
  setStatusFilter,
  dateRange,
  setDateRange,
  onRefresh,
  onExport 
}: OrdersHeaderProps) {
  return (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h2 className="text-2xl font-bold text-gray-900">Gestion des commandes</h2>
        <div className="flex items-center space-x-2">
          <Button variant="outline" size="sm" onClick={onRefresh}>
            <RefreshCw className="w-4 h-4 mr-2" />
            Actualiser
          </Button>
          <Button variant="outline" size="sm" onClick={onExport}>
            <Download className="w-4 h-4 mr-2" />
            Exporter
          </Button>
        </div>
      </div>
      
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
          <Input
            placeholder="Rechercher par nom, email ou ID de commande..."
            className="pl-10"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-full sm:w-48">
            <SelectValue placeholder="Filtrer par statut" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les statuts</SelectItem>
            <SelectItem value="pending">En attente</SelectItem>
            <SelectItem value="printing">En impression</SelectItem>
            <SelectItem value="ready">Prêt</SelectItem>
            <SelectItem value="delivered">Livré</SelectItem>
          </SelectContent>
        </Select>
        
        <DatePickerWithRange
          date={dateRange}
          setDate={setDateRange}
          className="w-full sm:w-auto"
        />
      </div>
    </div>
  )
}
