"use client";

import { Forbidden } from "@/components/errors/403";
import AdminLayout from "@/components/layout/admin-layout";
import UsersHeader from "@/components/users/users-header";
import UsersTable from "@/components/users/users-table";
import { useGetAllUsers } from "@/hooks/queries/useAuth";
import { useToast } from "@/hooks/use-toast";
import { useState } from "react";

export default function UsersPage() {
  const skip = 0;
  const limit = 10;
  const [searchTerm, setSearchTerm] = useState("");
  const [roleFilter, setRoleFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const { toast } = useToast();

  const { data, isLoading, isError, error , refetch} = useGetAllUsers(skip, limit);

  if (isError) {
  console.log(error)
    
    if (error.message === "Insufficient permissions") {
      return (
        <div>
          <Forbidden />
        </div>
      );
    }
  }

  const onExport = () => {
    console.log("Exporting users...");
  };

  const onRefresh = () => {
    refetch()
    toast({
      title: "Utilisateurs mis à jour",
      description: "Les utilisateurs ont bien été mis à jour.",
    })
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
          onRefresh={onRefresh}
          onExport={onExport}
        />
        <UsersTable users={data ?? []} />
      </div>
    </AdminLayout>
  );
}
