import { API_ENDPOINTS } from "../const/endpoint";
import { Orders } from "../types/order";
import client from "./clients";

export async function get_order_per_student(
    studentId: string,
):Promise<Orders> {
    const { data } = await client.get<Orders>(API_ENDPOINTS.ORDERS.BY_ID(studentId));
    return data;
}