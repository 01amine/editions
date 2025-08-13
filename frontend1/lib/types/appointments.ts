export interface appointmentsCreate {
  student_id: string;
  order_id: string;
  scheduled_at: string;
  location: string;
}
export interface AppointementGetResponse {
  _id: string;
  order: InAppointment;
  student: InAppointment;
  admin: InAppointment;
  scheduled_at: string;
  location: string;
  created_at: string;
}

interface InAppointment {
  id: string;
  collection: string;
}

export type AppointementGetResponses = AppointementGetResponse[];
