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