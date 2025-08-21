import { API_ENDPOINTS } from "../const/endpoint";
import { AdmindOrder, Orders } from "../types/order";
import client from "./clients";

export async function get_order_per_student(
    studentId: string,
):Promise<Orders> {
    const { data } = await client.get<Orders>(API_ENDPOINTS.ORDERS.BY_ID(studentId));
    return data;
}


export async function get_order_by_admin():Promise<AdmindOrder[]> {
    const { data } = await client.get<AdmindOrder[]>(API_ENDPOINTS.ORDERS.GET_ADMIN_ORDERS);
    return data;
}