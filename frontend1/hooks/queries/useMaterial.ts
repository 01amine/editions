import { createMaterial, deleteMaterialById, editMaterialById, getMaterialById, getMaterials } from "@/lib/api/material";
import { API_ENDPOINTS } from "@/lib/const/endpoint";
import { MaterialsAdmin,EditMaterialVars } from "@/lib/types/material";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useToast } from "../use-toast";

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

export  function useGetMaterialById(id:string){
    return useQuery<MaterialsAdmin>({
        queryKey: ["material", id],
        queryFn: () => getMaterialById(id),
        select: (data) => {
            const images =
              data.image_urls.length > 0
                ? data.image_urls.map(
                    (file) =>
                      `${process.env.NEXT_PUBLIC_API_URL}${API_ENDPOINTS.MATERIALS.GET_IMAGE(file)}`
                  )
                : ["/placeholder-lfrkp.png"]; 
            return {
              ...data,
              id: (data as any)._id ?? data.id,
              image_urls: images,
              pdf_url: `${process.env.NEXT_PUBLIC_API_URL}${API_ENDPOINTS.MATERIALS.GET_FILE(data.pdf_url)}`,
            };  
        },
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

export function useEditMaterial() {
  const queryClient = useQueryClient();

  return useMutation<void, Error, EditMaterialVars>({
    mutationFn: (vars) => editMaterialById(vars),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["materials"] });
    },
    onError: (error) => {
      console.error("Failed to update material:", error);
    },
  });
}

export function useCreateMaterial() {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: createMaterial,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["materials"] });
      toast({
        title: "Succès! ",
        description: "Le support a été ajouté avec succès.",
      });
    },
    onError: (error) => {
      console.error("Failed to create material:", error);
      toast({
        title: "Erreur! ",
        description: "Échec de l'ajout du support. Veuillez réessayer.",
        variant: "destructive",
      });
    },
  });
}