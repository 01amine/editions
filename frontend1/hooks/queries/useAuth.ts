import { get_me, getStudents, getUserbyId, login, logout } from "@/lib/api/auth";
import { authRegsiter, User } from "@/lib/types/auth";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { sk } from "date-fns/locale";


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
    });
}