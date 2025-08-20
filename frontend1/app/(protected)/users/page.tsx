"use client";

import { Forbidden } from "@/components/errors/403";
import AdminLayout from "@/components/layout/admin-layout";
import UsersHeader from "@/components/users/users-header";
import UsersTable from "@/components/users/users-table";
import { useGetAllUsers } from "@/hooks/queries/useAuth";
import { useState } from "react";

export default function UsersPage() {
  const skip = 0;
  const limit = 10;
  const [searchTerm, setSearchTerm] = useState("");
  const [roleFilter, setRoleFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");

  const { data, isLoading, isError, error } = useGetAllUsers(skip, limit);

  if (isError) {
    if (error.response?.status === 403) {
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
    console.log("Refreshing users...");
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
