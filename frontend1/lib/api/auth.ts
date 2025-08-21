import { API_ENDPOINTS } from "../const/endpoint";
import { AddAdmin, AllUser, authRegsiter, User, UserApiResponse } from "../types/auth";
import client from "../api/clients";

export async function login(payload :authRegsiter): Promise<void> {
    const {data} = await client.post(API_ENDPOINTS.AUTH.LOGIN, payload);
}
export async function get_me(): Promise<User> {
  const { data } = await client.get<UserApiResponse>(API_ENDPOINTS.AUTH.ME);

  const { specialite, study_year, created_at, hashed_password, roles, ...safeData } = data;

  return safeData;
}
export async function logout(): Promise<void> {
    await client.post(API_ENDPOINTS.AUTH.LOGOUT);
}

export async function getUserbyId(userId: string): Promise<UserApiResponse> {
    const { data } = await client.get<UserApiResponse>(API_ENDPOINTS.AUTH.GET_USER(userId));
    if (!data) {
        throw new Error("User not found");
    }
    return data;
}

export async function getStudents(skip: number = 0, limit: number = 10): Promise<User[]> {
    const { data } = await client.get<UserApiResponse[]>(API_ENDPOINTS.AUTH.ALL_STUDENTS, {
        params: { skip, limit },
    });
    if (!data) {
        throw new Error("No students found");
    }
    return data;
}

export async function getAllUsers(skip: number = 0, limit: number = 10): Promise<AllUser[]> {
    const { data } = await client.get<AllUser[]>(API_ENDPOINTS.AUTH.ALL_USERS, {
        params: { skip, limit },
    });
    if (!data) {
        throw new Error("No users found");
    }
    return data;
}

export async function addAdmin(userId: string, area :string): Promise<void> {
await client.post(API_ENDPOINTS.AUTH.ADD_ADMIN(userId), {
  placement: area,
})
}