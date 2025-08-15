import { get_order_per_student } from "@/lib/api/order";
import { useQuery } from "@tanstack/react-query";

export  function getOrdersForStudent(
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
