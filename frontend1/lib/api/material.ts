import { API_ENDPOINTS } from "../const/endpoint";
import { MaterialsAdmin } from "../types/material";
import client from "./clients";

export async function getMaterials(limit : number = 10, skip : number = 0): Promise<MaterialsAdmin[]> {
    const { data } = await client.get<MaterialsAdmin[]>(API_ENDPOINTS.MATERIALS.ROOT, {
        params: { limit, skip },
    });
    if (!data) {
        throw new Error("No materials found");
    }
    return data;
   
}