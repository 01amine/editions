import { getMaterials } from "@/lib/api/material";
import { MaterialsAdmin } from "@/lib/types/material";
import { useQuery } from "@tanstack/react-query";

export function useGetMaterials(limit: number = 10, skip: number = 0) {
  return useQuery<MaterialsAdmin[], Error>({
    queryKey: ["materials", limit, skip],
    queryFn: () => getMaterials(limit, skip),
    staleTime: 1000 * 60 * 5,
    retry: false,
  });
}