import { useEditMaterial, useGetMaterialById } from "@/hooks/queries/useMaterial"
import { MaterialsAdmin } from "@/lib/types/material"
import { useParams } from "next/navigation"

export default function MaterialDetailPage() {
  const { id } = useParams<{ id: string }>()
  const { data, isLoading, isError } = useGetMaterialById(id)
  const editHandler = useEditMaterial()

  if (isLoading) return <p>Loading...</p>
  if (isError) return <p>Failed to load material</p>
  const handleupdate = (id: string, data: MaterialsAdmin) => {
    editHandler.mutate({ id, data })
  }
  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold">{data?.title}</h1>
      <p className="text-gray-600">{data?.description}</p>
      <p className="font-semibold">{data?.price_dzd} DZD</p>
    </div>
  )
}
