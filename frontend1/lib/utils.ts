import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"
import { Orders, OrderStatus, SerializedOrder } from "./types/order";
import { get_me } from "./api/auth";
import { User } from "./types/auth";
import { cookies } from "next/headers";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}


export function summarizeOrder(order: SerializedOrder): string {
  const date = new Date(order.appointment_date).toLocaleDateString();
  const itemCount = order.item.reduce((sum, [, qty]) => sum + qty, 0);

  let statusLabel: string;
  switch (order.status) {
    case OrderStatus.PENDING:
      statusLabel = "Pending";
      break;
    case OrderStatus.PRINTING:
      statusLabel = "Printing";
      break;
    case OrderStatus.READY:
      statusLabel = "Ready";
      break;
    case OrderStatus.DELIVERED:
      statusLabel = "Delivered";
      break;
    default:
      statusLabel = order.status;
  }

  return `#${order.id.slice(-6)} | ${itemCount} items | ${date} | ${statusLabel}`;
}




export async function getSession(): Promise<User | null> {

  try {
    
    const user = await get_me();

    return user;
  } catch (err) {
    throw err;
    return null; 
  }
}