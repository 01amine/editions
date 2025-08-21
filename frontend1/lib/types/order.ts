import { Material } from "./material";

export  interface SerializedOrder {
  id: string;
  appointment_date: string;
  status: OrderStatus; 
  item: [Material, number][];
}

export type Orders = SerializedOrder[];

export enum OrderStatus {
    PENDING = "pending",
    PRINTING = "printing",
    READY = "ready",
    DELIVERED = "delivered"
}


export interface AdmindOrder {
  _id: string
  student: {
    full_name: string
    email: string
  }
  item: [
    {
      title: string
      material_type: string
      price_dzd: number
    },
    number 
  ][]
  status: "pending" | "printing" | "ready" | "delivered" 
  created_at: string
  appointment_date: string | null 
}
