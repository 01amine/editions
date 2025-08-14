import { API_ENDPOINTS } from "../const/endpoint";
import { AppointementGetResponses, appointmentsCreate } from "../types/appointments";
import client from "./clients";

export async function createAppointment(
    apointementData: appointmentsCreate
  ): Promise<void> {
    await client.post(API_ENDPOINTS.APPOINTMENTS.ROOT, apointementData);
  }


export async function getAppointmentsPaginated(
    skip: number = 0,
    limit: number = 10
  ): Promise<AppointementGetResponses> {
    const { data } = await client.get<AppointementGetResponses>(
      API_ENDPOINTS.APPOINTMENTS.ROOT,
      {
        params: { skip, limit },
      }
    );
    if (!data) {
      throw new Error("Failed to fetch appointments");
    }
    

    return data;
  }


export async function getAppointmentById(
    id: string
  ): Promise<AppointementGetResponses> {
    const { data } = await client.get<AppointementGetResponses>(
      API_ENDPOINTS.APPOINTMENTS.BY_ID(id)
    );
    return data;
  }
export async function deleteAppointmentById(
    id: string
  ): Promise<void> {
    await client.delete(API_ENDPOINTS.APPOINTMENTS.BY_ID(id));
  }



