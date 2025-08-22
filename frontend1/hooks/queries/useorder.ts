import { get_order_by_admin, get_order_per_student, make_order_accepted, make_order_printed, make_order_rejected } from "@/lib/api/order";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

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

export function useMakeOrderAccepted() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (studentId: string) => make_order_accepted(studentId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["orders"] })
    },
  })
}

export function useMakeOrderprinted() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (studentId: string) => make_order_printed(studentId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["orders"] })
    },
  })
}

export function useMakeOrderrejected() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (studentId: string) => make_order_rejected(studentId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["orders"] })
    },
  })
}