import { get_me, getUserbyId, login, logout } from "@/lib/api/auth";
import { authRegsiter, User } from "@/lib/types/auth";
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