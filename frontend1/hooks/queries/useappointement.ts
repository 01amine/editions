import { keepPreviousData, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  createAppointment,
  getAppointmentsPaginated,
  getAppointmentById,
  deleteAppointmentById,
} from "@/lib/api/appointments";
import { getUserbyId } from "@/lib/api/auth";
import { AppointementGetResponseWithUser } from "@/lib/types/appointments";


export function useAppointmentById(id: string) {
  return useQuery({
    queryKey: ["appointment", id],
    queryFn: () => getAppointmentById(id),
    staleTime: 1000 * 60 * 5,
    retry: false,
    enabled: !!id, 
  });
}


export function useAppointmentsPaginated(skip = 0, limit = 10) {
  return useQuery({
    queryKey: ["appointments", skip, limit],
    queryFn: () => getAppointmentsPaginated(skip, limit),
     placeholderData: keepPreviousData,
    staleTime: 1000 * 60 * 5,
    retry: false,
  });
}

export function useGetAppointmentsWithUser(skip = 0, limit = 10) {
  return useQuery<AppointementGetResponseWithUser>({
    queryKey: ["appointments-with-user", skip, limit],
    queryFn: async () => {
      const appointments = await getAppointmentsPaginated(skip, limit);
      const enriched = await Promise.all(
        appointments.map(async (appt) => {
          const [student, admin] = await Promise.all([
            getUserbyId(appt.student.id),
            getUserbyId(appt.admin.id),
          ]);

          return {
            ...appt,
            student,
            admin,
          };
        })
      );

      return enriched;
    },
    placeholderData: keepPreviousData,
    staleTime: 1000 * 60 * 5,
    retry: false,
  });
}
export function useCreateAppointment() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: createAppointment,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["appointments"] });
    },
  });
}

export function useDeleteAppointment() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: deleteAppointmentById,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["appointments"] });
    },
  });
}
