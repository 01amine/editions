"use client"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Search, Download, RefreshCw, UserPlus } from 'lucide-react'

interface UsersHeaderProps {
  searchTerm: string;
  setSearchTerm: (v: string) => void;
  roleFilter: string;
  setRoleFilter: (v: string) => void;
  statusFilter: string;
  setStatusFilter: (v: string) => void;
  orderBy: "date" | "name";
  setOrderBy: (v: "date" | "name") => void;
  orderDir: "asc" | "desc";
  setOrderDir: (v: "asc" | "desc") => void;
  onRefresh: () => void;
  onExport: () => void;
}


export default function UsersHeader({ 
  searchTerm, 
  setSearchTerm, 
  roleFilter, 
  setRoleFilter,
  statusFilter,
  setStatusFilter,
  onRefresh,
  onExport 
}: UsersHeaderProps) {
  return (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h2 className="text-2xl font-bold text-gray-900">Gestion des utilisateurs</h2>
        <div className="flex items-center space-x-2">
          <Button variant="outline" size="sm" onClick={onRefresh}>
            <RefreshCw className="w-4 h-4 mr-2" />
            Actualiser
          </Button>
          <Button variant="outline" size="sm" onClick={onExport}>
            <Download className="w-4 h-4 mr-2" />
            Exporter
          </Button>
          <Button>
            <UserPlus className="w-4 h-4 mr-2" />
            Inviter
          </Button>
        </div>
      </div>
      
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
          <Input
            placeholder="Rechercher par nom, email ou téléphone..."
            className="pl-10"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        
        <Select value={roleFilter} onValueChange={setRoleFilter}>
          <SelectTrigger className="w-full sm:w-48">
            <SelectValue placeholder="Filtrer par rôle" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les rôles</SelectItem>
            <SelectItem value="admin">Administrateurs</SelectItem>
            <SelectItem value="user">Étudiants</SelectItem>
          </SelectContent>
        </Select>
        
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-full sm:w-48">
            <SelectValue placeholder="Filtrer par statut" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les statuts</SelectItem>
            <SelectItem value="active">Actifs</SelectItem>
            <SelectItem value="blocked">Bloqués</SelectItem>
          </SelectContent>
        </Select>
      </div>
    </div>
  )
}
