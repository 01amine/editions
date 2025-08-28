"use client";

import { Forbidden } from "@/components/errors/403";
import AdminLayout from "@/components/layout/admin-layout";
import UsersHeader from "@/components/users/users-header";
import UsersTable from "@/components/users/users-table";
import { useGetAllUsers } from "@/hooks/queries/useAuth";
import { useToast } from "@/hooks/use-toast";
import { useState, useMemo } from "react";
import { TableLoading } from "@/components/ui/loading";
import { DataError } from "@/components/ui/error";

export default function UsersPage() {
  const skip = 0;
  const limit = 10;
  const [searchTerm, setSearchTerm] = useState("");
  const [roleFilter, setRoleFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [orderBy, setOrderBy] = useState<"date" | "name">("date");
  const [orderDir, setOrderDir] = useState<"asc" | "desc">("asc");
  const { toast } = useToast();

  const { data, isLoading, isError, error, refetch } = useGetAllUsers(skip, limit);

    if (isError) {
    console.log(error);
    if (error.message === "Insufficient permissions") {
      return <Forbidden />;
    }
  }

  const filteredUsers = useMemo(() => {
    if (!data) return [];

    return data
      .filter((user) => {
        const term = searchTerm.toLowerCase();
        const matchesSearch =
          user.full_name.toLowerCase().includes(term) ||
          user.email.toLowerCase().includes(term);

        const matchesRole =
          roleFilter === "all" ||
          (roleFilter === "admin" && user.roles.includes("admin")) ||
          (roleFilter === "student" && !user.roles.includes("admin"));

        const matchesStatus =
          statusFilter === "all" || 
          (statusFilter === "active" && !user.isblocked) ||
          (statusFilter === "blocked" && user.isblocked); 
        return matchesSearch && matchesRole && matchesStatus;
      })
      .sort((a, b) => {
        if (orderBy === "date") {
          const dateA = new Date(a.created_at).getTime();
          const dateB = new Date(b.created_at).getTime();
          return orderDir === "asc" ? dateA - dateB : dateB - dateA;
        }
        if (orderBy === "name") {
          return orderDir === "asc"
            ? a.full_name.localeCompare(b.full_name)
            : b.full_name.localeCompare(a.full_name);
        }
        return 0;
      });
  }, [data, searchTerm, roleFilter, statusFilter, orderBy, orderDir]);

  const onExport = () => {
    console.log("Exporting users...");
  };

  const onRefresh = () => {
    refetch();
    toast({
      title: "Utilisateurs mis à jour",
      description: "Les utilisateurs ont bien été mis à jour.",
    });
  };

  return (
    <AdminLayout>
      <div className="space-y-6">
        <UsersHeader
          searchTerm={searchTerm}
          setSearchTerm={setSearchTerm}
          roleFilter={roleFilter}
          setRoleFilter={setRoleFilter}
          statusFilter={statusFilter}
          setStatusFilter={setStatusFilter}
          orderBy={orderBy}
          setOrderBy={setOrderBy}
          orderDir={orderDir}
          setOrderDir={setOrderDir}
          onRefresh={onRefresh}
          onExport={onExport}
        />
        {isLoading ? (
          <TableLoading rows={8} />
        ) : isError ? (
          <DataError 
            error={error} 
            onRetry={onRefresh}
            title="Erreur de chargement des utilisateurs"
            message="Impossible de charger la liste des utilisateurs. Veuillez réessayer."
          />
        ) : (
          <UsersTable users={filteredUsers} />
        )}
      </div>
    </AdminLayout>
  );
}
