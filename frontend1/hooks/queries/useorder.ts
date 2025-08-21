import { get_order_by_admin, get_order_per_student } from "@/lib/api/order";
import { useQuery } from "@tanstack/react-query";

export  function useOrdersForStudent(
    studentId: string,
)
{
    return useQuery({
        queryKey: ['orders', studentId],
        queryFn: () => get_order_per_student(studentId),
        staleTime: 1000 * 60 * 5,
        retry: false,
        enabled: !!studentId,
    })
}

export function useOrdersForAdmin(){
    return useQuery({
        queryKey: ['orders'],
        queryFn: () => get_order_by_admin(),
        staleTime: 1000 * 60 * 5,
        retry: false,
    })
}