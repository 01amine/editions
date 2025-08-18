import { deleteMaterialById, getMaterialById, getMaterials } from "@/lib/api/material";
import { API_ENDPOINTS } from "@/lib/const/endpoint";
import { MaterialsAdmin } from "@/lib/types/material";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

export function useGetMaterials(limit: number = 10, skip: number = 0) {
  return useQuery<MaterialsAdmin[], Error>({
    queryKey: ["materials", limit, skip],
    queryFn: () => getMaterials(limit, skip),
    staleTime: 1000 * 60 * 5,
    retry: false,
    select: (data) =>
      data.map((m) => {
        const images =
          m.image_urls.length > 0
            ? m.image_urls.map(
                (file) =>
                  `${process.env.NEXT_PUBLIC_API_URL}${API_ENDPOINTS.MATERIALS.GET_IMAGE(file)}`
              )
            : ["/placeholder-lfrkp.png"]; 

        return {
          ...m,
          id: (m as any)._id ?? m.id,
          image_urls: images,
          pdf_url: `${process.env.NEXT_PUBLIC_API_URL}${API_ENDPOINTS.MATERIALS.GET_FILE(m.pdf_url)}`,
        };
      }),
  });
}

export async function useGetMaterialById(id:string){
    return useQuery<MaterialsAdmin>({
        queryKey: ["material", id],
        queryFn: () => getMaterialById(id),
        staleTime: 1000 * 60 * 5,
        retry: false,
    })
}

export function useDeleteMaterial() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: string) => deleteMaterialById(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["materials"] });
    },
    onError: (error) => {
      console.error("Failed to delete material:", error);
    },
  });
}

