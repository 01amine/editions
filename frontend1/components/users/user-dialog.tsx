import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Button } from "../ui/button"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

interface UserDialogProps {
  area: string
  setArea: React.Dispatch<React.SetStateAction<string>>
  open: boolean
  onOpenChange: (open: boolean) => void
  onConfirm: () => void
}

export const UserDialog = ({ area, setArea, open, onOpenChange, onConfirm }: UserDialogProps) => {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Choisir une zone</DialogTitle>
        </DialogHeader>

        <Select value={area} onValueChange={(value) => setArea(value)}>
          <SelectTrigger className="w-full">
            <SelectValue placeholder="Sélectionnez une zone" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="north">Nord</SelectItem>
            <SelectItem value="south">Sud</SelectItem>
            <SelectItem value="east">Est</SelectItem>
            <SelectItem value="west">Ouest</SelectItem>
          </SelectContent>
        </Select>

        <DialogFooter>
          <Button type="button" onClick={onConfirm}>
            Confirmer
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
