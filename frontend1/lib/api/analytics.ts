import { API_ENDPOINTS } from "../const/endpoint";
import { DashboardAnalytics } from "../types/analytics";
import client from "./clients";

export async function GetANalytics(): Promise<DashboardAnalytics> {
    const { data } = await client.get<DashboardAnalytics>(API_ENDPOINTS.Dashboard.ROOT);
    return data;
}