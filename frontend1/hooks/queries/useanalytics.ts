import { GetANalytics } from "@/lib/api/analytics";
import { useQuery } from "@tanstack/react-query";

export function useAnalytics() {
    return useQuery({
        queryKey: ['analytics'],
        queryFn: () => GetANalytics(),
        staleTime: 100000 * 60 * 5,
        retry: false,
        
    });
}