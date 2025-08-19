"use client"

import AdminLayout from "@/components/layout/admin-layout"
import UsersHeader from "@/components/users/users-header"
import UsersTable from "@/components/users/users-table"

const mockUsers = [
  {
    _id: "1",
    full_name: "Ahmed Benali",
    email: "ahmed@example.com",
    phone_number: "+213555123456",
    roles: ["user"],
    isblocked: false,
    created_at: "2024-01-01T10:00:00Z"
  },
  {
    _id: "2",
    full_name: "Dr. Sarah Admin",
    email: "sarah@lectio.com",
    phone_number: "+213555987654",
    roles: ["admin"],
    isblocked: false,
    created_at: "2024-01-01T10:00:00Z"
  }
]

export default function UsersPage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <UsersHeader />
        <UsersTable users={mockUsers} />
      </div>
    </AdminLayout>
  )
}
