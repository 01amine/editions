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
export async  function  make_order_accepted(id : string): Promise<void> {
    await client.put(API_ENDPOINTS.ORDERS.ACCEPT_ORDER(id));
}

export async function make_order_rejected(id : string): Promise<void> {
    await client.put(API_ENDPOINTS.ORDERS.REJECT_ORDER(id));
}

export async function make_order_printed(id : string): Promise<void> {
    await client.put(API_ENDPOINTS.ORDERS.PRINT_ORDER(id));
}

