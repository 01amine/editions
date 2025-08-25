import { API_ENDPOINTS } from "../const/endpoint";
import { NotificationApi } from "../types/notif";
import client from "./clients";

export async function getNotifications(): Promise<NotificationApi[]> {
    const { data } = await client.get<NotificationApi[]>(API_ENDPOINTS.NOTIF.ROOT);
    return data;
}