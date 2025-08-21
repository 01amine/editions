"use client"
import { Card, CardContent } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Eye } from 'lucide-react'
import { AllUser, User } from "@/lib/types/auth"
import { useState } from "react"
import { UserDialog } from "./user-dialog"  
import { useAddAdmin } from "@/hooks/queries/useAuth"

interface UsersTableProps {
  users: AllUser[]
}

export default function UsersTable({ users }: UsersTableProps) {
  const [area, setArea] = useState<string>("")
  const [dialogOpen, setDialogOpen] = useState<boolean>(false)
  const [selectedUser, setSelectedUser] = useState<User | null>(null)
  const { mutate, isPending } = useAddAdmin()

  const handlePromoteAdmin = async () => {
    console.log("Promoting user...")
    if (!selectedUser || !area) return

    mutate(
      { userId: selectedUser._id, area: area }, 
      {
        onSuccess: () => {
          setDialogOpen(false)
          setArea("")
          setSelectedUser(null)
        },
      }
    )
      
  }

  return (
    <>
      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Utilisateur</TableHead>
                <TableHead>Téléphone</TableHead>
                <TableHead>Rôle</TableHead>
                <TableHead>Date d'inscription</TableHead>
                <TableHead>Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((user) => (
                <TableRow key={user._id}>
                  <TableCell>
                    <div className="flex items-center space-x-3">
                      <Avatar>
                        <AvatarFallback>
                          {user.full_name.split(" ").map((n) => n[0]).join("")}
                        </AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="font-medium">{user.full_name}</p>
                        <p className="text-sm text-gray-500">{user.email}</p>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>{user.phone_number}</TableCell>
                  <TableCell>
                    <Badge variant={user.roles.includes("admin") ? "default" : "secondary"}>
                      {user.roles.includes("admin") ? "Administrateur" : "Étudiant"}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    {new Date(user.created_at).toLocaleDateString("fr-FR")}
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center space-x-2">
                      <Button variant="ghost" size="sm">
                        <Eye className="w-4 h-4" />
                      </Button>
                      {!user.roles.includes("admin") && (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => {
                            console.log(user)
                            setSelectedUser(user)
                            setDialogOpen(true)
                          }}
                        >
                          Promouvoir Admin
                        </Button>
                      )}
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <UserDialog
        area={area}
        setArea={setArea}
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        onConfirm={handlePromoteAdmin}
      />
    </>
  )
}
