"use client"

import { Card, CardContent } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { MoreHorizontal } from "lucide-react"
import { AllUser, User } from "@/lib/types/auth"
import { useState } from "react"
import { UserDialog } from "./user-dialog"  
import { useAddAdmin, useBlockUser, useRemoveAdmin, useUnblockUser } from "@/hooks/queries/useAuth"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { useToast } from "@/hooks/use-toast"

interface UsersTableProps {
  users: AllUser[]
}

export default function UsersTable({ users }: UsersTableProps) {
  const [area, setArea] = useState<string>("")
  const [dialogOpen, setDialogOpen] = useState<boolean>(false)
  const [selectedUser, setSelectedUser] = useState<User | null>(null)

  const { mutate } = useAddAdmin()
  const { mutate: mutateBlockUser } = useBlockUser()
  const { mutate: mutateUnblockUser } = useUnblockUser()
  const { mutate: mutateRemoveAdmin } = useRemoveAdmin()
  const { toast } = useToast()

  const handlePromoteAdmin = async () => {
    if (!selectedUser || !area) return
    mutate(
      { userId: selectedUser._id, area },
      {
        onSuccess: () => {
          setDialogOpen(false)
          setArea("")
          setSelectedUser(null)
          toast({
            title: "Ajout de rôle",
            description: "Le rôle de l'utilisateur a bien été ajouté.",
          })
        },
      }
    )
  }

  const handleRemoveAdmin = (user: User) => {
    mutateRemoveAdmin(user._id)
    toast({
      title: "Suppression de rôle",
      description: "Le rôle de l'utilisateur a bien été supprimé.",
    })
  }

  const handleBlockUser = (user: User) => {
    mutateBlockUser(user._id)
    toast({
      title: "Blocage de l'utilisateur",
      description: "L'utilisateur a bien été bloqué.",
    })
  }

  const handleUnblockUser = (user: User) => {
    mutateUnblockUser(user._id)
    toast({
      title: "Déblocage de l'utilisateur",
      description: "L'utilisateur a bien été débloqué.",
    })
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
                <TableHead>État</TableHead>
                <TableHead>Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((user) => (
                <TableRow 
                  key={user._id} 
                  className={user.isblocked ? "bg-red-50" : ""}
                >
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
                    {user.isblocked ? (
                      <Badge variant="destructive">Bloqué</Badge>
                    ) : (
                      <Badge variant="outline">Actif</Badge>
                    )}
                  </TableCell>
                  <TableCell>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="sm">
                          <MoreHorizontal className="w-4 h-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuLabel>Actions</DropdownMenuLabel>
                        <DropdownMenuSeparator />

                        {!user.roles.includes("admin") && (
                          <DropdownMenuItem
                            onClick={() => {
                              setSelectedUser(user)
                              setDialogOpen(true)
                            }}
                          >
                            Promouvoir Admin
                          </DropdownMenuItem>
                        )}

                        {user.roles.includes("admin") && (
                          <DropdownMenuItem onClick={() => handleRemoveAdmin(user)}>
                            Retirer des admins
                          </DropdownMenuItem>
                        )}

                        {!user.isblocked ? (
                          <DropdownMenuItem onClick={() => handleBlockUser(user)}>
                            Bloquer l’utilisateur
                          </DropdownMenuItem>
                        ) : (
                          <DropdownMenuItem onClick={() => handleUnblockUser(user)}>
                            Débloquer l’utilisateur
                          </DropdownMenuItem>
                        )}
                      </DropdownMenuContent>
                    </DropdownMenu>
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
