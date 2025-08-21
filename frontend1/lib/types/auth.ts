export  interface authRegsiter {
    email : string;
    password : string;
}

export interface UserApiResponse {
  _id: string;
  email: string;
  hashed_password: string;
  isblocked: boolean;
  full_name: string;
  phone_number: string;
  study_year: string;
  specialite: string;
  roles: string[];
  created_at: string; 
}

export type User = Omit<
  UserApiResponse,
  "specialite" | "study_year" | "created_at" | "hashed_password" | "roles"
>;

export interface AllUser extends UserApiResponse {
  reset_code : string
  
}
export interface AddAdmin{
  era:string
}