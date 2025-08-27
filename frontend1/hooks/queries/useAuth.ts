
import { addAdmin, block_user, get_me, get_user_by_name, getAllUsers, getStudents, getUserbyId, login, logout, removeAdmin, unblock_user } from "@/lib/api/auth";
import { AllUser, authRegsiter, User } from "@/lib/types/auth";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";


export function useCurrentUser(){
    return  useQuery<User>({
        queryKey: ['currentUser'],
        queryFn: get_me,
        staleTime: 1000 * 60 * 5,
        retry: false, 
    });
}

export function useIsAuthenticated() {
    const { data: user, isLoading } = useCurrentUser();
    return {
        isAuthenticated: !!user,
        user,
        isLoading,
    };
}

export function useLogout() {
    const queryClient = useQueryClient();
    return useMutation({
        mutationFn: logout,
        onSuccess: () => {
            queryClient.removeQueries({ queryKey: ['currentUser'] });
        },
    });
}

export function uselogin(){
     const queryclient = useQueryClient();
     return useMutation({
        mutationFn: (payload : authRegsiter) => login(payload),
        onSuccess: () => {
            queryclient.invalidateQueries({ queryKey: ['currentUser'] });
        },
        onError: (error) => {
            console.error("Login failed:", error);
        }
        
     })
}
export function GetUser(userId: string) {
    return useQuery<User>({
        queryKey: ['user', userId],
        queryFn: () => getUserbyId(userId),
        staleTime: 1000 * 60 * 5,
        retry: false,
        enabled: !!userId, 
    });
}

export function useGetStudents(skip = 0, limit = 10) {
    return useQuery<User[]>({
        queryKey: ['students'],
        queryFn: () => getStudents( skip, limit),
        staleTime: 1000 * 60 * 5,
        retry: false,
        refetchOnWindowFocus: false,
    });
}

export function useGetAllUsers(skip = 0, limit = 10) {
  return useQuery<AllUser[], Error>({
    queryKey: ['users', skip, limit],
    queryFn: () => getAllUsers(skip, limit),
    staleTime: 1000 * 60 * 5,
    retry: false,
    refetchOnWindowFocus: false,
  });
}

export function useAddAdmin() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: ({ userId, area }: { userId: string; area: string }) =>
      addAdmin(userId, area),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] })
    },
  })
}

export function useRemoveAdmin() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: (userId: string) => removeAdmin(userId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] })
    },
  })
}


export function useBlockUser() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: (userId: string) => block_user(userId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] })
    },
  })
}

export function useUnblockUser() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: (userId: string) => unblock_user(userId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] })
    },
  })
}


export function useGetByName(name: string) {
  return useQuery<User>({
    queryKey: ['users', name], // include name in the key for caching
    queryFn: () => get_user_by_name(name),
    enabled: !!name, // prevent query if name is empty
    staleTime: 1000 * 60 * 5,
    retry: false,
    refetchOnWindowFocus: false,
  });
}